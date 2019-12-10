#include <QDebug>

#include "filemanager.h"

FileManager::FileManager(QObject *parent) :
    QObject(parent)
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
    QDir dir(path);

    if (!dir.exists())
        dir.mkpath(path);

    if (!dir.exists("saved"))
        dir.mkdir("saved");

    dir.cd("./saved");

    dirPath = dir.path();
}

QList<QVariant> FileManager::getSavedFiles() {
    QList<QVariant> ret;

    QDir dir(dirPath);

    QStringList files = dir.entryList(QStringList() << "*.btlog", QDir::Files);

    qDebug() << "FileManager -> files.length() = " << files.length();

    // If no files exist, return it immediately
    if (files.length() == 0)
        return ret;


    foreach (QString filename, files)
    {
        ret.append(QVariant(filename));
        FullPaths.append(QDir::cleanPath(dir.path() + "/" + filename ));
    }

    return ret;
}

void FileManager::save(QList<QVariant> Monitor1, QList<QVariant> Monitor2) {
    QString save("");
    qDebug() << "Initialize saving";

    foreach (QVariant QVar, Monitor1)
    {
        save.append(QVar.toString() + ",");
    }

    // Remove the last ','
    save = save.left(save.lastIndexOf(QChar(',')));
    save.append(QString("\n"));

    foreach (QVariant QVar, Monitor2)
    {
        save.append(QVar.toString() + ",");
    }

    save = save.left(save.lastIndexOf(QChar(',')));

    QString curTimeString = QString::number(QDateTime::currentSecsSinceEpoch());

    // Build the file path for the file and write it
    QString path = QDir(dirPath).filePath(curTimeString + ".btlog");
    QFile file(path);

    file.open(QIODevice::WriteOnly | QIODevice::Text);
    file.write(save.toUtf8());
    file.close();
}

QList<QVariant> FileManager::load(QVariant index, int monitor){
    QList<QVariant> saved = getSavedFiles();

    QString path = QDir(dirPath).filePath(QVariant(saved[index.toInt()]).toString());
    QFile file(path);

    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString loaded = file.readAll();
    file.close();


    QStringList monitors = loaded.split( "\n", QString::SkipEmptyParts );

    QStringList MonitorDataToReturn = monitors[monitor].split(",", QString::SkipEmptyParts);

    QList<QVariant> returnData;

    foreach(QString data, MonitorDataToReturn)
    {
        returnData.append(data);
    }
    return returnData;
}

QList<QVariant> FileManager::getSavedMonitor(int index) {
    QList<QVariant> ret;

    return ret;
}


