#ifndef BTAGENT_H
#define BTAGENT_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothAddress>
// #include <QTextStream>


class BtAgent : public QObject
{
    Q_OBJECT
public:
    explicit BtAgent(QObject *parent = nullptr)
        : QObject{parent},
        m_agent(new QBluetoothDeviceDiscoveryAgent(this))

    {
        connect(m_agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
                this, &BtAgent::deviceFound);

        connect(m_agent, &QBluetoothDeviceDiscoveryAgent::finished,
                this, &BtAgent::scanFinished);

        connect(m_agent, &QBluetoothDeviceDiscoveryAgent::canceled,
                this, &BtAgent::scanCanceled);



    }
    ~BtAgent()
    {
        qInfo () << "BtAgent destructor";
        // delete m_agent;
    }


    void startDiscovery()
    {
        qInfo() << "Starting discovery...";
        m_devices.clear();
        m_agent->start();
    }
    void stopDiscovery()
    {
        qInfo() << "stopping discovery..";
        m_agent->stop();
    }

    QList<QString> getDevices()
    {
        QList<QString> list;
        QString res;
        qInfo () << "----------- disocvered devices:" << m_devices.size();

        for (const QString &address : m_devices.keys())
        {
            const QBluetoothDeviceInfo &deviceInfo = m_devices.value(address);


            res = address; // + "("+deviceInfo.name()+")";
            // res =  deviceInfo.name();
            // res +=  " Address:" + address;
            // res += "\n";
            qInfo() << "dev info:" << res;
            list.append(res);
        }


        return list;
    }

    QMap<QString, QBluetoothDeviceInfo>* getDevicesMap()
    {
        return &m_devices;
    }


private slots:

    QString getDeviceType(const QBluetoothDeviceInfo &device)
    {
        quint32 cod = device.majorDeviceClass();
        qInfo() << "major device class?" << cod;
        quint8 major = (cod >> 8) & 0xFF;      // Major Device Class
        quint8 minor = (cod >> 2) & 0x3F;     // Minor Device Class
        // quint8 service = cod >> 14;       // Major Service Class (not directly used here for simplicity)

        QString typeString;

        switch (major) {
        case QBluetoothDeviceInfo::MajorDeviceClass::ComputerDevice:
            switch (minor) {
            // case QBluetoothDeviceInfo::MajorDeviceClass: typeString = "Desktop Computer"; break;
            // case QBluetoothDeviceInfo::ComputerMinorDeviceClass::Laptop: typeString = "Laptop"; break;
            // case QBluetoothDeviceInfo::ComputerMinorDeviceClass::HandheldPC: typeString = "Handheld PC/PDA"; break;
            // case QBluetoothDeviceInfo::ComputerMinorDeviceClass::Wearable: typeString = "Wearable Computer"; break;
            default: typeString = "Computer"; break;
            }
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::PhoneDevice:
            switch (minor) {
            // case QBluetoothDeviceInfo::PhoneMinorDeviceClass::Cellular: typeString = "Cellular Phone"; break;
            // case QBluetoothDeviceInfo::PhoneMinorDeviceClass::Cordless: typeString = "Cordless Phone"; break;
            // case QBluetoothDeviceInfo::PhoneMinorDeviceClass::Smartphone: typeString = "Smartphone"; break;
            default: typeString = "Phone"; break;
            }
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::AudioVideoDevice:
            switch (minor) {
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::WearableHeadset: typeString = "Wearable Headset"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::HandsFree: typeString = "Hands-free Device"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::Microphone: typeString = "Microphone"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::Loudspeaker: typeString = "Loudspeaker"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::Headphones: typeString = "Headphones"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::PortableAudioPlayer: typeString = "Portable Audio Player"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::SetTopBox: typeString = "Set-top Box"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::HiFiAudio: typeString = "HiFi Audio System"; break;
            // case QBluetoothDeviceInfo::AudioVideoMinorDeviceClass::Soundbar: typeString = "Soundbar"; break;
            default: typeString = "Audio/Video Device"; break;
            }
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::PeripheralDevice:
            switch (minor) {
            // case QBluetoothDeviceInfo::PeripheralMinorDeviceClass::Keyboard: typeString = "Keyboard"; break;
            // case QBluetoothDeviceInfo::PeripheralMinorDeviceClass::PointingDevice: typeString = "Pointing Device (Mouse)"; break;
            // case QBluetoothDeviceInfo::PeripheralMinorDeviceClass::Combo: typeString = "Keyboard/Mouse Combo"; break;
            // Other peripheral types...
            default: typeString = "Peripheral"; break;
            }
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::ImagingDevice:
            typeString = "Imaging Device"; break;
        case QBluetoothDeviceInfo::MajorDeviceClass::WearableDevice:
            typeString = "Wearable Device"; break;
        case QBluetoothDeviceInfo::MajorDeviceClass::ToyDevice:
            typeString = "Toy"; break;
        case QBluetoothDeviceInfo::MajorDeviceClass::HealthDevice:
            typeString = "Health Device"; break;
        case QBluetoothDeviceInfo::MajorDeviceClass::UncategorizedDevice:
        default:
            typeString = "Unknown Device maj:" + QString::number(major) + " min:"+ QString::number(minor);
            break;
        }

        // Append Service Class if it adds meaningful info (optional)
        // quint8 service = cod >> 14;
        // if (service == QBluetoothDeviceInfo::ServiceClass::Audio) typeString += " (Audio)";
        // else if (service == QBluetoothDeviceInfo::ServiceClass::Networking) typeString += " (Networking)";
        // ... etc.

        return typeString;
    }


    void deviceFound(const QBluetoothDeviceInfo &info)
    {
        QString name = info.name();
        QString addr = info.address().toString();

        quint32 cod=info.majorDeviceClass();

        QString deviceType = getDeviceType(info);

        qInfo () << "device found:";
        if (name.isEmpty())
        {
            qInfo()<<"device name is empty set address as key! (" << name << ") @:" << "[" << addr  << "] " << " T:" << deviceType;
            m_devices[addr] = info;
            emit newDeviceFound(addr);
        }
        else
        {
            m_devices[name] = info;
            qInfo() << "Found:" << name << "@" << addr << " T:" << deviceType;
            emit newDeviceFound(name);
        }
    }

    void scanFinished()
    {
        qInfo() << "Discovery finished.";
        emit discoveryFinished();
        // qInfo() << "Enter device NAME to connect:";

        // QTextStream cin(stdin);
        // QString chosen = cin.readLine().trimmed();

        // if (!m_devices.contains(chosen))
        // {
        //     qWarning() << "Device not found!";
        //     // QCoreApplication::quit();
        //     return;
        // }


        //socket

        // m_socket->init(&m_devices[chosen]);
    }
    void scanCanceled()
    {
        emit discoveryCanceled();
    }

signals:
    void discoveryFinished();
    void discoveryCanceled();
    void newDeviceFound(QString key);

    void onBtStateChanged(bool newStatus);

private:
    QBluetoothDeviceDiscoveryAgent* m_agent;
    QMap<QString, QBluetoothDeviceInfo> m_devices;

    // QList<QBluetoothHostInfo> localAdapters;
};





#endif // BTAGENT_H
