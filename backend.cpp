#include "backend.h"

Backend::Backend(QGuiApplication* app, SettingsManager *settings, QObject *parent)
    : m_app(app),
    QObject{parent},
    m_btAgent{nullptr},
    m_currentAdapterIndex{0},
    m_socket{nullptr},
    m_settings(settings),
    m_localDevice(nullptr),
    m_netSocket(nullptr)
{

}

void Backend::processCommand(QByteArray data)
{
    QString payload;
    CommandHandler::Command cmd = m_command.unpack(data,payload);
    switch(cmd)
    {
        case CommandHandler::Command::VersionIsOutDated:
        case CommandHandler::Command::VersionNotProvided:
            emit showPopupMessage("update program your version is outdated");
            break;
        case CommandHandler::Command::Banned:
            emit showPopupMessage("you have been banned");
            break;
        case CommandHandler::Command::Kicked:
            emit showPopupMessage("you have been kicked");
            break;
        case CommandHandler::Command::ConnectionLost:
            emit showPopupMessage("connection lost, you might have been idle");
            break;
        case CommandHandler::Command::AlreadyConnected:
            emit showPopupMessage("your address already exists, run this app only once.");
            break;

        case CommandHandler::Command::EnterPassword:
            emit showPasswordDialog();
            break;
        case CommandHandler::Command::WrongPassword:
            emit wrongPassword();
            break;
        case CommandHandler::Command::AthenticatedFine:
            emit hidePasswordDialog();
            break;
        case CommandHandler::Command::MediaPlayerData: //initial data from server.
        {
            // qDebug() << "RAW MediaPlayerData-payload:" << payload;
            QList<QVariant> unpackedPayloads = m_command.unpackPayload(payload);

            if(unpackedPayloads.size() < CommandHandler::commandKeyMap.keys().count())
            {
                qDebug() <<"mediaPlayerData is not proper."
                         << "unpackedPayloads size:" << unpackedPayloads.size()
                         << " commandKeyMap count="<< CommandHandler::commandKeyMap.keys().count()
                         << " unpackedPayloads data="<< unpackedPayloads;


                emit showPopupMessage("Failed to load initial data\nTry again..");
                disconnectFromHost();
                return;
            }
            // else
                // qDebug() <<"mediaPlayerData is FINE,";

            //find command of that key and call QML slot to apply data to UI
            int index=0;
            for (const QString &key : CommandHandler::commandKeyMap.keys())
            {
                CommandHandler::Command command = CommandHandler::commandKeyMap.value(key);
                if(key=="1")//consists media metadata so need to unpackPayload
                {
                    QList<QVariant> unpackedPayload = m_command.unpackPayload(unpackedPayloads[index++].toString());
                    QString strPayload;
                    for(auto& v: unpackedPayload)
                        strPayload+="`"+v.toString();
                    qInfo() << "strPayload:" << strPayload;
                    emit remoteDataChanged(command, strPayload);
                }
                else
                    emit remoteDataChanged(command, unpackedPayloads[index++].toString());
            }
        }break;
        default: //undefined command, LATER avoid emitting.
            emit remoteDataChanged(cmd, payload);
    }
        qDebug() << "end of processCommand.";
}

QString Backend::getVersion() const
{
    //version and build macro from cmake
    QString result;
    result += QString::fromUtf8(APP_VERSION);
    result += " ";
    result += QString::fromUtf8(BUILD_DATE_TIME);
    return result;
}


void Backend::scan(bool status)
{
    //check permission and if its granted check device bluetooth status is ON?
    checkPermission();

    if(status)
    {
        qInfo() << "start scanning..";

        //clear old list
        m_devices.clear();
        emit devicesChanged();

        if(m_btStatus==BtStatus::PoweredOn) //we check if bluetooth is PoweredOn, becasuse if permission granted next stage is bt poweredOn
        {

            //when user is on connecting/connected stage is not allowed to scan.
            if(m_btStatus==BtStatus::Connected || m_btStatus==BtStatus::Connecting)
                return;

            setBtStatus(BtStatus::Scanning);

            // if(m_btAgent)
                // delete m_btAgent;

            m_btAgent = new BtAgent;

            connect(m_btAgent, &BtAgent::discoveryFinished,
                    this, &Backend::discoveryFinished);

            connect(m_btAgent, &BtAgent::discoveryCanceled,
                    this, &Backend::discoveryCanceled);

            connect(m_btAgent, &BtAgent::newDeviceFound,
                    this, &Backend::newDeviceFound);


            m_btAgent->startDiscovery();
            //then slot discoveryfinished will call by agent.

        }
        else
            qInfo() << "bluetooth power is off! cant scan!";

    }
    else
    {
        qInfo() << "stop scanning..";
        if(m_btAgent)
        {
            m_btAgent->stopDiscovery(); //will emit canceled/finished slots
        }

    }

}

void Backend::send(QString message)
{
    qInfo () << "seding message : " << message;
    emit sendMessage(message);
}

void Backend::send(CommandHandler::Command cmd, QString value)
{
    qInfo () << "seding data : " << cmd << "Val= " << value;
    emit sendData(m_command.pack(cmd,value));
}

void Backend::sendClientInfo()
{
    QList<QVariant> dataToPack;

    //obey ENUM's order (CommandHandler::ClientInfoIndexes)
    dataToPack << QString::fromUtf8(APP_VERSION_CODE);
    dataToPack << QSysInfo::machineHostName();
    dataToPack << QString::fromUtf8(APP_BUILD_PLATFORM);
    dataToPack << QString::fromUtf8(BUILD_DATE_TIME);
    dataToPack << getArchitecture();
    dataToPack << QSysInfo::prettyProductName();
    dataToPack << QSysInfo::kernelType();
    dataToPack << QSysInfo::kernelVersion();
    dataToPack << QSysInfo::currentCpuArchitecture();
    dataToPack << QSysInfo::buildAbi();
    dataToPack << QString::fromUtf8(APP_VERSION);
    // dataToPack << getPlatform(); //doesnt work proper, android and linux are not same! it return androids ->linux

    QString payload = m_command.packPayload(dataToPack);

    //send client info to server.such as app version, client system info...
    emit sendData(m_command.pack(CommandHandler::Command::ClientInfo,payload));
}


void Backend::connectToBluetoothHost(QString hostName)
{
    //stop discovery and check permission and bluetooth status
    scan(false);

    disconnectFromHost();


    QMap<QString, QBluetoothDeviceInfo>* deviceList = m_btAgent->getDevicesMap();
    if (deviceList->contains(hostName))
    {
        m_socket = new BtSocket;

        // QString firstKey = dev->firstKey();
        connectedDevice = deviceList->value(hostName);


        //save this device as recent
        m_settings->setSetting("recentDevice/type","bluetooth");
        m_settings->setSetting("recentDevice/name",hostName);
        m_settings->setSetting("recentDevice/address",connectedDevice.address().toString());
        setBtStatus(BtStatus::Connecting);

        m_socket->init(&connectedDevice);

        connect(m_socket, &BtSocket::connected,
                this , &Backend::connected);

        connect(m_socket, &BtSocket::disconnected,
                this , &Backend::disconnected);

        connect(m_socket, &BtSocket::messageReceived,
                this , &Backend::messageReceived);

        connect(m_socket, &BtSocket::error,
                this , &Backend::error);


        connect(this, QOverload<const QString &>::of(&Backend::sendMessage),
                m_socket, QOverload<const QString &>::of(&BtSocket::sendMessage));

        connect(this, QOverload<QByteArray>::of(&Backend::sendData),
                m_socket, QOverload<QByteArray>::of(&BtSocket::sendData));


    }
    else
    {
           qInfo() << "invalid hostName to connect. (" << hostName << ")";
           setBtStatus(BtStatus::Failed);
    }

}


void Backend::connectToBluetoothByAddress(QString name,QString address)
{
    //stop discovery and check permission and bluetooth status
    scan(false);

    disconnectFromHost();

    QBluetoothAddress addr(address.trimmed());
    if (addr.isNull()) {
        qWarning() << "Invalid Bluetooth address:" << address;
        setBtStatus(BtStatus::Failed);
        return;
    }

    //save this device as recent
    m_settings->setSetting("recentDevice/type","bluetooth");
    m_settings->setSetting("recentDevice/name",name);
    m_settings->setSetting("recentDevice/address",address);

    m_socket = new BtSocket;
    setBtStatus(BtStatus::Connecting);

    connectedDevice = QBluetoothDeviceInfo(
        addr,
        address,        // placeholder name
        0               // device class unknown
        );

    connectedDevice.setCoreConfigurations(
        QBluetoothDeviceInfo::BaseRateCoreConfiguration
        );

    QBluetoothUuid customUuid("e8e10f95-1a70-4b27-9ccf-02010264e9c8");
    connectedDevice.setServiceUuids({ customUuid });


    // init socket
    m_socket->init(&connectedDevice);

    connect(m_socket, &BtSocket::connected,
            this , &Backend::connected);

    connect(m_socket, &BtSocket::disconnected,
            this , &Backend::disconnected);

    connect(m_socket, &BtSocket::messageReceived,
            this , &Backend::messageReceived);

    connect(m_socket, &BtSocket::error,
            this , &Backend::error);

    connect(this, QOverload<const QString &>::of(&Backend::sendMessage),
            m_socket, QOverload<const QString &>::of(&BtSocket::sendMessage));

    connect(this, QOverload<QByteArray>::of(&Backend::sendData),
            m_socket, QOverload<QByteArray>::of(&BtSocket::sendData));

}

void Backend::reconnectToRecentDevice()
{
    QString deviceType = m_settings->getSetting("recentDevice/type","").toString();
    QString deviceName = m_settings->getSetting("recentDevice/name","").toString();
    QString deviceAddress = m_settings->getSetting("recentDevice/address","").toString();

    if(deviceType=="bluetooth")
    {
        //direct coonect tot that address.
        connectToBluetoothByAddress(deviceName,deviceAddress);
    }
    else if(deviceType=="network")
    {
        connectToNetworkByAddress(deviceName,deviceAddress);
    }
    else
        qInfo() << "reconnect type is neither blueooth nor network. its : " << deviceType; //later for wifi/network connection
}

void Backend::connectToNetworkByAddress(QString name, QString address)

{
    //separate ip and port
    QString ip= address.split(":").at(0);
    quint16 port= address.split(":").at(1).toUInt();

    //save this device as recent
    m_settings->setSetting("recentDevice/type","network");
    m_settings->setSetting("recentDevice/name",name);
    m_settings->setSetting("recentDevice/address",address);


    //make sure there is no connected connection.
    disconnectFromHost();


    //create socket and connection
    m_netSocket = new NtSocket(this);

    m_netSocket->connectToHost(ip,port);

    connect(m_netSocket, &NtSocket::connected,
            this , &Backend::connected);

    connect(m_netSocket, &NtSocket::disconnected,
            this , &Backend::disconnected);

    connect(m_netSocket, &NtSocket::messageReceived,
            this , &Backend::messageReceived);

    connect(m_netSocket, &NtSocket::error,
            this , &Backend::error);


    connect(this, QOverload<const QString &>::of(&Backend::sendMessage),
            m_netSocket, QOverload<const QString &>::of(&NtSocket::sendMessage));

    connect(this, QOverload<QByteArray>::of(&Backend::sendData),
            m_netSocket, QOverload<QByteArray>::of(&NtSocket::sendData));


}

void Backend::disconnectFromHost()
{
    if(m_settings->getSetting("recentDevice/type","") == "bluetooth" && m_socket)
    {
        qInfo()<<"backend disconnecting from bluetooth host...";
        m_socket->disconnectFromHost();
        // delete m_socket;
    }
    else if(m_settings->getSetting("recentDevice/type","") == "network" && m_netSocket)
    {
        qInfo()<<"backend disconnecting from network host...";
        m_netSocket->disconnectFromHost();
    }
    else
        qInfo()<<"unkown recentDevice/Type";
}


void Backend::checkPermission()
{
    //permission
    #if QT_CONFIG(permissions)
        QBluetoothPermission permission{};
        switch (m_app->checkPermission(permission))
        {
            case Qt::PermissionStatus::Undetermined:
            {
                qInfo()<<"undetermined askin permission..";
                setBtStatus(BtStatus::AskingPermission);
                m_app->requestPermission(permission, this, &Backend::checkPermission);
            }break;
            case Qt::PermissionStatus::Denied:
            {
                qInfo()<< "permission deinied..----------";
                setBtStatus(BtStatus::DeniedPermission);
                // m_app->quit();
            }break;

            case Qt::PermissionStatus::Granted:
            {
                qInfo()<<"permission is fine.";
                setBtStatus(BtStatus::GrantedPermission);

                //get latest localDevice. have to create new
                //to avoid old status e.g user's bluetooth is really ON but it reutnrs off! even hostModeStateChanged doesnt work correctly
                if(m_localDevice)
                {
                    delete m_localDevice;
                    disconnect(m_localDevice);
                    qInfo() << "deleting and disconnecting old localDevice to make new one.";
                }


                m_localDevice = new QBluetoothLocalDevice();
                connect(m_localDevice, &QBluetoothLocalDevice::hostModeStateChanged,
                        this, &Backend::onBluetoothStateChanged);

                isBluetoothOn();
            }break;
        }
    #endif // QT_CONFIG(permissions)

}

void Backend::isBluetoothOn()
{
    if(m_localDevice)
    {
        bool r = m_localDevice->hostMode()==QBluetoothLocalDevice::HostPoweredOff? true : false;
        qInfo()<<"bluetooth isBluetoothOFF?="  << r;

        setBtStatus(m_localDevice->hostMode()==QBluetoothLocalDevice::HostPoweredOff? BtStatus::PoweredOff : BtStatus::PoweredOn);
        QString res = (getBtStatus()==BtStatus::PoweredOff ? "OFF" :
                           getBtStatus()==BtStatus::PoweredOn ? "ON" : "other");
        qInfo() << "setBtStatus worked or not/ status=" << res;
    }
    else
        qInfo()<<"m_localDevice is not set yet";

}

void Backend::discoveryFinished()
{
    qInfo() <<"(backend) discovery finished.";
    setBtStatus(BtStatus::ScanningDone);


    qInfo() << "discovery finished, devices size=" << m_devices.size();
    // qInfo () << "mbtagent returned : " << m_btAgent->getDevices();
    // setDevices(m_btAgent->getDevices());
    // qInfo() << "devices size=" << m_devices.size();
}

void Backend::discoveryCanceled()
{
    setBtStatus(BtStatus::ScanningCanceled);
    qInfo() << "discovery canceled";
}
void Backend::newDeviceFound(QString key)
{
    setDevices(key);
}

void Backend::onBluetoothStateChanged(QBluetoothLocalDevice::HostMode state)
{
    qDebug() << QDateTime::currentDateTime().toString() <<" - Bluetooth device HostMode changed to:" << state;
    setBtStatus(state==QBluetoothLocalDevice::HostPoweredOff? BtStatus::PoweredOff : BtStatus::PoweredOn);
}


QString Backend::getArchitecture()
{
    #if defined(Q_PROCESSOR_X86_64)
        return "x86_64 (64-bit Intel/AMD)";
    #elif defined(Q_PROCESSOR_ARM)
        return "ARM (32-bit)";
    #elif defined(Q_PROCESSOR_ARM_64) // May also be Q_PROCESSOR_AARCH64
        return "ARM64 (64-bit ARM)";
    #elif defined(Q_PROCESSOR_X86)
        return "x86 (32-bit Intel/AMD)";
    #else
        return "architecture not specifically detected.";
    #endif
}


QString Backend::getPlatform()
{
    #ifdef Q_OS_WIN
        return "Windows";
    #elif defined(Q_OS_MAC) // Note: sometimes Q_OS_MACOS, sometimes Q_OS_MAC
        return "MacOs";
    #elif defined(Q_OS_LINUX)
        return "Linux";
    #elif defined(Q_OS_ANDROID)
        return "Android":
    #else
        return "unsupported Os";
    #endif
}


void Backend::connected()
{
    qDebug() << "backend: connected";
    setBtStatus(BtStatus::Connected);


    //send client's info to server such as app-version, device-name, device technical info..
    //server in response to this wil ask password
    //OR if password were not required will reply a inital status of latest status of mediaplayer to set to QML components
    sendClientInfo();
}


void Backend::disconnected()
{
    qDebug() << "backend: disconnected";
    setBtStatus(BtStatus::Disconnected);
}

void Backend::messageReceived(QByteArray data)
{
    //ping pong to server to determine clients ping every xSeconds
    if(data==CommandHandler::PING_DATA)
    {
        emit sendData(CommandHandler::PONG_DATA);
        return;
    }


    qInfo() << "backend: message received (data) = " << data;
    QString message =QString::fromUtf8(data);
    qInfo() << "backend: messagerecived:" << message;

    processCommand(data);
}

void Backend::error(QString errorDescription)
{
    qWarning() << "backend: erorr from bt socket" << errorDescription;
    setBtStatus(BtStatus::Failed);
}

QList<QString> Backend::devices() const
{
    return m_devices;
}

void Backend::setDevices(const QList<QString>& newDevices)
{
    if (m_devices == newDevices)
        return;
    m_devices = newDevices;
    emit devicesChanged();
}

void Backend::setDevices(QString newDevices)
{
    m_devices.append(newDevices);
    emit devicesChanged();
}



BtStatus Backend::getBtStatus() const
{
    return m_btStatus;
}


void Backend::setBtStatus(BtStatus newBtStatus)
{
    if (m_btStatus == newBtStatus)
        return;


    /*
     * to avoid override status
     * maybe user hit start scanning / stop scanning meanwhile clicked on
     * connect doesnt matter which one (direct connection / recentDevice / from found devices list)
     * connect functions will call scan(false) in result will do stopDiscovery and that would emit scanningCancel/Scanning Done
     * so we dont like this and ignore this new status to avoid override to show correct connected/connecting status
     */
    if((m_btStatus == BtStatus::Connecting || m_btStatus == BtStatus::Connected)
        && (newBtStatus == BtStatus::ScanningCanceled || newBtStatus == BtStatus::ScanningDone || newBtStatus == BtStatus::Scanning))
        return;


    m_btStatus = newBtStatus;

    emit btStatusChanged();
}
