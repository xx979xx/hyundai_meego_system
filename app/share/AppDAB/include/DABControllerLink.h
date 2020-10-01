#ifndef DABCONTROLLERLINK_H
#define DABCONTROLLERLINK_H

#include <QObject>
#include <QTimer>
#include "DABProtocol.h"
#include "DABEPGReservationItem.h"
#include "DABApplication_Def.h"

class DABController;

class DABControllerLink: public QObject
{
    Q_OBJECT

public:
    explicit DABControllerLink(DABController &aDABController, QObject* parent = 0);
    ~DABControllerLink();

    void createConnection(void);
    void sendServiceInfo(void);
    void listScanStart(void);
    void listScanStop(void);
    bool isListStarted(void) { return m_bListScanning; }
    void PresetScanStart(void);
    void PresetScanStop(void);
    bool isPresetScanStarted(void) { return m_bPresetScanning; }
    void allScanStop(void);
    void loadModuleVersion(void);
    void writeModuleVersion(void);
    void requestDABtoFM(void);
    void requestFMtoDAB(void);
    bool checkSwitchingTime(void);
    void checkEPGReservationList(void);
    void unSavedDataEPG(QString fileName);
    void CmdReqSetSeekStop(void);
    void CmdReqSetSelectStop(void);
    void setSystemTimeFromModule(int year, int month, int day, int hour, int minute, int second);
    bool checkDABtoFM(void);
    void checkTAService(void);
    void setStatus(CONTROLLER_STATUS status);
    void setEPGReservationItem(DABEPGReservationItem* pItem);
    DABEPGReservationItem* getEPGReservationItem(void);

    void setModulesStatusForDebugging(QString str);
    void setServiceStatusForDebugging(QString str);

    void setCurrentChannelItem(int freq, int serviceType, int serviceID, int subChId, int bitrate, QString label, QString ensembelLabel);
    void setCurrentChannelItemForSeek(int freq, int serviceType, int serviceID, int subChId, int bitrate, int pty, QString label, QString ensembelLabel);
    void setServiceStatus(DAB_SERVICE_STATUS status);
    void setServiveFollowingState(eDAB_SERVICE_FOLLOWING_STATE_INFO state);

    bool m_bListScanning;
    bool m_bPresetScanning;

private:
    DABController &m_DABController;
    QTimer  m_ScanTimer;
    int     m_iReqGetVersionCount;
    bool    m_bGetVersionRequested;

signals:
    void cmdReqDABtoFM(quint16 playPICode);
    void cmdReqClusterControl(QString serviceName, quint8 presetNumber, quint8 opState);
    void cmdReqRadioEnd(int band, quint16 frequency);
    void cmdReqdisplayOSD(QString serviceName, QString freqLabel, quint8 op_type);
    void cmdReqTASearchPopup(bool onOff);
    void cmdRemoveUnlockFrequency(quint32 freq);
    void cmdSendMuteCancel();
    void cmdStartDABtoFMTimer();
    void cmdStopDABtoFMTimer();
    void cmdUpdateChannelListFromAutoScan(void);
    void cmdUpdateChannelListFromReconfiguration(void);
    void cmdUpdateChannelListFromReconfigurationNotChange(void);
    void cmdLgeDBus_DABPICodeRequest(quint16 playPICode);
    void cmdReqVersion(QString ver);

public slots:
    // ================ Timer ===================
    void onOSDEPGStarted(void);

    //==================================================    Rsp :  DABCommManager => DABControllerLink ===================================
    void EvtAutoScanInfo(quint8 status, quint32 frequency, quint8 lock);

    void RspSetSelectService(quint32 frequency, quint8 serviceType, quint32 serviceID, quint8 subChId, quint16 bitrate, QString label);
    void RspSetAnnouncementFlag(quint16 flag);

    //Request / Response                  //===============================  Req : DABControllerLink => DABCommManager      call  ========================================
    void onRspGetDLS(QString sDLS, QString sTitle, QString sAlbum, QString sArtist);
    void RspGetSLS(QString fileName);
    void removeDuplicatEPGData(quint32 sID, quint32 mjd);
    void onRspGetEPG(quint32 mjd, quint32 sID);
    void ReqSetSeekService(eREQ_SET_FULL_SCAN_BAND band, eREQ_SET_SEEK_SERVICE_DIRECTION direction, bool isEnsembleSeek);
    void RspSetSeekService(eREQ_SET_FULL_SCAN_BAND band, quint8 direction, quint8 FilterType, quint8 FilterValue, quint32 Frequency, quint32 ServiceID, quint8 SubChId);
    void ReqGetVersion(void);
    void RspGetVersion(quint8 booloaderMajorVersion, quint8 bootloaderMinorVersion, quint8 kernelMajor, quint8 kernelMinor, quint8 appMajor, quint8 appMinor, quint8 appMicro, QString buildTime, quint8 bootCount);
    void ReqFirstSelectService(void);
    void RspGetServiceList();

    //=============================== AppEngine  => DABControllerLink ===============
    void onSettingServiceFollowing(int mode);
    void onSetCurrentInfoToHomeMedia(void);
    void onReqSeekCancel(void);
    void onReceiveFMSensitivity(const QByteArray &data);
    void sendPICodeToMicom(void);
#ifdef __ENG_MODE__
    void onReqVersion(int in0);
#endif
};

#endif // DABCONTROLLERLINK_H
