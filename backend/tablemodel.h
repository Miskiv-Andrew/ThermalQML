#ifndef TABLEMODEL_H
#define TABLEMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QVariant>

#include <QQmlEngine>

class CoeffTableModel : public QAbstractTableModel
{
    Q_OBJECT


   Q_PROPERTY(QList<QVariant> headerData READ headerData NOTIFY headerDataCreated)
   //testing list
   Q_PROPERTY(QList<QVariant> variantList READ variantList NOTIFY variantListChanged)

public:
    explicit CoeffTableModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    int columnCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role) override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole) override;
    bool insertRows(int row, int count, const QModelIndex &parent) override;
    bool insertColumns(int column, int count, const QModelIndex &parent) override;
    bool removeRows(int row, int count, const QModelIndex &parent) override;
    bool removeColumns(int column, int count, const QModelIndex &parent) override;

    void setHeaderData(const QList<QVariant> hData);

    QList<QVariant> headerData() const { return m_headerData; }

    //testing list
    QList<QVariant> variantList() const { return m_variantList; }

    void readDataFromTable();



private:
    QList<QList<QVariant>> tableData;
    QList<QVariant> m_headerData;  // Member variable to store header data

    //test list
    QList<QVariant> m_variantList;

signals:
    void headerDataCreated();
    void variantListChanged();

    void headerDataModified(QList<QVariant>);

public slots:
    void reciveTest(int);


};



#endif // TABLEMODEL_H
