// settingsmanager.h
#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(const QString& ,QObject *parent = nullptr);
    ~Settings();

    Q_INVOKABLE void setValue(const QString &path, const QVariant &value);
    Q_INVOKABLE QVariant getValue(const QString &path, const QVariant &defaultValue = QVariant()) const;

    Q_INVOKABLE bool saveSettings(const QString &filePath);
    Q_INVOKABLE bool loadSettings(const QString &filePath);

    Q_INVOKABLE void writeSettingsToFile();
    Q_INVOKABLE void readSettingsFromFile();

signals:
    void valueNotFound(const QString &warning);

public slots:



private:
    QJsonObject settingsObject;



    QString settingsFilePath;


};


inline Settings::Settings(const QString &programPath, QObject *parent)
    : QObject(parent), settingsFilePath(programPath + "/settings.json")
{

}

inline Settings::~Settings()
{

}

inline void Settings::setValue(const QString &path, const QVariant &value)
{
    QStringList pathComponents = path.split("/");

    QVector<QJsonObject> valuesUpToPath{settingsObject};

    // Ensure the path up to the last value exists,
    for (int i = 0; i < pathComponents.size() - 1; i++)
    {
        QString const &currentKey = pathComponents[i];

        if (!valuesUpToPath.last().contains(currentKey))
        {
            valuesUpToPath.last()[currentKey] = QJsonObject();
        }

        valuesUpToPath.push_back(valuesUpToPath.last()[currentKey].toObject());
    }

    // Set the last item's key = value
    valuesUpToPath.last()[pathComponents.last()] = QJsonValue::fromVariant(value);

    // Now merge all the items back into one
    QJsonObject result = valuesUpToPath.takeLast();

    while (valuesUpToPath.size() > 0)
    {
        QJsonObject parent = valuesUpToPath.takeLast();
        parent[pathComponents[valuesUpToPath.size()]] = result;
        result = parent;
    }

    settingsObject = result;
}

inline QVariant Settings::getValue(const QString &path, const QVariant &defaultValue) const
{
    QVariant result = defaultValue;

    QStringList pathComponents = path.split("/");
    QJsonObject parentObject = settingsObject;

    while (pathComponents.size() > 0)
    {
        QString const &currentKey = pathComponents.takeFirst();

        if (parentObject.contains(currentKey))
        {
            if (pathComponents.size() == 0)
            {
                result = parentObject.value(currentKey);
            }
            else
            {
                parentObject = parentObject.value(currentKey).toObject();
            }
        }
        else
        {
            QString warn = QStringLiteral("Settings could not access unknown key ") + currentKey + QStringLiteral(" in ") + QString::fromUtf8(QJsonDocument(parentObject).toJson());
            qWarning() << qPrintable(warn);
            return NULL;
            //break;
        }
    }

    return result;
}

inline bool Settings::saveSettings(const QString &filePath)
{
    if (!filePath.isEmpty()) {
        settingsFilePath = filePath;
    }

    writeSettingsToFile();
    return true; // You may want to add error handling logic here
}

inline bool Settings::loadSettings(const QString &filePath)
{
    if (!filePath.isEmpty()) {
        settingsFilePath = filePath;
    }

    readSettingsFromFile();
    return true; // You may want to add error handling logic here
}

inline void Settings::writeSettingsToFile()
{
    QFile file(settingsFilePath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument jsonDoc(settingsObject);
        file.write(jsonDoc.toJson());
        file.close();
    }
}

inline void Settings::readSettingsFromFile()
{
    QFile file(settingsFilePath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray jsonData = file.readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData);
        settingsObject = jsonDoc.object();
        file.close();
    }
}


#endif // SETTINGSMANAGER_H
