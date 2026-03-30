#include "backend.h"

Backend::Backend(QGuiApplication* app, SettingsManager *settings, QObject *parent)
    : m_app(app),
    QObject{parent},
    m_btAgent{nullptr},
    m_currentAdapterIndex{0},
    m_socket{nullptr},
    m_btStatus(BtStatus::Unknown),
    m_settings(settings)
{
    // initData();


    connect(&m_localDevice, &QBluetoothLocalDevice::hostModeStateChanged,
            this, &Backend::onBluetoothStateChanged);


    //get initial bluetooth status
    setBluetoothIsOff(m_localDevice.hostMode()==QBluetoothLocalDevice::HostPoweredOff? true : false);

    //setBtStatus will scan this but on inital it may not set status bar correctly speacially when bluetoothIsOff==true
    updateStatusBarColor();
}

// void Backend::processCommand(CommandHandler::Command  cmd, const QString &value)
// {
//     switch(cmd)
//     {
//         case CommandHandler::Command::PlayToggle:
//         {
//             setData(cmd,value);
//         }

//         default:
//         {
//             qInfo() <<"undefined command.";
//         }
//     }
// }

QString Backend::targetDevice() const
{
    return m_targetDevice;
}

void Backend::setTargetDevice(const QString &newConnetedDevice)
{
    if (m_targetDevice == newConnetedDevice)
        return;
    m_targetDevice = newConnetedDevice;
    emit targetDeviceChanged();
}

void Backend::scan(bool status)
{
    if(status)
    {
        qInfo() << "starting..";
        m_devices.clear();
        checkPermission();
        if(m_btStatus==BtStatus::GrantedPermission)
        {
            setBtStatus(BtStatus::Scanning);
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
            qInfo() << "permission problem. cant proceed.";

    }
    else
    {
        qInfo() << "stopping..";
        if(m_btAgent)
        {
            m_btAgent->stopDiscovery();
            setBtStatus(BtStatus::ScanningCanceled);
        }

    }

}

void Backend::send(QString message)
{
    emit sendMessage(message);
}

// void Backend::send(CommandHandler::Command cmd, const QString& value)
// {
//     emit sendMessage(m_command.package(cmd,value));
// }



void Backend::connectToBluetoothHost(QString hostName)
{
    //stop discovery
    scan(false);

    QMap<QString, QBluetoothDeviceInfo>* deviceList = m_btAgent->getDevicesMap();
    if (deviceList->contains(hostName))
    {
        //make sure stop discovery



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

        connect(this, &Backend::sendMessage,
                m_socket , &BtSocket::sendMessage);

    }
    else
    {
           qInfo() << "invalid hostName to connect. (" << hostName << ")";
           setBtStatus(BtStatus::Failed);
    }

}


void Backend::connectToBluetoothByAddress(QString name,QString address)
{
    //stop discovery
    scan(false);

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

    connect(this, &Backend::sendMessage,
            m_socket , &BtSocket::sendMessage);
}

void Backend::reconnectToRecentDevice()
{
    QString deviceType = m_settings->getSetting("recentDevice/type","").toString();
    if(deviceType=="bluetooth")
    {
        QString deviceName = m_settings->getSetting("recentDevice/name","").toString();
        QString deviceAddress = m_settings->getSetting("recentDevice/address","").toString();

        if(m_btAgent)//if user did scan
        {
            QMap<QString, QBluetoothDeviceInfo>* deviceList = m_btAgent->getDevicesMap();
            if (deviceList->contains(deviceName))
                connectToBluetoothHost(deviceName);
        }
        else //device not found on scanned devices list (or user didnt hit scan button and direcotly clicked this
            //lets try direct connection to recent device
            connectToBluetoothByAddress(deviceName,deviceAddress);
    }
    else
        qInfo() << "reconnect type is not blueooth, its : " << deviceType; //later for wifi/network connection
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
                return;
            }
            case Qt::PermissionStatus::Denied:
            {
                qInfo()<< "permission deinied..----------";
                setBtStatus(BtStatus::DeniedPermission);
                // m_app->quit();
                return;
            }

            case Qt::PermissionStatus::Granted:
            {
                qInfo()<<"permission is fine.";
                setBtStatus(BtStatus::GrantedPermission);
                return;
            }
        }
    #endif // QT_CONFIG(permissions)

    setBtStatus(BtStatus::Failed);
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

    setBluetoothIsOff(state==QBluetoothLocalDevice::HostPoweredOff? true : false);
}

void Backend::connected()
{
    qInfo() << "backend: connected";
    setBtStatus(BtStatus::Connected);
}


void Backend::disconnected()
{
    qInfo() << "backend: disconnected";
    setBtStatus(BtStatus::Disconnected);
}

void Backend::messageReceived(QByteArray data)
{
    QString message =QString::fromUtf8(data);
    qInfo() << "backend: messagerecived:" << message;

    setReceivedMessage(message);

    // QString value;
    // CommandHandler::Command  cmd;
    // cmd = m_command.unpackage(&data, value);
    // processCommand(cmd,value);
}

void Backend::error(QString errorDescription)
{
    qWarning() << "backend: erorr from bt socket" << errorDescription;
    setBtStatus(BtStatus::Failed);
}

bool Backend::bluetoothIsOff() const
{
    return m_bluetoothIsOff;
}

void Backend::setBluetoothIsOff(bool newBluetoothIsOff)
{
    if (m_bluetoothIsOff == newBluetoothIsOff)
        return;
    m_bluetoothIsOff = newBluetoothIsOff;

    setBtStatus(m_bluetoothIsOff? BtStatus::PoweredOff : BtStatus::PoweredOn);
    emit bluetoothIsOffChanged();
}


// QVariantMap Backend::data() const
// {
//     return m_data;
// }

// void Backend::setData(CommandHandler::Command key, const QString &value)
// {
//     QString keystr = m_command.commandToString(key);
//     // QVariant keyVariant = QVariant::fromValue(key);
//     if (m_data.contains(keystr) && m_data.value(keystr) != value)
//     {
//         if (!keystr.isEmpty())
//         {
//             m_data[keystr] = value;
//             qDebug() << "data changed " << keystr << "=" << value;
//         }
//         else
//         {
//             qDebug() << "Warning data: no key mapping found for key:" << keystr;
//         }

//         emit dataChanged();
//     }
//     else
//         qInfo()<<"key not defined or value not changed.";
// }

// void Backend::initData()
// {
//     m_data[m_command.commandToString(CommandHandler::Command::PlayToggle)] = "0";
// }

QString Backend::receivedMessage() const
{
    return m_receivedMessage;
}

void Backend::setReceivedMessage(QString newReceivedMessage)
{
    m_receivedMessage.append(newReceivedMessage);
    emit receivedMessageChanged();
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


void Backend::updateStatusBarColor()
{
    switch(m_btStatus)
    {
    case BtStatus::Connected:
        m_androidControl.setStatusBarColor(0, 170, 0);//green
        break;

    case BtStatus::Connecting:
        m_androidControl.setStatusBarColor(179, 81, 0);//orange
        break;

    case BtStatus::PoweredOn:
    case BtStatus::Scanning:
    case BtStatus::ScanningDone:
    case BtStatus::ScanningCanceled:
    case BtStatus::GrantedPermission:
    case BtStatus::AskingPermission:
        m_androidControl.setStatusBarColor(170, 170, 0);//yellow
        break;

    case BtStatus::AdapterNotFound:
    case BtStatus::Disconnected:
    case BtStatus::Failed:
    case BtStatus::Unknown:
    case BtStatus::PoweredOff:
    case BtStatus::DeniedPermission:
        m_androidControl.setStatusBarColor(170, 0, 0);//red
        break;
    default:
        m_androidControl.setStatusBarColor(99, 0, 155);//purple
    }

}

void Backend::setBtStatus(BtStatus newBtStatus)
{
    if (m_btStatus == newBtStatus)
        return;


    m_btStatus = newBtStatus;

    //set color for statusBar
    updateStatusBarColor();

    emit btStatusChanged();
}
