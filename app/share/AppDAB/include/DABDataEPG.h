#ifndef DABDATAEPG_H
#define DABDATAEPG_H

#include <QObject>

class DABDataEPG : public QObject
{
    Q_OBJECT

public:
    explicit DABDataEPG(QObject *parent = 0);
    //DABDataEPG(int hour, int minute, int second, int duration, QString strLabel, QString strDesc, QObject *parent = 0);

    inline int getHour(void) {return Hour;} const
    inline int getMinute(void) {return Minute;}
    inline int getSecond(void) {return Second;}
    inline int getDuration(void) {return Duration;}
    inline QString getProgramLabel(void) {return ProgramLabel;}
    inline QString getDescription(void) {return Description;}

    //void debugOut(void);
    /*
    inline DABDataEPG& operator=(const DABDataEPG& a) {
        this->Hour = a.Hour;
        return *this;
    }*/

signals:

public slots:


public:
    int Hour;
    int Minute;
    int Second;
    int Duration;
    int ProgramLabelLength;
    QString ProgramLabel;
    int DescriptionLength;
    QString Description;
};

#endif // DABDATAEPG_H
