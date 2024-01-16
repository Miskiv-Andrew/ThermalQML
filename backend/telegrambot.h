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

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

class TelegramBot : public QObject
{
    Q_OBJECT

public:
    //poling
    explicit TelegramBot(const QString& token, int interval,  QObject *parent = nullptr);


public slots:

    void sendMessage(const QString& chatId, const QString& text);
	
    void processMessage(const QString& chatId, const QString& text);
	
    void startListening();

private slots:

    void onNetworkReply(QNetworkReply* reply);

private:

    void processUpdates(const QJsonArray &updates);

    QString botToken;
	
    QString webhookUrl;
	
    QString botName = "@ThermalCalibrationBot";

    QString lastUpdateId;  // Последний идентификатор обновления

    QTimer pollTimer;
    int pollingInterval;  // Added variable for polling interval in milliseconds

    QNetworkAccessManager networkManager;

};


inline TelegramBot::TelegramBot(const QString &token, int interval, QObject *parent)
    : QObject(parent), botToken(token), pollingInterval(interval)
{
    connect(&networkManager, &QNetworkAccessManager::finished, this, &TelegramBot::onNetworkReply);

    // Set up timer for regular polling
    connect(&pollTimer, &QTimer::timeout, this, &TelegramBot::startListening);
	
    pollTimer.start(pollingInterval);
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

    // Выполнение POST-запроса
    QNetworkReply* reply = networkManager.post(request, query.toString(QUrl::FullyEncoded).toUtf8());

    // Обработка ответа
    connect(reply, &QNetworkReply::finished, this, [reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug() << "Сообщение успешно отправлено!";
        } else {
            qDebug() << "Ошибка при отправке сообщения:" << reply->errorString();
        }

        // Очистка ресурсов
        reply->deleteLater();
    });

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
            // Обработка случая, когда "ok" равно false
            qDebug() << "Telegram API returned an error:" << rootObject.value("description").toString();
        }
    }
    else
    {
        // Обработка ошибки сети
        qDebug() << "Network error:" << reply->errorString();
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

        // Обновляем последний идентификатор
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

    // Вызываем метод снова для следующего опроса
    //startListening();
}


#endif // TELEGRAMBOT_H
