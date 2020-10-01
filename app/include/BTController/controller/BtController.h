#ifndef __BT_CONTROLLER_H__
#define __BT_CONTROLLER_H__

#include <QObject>
#include <QMutex>
#include <QString>
#include <QtDBus>
#include <QtDBus/QDBusAbstractAdaptor>
#include "common/common.h"
#include "common/common_app.h"
#include "IBtControllerInterface.h"
#include "DHAVN_LogUtil.h"

#define REDUCE_BTC_LOG

#define BTC_LOG_CRITICAL(message)                  { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_CRITICAL); }
#define BTC_LOG_CRITICAL1(message,arg1)             { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_CRITICAL); }
#define BTC_LOG_CRITICAL2(message,arg1,arg2)       { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_CRITICAL); }

#define BTC_LOG_HIGH(message)                  { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_HI); }
#define BTC_LOG_HIGH1(message,arg1)             { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_HI); }
#define BTC_LOG_HIGH2(message,arg1,arg2)       { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_HI); }

#ifndef REDUCE_BTC_LOG
#define BTC_LOG_MEDIUM(message)                { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_MEDIUM); }
#define BTC_LOG_MEDIUM1(message,arg1)           { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_MEDIUM); }
#define BTC_LOG_MEDIUM2(message,arg1,arg2)     { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_MEDIUM); }

#define BTC_LOG_LOW(message)                   { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_LOW); }
#define BTC_LOG_LOW1(message,arg1)              { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_LOW); }
#define BTC_LOG_LOW2(message,arg1,arg2)        { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_LOW); }

#define BTC_LOG_INFO(message)                   { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_INFO); }
#define BTC_LOG_INFO1(message,arg1)              { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_INFO); }
#define BTC_LOG_INFO2(message,arg1,arg2)        { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_INFO); }
#define BTC_LOG_INFO3(message,arg1,arg2,arg3)   { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)).arg((arg3)),BtController::PRIORITY_INFO); }

#define BTC_LOG_TRACE(message)                   { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_TRACE); }
#define BTC_LOG_TRACE1(message,arg1)              { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_TRACE); }
#define BTC_LOG_TRACE2(message,arg1,arg2)        { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_TRACE); }
#define BTC_LOG_TRACE3(message,arg1,arg2,arg3)   { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)).arg((arg3)),BtController::PRIORITY_TRACE); }
#else   // REDUCE_BTC_LOG
#define BTC_LOG_MEDIUM(message)                { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_MEDIUM); }
#define BTC_LOG_MEDIUM1(message,arg1)           { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_MEDIUM); }
#define BTC_LOG_MEDIUM2(message,arg1,arg2)     { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_MEDIUM); }

#define BTC_LOG_LOW(message)
#define BTC_LOG_LOW1(message,arg1)
#define BTC_LOG_LOW2(message,arg1,arg2)

#define BTC_LOG_INFO(message)
#define BTC_LOG_INFO1(message,arg1)
#define BTC_LOG_INFO2(message,arg1,arg2)
#define BTC_LOG_INFO3(message,arg1,arg2,arg3)

#define BTC_LOG_TRACE(message)
#define BTC_LOG_TRACE1(message,arg1)
#define BTC_LOG_TRACE2(message,arg1,arg2)
#define BTC_LOG_TRACE3(message,arg1,arg2,arg3)
#endif  // REDUCE_BTC_LOG

#define BTC_LOG_SIGNAL(message)                   { BtController::GetInstance()->BtcLog(QString(message),BtController::PRIORITY_SIGNAL); }
#define BTC_LOG_SIGNAL1(message,arg1)              { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)),BtController::PRIORITY_SIGNAL); }
#define BTC_LOG_SIGNAL2(message,arg1,arg2)        { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)),BtController::PRIORITY_SIGNAL); }
#define BTC_LOG_SIGNAL3(message,arg1,arg2,arg3)   { BtController::GetInstance()->BtcLog(QString(message).arg((arg1)).arg((arg2)).arg((arg3)),BtController::PRIORITY_SIGNAL); }

class BtControllerFactory;
class BtDevice;
class BtHandsFree;
class BtPhoneBook;
class BtAudio;
class BtMessaging;
class BtSerialPort;
class BtStateHandler;
class BtTransmissionControl;
class BtReceptionControl;
class ATCommandGeneratorParser;
class BtModuleError;

class BtController : public QObject, public IBtControllerInterface
{
	Q_OBJECT

public:
	static BtController* GetInstance();
	~BtController();

signals:
	void BtControllerSignal(APP_EVENT_ID app_event_id, void *event_data);	
    // SPP_Pandora
    void PandoraSPPConnectedSignal(bool bResult);
    void PandoraSPPDisconnectedSignal(bool bResult);
    void PandoraSPPDataReadCompleteSignal(const QByteArray baReadData);
    void PandoraSPPDataWriteStatusSignal(const int iErrorStatus);
    // SPP_Aha
    void AhaSPPConnectedSignal(bool bResult);
    void AhaSPPDisconnectedSignal(bool bResult);
    void AhaSPPDataReadCompleteSignal(const QByteArray baReadData);
    void AhaSPPDataWriteStatusSignal(const int iErrorStatus);


protected:
	BtController(QObject *parent = 0);

private:
	USE_LOG_UTIL
	static BtController *m_pInstance;
    QMutex m_LogPrintMutex;

#ifdef AHA_PACKET_DEBUG
    int aha_cont_count;
    int aha_cont_size;
    int aha_total_size;
    UINT16 aha_last_pktId;
    UINT16 aha_last_opcode;
    QByteArray aha_ReceivedData;
#endif

#ifdef PANDORA_DEBUG
    QByteArray pandora_ReceivedData;
#endif

public:
    Q_ENUMS(BTC_LOG_PRIORITY)
    enum BTC_LOG_PRIORITY
    {
        PRIORITY_TRACE,
        PRIORITY_INFO,
        PRIORITY_SIGNAL,
        PRIORITY_LOW,
        PRIORITY_MEDIUM,
        PRIORITY_HI,
        PRIORITY_CRITICAL
    };

	IBtControllerInterface* GetBtControllerInstance();
	
	BtDevice *cpBtDevice;
	BtHandsFree *cpBtHandsFree; 
	BtPhoneBook *cpBtPhoneBook;
	BtAudio *cpBtAudio;
	BtMessaging *cpBtMessaging;
	BtSerialPort *cpBtSerialPort;
	BtStateHandler *cpBtStateHandler;
	BtTransmissionControl *cpBtTransmissionControl;
	BtReceptionControl *cpBtReceptionControl;
	ATCommandGeneratorParser *cpATCommandGeneratorParser;
	BtModuleError *cpBtModuleError;

    // For BTController Log
    void BtcLog(const QString &aMessage, BTC_LOG_PRIORITY priority );

	BT_RESULT SendBtAppSignal(APP_EVENT_ID app_event_id, void *event_data);

	BT_RESULT SetBtDeviceEnable(BOOL bOnOff);
	BT_RESULT SetBtDiscoveryEnable(BOOL bOnOff);
	BT_RESULT SetBtMessageEnable(BOOL bOnOff);
	BT_RESULT SetBtAudioEnable(BOOL bOnOff);
	BT_RESULT SetBtPinCode(char *cPinCode);
	BT_RESULT SetBtInBandRing(BOOL bOnOff);
	BT_RESULT DeviceInitialze(void);
	BT_RESULT DeviceFactoryInitialze(void);

	BT_RESULT DeviceSoftReset(void);
	BT_RESULT GetLocalDeviceInfo(void);
	BT_RESULT SetLocalDeviceName(QString qstrDevName);
	BT_RESULT GetLocalDeviceName(void);
	BT_RESULT SetConnectableMode(BOOL bOnOff);
	BT_RESULT GetConnectableMode(void);
	BT_RESULT SetDiscoveryMode(BOOL bOnOff);
	BT_RESULT GetDiscoveryMode(void);
	BT_RESULT SetUARTLoopBackMode(BOOL bOnOff);
	BT_RESULT GetUARTLoopBackMode(void);
	BT_RESULT SetSSPDebugMode(BOOL bOnOff);
	BT_RESULT GetSSPDebugMode(void);
	BT_RESULT SetDUTMode(BOOL bOnOff);
	BT_RESULT GetDUTMode(void);
    BT_RESULT SetADCMode(void);
	BT_RESULT GetDeviceFunctionState(void);
	BT_RESULT SetHandsFreeFordMode(BOOL bOnOff);
	BT_RESULT GetHandsFreeFordMode(void);
	BT_RESULT SetBTModuleBDAddr(char* strBdAddress);
	BT_RESULT GetBTModuleBDAddr(void);
	BT_RESULT GetBTDeviceRSSI(int iDeviceID);

	BT_RESULT ControlDeviceDiscovery(BOOL bOnOff);
	BT_RESULT InitPairing(char* strBdAddress, char *pin);
	BT_RESULT AcceptSspPairing(char* strBdAddress, BT_SSP_RESPONSE btSspResponse);
	BT_RESULT AcceptLegacyPairing(char* strBdAddress, BT_LEGACY_PAIRING_RESPONSE btLegacyPairingResponse, char *strPinCode);
	BT_RESULT GetPairedDeviceCount(void);
	BT_RESULT GetPairedDeviceList(void);
	BT_RESULT DeletePairedDevice(char *strBdAddress);
	BT_RESULT DeletePairedDeviceNew(BTAPP_DELETE_DEVICE_LIST btList);
	BT_RESULT DeleteAllPairedDevice(void);
	BT_RESULT Connect(char *strBdAddress, BT_SERVICE_DESCR services);
	BT_RESULT ConnectSpp(char *strBdAddress);
	BT_RESULT ConnectCancel(char *strBdAddress);
	BT_RESULT Disconnect(int iPairedIndex);
	BT_RESULT SetAutoConnectionDevice(BTAPP_AUTOCONNECT_DEVICE btppAutoConnectDevice);
    BT_RESULT GetAutoConnectionMode(void);
    BT_RESULT ControlAutoConnection(BT_AUTO_CONNECT_MODE btMode);
	BT_RESULT SetSspMode(BOOL bOnOff);
	BT_RESULT GetSspMode(void);

    BT_RESULT GetManufacturerID(void);
	BT_RESULT DialNumber(QString qstrDialNum);
	BT_RESULT DialNumberFromMemory(QString qstrMemoryNum);
	BT_RESULT HangUpCall(void);
	BT_RESULT AcceptCall(void);
	BT_RESULT RejectWaitingCall(void);
	BT_RESULT ReleaseCurrentCall(void);
	BT_RESULT SwapCalls(void);
	BT_RESULT SetAudioPrivacyMode(BT_HFP_AUDIOPATH path);
	BT_RESULT GetAudioPrivacyMode(void);
	BT_RESULT SetMicVolume(int iMicVolume);
	BT_RESULT GetMicVolume(void);
	BT_RESULT TransmitDTMFTones(char dtmf_code);
	BT_RESULT GetCallListNotification(void);
	BT_RESULT SetECNRBTMConfig(BOOL bOnOff);
	BT_RESULT GetECNRBTMConfig(void);
	BT_RESULT SetECNRAGConfig(BOOL bOnOff);
	BT_RESULT GetECNRAGConfig(void);
    BT_RESULT GetECNRVersion(BT_ECNR_VARIANT CountryVariantCode);
    BT_RESULT SetECNRVersion(BT_ECNR_VERSION_INFO ecnr_info);
    BT_RESULT SetECNRParameter(int vectorIndex);
    BT_RESULT SetECNRDownloadSize(int iSize);
    BT_RESULT StartDownloadECNRParameter(int size, char* EcnrParam);

	BT_RESULT Play(void);
	BT_RESULT Stop(void);
	BT_RESULT Pause(void);
	BT_RESULT Next(void);
	BT_RESULT Prev(void);
	BT_RESULT Repeat(BT_AV_REPEAT_MODE btAvRepeatMode);
	BT_RESULT Shuffle(BT_AV_SHUFFLE_MODE btAvShuffleMode);
	BT_RESULT GetRepeatShuffleMode(void);
	BT_RESULT GetCurrentMediaInfo(void);
	BT_RESULT SetAVMute(BOOL bOnOff);
	BT_RESULT GetAVMute(void);

	BT_RESULT SetPBAPDownloadSrc(BT_PBAP_DOWNLOAD_SRC src);
	BT_PBAP_DOWNLOAD_SRC GetPBAPDownloadSrc(void);
    BT_RESULT PhoneBookDownloadStart(BT_PBAP_DOWNLOAD_SRC src, QHash<ushort, BtPinyinInfo>* pinyinTable = NULL);
	BT_RESULT CallHistoryDownloadStart(void);
	BT_RESULT PhoneBookDownloadCancel(void);
	BT_RESULT CallHistoryDownloadCancel(void);
//#ifdef UPDATE_PB_DATA
    BT_RESULT PhoneBookDBUpdateStart(BOOL bOnOff);
//#endif
	BT_RESULT SPPDataTx(char* pBuffer, int iLength);
	BT_RESULT CheckBTModuleForDTC(void);
	BT_RESULT CheckBTModuleForReset(void);
    BT_RESULT CheckBTModuleForAlive(void);
    BT_RESULT GetRemoteDevicename(void);

    BT_RESULT UARTOpen(void);
	BT_RESULT UARTClose(void);
    BT_RESULT UARTReopen(void);
//[20121128, TROY] no use
#if 0
	BT_RESULT AddBtContact(BT_PBAP_CONTACT *contact);
	BT_RESULT EditBtContact(BT_PBAP_CONTACT *contact);
	BT_RESULT RemoveBtContact(BT_PBAP_CONTACT *contact);
	BT_RESULT AddBtLocalContact(BT_PBAP_CONTACT *contact);
	BT_RESULT EditBtLocalContact(BT_PBAP_CONTACT *contact);
	BT_RESULT RemoveBtLocalContact(BT_PBAP_CONTACT *contact);
	BT_RESULT RemoveBtLocalContacts(bool *p_bRemoveFlag);
	BT_RESULT RemoveBtAllContactsWithBDAddr(char *strBdAddress);
	BT_RESULT RemoveBtAllPhoneBooks(void);
	BT_RESULT RemoveBtCallHistory(void);
#endif

	BT_RESULT UpgradeStart(void);

	// OLD
	BT_RESULT TestSetMessageIndication(BT_MAP_MSG_NOTIFY_CONF mode);
	BT_RESULT TestGetMessage(BT_DEVICE_ID id, UINT16 msg_id);
	BT_RESULT TestSetMessageStatus(BT_DEVICE_ID paired_id, UINT16 msg_id, BT_MAP_MSG_READ_STATUS status);
	BT_RESULT TestAbortMessageRetreival(BT_DEVICE_ID paired_id);
	BT_RESULT TestUpdateMessageInbox(BT_DEVICE_ID paired_id);
	BT_RESULT TestSetMessageFolder(BT_DEVICE_ID paired_id, BT_MAP_FLDR_MODE mode, QString folder_name);
	BT_RESULT TestGetMessageFolderDetails(void);
	BT_RESULT TestGetMessageList(BT_DEVICE_ID paired_id, UINT16 start_index, UINT16 size, QString name);
	BT_RESULT EchoTest(BT_ECHO *bt_echo);

	BT_RESULT SetIPodStatus(BTAPP_IPOD_STATUS tAppleDevice);
	BT_RESULT GetIPodStatus(void);

	BT_RESULT SetBTVoiceRecognitionMode(BOOL bOnOff);
	BT_RESULT SetSiriEyesFreeMode(BOOL bOnOff);

	BT_RESULT DiagnosticStart(int iSec);
	BT_RESULT DiagnosticStop(void);
    //SPP_Pandora
	BT_RESULT PandoraSppConnected(BOOL bResult);
	BT_RESULT PandoraSppDisconnected(BOOL bResult);
	BT_RESULT PandoraSppDataReceived(BT_SERIAL_DATA *tBtSerialData);
	BT_RESULT PandoraSppTxResult(int iErrorValue);
    //SPP_Aha
    BT_RESULT AhaSppConnected(BOOL bResult);
    BT_RESULT AhaSppDisconnected(BOOL bResult);
    BT_RESULT AhaSppDataReceived(BT_SERIAL_DATA *tBtSerialData);
    BT_RESULT AhaSppTxResult(int iErrorValue);

//#ifdef __PROJECTION__
    //projection
    BT_RESULT SSPOOBPairingRequest(BT_SSPOOB_REQ value);
    BT_RESULT SetAAPMode(BTAPP_AAP_MODE value);
    BT_RESULT GetAAPMode(void);
    BT_RESULT DisconnectProfile(char *strBdAddress, BT_SERVICE_DESCR btServiceDescr);
    BT_RESULT SetEnableFordPatentMode(BOOL bOnOff);
    BT_RESULT GetEnableFordPatentMode(void);

//#endif

#ifdef AHA_PACKET_DEBUG
    BT_RESULT AhaSppDecodeRequest(UINT16 opcode, UINT8 *pstrData, int length);
    BT_RESULT AhaSppDecodeResponse(UINT16 opcode, UINT8 *pstrData, int length);
    BT_RESULT AhaSppDecodeFrame(UINT8 *pstrSppData, int length, bool dir);
#endif

#ifdef PANDORA_DEBUG
    BT_RESULT PandoraSppDecodeDataFrame(UINT8 *pstrData, int length);
    BT_RESULT PandoraSppDecodeFrame(UINT8 *pstrSppData, int length, bool dir);
#endif
    BT_PBAP_DOWNLOAD_SRC m_eBtPbapDownloadSrc;
    BT_SPP_SET_SPMODE m_eCurrentSppConnect;

    //16MY
    BT_RESULT GetPBAPSupport(void);
};

#endif // __BT_CONTROLLER_H__
