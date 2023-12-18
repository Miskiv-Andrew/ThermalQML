#ifndef DEVICELIST_H
#define DEVICELIST_H

#include <QAbstractListModel>
#include <QObject>
#include <QList>

class DeviceList : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int selectedIndex READ selectedIndex NOTIFY selectedIndexChanged)

public:
    enum DeviceRoles {
        DeviceNameRole = Qt::UserRole + 1,
        ComPortNameRole,
        CurrentTempRole,
        ComplitedTempRole
    };

    struct DeviceItem {
        QString deviceName;
        QString comPortName;
        QString currentTemp;
        QString complitedTemp;
        // Добавьте свои собственные данные, если нужно
    };

    explicit DeviceList(QObject *parent = nullptr);

    // Определение методов, необходимых для работы с QML
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Добавление и удаление элементов
    void addDevice(const DeviceItem &item);

    void clear();

    int selectedIndex() const;

signals:
    void selectedIndexChanged(int index);

public slots:
    void setSelectedIndex(int index);
    void removeDevice(int index);


private:
    QList<DeviceItem> m_deviceItems;
    int m_selectedIndex;
    int m_currentSelectedIndex;
};

inline DeviceList::DeviceList(QObject *parent)
    : QAbstractListModel(parent)
{

}

inline int DeviceList::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_deviceItems.count();
}

inline QVariant DeviceList::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const int row = index.row();

    if (row < 0 || row >= m_deviceItems.count())
        return QVariant();

    const DeviceItem &item = m_deviceItems.at(row);

    switch (role) {
    case DeviceNameRole:
        return item.deviceName;
    case ComPortNameRole:
        return item.comPortName;
    case CurrentTempRole:
        return item.currentTemp;
    case ComplitedTempRole:
        return item.complitedTemp;

    }

    return QVariant();
}

inline QHash<int, QByteArray> DeviceList::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DeviceNameRole] = "deviceName";
    roles[ComPortNameRole] = "comPortName";
    roles[CurrentTempRole] = "currentTemp";
    roles[ComplitedTempRole] = "complitedTemp";
    return roles;
}

inline void DeviceList::addDevice(const DeviceItem &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_deviceItems.append(item);
    endInsertRows();
}

inline void DeviceList::removeDevice(int index)
{
    if (index >= 0 && index < m_deviceItems.size()) {
        beginRemoveRows(QModelIndex(), index, index);
        m_deviceItems.removeAt(index);
        endRemoveRows();

        // Если удаляемый элемент был выбран, обнуляем выбранный индекс
        if (index == m_selectedIndex) {
            m_selectedIndex = -1;
            emit selectedIndexChanged(m_selectedIndex);
        }
    }
}

inline void DeviceList::clear()
{
    beginResetModel();
    m_deviceItems.clear();
    endResetModel();
}


//Методы для обработки когда пользователь выбирает девайс
inline int DeviceList::selectedIndex() const
{
    return m_selectedIndex;
}

inline void DeviceList::setSelectedIndex(int index)
{
    if (m_currentSelectedIndex != -1) {
        // Сбрасываем подсветку для предыдущего выбранного девайса
        QModelIndex previousIndex = createIndex(m_currentSelectedIndex, 0);
        emit dataChanged(previousIndex, previousIndex, {Qt::UserRole});
    }

    if (m_selectedIndex != index) {
        m_selectedIndex = index;
        m_currentSelectedIndex = index;
        emit selectedIndexChanged(m_selectedIndex);

        // Подсвечиваем текущий выбранный девайс
        QModelIndex currentIndex = createIndex(m_selectedIndex, 0);
        emit dataChanged(currentIndex, currentIndex, {Qt::UserRole});
    }
}

#endif // DEVICELIST_H
