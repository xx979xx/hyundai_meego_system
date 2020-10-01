#ifndef DABCOMMMANAGERHANDLER_H
#define DABCOMMMANAGERHANDLER_H

#include <QObject>
#include "DABCommManager.h"
#include "DABCommManagerLink.h"

class DABCommManagerHandler : public QObject
{
    Q_OBJECT
public:
    explicit DABCommManagerHandler(DABCommManager* m_CommManager, QObject* parent = 0);
    ~DABCommManagerHandler();

    void ReqGetVersion(void);
    void RspGetVersion(unsigned char* buff, int size);
    void ReqSetSeekService(quint8 band, quint8 direction, quint8 filterType, quint8 filterValueLen, QByteArray filterValue, quint32 frequency, quint32 serviceID, quint8 subChId);
    void RspSetSeekService(unsigned char* buff, int size);
    void ReqSetSeekStop(void);
    void RspSetSeekStop(unsigned char* buff, int size);
    void ReqSetSelectService(quint32 frequency, quint8 serviceType, quint32 serviceID, quint8 subChId, quint16 bitrate, quint8 subCHSize, quint16 address, quint8 ps,const char* label, quint8 picodeCount, quint16* picode);
    void RspSetSelectService(unsigned char* buff, int size);
    void ReqSetServiceInfo(quint32 frequency, quint8 serviceType, quint32 serviceID, quint8 subChId, quint16 bitrate, quint8 labelCharset, const char* label, quint8 picodeCount, const char* picodeValue);
    void ReqSetSelectStop(void);
    void RspSetSelectStop(unsigned char* buff, int size);
    void RegSetServiceFollowing(int mode);
    void RspSetServiceFollowing(unsigned char* buff, int size);
    void ReqSetAnnouncementFlag(quint16 flag);
    void RspSetAnnouncementFlag(unsigned char* buff, int size);
    void ReqGetServiceList(unsigned int frequency = 0);
    void RspGetServiceList(unsigned char* buff, int size);
    void ReqGetDLS(void);
    void RspGetDLS(unsigned char* buff, int size);
    bool RspGetDLSInfo(unsigned char* buff, int index, int iDLSStringLength, QString strDLS);
    void ReqSetSelectAnnouncementService(quint32 frequency, quint8 serviceType, quint32 serviceID, quint8 subChId, quint16 bitrate, quint8 subCHSize, quint16 address, const char* label, quint8 picodeCount, const char* picodeValue, quint16 flags, quint8 status);
    void RspSetSelectAnnouncementService(unsigned char* buff, int size);
    void ReqGetAnnouncementStatus(void);
    void RspGetAnnouncementStatus(unsigned char* buff, int size);
    void ReqGetPinkStatus(void);
    void RspGetPinkStatus(unsigned char* buff, int size);
    void ReqSetAutoScan(quint8 band, quint8 action, quint8 onOff);
    void RspSetAutoScan(unsigned char* buff, int size);
    void ReqSetFMService(quint8 band, quint32 piCode);
    void RspSetFMService(unsigned char* buff, int size);
    void ReqGetAudioInfo(void);
    void RspGetAudioInfo(unsigned char* buff, int size);
    void ReqSetServLinkCERValue(quint32 dab_worst, quint32 dab_bad, quint32 dab_nogood, quint32 dab_good, quint32 dabPlus_worst, quint32 dabPlus_bad, quint32 dabPlus_nogood, quint32 dabPlus_good);
    void RspSetServLinkCERValue(unsigned char* buff, int size);
    void ReqSetSigStatusCERValue(quint8 count, quint32 dab_bad, quint32 dab_nogood, quint32 dab_good, quint32 dabPlus_bad, quint32 dabPlus_nogood, quint32 dabPlus_good);
    void RspSetSigStatusCERValue(unsigned char* buff, int size);
    void ReqSetPinknoiseCERValue(quint8 unmute_count, quint8 mute_count, quint32 dab_bad, quint32 dab_good, quint32 dabPlus_bad, quint32 dabPlus_good);
    void RspSetPinknoiseCERValue(unsigned char *buff, int size);

    DABCommManager* m_dabCommManager;
    DABCommManagerLink* pCommManagerLink;

signals:
    void rspGetVersion(quint8 booloaderMajorVersion, quint8 bootloaderMinorVersion, quint8 kernelMajor, quint8 kernelMinor, quint8 appMajor, quint8 appMinor, quint8 appMicro, QString buildTime, quint8 bootCount);
    void rspSetSeekService(eREQ_SET_FULL_SCAN_BAND band, quint8 direction, quint8 FilterType, quint8 FilterValue, quint32 Frequency, quint32 ServiceID, quint8 SubChId);
    void rspSetSelectService(quint32 frequency, quint8 serviceType, quint32 serviceID, quint8 subChId, quint16 bitrate, QString label);
    void rspSetAnnouncementFlag(quint16 flag);
    void rspGetServiceList();
    void sendChannelItem(quint32 freq, quint16 eId, quint8 iId, QString eLabel, quint8 sCount, quint32 sID, quint8 sType, quint8 subChId, quint16 bitrate, quint8 ps, quint8 charset, quint8 pty, quint8 language,
                         QString sLabel, stASU_INFO asuInfo, stPICODE_INFO picodeInfo, quint8 subCHSize, quint16 address);
    void rspGetDLS(QString sDLS, QString sTitle, QString sAlbum, QString sArtist);
    void evtSendAnnouncement(QString label, int flag, eEVT_SEND_ANNOUNCEMENT_STATUS status, quint8 subChID);
    void evtSendPinkStatus(quint8 status);
    void cmdAudioInfo(quint8 ProtectType, quint8 ProtectLevel, quint8 ProtectOption);

};

#endif // DABCOMMMANAGERHANDLER_H
