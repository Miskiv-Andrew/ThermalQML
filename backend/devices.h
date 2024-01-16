#ifndef DEVICES_H
#define DEVICES_H



#include <QObject>
#include <QString>
#include <QSerialPort>
#include <QTimer>
#include <QByteArray>
#include <QList>
#include <QVariant>
#include <QPair>
#include <QDateTime>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>


#define ID_TIMER_PAUSE  2000

#define DIR_PATH   "D:\\comp_data\\sessions\\"


//  Класс InfoDev описывает данные конкретного девайс, подключенного к системе
class InfoDev {
	
public:

    InfoDev() {
        clear();  
    }
	
	/*
		int _type                            -  тип прибора
		QString _port                        -  СОМ-порт прибора
		QString _name                        -  имя прибора (Spectra...)
		QString _ser_num                     -  серийный номер прибора		
		
		QList<QVariantList> _data_list)      -  блоки температур, параметров и спектров		
		QList<double> temp_list;             -  Список уже обработанных температур
		QString path;                        -  Полный путь к файлу девайса 
	
	*/

	// Конструктор поиска девайсов
    InfoDev( int _type, QString _port, QString _name, QString _ser_num) {
        set_min_params(_type, _port, _name, _ser_num, QList<QVariantList>());
    }


	// Конструктор копирования
    InfoDev(const InfoDev &p) {
        type      = p.type;
        port      = p.port;
        name      = p.name;
        ser_num   = p.ser_num;
        data_list = p.data_list;
		temp_list = p.temp_list;
		path      = p.path;
    }

    InfoDev& operator = (const InfoDev &p) {
        if(this == &p)
            return *this;

        type      = p.type;
        port      = p.port;
        name      = p.name;
        ser_num   = p.ser_num;
        data_list = p.data_list;
		temp_list = p.temp_list;
		path      = p.path;
        return *this;
    }

    ~InfoDev() {}

    void clear() { 	
        type    = -1;         
        port.clear();            
        name.clear();
        ser_num.clear();
        data_list.clear();		
		temp_list.clear();
        path.clear();
    }

    void set_min_params(int _type, QString _port, QString _name, QString _ser_num, QList<QVariantList>) {
        type      = _type;
        port      = _port;
        name      = _name;
        ser_num   = _ser_num;
        data_list.clear();		
		temp_list.clear();
		path.clear();
    }
	
	void set_max_params(int _type, QString _port, QString _name, QString _ser_num,
                         QList<QVariantList> _data_list, QList<double> _temp_list, QString _path)
	{
        type      = _type;
        port      = _port;
        name      = _name;
        ser_num   = _ser_num; 
	    data_list = _data_list;   
        temp_list = _temp_list;                            
		path      = _path;    	
    }
	
	

    int get_type() const{
        return type;
    }

    QString get_ser_num() const {
        return ser_num;
    }

    QString get_port() const{
        return port;
    }

    void set_port(QString _port) {
        port = _port;
    }

    QString get_name() const{
        return name;
    }

    QString get_num() const{
        return ser_num;
    }
	
    QString get_path() const{
        return path;
    }

    void set_path(QString _path) {
        path = _path;
    }

    QList<QVariantList> get_data_list() const{
        return data_list;
    }
	
    void set_data_list(QList<QVariantList> list) {
		data_list = list;		
	}

    void set_temp_data(QVariantList list) {
        data_list.append(list);
    }

private:

    int type;                        //   int номер для определения типа девайса
    QString port;                    //   СОМ порт девайса
    QString name;                    //   имя девайса
    QString ser_num;                 //   сер. номер девайса
	
    QList<QVariantList> data_list;   //   список блоков температур и параметров и спектров,
                                     //   на которых девайс был откалиброван
    QList<double> temp_list;         //   Список уже обработанных температур
    QString path;                    //   Полный путь к файлу девайса
                                     

    /*
                 СТРУКТУРА QList<QVariantList> data_list

        data_list[0] - просто  QVariantList список отработанных ранее температур
        Начиная с data_list[1]:
            data_list[1] << temp1 << param1 << param2 << ...
    */



    /*
        Может, сделать содержание data_list по подобию файла девайса

                 СТРУКТУРА ФАЙЛА ПРИБОРА
    - закончен (- не закончен)       - в data_list отсутствует
    - имя прибора                    - в data_list отсутствует
    - сер ном прибора                - в data_list отсутствует

    - температура
    - список параметров
    - строка массива спектра
    - температура
    - список параметров
    - строка массива спектра
    .....
    - температура
    - список параметров
    - строка массива спектра



    $$finished(unfinished)                      \n
    $$name_Spectra                              \n
    $$sernum_1234567                              \n
    $$temp_31.0                               \n
    param1_222.222                         \n
    param2_222.222                         \n
    ….
    paramn_222.222                         \n
    spectr_20_......_5                 \n
    $$temp_40.0                               \n
    param1_222.222                         \n
    param2_222.222                         \n
    ….
    paramn_222.222                         \n
    spectr_20_......_5                 \n
*/



};

Q_DECLARE_METATYPE(InfoDev)


class Devices : public QObject
{
    Q_OBJECT

public:

    explicit Devices(QObject *parent = nullptr);
	
	~Devices();
	
	void create_devices();
                    
    enum Work_Mode { Search , Reset , Reload , Work };  
	/*
		Search     - старт новой сессии		
		Reset      - переподключение		
		Reload     - рестарт старой сессии		
		Work       - рабочий режим		    
	*/
	
	void set_work_mode(Work_Mode _mode);
    Work_Mode get_work_mode();
	
	
    enum Temp_Control_Mode{ ON_DEVt, GET_TEMP, SWITCH_DEVt };
	/*
		ON_DEV        - включение девайса	
		GET_TEMP      - получение температуры	
		SWITCH_DEV    - выбор нового девайса		    
	*/
	
	void set_temp_control_mode(Temp_Control_Mode _mode);
	Temp_Control_Mode get_temp_control_mode();   // Temp_Control_Mode  temp_control_mode; 
	

    enum Control_Mode { Default, Auto, SemiAuto, Handle, Temp_List };
	/*
		Default    - режим по умолчанию 	
		Auto       - АВТО режим		
		SemiAuto   - ПОЛУАВТО режим		
		Handle     - РУЧНОЙ режим
        Temp_List  - режим набора температуры девайсами
	*/
	
	void set_control_mode(Control_Mode _mode); 
    Control_Mode get_control_mode();
	
	
    enum Req_Mode { ON_DEVr, SER_NUM, OFF_DEV, SWITCH_DEVr };
    /*
		ON_DEV       - режим включения прибора	
		SER_NUM      - режим получения сер.номера прибора		
		OFF_DEV      - режим выключения прибора
		SWITCH_DEV   - режим выбора следующего прибора
		
	*/
    void set_request_mode(Req_Mode _mode);
    Req_Mode get_request_mode();

    bool open_port(const QString name, int _type);
    void close_port();

    bool send_data(const QByteArray &data);

    bool check_crc(QByteArray &, int);

    QString get_ser_num(QByteArray &, int);

    void start_fil_lists();

    void switch_dev_ident();

    int verify_ID(int _ID);
	
	void set_target_temp(double _target_temp);
	
	double get_target_temp();

public slots:

	void start_search_com();
	
	void ident_type_dev(QVariantList list);

    void proc_ident_timer();   

	void proc_temp_control_timer();

    void read_data();  

    QPair<int, QString> get_dev_info(int ID);
	
	// Прием команд из dispatcher
	void receive_dispatcher_order(QVariantList);
	
	// Ф-ция обработки данных переподключения
	void reconnect_proc();
	
	// Ф-ция обработки данных рестарта старой сессии
	void old_session_proc();
	
	// Ф-ция создания папки и файлов новой сессии
	void create_new_session_files();
	
	// Ф-ция дозаписи данных в файл
	bool add_data_to_file(QString, QString &);
	
	// Геттер и сеттер фамилии регулировщика
	QString get_adjuster_name();
	void set_adjuster_name(QString);
	
	
	// Геттер и сеттер глобального номера выбранного девайса
	int get_select_dev_num();
	void set_select_dev_num(int);
	// main_path
	
	// Геттер и сеттер абсолютного пути к папке сессии
	QString get_main_path();
	void set_main_path(QString);
	
	// Ф-ция добавления девайса в сессию
	void add_device_func(QString);
	
	// Ф-ция удаления девайса из сессии
	void del_device_func(int, bool);
	
	// Ф-ция возобновления работы после переподключения
	void start_after_recon();
	
	// Ф-ция возобновления работы после загрузки данных старой сессии
	void start_after_reload();
	
	// Ф-ция старта работы системы
	void start_work_system();
	
	// Ф-ция контроля температур девайсов
	void temp_control(QVariantList);
	
	// Ф-ция выбора нового девайса при температурном контроле
	void switch_dev_temp_control();
	
	// Ф-ция выбора числового значения 1 байта из QByteArray
	qint8 byte_select_func(QByteArray &, int);
	
	// Ф-ция получения double температуры 
	double get_2_temp_func(QByteArray &, int);
	
	// Ф-ция остановки таймера контроля температур девайсов
	void stop_temp_control_timer();

    

private:

     // Режим работы (ПОИСК ДЕВАЙСОВ, РАБОТА ПО КАЛИБРОВКЕ)
    Work_Mode  work_mode;

    // Режим работы (РУЧНАЯ, АВТО, ПОЛУАВТО)
    Control_Mode  control_mode;

     // Режим поиска (ВКЛ, СЕР.НОМЕР, ВЫКЛ)
    Req_Mode  request_mode;
	
	// Режим контроля температур (ВКЛ, ПОЛУЧИТЬ ТЕМПЕРАТУРУ, ВЫБРАТЬ СЛЕД. ДЕВАЙС)
	Temp_Control_Mode  temp_control_mode; 
	

    // Инфо объект девайса (тип, СОМ, имя, сер. номер)
    InfoDev       info_dev;

    QSerialPort *ser_port;   

    // Таймер поиска девайсов
    QTimer *ident_timer;
	
	// Таймер контроля температур
    QTimer *temp_control_timer;	
	
	// Таймер контроля неответа девайса
    //QTimer *err_timer;

    // Таймер вызова ф-ции отправки запроса
    // QTimer *send_req_timer;

	// Таймер вызова STATE MACHINE DEV
	//QTimer *state_machine_timer;

    // Глобальный тип девайса
    int global_type = -1;

    // Список всех СОМ портов в системе
    QList<QString> port_list;   
	
	// Начальный список всех девайсов, найденных в системе
	QList<InfoDev> start_queue_dev_list;	
	
	// Рабочий список всех девайсов, найденных в системе
	QList<InfoDev> work_queue_dev_list;

    // Список всех массивов запросов включения девайса
    QList<QByteArray> rec_on_dev;
	
    // Список всех массивов ответов включения девайса
    QList<QByteArray> answ_on_dev;

    // Список всех массивов запросов выключения девайса
    QList<QByteArray> rec_off_dev;

    // Список всех массивов запросов серийного номера девайса
    QList<QByteArray> rec_ser_num_dev;

    // Список всех массивов запросов старта набора спектра девайса
    QList<QByteArray> rec_start_spectr_dev;	
	
    // Список всех массивов ответов на  старт набора спектра девайса
    QList<QByteArray> answ_start_spectr_dev;

    // Список всех массивов запросов на выдачу спектра девайса
    QList<QByteArray> rec_get_spectr_dev;

    // Список всех массивов запросов на выдачу коэфф. девайса
    QList<QByteArray> rec_get_koeff_dev;

    // Список всех массивов запросов на запись новых коэфф. девайса
    QList<QByteArray> rec_set_koeff_dev;

    // Список всех массивов ответов на запись новых коэфф. девайса
    QList<QByteArray> answ_set_koeff_dev;

    // Список калибровочных температур девайса
    QList<QList<int>> etal_temp_dev;

    // Список времени ожидания набора спектра девайсов
    QList<int> wait_spectr_dev;

    // Список диапазонов "попаданий" пиков девайсов
    QList<int> range_picks_dev;
	
	// Список всех массивов запросов на выдачу текущей температуры девайса
    QList<QByteArray> rec_get_curr_temp;

    // Глобальный массив принятых от девайсов данных
    QByteArray glob_buff;
	
	// Абсолютный путь к папке сессии
	QString main_path;
	
	// Фамилия регулировщика
	QString adjuster_name;
	
	// Номер выбранного девайса
	int glob_select_dev_num{-1};
	
    // Список температур девайсов при контроле температур
    QList<double> temp_dev_list;

	// Целевая температура системы (для выбора правильного пакета запроса температуры)
	double target_temp;
			
	      


signals:

	// Сигнал передачи списка обнаруженных приборов в dispatcher
    void s_proc_dev_list(bool , QString ,QList<InfoDev> );
	
	// Сигнал передачи данных в dispatcher
    void s_send_dispatcher_data(QVariantList);
	
	// Сигнал вызова ф-ции начального пооиска девайсов ident_type_dev
	void s_ident_type_dev(QVariantList);

	// Сигнал вызова ф-ции обработки данных переподключения девайсов
	void s_reconnect_proc();
	
	// Сигнал вызова ф-ции обработки данных рестарта старой сессии
	void s_old_session_proc();
	
	// Сигнал вызова ф-ции создания папки и файлов новой сессии
	void s_create_new_session_files();
	
	// Сигнал вызова ф-ции добавления девайса в сессию
    void s_add_device_func(QString);
	
	// Сигнал вызова ф-ции удаления девайса из сессии
	void s_del_device_func(int, bool);
	
	// Сигнал вызова ф-ции возобновления работы после переподключения
	void s_start_after_recon();
	
	// Сигнал вызова ф-ции возобновления работы после загрузки данных старой сессии
	void s_start_after_reload();
	
	// Сигнал вызова ф-ции старта работы системы
	void s_start_work_system();
	
	// Сигнал вызова ф-ции контроля температур девайсов
	void s_temp_control(QVariantList);
	
	// Сигнал отправки пакета текущих температур девайсов в Dispatcher
	void s_send_temp_list(QList<double>);

};

//////////////////////////////////////////////////////////////////////////////////////

inline Devices::Devices(QObject *parent)
{
    Q_UNUSED(parent);
}

inline Devices::~Devices()
{
    ident_timer->deleteLater();	
	
    ser_port->deleteLater();
	
	
	//err_timer->deleteLater();
	
}

inline void Devices::create_devices() {
	
	/*
		Ф-ция создания дополнительных  динамических объектов и 
		заполнения стандартных массивов при передаче 
		в отдельный поток объекта класса Devices
	*/	
	start_fil_lists();	
	
	set_control_mode(Auto); // По умолчанию - АВТО режим	
	
	connect(this, &Devices::s_ident_type_dev, &Devices::ident_type_dev);
	
	connect(this, &Devices::s_reconnect_proc, &Devices::reconnect_proc);

	connect(this, &Devices::s_old_session_proc, &Devices::old_session_proc);
	
	connect(this, &Devices::s_create_new_session_files, &Devices::create_new_session_files);
	
	connect(this, &Devices::s_add_device_func, &Devices::add_device_func);
		
	connect(this, &Devices::s_del_device_func, &Devices::del_device_func);
		
	connect(this, &Devices::s_start_after_recon, &Devices::start_after_recon);
	
	connect(this, &Devices::s_start_after_reload, &Devices::start_after_reload);
	
	connect(this, &Devices::s_start_work_system, &Devices::start_work_system);
	
	connect(this, &Devices::s_temp_control, &Devices::temp_control);
	
	
	ident_timer = new QTimer();
	ident_timer->setSingleShot(true);
	connect(ident_timer, &QTimer::timeout, this, &Devices::proc_ident_timer);	
	
	temp_control_timer = new QTimer();
	temp_control_timer->setSingleShot(true);
	connect(temp_control_timer, &QTimer::timeout, this, &Devices::proc_temp_control_timer);	
	
	ser_port    = new QSerialPort();
	connect(ser_port, &QSerialPort::readyRead, this, &Devices::read_data);	
	
	
	
	// err_timer   = new QTimer();

	

	
}  


inline void Devices::set_work_mode(Work_Mode _mode)
{
    work_mode = _mode;
}

inline Devices::Work_Mode Devices::get_work_mode()
{
    return work_mode;
}

inline void Devices::set_control_mode(Control_Mode _mode)
{
    control_mode = _mode;
}

inline Devices::Control_Mode Devices::get_control_mode()
{
    return control_mode;
}

inline void Devices::set_request_mode(Req_Mode _mode)
{
    request_mode = _mode;
}

inline Devices::Req_Mode Devices::get_request_mode()
{
    return request_mode;
}


inline bool Devices::open_port(const QString name, int _type)
{
    if (ser_port->isOpen())
            ser_port->close();

    ser_port->setPortName(name);

    if(!_type) {  // Spectra, new Spectra, Cadmium
        ser_port->setBaudRate(QSerialPort::Baud115200);
        ser_port->setDataBits(QSerialPort::Data8);
        ser_port->setParity(QSerialPort::Parity::NoParity);
        ser_port->setStopBits(QSerialPort::StopBits::OneStop);
        ser_port->setFlowControl(QSerialPort::FlowControl::NoFlowControl);
    }

    else if(_type == 1) {
        ser_port->setBaudRate(QSerialPort::Baud115200);
        ser_port->setDataBits(QSerialPort::Data8);
        ser_port->setParity(QSerialPort::Parity::NoParity);
        ser_port->setStopBits(QSerialPort::StopBits::OneStop);
        ser_port->setFlowControl(QSerialPort::FlowControl::NoFlowControl);
    }

    else if(_type == 2) {
        ser_port->setBaudRate(QSerialPort::Baud115200);
        ser_port->setDataBits(QSerialPort::Data8);
        ser_port->setParity(QSerialPort::Parity::NoParity);
        ser_port->setStopBits(QSerialPort::StopBits::OneStop);
        ser_port->setFlowControl(QSerialPort::FlowControl::NoFlowControl);
    }

    else if(_type == 3) {
        ser_port->setBaudRate(QSerialPort::Baud115200);
        ser_port->setDataBits(QSerialPort::Data8);
        ser_port->setParity(QSerialPort::Parity::NoParity);
        ser_port->setStopBits(QSerialPort::StopBits::OneStop);
        ser_port->setFlowControl(QSerialPort::FlowControl::NoFlowControl);
    }

    return ser_port->open(QSerialPort::ReadWrite);
}

inline void Devices::close_port()
{
    if (ser_port->isOpen())
        ser_port->close();
}

inline bool Devices::send_data(const QByteArray &data)
{ 
    if (ser_port->isOpen())
        return (ser_port->write(data) == data.size());

    return false;
}


inline bool Devices::check_crc(QByteArray &buff, int type)
{
    // Cadmium              - 0
    // Spectra              - 1
    // Spectra New          - 2
    // Guarder              - 3
	
	quint8 crc = 0;

    if(type >= 0 && type <= 3) {

        if(buff.size() <= 4)
            return false;
        
        for(int i = 4; i < buff.size() - 1; ++i)
            crc +=  static_cast<quint8>(buff.at(i));

        return crc == static_cast<quint8>(buff.at(buff.size() - 1));
    }

    return false;
}


inline QString Devices::get_ser_num(QByteArray &buff, int type)
{
    QString ser_num;
	ser_num.clear(); 
	
    QChar symb;       

    if(type  >= 0 && type <= 3)  { // Cadmium, Spectra, new Spectra, Guarder

        for(int i = 8; i < 15; ++i) {
            symb = QChar(buff.at(i));
            ser_num.append(symb);
        }

        return ser_num;
    }

    return ser_num;
}


inline void Devices::start_fil_lists()
{

    // Cadmium              - 0
    // Spectra              - 1
    // Spectra New          - 2
    // Guarder              - 3

    QByteArray help_arr;
    int i;
    unsigned char CRC;
	
						// ПАКЕТЫ ВКЛЮЧЕНИЯ ДЕВАЙСОВ

    help_arr.clear();    // Spectra, Spectra New, Cadmium, Guarder   
    rec_on_dev.clear();
    const unsigned char start_dev[5] = {0x24, 0x24, 0x24, 0x0D, 0x0A};
    for(i = 0; i < 5; ++i)
        help_arr.append(start_dev[i]);
	
    // Точка вставки новых протоколов включения девайсов
	
    rec_on_dev << help_arr << help_arr << help_arr  << help_arr;
//-----------------------------------------------------------------------------------------------

						// ПАКЕТЫ ВЫКЛЮЧЕНИЯ ДЕВАЙСОВ

    help_arr.clear();     // Cadmium, Spectra, Spectra New, Guarder   
    rec_off_dev.clear();
    const unsigned char stop_dev[5] = {0x2D, 0x2D, 0x2D, 0x0D, 0x0A};
    for(i = 0; i < 5; ++i)
        help_arr.append(stop_dev[i]);
	
    // Точка вставки новых протоколов выключения девайсов
	
    rec_off_dev << help_arr << help_arr << help_arr  << help_arr;
//-----------------------------------------------------------------------------------------------

					// ПАКЕТЫ ПОЛУЧЕНИЯ СЕР.НОМЕРОВ ДЕВАЙСОВ

    help_arr.clear();     
    rec_ser_num_dev.clear();
    const unsigned char get_Number[21] = {0x55, 0xAA, 0x11, 0x00, 0xFF, 0x5C, 0x3A, 0x01, 0x00, 									 0x00, 0x00,
                                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00 };
    for(i = 0; i < 21; ++i)
        help_arr.append(get_Number[i]);
    CRC = 0;
    for( i = 4; i <= 19; ++i)
        CRC += static_cast<unsigned char>(help_arr.at(i));
    help_arr[20] = CRC;
    rec_ser_num_dev << help_arr << help_arr << help_arr ; // Cadmium, Spectra, Spectra New (0, 1, 2)

    help_arr.clear();
    const unsigned char get_Number_1[23] = {0x55, 0xAA, 0x13, 0x00,	0xFF, 0x5C, 0x3A, 0x1, 0x00, 0x00, 0x00,
                                            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
                                            0x97};
    for(i = 0; i < 23; ++i)
        help_arr.append(get_Number_1[i]);
    rec_ser_num_dev << help_arr;  // Guarder (3)
	
	 // Точка вставки новых протоколов получения сер.номеров девайсов
	
//-----------------------------------------------------------------------------------------------

    /*
                 СПИСКИ КАЛИБРОВОЧНЫХ ТЕМПЕРАТУР ДЕВАЙСОВ     
		   
		   QList<QList<int>> etal_temp_dev;

        Cadmium, Spectra, Spectra New   -20  -10  0  10  20  30  40  50
        Guarder                         -20    0  10 20  40  60
    */

    etal_temp_dev.clear();
    QList<int> inner_list;

    inner_list.clear();
    inner_list << -20 << -10 << 0 << 10 << 20 << 30 << 40 << 50;
    etal_temp_dev.append(inner_list); // Cadmium
    etal_temp_dev.append(inner_list); // Spectra
    etal_temp_dev.append(inner_list); // Spectra New

    inner_list.clear();
    inner_list << -20 << 0 << 10 << 20 << 40 << 60;
    etal_temp_dev.append(inner_list); // Guarder
	
	// Точка вставки новых списков калибровочных температур девайсов
	
	
//-----------------------------------------------------------------------------------------------


    // Список времени ожидания набора спектра девайса


    wait_spectr_dev.clear();
    wait_spectr_dev << 60000 << 60000 << 60000 << 60000;

	// Точка вставки новых времен ожидания набора спектра девайсов


//-----------------------------------------------------------------------------------------------
	
    /*
                 СПИСКИ ЗАПРОСОВ ПОЛУЧЕНИЯ ТЕКУЩИХ ТЕМПЕРАТУР ДЕВАЙСОВ     
		   
		   QList<QByteArray> rec_get_curr_temp;

        Cadmium, Spectra, Spectra New (20 - 50)   - 0, 1 позиции в rec_get_curr_temp
		Cadmium, Spectra, Spectra New (-20 - 10)  -    2 позиция в rec_get_curr_temp          
        Guarder                                   -    3 позиция в rec_get_curr_temp             
    */
	
	// Пакет температуры ВЕРХ (Cadmium, Spectra, SpectraNew)
	rec_get_curr_temp.clear();
	help_arr.clear();

    const unsigned char upper_temp[38] = {0x55,0xAA,0x27,0x00,0xFF,0x5C,0x3A,0x83,0x00,
                                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x19};

    for(int i = 0; i < sizeof(upper_temp); ++i)
       help_arr.append(upper_temp[i]);	

	rec_get_curr_temp << help_arr << help_arr;
	
	
	// Пакет температуры НИЗ (Cadmium, Spectra, SpectraNew)
	help_arr.clear();
	const unsigned char lower_temp[38] = {0x55,0xAA,0x27,0x00,0xFF,0x5C,0x3A,0x84,0x00,
                                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01, 0x1A};

    for(int i = 0; i < sizeof(lower_temp); ++i)
       help_arr.append(lower_temp[i]);
   
    rec_get_curr_temp << help_arr;
	
	
	// Пакет температуры GUARDER
	help_arr.clear();
	const unsigned char guarder[61] = {0x55,0xAA,0x38,0x00,0xFF,0x5C,0x3A,0x81,0x00,0x00,
                                       0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                       0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                       0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                       0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                                       0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01, 0x17};
	
	for(int i = 0; i < sizeof(guarder); ++i)
       help_arr.append(guarder[i]);
   
    rec_get_curr_temp << help_arr;
	
//-----------------------------------------------------------------------------------------------
	
	



}


inline void Devices::switch_dev_ident()
{
    ser_port->clear();
    close_port();
    set_request_mode(SWITCH_DEVr);
    ident_timer->start(ID_TIMER_PAUSE);
}


inline int Devices::verify_ID(int _ID)
{
    /*
        (Байт 43h )  CADMIUM           67
        (Байт 53h ) SPECTRA            83
        (Байт 4Eh ) SPECTRA NEW        78
        (Байт 47h ) GUARDER            71
    */

    switch(_ID) {

        case 67:
            return 0;

        case 83:
            return 1;

        case 78:
            return 2;

        case 71:
            return 3;





        default:
            return -1;

    }
}


inline void Devices::start_search_com()
{   	
	QString com;
    port_list.clear();

    for(int i = 1; i < 101; ++i) {
        com = "COM";
        com.append(QString::number(i));

        if(open_port(com, 0)) {
            port_list.append(com);
            close_port();
        }
    }

	// Порты не обнаружены, отправляем сообщение об отсутствии приборов
	if(port_list.isEmpty()) {
        QVariantList list;
		list.clear();
		list.append("Not_devices");		
		emit s_send_dispatcher_data(list);
	}
	
    // Порты обнаружены, приступаем к поиску девайсов
	// Пустой QVariantList() означает начало поиска
	else                     
        emit s_ident_type_dev(QVariantList());
    
}




inline void Devices::ident_type_dev(QVariantList list)
{

    static int st_posit,       // статический порядковый номер эл-та в QList<QString> port_list;
               st_type ;       // статический номер типа девайса, с которым работаем

    static int _ID;            // статический ID для идентификации прибора

    static QString port_name,  // статическое имя используемого порта
                   st_ser_num; // статический серийный номер


////////////////////////// БЛОК НАЧАЛА ПОИСКА ДЕВАЙСОВ ///////////////////////////////////
						

    if(list.isEmpty()) { // Начало поиска девайсов или открытие следующих портов из списка
							
        st_posit   = 0;                   // Начинаем с 0 позиции в списке start_queue_dev_list
        st_type    = 0;             	  // Начинаем с 0 позиции в массивах типа прибора
        _ID        = -1;                  // Начинаем с -1 - несуществующий _ID
        port_name  = QString();		      // Очищаемся
        st_ser_num = QString();           // Очищаемся
        start_queue_dev_list.clear();     // Очишаем список девайсов

        if(open_port(port_list.at(st_posit), st_type)) { // Порт открылся c нaстройками по st_type

            // Включаем девайс
            if(send_data(rec_on_dev.at(st_type))) {   // Данные записаны в порт
                set_request_mode(ON_DEVr);             // Режим включения девайса
                port_name = port_list.at(st_posit);   // Фиксируем имя порта
                global_type = st_type;                // Фиксируем тип девайса
                ident_timer->start(ID_TIMER_PAUSE);
                return;
            }
        }

        ++st_posit;
        switch_dev_ident();
        return;
    }
	

/////////////////////////////// БЛОК ВЫБОРА НОВОГО СОМ-порта ////////////////////////////////


    if(list.size() == 2 ) {   // точка SWITCH_DEV ( неответ или переключение )
       
        if(st_posit >= port_list.size()) { // Список всех СОМ-портов перебран

            /*
				enum Work_Mode { Search , Reset , Reload , Work };
				// Начальный список всех девайсов, найденных в системе
					QList<InfoDev> start_queue_dev_list;	
					
					// Рабочий список всех девайсов, найденных в системе
					QList<InfoDev> work_queue_dev_list;

					
					ОПИСАНИЕ ЗАДАЧ				
					
				2. Режим Reset (переподключение)
					- получить новый start_queue_dev_list
					- нужно сравнить полученный start_queue_dev_list с
					  существующим work_queue_dev_list
					  
					  Если ОК:
						- отправить данные в QML с сообщением все ОК
			  
					  Если NO:
						- отправить данные в QML с сообщением о проблеме
						  и списком неподключенных девайсов
						  
				3. Режим Reload (возобновление старой сессии)
					- получить новый start_queue_dev_list					
					- по пути к файлу сессии загрузить в work_queue_dev_list
					  все данные старой сессии
					- нужно сравнить полученный start_queue_dev_list с
					  существующим work_queue_dev_list
					  
					  Если ОК:
						- отправить данные в QML с сообщением все ОК
			  
					  Если NO:
						- отправить данные в QML с сообщением о проблеме
						  и списком несоответствия девайсов
			*/			
           
            if(start_queue_dev_list.isEmpty()) {
				QString str("\nНемає підключених приладів\n");
				emit s_proc_dev_list(false, str, start_queue_dev_list);
				return;
            }			
			
			if(get_work_mode() == Search) {    // Режим Search (стартовый поиск)
				QString str("\nНовий перелік підключених приладів\n");
				emit s_proc_dev_list(true, str, start_queue_dev_list);
				return;
			}
			
			else if(get_work_mode() == Reset) { // Режим Reset (переподключение)			
				emit s_reconnect_proc();
				return;
			}
			
			else if(get_work_mode() == Reload) { // Режим Reload (рестарт старой сесии)			
				emit s_old_session_proc();
				return;
			}            
        }

        if(open_port(port_list.at(st_posit), st_type)) { // Порт открылся c нaстройками по st_type

            // Включаем девайс
            if(send_data(rec_on_dev.at(st_type))) {   // Данные записаны в порт
                set_request_mode(ON_DEVr);                   // Режим включения девайса
                port_name = port_list.at(st_posit);   // Фиксируем имя порта
                global_type = st_type;                // Фиксируем тип девайса
                ident_timer->start(ID_TIMER_PAUSE);
                return;
            }
        } // set_request_mode

        ++st_posit;
        switch_dev_ident();
        return;
    }


//////////////////////////////////////////////////////////////////////////////////////////////


    else if(!list.at(0).toBool()) { // ТОЧКА НЕОТВЕТА ДЕВАЙСА (НЕСОВПАДЕНИЕ ТИПА)
        
        ++st_type;                          // Выбираем следующий тип девайса

        if(st_type >= rec_on_dev.size()) {  // Все типы девайсов перебрали
            ++st_posit;                     // Переходим к следующему СОМ порту
            st_type = 0;
            switch_dev_ident();
            return;
        }

        else {  // Записываем включение след. типа девайса

            close_port();

			// Порт открылся c нaстройками по следующему st_type 
            if(open_port(port_name, st_type)) { 
			
                if(send_data(rec_on_dev.at(st_type))) { // Данные записаны в порт
                    set_request_mode(ON_DEVr);
                    global_type = st_type;
                    ident_timer->start(ID_TIMER_PAUSE);
                    return;
                }
            }

            ++st_posit;
            st_type = 0;
            switch_dev_ident();
            return;
        }

    }  // else if(!list.at(0).toBool()){ // Обработка неответа девайса
	
	

    else { // Девайс ответил

        int order = list.at(1).toInt();

        if(order == 1) {   // QVariant (true, 1, int ID)
            // Девайс включился, нужно:
            // - отправить запрос серийного номера
            // - сохранить ID девайса

            // точка ОТВЕТА ДЕВАЙСА (ВКЛ)
            _ID = list.at(2).toInt();
			
            st_type = verify_ID(_ID);

            if(send_data(rec_ser_num_dev.at(st_type))) { // Данные запроса сер. номера записаны в порт
                set_request_mode(SER_NUM);
                ident_timer->start(ID_TIMER_PAUSE);
                return;
            }

            else {  // Данные не записались в порт - проблема
                ++st_posit;
                st_type = 0;
                switch_dev_ident();
                return;
            }
        }

        else if(order == 2) {  // QVariant (true, 2, QString(ser_num))

            // точка ОТВЕТА ДЕВАЙСА (СЕР.НОМ)
            set_request_mode(OFF_DEV);
            st_ser_num = list.at(2).toString();

            if(send_data(rec_off_dev.at(st_type))) { // Данные записаны в порт
                ident_timer->start(ID_TIMER_PAUSE);
                return;
            }

            else {  // Данные не записались в порт - проблема
                ++st_posit;
                st_type = 0;
                switch_dev_ident();
                return;
            }
        }

        else if(order == 3) {   // QVariant (true, 3)
            // Девайс отключился, нужно записать данные ,
            //закрыть порт и перейти к следующему порту

            // точка ОТВЕТА ДЕВАЙСА (ВЫКЛ)
            QPair<int, QString> info_pair(get_dev_info(_ID));
            QList<QVariantList> list;
            list.clear();
            info_dev.set_min_params(info_pair.first, port_name, info_pair.second, st_ser_num, list);
            start_queue_dev_list.append(info_dev);
            info_dev.clear();

            ++st_posit;
            st_type = 0;
            switch_dev_ident();
            return;
        }
    }
	
	
	
	
}





inline void Devices::proc_ident_timer()
{
    /*
         ОБРАБОТКА ДАННЫХ ПОИСКА ПРИБОРОВ
            - вычитываем данные из QSerialPort *ser_port;
            - нет ответа  - эмитируем сигнал с QVariant (false, ...)

            Данные есть:
                -  1 выбор - тип девайса
                -  2 выбор - режим запроса

                  Ответ некорректный - эмитируем сигнал с QVariant (false, ...)

                  Ответ корректный   - эмитируем сигнал с QVariant (true, (int) order, (QString) data)

        ПАРАМЕТРЫ ДЛЯ ПРИНЯТИЯ РЕШЕНИЯ:
            - тип девайса      - global_type
            - режим запроса:
                enum Req_Mode{ ON_DEV, SER_NUM, OFF_DEV, SWITCH_DEV };
                Req_Mode       request_mode;
                геттер:   Req_Mode get_request_mode();

//       bool empty_flag = false,  // флаг наличия данных порта
//            CRC_flag   = false;  // флаг CRC данных порта

    */

    /*
            Варианты вызовов  ident_type_dev(QVariantList list)
          QVariantList()                               - начало опроса        ( размер - 0)
          data_list << true << 1;                      - пакет перехода на Label ( размер - 2)
          data_list << false << 0 << 0 << 0;           - неответ девайса      ( размер - 4)
          data_list << true  << 1 << ID << 0;          - девайс включился      ( размер - 4)
          data_list << true  << 2 << ser_num << 0;     - девайс дал сер.ном.    ( размер - 4)
          data_list << true  << 3 << 0 << 0;           - девайс отключился      ( размер - 4)
    */


    Req_Mode local_mode = get_request_mode();

    // точка ТАЙМЕР ОБРАБОТЧИК
    QVariantList data_list;
    data_list.clear();

    if(local_mode == SWITCH_DEVr) {            // Отправляем пакет перехода на Label
        data_list << 1 << 1;
        emit s_ident_type_dev(data_list);
        return;
    }

    QByteArray rec_buff;
    rec_buff.clear();

    while(ser_port->bytesAvailable())
        rec_buff.append(ser_port->readAll());
    ser_port->clear();

////////////// Нет ответа ///////////////////////////////////////

    if(!rec_buff.size()) {  // Нет ответа
        data_list << false << 0 << 0 << 0;
        emit s_ident_type_dev(data_list);
        return;
    }

//////////////////////////////////////////////////////////////////


////////////// Контроль CRC ///////////////////////////////////////

//    if(!check_crc(rec_buff, global_type)) {     // Не совпало CRC
//        //
//        data_list << false << 0 << 0 << 0;
//        emit s_ident_type_dev(data_list);
//        return;
//    }


//////////////////////////////////////////////////////////////////

    if(local_mode == ON_DEVr) { // Девайс включился
        if(rec_buff.size() >= 7){  // Корректный пакет    // QVariant (true, 1, int ID)
            int ID = static_cast<int>(rec_buff.at(5));
            data_list << true << 1 << ID << 0;
            emit s_ident_type_dev(data_list);
            return;
        }

        else {
            data_list << false << 0 << 0 << 0;
            emit s_ident_type_dev(data_list);
            return;
        }

    }

    else if(local_mode == SER_NUM) { // Девайс дал серийный номер

        QString ser_num = get_ser_num(rec_buff, global_type);

        if(!ser_num.isEmpty()) {
            data_list << true << 2 << ser_num << 0;
            emit s_ident_type_dev(data_list);
            return;
        }

        else {
            data_list << false << 0 << 0 << 0;
            emit s_ident_type_dev(data_list);
            return;
        }

    }

    else if(local_mode == OFF_DEV) { // Девайс выключился

        if(rec_buff.size() == 6) {
            data_list << true << 3 << 0 << 0;
            emit s_ident_type_dev(data_list);
            return;
        }

        else {
            data_list << false << 0 << 0 << 0;
            emit s_ident_type_dev(data_list);
            return;
        }

    }

}




inline QPair<int, QString> Devices::get_dev_info(int ID)
{
        switch(ID) {

        case 67:
            return qMakePair(0, QString("Cadmium"));


        case 71:
             return qMakePair(3, QString("Guarder"));

        case 78:
             return qMakePair(2, QString("Spectra New"));

        case 83:
            return qMakePair(1, QString("Spectra"));


        default:
            break;
    }

    return qMakePair(-1, QString("No device"));
}




inline void Devices::read_data()
{
	if(get_work_mode()  != Work)  
		return;
	
	// Search , Reset , Reload , Work
	//if(get_work_mode() == Search ||  get_work_mode() == Reset || get_work_mode() == Reload )
	//	return;

}




inline void Devices::receive_dispatcher_order(QVariantList list) {

	if(list.isEmpty()) {
		// Отправить сообщение о некорректности команды
		QVariantList list;
		list.clear();
		list.append("Incorrect_command");		
		emit s_send_dispatcher_data(list);
		return;
	}
	
    QString key(list.at(0).toString());

    if(list.size() == 1) {
		
		if(key == "correct_connect") {
			
		// enum Work_Mode { Search , Reset , Reload , Work };
            // Не забыть set_work_mode(Work) ??????????????????????????????
			if(get_work_mode() == Search) {				
				emit s_create_new_session_files();
			}				
			
			else if(get_work_mode() == Reset) {		
				emit s_start_after_recon();
			}
			
			else if(get_work_mode() == Reload) {
				emit s_start_after_reload();
			}
			
			return;
		}
		
		else if(key == "start_work_system") {
			emit s_start_work_system();
			
			return;
		}
		
		
    }

    else if(list.size() == 2) {
		
		if(key == "search") {  // enum Work_Mode { Search , Reset , Reload , Work };			
			
			if(list.at(1).toInt() == 1)               // старт новой сессии	
				set_work_mode(Search);
			
			else if(list.at(1).toInt() == 2)          // переподключение девайсов
				set_work_mode(Reset);
				
			start_search_com();
			
		} // if(key == "search")  Стартовый поиск и переподключение девайсов
		
		
		else if(key == "restart_session") {// enum Work_Mode{Search,Reset,Reload,Work}			
			
			set_main_path(list.at(1).toString());
			
			set_work_mode(Reload);		
				
			start_search_com();
			
		} // if(key == "restart_session")  Рестарт старой сессии
		
		else if(key == "add_device") {
			
			QString path(list.at(1).toString());
			
			emit s_add_device_func(path);
			
			
		} // if(key == "add_device")  Добавление девайса в сессию	
		
		else if(key == "adjuster_name") {			
			set_adjuster_name(list.at(1).toString());			
		} // key == "adjuster_name"  - фамилия регулировщика


		else if(key == "select_dev") {				
			set_select_dev_num(list.at(1).toInt());						
		} // key == "select_dev"  - номер выбранного девайса
		
		
		else if(key == "mode") { //set_control_mode(Auto, SemiAuto, Handle)
			int mode = list.at(1).toInt();
		
			if(mode == 1) 
				set_control_mode(Auto);
			
			else if(mode == 2) 
				set_control_mode(SemiAuto);
			
			else if(mode == 3) 
				set_control_mode(Handle);
			
								
		} 
		
		
		return;
		
    }

    else if(list.size() == 3) { //  delete_dev   5  true-false
	
		if(key == "delete_dev") {			
			int num = list.at(1).toInt();
			bool flag = list.at(2).toBool();
			
			emit s_del_device_func(num, flag);			
		}
		
		
		
		return;
		
	}
	
	
}



inline void Devices::reconnect_proc() {
	
	QList<QString> match_list;
	match_list.clear(); 
	QString work_ser_num,    // Рабочий серийный номер
			start_ser_num,   // Новый серийный номер
			work_com_port,   // Рабочий СОМ-порт
			start_com_port,  // Новый СОМ-порт
			info_str;
			
	bool match_flag;  
	int i, j;
	
	for(i = 0; i < work_queue_dev_list.size(); ++i) { // Идем по рабочему списку
		
		// Вытягиваем очередной рабочий серийный номер
		work_ser_num = work_queue_dev_list.at(i).get_ser_num();	
		
		match_flag = false;	
		
		for(j = 0; j < start_queue_dev_list.size(); ++j) { // Идем по новому списку	
		
			// Вытягиваем очередной новый серийный номер
			start_ser_num = start_queue_dev_list.at(j).get_ser_num();
			
			if(start_ser_num == work_ser_num) { // Если серийные номера совпали
				match_flag = true;
				break;
			}	
		}	
		if(!match_flag) // Серийный номер из work_queue_dev_list не обнаружен в start_ser_num
			match_list.append(work_ser_num);	 
	} 
	
	
	if(!match_list.isEmpty()) { // Список не пустой - какие-то SER_NUM не обнаружены
		info_str.clear();		
		info_str.append("\nНе підключено наступні девайси :\n");
		for(i = 0; i < match_list.size(); ++i) 		
			info_str.append(match_list.at(i) + "\n");			
		emit s_proc_dev_list(false, info_str, start_queue_dev_list);		
		return;
	} 
	
	
	for( i = 0; i < start_queue_dev_list.size(); ++i) {	 
		start_ser_num  = start_queue_dev_list.at(i).get_ser_num(); // новый серийный номер
		start_com_port = start_queue_dev_list.at(i).get_port();    //новый COM порт	
		for(j = 0; j < work_queue_dev_list.size(); ++j) {		
			if(work_queue_dev_list.at(j).get_ser_num() == start_ser_num) {
                // Совпали сер.номера - присваиваем новое значение COM порта
                InfoDev& dev = work_queue_dev_list[j];
                dev.set_port(start_com_port);
				break;
			}		
		}	 
	}
	
	info_str.clear();		
	info_str.append("\nДевайси перепідключені коректно\n");
	emit s_proc_dev_list(true, info_str, start_queue_dev_list);	
}


inline void Devices::old_session_proc() {
	/*
					АЛГОРИТМ
		имеем get_main_path() return main_path - путь к папке сессии
			- проверяем наличие основного файла сессии
			- вытягиваем из файла сессии список девайсов
			- проверяем соответствие список - реальные файлы
			- идем по списку файлов девайсов, заполняем work_queue_dev_list данными девайсов
			- сверяем work_queue_dev_list и start_queue_dev_list
			- отправляем информацию в Dispatcher		
	*/
	
	
}


inline void Devices::create_new_session_files() {

/*
	- зафиксировать строчное представление времени
	
	- создать папку сессии
		D:\\comp_data\\sessions\\session_01.01.2023
	
	- создать основной файл сессии (в папке данной сессии)
		session_01.01.2023.txt
		
	- создать Файл описания течения сессии (в папке данной сессии) 
		info_01.01.2023.txt
		
	- создать файлы девайсов (имя + сер.номер) (в папке данной сессии)
      и записать в файлы девайсов начальную информацию:		  
			unfinished\n    
			SpectaOld_1234567\n
			type_1\n	
		
	- В файл сессии внести следующие данные:
		
			name_Ivanov\n  (name + фамилия регулировщика)     "name_" + adjuster_name + "\n" 
			date_01.01.2023\n  (date + дата)                  "date_" + time + "\n"
			Spectra_1234567.txt
			Spectra_New_2345678.txt
			Cadmium_3456789.txt
			Guarder_4567889.txt
		
		
*/	
///////////////////ДАТА И ПУТЬ К ПАПКЕ СЕССИИ ///////////////////////////////////////////////////
	QDateTime dt(QDateTime::currentDateTime());
    QString time = dt.toString("dd.MM.yyyy"),   // Строка текущей даты
            str(DIR_PATH);
           
    str.append("session_" + time);
    main_path = str;      // Абсолютный путь к папке сессии	- в глобальную переменную main_path


///////////////////////////////// ПАПКА СЕССИИ ////////////////////////////////////////////////
    
	QDir dir;
    if (!dir.exists(main_path)) {
        if (!dir.mkdir(main_path)) {
            // Отправить сообщение о проблеме в DISPATCHER - папка сессии не создана
			QVariantList list;
			list.clear();
			list.append("Session_folder_not_created");		
			emit s_send_dispatcher_data(list);
            return;
        }
    } // Создали папку сессии D:\\comp_data\\sessions\\session_21.12.2023


///////////////////////////////// ОСН. ФАЙЛ СЕССИИ ////////////////////////////////////////////
 

    QFile f(main_path + "\\" + "_session_" + time + ".txt");
    if(!f.open(QIODevice::ReadWrite)) {
        // Отправить сообщение о проблеме в DISPATCHER - основной файл сессии не создан
		QVariantList list;
		list.clear();
		list.append("Session_file_not_created");		
		emit s_send_dispatcher_data(list);
		return;
    }
    f.close();
    // Создали основной файл сессии D:\\comp_data\\_sessions\\session_21.12.2023.txt
	
///////////////////////////////// INFO ФАЙЛ СЕССИИ ////////////////////////////////////////////
 	

    if(!f.copy(main_path + "\\" + "_info_" + time + ".txt")) {
       // Отправить сообщение о проблеме в DISPATCHER - info файл сессии не создан
		QVariantList list;
		list.clear();
		list.append("Info_file_not_created");		
		emit s_send_dispatcher_data(list);
		return;
    }
    // Создали info файл сессии D:\\comp_data\\_sessions\\_info_21.12.2023.txt
	

//////// СОЗДАНИЕ ФАЙЛОВ ДЕВАЙСОВ СЕССИИ И НАЧАЛЬНОЕ ЗАПОЛНЕНИЕ ////////////////////////////
 	
	QString help_str,
	        dev_list,
			dev_info; 
	dev_list.clear();			
	
	// Перед записью данных очищаем рабочий список work_queue_dev_list
	work_queue_dev_list.clear(); 
		
	for(int i = 0; i < start_queue_dev_list.size(); ++i) {	
		
		//dev_info - SpectaOld_1234567
		dev_info = start_queue_dev_list.at(i).get_name() + "_" + start_queue_dev_list.at(i).get_ser_num();
		
		// Абсолютный путь к файлу девайса
		help_str.clear();
		help_str.append(main_path + "\\" + dev_info + ".txt");		
		
		// Формируем список девайсов для осн. файла сессии
		dev_list.append(dev_info + "\n");		
		
		if(!f.copy(help_str)) {
			// Отправить сообщение о проблеме в DISPATCHER - не создан файл девайса
			QVariantList list;
			list.clear();
			list.append("Device_file_not_created");
			list.append(dev_info);
			emit s_send_dispatcher_data(list);
			return;
			
		}
		
		else {  		
            //start_queue_dev_list.at(i).set_path(help_str);
            InfoDev& dev = start_queue_dev_list[i];
            dev.set_path(help_str);
			// Копируем данные в рабочий список work_queue_dev_list 
			work_queue_dev_list.append(start_queue_dev_list.at(i));
			
			/*			
					Вносим стартовые данные девайса
				unfinished\n    
				SpectaOld_1234567\n
				type_1\n	
			*/			
			dev_info.prepend("unfinished\n");
			dev_info.append("\ntype_" + QString::number(start_queue_dev_list.at(i).get_type())  + "\n");
			
            if(!add_data_to_file(help_str, dev_info)) {
				//Отправить сообщение о проблеме в DISPATCHER - проблема с записью данных в файл девайса
				QVariantList list;
				list.clear();
				list.append("Error_writing_to_device_file");
				list.append(dev_info);
				emit s_send_dispatcher_data(list);
				return;
			}
		
		}
		
	} // Создали набор файлов девайсов сессии с первичными данными
	
		
/////////////////////////////////ЗАПИСЬ ДАННЫХ В ОСН. ФАЙЛ СЕССИИ ///////////////////////////
 	
/*
	name_Ivanov\n  (name + фамилия регулировщика)     "name_" + adjuster_name + "\n" 
	date_01.01.2023\n  (date + дата)                  "date_" + time + "\n"
	Spectra_1234567.txt\n                             dev_list
	Spectra_New_2345678.txt\n
	Cadmium_3456789.txt\n
	Guarder_4567889.txt\n
*/	
	dev_list.prepend("date_" + time + "\n");
    dev_list.prepend("name_" + adjuster_name + "\n");

    QString help_path(main_path + "\\" + "_session_" + time + ".txt");
	
	if(!add_data_to_file(help_path, dev_list)) {
		//Отправить сообщение о проблеме в DISPATCHER - проблема с записью данных в файл сессии
		QVariantList list;
		list.clear();
		list.append("Error_writing_to_session_file");		
		emit s_send_dispatcher_data(list);
		return;
	}
	
	// Отправить сообщение о удачном создании файлов и готовности к работе в DISPATCHER
	
	QVariantList list;
	list.clear();
	list.append("correct_connect");		
	emit s_send_dispatcher_data(list);
	
}


inline bool Devices::add_data_to_file(QString path, QString &data) {
	
	QFile f(path);

	if(f.exists()) {		
		QByteArray buff(data.toUtf8());
		
		if (f.open(QIODevice::Append)) {  // Открываем файл на дозапись
			if(f.write(buff) == buff.size()) {
				f.close();
				return true;  // Запись успешна 
			}

			else 
				return false; // Проблемы
		}		
	}	
}

inline QString Devices::get_adjuster_name() {
	return adjuster_name;	
}

inline void Devices::set_adjuster_name(QString _name) {
	adjuster_name = _name;	
}


inline int Devices::get_select_dev_num() {		
	return glob_select_dev_num;	
}

inline void Devices::set_select_dev_num(int _num) {
	glob_select_dev_num = _num;	
}


inline	QString Devices::get_main_path() {
	return main_path;
}

inline	void Devices::set_main_path(QString _main_path) {
	main_path = _main_path;	
}



inline void Devices::add_device_func(QString path) {
/*
					АЛГОРИТМ
		имеем get_main_path() return main_path - путь к папке сессии
		имеем path - путь к файлу нужного девайса
			- перемещаем файл в папку сессии (если там такого нет)
			- открываем файл и проверяем корректность данных
			- Если ОК:
				- вносим в рабочий список данные
				- закрываем файл
				- отправляем сигнал в Dispatcher с данными прибора для внесения в табл.
			- Если NO:
				- удаляем файл
				- отправляем сигнал в Dispatcher с описанием проблемы
		
	*/		
}

inline void Devices::del_device_func(int posit, bool flag) {
	
/*
					АЛГОРИТМ
		- имеем позицию девайса в рабочем списке work_queue_dev_list
		- проверяем размер work_queue_dev_list , если норм, удаляем позицию
		- проверяем флаг:
			- если ОК:
				- удаляем девайс из фала сесиии
				- переносим файл девайса в папку "Незаконченные девайсы"
				- отправляем сообщение в Dispatcher (для передачи команды
				  в QML для удаления девайса из таблицы	
				  
				  
		// Сигнал передачи данных в dispatcher
		void s_send_dispatcher_data(QVariantList);
		
		["delete_dev", 5 , true, QString()]  - в случае корректно выполненной операции
		
		для дальнейшей передачи в QML  void qml_send_array(QVariantList); 
		
		["delete_dev", 5 , true, Problems] - в случае ошибки -  с описанием ошибки
		
		для дальнейшей передачи в QML  qml_send_text(QString)
		
*/			
	
	
}

inline void Devices::start_after_recon() {
	
/*
				АЛГОРИТМ				
	- переподключение прошло успешно, нужно вернуться к работе
      с точки останова					
*/
	
	
}

inline void Devices::start_after_reload() {
	
/*
				АЛГОРИТМ				
	- загрузка данных прошлой сессии  прошла успешно, нужно вернуться к работе
      с точки останова. Отправить в Devices список "неотработанных"  и
	  "отработанных" температур 					
*/	
	
}

inline void Devices::start_work_system() {

/*
				АЛГОРИТМ				
	- загрузка данных прошлой сессии  прошла успешно, нужно вернуться к работе
      с точки останова					
*/		
	
	
	
}


//inline void Devices::set_work_mode(Work_Mode _mode)
//{
//    work_mode = _mode;
//}

//inline Devices::Work_Mode Devices::get_work_mode()
//{
//    return work_mode;
//}

inline void Devices::set_temp_control_mode(Temp_Control_Mode _mode) {
	temp_control_mode = _mode;
}

inline Devices::Temp_Control_Mode Devices::get_temp_control_mode() {
	return temp_control_mode;
}

inline void Devices::set_target_temp(double _temp){
	target_temp = _temp;
}

inline double Devices::get_target_temp(){
	return target_temp;
}

inline void Devices::switch_dev_temp_control(){
	/*
		Ф-цию используем для:
			- очистки и закрытия порта
			- выбора следующего девайса
	*/
	if(ser_port->isOpen()) {
		ser_port->clear();	
		close_port();
	}	
    set_temp_control_mode(SWITCH_DEVt);
    temp_control_timer->start(ID_TIMER_PAUSE);	
}

inline qint8 Devices::byte_select_func(QByteArray &buff, int posit)
{
    return static_cast<qint8>(buff.at(posit));
}

inline double Devices::get_2_temp_func(QByteArray &buff, int global_type)
{
    double d_temp;
	
	if(global_type >= 0 && global_type <= 3) {
	
		qint8 l_byte =  byte_select_func(buff, 8);  // 8 - posit LSB byte temp
		qint8 m_byte =  byte_select_func(buff, 9);  // 9 - posit MSB byte temp
		qint16 res = l_byte + (m_byte << 8);
		
		if((res & 0x8000) == 0x8000) 		
			d_temp = (static_cast<double>(res - 65536))/128.0; 
		
		else 
			d_temp = (static_cast<double>(res))/128.0; 

	}
	
    return d_temp;
}


inline void Devices::proc_temp_control_timer() {

    Temp_Control_Mode local_mode  = get_temp_control_mode();

    if(local_mode == SWITCH_DEVt) {            // Выбор следующего девайса
		emit s_temp_control(QVariantList());  
        return;
    }
	
	QVariantList data_list;
    data_list.clear();
	
	QByteArray rec_buff;
    rec_buff.clear();

    while(ser_port->bytesAvailable())   // Вычитываем все данные из порта и очищаем порт
        rec_buff.append(ser_port->readAll());
    ser_port->clear();	
	
	 if(!rec_buff.size()) {  // Нет ответа  - переходим к следующему девайсу
		/*
			Данные записались в порт, но девайс не ответил:
		    нужно внести -50.0 в temp_dev_list  temp_dev_list.append(-50.0); 
		*/
		temp_dev_list.append(-50.0); 			 
        emit s_temp_control(data_list);  // data_list.isEmpty()
		
        return;
    }
	
    if(local_mode == ON_DEVt) { // Девайс включился
	
        if(rec_buff.size() >= 7){  // Корректный пакет    // QVariant (true, 1, int ID)
			
			// Проверка пакета включения ???????????????????????????????????????		
		
            data_list << 1 << 1 ;   // 1 на 0 позиции - включение девайса			
            emit s_temp_control(data_list);			
            return;
        }

        else {			
			/*
				Данные записались в порт, но девайс ответил некорректно:
				нужно внести -50.0 в temp_dev_list  temp_dev_list.append(-50.0); 
			*/			
            temp_dev_list.append(-50.0); 	 
			emit s_temp_control(data_list);			
            return;
        }
    }	
	
	if(local_mode == GET_TEMP) { // Девайс дал температуру
	
		if(global_type >= 0 && global_type <= 3) {
			
			if(rec_buff.size() < 10) {
				/*
					Некорректный ответ на запрос температуры - размер ответа < 10
					нужно внести -50.0 в temp_dev_list  temp_dev_list.append(-50.0); 
				*/			
				temp_dev_list.append(-50.0); 	 
				emit s_temp_control(data_list);			
				return;			
			}
		}		
		 			
		double d_temp = get_2_temp_func(rec_buff, global_type); 
		
		data_list << 2 << d_temp;

		emit s_temp_control(data_list);

		return;
	}	
}


inline void Devices::temp_control(QVariantList list) {
	
//////////////////////   НАЧАЛО ИЛИ ВЫБОР СЛЕДУЮЩЕГО ДЕВАЙСА ////////////////////////

	static int st_posit = -1,  // статический порядковый номер эл-та в work_queue_dev_list;
               st_type ;       // статический номер типа девайса, с которым работаем

	QString st_port;

	if(list.isEmpty()) {  // list.isEmpty() - начало или выбор нового девайса
	
		++st_posit;
		
		if(st_posit >= work_queue_dev_list.size()) {	
		
			/*
				Все девайсы перебраны:
					- статические переменные - в начальное состояние
					- чистим и закрываем СОМ-порт
					- режим - SWITCH_DEV (опять начнем опрос с начала)
					- запуск таймера temp_control_timer на 2 минуты					
					- отправляем список temp_dev_list в Dispatcher	
			*/
			
			st_posit = -1;
			
			if(ser_port->isOpen()) {
				ser_port->clear();	
				close_port();
			}	
            set_temp_control_mode(SWITCH_DEVt);
			temp_control_timer->start(120000);	// 2 мин
			
			emit s_send_temp_list(temp_dev_list);
			
			return;			
		}
		
		// Имеем тип следующего прибора		
		st_type = work_queue_dev_list.at(st_posit).get_type();
		
		// Имеем СОМ-порт следующего прибора
		st_port = work_queue_dev_list.at(st_posit).get_port(); 
		
		if(open_port(st_port, st_type)) { // Порт открылся c нaстройками по st_type

            // Включаем девайс
            if(send_data(rec_on_dev.at(st_type))) {   // Данные записаны в порт
			
                set_temp_control_mode(ON_DEVt);        // Режим включения девайса
				
                temp_control_timer->start(ID_TIMER_PAUSE);
				
                return;
            }
        }		
		
		// Если не открылся СОМ-порт или запись прошла некорректно - записываем некорректную
		// температуру и вызываем ф-цию переключения прибора		 
		temp_dev_list.append(-50.0); 
        switch_dev_temp_control();
		
        return;		
	}
	
	
	 else { // Девайс ответил

        int order = list.at(0).toInt();  // 0 байт списка - тип команды

        if(order == 1) {  // Включение девайса   
		
			int posit;
			
			global_type = st_type; // Глобальный тип девайса для обработки в таймере
			
			/*
				Девайс включился, нужно выбрать массив запроса температуры
				в соответствии с типом девайса и целевой температурой
			*/
			// Cadmium, Specta и Spectra New
			if(st_type >= 0 && st_type <= 2 ) { 
			
				if(target_temp >= 20)   // "Верхний" пакет Spectra 20 - 50
					posit = 1;			
				
				else  // "Нижний" пакет Spectra -20 - 10
					posit = 2;				
			}
			
			// Guarder
			else if(st_type == 3)   // buff = rec_get_curr_temp.at(1);
				posit = 3;
				
			// Посылаем запрос температуры девайса
            if(send_data(rec_get_curr_temp.at(posit))) {   // Данные записаны в порт			
                set_temp_control_mode(GET_TEMP); // Режим запроса температуры  				
                temp_control_timer->start(ID_TIMER_PAUSE);				
                return;
            }
			
			// Если запись прошла некорректно - записываем некорректную
			// температуру и вызываем ф-цию переключения прибора		 
			temp_dev_list.append(-50.0); 
			switch_dev_temp_control();			
			return;				
		}
		
		else if(order == 2) {   // Девайс дал температуру
		
			// точка ОТВЕТА ДЕВАЙСА (ТЕМПЕРАТУРА)

			double temp = list.at(1).toDouble();

            if(send_data(rec_off_dev.at(st_type))) { // Данные записаны в порт
				/*
					Имеем температуру, и корректно записали
					выключение девайса
				*/
				temp_dev_list.append(temp);     // Записываем реальную температуру девайса
                set_temp_control_mode(SWITCH_DEVt);
                temp_control_timer->start(ID_TIMER_PAUSE);
                return;
            }

			// Если запись прошла некорректно - записываем некорректную
			// температуру и вызываем ф-цию переключения прибора		 
			temp_dev_list.append(-50.0); 
			switch_dev_temp_control();
			
			return;		
		}		
	}	
}


inline void Devices::stop_temp_control_timer() {
	temp_control_timer->stop();	
}































#endif // DEVICES_H
