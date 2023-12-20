#ifndef DISPATCHER_H
#define DISPATCHER_H

#include <QObject>
#include <QThread>
#include <QtGlobal>
#include "heater.h"
#include "devicelist.h"


class dispatcher : public QObject
{
    Q_OBJECT

public:

	// Свойство temp - текущая температура печки curr_temp
    Q_PROPERTY(double temp READ get_curr_temp WRITE set_curr_temp NOTIFY change_curr_temp)
	
	explicit dispatcher(QObject *parent = nullptr);

    ~dispatcher();

    // Метод для установки указателя на DeviceList (для отображения в списке QML)
    void setDeviceList(DeviceList* deviceList);

public slots:

//////////////////////////////////// БЛОК Ф-ЦИЙ HEATER /////////////////////////////////////// 

	// Прием данных от класса heater
    void receive_data_from_heater(int, bool, double);
	
	// Прием текстовых данных Exception от класса heater
	void receive_exeptinfo_from_heater(int, QString);
	
	// Геттер Q_PROPERTY temp (curr_temp)
	double get_curr_temp();
	
	// Сеттер Q_PROPERTY temp (curr_temp)
	void set_curr_temp(double);
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////// БЛОК Ф-ЦИЙ QML /////////////////////////////////////////////
	
	// Прием данных от класса heater
    void receive_data_from_QML(QVariantList);
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////
	
//////////////////////////////////// БЛОК Ф-ЦИЙ dispatcher /////////////////////////////////
	
	// обработчик таймера request_heater_timer
    void proc_request_heater_timer();
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////
	

private:

    heater * heater_obj;

    QThread * heat_thread;
	
	double curr_temp {0.0};        // Текущая температура печки
	
	double target_temp {0.0};      // Целевая температура печки
	
	bool flag_target_temp {false}; // Флаг необходимости передачи целевой температуры в печку
	
	bool flag_change_temp {false}; // Флаг изменения целевой температуры 
	
	QTimer * request_heater_timer;  // Таймер запросов целевой и текущей температуры в печку
	
	QList<double> unfinished_temp_list; // Список целевых "неотработанных" температур
	
	QList<double>finished_temp_list;    // Список целевых "отработанных" температур

    DeviceList* m_deviceList;           //Список девайсов (List QML)


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
    void receive_order_to_heater(int, double);
	
	// Сигнал изменения значения Q_PROPERTY temp (curr_temp)
	void change_curr_temp(double);		
	
	// Сигнал отправки текстовых данных в QML
	void qml_send_text(QString);
	
	// Сигнал подсветки нужной целевой температуры в таблице температур QML
	void qml_light_turget_temp(int);

    


};

inline dispatcher::dispatcher(QObject *parent)
{
    Q_UNUSED(parent);
	
/////////////////// СОЗДАНИЕ heater_obj, КОННЕКТЫ И ПЕРЕДАЧА В ПОТОК ////////////////////////////

    heater_obj = new heater();
    heat_thread = new QThread();

    heater_obj->moveToThread(heat_thread);

    // передача команд из dispatcher в печку
    connect(this, &dispatcher::receive_order_to_heater, heater_obj, &heater::receive_dispatcher_order);

    // передача данных из печки в dispatcher
    connect(heater_obj, &heater::send_data_to_dispatcher, this, &dispatcher::receive_data_from_heater);
	
	// передача текстовых данных Exception из печки в dispatcher
    connect(heater_obj, &heater::send_exceptinfo_to_dispatcher, this, &dispatcher::receive_exeptinfo_from_heater);
	

    // запуск потока - создание сервисов печки (таймер, сокет)
    connect(heat_thread, &QThread::started,  heater_obj, &heater::create_heater);

    heat_thread->start();
	
	
////////////////////////////////////////////////////////////////////////////////////////////	

/////////////////// СОЗДАНИЕ ОБЪЕКТОВ И КОННЕКТЫ dispatcher ////////////////////////////////

	request_heater_timer = new QTimer();	
	request_heater_timer->stop();
	
	connect(request_heater_timer, &QTimer::timeout, this, &dispatcher::proc_request_heater_timer); 




////////////////////////////////////////////////////////////////////////////////////////////

	
}

inline dispatcher::~dispatcher()
{
    heat_thread->deleteLater();
    heater_obj->deleteLater();
}

//Spectre
inline void dispatcher::setDeviceList(DeviceList *deviceList)
{
    m_deviceList = deviceList;
}


// Геттер Q_PROPERTY temp (curr_temp)
//	double get_curr_temp();
	
	// Сеттер Q_PROPERTY temp (curr_temp)
//	void set_curr_temp(double);

inline double dispatcher::get_curr_temp() {	
	return curr_temp;	
}

inline void dispatcher::set_curr_temp(double temp) {
	
	if(curr_temp == temp)
		return;
	
	curr_temp = temp;	
	emit change_curr_temp(curr_temp);	
}

// обработчик таймера request_heater_timer
inline void dispatcher::proc_request_heater_timer() {
	/*
		Обработчик таймера запросов к печке:
			- либо передаем новую целевую темп. (по условию flag_target_temp == true)
			- либо отправляем запрос на текущую температуру
	*/
    
	request_heater_timer->stop();
	
	if(flag_target_temp) {  // отправка целевой температуры
		flag_target_temp = false; // Сбросили флаг необходимости передачи новой целевой темп.
		emit receive_order_to_heater(4, target_temp); // Передали новую целевой темп.		
	}
	
	else { // запрос текущей температуры
		emit receive_order_to_heater(1, 0.0); // Запросили текущую температуру печки
	}
	
	request_heater_timer->start(5000);	
}



inline void dispatcher::receive_data_from_heater(int order, bool flag, double temp)
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


    QString str;	
    str.clear();   	

	if(!flag) {    // flag == false  - ошибки при работе с печкой
	
		/*
			Выполнить необходимые системные действия с учетом 
			некорректной работы печки		
		*/

		switch (order) {
			
			case 1:   // запрос на получение температуры
                str.append("[WARN] Запрос на отримання температури не виконано");
				break;

			case 2:  // включение системы контроля
                str.append("[WARN] Запрос на включення системи контролю не виконано");
				break;

			case 3:  //  выключение системы контроля
                str.append("[WARN] Запрос на виключення системи контролю не виконано");
				break;

			case 4:  //  установка температуры (4, double)
                str.append("[WARN] Запрос на встановлення температури " + QString::number(temp) + " не виконано");
				break;

			case 5:  //  коннект к печке
                str.append("[WARN] Коннект з пічкою не виконано");
				break;

			case 6:  //  дисконнект от печки
                str.append("[WARN] Дисконнект з пічкою не виконано");
				break;

			default:
				break;
		}
	}

	else {
		switch (order) {
			case 1:   // запрос на получение температуры
				set_curr_temp(temp); // Записали новое значение температуры		
				/*
					Если поднят флаг сверки текущей и целевой температур,
					сверяем целевую и текущую температуры.
					Если совпадения нет (разница > 1 гр), выходим
					Если совпадение есть (разница < 1 гр):
						- Сбрасываем флаг сверки текущей и целевой температур
						- Main Disp State переводим в состояние контроля температур девайсов
						- фиксируем стартовое время начала контроля температуры девайсов					
				*/				
				
				if(flag_change_temp) {
					
					if(qAbs(target_temp - curr_temp) < 1.0) { // Целевая температура достигнута
						
						flag_change_temp = false; // Сбрасываем флаг сравнения температур 
						
						/*
							Здесь Main State Machine должна перейти в состояние контроля за температурами девайсов	
							Здесь можно отправить сообщение в Telegramm о достижении целевой температуры
						*/
						
                        str.append("[INFO] Цільову температуру " + QString::number(target_temp) + " досягнуто");
					
					}					
					
				}

				
				break;

			case 2:  // включение системы контроля
                str.append("[INFO] Запрос на включення системи контролю виконано");
				/*
					Здесь запустить таймер запросов к печке	
					Печка включена, начинаем периодический опрос по температуре
				
				*/
				request_heater_timer->start(1000);
				break;

			case 3:  //  выключение системы контроля
                str.append("[INFO] Запрос на виключення системи контролю виконано");
				/*
					Здесь остановить таймер запросов к печке				
				
				*/
				request_heater_timer->stop();
				break;

			case 4:  //  установка температуры (4, double)
                str.append("[INFO] Запрос на встановлення температури " + QString::number(temp) + " виконано");
				/*
					Установлена новая целевая температура,
					поднимаем флаг сверки текущей и целевой температур					
				*/
				flag_change_temp = true; // 
				break;

			case 5:  //  коннект к печке
                str.append("[INFO] Коннект з пічкою виконано");
				break;

			case 6:  //  дисконнект от печки
                str.append("[INFO] Дисконнект з пічкою виконано");
				break;


			default:
				break;
		}
	}

	if(!str.isEmpty())	
		emit qml_send_text(str);
}


// Прием текстовых данных Exception от класса heater
inline void dispatcher::receive_exeptinfo_from_heater(int type, QString str) {
	
/*
            ОТПРАВКА ДАННЫХ ИСКЛЮЧЕНИЯ В GUI
        int order        - номер ф-ции, где произошло исключение
		1 - create_heater()
		2 - receive_dispatcher_order(int order, double temp)
		3 - receive_heater_data()
		4 - ret_request_buffer(qint8 key, double temp)
		5 - send_order_heater(buffer *p)
		
    */

	switch(type) {
		
		case 1: // Не создались объекты печки или девайсов, нужна перезагрузка			
			break;
			
		case 2: // Ошибка при приеме команды печкой	
			// Необходимые системные действия
			break;
			
		case 3: // Ошибка при приеме данных печки	
			// Необходимые системные действия
			break;
			
		case 4: // Ошибка при создании буфера запроса
			// Необходимые системные действия
			break;
			
		case 5: // Ошибка при передаче данных в печку
			// Необходимые системные действия
			break;		
		
		default:
			break;		
	}
	
	emit qml_send_text(str);	
	
}

// Прием команд из интерфейса QML
inline void dispatcher::receive_data_from_QML(QVariantList list) {

	if(list.isEmpty()) {
        emit qml_send_text("[INFO] Отримано порожній список");
		return;
	}
	
	QString str(list.at(0).toString());
	
    if(list.size() == 1) {
		
		if(str == "connect_heater")  // Подключение к серверу печки
			emit receive_order_to_heater(5, 0.0); 		
		
		else if(str == "disconnect_heater")  // Отключение от сервера печки
			emit receive_order_to_heater(6, 0.0); 		
		
		else if(str == "on_control_heater")  // Включение системы контроля печки
			emit receive_order_to_heater(2, 0.0); 
					
		else if(str == "off_control_heater")  // Отключение системы контроля печки
            emit receive_order_to_heater(3, 0.0);
        else if(str == "start_search"){
            //test adding
            DeviceList::DeviceItem item1{"Spectra №19000031", "COM1"};
            DeviceList::DeviceItem item2{"Spectra №19000033", "COM2"};
            DeviceList::DeviceItem item3{"Cadmium №18000032", "COM3"};
            DeviceList::DeviceItem item4{"BDBG-09 №16000034", "COM4"};
            m_deviceList->addDevice(item1);
            m_deviceList->addDevice(item2);
            m_deviceList->addDevice(item3);
            m_deviceList->addDevice(item4);
            emit qml_send_text("devices added");

        }

		
		return;		
	}
	
	else if(list.size() == 2) {		
		
		if(str == "target_temp") {			
            target_temp = list.at(1).toDouble(); // Присвоили новое значение целевой темп.
			flag_target_temp = true; // Подняли флаг необходимости передачи новой целевой темп.
			request_heater_timer->stop();  // Остановили таймер запроса к печке
			request_heater_timer->start(1000); // Перезапустили таймер на меньшее время
			return;			
		}
			
	}
	// QList<double> unfinished_temp_list; // Список целевых "неотработанных" температур
	else {
		
		if(str == "target_temp_list") {
			
			unfinished_temp_list.clear();
			
			for(int i = 1; i < list.size(); ++i) {				
				unfinished_temp_list.append(list.at(i).toString().toDouble());				
			}
			
			QString str;
			str.clear();
            str.append("[INFO] Список отриманих цільових температур");
			
			for(int i = 0; i < unfinished_temp_list.size(); ++i) 				
                str.append(" " + QString::number(unfinished_temp_list.at(i)));
			
			emit qml_send_text(str);			
		}		
	}
}






































































/////////////////////////////////////////////////////////////////////////////////////////

#endif // DISPATCHER_H
