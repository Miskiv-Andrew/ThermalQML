#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQmlContext>
#include <QFontDatabase>
#include <QIcon>

#include "backend/dispatcher.h"
#include "backend/settings.h"
#include "backend/devicelist.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv); //Here etc..
    app.setWindowIcon(QIcon(":/icons/additional/win-icon.png"));

    // Get programm path where it launched
    QString programPath = QCoreApplication::applicationDirPath();

    //Update same font for all app
    int fontId = QFontDatabase::addApplicationFont(":/Fonts/GigaSans/GigaSans-Medium.ttf");
    if (fontId != -1) {
        QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);

        if (!fontFamilies.isEmpty()) {
            QString fontFamily = fontFamilies.at(0);

            // Установка шрифта для приложения
            QFont appFont(fontFamily);
            app.setFont(appFont);
        }
    }

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    Settings settingsManager(programPath);
    settingsManager.readSettingsFromFile();
    context->setContextProperty("smContext", &settingsManager);

    dispatcher disp;
    context->setContextProperty("dsContext", &disp);

    DeviceList deviceList;
    context->setContextProperty("deviceListModel", &deviceList);
    disp.setDeviceList(&deviceList);


    const QUrl url(u"qrc:/qml/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
