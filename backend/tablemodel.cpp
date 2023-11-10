#include "tablemodel.h"

CoeffTableModel::CoeffTableModel(QObject *parent)
{
    // Инициализация данных вашей таблицы. Замените эти значения на ваши данные.
    QList<QVariant> headerData;
    headerData << "" << "60°C" << "50°C" << "40°C" << "30°C" << "20°C" << "10°C" << "0°C" << "-10°C" << "/" << "Поточні";  // Add your header data
    this->setHeaderData(headerData);

    QList<QVariant> temperatureRow;
    temperatureRow << "Температура" << 60 << 50 << 40 << 30 << 20 << 10 << 0 << -10 << "" << -30;
        tableData.append(temperatureRow);

    QList<QVariant> uzmRow;
    uzmRow << "Uзм" << 1200 << 1150 << 1100 << 1000 << 900 << 850 << 800 << 780 << "Uзм" << 740;
    tableData.append(uzmRow);

    QList<QVariant> zsuwRow;
    zsuwRow << "Зсув" << 3 << 3 << 3 << 3 << 4 << 4 << 4 << -5 << "Ku" << 5;
        tableData.append(zsuwRow);

    QList<QVariant> noiseRow;
    noiseRow << "Шум" << 2 << 2 << 1 << 1 << 0 << 0 << 0 << 0 << "Шум" << 0;
    tableData.append(noiseRow);

    //test
    m_variantList << "/" << "60°C" << "50°C" << "40°C" << "30°C" << "20°C" << "10°C" << "0°C" << "-10°C" << "-20°C" << "-30°C";

}

int CoeffTableModel::rowCount(const QModelIndex &parent) const
{
    return tableData.size();
}

int CoeffTableModel::columnCount(const QModelIndex &parent) const
{
    if (tableData.isEmpty())
        return 0;
    return tableData.at(0).size();
}

QVariant CoeffTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || role != Qt::DisplayRole)
        return QVariant();

    int row = index.row();
    int col = index.column();

    if (row < 0 || row >= tableData.size() || col < 0 || col >= tableData.at(0).size())
        return QVariant();

    return tableData.at(row).at(col);
}

QVariant CoeffTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole)
        return QVariant();

    if (orientation == Qt::Horizontal) {
        if (section < 0 || section >= m_headerData.size())
            return QVariant();
        return m_headerData.at(section);
    }

    return QVariant();
}

bool CoeffTableModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
//    if (section < 0 || section >= m_headerData.size())
//        return false;

//    m_headerData[section] = value.toString();  // Update the header data
//    emit headerDataChanged(Qt::Horizontal, section, section);  // Emit the signal
    return true;
}


Qt::ItemFlags CoeffTableModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEnabled | Qt::ItemIsSelectable;
}

bool CoeffTableModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (role != Qt::EditRole)
        return false;

    int row = index.row();
    int col = index.column();

    if (row < 0 || row >= tableData.size() || col < 0 || col >= tableData.at(0).size())
        return false;

    tableData[row][col] = value;
    // Emit the dataChanged signal to inform the view that the data has changed
    emit dataChanged(index, index, {role});

    //dispaly changed value
    qDebug() << tableData;

    return true;
}

void CoeffTableModel::setHeaderData(const QList<QVariant> hData)
{
    m_headerData = hData;
    emit headerDataModified(m_headerData);  // Emit the custom signal
    //qDebug() << "Header data modified:" << m_headerData;
}

void CoeffTableModel::reciveTest(int test)
{
    QList<QVariant> headerData;

    switch (test) {

    case 0:

        headerData << "/" << "60°C" << "50°C" << "40°C" << "30°C" << "20°C" << "10°C" << "0°C";
        setHeaderData(headerData);
        qDebug() << "Header data modified:" << m_headerData;

        break;


    default:
        break;
    }

}

bool CoeffTableModel::insertRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || row > tableData.size())
        return false;

    beginInsertRows(parent, row, row + count - 1);

    for (int i = 0; i < count; ++i) {
        QList<QVariant> newRow(tableData.at(0).size());
        tableData.insert(row + i, newRow);
    }

    endInsertRows();

    return true;
}

bool CoeffTableModel::insertColumns(int column, int count, const QModelIndex &parent)
{
    if (column < 0 || column > tableData.at(0).size())
        return false;

    beginInsertColumns(parent, column, column + count - 1);

    for (int i = 0; i < count; ++i) {
        for (int j = 0; j < tableData.size(); ++j) {
            tableData[j].insert(column + i, QVariant());
        }
    }

    endInsertColumns();

    return true;
}

bool CoeffTableModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || (row + count) > tableData.size())
        return false;

    beginRemoveRows(parent, row, row + count - 1);

    for (int i = 0; i < count; ++i) {
        tableData.removeAt(row);
    }

    endRemoveRows();

    return true;
}

bool CoeffTableModel::removeColumns(int column, int count, const QModelIndex &parent)
{
    if (column < 0 || (column + count) > tableData.at(0).size())
        return false;

    beginRemoveColumns(parent, column, column + count - 1);

    for (int i = 0; i < count; ++i) {
        for (int j = 0; j < tableData.size(); ++j) {
            tableData[j].removeAt(column);
        }
    }

    endRemoveColumns();

    return true;
}

