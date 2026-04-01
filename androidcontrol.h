#ifndef ANDROIDCONTROL_H
#define ANDROIDCONTROL_H

#include <QObject>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QDebug>
#endif

class AndroidControl : public QObject
{
    Q_OBJECT
public:
    explicit AndroidControl(QObject *parent = nullptr);

    Q_INVOKABLE void setStatusBarColor(const QString& hexColor);
    Q_INVOKABLE void setStatusBarColor(int r, int g, int b);
    void setNavigationBarColor(int r, int g, int b);
    void hideNavigationBar();

signals:
};

#endif // ANDROIDCONTROL_H
