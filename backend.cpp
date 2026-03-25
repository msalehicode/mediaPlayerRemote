#include "backend.h"

Backend::Backend(QGuiApplication* app,QObject *parent)
    : m_app(app),
    QObject{parent},
    m_btAgent{nullptr},
    m_currentAdapterIndex{0},
    m_socket{nullptr}
{

}

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

void Backend::run(bool status)
{
    if(status)
    {
        qInfo() << "starting..";
        checkPermission();
        if(m_btStatus==BtStatus::GrantedPermission)
        {
            setBtStatus(BtStatus::Scanning);
            m_devices.clear();
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
            m_btAgent->stopDiscovery();
    }

}

void Backend::send(QString message)
{
    emit sendMessage(message);
}

void Backend::connectToHost(QString hostName)
{
    QMap<QString, QBluetoothDeviceInfo>* deviceList = m_btAgent->getDevicesMap();
    if (deviceList->contains(hostName))
    {
        setBtStatus(BtStatus::Connecting);
        m_socket = new BtSocket;

        // QString firstKey = dev->firstKey();
        connectedDevice = deviceList->value(hostName);
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
    if(m_btStatus==BtStatus::Scanning) //till now user didnt choose any device
        setBtStatus(BtStatus::ScanningDone);


    qInfo() << "discovery finished, devices size=" << m_devices.size();
    // qInfo () << "mbtagent returned : " << m_btAgent->getDevices();
    // setDevices(m_btAgent->getDevices());
    // qInfo() << "devices size=" << m_devices.size();


    qInfo() << "wating user select a host..";
}

void Backend::discoveryCanceled()
{
    qInfo() << "-----------------discovery canceled";
    setBtStatus(BtStatus::ScanningCanceled);
}
void Backend::newDeviceFound(QString key)
{
    setDevices(key);
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
}

void Backend::error(QString errorDescription)
{
    qWarning() << "backend: erorr from bt socket" << errorDescription;
    setBtStatus(BtStatus::Failed);
}

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

void Backend::setBtStatus(BtStatus newBtStatus)
{
    if (m_btStatus == newBtStatus)
        return;
    m_btStatus = newBtStatus;
    emit btStatusChanged();
}
