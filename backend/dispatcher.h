#ifndef DISPATCHER_H
#define DISPATCHER_H

#include <QObject>
#include <QThread>
#include <QtGlobal>
#include "heater.h"
#include "devices.h"
#include "devicelist.h"
#include "telegrambot.h"

#define ONE_HOUR 3600000
#define TWO_HOUR 7200000




class dispatcher : public QObject
{
    Q_OBJECT

public:

	// Свойство temp - текущая температура печки curr_temp
    Q_PROPERTY(double temp READ get_curr_temp WRITE set_curr_temp NOTIFY change_curr_temp)
    // [SCE] Список целевых температу связывание напрямую с QML
    Q_PROPERTY(QList<double> unfinishedTempList READ unfinishedTempList NOTIFY unfinishedTempListChanged)
    Q_PROPERTY(double currentTargetTemp READ currentTargetTemp NOTIFY currentTargetTempChanged)
	
	explicit dispatcher(QObject *parent = nullptr);

    ~dispatcher();
	
    enum System_Mode { sDefault, Heater_Temp_Control, Device_Temp_Control, Adjuster_Wait  };
	/*
		Default                 - режим начального состояния 
		Heater_Temp_Control     - режим контроля температуры (набор темп печкой)	
		Device_Temp_Control     - режим контроля температуры (набор темп девайсами)		
		Adjuster_Wait           - режим ожидания регулировщика		    
	*/
	                                         
	void set_system_mode(System_Mode _mode);  
    System_Mode get_system_mode();  
	
	
    enum D_Control_Mode { dDefault, Auto, SemiAuto, Handle };
	/*
		Default    - режим по умолчанию 	
		Auto       - АВТО режим		
		SemiAuto   - ПОЛУАВТО режим		
		Handle     - РУЧНОЙ режим	
	*/

    // Метод для установки указателя на DeviceList (для отображения в списке QML)
    void setDeviceList(DeviceList* deviceList);
	
	
	// Ф-ция возвращает следующую целевую температуру
    QPair<bool, double> target_temp_selection();

    /*          QML         */
    // [SCE] Список целевых "неотработанных" температур (обновление)
    QList<double> unfinishedTempList() const
    {
        return unfinished_temp_list;
    }

    double currentTargetTemp() const
    {
        return m_currentTargetTemp;
    }

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
	
	
//////////////////////////////////// БЛОК Ф-ЦИЙ DEVICES ///////////////////////////////////////


	// Прием списка девайсов из Devices
	void proc_dev_list(bool , QString, QList<InfoDev> );	

	// Прием данных от класса Devices
    void receive_data_from_devices(QVariantList);
	
	// Прием списка текущих температур девайсов из Devices
	void receive_temp_list(QList<double>);
	
	 	

	
	

//////////////////////////////////// БЛОК Ф-ЦИЙ QML /////////////////////////////////////////////
	
	
	// Прием данных из интерфейса QML
    void receive_data_from_QML(QVariantList);
	
	
	

//////////////////////////////////// БЛОК Ф-ЦИЙ dispatcher /////////////////////////////////
	
	// обработчик таймера request_heater_timer
    void proc_request_heater_timer();
	
	// Ф-ция проверки готовности девайсов к термокомпенсации
	// - проверка времени выдержки и температур девайсов
	bool readiness_of_devices(QList<double> &);
	
	// Геттер и сеттер для установки значения d_control_mode
	void set_d_control_mode(D_Control_Mode _mode); 
	D_Control_Mode get_d_control_mode();
	
	
	// Ф-ция получения новой целевой температуры и продолжения работы
	void contin_system_work();
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////
	

private:

    heater * heater_obj;     // Объекты печки и потока печки
    QThread * heat_thread;  
	
	Devices * devices_obj;	 // Объекты девайсов и потока девайсов
	QThread * dev_thread;	
	
	QTimer * request_heater_timer;      // Таймер запросов целевой и текущей температуры в печку
	
	 // Режим работы (НАБОР ТЕМПЕРАТУРЫ, КАЛИБРОВКА, ...)
    System_Mode      system_mode;
	
	double curr_temp {0.0};          // Текущая температура печки
	
	double target_temp {0.0};        // Целевая температура печки
	
	QList<double> etal_list;         // Список эталонных температур термокомпенсации
	
	bool flag_target_temp {false};      // Флаг необходимости передачи целевой температуры в печку
	
	bool flag_change_temp {false};      // Флаг изменения целевой температуры 	
	
    QList<double> unfinished_temp_list;   // [SCE] Список целевых "неотработанных" температур
	
	QList<double> finished_temp_list;      // Список целевых "отработанных" температур

    DeviceList* m_deviceList;             //Список девайсов (List QML)
	
	// Время начала набора температур девайсами
	// Присваиваем значение, когда печка набрала температуру и переходим к
	// набору температуры девайсами
	QTime glob_start_time;  


	// Режим работы в термокомпенсации (РУЧНАЯ, АВТО, ПОЛУАВТО)
	D_Control_Mode  d_control_mode;
	
	// Позиция целевой температуры в таблице
	int target_temp_posit{-1};

    TelegramBot *bot;

    // [SCE] Темература которую подсвечиваем в списке
    double m_currentTargetTemp;


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
    void receive_order_to_heater(int, double); // ОТПРАВКА КОМАНДЫ В ПЕЧКУ
	
	// Сигнал изменения значения Q_PROPERTY temp (curr_temp)
	void change_curr_temp(double);		
	
	// Сигнал отправки текстовых данных в QML
	void qml_send_text(QString);
	
	// Сигнал подсветки нужной целевой температуры в таблице температур QML
    void qml_light_target_temp(int);

	// Сигнал отправки массива данных в QML
	void qml_send_array(QVariantList); 
	
	// Сигнал отправки команд в Devices
	void trans_order_to_devices(QVariantList); 

	// Сигнал остановки таймера контроля температур
	void stop_temp_control_timer();
	
	// Сигнал вызова ф-ции выборки новой температуры и продолжения работы 
	void s_contin_system_work();


    // [SCE] Сигнал для обновления списка темрерату [SCE]
    void unfinishedTempListChanged();
    void currentTargetTempChanged();    // подсветка текущей температуы


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
	
/////////////////// СОЗДАНИЕ devices_obj, КОННЕКТЫ И ПЕРЕДАЧА В ПОТОК ////////////////////////////

    devices_obj = new Devices();
    dev_thread  = new QThread();

    devices_obj->moveToThread(dev_thread);
	
	// передача команд из dispatcher в devices
    connect(this, &dispatcher::trans_order_to_devices, devices_obj, &Devices::receive_dispatcher_order);

	// прием списка приборов из Devices
	connect(devices_obj, &Devices::s_proc_dev_list, this, &dispatcher::proc_dev_list);

	// прием данных из Devices
	connect(devices_obj, &Devices::s_send_dispatcher_data, this, &dispatcher::receive_data_from_devices);
	
	// прием из Devices списка температур девайсов
	connect(devices_obj, &Devices::s_send_temp_list, this, &dispatcher::receive_temp_list);
	
	// Остановка таймера контроля температур
	connect(this, &dispatcher::stop_temp_control_timer, devices_obj, &Devices::stop_temp_control_timer);
	
	
	// запуск потока - создание сервисов девайсов (таймера, сериал-порт)
    connect(dev_thread, &QThread::started,  devices_obj, &Devices::create_devices);
    heat_thread->start();


    ////////////////////////////// СОЗДАНИЕ TelegramBot bot////////////////////////////

    bot = new TelegramBot();

/////////////////// СОЗДАНИЕ ОБЪЕКТОВ И КОННЕКТЫ dispatcher ////////////////////////////////

	request_heater_timer = new QTimer();	
	request_heater_timer->stop();
	
	connect(request_heater_timer, &QTimer::timeout, this, &dispatcher::proc_request_heater_timer); 
	etal_list.clear();   //  Заполняем эталонный список значениями
	etal_list << -20.0 << -10.0 << 0.0 << 10.0 << 20.0 << 30.0 << 40.0 << 50.0;
	
    set_system_mode(sDefault);  // При старте система - в начальное состояние
	
	connect(this, &dispatcher::s_contin_system_work, &dispatcher::contin_system_work);


////////////////////////////////////////////////////////////////////////////////////////////


    

	
}

inline dispatcher::~dispatcher()
{
    heat_thread->deleteLater();
    heater_obj->deleteLater();
	
	devices_obj->deleteLater();	
	dev_thread->deleteLater();
	
	bot->deleteLater();
	
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
	
	else  // запрос текущей температуры
		emit receive_order_to_heater(1, 0.0); // Запросили текущую температуру печки	
	
	// Запустили таймер для следующего запроса к печке
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

            Остановить таймер запросов к печке ????????????????????????????????????????????????????????????????????????????
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
					Если совпадения нет (разница > 0.5 градуса), выходим
					Если совпадение есть (разница < 0.5 градуса):
						- Сбрасываем флаг сверки текущей и целевой температур
						- Main Disp State переводим в состояние контроля температур девайсов
						- фиксируем стартовое время начала контроля температуры девайсов	
				*/				
				
				if(flag_change_temp) {
					
					if(qAbs(target_temp - curr_temp) < 0.5) { // Целевая температура достигнута
						
						flag_change_temp = false; // Сбрасываем флаг сравнения температур 
						
						/*
							Здесь Main State Machine должна перейти в состояние контроля за температурами девайсов	
							Здесь можно отправить сообщение в Telegramm о достижении данной целевой температуры печкой							
						*/
						
						
						/* Действия тестового режима №1
							- отправить сообщение в Telegramm
							- перейти к следующей целевой температуре
						*/
						
						QString str(" Цільову температуру " + QString::number(target_temp)    + " досягнуто");
						
                        bot->sendGroupMessage(str);
						
                        str.prepend("[INFO]");
						
						emit s_contin_system_work();						
					
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
        emit qml_send_text("[INFO] Отримано порожній список команд");
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
			
        else if(str == "start_search")  {    // Стартовый поиск девайсов		
			QVariantList list;
			list.clear();			
			list.append("search");
			list.append(1);		
			emit trans_order_to_devices(list); 
		}
		
		else if(str == "start_research")  {   // Переподключение девайсов		
			QVariantList list;
			list.clear();			
			list.append("search");
			list.append(2);		
			emit trans_order_to_devices(list); 
		}
		
		else if(str == "correct_connect") { // Подтверждение корректности подкл. девайсов
			QVariantList list;
			list.clear();			
			list.append(str);				
			emit trans_order_to_devices(list);		
		}
		
		else if(str == "start_work_system") { // Подтверждение корректности подкл. девайсов
			/*
					АЛГОРИТМ
				1. Начало новой сессии
					- зафиксировать 1 целевую температуру
					- запустить Devices в режиме контроля температур девайсов
					- зафиксировать время старта контроля температур
					- зафиксировать режим "Контроль температуры"
				
				
			*/
			// set_system_mode(Temp_Control);
			
			//QVariantList list;
			//list.clear();			
			//list.append(str);				
			//emit trans_order_to_devices(list);
			
			// Начало новой сессии 
            if(get_system_mode() == sDefault ) {
				
				// Вызываем ф-цию выборки температуры и старта(рестарта) цикла
				emit s_contin_system_work();   
				return;
			}




			
		}
		
		
			 
		
		return;		
	}
	
	else if(list.size() == 2) {		
		
		if(str == "target_temp") {		

			bool flag;
            double d_temp(list.at(1).toDouble(&flag));
			
			if(flag && etal_list.contains(d_temp)) {	
			
				if(finished_temp_list.contains(d_temp)) {				
					emit qml_send_text("[INFO] Температура " + QString::number(d_temp) + " вже відпрацьована");
					return;					
				}			
            
				target_temp = d_temp;     // Присвоили новое значение целевой темп.
				flag_target_temp = true;  // Подняли флаг необходимости передачи новой целевой темп.
				
				set_system_mode(Heater_Temp_Control); //  Систему - в состояние контроля 
				                                      //  температуры печки
				
				request_heater_timer->stop();  // Остановили таймер запроса к печке				
				request_heater_timer->start(1000); // Перезапустили таймер на меньшее время
				
				/*
				   Здесь ничего не нужно - при получении данных печки контролируем
				   совпадение текущей и целевой температур
				*/
			}
			
			else 
				emit qml_send_text("[INFO] Некоректне значення цільової температури");			
			
			return;			
		}
		
		else if(str == "select_dev") {
			
			QString str_num(list.at(1).toString());
			bool flag;   // Достали номер и перевели в Int			
			int local_num = str_num.toInt(&flag);
			
			if(flag) {  // Корректное преобразование в Int 				
				QVariantList list;
				list.clear();
				list.append(str);
                list.append(local_num);
				emit trans_order_to_devices(list);
			}
				
			else      // Некорректное преобразование в Int 	
				emit qml_send_text("[INFO] Номер девайса некоректний");
			
			return;				
		}
		
		else if(str == "adjuster_name") {			
			QString adj_name(list.at(1).toString());
			QVariantList list;
			list.clear();			
			list.append(str);
			list.append(adj_name);
			
			emit trans_order_to_devices(list);
			
			return;				
		}
		
		else if(str == "restart_session") {	
		
			QString path(list.at(1).toString());			
			QFile f(path);
			
			if(!f.exists()) { // Некорректный путь к файлу	
				emit qml_send_text("[INFO] Некоректний шлях до файлу сесії");
				return;
			}
			
			if(!f.fileName().contains("session_")) { // Это не файл сессии	
				emit qml_send_text("[INFO] Це не файл сесії");
				return;
			}
			
			QVariantList list;
			list.clear();			
			list.append(str);
			list.append(path);
			
			emit trans_order_to_devices(list);
			
			return;	
		}	


		else if(str == "add_device") {	
		
			QString path(list.at(1).toString());			
			QFile f(path);
			
			if(!f.exists()) { // Некорректный путь к файлу	
				emit qml_send_text("[INFO] Некоректний шлях до файлу приладу");
				return;
			}
			
			QVariantList list;
			list.clear();			
			list.append(str);
			list.append(path);
			
			emit trans_order_to_devices(list);
			
			return;				
		}
		
		else if(str == "mode") {

			QString s_mode(list.at(1).toString());
			int i_mode;
			
			/*
				Здесь присваиваем тип работы с девайсами:
					- АВТО
					- ПОЛУАВТО
					- РУЧНОЙ
				enum D_Control_Mode { Default, Auto, SemiAuto, Handle };
			*/
			
			if(s_mode == "auto") {
				i_mode = 1;
				set_d_control_mode(Auto);
			}

			else if(s_mode == "semi") {
				i_mode = 2;
				set_d_control_mode(SemiAuto);
			}

			else if(s_mode == "handle") {
				i_mode = 3;
				set_d_control_mode(Handle);
			}

			/*
			 Отправляем данные в 
			*/
			
			QVariantList list;
			list.clear();			
			list.append(str);
			list.append(i_mode);
			
			emit trans_order_to_devices(list);
			
			return;	
		}
			
	}
	
	else if(list.size() == 3) {	
	
		if(str == "delete_dev") {
			
			QString str_num(list.at(1).toString());
			QString key(list.at(2).toString());
			bool flag;   // Достали номер и перевели в Int			
			int num_dev = str_num.toInt(&flag);
			
			if(flag) {  // Корректное преобразование в Int 				
				QVariantList list;
				list.clear();				
				list.append(str);
                list.append(num_dev);  //  delete_dev   5  true-false

				if(key == "save")
					list.append(true);					
				else if(key == "not")
					list.append(false);		
				
				emit trans_order_to_devices(list);
			}
				
			else      // Некорректное преобразование в Int 	
				emit qml_send_text("[INFO] Номер девайса(для видалення) некоректний");			
		}
	
	}
	
	
	
    // QList<double> unfinished_temp_list; // Список целевых "неотработанных" температур
	else {
		
		if(str == "target_temp_list") {
			
            unfinished_temp_list.clear();// очистили стартовый список температур
            unfinishedTempListChanged();
			bool test;
			double value;			
						
			for(int i = 1; i < list.size(); ++i) {	
			
                value = list.at(i).toString().toDouble(&test);
				
				if(!test || !etal_list.contains(value)) {
                    unfinished_temp_list.clear();// При ошибке очищаем стартовый список температур
                    unfinishedTempListChanged();
                    QString info("[INFO] Некоректний формат даних температури.\nСписок доступних температур: ");

                    // [SCE] Преобразование каждого элемента QList<double> в строку и добавление к info
                    foreach (double temperature, etal_list) {
                        info += QString::number(temperature) + " ";
                    }

					emit qml_send_text(info);
					return;
				}
			
                unfinished_temp_list.append(value);
                unfinishedTempListChanged();
			}				
			
			
			// Тестовая вставка, потом убрать ?????????????????????????????????????????
			QString str;
			str.clear();
            str.append("[INFO] Список отриманих цільових температур");
						
            for(int i = 0; i < unfinished_temp_list.size(); ++i)
                str.append(" " + QString::number(unfinished_temp_list.at(i)));
			
			emit qml_send_text(str);			
		}		
	}
}


// Прием данных из Devices
inline void dispatcher::receive_data_from_devices(QVariantList list) {

	if(list.isEmpty()) {
		// Пустой list не может быть, ошибка, сообщить в QML (текст)
		emit qml_send_text("[INFO]  Помилка отримання даних з Devices\n");
		return;
	}
	
	QString key(list.at(0).toString());
	
	if(list.size() == 1) {
		
		if(key == "correct_connect") {
			// Сообщить в QML об отсутствии проблем и корректности подключения
			QVariantList list;
			list.clear();
			list.append("correct_connect");		
			emit qml_send_array(list);
			return;
		}
		
		else if(key == "Not_devices") {
			// Сообщить в QML об отсутствии подключенных девайсов (текст)
			emit qml_send_text("[INFO] Відсутні підключені прилади\n");
			return;
		}
		
		else if(key == "Incorrect_command") {
			// Сообщить в QML об получении пустой команды в Devices
			emit qml_send_text("[INFO] Некоректна команда в Devices\n");
			return;
		} 
		
		else if(key == "Session_folder_not_created") {
			// Сообщить в QML о проблеме создания папки сесии
			emit qml_send_text("[INFO] Проблема при створені папки сесії\n");
			return;
		} 
		
		else if(key == "Session_file_not_created") {
			// Сообщить в QML о проблеме создания основного файла сесии
			emit qml_send_text("[INFO] Проблема при створені основного файлу сесії\n");
			return;
		} 
		
		else if(key == "Info_file_not_created") {
			// Сообщить в QML о проблеме создания ИНФО файла сесии
			emit qml_send_text("[INFO] Проблема при створені інфо файлу сесії\n");
			return;
		} 
		
		else if(key == "Error_writing_to_session_file") {
			// Сообщить в QML о проблеме  записи данных в  файл сесии
			emit qml_send_text("[INFO] Проблема при запису даних в  основний файл сесії\n");
			return;
		} 
		
		
		
	}
		
	else if(list.size() == 2) {
		
		if(key == "Device_file_not_created") {			
			QString dev(list.at(1).toString());
			dev.prepend("Не створено файл приладу "); 
			dev.prepend("[INFO] ");
			// Сообщить в QML о проблеме создания файла девайса
			emit qml_send_text(dev);
			return;
		}
		
		else if(key == "Error_writing_to_device_file") {			
			QString dev(list.at(1).toString());
			dev.prepend("Помилка запису даних у файл приладу "); 
			dev.prepend("[INFO] ");
			// Сообщить в QML о проблеме записи данных в  файл девайса
			emit qml_send_text(dev);
			return;
		}
		
		
	}
	
}


// Прием списка приборов из Devices
inline void dispatcher::proc_dev_list(bool flag, QString str, QList<InfoDev> list) {
	
	m_deviceList->clear(); // Очищаем список приборов	
		
	if(flag) {	// Данные в таблицу выводим, если все нормально	
		QString help_str;    

		for(int i = 0; i < list.size(); ++i) {
			help_str.clear();
			help_str.append(list[i].get_name() + " , ");   // Вытягиваем имя девайса из списка
			help_str.append(list[i].get_ser_num() + "\n"); // Вытягиваем сер.номер из списка
            //DeviceList::DeviceItem item(help_str);         // Создаем строку DeviceItem
            //m_deviceList->addDevice(item);                // Добавляем строку в интерфейс QML
		}		
	}

	emit qml_send_text(str);             // Отправляем информацию в QML		
}



inline void dispatcher::receive_temp_list(QList<double> list) {

	// Вставить передачу cписка температур в QML
	
	if(!readiness_of_devices(list)) {
		/*
			Или недостаточная выдержка по времени,
			или приборы не набрали тмепературу:
				- ничего не делаем, выходим
		*/
		return;
	}
	
	emit stop_temp_control_timer();  // Отправляем сигнал остановки таймера контроля температур
	
	if(get_d_control_mode() == Auto) {
		/*		
			В АВТО режиме: 
			- начинаем термокомпенсацию
			- в тестовом режиме:
				- выбираем следующую температуру
				  и запускаем печку на набор
				- отправляем сообщение в Telegramm (АВТО - переход)
				- выходим			
		*/	
	}
	
	else if(get_d_control_mode() == SemiAuto || get_d_control_mode() == Handle) {
		/*		
			В РУЧНОМ и ПОЛУРУЧНОМ режимах
			- сообщения в Telegramm и 30 мин ожидания. Постараться дать возможность из
			Telegramm стартануть АВТО режим, если нет возможности подойти
			
			- в тестовом режиме:
				- выбираем следующую температуру
				  и запускаем печку на набор
				- отправляем сообщение в Telegramm (АВТО - переход)
				- выходим
		*/	
		
		
	}
	
}


 
inline void dispatcher::set_system_mode(System_Mode _mode) {
	system_mode = _mode;	
}



inline dispatcher::System_Mode dispatcher::get_system_mode() {
	return system_mode;	
}


inline bool dispatcher::readiness_of_devices(QList<double> &list) {

	QTime local_time = QTime::currentTime();	
	int period = glob_start_time.secsTo(local_time);
	
	if(period >= TWO_HOUR) 		
		return true;	
	
	if(period < ONE_HOUR)
		return false;
		
	if(period >= ONE_HOUR && period < TWO_HOUR) {
		// Температуры приборов сверяем с целевой температурой  target_temp
		for(int i = 0; i < list.size(); ++i) {			
			if(qFabs(list.at(i) - target_temp) > 0.8)  // 0.8 градуса выбрано условно
				return false;
		}

		return true;		
	}
	
	return false;
	
}


inline void dispatcher::set_d_control_mode(D_Control_Mode _mode) {
    d_control_mode = _mode;
}

inline dispatcher::D_Control_Mode dispatcher::get_d_control_mode() {
    return d_control_mode;
}

inline QPair<bool, double>  dispatcher::target_temp_selection() {
	
	/*
	   1. Выбрать новую целевую температуру
	       Если новая целевая температура существует:
                - удалить выбранное значение из списка unfinished_temp_list
				- записать выбранное значение в список finished_temp_list
				- вернуть пару с <true, new target_temp>
		   Если все температуры отработаны:
				- вернуть пару с <false, - 1.0>	
	*/
	
	
	bool flag = false;
	double temp = -1.0;

    if(unfinished_temp_list.isEmpty())
		return qMakePair(flag, temp);
		
	flag = true;
	
    temp = unfinished_temp_list.at(0);

    // [SCE] Подсветка температуры в списке напрямую в QML
    m_currentTargetTemp = temp;
    emit currentTargetTempChanged();
		
	// Отправляем новую целевую температуру в Devices
	QVariantList list;
	list.clear();			
	list.append("new_target_temp");
	list.append(temp);		
	emit trans_order_to_devices(list);
	
	// отправляем сигнал в QML с новым значением позиции температуры 	
    emit qml_light_target_temp(target_temp_posit);
	++target_temp_posit;	
	
    // Перезаписываем температуру из unfinished_temp_list в finished_temp_list
    unfinished_temp_list.removeFirst();
    unfinishedTempListChanged(); // [SCE] обновляем список
    finished_temp_list.append(temp);
	return qMakePair(flag, temp);
}



inline void dispatcher::contin_system_work() {
	
	request_heater_timer->stop();  // Остановили таймер запроса к печке	
	
    if(unfinished_temp_list.isEmpty()) {
		
		/*
			Все температуры отработаны
				- остановить таймер запроса температур
				- отправить сообщение в QML
				- отправить сообщение в Telegramm
		
		*/
		
		QString str("Система успішно завершила роботу");
		
		emit qml_send_text(str);
		
        bot->sendGroupMessage(str);
		
		return;
		
	}
	
	// Берем следующую целевую температуру
    double temp = unfinished_temp_list.at(0);
		
	// Отправляем новую целевую температуру в Devices
	QVariantList list;
	list.clear();			
	list.append("new_target_temp");
	list.append(temp);		
	emit trans_order_to_devices(list);
	
	// отправляем сигнал в QML с новым значением позиции температуры 	
    emit qml_light_target_temp(target_temp_posit);
	++target_temp_posit;	
	
    // Перезаписываем температуру из unfinished_temp_list в finished_temp_list
    unfinished_temp_list.removeFirst();
	finished_temp_list.append(temp);
	
	target_temp = temp;     // Присвоили новое значение целевой темп.
	flag_target_temp = true;  // Подняли флаг необходимости передачи новой целевой темп.
				
	set_system_mode(Heater_Temp_Control); //  Систему - в состояние контроля 
				                          //  температуры печки				
				
	request_heater_timer->start(1000); // Перезапустили таймер на меньшее время
	
	QString str("Вибрано цільову температуру " + QString::number(target_temp));
		
	//emit qml_send_text(str);
		
    bot->sendGroupMessage(str); // send to Telegramm
	
}










////////////////////////////////////////////////////////////////////////

#endif // DISPATCHER_H
