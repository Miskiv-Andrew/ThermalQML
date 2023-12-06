#ifndef HEATER_H
#define HEATER_H

#include <QObject>
#include <QTcpSocket>
#include <QByteArray>
#include <QTimer>

/*

#define HEATER_NAME "heat"

*/

#define CREATE_EXC          1
#define REC_GUI_ORDER_EXC   2
#define REC_HEAT_DATA_EXC   3
#define RET_REC_BUFF_EXC    4
#define SEND_ORD_HEAT_EXC   5



/*
		Структура буфера обмена данными
	data - char массив
	count - размер массива
*/
typedef struct
{
    char data[49];
    quint64 count;
} buffer ;


// Символы для работы с печкой
const char sp    =  static_cast<char>(182);
const char cr    =  '\r';
const char zero  =  '0';
const char one   =  '1';


class heater : public QObject
{
    Q_OBJECT

public:

    explicit heater(QObject *parent = nullptr);
	
    ~heater();

public slots:


    //  После передачи объекта heater в поток и активации потока
    //  создаем сокет, таймер и нужные коннекты
    void create_heater();

    // int     - номер команды
    // double  - требуемая температура (если есть)
    void receive_dispatcher_order(int, double = 0.0);

    // прием данных от печки 
    void receive_heater_data();

    // заполнение буфера запроса
    void ret_request_buffer(qint8 key, double temp = 0.0);

    // отправка команды печке
    bool send_order_heater(buffer *p);


private slots:



private:

    QTcpSocket * heater_socket;
	
    QTimer * heater_timer;
	
    buffer heater_req_arr;
	
    // Флаг активности соединения с сервером печки
	bool active_socket = false;  
	
    // Глобальная переменная - тип команды для печки
	int dispatcher_order;
	
	// Глобальная переменная - значение цеоевой температуры для печки
    double gl_temp = 0.0;


signals:

    /*
            ОТПРАВКА ОБРАБОТАННЫХ ДАННЫХ В Main Dispatcher
        int order        - тип команды
        bool flag        - успешность передачи команды
        double temp      - данные (здесь температура)
    */
    void send_data_to_dispatcher(int, bool, double);


    /*
            ОТПРАВКА ДАННЫХ ИСКЛЮЧЕНИЯ В GUI
        int order        - номер ф-ции, где произошло исключение
		1 - create_heater()
		2 - receive_dispatcher_order(int order, double temp)
		3 - receive_heater_data()
		4 - ret_request_buffer(qint8 key, double temp)
		5 - send_order_heater(buffer *p)
		
    */
    void send_exceptinfo_to_dispatcher(int, QString);



};

inline heater::heater(QObject *parent)
{
    Q_UNUSED(parent);
}

inline heater::~heater()
{
   heater_socket->deleteLater();
   heater_timer->deleteLater();
}

inline void heater::create_heater()
{
    try {
        
		/*
			Создаем аварийный таймер неответа печки:
			- в случае срабатывания таймера отправляем сигнал диспетчеру про
			  проблемы с печкой			  
		*/       
		
		heater_timer = new QTimer();

        connect(heater_timer, &QTimer::timeout, [=](){
            heater_timer->stop();
			// Эмитируем сигнал в диспетчер при неответе печки
            emit send_data_to_dispatcher(dispatcher_order, false, 0.0);  
        });
		
		
		/*
			Создаем сокет для коннекта с сервером печки:					  
		*/
		
		heater_socket = new QTcpSocket();
		
        // Сигнал при коннекте к серверу печки		
		connect(heater_socket, &QTcpSocket::connected, [=](){
            active_socket = true;
            emit send_data_to_dispatcher(dispatcher_order, true, 0.0);   
        });
		
		// Сигнал при дисконнекте от сервера печки	
        connect(heater_socket, &QTcpSocket::disconnected, [=](){
            active_socket = false;
            emit send_data_to_dispatcher(dispatcher_order, true, 0.0);   
        });
		
		// Сигнал при получении данных от печки
        connect(heater_socket, &QTcpSocket::readyRead, this, &heater::receive_heater_data);  

    }

    catch(...) {
        emit send_exceptinfo_to_dispatcher(CREATE_EXC, "Помилка при створенні допоміжних об'єктів,\nпотрібно перезавантажити компьютер");
    }
}

inline void heater::receive_dispatcher_order(int order, double temp)
{

    try {
        /*
        *                  ТАБЛИЦА КОМАНД, ПОЛУЧЕННЫХ ИЗ GUI
        *    -  1               - запрос на получение температуры
        *    -  2               - включение системы контроля
        *    -  3               - выключение системы контроля
        *    -  4, double       - установка температуры
        *    -  5               - connect к печке
        *    -  6               - disconnect от печки
        */

        dispatcher_order = order;

        if(dispatcher_order == 5) {  // Connect
            heater_socket->connectToHost("169.254.50.136", 2049);  //origin
//            heater_socket->connectToHost("192.168.17.104", 2049);
            return;
        }

        else if(dispatcher_order == 6) {  // Disconnect
            heater_socket->disconnectFromHost();
            return;
        }


        else if(dispatcher_order >= 1 &&  order <= 3) // включение, выключение, запрос температуры
            ret_request_buffer(dispatcher_order);     // заполняем буфер buffer heater_req_arr

        else if(dispatcher_order == 4) {             // установка нового значения температуры
            gl_temp = temp;
			// заполняем буфер buffer heater_req_arr
            ret_request_buffer(dispatcher_order, gl_temp);      
        }

        else
            return;

        bool flag = send_order_heater(&heater_req_arr);          // Записываем запрос в сокет

        if(!flag) {
			// При ошибке записи информируем диспетчера
            emit send_data_to_dispatcher(dispatcher_order, flag, 0.0);  
		}

        heater_timer->start(1000);           // Запускаем таймер "неответа печки"
    }

    catch(...) {
        emit send_exceptinfo_to_dispatcher(REC_GUI_ORDER_EXC, "Помилка при отриманні команди від диспетчера");
    }



}

inline void heater::receive_heater_data()
{
    try {

        heater_timer->stop();

        QByteArray rec_arr;
		rec_arr.clear();

        while(heater_socket->bytesAvailable())
            rec_arr.append(heater_socket->readAll());

        if(rec_arr.at(0) != '1')   {                       // ПЕЧКА НЕ "ВОСПРИНЯЛА" КОМАНДУ
            if(dispatcher_order != 4)
                emit send_data_to_dispatcher(dispatcher_order, false, 0.0);
            else
                emit send_data_to_dispatcher(dispatcher_order, false, gl_temp);
        }

        else if(rec_arr.size() == 3 ) {    // ПЕЧКА  "ВОСПРИНЯЛА" КОМАНДУ, ОТВЕТ БЕЗ ПАРАМЕТРА
            if(dispatcher_order != 4)
                emit send_data_to_dispatcher(dispatcher_order, true, 0.0);

            else
                emit send_data_to_dispatcher(dispatcher_order, true, gl_temp);
        }

        else {    // ПЕЧКА  "ВОСПРИНЯЛА" КОМАНДУ, ОБРАБАТЫВАЕМ ДАННЫЕ ТЕМПЕРАТУРЫ

            QString str(rec_arr);
            bool flag;
            double d_temp(str.mid(2, str.indexOf(QChar('\r'))).toDouble(&flag));
            emit send_data_to_dispatcher(dispatcher_order, flag, d_temp);
        }

    }

    catch(...) {
        emit send_exceptinfo_to_dispatcher(REC_HEAT_DATA_EXC, "Помилка при отримані даних від пічки");
    }
}

inline void heater::ret_request_buffer(qint8 key, double temp)
{

    try {
        /*
        * Функция формирования запроса к печке
        *                  ПРОТОКОЛ ОБЩЕНИЯ С ПЕЧКОЙ
        *    -  1  -  11004 ¶ 1 ¶ 1 ¶ 1<CR>      - запрос на получение температуры
        *    -  2  -  14001 ¶ 1 ¶ 2 ¶ 1 <CR>     - включение системы контроля
        *    -  3  -  14001 ¶ 1 ¶ 2 ¶ 0 <CR>     - выключение системы контроля
        *    -  4  -  11001 ¶ 1 ¶ 1 ¶ 23.0 <CR>  - установка температуры
        */

        char help_buffer[7] = {'\0'};

        int sign_count;

        memset(&heater_req_arr.data, '\0', sizeof(heater_req_arr.count));
        heater_req_arr.count = 0;

        switch(key) {

            case 1:                                 // запрос на получение температуры
                heater_req_arr.data[0]   = '1';
                heater_req_arr.data[1]   = '1';
                heater_req_arr.data[2]   = '0';
                heater_req_arr.data[3]   = '0';
                heater_req_arr.data[4]   = '4';
                heater_req_arr.data[5]   =  sp;
                heater_req_arr.data[6]   =  one;
                heater_req_arr.data[7]   =  sp;
                heater_req_arr.data[8]   =  one;
                heater_req_arr.data[9]   =  sp;
                heater_req_arr.data[10]  =  one;
                heater_req_arr.data[11]  =  cr;
                heater_req_arr.count     =  12;
                break;

            case 2:                                 // включение системы контроля
                heater_req_arr.data[0]   = '1';
                heater_req_arr.data[1]   = '4';
                heater_req_arr.data[2]   = '0';
                heater_req_arr.data[3]   = '0';
                heater_req_arr.data[4]   = '1';
                heater_req_arr.data[5]   =  sp;
                heater_req_arr.data[6]   =  one;
                heater_req_arr.data[7]   =  sp;
                heater_req_arr.data[8]   =  one;
                heater_req_arr.data[9]   =  sp;
                heater_req_arr.data[10]  =  one;
                heater_req_arr.data[11]  =  cr;
                heater_req_arr.count     =  12;
                break;

            case 3:                                 // выключение системы контроля
                heater_req_arr.data[0]   = '1';
                heater_req_arr.data[1]   = '4';
                heater_req_arr.data[2]   = '0';
                heater_req_arr.data[3]   = '0';
                heater_req_arr.data[4]   = '1';
                heater_req_arr.data[5]   =  sp;
                heater_req_arr.data[6]   =  one;
                heater_req_arr.data[7]   =  sp;
                heater_req_arr.data[8]   =  one;
                heater_req_arr.data[9]   =  sp;
                heater_req_arr.data[10]  =  zero;
                heater_req_arr.data[11]  =  cr;
                heater_req_arr.count     =  12;
                break;

            case 4:                                // установка нового значения температуры
                heater_req_arr.data[0]  = '1';
                heater_req_arr.data[1]  = '1';
                heater_req_arr.data[2]  = '0';
                heater_req_arr.data[3]  = '0';
                heater_req_arr.data[4]  = '1';
                heater_req_arr.data[5]  =  sp;
                heater_req_arr.data[6]  =  one;
                heater_req_arr.data[7]  =  sp;
                heater_req_arr.data[8]  =  one;
                heater_req_arr.data[9]  =  sp;

                // Записали во временный буфер значение температуры
                sign_count = sprintf (help_buffer, "%.1f", temp);

                // Скопировали данные температуры в буфер обмена
                int i ;
                for(i = 0; i < sign_count; ++i)
                    heater_req_arr.data[i + 10] = help_buffer[i];

                heater_req_arr.data[i + 10] = cr;
                heater_req_arr.count        = i + 11;
                break;

            default:
                return;
        }
    }

    catch(...) {
        emit send_exceptinfo_to_dispatcher(RET_REC_BUFF_EXC, "Помилка при створенні буферу команди");
    }


}

inline bool heater::send_order_heater(buffer *p) // Записываем запрос в сокет
{
    try {
        if(active_socket) {
            quint64 result = heater_socket->write(p->data, p->count);
            return result == p->count;
        }

        else
            return false;
    }

    catch(...) {
        emit send_exceptinfo_to_dispatcher(SEND_ORD_HEAT_EXC, "Помилка при передачі буферу команди");
        return false;
    }
}



#endif // HEATER_H
