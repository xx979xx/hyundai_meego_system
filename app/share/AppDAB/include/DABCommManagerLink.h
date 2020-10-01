#ifndef DABCOMMMANAGERLINK_H
#define DABCOMMMANAGERLINK_H

#include <QObject>

class DABCommManagerHandler;
class DABCommManagerLink : public QObject
{
    Q_OBJECT
public:
    explicit DABCommManagerLink(DABCommManagerHandler* pCommManagerHandler, QObject* parent = 0);
    ~DABCommManagerLink();

    void onProcessCommand(unsigned char type, unsigned char command, unsigned char *pData, int dataLen);
    void RspCommandLow(unsigned char command, unsigned char *pData, int dataLen);
    void RspCommandMiddle(unsigned char command, unsigned char *pData, int dataLen);
    void RspCommandHigh(unsigned char command, unsigned char *pData, int dataLen);
    void RspCommandLast(unsigned char command, unsigned char *pData, int dataLen);
    void EvtCommandLow(unsigned char command, unsigned char *pData, int dataLen);
    void EvtCommandHigh(unsigned char command, unsigned char *pData, int dataLen);

    void ReqSetAntennaStatus(quint8 flag);
    void RspSetAntennaStatus(unsigned char *buff, int size);
    void ReqGetSLS(void);
    void RspGetSLS(unsigned char* buff, int size);
    void ReqGetEPG(void);
    void ReqSetEvtSendTime(quint8 status);
    void RspSetEvtSendTime(unsigned char* buff, int size);
    void ReqSetDrcFlag(quint8 flag);
    void RspSetDrcFlag(unsigned char* buff, int size);
    void ReqSetBandSelection(quint8 band);
    void RspSetBandSelection(unsigned char* buff, int size);
    void ReqSetBroadcasting(quint8 band);
    void RspSetBroadcasting(unsigned char* buff, int size);

signals:
#ifdef __DTC__
    void evtSendDtcUart();
#endif

private:
    DABCommManagerHandler* m_DABCommManagerHandler;
};

#endif // DABCOMMMANAGERLINK_H
