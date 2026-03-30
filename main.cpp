#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend.h"
#include "settingsmanager.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QGuiApplication::setApplicationName("MediaPlayer Remote");
    QGuiApplication::setOrganizationName("QtProject");

    QQmlApplicationEngine engine;


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

    return app.exec();
}
