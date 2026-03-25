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
    void deviceFound(const QBluetoothDeviceInfo &info)
    {
        QString name = info.name();
        QString addr = info.address().toString();

        qInfo () << "device found:";
        if (name.isEmpty())
        {
            qInfo()<<"device name is empty set address as key! (" << name << ") @:" << "[" << addr  << "]";
            m_devices[addr] = info;
            emit newDeviceFound(addr);
        }
        else
        {
            m_devices[name] = info;
            qInfo() << "Found:" << name << "@" << addr;
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

private:
    QBluetoothDeviceDiscoveryAgent* m_agent;
    QMap<QString, QBluetoothDeviceInfo> m_devices;

    // QList<QBluetoothHostInfo> localAdapters;
};

#endif // BTAGENT_H
