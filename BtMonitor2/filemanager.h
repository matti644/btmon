#include <QObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QVariantList>
#include <QVariant>
#include <QDateTime>

#ifndef FILEMANAGER_H
#define FILEMANAGER_H


class FileManager : public QObject
{
Q_OBJECT

public:
    explicit FileManager (QObject *parent = 0);

signals:

public slots:
    QList<QVariant> getSavedFiles();
    void save(QList<QVariant> Monitor1, QList<QVariant> Monitor2);
    QList<QVariant> load(QVariant index, int monitor);
    QList<QVariant> getSavedMonitor(int index);

private slots:

private:
    QList<QVariant> FullPaths;
    QString dirPath;

};

#endif // FILEMANAGER_H
