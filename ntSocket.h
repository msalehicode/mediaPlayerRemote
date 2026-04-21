#ifndef NTSOCKET_H
#define NTSOCKET_H

#include <QObject>

#include <QTimer>
#include <QTcpSocket>

class NtSocket : public QObject
{
    Q_OBJECT
public:
    explicit NtSocket(QObject *parent = nullptr)
        : QObject{parent}, m_socket(nullptr)
    {
        qInfo() << "creating network tcp socket...";
    }
    ~NtSocket()
    {
        qInfo () << "destructor SOCKET.";
    }

    void disconnectFromHost()
    {
        if(m_socket)
            m_socket->disconnectFromHost();
    }

    void connectToHost(const QString& ip, quint16 port)
    {
        qInfo() << "tcp socket: connecting to host (" << ip << "):" << port;


        if (m_socket==nullptr)
            m_socket = new QTcpSocket(this);
        else
        {
            qInfo()<< "socket is not nullptr";
            return;
        }

        if(m_socket)
        {
            m_socket->connectToHost(ip,port);

            connect(m_socket, &QTcpSocket::connected, this, &NtSocket::onConnected);
            connect(m_socket, &QTcpSocket::disconnected, this, &NtSocket::onDisconnected);
            connect(m_socket, &QTcpSocket::readyRead, this, &NtSocket::onDataReceived);
            connect(m_socket, &QTcpSocket::errorOccurred, this, &NtSocket::onError);
        }
        else
            qInfo() << "failed m_socket is null..";

    }


signals:
    void connected();
    void disconnected();
    void messageReceived(QByteArray data);
    void error(QString errorDescription);


public slots:

    void sendMessage(const QString& text)
    {
        qDebug() << "socket sending message (" << text << ")";
        if (!m_socket)
        {
            qWarning() << "sendMessage: m_socket is null!";
            return;
        }

        //Crucial before send data. need string closer to determind where it ends. (\0)
        if(!text.endsWith("\n"))
        {
            QString newText = text+"\n";
            QByteArray msg = newText.toUtf8();
            m_socket->write(msg);
            return;
        }

        QByteArray msg = text.toUtf8();
        m_socket->write(msg);
    }

    void sendData(QByteArray data)
    {
        qDebug() << "socket: sending QByteArray data=(" << data << ")";
        if (!m_socket)
        {
            qWarning() << "sendMessage: m_socket is null!";
            return;
        }

        // --- Check connection state ---
        if (m_socket->state() != QTcpSocket::SocketState::ConnectedState)
        {
            qWarning() << "sendMessage: Socket is not connected. Cannot send message.";
            return;
        }
        // else
            // qDebug() << "socket state:" <<m_socket->state();


        if (!data.endsWith('\n') || !data.endsWith("\r\n"))
            data += '\n'; // Append newline if not present

        m_socket->write(data);
    }

private slots:
    void onConnected()
    {
        qInfo() << "socket connected";
        emit connected();
    }
    void onDisconnected()
    {
        qInfo() << "socket disconnected";
        emit disconnected();
    }

    void onDataReceived()
    {
        QByteArray data = m_socket->readAll();
        qDebug() << "socket data recevied" << data;
        emit messageReceived(data);
    }

    void onError(QTcpSocket::SocketError err)
    {
        qCritical() << "error hanppend. error=" << err;
        qWarning() << "Error description:" << m_socket->errorString();
        emit error(m_socket->errorString());
    }

private:
    QTcpSocket* m_socket = nullptr;

};



#endif // NTSOCKET_H
