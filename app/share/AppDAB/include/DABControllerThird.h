#ifndef DABCONTROLLERTHIRD_H
#define DABCONTROLLERTHIRD_H

#include <QObject>
#include "DABLogger.h"
#include "DABProtocol.h"
//#include "DABUIListener.h"

class DABController;

class DABControllerThird : public QObject
{
    Q_OBJECT

public:
    explicit DABControllerThird(DABController &aDABController, QObject *parent = 0);
    ~DABControllerThird();

    void StartTuneTimer(void);
    void StopTuneTimer(void);

signals:
    void cmdStartDABtoFMTimer();
    void closeOptionMenu();
    void displayLinkingIcon(bool isDABtoDAB, bool isDABtoFM, bool isSearching);
    void cmdReqRadioEnd(int band, quint16 frequency);
    void cmdReqdisplayOSD(QString serviceName, QString freqLabel, quint8 op_type);
    void cmdStopDABtoFMTimer();

public slots:
    void onEventExceptionHandler(eDAB_EVENT_TYPE event);
    void onEventExceptionHandlerOne(eDAB_EVENT_TYPE event);
    void onEventExceptionHandlerTwo(eDAB_EVENT_TYPE event);
    void onEventExceptionHandlerThree(eDAB_EVENT_TYPE event);
    void onEventExceptionHandlerFour(eDAB_EVENT_TYPE event);
    void onEventExceptionHandlerFive(eDAB_EVENT_TYPE event);
    void onTuneTimeOut(void);

private:
    DABController &m_DABController;
};

#endif // DABCONTROLLERTHIRD_H
