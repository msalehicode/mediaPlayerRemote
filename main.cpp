#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend.h"
#include "settingsmanager.h"
#include "androidcontrol.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //reading these from cmake
    QCoreApplication::setOrganizationName(QString::fromUtf8(APP_ORGANIZATION));
    QCoreApplication::setApplicationName(QString::fromUtf8(APP_NAME));
    QCoreApplication::setApplicationVersion(QString::fromUtf8(APP_VERSION));


    QQmlApplicationEngine engine;

    AndroidControl androidControl;
    engine.rootContext()->setContextProperty("phoneControl", &androidControl);

    SettingsManager settings;
    engine.rootContext()->setContextProperty("settings", &settings);

    Backend backend(&app,&settings);
    engine.rootContext()->setContextProperty("backend", &backend);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("mediaPlayerRemote", "Main");

    //set starting status unkown to emit btStatusChanged then in qml will setStatusBarColor and app looks fine
    //it should set after qml loaded, because in main.qml we listen to signals btStatusChanged to change statusBarColors
    backend.setBtStatus(BtStatus::Unknown);

    return app.exec();
}
