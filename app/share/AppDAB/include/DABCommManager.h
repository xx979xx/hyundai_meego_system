#ifndef DABCOMMMANAGER_H
#define DABCOMMMANAGER_H

#include <QObject>
#include <QProcess>
#include "DABCommDataHandler.h"
#include "DABCommSPIPacketInfo.h"
#include "DABCommReceiverThread.h"
#include "DABProtocol.h"

typedef struct
{
    quint8 m_ascll;
    quint16 m_unicode;
} EBU_CHAR_TABLE;

class DABController;
class DABCommManager : public QObject
{
    Q_OBJECT
public:
    explicit DABCommManager(DABController &aDABController, QObject *parent = 0);
    ~DABCommManager();
    void startComm(void);
    void stopComm(void);
    void restartUART(void);
    DABCommUART m_ComUart;
    DABCommSPI m_ComSpi;
    DABCommSPIPacketInfo* getSPIPacketInfo(void);

    struct DABCommandDataBackup{
        quint8 data[100];
        quint8 cmd;
        int size;
    };
    DABCommandDataBackup m_xDataBackup;

    int writeCmd(quint8* cmdBuf, int cmdLen);
    void copyLabelBufferAndRemoveSpace(char* pDest, int destSize, const char* pSrc, int srcSize);
    QString ebuLatinToUnicode(unsigned char* latinChar, int strlLength);
    QString ToUnicode(char* labelBuffer, quint8 Charset);

public:
    void RspSetAnnounceDelay(unsigned char* buff, int size);
    void RspSetAnnounceTimeout(unsigned char* buff, int size);
    void RspSetServLinkTimeout(unsigned char* buff, int size);
    void RspSetAnnouncementWeakTimeout(unsigned char* buff, int size);

    ////////////////////////////////////////////////////////////////////////////////////////
    //Receive Event from DABCommReceiverThread (Naming from DAB Module Specification Document)
    ////////////////////////////////////////////////////////////////////////////////////////
    void EvtSendModuleStatus(quint8 ms, quint8 ss);
    void EvtSendChangeService(unsigned char* buff, int buffLen);
    void EvtSendAnnouncement(unsigned char* buff, int buffLen);
    void EvtSendTime(unsigned char* buff, int buffLen);
    void EvtSendQOS(unsigned char* buff, int buffLen);
    void EvtUpdateDLS(unsigned char* buff, int buffLen);
    void EvtUpdateSLS(unsigned char* buff, int buffLen);
    void EvtUpdateEPG(unsigned char* buff, int buffLen);
    void EvtDownloadStatus(unsigned char* buff, int buffLen);
    void EvtSendAutoScanInfo(unsigned char* buff, int buffLen);
    void EvtSendSignalInfo(unsigned char* buff, int buffLen);
    void EvtServiceFollowingState(unsigned char* buff, int buffLen);
    void EvtSendCountryInfo(unsigned char* buff, int buffLen);
    void EvtSendPinkStatus(unsigned char* buff, int buffLen);
    void EvtSendUserAppType(unsigned char* buff, int buffLen);
    void EvtSendAnnouncementTAInvalid(unsigned char* buff, int buffLen);
    void EvtSPIUpdateSLS(unsigned char* buff, int buffLen, int value, unsigned char framepostion, int totalLen);
    void setSLS(unsigned char* buff, int buffLen, int value);
    void EvtSPIUpdateEPG(unsigned char* buff, int buffLen);
    void EvtSPIUpdateTPEG(unsigned char* buff, int buffLen);
    void EvtDataInfo(unsigned char* buff, int buffLen);
    void EvtSPIUpdateStationLogo(unsigned char* buff, int buffLen, unsigned char framepostion);
    bool SPIUpdateStationLogoPackage(unsigned char* buff, int buffLen);
    bool SPIUpdateStationLogoDefault(unsigned char* buff, int buffLen);

signals:
    void cmdAddEPGItem(quint32 mjd, quint32 serviceID, int Hour, int Minute, int Second, int Duration, QString ProgramLabel, QString Description);
    void rspGetSLS(QString fileName);
    void removeDuplicatEPGData(quint32 sID, quint32 mjd);
    void rspGetEPG(quint32 mjd, quint32 sID);
    void evtSendModuleStatus(eEVT_SEND_MODULE_STATUS m, eEVT_SEND_SERVICE_STATUS s);
    void evtSendChangeService(int freq, int serviceType, int serviceID, int SubChId, int Bitrate, int Pty, QString label, QString ensembleLabel,eEVT_SEND_CHANGE_SERVICE_EVENT event);

    void evtSendAnnouncement(QString label, int flag, eEVT_SEND_ANNOUNCEMENT_STATUS status, quint8 subChID);
    void evtSendTime(int year, int month, int day, int hour, int minute, int second);
    void evtSendQOS(int CER, int SNR, int RSSI, int CER_sub, int SNR_sub, int RSSI_sub);
    void evtUpdateDLS(quint8 update);
    void evtUpdateSLS();
    void evtUpdateEPG();
    void evtSendSignalInfo(quint8 status);
    void evtSendPinkStatus(quint8 status);
    void evtAutoScanInfo(quint8 status, quint32 frequency, quint8 lock);
    void cmdAddStationLogo(QString);

#ifdef __DAB_TPEG__
    void cmdRspTPEGData(const QByteArray &data);
#endif

public slots:
    void onProcessCommand(unsigned char type, unsigned char command, QByteArray bArray, int dataLen);
    //void onProcessCommand(unsigned char type, unsigned char command, unsigned char *pData, int dataLen);
    void onSPIProcessCommand(unsigned char type, unsigned char command, unsigned char framepostion, QByteArray bArray, int dataLen, int totalLen);
    void onSPIProcessCommand(unsigned char type, unsigned char command, unsigned char framepostion, unsigned char *pData, int dataLen, int totalLen);
    void onUpdateOutputText();
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProcessError(QProcess::ProcessError error);
    void sendBackupCommandFromRebooting(void);
    void onReqSetAnnounceDelay(quint32 time);
    void onReqSetAnnounceTimeout(quint32 time);
    void onReqSetAnnounceWeakTimeout(quint32 time);
    void onReqSetServLinkTimeout(quint32 time);

private:
    QProcess process;

    enum PlaySvcState {
        PlaySvcNone = 0,
        PlaySvcReq,
        PlaySvcRsp,
        PlaySvcReceiving,
        PlaySvcPlaying
    };

    enum ModuleStatus {
        ModBooting = 0,
        ModIdle,
        ModReady,
        ModWaiting,
        ModServiceGood,
        ModServiceWeak,
        ModScanning,
        ModScanStop,
        ModScanEnd
    };

    enum ScanMode {
        StartScan = 0,
        StopScan
    };

    DABCommReceiverThread* pCommReceiverThread;
    DABCommDataHandler* pCommDataHandler;
    DABCommSPIPacketInfo* pSPIPacketInfo;
    ModuleStatus ModState;    
    PlaySvcState BState;
    ScanMode ScanState;
    DABController &m_DABController;
};

#endif // DABCOMMMANAGER_H
