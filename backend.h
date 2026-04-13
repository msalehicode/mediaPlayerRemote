#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

#include <QGuiApplication>

#include "btagent.h"

// #include "commandhandler.h"

#if QT_CONFIG(permissions)
// #include <QCoreApplication>
#include <QPermissions>
#endif

#include "btSocket.h" //bluetooth socket
#include "ntSocket.h" //network socket

#include <QBluetoothLocalDevice> //to get device bluetooth is off or on
#include <QDateTime>

#include "settingsmanager.h"

#include "commandhandler.h"

#include <QSysInfo>

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

    Q_PROPERTY(QString targetDevice READ targetDevice WRITE setTargetDevice NOTIFY targetDeviceChanged)
    Q_PROPERTY(BtStatus btStatus READ getBtStatus WRITE setBtStatus NOTIFY btStatusChanged FINAL)
    Q_PROPERTY(QList<QString> devices READ devices WRITE setDevices NOTIFY devicesChanged FINAL)
    Q_PROPERTY(QString receivedMessage READ receivedMessage WRITE setReceivedMessage NOTIFY receivedMessageChanged FINAL)
    // Q_PROPERTY(QVariantMap data READ data NOTIFY dataChanged)


public:
    explicit Backend(QGuiApplication* app, SettingsManager* settings, QObject *parent = nullptr);



    void processCommand(QByteArray data);



    QString targetDevice() const;
    void setTargetDevice(const QString &newtargetDevice);


    BtStatus getBtStatus() const;
    void setBtStatus(BtStatus newBtStatus);

    Q_INVOKABLE void scan(bool status);
    Q_INVOKABLE void send(QString message);
    Q_INVOKABLE void send(CommandHandler::Command cmd, QString value);

    Q_INVOKABLE void connectToBluetoothHost(QString hostName);

    Q_INVOKABLE void connectToBluetoothByAddress(QString name, QString address);
    Q_INVOKABLE void reconnectToRecentDevice();

    Q_INVOKABLE void connectToNetworkByAddress(QString name, QString address);

    Q_INVOKABLE QString getVersion();

    Q_INVOKABLE void disconnectFromHost();

    Q_INVOKABLE void checkPermission();
    Q_INVOKABLE void isBluetoothOn();

    QList<QString> devices() const;
    void setDevices(const QList<QString> &newDevices);
    void setDevices(QString newDevices);

    QString receivedMessage() const;
    void setReceivedMessage(QString newReceivedMessage);


    void updateStatusBarColor();

    // QVariantMap data() const;
    // Q_INVOKABLE void setData(CommandHandler::Command key, const QString &value);
    // void initData();


signals:

    // void dataChanged();


    void sendMessage(const QString& text);
    void sendData(QByteArray data);


    void targetDeviceChanged();
    void btStatusChanged();


    void devicesChanged();

    void receivedMessageChanged();

    void showPasswordDialog();
    void wrongPassword();
    void hidePasswordDialog();

public slots:
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
    QString getPlatform();
    QString getArchitecture();

    const int m_currentAdapterIndex;
    QString m_targetDevice;
    BtStatus m_btStatus;
    BtAgent* m_btAgent;

    QString m_receivedMessage;
    QList<QString> m_devices;

    QGuiApplication* m_app; //for bluetooth permission

    QBluetoothDeviceInfo connectedDevice;//to hold passing device to socket

    BtSocket* m_socket;
    CommandHandler m_command;

    NtSocket* m_netSocket;
    // QVariantMap m_data;//store remote control data

    SettingsManager* m_settings;

    QBluetoothLocalDevice* m_localDevice; //get blueooth state is on/off..
};

#endif // BACKEND_H
