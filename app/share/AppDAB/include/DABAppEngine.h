#ifndef DAB_APP_ENGINE_H
#define DAB_APP_ENGINE_H

#include "DHAVN_AppFramework_AppEngineQML_Def.h"
#include <QDeclarativeView>
#include <QTranslator>
#include <uistate_manager_def.h>

#ifdef __RPMCLIENT__
#include "DHAVN_QRPMClient.h"
#endif

#ifdef __ENG_MODE__
#include "EngModeIf.h"
#endif
#include "DABtoFMIf.h"
#ifdef __DTC__
#include "MICOMIf.h"
#include <QTimer>
#endif
#include <QFile>
#include <QTextStream>
#include <QStack>
#include <DHAVN_QCANController_ApplnTxRx.h>
#include <DHAVN_QCANController_ApplnTxRxStruct.h>
#include "DABController.h"
#include "DABControllerSecond.h"
#include "DABControllerLink.h"
#include "DABUIListener.h"
#include "LocTrigger.h"
#include "DABLogger.h"
#include "DABProtocol.h"
#ifndef __DAB_DEBUG_MSG_OUTPUT_FILE__
#include <DHAVN_LogUtil.h>
#endif
#ifdef __DAB_TPEG__
#include "DABTpegService.h"
#include "DABTpegIf.h"
#endif

#ifdef __WDT__
#include <signal.h>
#include <bits/siginfo.h>
#endif
#include "DABRdsIf.h"
#include "osdwriter.h"
#include "DABAppEngineLink.h"
#include "DABAppEngineNotiUICommon.h"

// constant which defines language command line parameter
const QString KLanguageId = QString("-l:");

enum eRpmClientType
{
    NO_DAB = 0,
    DAB1,
    DAB2,
    DAB3,
    DAB_AV_OFF
};

enum eDAB_CURRENT_STATUS
{
    DAB_FG_STATUS = 0,
    DAB_BG_STATUS,
    DAB_FG_FM_STATUS,
    DAB_BG_FM_STATUS,
    DAB_EXIT_STATUS
};

#ifdef __DTC__
enum eDTC_CMD_TYPE
{
    DTC_CMD_ANTENNA_OUT_BATTERY = 0x00,
    DTC_CMD_ANTENNA_OPEN        = 0x01,
    DTC_CMD_ANTENNA_SHORT       = 0x02,
    DTC_CMD_ANTENNA_NORMAL      = 0x03,
    DTC_CMD_MODULE_UART_ERROR   = 0x04,
    DTC_CMD_EXT_ANTENNA_OPEN    = 0x05
};

#define DTC_EXT_CHECK_COUNT         25
#define DTC_CHECK_COUNT             5
#define DTC_ERROR                 0x01
#define DTC_CLEAR                 0x00
#endif


#define SYSTEM_POPUP_STATUS_SIZE                        (sizeof(char)*4)
#define SYSTEM_OFFSET_CURRENT_AV_MODE                   (28)
#define SYSTEM_OFFSET_POPUP_STATUS                      (32)
#define SYSTEM_OFFSET_CALL_STATUS                       (40)
#define SYSTEM_OFFSET_TOTAL_SIZE                        (40)

#ifndef __DAB_DEBUG_MSG_OUTPUT_FILE__
#define qDebug()          qCritical()/*LOG_HIGH*/
#endif
// User Application must be based from AppEngineBase class (App Framework Lib), it allows to hide d-bus interactions with
// UI State Handler and process common behavior inside of App Framework Lib
class DABAppEngine: public AppEngineQML
{
#ifndef __DAB_DEBUG_MSG_OUTPUT_FILE__
    USE_LOG_UTIL
#endif
   Q_OBJECT

    //Image Source directory
    Q_PROPERTY(QString m_sImageRoot     READ getImageRootDir                            NOTIFY imageRootDirChanged)

public:

    DABAppEngine( QDeclarativeView &aQMLView, LANGUAGE_T nLanguage, QObject *pParent = NULL );
    ~DABAppEngine();

    Q_INVOKABLE void pushScreen(const QString &screenName) { mFlowStack.push(screenName); }
    Q_INVOKABLE QString popScreen();
    Q_INVOKABLE int countScreen() {  return mFlowStack.count(); }
    Q_INVOKABLE void HandleBackKey(QString sInputMode);
    Q_INVOKABLE void HandleHomeKey();
    Q_INVOKABLE void HandleFMKey();
    Q_INVOKABLE void HandleAMKey();
    Q_INVOKABLE void playAudioBeep(void);
    Q_INVOKABLE void setBlockedStation(bool onOff);
#ifdef __AUTO_TEST__
    Q_INVOKABLE void autoTest_athenaSendObject(void);
#endif

    QStack<QString> mFlowStack;
    Q_PROPERTY(QString m_APP_VERSION    READ getAPP_VERSION     NOTIFY appVersionChanged);
    Q_PROPERTY(QString m_BUILDDATE      READ getBUILDDATE       NOTIFY buildDateChanged);

    void setTranslator(QTranslator *translator) { m_pTranslator = translator; }
    void setStatusBarTranslator(QTranslator *translator) { m_pStatusBarTranslator = translator; }
    void RetranslateUi(void);
    QString getAPP_VERSION(void) {return m_APP_VERSION; };
    QString getBUILDDATE(void) {return m_BUILDDATE; };

    // Image Root
    QString getImageRootDir(void){ return this->dabController.getImageRootDir(); }
    void setImageRootDir(QString dir) { this->dabController.setImageRootDir(dir); }

    void Log( const QString &aMessage);
#ifdef __WDT__
    static void signalHandler(int signum);
    void signalConnection();
    static void setSignalHandlerObject(DABAppEngine* m);
    void restart(int sig);
#endif

    void setConnectUISH(void);
    void setInitLanguage(int languageID);
    virtual APP_ID_T GetThisAppId() const { return APP_DAB; }
    void onCanDataSend(SQCanFrame c_data);

signals:
    void retranslateUi(int languageId);
    void cmdReqSaveData(bool unsaved);
    void cmdSendOSDUpdate(void);
    void Can_data_send(const SQCanFrame &c_data);

    // Image Root Dir
    void imageRootDirChanged();
    void cmdReqTrafficDABtoRDS(bool onOff);
    void reqForegroundFromUISH(bool bTemporalMode);
    void appVersionChanged(void);
    void buildDateChanged(void);
    void drivingRegulation(bool onOff);
    void cmdEventExceptionHandler(eDAB_EVENT_TYPE event);

    //Cluster
    void Can_filter_msg_id(const SQCanIdList &c_data);
    void Can_filter_bcm_msg(const SQBCMHead &c_data);
    void Can_data_send_bcm(const SQBCMHead &c_bcm_data,const SQCanFrameList &c_can_data);

    void cmdReqTA(bool bDABAudioOpen);
    void cmdReqTASetting(bool onOff);
    void cmdReqCancelTrafficAnnouncement(bool onOff);
    void cmdReqCancelAlarmAnnouncement(void);
    void sendSeekToEPGList(void);
    void cmdRspTARDStoDAB(bool onOff);
    void cmdReqSetReservationChannel(void);
    void cmdReqTASearch(void);
    void cmdCancelEPGReservation(bool isSystemPopup);
    void gotoMainScreen(void);
    void displayTAPopup(QString serviceName, quint16 flags, bool onOff);
    void cmdReqSetAntennaStatus(quint8 status);
    void dabEngineerMode(void);
    void dabDealerMode(void);

public slots:
    virtual void NotifyFromUIStateManager( Event aEvent );
    virtual void NotifyFromUIStateManagerRear( Event aEvent );
    virtual void NotifyFromUIStateManagerCommon ( Event aEvent );

#ifdef __RPMCLIENT__
    void audioCHsetResponse(TAudioMode eBAND, TAudioSink tSINK);
#endif
#ifdef __DTC__
    void onInterAntenaCheck(void);
    void onExterAntenaCheck(void);
    void sendDTCMessage(quint8 command, quint8 error);
    void onEndExternalDTC(void);
    void onUartModuleCheck(void);
    void initAntennaCount(void);
    void onRspTrafficRDStoDAB(bool onOff);
#endif    
    void onSoundSetting(bool isjogMode);
    bool getBlockedStation(void) { return this->m_bBlockStation; }

    void onReqSendMuteCancel(void);  //# Mute Cancel

private slots:
    void doNotifyUISHFront( Event aEvent );
    void doNotifyUISHRear( Event aEvent );
    void onDABAudioOpen(void);

private:
    void NotifyFromUIStateManagerCommonGeneric ( Event aEvent );
    void NotifyFromUIStateManagerGeneric( Event aEvent, DISPLAY_T display );
    void GENERIC_EVT_REQUEST_PRE_FG(Event aEvent);
    void GENERIC_EVT_REQUEST_FG(Event aEvent);
    void GENERIC_EVT_REQUEST_BG(Event aEvent);
    void GENERIC_EVT_SHOW_POPUP(Event aEvent);
    void GENERIC_EVT_HIDE_POPUP(Event aEvent);
    void GENERIC_EVT_REQUEST_APP_EXIT(Event aEvent);
    void GENERIC_EVT_POPUP_RESPONSE(Event aEvent);
    void GENERIC_EVT_DRS_SHOW(Event aEvent);
    void GENERIC_EVT_DRS_HIDE(Event aEvent);
    void GENERIC_EVT_AV_ON(Event aEvent);
    LANGUAGE_T m_nLanguage;
    QTranslator *m_pStatusBarTranslator;
    void CreateQRPMClient(void);
    void Init(void);
    void SetPropertyToQML(void);
    void SetQMLSource(void);
    void ConnectionWithQML(void);
    void Start(void);

private:
#ifdef __RPMCLIENT__
    QRPMClient* m_pRpmClient;
#endif

    CQCANController_ApplnTxRx* m_pQCanController;
    QString m_APP_VERSION;
    QString m_BUILDDATE;
    QString m_sTAType;
    QString m_sTAServiceName;

    void PrepareLogFile(QObject *pParent);
    DABAppEngineNotiUICommon* pAppEngineNotiUICommon;
    LocTrigger locTrigger;
    int m_iDisplayMode;
    bool m_bFrontMode;
    bool m_bRearMode;
    bool m_bBlockStation;
    bool m_bDABForeground;
#ifdef __DAB_TPEG__
    DABTpegService *m_tpegDataService;
#endif

public:
    DABAppEngineLink* pAppEngineLink;
    QTranslator *m_pTranslator;
    DABtoFMIf* m_DABtoFMClient;
    DABRdsAdaptor *m_pRdsAdaptor;
    MICOMIf* m_MicomClient;
    DABController dabController;
    DABControllerSecond dabControllerSecond;
    bool m_bDABAudioOpen;
    bool m_SystemShowingPopup;
    eDAB_SYSTEM_POPUP_TYPE m_eDabSystemPopupType;
    eDAB_CURRENT_STATUS m_eDabCurrentStatus;
    bool m_bAgreeShowOSD;
    QString m_sBackupOSD;
    bool m_bCallFlag;
    bool m_bFirstShort;
    bool m_bFirstOpen;
    bool m_bUartCheck;
    int m_iAntennaShortCount;
    int m_iAntennaOpenCount;
    int m_iAntennaNormalCount;
    int m_iAntennaOutBatteryCount;
    int m_iUartGoodCount;
    int m_iUartErrorCount;
    quint8 m_DtcSetState;
    QTimer* m_interAntennaTimer;
    QTimer* m_UARTCheckTimer;
    QTimer* m_DABtoFMTimer;
#ifdef __DTC__
    QTimer* m_exterAntennaTimer;
#endif
    bool m_bVRFlag;
    bool m_bMixFlag;
    QSharedMemory m_xSystemPopupSharedMem;
    QSharedMemory m_xCurrentAVModeSharedMem;
    quint16 m_AnnouncementFlags;
    QString m_sAnnouncementServiceName;
    bool m_bPopupNone;
    bool m_bCCPLongPressed;
    bool m_bSeekLongPressed;
    bool m_bFactoryReset;
    bool m_bStationListFromVR;
    bool m_bPowerLogigOff;
    bool m_bCARPlayFlag;
    bool m_bCA_CPP_displayFlag;
};

#endif //DAB_APP_ENGINE_H
