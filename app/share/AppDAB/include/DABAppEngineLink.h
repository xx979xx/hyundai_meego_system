#ifndef DABAPPENGINELINK_H
#define DABAPPENGINELINK_H

//#include <QObject>
#include <DHAVN_QCANController_ApplnTxRxStruct.h>
#include "EngModeIf.h"
#include "DABProtocol.h"
#include "DABApplication_Def.h"

class DABAppEngine;
class DABAppEngineLink : public QObject
{
    Q_OBJECT
public:
    explicit DABAppEngineLink(DABAppEngine &adabAppEngine, QObject* parent = 0);
    ~DABAppEngineLink();

    void ConnectionCreate();
    bool isEnableSystemPopup(void);
    int checkAudioPath(void);
    void checkEPGPopupVisible(void);
    //bool eventFilter(QObject *pFromObj, QEvent *pEvent);

signals:
    //void cmdReqTA(bool bDABAudioOpen);
    //void cmdReqCancelTrafficAnnouncement(bool onOff);
    //void Can_data_send(const SQCanFrame &c_data);
    void cmdCancelEPGReservation(bool isSystemPopup);
    void cmdReqCancelTrafficAnnouncement(bool onOff);
    void cmdEventExceptionHandler(eDAB_EVENT_TYPE event);
    void displayTAPopup(QString serviceName, quint16 flags, bool onOff);
    void cmdReqCancelAlarmAnnouncement(void);
    void closeEPGDescPopup(void);
    void closeEPGFullPopup(void);
    void closeEPGDateListPopup(void);
    void closeEPGOffAirPopup(void);

public slots:
    //void onRspTrafficRDStoDAB(bool onOff);
    void onReqDisplayOSD(QString str1, QString str2, quint8 op_type);
    QString modifyOSDLow(QString strOSD, QString str1, QString str2, quint8 op_type);
    QString modifyOSDHigh(QString strOSD, QString str1, QString str2, quint8 op_type);
    void onOSDUpdate(void);
    void onReqClusterControl(QString serviceName, quint8 presetNumber, quint8 opState);
    void onReqDABSoundOn();
    void onReqDisplayStatusBar(quint8 type, bool onOff);
    void PostKeyEvent(KEY_EVENT_DATA_T *message, Qt::Key key);
    void PostJogEvent(KEY_EVENT_DATA_T *message, EVT_COMMAND_T keyCount);
    void onLgeDBus_DABPICodeRequest(quint16 playPICode);
#ifdef __ENG_MODE__
    void onReqVersion(QString ver);
    void onReqConnectivity(int in0);
    void onReqDiagnosis();
#endif
    void onReqRadioEnd(int band, quint16 playPICode);
    void onReqDABtoFM(quint16 playPICode);
    void onReqEPGPreservePopup(QString title, QString serviceName);
    void onReqTAStart(quint16 flag, QString serviceName);
    void onReqTAStop(void);
    void onReqAlarmStart(quint16 flag, QString serviceName);
    void onReqAlarmStop(void);
    void closeSystemPopup(eDAB_SYSTEM_POPUP_TYPE m_ePopupType);
    void startDABtoFMTimer(void);
    void stopDABtoFMTimer(void);
    void onReqTASearchPopup(bool onOff);

private:
DABAppEngine &m_DABAppEngine;
#ifdef __ENG_MODE__
    EngModeIf* m_engClient ;
#endif
};

#endif // DABAPPENGINELINK_H
