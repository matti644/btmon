#ifndef CONTAINER_H
#define CONTAINER_H
#include <QObject>

class container : public QObject
{
Q_OBJECT
public:
    explicit container (QObject *parent = 0);
    Q_INVOKABLE int mon1() {
        return monitor1;
    }
    int monitor1;
    float monitor2;
    //Q_PROPERTY(int mon1 MEMBER monitor1)
    //Q_PROPERTY(float mon2 MEMBER monitor2)

signals:

public slots:
};

#endif // CONTAINER_H
