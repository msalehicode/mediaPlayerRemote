#ifndef BTSOCKET_H
#define BTSOCKET_H

#include <QObject>
#include <QBluetoothSocket>
#include <QBluetoothServiceInfo>

#include <QTimer>

#include <QBluetoothDeviceDiscoveryAgent>

class BtSocket : public QObject
{
    Q_OBJECT
public:
    explicit BtSocket(QObject *parent = nullptr)
        : QObject{parent}
    {
        qInfo() << "creating bluetooth socket...";

    }
    ~BtSocket()
    {
        // delete m_socket;
        qInfo () << "destructor SOCKET.";
    }

    void init(QBluetoothDeviceInfo* chosenDevice)
    {
        m_device = chosenDevice;
        qInfo() << "Connecting to" << m_device->name()
        << m_device->address().toString();

        m_socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);



        connect(m_socket, &QBluetoothSocket::connected, this, &BtSocket::sConnected);
        connect(m_socket, &QBluetoothSocket::disconnected, this, &BtSocket::sDisconnected);
        connect(m_socket, &QBluetoothSocket::readyRead, this, &BtSocket::sDataReceived);
        qInfo() << "right before errorOccurSignal Slot";
        connect(m_socket, &QBluetoothSocket::errorOccurred, this, &BtSocket::sError);
        qInfo() << "after erroroccursingal slot";

        const QUuid serviceUuid("e8e10f95-1a70-4b27-9ccf-02010264e9c8");
        // e8e10f95-1a70-4b27-9ccf-02010264e9c8
        qInfo() << "Attempting to connect to service with UUID:" << serviceUuid.toString();

        m_socket->connectToService(m_device->address(), serviceUuid);


        // connect(m_socket, &QBluetoothSocket::connected, this, [this]()
        // {
        //     qDebug() << "Internal QBluetoothSocket connected! Emitting BtSocket::connected().";
        //     emit connected();
        // });

        // connect(m_socket, &QBluetoothSocket::disconnected, this, [this]()
        //         {
        //             emit disconnected();
        //         });

        // connect(m_socket, &QBluetoothSocket::readyRead, this, [this]()
        //         {
        //             emit messageReceived(m_socket->readAll());
        //         });

        // connect(m_socket, &QBluetoothSocket::errorOccurred, this, [this](QBluetoothSocket::SocketError err)
        //         {
        //             qInfo()<< "socket error occured:" << err;
        //             // emit error(errorToString(err));

        //             if(m_socket)
        //                 emit error(m_socket->errorString());
        //             else
        //                 qInfo() << "msocket is nullptr..";
        //         });

    }


signals:
    void connected();
    void disconnected();
    void messageReceived(QByteArray data);
    void error(QString errorDescription);


public slots:
    void sendMessage(QString text)
    {
        qInfo() << "socket sending message (" << text << ")";
        if (!m_socket)
        {
            qWarning() << "sendMessage: m_socket is null!";
            return;
        }

         //Crucial before send data. need string closer to determind where it ends. (\0)
        if(!text.endsWith("\n"))
            text+="\n";

        QByteArray msg = text.toUtf8();
        m_socket->write(msg);
    }

private slots:
    void sConnected()
    {
        // qInfo() << "socket Connected!";
        //send test message
        // QByteArray msg = "hello from qt btSocket\n";
            // m_socket->write(msg);


        emit connected();
    }
    void sDisconnected()
    {
        // qInfo () << "socket disconnected.";
        emit disconnected();
    }

    void sDataReceived()
    {
        QByteArray data = m_socket->readAll();
        // qInfo() << "socket Received:" << data;
        emit messageReceived(data);
    }

    void sError(QBluetoothSocket::SocketError err)
    {
        qInfo () << "error hanppend.";
        // qWarning() << "socket error:" << err;
        // qWarning() << "Error description:" << m_socket->errorString();
        emit error("erorr on socket");
    }

private:
    QBluetoothSocket* m_socket = nullptr;
    QBluetoothDeviceInfo* m_device = nullptr;

};



#endif // BTSOCKET_H
