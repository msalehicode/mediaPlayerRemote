#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

#include <QGuiApplication>

#include "btagent.h"



#if QT_CONFIG(permissions)
// #include <QCoreApplication>
#include <QPermissions>
#endif

enum class BtStatus
{
    Unknown=-1,

    AdapterNotFound=10, //later for feature select adapter
    Failed,


    DeniedPermission=20,
    AskingPermission,
    GrantedPermission,


    Disconnected=30,
    Scanning,
    ScanningCanceled,
    ScanningDone,
    Connecting,
    Connected
};


#include "btSocket.h"

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString targetDevice READ targetDevice WRITE setTargetDevice NOTIFY targetDeviceChanged)
    Q_PROPERTY(BtStatus btStatus READ getBtStatus WRITE setBtStatus NOTIFY btStatusChanged FINAL)
    Q_PROPERTY(QList<QString> devices READ devices WRITE setDevices NOTIFY devicesChanged FINAL)
    Q_PROPERTY(QString receivedMessage READ receivedMessage WRITE setReceivedMessage NOTIFY receivedMessageChanged FINAL)


public:
    explicit Backend(QGuiApplication* app,QObject *parent = nullptr);


    QString targetDevice() const;
    void setTargetDevice(const QString &newtargetDevice);


    BtStatus getBtStatus() const;
    void setBtStatus(BtStatus newBtStatus);

    Q_INVOKABLE void run(bool status);
    Q_INVOKABLE void send(QString message);
    Q_INVOKABLE void connectToHost(QString hostName);

    void checkPermission();
    QList<QString> devices() const;
    void setDevices(const QList<QString> &newDevices);
    void setDevices(QString newDevices);

    QString receivedMessage() const;
    void setReceivedMessage(QString newReceivedMessage);

signals:

    void sendMessage(QString text);


    void targetDeviceChanged();
    void btStatusChanged();


    void devicesChanged();

    void receivedMessageChanged();

public slots:
    void discoveryFinished();
    void discoveryCanceled();
    void newDeviceFound(QString key);



    //emits by BtSocket
    void connected();
    void disconnected();
    void messageReceived(QByteArray data);
    void error(QString errorDescription);


private:
    const int m_currentAdapterIndex;
    QString m_targetDevice;
    BtStatus m_btStatus = BtStatus::Unknown;
    BtAgent* m_btAgent;


    QString m_receivedMessage;
    QList<QString> m_devices;

    QGuiApplication* m_app; //for bluetooth permission

    QBluetoothDeviceInfo connectedDevice;//to hold passing device to socket

    BtSocket* m_socket;
};

#endif // BACKEND_H
