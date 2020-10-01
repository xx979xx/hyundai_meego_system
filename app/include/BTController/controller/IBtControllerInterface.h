#ifndef __BT_IBTCONTROLLERINTERFACE_H__
#define __BT_IBTCONTROLLERINTERFACE_H__

#include "BtControllerGlobal.h"
#include "common/common.h"
#include "common/common_app.h"

class BTCONTROLLER_EXPORT IBtControllerInterface
{
public:
	virtual BT_RESULT SetBtDeviceEnable(BOOL bOnOff) = 0;
	virtual BT_RESULT SetBtDiscoveryEnable(BOOL bOnOff) = 0;
	virtual BT_RESULT SetBtMessageEnable(BOOL bOnOff) = 0;
	virtual BT_RESULT SetBtAudioEnable(BOOL bOnOff) = 0;
	virtual BT_RESULT SetBtPinCode(char *cPinCode) = 0;
	virtual BT_RESULT SetBtInBandRing(BOOL bOnOff) = 0;
	virtual BT_RESULT DeviceInitialze(void) = 0;
	virtual BT_RESULT DeviceFactoryInitialze(void) = 0;

	// BT Module Control API
	virtual BT_RESULT DeviceSoftReset(void) = 0;
	virtual BT_RESULT GetLocalDeviceInfo(void) = 0;
	virtual BT_RESULT SetLocalDeviceName(QString qstrDevName) = 0;
	virtual BT_RESULT GetLocalDeviceName(void) = 0;
	virtual BT_RESULT SetConnectableMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetConnectableMode(void) = 0;
	virtual BT_RESULT SetDiscoveryMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetDiscoveryMode(void) = 0;
	virtual BT_RESULT SetUARTLoopBackMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetUARTLoopBackMode(void) = 0;
	virtual BT_RESULT SetSSPDebugMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetSSPDebugMode(void) = 0;
	virtual BT_RESULT SetDUTMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetDUTMode(void) = 0;
    virtual BT_RESULT SetADCMode(void) = 0;
	virtual BT_RESULT GetDeviceFunctionState(void) = 0;
	virtual BT_RESULT SetHandsFreeFordMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetHandsFreeFordMode(void) = 0;
	virtual BT_RESULT SetBTModuleBDAddr(char* strBdAddress) = 0;
	virtual BT_RESULT GetBTModuleBDAddr(void) = 0;
	virtual BT_RESULT GetBTDeviceRSSI(int iDeviceID) = 0;

	virtual BT_RESULT ControlDeviceDiscovery(BOOL bOnOff) = 0;
	virtual BT_RESULT InitPairing(char* strBdAddress, char *pin) = 0;
	virtual BT_RESULT AcceptSspPairing(char* strBdAddress, BT_SSP_RESPONSE btSspPairing) = 0;
	virtual BT_RESULT AcceptLegacyPairing(char* strBdAddress, BT_LEGACY_PAIRING_RESPONSE btLegacyPairingResponse, char *strPinCode) = 0;
	virtual BT_RESULT GetPairedDeviceCount(void) =0;
	virtual BT_RESULT GetPairedDeviceList(void) = 0;
	virtual BT_RESULT DeletePairedDevice(char *strBdAddress) = 0;
	virtual BT_RESULT DeletePairedDeviceNew(BTAPP_DELETE_DEVICE_LIST btList) = 0;
	virtual BT_RESULT DeleteAllPairedDevice(void) = 0;
	virtual BT_RESULT Connect(char *strBdAddress, BT_SERVICE_DESCR services) = 0;
	virtual BT_RESULT ConnectSpp(char *strBdAddress) = 0;
	virtual BT_RESULT ConnectCancel(char *strBdAddress) = 0;
	virtual BT_RESULT Disconnect(int iPairedIndex) = 0;
	virtual BT_RESULT SetAutoConnectionDevice(BTAPP_AUTOCONNECT_DEVICE btppAutoConnectDevice) = 0;
    virtual BT_RESULT GetAutoConnectionMode(void) = 0;
    virtual BT_RESULT ControlAutoConnection(BT_AUTO_CONNECT_MODE btMode) = 0;
	virtual BT_RESULT SetSspMode(BOOL bOnOff) = 0;
	virtual BT_RESULT GetSspMode(void) = 0;

    virtual BT_RESULT GetManufacturerID(void) = 0;
	virtual BT_RESULT DialNumber(QString qstrDialNum) = 0;
	virtual BT_RESULT DialNumberFromMemory(QString qstrMemoryNum) = 0;
	virtual BT_RESULT HangUpCall(void) = 0;
	virtual BT_RESULT AcceptCall(void) = 0;
	virtual BT_RESULT RejectWaitingCall(void) = 0;
	virtual BT_RESULT ReleaseCurrentCall(void) = 0;
	virtual BT_RESULT SwapCalls(void) = 0;
	virtual BT_RESULT SetAudioPrivacyMode(BT_HFP_AUDIOPATH path) = 0;
	virtual BT_RESULT GetAudioPrivacyMode(void) = 0;
	virtual BT_RESULT SetMicVolume(int iMicVolume) = 0;
	virtual BT_RESULT GetMicVolume(void) = 0;
	virtual BT_RESULT TransmitDTMFTones(char dtmf_code) = 0;
	virtual BT_RESULT GetCallListNotification(void) = 0;
	virtual BT_RESULT SetECNRBTMConfig(BOOL bOnOff) = 0;
	virtual BT_RESULT GetECNRBTMConfig(void) = 0;
	virtual BT_RESULT SetECNRAGConfig(BOOL bOnOff) = 0;
	virtual BT_RESULT GetECNRAGConfig(void) = 0;
    virtual BT_RESULT GetECNRVersion(BT_ECNR_VARIANT CountryVariantCode) = 0;
    virtual BT_RESULT SetECNRVersion(BT_ECNR_VERSION_INFO ecnr_info) = 0;
    virtual BT_RESULT SetECNRParameter(int vectorIndex) = 0;
    virtual BT_RESULT SetECNRDownloadSize(int iSize) = 0;
    virtual BT_RESULT StartDownloadECNRParameter(int size, char* EcnrParam) = 0;



	virtual BT_RESULT Play(void) = 0;
	virtual BT_RESULT Stop(void) = 0;
	virtual BT_RESULT Pause(void) = 0;
	virtual BT_RESULT Next(void) = 0;
	virtual BT_RESULT Prev(void) = 0;
	virtual BT_RESULT Repeat(BT_AV_REPEAT_MODE btAvRepeatMode) = 0;
	virtual BT_RESULT Shuffle(BT_AV_SHUFFLE_MODE btAvShuffleMode)= 0;
	virtual BT_RESULT GetRepeatShuffleMode(void) = 0;
	virtual BT_RESULT GetCurrentMediaInfo(void) = 0;
	virtual BT_RESULT SetAVMute(BOOL bOnOff) = 0;
	virtual BT_RESULT GetAVMute(void) = 0;

    virtual BT_RESULT PhoneBookDownloadStart(BT_PBAP_DOWNLOAD_SRC src, QHash<ushort, BtPinyinInfo>* pinyinTable) = 0;
	virtual BT_RESULT CallHistoryDownloadStart(void) = 0;
	virtual BT_RESULT PhoneBookDownloadCancel(void) = 0;
	virtual BT_RESULT CallHistoryDownloadCancel(void) = 0;
//#ifdef UPDATE_PB_DATA
    virtual BT_RESULT PhoneBookDBUpdateStart(BOOL bOnOff) = 0;
//#endif
	virtual BT_RESULT SPPDataTx(char* pBuffer, int iLength) = 0;
	virtual BT_RESULT CheckBTModuleForDTC(void) = 0;
	virtual BT_RESULT CheckBTModuleForReset(void) = 0;
    virtual BT_RESULT CheckBTModuleForAlive(void) = 0;
    virtual BT_RESULT GetRemoteDevicename(void) = 0;

    virtual BT_RESULT UARTOpen(void) = 0;
	virtual BT_RESULT UARTClose(void) = 0;
    virtual BT_RESULT UARTReopen(void) = 0;
//[20121128, TROY] no use
#if 0
	virtual BT_RESULT AddBtContact(BT_PBAP_CONTACT *contact) = 0;
	virtual BT_RESULT EditBtContact(BT_PBAP_CONTACT *contact) = 0;
	virtual BT_RESULT RemoveBtContact(BT_PBAP_CONTACT *contact) = 0;
	virtual BT_RESULT AddBtLocalContact(BT_PBAP_CONTACT *contact) = 0;
	virtual BT_RESULT EditBtLocalContact(BT_PBAP_CONTACT *contact) = 0;
	virtual BT_RESULT RemoveBtLocalContact(BT_PBAP_CONTACT *contact) = 0;
	virtual BT_RESULT RemoveBtLocalContacts(bool *p_bRemoveFlag) = 0;
	virtual BT_RESULT RemoveBtAllContactsWithBDAddr(char *strBdAddress) = 0;
	virtual BT_RESULT RemoveBtAllPhoneBooks(void) = 0;
	virtual BT_RESULT RemoveBtCallHistory(void) = 0;
#endif

	virtual BT_RESULT UpgradeStart(void) = 0;

	// Don't use the below APIs, only for Test App.
	virtual BT_RESULT TestSetMessageIndication(BT_MAP_MSG_NOTIFY_CONF mode) = 0;
	virtual BT_RESULT TestGetMessage(BT_DEVICE_ID id, UINT16 msg_id) = 0;
	virtual BT_RESULT TestSetMessageStatus(BT_DEVICE_ID paired_id, UINT16 msg_id, BT_MAP_MSG_READ_STATUS status) = 0;
	virtual BT_RESULT TestAbortMessageRetreival(BT_DEVICE_ID paired_id) = 0;
	virtual BT_RESULT TestUpdateMessageInbox(BT_DEVICE_ID paired_id) = 0;
	virtual BT_RESULT TestSetMessageFolder(BT_DEVICE_ID paired_id, BT_MAP_FLDR_MODE mode, QString folder_name) = 0;
	virtual BT_RESULT TestGetMessageFolderDetails(void) = 0;
	virtual BT_RESULT TestGetMessageList(BT_DEVICE_ID paired_id, UINT16 start_index, UINT16 size, QString name) = 0;
	virtual BT_RESULT EchoTest(BT_ECHO *bt_echo) = 0;

	virtual BT_RESULT SetIPodStatus(BTAPP_IPOD_STATUS tAppleDevice) = 0;
	virtual BT_RESULT GetIPodStatus(void) = 0;

	virtual BT_RESULT SetBTVoiceRecognitionMode(BOOL bOnOff) = 0;
	virtual BT_RESULT SetSiriEyesFreeMode(BOOL bOnOff) = 0;
	
	virtual BT_RESULT DiagnosticStart(int iSec) = 0;
	virtual BT_RESULT DiagnosticStop(void) = 0;

//#ifdef __PROJECTION__
    //projection
    virtual BT_RESULT SSPOOBPairingRequest(BT_SSPOOB_REQ value) = 0;
    virtual BT_RESULT SetAAPMode(BTAPP_AAP_MODE value) = 0;
    virtual BT_RESULT GetAAPMode(void) = 0;
    virtual BT_RESULT DisconnectProfile(char *strBdAddress, BT_SERVICE_DESCR btServiceDescr) = 0;
    virtual BT_RESULT SetEnableFordPatentMode(BOOL bOnOff) = 0;
    virtual BT_RESULT GetEnableFordPatentMode(void) = 0;
//#endif

    //IQS_16MY
    virtual BT_RESULT GetPBAPSupport(void) = 0;

};

#endif // __BT_IBTCONTROLLERINTERFACE_H__
