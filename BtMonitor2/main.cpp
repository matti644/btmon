#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtBluetooth>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QtAndroid>
#include <container.h>
#include <QDataStream>
#include <QTouchEvent>

#include <Bt.h>
#include <filemanager.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    qmlRegisterType<Bt>("Bt", 1, 0, "Bt");
    qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    // Force ask android for location permissions, doesn't seem to happen automatically
    auto result = QtAndroid::checkPermission(QString("android.permission.ACCESS_FINE_LOCATION"));
    if(result == QtAndroid::PermissionResult::Denied){
        QtAndroid::PermissionResultMap resultHash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.ACCESS_FINE_LOCATION"}));
        if(resultHash["android.permission.ACCESS_FINE_LOCATION"] == QtAndroid::PermissionResult::Denied)
            return 0;
    }

    return app.exec();
}
