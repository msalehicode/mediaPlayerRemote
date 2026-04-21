#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

#include <QGuiApplication>

#include "btagent.h" //to do discover nearby bluetooth devices


//it is curial
#if QT_CONFIG(permissions)
#include <QPermissions>
#endif

#include "btSocket.h" //bluetooth socket
#include "ntSocket.h" //network socket

#include <QBluetoothLocalDevice> //to get device bluetooth is off or on
#include <QDateTime>

#include "settingsmanager.h"

#include "commandhandler.h"

#include <QSysInfo> //to get system info and send to server as CLientInfo

enum class BtStatus
{
    Unknown=-1,

    AdapterNotFound=10, //later for feature select adapter
    Failed,


    DeniedPermission=20,
    AskingPermission,
    GrantedPermission,
    PoweredOff,
    PoweredOn,

    Disconnected=30,
    Scanning,
    ScanningCanceled,
    ScanningDone,
    Connecting,
    Connected
};



class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(BtStatus btStatus READ getBtStatus WRITE setBtStatus NOTIFY btStatusChanged FINAL)
    Q_PROPERTY(QList<QString> devices READ devices WRITE setDevices NOTIFY devicesChanged FINAL)

    // Q_PROPERTY(NOTIFY remoteDataChanged)

public:
    explicit Backend(QGuiApplication* app, SettingsManager* settings, QObject *parent = nullptr);

    void processCommand(QByteArray data); //process received command

    Q_INVOKABLE QString getVersion() const; //to show app version in UI

    //for both network and bluetooth
    Q_INVOKABLE void reconnectToRecentDevice();
    Q_INVOKABLE void disconnectFromHost();
    Q_INVOKABLE void send(QString message);
    Q_INVOKABLE void send(CommandHandler::Command cmd, QString value);
    void sendClientInfo();


    //network
    Q_INVOKABLE void connectToNetworkByAddress(QString name, QString address);

    //bluetooth
    Q_INVOKABLE void checkPermission();
    Q_INVOKABLE void isBluetoothOn();
    Q_INVOKABLE void scan(bool status);
    Q_INVOKABLE void connectToBluetoothHost(QString hostName);
    Q_INVOKABLE void connectToBluetoothByAddress(QString name, QString address);
    BtStatus getBtStatus() const;
    void setBtStatus(BtStatus newBtStatus);
    QList<QString> devices() const;
    void setDevices(const QList<QString> &newDevices);
    void setDevices(QString newDevices);




signals:
    void sendMessage(const QString& text);
    void sendData(QByteArray data);
    void receivedMessageChanged();


    //bluetooth
    void devicesChanged();
    void btStatusChanged();


    //password dialog
    void showPasswordDialog();
    void wrongPassword();
    void hidePasswordDialog();

    //to tell qml data received do things on his way
    void remoteDataChanged(CommandHandler::Command cmd, QString val);
    void showPopupMessage(QString message);

public slots:

    //bluetooth
    void discoveryFinished();
    void discoveryCanceled();
    void newDeviceFound(QString key);
    void onBluetoothStateChanged(QBluetoothLocalDevice::HostMode state);


    //emits by BtSocket
    void connected();
    void disconnected();
    void messageReceived(QByteArray data);
    void error(QString errorDescription);


private:
    //bluetooth
    const int m_currentAdapterIndex;
    BtStatus m_btStatus;
    BtAgent* m_btAgent;
    QList<QString> m_devices;
    QGuiApplication* m_app; //for bluetooth permission
    QBluetoothDeviceInfo connectedDevice;//to hold passing device to socket
    BtSocket* m_socket;
    QBluetoothLocalDevice* m_localDevice; //get blueooth state is on/off..


    //network
    NtSocket* m_netSocket;


    //--
    CommandHandler m_command;
    SettingsManager* m_settings;
    QString getPlatform();
    QString getArchitecture();
};

#endif // BACKEND_H
