// telegrambot.h
#ifndef TELEGRAMBOT_H
#define TELEGRAMBOT_H

#include <QCoreApplication>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>
#include <QUrlQuery>
#include <QTimer>
#include <QFile>

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

class TelegramBot : public QObject
{
    Q_OBJECT

public:
    //poling
    explicit TelegramBot(const QString& token, int interval,  QObject *parent = nullptr);
    explicit TelegramBot(QObject *parent = nullptr); //constructor with default params


public slots:

    void sendMessage(const QString& chatId, const QString& text);

    void sendGroupMessage(const QString& text);
	
    void processMessage(const QString& chatId, const QString& text);
	
    void startListening();

private slots:

    void onNetworkReply(QNetworkReply* reply);

private:

    void processUpdates(const QJsonArray &updates);

    QString programPath;

    QString botToken;
	
    QString webhookUrl;
	
    QString botName = "@ThermalCalibrationBot";

    QString lastUpdateId;

    QTimer pollTimer;
    int pollingInterval;

    QNetworkAccessManager networkManager;

};


inline TelegramBot::TelegramBot(const QString &token, int interval, QObject *parent)
    : QObject(parent), botToken(token), pollingInterval(interval)
{    
    programPath = QCoreApplication::applicationDirPath();

    connect(&networkManager, &QNetworkAccessManager::finished, this, &TelegramBot::onNetworkReply);

    // Set up timer for regular polling
    connect(&pollTimer, &QTimer::timeout, this, &TelegramBot::startListening);

    pollTimer.start(pollingInterval);
}

inline TelegramBot::TelegramBot(QObject *parent)
{
    //this constructor search token if telegram folder where app placed
    programPath = QCoreApplication::applicationDirPath();
    QFile tokenFile(programPath + "/telegram/token.txt");
    QString tokenFromFile;

    if (tokenFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&tokenFile);
        tokenFromFile = in.readAll();
        tokenFile.close();

        connect(&networkManager, &QNetworkAccessManager::finished, this, &TelegramBot::onNetworkReply);

        botToken = tokenFromFile;
        pollingInterval = 3000;

        pollTimer.start(pollingInterval);
    } else {
        qDebug() << "Error of open file token.txt";
    }


}


inline void TelegramBot::sendMessage(const QString &chatId, const QString &text)
{
    QString apiUrl = "https://api.telegram.org/bot" + botToken + "/sendMessage";
    QUrl url(apiUrl);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QUrlQuery query;
    query.addQueryItem("chat_id", chatId);
    query.addQueryItem("text", text);

    // POST requesr
    QNetworkReply* reply = networkManager.post(request, query.toString(QUrl::FullyEncoded).toUtf8());

    // Answer process
    connect(reply, &QNetworkReply::finished, this, [reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug() << "Message succsesfuly send!";
        } else {
            qDebug() << "Send message error:" << reply->errorString();
        }

        // Clear resources
        reply->deleteLater();
    });

}

inline void TelegramBot::sendGroupMessage(const QString &text)
{
    //send message to group of users, id stored in telegram folder in txt file
    QFile groupListFile(programPath + "/telegram/groupList.txt");
    QStringList groupList;

    if (groupListFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&groupListFile);
        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (!line.isEmpty()) {
                groupList.append(line);
            }
        }
        groupListFile.close();
    } else {
        qDebug() << "Error of open file groupList.txt";
        return;
    }

    for (const QString &chatId : groupList) {
        sendMessage(chatId, text);
    }
}

inline void TelegramBot::processMessage(const QString &chatId, const QString &text)
{
    // Implement your logic to process incoming messages here
    if (text == "/status")
    {
        sendMessage(chatId, "Status: Online");
    }
}

inline void TelegramBot::startListening()
{
    QString apiUrl = "https://api.telegram.org/bot" + botToken + "/getUpdates";

    if (!lastUpdateId.isEmpty())
    {
        apiUrl += "?offset=" + QString::number(lastUpdateId.toInt() + 1);
    }

    QNetworkRequest request(apiUrl);
    networkManager.get(request);
}

inline void TelegramBot::onNetworkReply(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray data = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);

        QJsonObject rootObject = jsonDoc.object();

        if (rootObject.value("ok").toBool())
        {
            QJsonArray updates = rootObject.value("result").toArray();
            processUpdates(updates);
        }
        else
        {
            qDebug() << "Telegram API returned an error:" << rootObject.value("description").toString();
        }
    }
    else
    {
        //qDebug() << "Network error:" << reply->errorString();
    }

    reply->deleteLater();
}



inline void TelegramBot::processUpdates(const QJsonArray &updates)
{
    for (const QJsonValue &update : updates)
    {
        QJsonObject message = update.toObject().value("message").toObject();
        QString chatId = message.value("chat").toObject().value("id").toVariant().toString();
        QString text = message.value("text").toVariant().toString();

        processMessage(chatId, text);

        // Update last update identificato
        QJsonValue updateIdValue = update.toObject().value("update_id");
        if (updateIdValue.isDouble())
        {
            qint64 updateId = static_cast<qint64>(updateIdValue.toDouble());
            lastUpdateId = QString::number(updateId);
        }
        else if (updateIdValue.isString())
        {
            lastUpdateId = updateIdValue.toString();
        }
    }

    // If no timer enabled, call in cycle
    //startListening();
}


#endif // TELEGRAMBOT_H
