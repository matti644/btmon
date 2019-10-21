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
    //Q_PROPERTY(container values[] MEMBER buffer)

signals:
    void socketErrorOccurred(const QString &errorString);
    //void messageReceived(const QString &sender, const QString &message);
    void readedSocket(QList<QVariant> atalante, QList<QVariant> tamamo);

public slots:
    QList<QVariant> values();

private slots:
    Q_INVOKABLE void serviceDiscovered(const QBluetoothServiceInfo &service);
    void readSocket();
    void onSocketErrorOccurred(QBluetoothSocket::SocketError);
    void insert(int ki, float ke);
    void parse(QString s);
    std::vector<std::string> parseJson(std::string strToSplit, char delimeter);

private:
    QBluetoothSocket *socket = nullptr;
    //container * buffer[100] = {};
    QList<QVariant> kissa;
    QList<QVariant> kettu;
    int buffer[100] = {};
    float bufferf[100] = {};

};

#endif // Bt_H
