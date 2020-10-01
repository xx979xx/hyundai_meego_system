#ifndef __COMMON_APP_H__
#define __COMMON_APP_H__

#include "common/type.h"

#define SHMKEY_INCOMING_CALL	"258011"
#define SHMKEY_OUTGOING_CALL	"258012"
#define SHMKEY_MISSED_CALL		"258013"
#define SHMKEY_COMBINED_CALL	"258014"

typedef enum {
	APP_EVENT_BLUETOOTH_READY = 0,
	APP_EVENT_BLUETOOTH_ADDRESS = 1,
	APP_EVENT_BLUETOOTH_DEVICE_DISCOVERY = 2,
	APP_EVENT_BLUETOOTH_DEVICE_DISCOVERY_DONE = 3,
	APP_EVENT_BT_MODULE_INFO = 4,
	APP_EVENT_LOCAL_DEVICE_NAME = 5,
	APP_EVENT_DEVICE_PAIRING_RESULT = 6,
	APP_EVENT_SSP_REQUEST = 7,
	APP_EVENT_LEGACY_PAIRING_REQUEST = 8,
	APP_EVENT_SSP_MODE = 9,
	
	APP_EVENT_PAIRED_DEVICE_LIST = 10,
	APP_EVENT_PAIRED_COUNT = 11,
	APP_EVENT_PAIRED_DEVICE_INFO = 12,
	APP_EVENT_PAIRED_DEVICE_INFO_DONE = 13,
	APP_EVENT_PAIRED_DEVICE_DELETE = 14,
	APP_EVENT_BT_MODULE_STATE = 15,
	APP_EVENT_HFP_FORD_MODE = 16,
	APP_EVENT_BT_MODULE_ERROR = 17,
	APP_EVENT_BT_MODULE_RESET = 18,
	APP_EVENT_BT_MODULE_TIMEOUT = 19,
	
	APP_EVENT_DEVICE_LINKLOSS = 20,
	APP_EVENT_HANDSFREE_CONNECTED = 21,
	APP_EVENT_HANDSFREE_DISCONNECTED = 22,
	APP_EVENT_A2DP_CONNECTED = 23,
	APP_EVENT_A2DP_DISCONNECTED = 24,
	APP_EVENT_AVRCP_CONNECTED = 25,
	APP_EVENT_AVRCP_DISCONNECTED = 26,
	APP_EVENT_PHONEBOOK_CONNECTED = 27,
	APP_EVENT_PHONEBOOK_DISCONNECTED = 28,
	APP_EVENT_SERIAL_CONNECTED = 29,
	APP_EVENT_SERIAL_DISCONNECTED = 30,
	APP_EVENT_MESSAGE_CONNECTED = 31,
	APP_EVENT_MESSAGE_DISCONNECTED = 32,
	
    APP_EVENT_DEFAULT_PROFILE_CONNECT_DONE = 40,
	APP_EVENT_DEFAULT_PROFILE_CONNECT_NOTHING = 41,
	APP_EVENT_AUTO_CONNECT_START = 42,
	APP_EVENT_CONNECT_CANCLE_DONE = 43,
	APP_EVENT_INCOMING_CONNECT_CANCLE_DONE = 44,
	APP_EVENT_HANDSFREE_BTM_ECNR_CONFIG = 45,
	APP_EVENT_HANDSFREE_AG_ECNR_CONFIG = 46,
	APP_EVENT_HANDSFREE_CALL_INDICATOR = 47,
	APP_EVENT_HANDSFREE_MIC_VOLUME = 48,
	APP_EVNET_HANDSFREE_INBANDRING = 49,
	APP_EVENT_HANDSFREE_CALL_STATUS = 50,
	APP_EVENT_HANDSFREE_CALL_STATUS_NEW = 51,
	APP_EVENT_HANDSFREE_CALL_SETUP = 52,
	APP_EVENT_HANDSFREE_CALL_HELD = 53,
	APP_EVENT_HANDSFREE_CALL_LINE_INFO = 54,	// +CLIP
	APP_EVENT_HANDSFREE_CALL_WAITING_NUMBER = 55,	// +CCWA
	APP_EVENT_HANDSFREE_BATTERY = 56,
	APP_EVENT_HANDSFREE_SIGNAL = 57,
	APP_EVENT_HANDSFREE_ROAM_STATUS = 58,
	APP_EVENT_HANDSFREE_SERVICE = 59,	
	APP_EVENT_HANDSFREE_AUDIOPATH = 60,
	APP_EVNET_HANDSFREE_INBANDRING_SUPPORT = 61,
	APP_EVNET_HANDSFREE_GENERAL_ERROR = 62,
	APP_EVNET_HANDSFREE_BVRA_MODE = 63,
	APP_EVNET_HANDSFREE_SIRI_STATUS = 64,
	APP_EVNET_HANDSFREE_SIRI_EFM_SETTED = 65,
	APP_EVNET_HANDSFREE_SET_BVRA_MODE_FAIL = 66,
	APP_EVNET_HANDSFREE_SET_SIRI_EFM_FAIL = 67,
	APP_EVNET_HANDSFREE_SET_BVRA_MODE_OK = 68,
	APP_EVNET_HANDSFREE_RINGING = 69,
	
	APP_EVENT_AUDIO_AV_MUTE_MODE = 70,
	APP_EVENT_AUDIO_CURRENT_INFO = 71,
	APP_EVENT_AUDIO_PLAY_IND = 72,
	APP_EVENT_AUDIO_STOP_IND = 73,
	APP_EVENT_AUDIO_PAUSE_IND = 74,
	APP_EVENT_AUDIO_TRACK_IND = 75,
	APP_EVENT_AUDIO_REPEAT_MODE = 76,
	APP_EVENT_AUDIO_SHUFFLE_MODE = 77,
	APP_EVENT_AUDIO_STREAMING_START = 78,
	APP_EVENT_AUDIO_STREAMING_SUSPEND = 79,
	
	APP_EVENT_PHONEBOOK_AT_DOWNLOAD_SUPPORT = 80,
	APP_EVENT_PHONEBOOK_START = 81,
	APP_EVENT_PHONEBOOK_END = 82,
	APP_EVENT_CALL_HISTORY_START = 83,
	APP_EVENT_CALL_HISTORY_END = 84,
	
	APP_EVENT_PHONEBOOK_FULL = 86,
	APP_EVENT_PHONEBOOK_COUNT = 87,
	APP_EVENT_CALL_HISTORY_COUNT = 88,
	APP_EVENT_INCOMING_CALL_HISTORY_UPDATE = 89,
	APP_EVENT_OUTGOING_CALL_HISTORY_UPDATE = 90,
	APP_EVENT_MISSED_CALL_HISTORY_UPDATE = 91,
	APP_EVENT_LOCAL_PHONEBOOK_UPDATE = 92,
	APP_EVENT_LOCAL_PHONEBOOK_ADD_FAIL = 93,
	APP_EVENT_PHONEBOOK_ABORT = 94,
#ifdef _FOR_VR_PERFORMANCE_
	APP_EVENT_PHONEBOOK_SAME = 95,
#endif

	APP_EVENT_SERVICE_MESSAGE = 100,	

	APP_EVENT_DIAGNOSTIC_FOR_DTC_RESULT = 104,
	APP_EVENT_DIAGNOSTIC_FOR_RESET_RESULT = 105,

	APP_EVENT_FW_BLOCK_COUNT = 111,
	APP_EVENT_FW_UPDATE_FAIL = 112,
	APP_EVENT_FW_UPDATE_DONE = 113,

	APP_EVENT_TESTCMD_UART_MODE = 121,	// UART loop-back mode
	APP_EVENT_TESTCMD_SSP_MODE = 122,	// SSP debug mode
	APP_EVENT_TESTCMD_DUT_MODE = 123,	// DUT mode
    APP_EVENT_TESTCMD_ADC_MODE = 124,	// ADC mode

	APP_EVENT_BLUETOOTH_DEVICE_RSSI = 130,
	
	APP_EVENT_IBOX_CONTACT_END = 152,
	APP_EVENT_IPOD_STATUS = 153,
	APP_EVENT_SET_IPOD_STATUS_FAIL = 154,

	APP_EVENT_REQUEST_ERROR_CONNECTION = 160,
	APP_EVENT_AUDIO_CURRENT_INFO_TIMEOUT = 171,

    APP_EVENT_BACM_MODE = 180,

    APP_EVENT_ALIVE = 181,
    APP_EVENT_GET_REMOTE_DEVICENAME = 182,

    APP_EVENT_SPP_DATA_RECEIVED = 250,

    APP_EVENT_GET_ECNR_VERSION = 260,
    APP_EVENT_SET_ECNR_VERSION_DONE = 261,
    APP_EVENT_SET_ECNR_PRAMETER_DONE = 262,

    APP_EVNET_HANDSFREE_MANUFACT_ID = 200,
    APP_EVNET_HANDSFREE_MODEL_ID = 201,
    APP_EVNET_HANDSFREE_REVISION_ID = 202,
//#ifdef UPDATE_PB_DATA
    APP_EVENT_PHONEBOOK_NOT_SAME = 203,
//#endif
//IQS_16MY
    APP_EVENT_PHONEBOOK_NOT_SUPPORT = 204,
//17MY IQS
    APP_EVENT_AUDIO_PLAYER_MODE = 205,
    APP_EVENT_AAP_MODE = 206,
    APP_EVENT_FPM_FORD_MODE = 207
} APP_EVENT_ID;

typedef enum {
	UNKNOWN_RING_TYPE,
	GENERAL_RING_TYPE,
	IN_BAND_RING_TYPE
} BTAPP_RING_TYPE;

typedef enum {
	ACCEPT_BY_HMI,
	ACCEPT_BY_PHONE
} BTAPP_ACCEPT_TYPE;

typedef enum {
	BTAPP_OUTGOING_CALL,
	BTAPP_INCOMING_CALL,
	BTAPP_MISSED_CALL,
	BTAPP_UNKNOWN_CALL
} BTAPP_CALL_HISTORY_TYPE;

typedef enum {
	BTAPP_CONNECT_FAIL,
	BTAPP_CONNECT_SUCCESS,
	BTAPP_CONNECT_NOT_SUPPORT
} BTAPP_CONNECT_RESULT;

typedef enum {
	BTAPP_NO_SELECT_DEVICE,
	BTAPP_SELECT_DEVICE_P0,
	BTAPP_SELECT_DEVICE_P1,
	BTAPP_SELECT_DEVICE_P2,
	BTAPP_SELECT_DEVICE_P3,
	BTAPP_SELECT_DEVICE_P4
} BTAPP_AUTOCONNECT_DEVICE;

struct BTAPP_DEVICE_PAIRED_LIST {
	int iPairedCount;
	BT_PAIRED_DEVINFO btPairedDeviceInfo[MAX_PAIRED_DEVICE_COUNT];
};

struct BTAPP_SERVICE_CONNECT {
	char strBdAddress[BD_ADDRESS_LENGTH+1];
	int iPairedID;
	BTAPP_CONNECT_RESULT btResult;
	AVRCP_VERSION_SUPPORT btAvrcpVersion;
};

struct BTAPP_SERVICE_ENABLE {
	BOOL bHandsfreeEnable;
	BOOL bAudioEnable;
	BOOL bPhonebookEnable;
	BOOL bMessageEnable;
	BOOL bSerialEnable;
	BOOL bA2DPEnable;
	BOOL bAVRCPEnable;
	BOOL bRsvdService01;
};

struct BTAPP_SERVICE_DESCRIPTION {
	BOOL bHFPSupport;
	BOOL bA2DPSupport;
	BOOL bAVRCPSupport;
	BOOL bPBAPSupport;
	BOOL bMAPSupport;
	BOOL bSPPSupport;
	BOOL bRsvdSupport01;
	BOOL bRsvdSupport0;	
};

//[20121128, TROY] no use
#if 0
struct BTAPP_CALL_STATUS {
	BT_CALL_STATUS btCallStatus;
	char cstrCallNumber[MAX_CALL_NUM_LEN+1];
	BTAPP_RING_TYPE btappRingType;
#if 0
	BTAPP_ACCEPT_TYPE btapp_accept_type;
#endif
};

struct BTAPP_3WAY_CALL_STATUS {
	BT_3WAY_CALL_STATUS bt3WayCallStatusFirst;
	char cstrCallNumberFirst[MAX_CALL_NUM_LEN+1];
	BT_3WAY_CALL_STATUS bt3WayCallStatusSecond;
	char cstrCallNumberSecond[MAX_CALL_NUM_LEN+1];
};
#endif

struct BTAPP_CURRENT_PLAY_INFO {
	int iTrackNumber;
	int iTotalTrackNumber;
	int iPlayTime;
	char cstrTitle[AUDIO_INFO_DATA_LENGTH+1];
	char cstrArtist[AUDIO_INFO_DATA_LENGTH+1];
	char cstrAlbumNam[AUDIO_INFO_DATA_LENGTH+1];
	char cstrGenere[AUDIO_INFO_DATA_LENGTH+1];
};

struct BTAPP_AUTOCONNECT_PRIORITY {
	int iConnectCount;
	char cstrAutoList[MAX_PAIRED_DEVICE_COUNT][BD_ADDRESS_LENGTH+1];
};

struct BTAPP_AUTOCONNECT {
	BT_ENABLE_AUTO_CONNECT btAutoConnectMode;
	int iSelectValid;
	int iPriorytyCount;
	char cstrAutoListSelect[BD_ADDRESS_LENGTH+1];
	char cstrAutoListPriority[MAX_PAIRED_DEVICE_COUNT][BD_ADDRESS_LENGTH+1];
};

struct BTAPP_CALL_HISTORY {
	char first_name[PB_FIRST_NAME_LEN+1];		// PB_FIRST_NAME_LEN is 80
	char last_name[PB_LAST_NAME_LEN+1];			// PB_LAST_NAME_LEN is 80
	char phone_number[PB_MOBILE_NUM_LEN+1];		// PB_MOBILE_NUM_LEN is 25
	char time_stamp[PB_TIME_STAMP_LEN+1];		// PB_TIME_STAMP_LEN is 20
	BTAPP_CALL_HISTORY_TYPE call_type;
};

struct BTAPP_CALL_HISTORY_LIST {
	int iCallHistoryCount;
	BTAPP_CALL_HISTORY btappCallHistoryList[MAX_CALL_HISTORY_NUM];	// MAX_CALL_HISTORY_NUM is 20
};

struct BTAPP_COMBINED_CALL_HISTORY_LIST {
	int iCallHistoryCount;
	BTAPP_CALL_HISTORY btappCallHistoryList[MAX_CALL_HISTORY_NUM*3];	// MAX_CALL_HISTORY_NUM is 20 *3 // 60
};

struct BTAPP_IPOD_STATUS {
	int iPortNumber;
	BOOL bIsConnect;
	char cstrDeviceName[MAX_DEVICE_NAME_LENGTH+1];
};

struct BTAPP_DELETE_DEVICE_LIST {
	BOOL bDeleteDeviceP0;
	BOOL bDeleteDeviceP1;
	BOOL bDeleteDeviceP2;
	BOOL bDeleteDeviceP3;
	BOOL bDeleteDeviceP4;
    BOOL bDeleteDeviceP5;
};

#endif /* __COMMON_APP_H__ */