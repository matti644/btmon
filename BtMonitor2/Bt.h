#ifndef Bt_H
#define Bt_H

#include <QObject>
#include <QtBluetooth>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QtBluetooth/qbluetoothaddress.h>
#include <QtBluetooth/qbluetoothserviceinfo.h>
#include "container.h"

class Bt : public QObject
{
Q_OBJECT
public:
explicit Bt (QObject *parent = 0);


signals:
    void socketErrorOccurred(const QString &errorString);
    //void messageReceived(const QString &sender, const QString &message);
    void readedSocket(QString i);

public slots:


private slots:
    Q_INVOKABLE void serviceDiscovered(const QBluetoothServiceInfo &service);
    void readSocket();
    void onSocketErrorOccurred(QBluetoothSocket::SocketError);
    void insert(container cont);
    void parse(QString s);
    std::vector<std::string> parseJson(std::string strToSplit, char delimeter);

private:
    QBluetoothSocket *socket = nullptr;
};

#endif // Bt_H
