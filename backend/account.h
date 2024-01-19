#ifndef ACCOUNT_H
#define ACCOUNT_H

#include <QObject>
#include <QFile>
#include <QDateTime>

class Account
{
public:
    Account(){

    };

public slots:
    void login(const QString &, const QString &);
    void logout();
    void loadUserBase(const QString &);

private:
    QString _userName;
    QDateTime _lastLogin;

};

inline void Account::login(const QString &userName, const QString &password)
{

}

inline void Account::logout()
{

}

inline void Account::loadUserBase(const QString &path)
{

}

#endif // ACCOUNT_H
