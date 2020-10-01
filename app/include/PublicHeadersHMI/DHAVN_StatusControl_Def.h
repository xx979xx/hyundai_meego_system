#ifndef STAUSCONTROLADAPTER_GLOBAL_H
#define STAUSCONTROLADAPTER_GLOBAL_H

#include <QtCore/qglobal.h>
#include <QObject>

#if defined(STATUSCONTROLADAPTER_LIBRARY)
#  define STATUSBARCONTROLSHARED_EXPORT Q_DECL_EXPORT
#else
#  define STATUSCONTROLADAPTERSHARED_EXPORT Q_DECL_IMPORT
#endif

#define CLUSTER_STRING_LENGHT 256
#define CLUSTER_SHORT_STRING_LENGHT 36

const static QString STATUS_BAR_SPLIT("::");
const static QString STATUS_BAR_MACRO_SPLIT("&&");
/** state indicators list */
typedef enum
{
   STATUS_NONE = 0,

    /** BT Connection: Slot-0*/
    STATUS_BT_CONNECTION,            /** need delete after remove QmlStatusbarWidget 1.0 */
    STATUS_BT_TYPE,

    /** BT IN Call: Slot-1*/
    STATUS_BT_TALKING,               /** BT talking now, second argument  bool (yes/no) */

    /** 3G Section: Slot-2*/
    STATUS_MTS_MODEM_DATA,            /** Curent network data type, second uint */

    /** WiFi: Slot-3*/
    STATUS_WIFI,                     /** need delete after remove QmlStatusbarWidget 1.0 */
    STATUS_WIFI_LEVEL,               /** need delete after remove QmlStatusbarWidget 1.0 */
    STATUS_WIFI_MODE,                 /** Wifi Mode: AP/Client/Direct, second argument uint(0x01,0x02,0x03)*/

    /** TMC (EU -only): slot - 4*/
    STATUS_TMC,

    /** NEWS (EU -only) : slot - 5*/
    STATUS_NEWS,

    /** TA (EU -only): slot - 6*/
    STATUS_TA,

    /**  HU - Group: Navi Sound off: slot - 7*/
    STATUS_NAVI_SOUND,               /** Navi sound active, second argument  bool (on/off) */

    /**  HU - Group: AV Sound off: slot - 8*/
    STATUS_AV_SOUND,                 /** AV sound active, second argument  bool (on/off) */

    /**  HU - Group: RSE Lock: slot - 9*/
    STATUS_RSE_LOCK,                 /** rear monitor unable, second argument  bool (on/off) */

    /**  HU - Group: Copying file: slot - 10*/
    STATUS_FILES_COPIED,             /** files coping, second argument  bool (on/off) */

    /**  HU - Group: HD Radio: slot - 11*/
    STATUS_HD_RADIO,

    /**  HU - Group: Searching Media File: slot - 12*/
    STATUS_MEDIA_SEARCHING,

    /**  Connectivity - Group: Wibro: slot - 13*/
    STATUS_WIBRO,

    /**  Receive Info(TPEG, TPEG notify): slot - 14*/
    STATUS_TPEG,                     /** TPEG , second argument  bool (on/off) */

    /**  About Call (Down Phone Book, Down Recent Call): slot - 15*/
    STATUS_PHONE_BOOK_DOWNLOADING,    /** phone book is downloading, second argument  bool (on/off) */
    STATUS_RECENT_CALL_DOWNLODING,   /** recent call is downloading, second argument  bool (on/off) */

    /**  About Call (BT Missed call): slot - 16*/
    STATUS_BT_MISSED_CALLS,          /** missed BT message is avaliable, second argument  bool (yes/no) */

    /**  About Call (BT Battery): slot - 17*/
    STATUS_BATTERY,                  /** battary leven, second argument int - level TBD */

    /**  About Call (BT RSSI): slot - 18*/
    STATUS_BT_RSSI,                  /** BT RSSI, second argument  bool (yes/no) */

    /**  About Call (BT Mute): slot - 19*/
    STATUS_BT_MUTE,                  /** BT MUTE, second argument  bool (yes/no) */

    /**  MTS Group (Front call/Rear call/MIC off): slot - 20*/
    STATUS_MTS_USER_MODE,             /** MTS Group -  Front Active Calling/ Rear Active Calling/ PrivateMode/ Mic off */

    /**   MTS Group (RSSI): slot - 21*/
    STATUS_MODEM_LEVEL,              /** Current modem level, second argument uint (0x00 ..0x05)*/

    /**   MTS Group (Missed call): slot - 22*/
    STATUS_MTS_MISSED_CALLS,         /** missed MTS message is avaliable, second argument  bool (yes/no) */

    /**   MTS Group (POI Info): slot - 23*/
    STATUS_MTS_INFO,                 /** new MTS information is avaliable, second argument  bool (yes/no)  */

    /** APP - Group: slot - 24*/
    STATUS_APP_INSTALL,
    STATUS_APP_INSTALL_PROGRESS,

    /** Temperature Indicator*/
    STATUS_TEMPERATURE_OUT,          /** current temperature outside car, second argument  int - temperature */
    STATUS_TEMPERATURE_DRIVER,       /** current temperature on driver seat, second argument  int - temperature */
    STATUS_TEMPERATURE_PASSANGER,    /** current temperature on secind seat, second argument  int - temperature */
    STATUS_TEMPERATURE_REAR,         /** current temperature on rear seats, second argument  int - temperature */
    STATUS_TEMPERATURE_DISPLAY_MODE,      /** cureent temperarure display mode, second argument uint( off/Centigrade/Fahrenheit) */
    /** conditioner states*/
    STATUS_CONDITIONER_SPEED,        /** current conditioner speed, second argument  int - speed */
    STATUS_DRIVER_CONDITIONER_DIRECTION,    /** current driver conditioner direction, second argument  int - conditioner */
    STATUS_PASSENGER_CONDITIONER_DIRECTION, /** current passenger conditioner direction, second argument  int - conditioner */
    STATUS_CONDITIONER_MODE,         /** current conditioner mode, second argument  int - mode */
    STATUS_AIR_INCOME,               /** current air way, second argument  bool - from outdoor true/false */

    /** Not Grouped*/
    STATUS_USB_CONNECTED,            /** USB device attached, second argument  bool (mount/unmount) */
    STATUS_DMB_RECORDED,             /** DBM recording active, second argument  bool (on/off) */
    STATUS_SMART_PHONE,              /** smart phone was attached, second argument  bool (on/off) */
    STATUS_GPS_SATELITE,             /** number of active gps satelites  int - number */
    STATUS_GPS_STATE,                /** GPS is Activ (yes/no), second argument bool*/
    STATUS_NEW_INFO,                 /** new alert information is avaliable, second argument  bool (yes/no) */
    STATUS_MTS_MESSAGE,              /** need delete after remove QmlStatusbarWidget 1.0*/
    STATUS_MTS_MESSAGE_COUNT,        /** need delete after remove QmlStatusbarWidget 1.0 */
    STATUS_MTS_NON_CHECKED_MESSAGE,  /** non checked MTS message is avaliable, second argument  bool (yes/no) */
    STATUS_BT_NON_CHECKED_MESSAGE,   /** non checked BT message is avaliable, second argument  bool (yes/no) */
    STATUS_CALLS_NUMBER,             /** Full number of missted and non-cheked calls */
    STATUS_MESSAGES_NUMBER,          /** Full number of missted and non-cheked messages */
    STATUS_ACTIVE_NETWORK,           /** need delete after remove QmlStatusbarWidget 1.0 */
    STATUS_CALL_STATE_NORMAL,
    STATUS_CALL_STATE_EMERGENCY,
    STATUS_DLNA_CONNECTION,          /** DLNA connection active, second argument  bool (on/off) */
    STATUS_PBOOK,                    /** current PhoneBook Statusection active, second uint */

    /** OSD */
    /** AutoCare Indicators */
    STATUS_SUSPESNSION_HEIGHT,       /** car height. second argument is int passed from CAN */
    STATUS_SUSPESNSION_DAMPING,      /** car damping . second argument is int passed from CAN */
    STATUS_CAR_DRIVE_MODE,               /** car drive mode */

    /** Volume level          */
    STATUS_VOLUME_LEVEL,             /** Volme level. second argument is int value of volume */
    STATUS_AUDIO_MODE,               /** Audio mode. second argument is int mode from QRPMClient */

   /*climate */
   STATUS_CONDITIONER_WINDSHIELD_DEFROST,
   STATUS_CONDITIONER_REARGLASS_DEFROST,
   STATUS_CONDITIONER_C02_WARNING,
   STATUS_CONDITIONER_CLEANAIR_MODE,
   STATUS_CONDITIONER_ZONE_MODE,
   STATUS_CONDITIONER_AC_MODE,
   STATUS_CONDITIONER_AUTO,

   STATUS_WIFI_CLIENT,
   STATUS_MTS_LOCATION,
   STATUS_BT_ROAMING_RSSI

}STATUS_INDICATORS_T;

/** avaliable Date/Time formats */
typedef enum
{
   DATE_TIME_FORMAT_F = 0,    /** month Date HH:mm am(pm)*/
   DATE_TIME_FORMAT_B         /** MM DD HH:mm */
} STATUS_DATE_TIME_FORMAT_T;

/** avaliable active network type */
/** need delete after remove QmlStatusbarWidget 1.0 */
typedef enum
{
   ACTIVE_NETWORK_NONE = 0,
   ACTIVE_NETWORK_MODEM,
   ACTIVE_NETWORK_WIFI,
   ACTIVE_NETWORK_USB,
   ACTIVE_NETWORK_BT,
   ACTIVE_NETWORK_WIMAX,
   ACTIVE_NETWORK_ERROR = 0xFF
} STATUS_DATE_ACTIVE_NETWORK_T;

/** avaliable installing or downloading status */
typedef enum
{
   STATUS_INSTALL_READY = 0,
   STATUS_INSTALLING,
   STATUS_INSTALLED,
   STATUS_IMPOSSIBLE_INSTALL,
   STATUS_DOWNLOAD_READY = 0x10,
   STATUS_DOWNLOADING,
   STATUS_DOWNLOADED,
   STATUS_DOWLOAD_IMPOSSIBLE,
   STATUS_APP_INSTALL_ERROR = 0xFF
} STATUS_APP_INSTALL_T;

/** avaliable MTS mees type */
/** need delete after remove QmlStatusbarWidget 1.0 */
typedef enum
{
   MTS_MESSAGE_NO = 0,
   MTS_MESSAGE_NEW,
   MTS_MESSAGE_NOTICE,
   MTS_MESSAGE_INFO
} STATUS_MTS_MESSAGE_T;

/** avaliable MTS mees type */
typedef enum
{
   PBOOK_NO_CHANGED = 0,
   PBOOK_ADDED,
   PBOOK_DELETED,
   PBOOK_ADDED_AND_DELETED
} STATUS_PBOOK_T;

/** call status */
struct CALL_STATE
{
   int nCountIdle;
   int nCountRinging;
   int nCountActive;
   int nCountDialing;
   int nCountDisconnecting;
   int nCountOnHold;
   int nCountReestablish;
   int nCountCallingRBT;
   int nCountBusy;
   int nCountMultipartyCallRinging;
   int nCountMultipartyCallActive;
   int nCountConferenceCall;
   int nCountNotAcceptedCall;
};

/** all indicators states */
struct STATUS_AREA_INDICATORS
{
   /** BT Connection: Slot-0*/
    bool bBluetooth;              /** need delete after remove QmlStatusbarWidget 1.0*/
    int  nBTType;

    /** BT IN Call: Slot-1*/
    bool bBTTalking;              /** Indicator about talking over BT phone. */

    /** 3G Section: Slot-2*/
    int  nModemData;               /** Indicator 3G, HSDPA Network*/

    /** WiFi: Slot-3*/
    bool bWiFi;                   /** need delete after remove QmlStatusbarWidget 1.0*/
    int  nWifiMode;               /** Wifi Mode: AP/Client/Direct = 0x01,0x02,0x03)*/
    int  nWiFiLevel;              /** need delete after remove QmlStatusbarWidget 1.0 */

    /** TMC (EU -only): slot - 4*/
    bool bTMC;

    /** NEWS (EU -only) : slot - 5*/
    bool bNews;

    /** TA (EU -only): slot - 6*/
    bool bTA;

    /**  HU - Group: Navi Sound off: slot - 7*/
    bool bNAVISound;              /** Navi Sound Off Indicator*/

    /**  HU - Group: AV Sound off: slot - 8*/
    bool bAVSound;                /** AV Sound Off Indicator*/

    /**  HU - Group: RSE Lock: slot - 9*/
    bool bRSELock;                /** RSE Lock relevant Indicator */

    /**  HU - Group: Copying file: slot - 10*/
    bool bFileCopied;             /** Indicator about files are being copied*/

    /**  HU - Group: HD Radio: slot - 11*/
    bool bHDRadio;

    /**  HU - Group: Searching Media File: slot - 12*/
    bool bMediaSearch;

    /**  Connectivity - Group: Wibro: slot - 13*/
    bool bWibro;

    /**  Receive Info(TPEG, TPEG notify): slot - 14*/
    int  nTPEG;                   /** Indicator about receiving TPEG information. */

    /**  About Call (Down Phone Book, Down Recent Call): slot - 15*/
    bool bPhoneBookLoad;          /** Indicator about phone book download*/
    bool bRecentCallLoad;

    /**  About Call (BT Missed call): slot - 16*/
    bool bBTCall;                 /** Indicator about BT phone missed calls. */

    /**  About Call (BT Battery): slot - 17*/
    int  nBattery;                /** Indicator about battery information*/

    /**  About Call (BT RSSI): slot - 18*/
    int  nBTRssi;

    /**  About Call (BT Mute): slot - 19*/
    bool bBTMute;

    /**  MTS Group (Front call/Rear call/MIC off): slot - 20*/
    int  nUserMode;                /** MTS Group -  Front Active Calling/ Rear Active Calling/ PrivateMode */
    bool bMicOff;                  /** MTS Group -  Mic off */

    /**   MTS Group (RSSI): slot - 21*/
    int  nModemLevel;             /** Current modem level*/

    /**   MTS Group (Missed call): slot - 22*/
    bool bMTSCall;                /** Indicator about MTS missed calls. */

    /**   MTS Group (POI Info): slot - 23*/
    bool bMTSInfo;                /** Indicator about receiving MTS POI text messages*/

    /** APP - Group: slot - 24*/
    int  nAppInstallStatus;       /** current installing or downloading status */
    int  nAppInstallProgress;

    /** Not Grouped*/
    bool bUSB;                    /** Indicator about USB connection*/
    bool bDMBRecord;              /** Indicator about DMB is being recorded*/
    bool bSmartLinkage;           /** Indicate smart-phone linkage.*/
    bool bAlert;                  /** Indicator about alerting new information. */
    int  nMTSMessage;             /** need delete after remove QmlStatusbarWidget 1.0 */
    int  nMTSMessageCount;        /** need delete after remove QmlStatusbarWidget 1.0 */
    bool bBTMessage;           	  /** Indicator about BT phone non-checked text messages. */
    bool bMTSMessNoChecked;    	  /** Indicator about MTS non-checked text messages. */
    int  nCallsNumber;            /** Full number of missted and non-cheked calls */
    int  nMessageNumber;          /** Full number of missted and non-cheked messages */
    int  nSatelitesNumber;        /** Number of active satelites */
    int  nActivNetworkType;       /** need delete after remove QmlStatusbarWidget 1.0 */
    CALL_STATE NormalCallStates;
    CALL_STATE EmergencyCallStates;
    bool bDLNAConnection;         /** Indicator about DLNA connection*/
    int  nPBookStatus;            /** Current PhoneBook statusl*/
    bool bGPSActiv;               /** GPS is Activ (yes/no)*/

     /** Temperature Indicator*/
    int  nTemperatureOutside;     /** Current temperature GPS is Activ (yes/no)outside car. */
    int  nTemperatureRear;        /** Current temperature on rear seats.*/
    int  nTemperatureDriver;      /** Current temperature on driver seat. */
    int  nTemperatureSecond;      /** Current temperature on second seat.*/
    int  nTemperatureDisplayMode; /** Current temperature dislay mode: off/Centigrade/Fahrenheit*/

    /** conditioner states*/
    int  nConditionerSpeed;       /** Current conditioner speed. */
    int  nConditionerMode;        /** Current conditioner mode.*/
    int  nDriverConditionerDirection;   /** Current conditioner direction for driver. */
    int  nPassengerConditionerDirection;   /** Current conditioner direction for driver. */
    int  nAirWay;                 /** Current air way true - fro outside / false - inside circulation*/

     /** OSD - AutoCare Indicators */
    int  nCarDriveModeState;      /** Current car drive mode state */
    int  nSuspensionHeightState;  /** Current suspeinsion height state */
    int  nSuspensionDampingState; /** Current suspension damping state. Values are in SUSPENSION_DAMPING_STATE_T */

     /** OSD - Volume level*/
    int  nAudioVolume;            /** Volume level */
    int  nAudioMode;              /** Audio Mode. */
    bool bWindshieldDefrost;      /** Indicator of windshield defrost OnOff */
    bool bRearGlassDefrost;       /** Indicator of rear glass defrost */
    bool bCO2Warning;             /** CO2 warning indicator           */
    int  nCleanAirMode;           /** clean air indicator           */
    int  nZoneMode;               /** zone number indicator. not used   */
    bool bAC;
    int  nAuto;
    int  nWifiClient;
    bool bFriendLocation;
    int  nBTRoamingRssi;          /** BT roaming signal length. RSSI */
};



/** Need delete this block after moving public headers */
#define DATA_PROVIDER_LINK "/com/lg/qt/status_data_provider"
#define DATA_PROVIDER_PACK "com.lg.qt.status_data_provider"
#define DATA_PROVIDER_IPC_ADRESS "status_data_provider"
#define DATA_PROVIDER_NAME "StatusDataProvider"
#define DATA_PROVIDER_VERSION "1.0"
/** ------------------------------------- */

typedef enum
{
   STATE_DEFAULT = 0,           /** state normal or home (wtich was set during intialisation) */
   STATE_FATC,                  /** detail climate information */
   STATE_MEDIA,
   STATE_HEIGHT,
   STATE_DAMPING,
   STATE_OSD_VOLUME,
   STATE_INIT_MEDIA
} STATUS_BAR_STATES_T;


typedef enum
{
   BT_CONNECTED,
   BT_HANSFREE,
   BT_AUDIO,
   BT_HANSFREE_AUDIO,
   BT_NONE
} BT_STATES_T;


//OSD changes

class SB_OSD_Enum_Def: public QObject
{
   Q_OBJECT
   Q_ENUMS( EOSD_INFO_ICONS_T );
   Q_ENUMS( EOSD_MEDIA_MODE_TYPE_T );
   Q_ENUMS( E_OSD_INDICATOR_ICONS_T );
   Q_ENUMS( EOSD_MEDIA_BAR_TYPE_T );
   Q_ENUMS( E_OSD_INFO_SLOT_TYPE_T );
   Q_ENUMS( E_OSD_INDICATOR_TYPE_T );
   Q_ENUMS( E_OSD_INDICATOR_ICONS_T );
   Q_ENUMS( E_OSD_RADIO_INDICATORS_INDEXES_T );
   Q_ENUMS( E_OSD_MEDIA_INDICATORS_INDEXES_T );
   //climate enums
   Q_ENUMS( E_OSD_CLIMATE_AIR_CYCLE_T );
   Q_ENUMS( E_OSD_CLIMATE_CONDITIONER_DIRECTION_T );
   Q_ENUMS( E_OSD_CLIMATE_CONDITIONER_AUTO_MODE_T );
   Q_ENUMS( E_OSD_CLIMATE_TEMPERATURE_POSITION_T )
   Q_ENUMS( E_OSD_CLIMATE_TEMPERATURE_UNITS_T );
   Q_ENUMS( E_OSD_CLIMATE_PARAMS_T );
   Q_ENUMS( E_OSD_CLIMATE_DEFROST_POSITION_T );
   Q_ENUMS( OSD_CLIMATE_CLEAN_AIRMODE_T );
   Q_ENUMS( SUSPENSION_HEIGHT_STATE_T );
   Q_ENUMS( SUSPENSION_DAMPING_STATE_T );
   Q_ENUMS( STATUSBAR_DATEFORMAT_T );
   Q_ENUMS( CLOCK_MODE_T );
   Q_ENUMS( TIME_FORMAT_T );
   Q_ENUMS( STATUS_CONTROL_EVT_ID );
   Q_ENUMS( STATUS_BAR_POST_EVT_CMD_T );

public:

   typedef enum
   {
      OSD_INFO_ICON_NONE,
      OSD_INFO_ICON_MUSIC,
      OSD_INFO_ICON_LOADING,
      OSD_INFO_ICON_CHANNEL,
      OSD_INFO_ICON_ERROR,
      OSD_INFO_ICON_DISABLE,
      OSD_INFO_ICON_CONNECT,
      OSD_INFO_ICON_MESSAGE,
      OSD_INFO_ICON_RECEIVE_CALL,
      OSD_INFO_ICON_SEND_CALL,
      OSD_INFO_ICON_END_CALL,
      OSD_INFO_ICON_VOLUME,
      OSD_INFO_ICON_HANDSFREE,
      OSD_INFO_ICON_VIDEO,
      OSD_INFO_ICON_UP,
      OSD_INFO_ICON_DOWN,
// icon info for car drive mode
      OSD_INFO_CAR_NORMAL_DRIVE,
      OSD_INFO_CAR_SPORT_DRIVE,
      OSD_INFO_CAR_ECO_DRIVE,
      OSD_INFO_CAR_SNOW_DRIVE,
// icon info for car suspension height mode
      OSD_INFO_SUSPESNSION_HEIGHT_LOW,
      OSD_INFO_SUSPESNSION_HEIGHT_NORMAL,
      OSD_INFO_SUSPESNSION_HEIGHT_HIGH
   } EOSD_INFO_ICONS_T;

   typedef enum
   {
      OSD_MEDIA_MODE_NONE           = 0x00,
      OSD_MEDIA_MODE_RADIO_FM1      = 0x12,
      OSD_MEDIA_MODE_RADIO_FM2      = 0x13,
      OSD_MEDIA_MODE_RADIO_AM       = 0x14,
      OSD_MEDIA_MODE_DMB1_TV        = 0x23,
      OSD_MEDIA_MODE_DMB1_RADIO     = 0x24,
      OSD_MEDIA_MODE_DMB2_TV        = 0x25,
      OSD_MEDIA_MODE_DMB2_RADIO     = 0x26,
      OSD_MEDIA_MODE_RADIO_XM       = 0x31,
      OSD_MEDIA_MODE_DISC_CD        = 0x40,
      // { added by junggil 2012.10.15 for CR14567 AVP should send more detail OSD info. 
      OSD_MEDIA_MODE_DISC_CD_AUDIO  = 0x41,
      OSD_MEDIA_MODE_DISC_MP3_AUDIO = 0x42,
      OSD_MEDIA_MODE_DISC_DVD_AUDIO = 0x43,
      // } added by junggil 
      OSD_MEDIA_MODE_DISC_DVD       = 0x4B,
      // { added by junggil 2012.10.15 for CR14567 AVP should send more detail OSD info. 
      OSD_MEDIA_MODE_DISC_DVD_VIDEO = 0x4C,
      OSD_MEDIA_MODE_DISC_VCD       = 0x4D,
      // } added by junggil 
      OSD_MEDIA_MODE_IPOD           = 0x61,
      OSD_MEDIA_MODE_AUX            = 0x63,
      OSD_MEDIA_MODE_USB_AUDIO      = 0x64,
      OSD_MEDIA_MODE_USB_VIDEO      = 0x65,
      OSD_MEDIA_MODE_USB_IMAGE      = 0x66,
      OSD_MEDIA_MODE_AUX_AUDIO      = 0x67,
      OSD_MEDIA_MODE_AUX_VIDEO      = 0x68,
      OSD_MEDIA_MODE_JUKEBOX_AUDIO  = 0x71,
      OSD_MEDIA_MODE_JUKEBOX_VIDEO  = 0x72,
      OSD_MEDIA_MODE_JUKEBOX_IMAGE  = 0x73,
      OSD_MEDIA_MODE_BT_MUSIC       = 0x86,
      OSD_MEDIA_MODE_DLNA_AUDIO     = 0xB1,
      OSD_MEDIA_MODE_DLNA_VIDEO     = 0xB2,
      OSD_MEDIA_MODE_DLNA_IMAGE     = 0xB3,
      OSD_MEDIA_MODE_RADIO_SXM      = 0xD4,
      OSD_MEDIA_MODE_RADIO_SXM1     = 0xD5,
      OSD_MEDIA_MODE_RADIO_SXM2     = 0xD6,
      OSD_MEDIA_MODE_RADIO_SXM3     = 0xD7,
      OSD_MEDIA_MODE_VOLUME_AV      = 0xD8,
      OSD_MEDIA_MODE_VOLUME_AUX     = 0xD9,
      OSD_MEDIA_MODE_VOLUME_PHONE   = 0xDA,
      OSD_MEDIA_MODE_VOLUME_NAVI    = 0xDB,
      OSD_MEDIA_MODE_VOLUME_VR      = 0xDC,
      OSD_MEDIA_MODE_VOLUME_BELL    = 0xDD,
      OSD_MEDIA_MODE_VOLUME_INFO    = 0xDE,
      OSD_MEDIA_MODE_PANDORA        = 0xEF,
      OSD_MEDIA_MODE_DMB            = 0xF0,
      OSD_MEDIA_MODE_PHONE          = 0xF1,
      OSD_MEDIA_MODE_DISC           = 0xF2,
      OSD_MEDIA_MODE_USB            = 0xF3,
      OSD_MEDIA_MODE_JUKEBOX        = 0xF4,
      OSD_MEDIA_MODE_RADIO_DAB      = 0xF5,
      OSD_MEDIA_MODE_RADIO_DAB1     = 0xF6,
      OSD_MEDIA_MODE_RADIO_DAB2     = 0xF7,
      OSD_MEDIA_MODE_RADIO_DAB3     = 0xF8,
      OSD_MEDIA_MODE_RADIO_FM       = 0xF9,
      OSD_MEDIA_MODE_RADIO_MW       = 0xFA,
      OSD_MEDIA_MODE_DLNA           = 0xFB,
      OSD_MEDIA_MODE_PHONE_BL       = 0xFC,
      // car drive mode
      OSD_CAR_DRIVE_MODE            = 0xFD,
      // car suspension height mode
      OSD_SUSPESNSION_HEIGHT_MODE   = 0xFE,
      OSD_MODE_INVALID              = 0xFF
   } EOSD_MEDIA_MODE_TYPE_T;

   typedef enum
   {
      OSD_MEDIA_BAR_NONE,
      OSD_MEDIA_BAR_INFO,
      OSD_MEDIA_BAR_WARNING,
      OSD_MEDIA_BAR_LOADING,
// new name items
      OSD_RADIOTV_BAR_TYPE,
      OSD_MEDIA_BAR_TYPE,
      OSD_IBOX_BAR_TYPE,
      OSD_INFO_BAR_TYPE,
      OSD_VOLUME_BAR_TYPE,
      OSD_GARAGE_BAR_TYPE,
      OSD_AC_BAR_TYPE,
      OSD_CENTER_INFO_BAR_TYPE,
      OSD_PANDORA_BAR_TYPE
   } EOSD_MEDIA_BAR_TYPE_T;

   typedef enum
   {
      OSD_INFO_SLOT_TYPE_NONE,
      OSD_INFO_SLOT_TYPE_ICON, //predefined icons
      OSD_INFO_SLOT_TYPE_ICON_PATH
   } E_OSD_INFO_SLOT_TYPE_T;

   typedef enum
   {
      OSD_INDICATOR_NONE,
      OSD_INDICATOR_TEXT,
      OSD_INDICATOR_ICON, //predefined icons
      OSD_INDICATOR_ICON_PATH
   } E_OSD_INDICATOR_TYPE_T;

   typedef enum
   {
      OSD_ICON_NONE,
      OSD_ICON_HD,
      OSD_ICON_SCAN,
      OSD_ICON_SHUFFLE,
      OSD_ICON_REPEAT,
      OSD_ICON_REPEAT_ONE
   } E_OSD_INDICATOR_ICONS_T;

   // this values can be used to put appropriate data to indicator in RADIO OSD
   // sample usage:  stIndicatorsList[OSD_RADIO_INDICATOR_HD_ICON_ITEM].stType == ....
   typedef enum
   {
      OSD_RADIO_INDICATOR_HD_ICON = 0,
      OSD_RADIO_INDICATOR_TEXT,
      OSD_RADIO_INDICATOR_SCANNING_ICON
   } E_OSD_RADIO_INDICATORS_INDEXES_T;

   typedef enum
   {
      OSD_MEDIA_INDICATOR_SCANNING_ICON = 0,
      OSD_MEDIA_INDICATOR_SHUFFLE_ICON,
      OSD_MEDIA_INDICATOR_REPEAT_ICON,
      OSD_MEDIA_INDICATOR_COUNT_TEXT,
      OSD_MEDIA_INDICATOR_PLAYBACK_TEXT,
      OSD_MEDIA_INDICATOR_TOTAL_TEXT = OSD_MEDIA_INDICATOR_COUNT_TEXT,
      OSD_MEDIA_INDICATOR_TRACK_TEXT = OSD_MEDIA_INDICATOR_PLAYBACK_TEXT

   } E_OSD_MEDIA_INDICATORS_INDEXES_T;

   typedef enum
   {
      OSD_CLIMATE_AIR_CYCLE_INDOOR,
      OSD_CLIMATE_AIR_CYCLE_OUTDOOR,
      OSD_CLIMATE_AIR_CYCLE_AUTO
   } E_OSD_CLIMATE_AIR_CYCLE_T;

   typedef enum
   {
      OSD_CLIMATE_CONDITIONER_DIRECTION_OFF = 0,
      OSD_CLIMATE_CONDITIONER_DIRECTION_VENT,
      OSD_CLIMATE_CONDITIONER_DIRECTION_BL,
      OSD_CLIMATE_CONDITIONER_DIRECTION_FLOOR,
      OSD_CLIMATE_CONDITIONER_DIRECTION_MIX,
      OSD_CLIMATE_CONDITIONER_DIRECTION_DEF,
      OSD_CLIMATE_CONDITIONER_DIRECTION_AUTO_DEFOG
   } E_OSD_CLIMATE_CONDITIONER_DIRECTION_T;

   typedef enum
   {
      OSD_CLIMATE_CONDITIONER_MODE_OFF = 0,
      OSD_CLIMATE_CONDITIONER_MODE_ON,
      OSD_CLIMATE_CONDITIONER_MODE_NOT_USED,
      OSD_CLIMATE_CONDITIONER_MODE_INVALID
   } E_OSD_CLIMATE_CONDITIONER_AUTO_MODE_T;

   typedef enum
   {
      OSD_CLIMATE_TEMPERATURE_POSITION_DRIVER,
      OSD_CLIMATE_TEMPERATURE_POSITION_PASSENGER,
      OSD_CLIMATE_TEMPERATURE_POSITION_REAR
   } E_OSD_CLIMATE_TEMPERATURE_POSITION_T;

   typedef enum
   {
      OSD_CLIMATE_TEMPERATURE_UNITS_CELCIUS,
      OSD_CLIMATE_TEMPERATURE_UNITS_FARENHEIT
   } E_OSD_CLIMATE_TEMPERATURE_UNITS_T;


   typedef enum
   {
      OSD_CLIMATE_PARAM_CONDITIONER_MODE,
      OSD_CLIMATE_PARAM_CYCLE_MODE,
      OSD_CLIMATE_PARAM_CONDITIONER_SPEED,
      OSD_CLIMATE_PARAM_CONDITIONER_DIRECTION
   } E_OSD_CLIMATE_PARAMS_T;

   typedef enum
   {
      OSD_CLIMATE_DEFROST_POSITION_WINDSHIELD,
      OSD_CLIMATE_DEFROST_POSITION_REARGLASS
   } E_OSD_CLIMATE_DEFROST_POSITION_T;

   typedef enum
   {
      OSD_CLIMATE_CLEAN_AIRMODE_OFF = 0,
      OSD_CLIMATE_CLEAN_AIRMODE_CLEAN,
      OSD_CLIMATE_CLEAN_AIRMODE_ION
   } OSD_CLIMATE_CLEAN_AIRMODE_T;

   typedef enum
   {
      SUSPENSION_HEIGHT_STATE_OFF,
      SUSPENSION_HEIGHT_STATE_RESERVED_01,
      SUSPENSION_HEIGHT_STATE_RESERVED_02,
      SUSPENSION_HEIGHT_STATE_LOW,
      SUSPENSION_HEIGHT_STATE_HIGHWAY,
      SUSPENSION_HEIGHT_STATE_NORMAL,
      SUSPENSION_HEIGHT_STATE_OFFROAD,
      SUSPENSION_HEIGHT_STATE_HIGH
   } SUSPENSION_HEIGHT_STATE_T;

   typedef enum
   {
      SUSPENSION_DAMPING_STATE_AUTO,
      SUSPENSION_DAMPING_STATE_SOFT,
      SUSPENSION_DAMPING_STATE_HARD
   } SUSPENSION_DAMPING_STATE_T;

   typedef enum
   {
      STATUSBAR_DATEFORMAT_MMDD,
      STATUSBAR_DATEFORMAT_DDMM
   }
   STATUSBAR_DATEFORMAT_T;

   typedef enum
   {
      HOME_BTN_SHOW,
      HOME_BTN_HIDE,
      JOG_RELEASE,
      JOG_PRESS,
      JOG_CLICK,
      JOG_FOCUS
   } STATUS_BAR_POST_EVT_CMD_T;
};

struct OSD_TEXT
{
   wchar_t sText[CLUSTER_STRING_LENGHT];
   wchar_t sColor[CLUSTER_STRING_LENGHT];
};

union OSD_INDICATOR_UNION
{
   SB_OSD_Enum_Def::E_OSD_INDICATOR_ICONS_T eIndicatorIconID;
   OSD_TEXT stText;
   wchar_t sIconPath[CLUSTER_STRING_LENGHT];
};

struct OSD_INDICATOR
{
   SB_OSD_Enum_Def::E_OSD_INDICATOR_TYPE_T stType;
   OSD_INDICATOR_UNION uIndicator;
};


union OSD_INFO_ICON_UNION
{
   wchar_t sIcon[CLUSTER_STRING_LENGHT];
   SB_OSD_Enum_Def::EOSD_INFO_ICONS_T eInfoIconID;
};

struct OSD_INFO_ICON
{
   OSD_INFO_ICON_UNION uIconData;
   SB_OSD_Enum_Def::E_OSD_INFO_SLOT_TYPE_T eType;
};

struct OSD_MEDIA_INFO
{
   SB_OSD_Enum_Def::EOSD_MEDIA_MODE_TYPE_T eModeType;
   SB_OSD_Enum_Def::EOSD_MEDIA_BAR_TYPE_T eBarType;
   OSD_INFO_ICON stInfoIcon;
   OSD_TEXT stText1;
   OSD_TEXT stText2;
   OSD_INDICATOR stIndicatorsList[5];
};

struct OSD_CLIMATE_INFO
{
   SB_OSD_Enum_Def::EOSD_MEDIA_BAR_TYPE_T                  eBarType;
   SB_OSD_Enum_Def::E_OSD_CLIMATE_CONDITIONER_DIRECTION_T  stInfoIcon1;
   SB_OSD_Enum_Def::E_OSD_CLIMATE_CONDITIONER_DIRECTION_T  stInfoIcon2;
   SB_OSD_Enum_Def::E_OSD_CLIMATE_CONDITIONER_AUTO_MODE_T  eAutoMode;
   SB_OSD_Enum_Def::OSD_CLIMATE_CLEAN_AIRMODE_T            eWindStrengthModeType;
   bool    bEnabledDual;        // 0:single, 1:dual
   bool    bEnabledAC;          // 0:off,    1:on
   int     nWindStrength;       // 0:off,    1:0 level, ..., 9:8 level, 10~14:not used, 15:invalid
   wchar_t sText1[CLUSTER_SHORT_STRING_LENGHT]; // Driver information
   wchar_t sText2[CLUSTER_SHORT_STRING_LENGHT]; // Passenger information
};

typedef enum
{
   OSD_MEDIA_EMPTY = 0,
   OSD_MEDIA_ICON = 1,
   OSD_MEDIA_TEXT_1 = 2,
   OSD_MEDIA_TEXT_2 = 4,
   OSD_MEDIA_INDIC = 8,
   OSD_MEDIA_SHORT_UPDATE = 16

}OSD_MEDIA_CONTAINER_BODY_TYPES;

struct OSD_MEDIA_CONTAINER_HEADER
{
   SB_OSD_Enum_Def::EOSD_MEDIA_MODE_TYPE_T eModeType;
   SB_OSD_Enum_Def::EOSD_MEDIA_BAR_TYPE_T eBarType;
   int eType; //bit mask from OSD_MEDIA_CONTAINER_BODY_TYPES enum
   int nIndicatorsNum;
   QString stMessage;
};

typedef enum
{
   CLOCK_USER_MODE,
   CLOCK_GPS_MODE,
   CLOCK_GPS_MODE_UNAVAILABLE
} CLOCK_MODE_T;

typedef enum
{
   HOUR_12 = 1,
   HOUR_24
} TIME_FORMAT_T;

struct STATUS_CONTROL_EVENT
{
   int EVTid;
   int nParam;
   QByteArray arrayParam;
};

typedef enum
{
   EVT_ID_SET_OSD_MEDIA_INFO = 0,
   EVT_ID_CHANGE_PLAYTIME_IN_OSD,
   EVT_ID_GET_INDI_STATE,
   EVT_ID_SET_INDI_STATE,
   EVT_ID_SET_TIME_FORMAT,
   EVT_ID_SET_DATE_FORMAT,
   EVT_ID_INDI_STATE,
   EVT_ID_DT_SYNC,
   EVT_ID_DT_AND_FORMAT_SYNC,
   EVT_ID_UPDATE_ALL_INDI,
   EVT_ID_TIME_FORMAT_CHANGED,
   EVT_ID_GET_EXT_CLOCK_TIME,
   EVT_ID_SET_EXT_CLOCK_TIME,
   EVT_ID_SET_SETTINGS_MODE,
   EVT_ID_CHANGE_TO_GPS_MODE,
   EVT_ID_CHANGE_TIME_FORMAT,
   EVT_ID_GET_GPS_TIME,
   EVT_ID_EXT_CLOCK_TIME,
   EVT_ID_SET_OSD_CLIMATE_INFO,
   EVT_ID_CLEAR_OSD_INFO
} STATUS_CONTROL_EVT_ID;

#endif // STAUSBARCONTROL_GLOBAL_H
