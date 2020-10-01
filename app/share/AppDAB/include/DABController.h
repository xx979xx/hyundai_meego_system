#ifndef DABCONTROLLER_H
#define DABCONTROLLER_H
/**
 * FileName: DABController.h
 * Author: David.Bae
 * Time: 2011-07-22 11:49
 */

#include <QObject>
#include <QTimer>
#include "DABUIListener.h"
#include "DABDataStorage.h"
#include "DABCommManager.h"
#include "DABCommManagerHandler.h"
#include "DABChannelManager.h"
#include "DABEPGReservationList.h"
#include "DABRdsAdaptor.h"
#include "DABLogger.h"
#include "DABControllerLink.h"
#include "DABControllerThird.h"

#ifndef __DAB_DEBUG_MSG_OUTPUT_FILE__
#include <DHAVN_LogUtil.h>
#endif

#ifndef __DAB_DEBUG_MSG_OUTPUT_FILE__
#define qDebug()          qCritical()/*LOG_HIGH*/
#endif

class DABController : public QObject
{
#ifndef __DAB_DEBUG_MSG_OUTPUT_FILE__
    USE_LOG_UTIL
#endif
    Q_OBJECT

public:
    explicit DABController(QObject *parent = 0);
    ~DABController();
    DABUIListener* getUIListener(void);
    DABControllerLink* getControllerLink(void);
    void start(void);
    inline CONTROLLER_STATUS getStatus(void) {return this->m_eStatus;}
    inline DAB_SERVICE_STATUS getServiceStatus(void) {return this->m_eServiceStatus;}
    inline eEVT_SEND_MODULE_STATUS getModuleStatus(void) {return this->m_eModuleStatus;}
    void setModuleStatus(eEVT_SEND_MODULE_STATUS moduleStatus) {this->m_eModuleStatus = moduleStatus;}
    void StartScanTimer(quint8 serviceType);
    void StopScanTimer(void);
    void StartWeakSignalTimer(void);
    void StopWeakSignalTimer(void);
    void StartTASearchTimer(void);
    void StopTASearchTimer(void);
    void StartBroadcastingTimer(void);
    void StopBroadcastingTimer(void);
    void StartDeactiveFMLinkingTimer(void);
    void StopDeactiveFMLinkingTimer(void);
    void StartDeactiveTATimer(void);
    void StopDeactiveTATimer(void);
    DAB_SERVICE_STATUS  m_eServiceStatus;
    QString getImageRootDir(void){ return m_sImageRootDir; }
    void setImageRootDir(QString dir) { this->m_sImageRootDir = dir; }
    void setRadioPlayBand(int band) {this->m_iRadioPlayBand = band;}
    void setRadioPlayFreq(quint16 freq) { this->m_qRadioPlayFrequency = freq; }
    int getRadioPlayBand() { return this->m_iRadioPlayBand; }
    eDAB_SERVICE_FOLLOWING_STATE_INFO getServiceFollowingState() { return this->m_eServiceFollowingState; }
    void setRequestDABtoFM(bool value) { this->m_bRequestDABtoFM = value; }
    void setDeactiveDABtoFM(bool onOff) { this->m_bDeactiveDABtoFM = onOff; }
    bool getDeactiveDABtoFM(void) { return this->m_bDeactiveDABtoFM; }
    quint16 getRadioPlayFreq() { return this->m_qRadioPlayFrequency; }
    Q_INVOKABLE int getDLPlusTimeout(void){ return this->m_iDLPlustTimeout; }
    Q_INVOKABLE int getDLSTimeout(void){ return this->m_iDLSTimeout; }
    Q_INVOKABLE int getSLSTimeout(void){ return this->m_iSLSTimeout; }
    Q_INVOKABLE void seekDownFromStationList(void);
    Q_INVOKABLE void seekUpFromStationList(void);
    Q_INVOKABLE void debugRequestDABtoDAB(QString onOff);
    Q_INVOKABLE void sendServLinkCERValue(quint32 dab_worst, quint32 dab_bad, quint32 dab_nogood, quint32 dab_good, quint32 dabPlus_worst, quint32 dabPlus_bad, quint32 dabPlus_nogood, quint32 dabPlus_good);
    Q_INVOKABLE void sendtSigStatusCERValue(quint8 count, quint32 dab_bad, quint32 dab_nogood, quint32 dab_good, quint32 dabPlus_bad, quint32 dabPlus_nogood, quint32 dabPlus_good);
    Q_INVOKABLE void sendPinknoiseCERValue(quint8 unmute_count, quint8 mute_count, quint32 dab_bad, quint32 dab_good, quint32 dabPlus_bad, quint32 dabPlus_good);
    Q_INVOKABLE void debugSetDLSTimeout(int time);
    Q_INVOKABLE void debugSetSLSTimeout(int time);
    void setReservationCount(int count) { this->m_iReservationCount = count; }
    void changeFMtoDAB(void);
    bool getBroadcastingTimeActive(void) { return m_bLoadReservationItem; }
    void setTAInterrupt(bool value) { m_bTAInterrupt = value; }
#ifdef __DTC__
    bool m_AliveUartMsg;
    bool m_AliveMsgOnOff;
#endif
    void updateStationListPlayIndex(void);

signals:
    void cmdUpdateChannelItem(quint32 freq, quint16 eId, quint8 iId, QString eLabel, quint8 sCount, quint32 sID, quint8 sType, quint8 subChId, quint16 bitrate, quint8 ps, quint8 charset, quint8 pty, quint8 language, QString sLabel, stASU_INFO asuInfo, stPICODE_INFO picodeInfo, quint8 subCHSize, quint16 address);
    void cmdAddTempChannelItem(quint32 freq, quint16 eId, quint8 iId, QString eLabel, quint8 sCount, quint32 sID, quint8 sType, quint8 subChId, quint16 bitrate, quint8 ps, quint8 charset, quint8 pty, quint8 language, QString sLabel, stASU_INFO asuInfo, stPICODE_INFO picodeInfo, quint8 subCHSize, quint16 address);
    void cmdAddNewChannelItem(quint32 freq, quint16 eId, quint8 iId, QString eLabel, quint8 sCount, quint32 sID, quint8 sType, quint8 subChId, quint16 bitrate, quint8 ps, quint8 charset, quint8 pty, quint8 language, QString sLabel, stASU_INFO asuInfo, stPICODE_INFO picodeInfo, quint8 subCHSize, quint16 address);
    void cmdReqClusterControl(QString serviceName, quint8 presetNumber, quint8 opState);
    void cmdReqdisplayOSD(QString serviceName, QString freqLabel, quint8 op_type);
    void cmdReqDABSoundOn(void);
    void cmdReqRadioEnd(int band, quint16 frequency);
    void cmdResponseAddReservation(bool isReserve, int hour, int minute, int second);
    void cancelEPGReservation(bool isSystemPopup);
    void cmdReservationCountFull();
    void displayLinkingIcon(bool isDABtoDAB, bool isDABtoFM, bool isSearching);
    void alreadyPreserved();
    void updateChannelItemStatus(quint8 type, bool onOff);
    void cmdRemoveUnlockFrequency(quint32 freq);
#ifdef __DAB_TPEG__
    void cmdSendTPEGData(const QByteArray &data, int length);
#endif
    void cmdReqAllAnnounceDABtoRDS(bool bTraffic);
    void newsFlagChanged();
    void cmdStartDABtoFMTimer();
    void cmdStopDABtoFMTimer();
    void cmdReqTASearchPopup(bool onOff);
    void cmdCloseSystemPopup(eDAB_SYSTEM_POPUP_TYPE m_ePopupType);
    void cmdCheckReservationItem(void);
    void loadEPGListBySelect(void);
    void sendAudioInfo(quint8 protectType, quint8 protectLevel, quint8 protectOption);
    void cmdSendMuteCancel();
    void playIndexUpdateForScan(quint32 frequency, quint32 serviceID, QString serviceName);
    void menuEnableInitialized();
    void updatePlayIndex(quint32 playIndex);

public slots:
//=============================== AppEngine  => DABController ===============
    void onChangeDABtoFM(void);
    void onAddEPGReservation(QDateTime dateTime, QString serviceName, int serviceID, QString title, QString description, int hour, int minute, int second, int duration);
    void onAddRemoveEPGReservation(QDateTime dateTime, QString serviceName, int serviceID, QString title, QString description, int hour, int minute, int second, int duration);
    void onCheckExistServiceID(QDateTime dateTime, int serviceID, int hour, int minute, int second);
    void onCancelEPGReservation(bool isSystemPopup);

//==================================================    Rsp :  DABCommManager => DABController ===================================
    void EvtSendChangeService(int freq, int serviceType, int serviceID, int SubChId, int Bitrate, int Pty, QString label, QString ensembelLabel,eEVT_SEND_CHANGE_SERVICE_EVENT event);
    void SendChangeServiceLow(int freq, int serviceType, int serviceID, int SubChId, int Bitrate, int Pty, QString label, QString ensembelLabel,eEVT_SEND_CHANGE_SERVICE_EVENT event);
    void SendChangeServiceMiddle(int freq, int serviceType, int serviceID, int SubChId, int Bitrate, QString label, QString ensembelLabel,eEVT_SEND_CHANGE_SERVICE_EVENT event);
    void SendChangeServiceHigh(int freq, int serviceID, eEVT_SEND_CHANGE_SERVICE_EVENT event);
    void sendChannelItem( quint32 freq, quint16 eId, quint8 iId, QString eLabel, quint8 sCount, quint32 sID, quint8 sType, quint8 subChId, quint16 bitrate, quint8 ps, quint8 charset, quint8 pty, quint8 language, QString sLabel, stASU_INFO asuInfo, stPICODE_INFO picodeInfo, quint8 subCHSize, quint16 address);
    void onAudioInfo(quint8 ProtectType, quint8 ProtectLevel, quint8 ProtectOption);
#ifdef __DAB_TPEG__
    void onRspTPEGData(const QByteArray &data);
#endif

//==================================================    Rsp :  DABChannelManager => DABController ===================================
    void initPICodeValue(void);
    void ReqSetSelectService(void);

//========================================================  Timer ==========================================================
    void ScanTimeOut(void);
    void WeakTimeOut(void);
    void onTASearchTimeOut(void);
    void onBroadcastingTimeTick(void);
    void onDeactivateTA(void);
    void onDeactivateFMLinking(void);

public:
    DABUIListener* pUIListener;
    DABCommManager* pCommManager;
    DABCommManagerHandler* pCommManagerHandler;
    DABChannelManager* pChannelManager;
    DABEPGReservationList* pEPGReservationList;
    DABControllerLink* pControllerLink;
    DABControllerThird* pControllerThird;
    DABEPGReservationItem* pEPGReservationItem;
    eDAB_SERVICE_FOLLOWING_STATE_INFO  m_eServiceFollowingState;
    int     m_iPlayIndexBackup;
    bool    m_bExistCurrentChannel;
    bool    m_bExistCurrentChannelInPreset;
    bool    m_bMuteCheck;
    bool    m_bDeactiveTA;
    /**
    2013.08.29 Mobilus DaehyungE
    Announcement SubChID를 따로 저장한다.
    이유는 Announcement 수신중에 SLS가 오면 원래 듣고 있던 방송이랑 SubChID를 비교해서 다르면 SLS 무시하기 위해서임
    */
    quint8 m_iTASubChId;
    bool    m_bLoadReservationItem;
    int     m_iLinkingState;   //0: orginal, 1:DABtoDAB, 2:DABtoFM
    /**
    2013.06.30 Mobilus DaehyungE
    채널 선택시 3번째 signal status값은 무시한다.
    이유는 DAB-DAB, DAB-FM 지역에서 채널 선택시 DAB-FM으로 먼저 linking되는 현상을 방지하기 위해서임
    하지만 연속으로 NoGood or BAD Signal 들어오는 case에 대해서는 어쩔수 없이 DAB-FM으로 먼저 넘어간다.
    */
    int     m_bIgnoreBADSignal;
    FM_DAB_STATE_INFO m_eFMtoDABState;
    bool    m_bRequestDABtoFM;
    quint8  m_bPICodeStatus;
    quint8  m_bPICodeSensitive;
    int     m_iSLSTimeCount;
    int     m_iSLSTimeout;
    int     m_iDLSTimeCount;
    int     m_iDLSTimeout;
    int     m_iDLPlustTimeCount;
    int     m_iDLPlustTimeout;
    bool    m_bDeactiveFMLinking;
    bool    m_bDeactiveDABtoFM;
    QString m_sBackupEPGTitle;
    QString m_sBackupEPGServiceName;
    CONTROLLER_STATUS   m_eStatus;
    int     m_iServiceEvent;
    quint16 m_FMFrequency;
    int     m_PICodeOffset;
    quint16 m_PICodeValue[12];
    int     m_PICodeValueCount;
    bool    m_bSoundSettingFlag;
    bool    m_bVrStatus;
    bool    m_bTAInterrupt;
    QTimer  m_TuneTimer;

private:
    eEVT_SEND_MODULE_STATUS m_eModuleStatus;
    bool    m_bIsAutoScan;
    int     m_iRadioPlayBand;
    quint16 m_qRadioPlayFrequency;
    QTimer  m_TASearchTimer;
    QTimer  m_BroadcastingTimer;
    QTimer  m_DeactiveFMLinkingTimer;
    QTimer  m_DLPlusTimer;
    QTimer  m_DeactiveTATimer;
    QTimer  m_ScanTimer;
    QTimer  m_WeakSignalTimer;
    QString m_sImageRootDir;
    quint32 m_iPreviousFreq;
    bool    m_bPinkStatus;
    int     m_iReservationCount;

    void init(void);
    void createConnection(void);
};

#endif // DABCONTROLLER_H
