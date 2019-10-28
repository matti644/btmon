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
    for (int i = 0; i < 100; i++) {
        // Prefill buffer to 100
        // For ease of use on the UI side
        mon1Buffer.append(0);
        mon2Buffer.append(0.0);
    }

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
        qDebug() << "Found the correct device, attempting to create a socket";
        socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
        socket->connectToService(service, QIODevice::ReadWrite);

        //connect(socket, &QBluetoothSocket::canReadLine, this, &Bt::readSocket);
        connect(socket, &QIODevice::readyRead, this, &Bt::readSocket);
        connect(socket, QOverload<QBluetoothSocket::SocketError>::of(&QBluetoothSocket::error),
                this, &Bt::onSocketErrorOccurred);

        qDebug() << "done creating socket";
    }
}

void Bt::readSocket()
{
    if (!socket)
    {
        qDebug() << "no socket";
        return;
    }
    while (socket->canReadLine()) {
        QByteArray line = socket->readLine().trimmed();
        parse(line);

        emit socketDataRead(mon1Buffer, mon2Buffer);
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

        //container * c = new container();
        //c.monitor1 = std::stoi(temp[0]);
        //c->monitor1 = std::stoi(temp[0]);
        //c->monitor2 = std::stof(temp[1]);

        insert(std::stoi(temp[0]), std::stof(temp[1]));
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

void Bt::insert(int m1, float m2)
{
    // Keep an even amount of 100 data points in the buffer
    // Eases the use on UI
    mon1Buffer.append(m1);
    mon2Buffer.append(m2);

    mon1Buffer.removeAt(0);
    mon2Buffer.removeAt(0);
}
