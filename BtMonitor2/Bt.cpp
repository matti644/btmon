#include "Bt.h"
#include <QDebug>
#include <QtBluetooth>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QIODevice>
#include <vector>
#include <sstream>
#include <string>
#include "container.h"

Bt::Bt(QObject *parent) :
QObject(parent)
{
    QBluetoothLocalDevice localDevice;
    QString localDeviceName;
    //connect(socket, &QIODevice::readyRead, this, &Bt::readSocket);
    // Check if Bluetooth is available on this device
    if (localDevice.isValid()) {

        // Turn Bluetooth on
        localDevice.powerOn();

        // Read local device name
        localDeviceName = localDevice.name();

        // Make it visible to others
        localDevice.setHostMode(QBluetoothLocalDevice::HostDiscoverable);

        // Get connected devices
        QList<QBluetoothAddress> remotes;
        remotes = localDevice.connectedDevices();


        qDebug() << "started discovery";
        QBluetoothServiceDiscoveryAgent *discoveryAgent = new QBluetoothServiceDiscoveryAgent(this);

        // Create a discovery agent and connect to its signals
        connect(discoveryAgent, SIGNAL(finished()), discoveryAgent, SLOT(stop()));
        connect(discoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)),
                this, SLOT(serviceDiscovered(QBluetoothServiceInfo)));

        discoveryAgent->start();
    }
}

// In your local slot, read information about the found devices
void Bt::serviceDiscovered(const QBluetoothServiceInfo &service)
{
    //qDebug() << "Found new device:" << service.device().address().toString() << " " << service.serviceName();
    if(service.device().address().toString() == "B8:27:EB:43:05:5D" && service.serviceName() == "Serial Port Profile")
    {
        qDebug() << "yeet";
        socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
        socket->connectToService(service, QIODevice::ReadWrite);

        //connect(socket, &QBluetoothSocket::canReadLine, this, &Bt::readSocket);
        connect(socket, &QIODevice::readyRead, this, &Bt::readSocket);
        connect(socket, QOverload<QBluetoothSocket::SocketError>::of(&QBluetoothSocket::error),
                this, &Bt::onSocketErrorOccurred);

        qDebug() << "done creating socket";
    }
}

static container buffer[100] = {};

void Bt::readSocket()
{
    if (!socket)
    {
        qDebug() << "no socket";
        return;
    }
    QString str;
    while (socket->canReadLine()) {
        QByteArray line = socket->readLine().trimmed();
        parse(line);
        for(int i=0;i<100;i++)
        {
            str += QString::number(buffer[i].monitor1);
            str += "_";
            str += QString::number(buffer[i].monitor2);
            str += " ";
        }
        emit readedSocket(str);
    }
}

void Bt::onSocketErrorOccurred(QBluetoothSocket::SocketError error)
{
    if (error == QBluetoothSocket::NoSocketError)
        return;

    QMetaEnum metaEnum = QMetaEnum::fromType<QBluetoothSocket::SocketError>();
    QString errorString = socket->peerName() + QLatin1Char(' ')
            + metaEnum.valueToKey(error) + QLatin1String(" occurred");
}


void Bt::parse(QString s)
{
    std::vector<std::string> objects;
    objects = parseJson(s.toUtf8().constData(), ';');

    foreach (std::string dataTick, objects) {
        std::vector<std::string> temp = parseJson(dataTick, ',');
        container c;
        c.monitor1 = std::stoi(temp[0]);
        c.monitor2 = std::stof(temp[1]);

        insert(c);
    }
}

std::vector<std::string> Bt::parseJson(std::string s, char delimeter)
{
    std::stringstream ss(s);
    std::string item;
    std::vector<std::string> splittedStrings;
    while (std::getline(ss, item, delimeter))
    {
       splittedStrings.push_back(item);
    }

    /*std::vector<std::string> splittedStrings;
    std::string delimiter = "\"py/object\": \"__main__.container\"},";
    size_t pos = 0;
    while ((pos = s.find(delimiter)) != std::string::npos) {
        splittedStrings.push_back(s.substr(0, pos));

        s.erase(0, pos + delimiter.length());
    }*/

    return splittedStrings;
}

void Bt::insert(container cont)
{
    memmove(&buffer[0], &buffer[1], (sizeof (cont) * 100));

    buffer[99] = cont;
}
