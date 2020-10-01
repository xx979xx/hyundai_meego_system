#ifndef DABCONTROLLERSECOND_H
#define DABCONTROLLERSECOND_H

#include <QObject>
#include "DABLogger.h"
#include "DABUIListener.h"

class DABController;

class DABControllerSecond : public QObject
{
    Q_OBJECT

public:
    explicit DABControllerSecond(DABController &aDABController, QObject *parent = 0);
    ~DABControllerSecond();

    void SendModuleStatusLow(eEVT_SEND_MODULE_STATUS moduleState, eEVT_SEND_SERVICE_STATUS serviceState);
    void SendModuleStatusHigh(eEVT_SEND_MODULE_STATUS moduleState, eEVT_SEND_SERVICE_STATUS serviceState);

signals:
    void cmdReqdisplayOSD(QString serviceName, QString freqLabel, quint8 op_type);
    void cmdReqClusterControl(QString serviceName, quint8 presetNumber, quint8 opState);
    void cmdSendMuteCancel();
    void cmdReqTrafficDABtoRDS(bool onOff);
    void cmdStopDABtoFMTimer();

public slots:
    void onReqSeekUp(void);
    void onReqSeekDown(void);
    void onReqLongSeekUp(void);
    void onReqLongSeekDown(void);
    void onReqTuneUp(void);
    void onReqTuneDown(void);
    void onReqTunePressed(void);
    void onReqScan(void);
    void onReqPresetScan(void);
    void onReqSeekNextPresetList(void);
    void onReqSeekPrevPresetList(void);
    void onReqTA(bool onOff);
    void onReqTASearch(void);
    void onReqListSelected(int count, QString type);
    void onReqPresetSelected(int count);
    void onReqSetReservationChannel(void);
    void onReqSetAnnounement(bool onOff);
    void onFactoryResetRemoveData(QString path);
    void onExceptionTACancel(bool);
    void onReqTASetting(bool onOff);
    void onReqCancelTrafficAnnouncement(bool onOff);
    void onReqCancelAlarmAnnouncement(void);
    void onSendClusterUpdate(void);
    void onSendOSDUpdate(void);
    void onReqSaveData(bool unsaved);
    void onSettingSlideShow(bool isON);
    void onSettingBandSelection(int mode);
    void onSettingSaveData(void);
    void onReqSetAntennaStatus(quint8 status);
    void onSetCurrentChannelInfo(int serviceID);

    //==================================================     DABCommManager => DABControllerSecond  ===================================
    void EvtSendAnnouncement(QString label, int flag, eEVT_SEND_ANNOUNCEMENT_STATUS status, quint8 subChID);
    void EvtSendModuleStatus(eEVT_SEND_MODULE_STATUS moduleState, eEVT_SEND_SERVICE_STATUS serviceState);
    void EvtSendTime(int year, int month, int day, int hour, int minute, int second);
    void EvtSendQOS(int CER, int SNR, int RSSI, int CER_sub, int SNR_sub, int RSSI_sub);
    void EvtUpdateDLS(quint8 update);
    void EvtUpdateSLS(void);
    void EvtUpdateEPG(void);
    void EvtSendPinkStatus(quint8 status);
    void EvtSendSignalInfo(quint8 status);
    void CmdAddStationLogo(QString filename);
#ifdef __DTC__
    void EvtSendDtcUart(void);
#endif

public:
    void onReqExceptionSetAnnounement(bool onOff);

    bool cameraOnOff;

private:
    DABController &m_DABController;

    void createConnection(void);

};

#endif // DABCONTROLLERSECOND_H
