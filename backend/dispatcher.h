#ifndef DISPATCHER_H
#define DISPATCHER_H

#include <QObject>
#include <QThread>
#include "heater.h"

class dispatcher : public QObject
{
    Q_OBJECT

public:

    explicit dispatcher(QObject *parent = nullptr);

    ~dispatcher();

public slots:

    void h_rec_data_from_heater(QString, int, bool, double);

    void qml_rec_order_heater(int, double);




private:

    heater * heater_obj;

    QThread * heat_thread;



signals:

    /*
        ОТПРАВКА КОМАНДЫ В ПЕЧКУ

        int - номер команды
        -  1               - запрос на получение температуры
        -  2               - включение системы контроля
        -  3               - выключение системы контроля
        -  4, double       - установка температуры
        -  5               - connect к печке
        -  6               - disconnect от печки

        double - требуемая температура
    */
    void h_receive_GUI_order(int, double);

    void send_qml_1_param(QString data);

    void send_qml_2_param(QString data, QString temp);


};

inline dispatcher::dispatcher(QObject *parent)
{
    Q_UNUSED(parent);

    heater_obj = new heater();
    heat_thread = new QThread();

    heater_obj->moveToThread(heat_thread);

    // передача команд из dispatcher в печку
    connect(this, &dispatcher::h_receive_GUI_order, heater_obj, &heater::receive_GUI_order);

    // передача данных из печки в dispatcher
    connect(heater_obj, &heater::send_data_to_GUI, this, &dispatcher::h_rec_data_from_heater);

    // запуск потока - создание сервисов печки (таймер, сокет)
    connect(heat_thread, &QThread::started,  heater_obj, &heater::create_heater);

    heat_thread->start();
}

inline dispatcher::~dispatcher()
{
    heat_thread->deleteLater();
    heater_obj->deleteLater();
}

inline void dispatcher::h_rec_data_from_heater(QString name, int order, bool flag, double temp)
{
    /*
    *                  ТАБЛИЦА КОМАНД
    *    -  1               - запрос на получение температуры
    *    -  2               - включение системы контроля
    *    -  3               - выключение системы контроля
    *    -  4, double       - установка температуры
    *    -  5               - connect к печке
    *    -  6               - disconnect от печки
    */


    QString str, gui_temp;
    str.clear();
    gui_temp.clear();

    bool temp_flag(false);

    if(name == HEATER_NAME) {

        if(!flag) {    // flag == false  - ошибки

            switch (order) {
                case 1:   // запрос на получение температуры
                    str.append("\nЗапрос на отримання температури не виконано\n");
                    temp_flag = true;
                    gui_temp = "-----";
                    break;

                case 2:  // включение системы контроля
                    str.append("\nЗапрос на включення системи контролю не виконано\n");
                    break;

                case 3:  //  выключение системы контроля
                    str.append("\nЗапрос на виключення системи контролю не виконано\n");
                    break;

                case 4:  //  установка температуры (4, double)
                    str.append("\nЗапрос на встановлення температури " + QString::number(temp) + " не виконано\n");
                    break;

                case 5:  //  установка температуры (4, double)
                    str.append("\nКоннект з пічкою не виконано\n");
                    break;

                case 6:  //  установка температуры (4, double)
                    str.append("\nДисконнект з пічкою не виконано\n");
                    break;

                default:
                    break;
            }
        }

        else {
            switch (order) {
                case 1:   // запрос на получение температуры
                    str.append("\nЗапрос на отримання температури виконано\n");
                    temp_flag = true;
                    gui_temp = QString::number(temp);
                    break;

                case 2:  // включение системы контроля
                    str.append("\nЗапрос на включення системи контролю виконано\n");
                    break;

                case 3:  //  выключение системы контроля
                    str.append("\nЗапрос на виключення системи контролю виконано\n");
                    break;

                case 4:  //  установка температуры (4, double)
                    str.append("\nЗапрос на встановлення температури " + QString::number(temp) + " виконано\n");
                    break;

                case 5:  //  установка температуры (4, double)
                    str.append("\nКоннект з пічкою виконано\n");
                    break;

                case 6:  //  установка температуры (4, double)
                    str.append("\nДисконнект з пічкою виконано\n");
                    break;


                default:
                    break;
            }
        }

        if(temp_flag) {
            // Отправляем сигнал в QML с 2 QString параметрами (текст и температура)
            emit send_qml_2_param(str, gui_temp);
        }

        else {
            // Отправляем сигнал в QML с 1 QString параметром (текст)
            send_qml_1_param(str);
        }

    } // if(name == HEATER_NAME)


}

inline void dispatcher::qml_rec_order_heater(int param, double temp)
{
    /*
    *                  ТАБЛИЦА КОМАНД
    *    -  1               - запрос на получение температуры
    *    -  2               - включение системы контроля
    *    -  3               - выключение системы контроля
    *    -  4, double       - установка температуры
    *    -  5               - connect к печке
    *    -  6               - disconnect от печки
    */

    switch(param) {

        case 1:
            emit h_receive_GUI_order(1, 0.0);  // запрос на получение температуры
            break;

        case 2:
            emit h_receive_GUI_order(2, 0.0); // включение системы контроля
            break;

        case 3:
            emit h_receive_GUI_order(3, 0.0); // выключение системы контроля
            break;

        case 4:
            emit h_receive_GUI_order(4, temp); // установка температуры  temp
            break;

        case 5:
            emit h_receive_GUI_order(5, 0.0);  // connect к печке
            break;

        case 6:
            emit h_receive_GUI_order(6, 0.0);  // disconnect от печки
            break;

        default:
            break;

    }

}



/////////////////////////////////////////////////////////////////////////////////////////

#endif // DISPATCHER_H
