#include "settingsmanager.h"


SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent)
{
    qDebug() << "Settings file location:" << m_settings.fileName();
    loadSettings();
}

SettingsManager::~SettingsManager()
{
    m_settings.sync(); // Explicit sync if needed
}

void SettingsManager::loadSettings()
{
    qDebug() << "Loading settings...";
    m_value.clear();

    // Default values if keys are not found
    if(!m_settings.contains("recentDevice/type")) m_settings.setValue("recentDevice/type","");
    if(!m_settings.contains("recentDevice/name")) m_settings.setValue("recentDevice/name","");
    if(!m_settings.contains("recentDevice/address")) m_settings.setValue("recentDevice/address","");



    // Default values if keys are not found
    m_value["recentDevice/type"] = m_settings.value("recentDevice/type","");
    m_value["recentDevice/name"] = m_settings.value("recentDevice/name","");
    m_value["recentDevice/address"] = m_settings.value("recentDevice/address","");

    // qDebug() << "Loaded settings map:" << m_value;
}

QVariantMap SettingsManager::value() const
{
    return m_value;
}

void SettingsManager::setValue(const QVariantMap &settings)
{
    m_value = settings;
}


void SettingsManager::setSetting(const QString &key, const QVariant &value)
{
    // qDebug() << "setsettings key" << key << "val=" << value ;
    if (!m_value.contains(key) || m_value.value(key) != value)
    {
        if (!key.isEmpty())
        {
            m_value[key] = value;
            m_settings.setValue(key, value);
            // m_settings.sync(); // for immediate write
            qDebug() << "Setting changed and saved:" << key << "=" << value << "to QSettings key" << key;
        }
        else
        {
            qDebug() << "Warning: No QSettings key mapping found for QML setting key:" << key;
            // Optionally, you could store it in QSettings under the same key if it's simple.
            // m_settings.setValue(key, value);
        }

        emit settingChanged(key);
        emit valueChanged();
    }
}

QVariant SettingsManager::getSetting(const QString &key, const QVariant &defaultValue) const
{
    if (m_value.contains(key))
    {
        return m_value.value(key);
    }
    return m_settings.value(key, defaultValue);
}
