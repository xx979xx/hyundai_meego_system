#ifndef DHAVN_APPSETTINGS_SHARED_H
#define DHAVN_APPSETTINGS_SHARED_H

#include <QObject>

#define MAX_STRING_LENGHT 256
#define MAX_ITEM_COUNT 100

class AppSettingsDef : public QObject
{
   Q_OBJECT

   Q_ENUMS( SCREEN_SAVER_MODE )
   Q_ENUMS( CLOCK_TYPE )
   Q_ENUMS( TIME_TYPE )
   Q_ENUMS( APPLICATION_START )
   Q_ENUMS( SETTINGS_PHONE_PRIORITY )
   Q_ENUMS( SETTINGS_DATEFORMAT )

public:
   enum SCREEN_SAVER_MODE
   {
      SCREEN_SAVER_MODE_OFF,
      SCREEN_SAVER_MODE_CLOCK,
      SCREEN_SAVER_MODE_IMAGE
   };

   enum CLOCK_TYPE
   {
      CLOCK_TYPE_ANALOG,
      CLOCK_TYPE_DIGITAL
   };

   enum TIME_TYPE
   {
      TIME_TYPE_12H,
      TIME_TYPE_24H
   };

   enum APPLICATION_START
   {
      APPLICATION_START_TOUCH,
      APPLICATION_START_DIAL,
      APPLICATION_START_BLUETOOTH,
      APPLICATION_START_VOICE_RECOGNITION,
      APPLICATION_START_NAVI
   };

   enum SETTINGS_PHONE_PRIORITY
   {
      SETTINGS_PHONE_PRIORITY_BLUETOOTH = 0,
      SETTINGS_PHONE_PRIORITY_BLUELINK
   };

   enum SETTINGS_DATEFORMAT
   {
      SETTINGS_DATEFORMAT_YYYYMMDD_DASH = 1,    //YYYY-MM-DD
      SETTINGS_DATEFORMAT_MMDDYYYY_DASH,        //MM-DD-YYYY
      SETTINGS_DATEFORMAT_DDMMYYYY_DASH,        //DD-MM-YYYY
      SETTINGS_DATEFORMAT_YYYYMMDD_SLASH,       //YYYY/MM/DD
      SETTINGS_DATEFORMAT_MMDDYYYY_SLASH,       //MM/DD/YYYY
      SETTINGS_DATEFORMAT_DDMMYYYY_SLASH,       //DD/MM/YYYY
      SETTINGS_DATEFORMAT_YYYYMMDD_DOT,         //YYYY.MM.DD
      SETTINGS_DATEFORMAT_MMDDYYYY_DOT,         //MM.DD.YYYY
      SETTINGS_DATEFORMAT_DDMMYYYY_DOT          //DD.MM.YYYY
   };

   enum EAppSettingsStartState
   {
      eStart_InvalidState = -1,
      eStart_Mode_Main = 0,
      eStart_Mode_Sound,
      eStart_Mode_Sound_Balance,
      eStrat_Mode_Sound_Tones,
      eStart_Mode_Sound_Volume_Ratio_Control,
      eStart_Mode_Sound_Variable_EQ,
      eStart_Mode_Sound_Active_Sound_Design,
      eStart_Mode_Sound_Beep,
      eStart_Mode_Sound_Speed_Dependent_VC,
      eStart_Mode_Sound_Virtual_Sound,
      eStart_Mode_Screen,
      eStart_Mode_VR,
      eStart_Mode_VR_Voice_Reconition,
      eStrat_Mode_VR_Instruction,
      eStart_Mode_General,
      eStart_Mode_General_Photo_Frame,
      eStart_Mode_General_Clock,
      eStart_Mode_General_Language,
      eStart_Mode_General_Temperature,
      eStart_Mode_General_Approval,
      eStart_Mode_System,
      sStart_Mode_System_System_Info,
      eStart_Mode_System_Update,
      eStart_Mode_System_Lock_Rear_Monitor,
      eStart_Mode_Syste_JukeBox_Infom,
      eStart_Mode_General_Language_only,
      eStart_Mode_General_Keyboard,
      eStart_Mode_Egineering_Sound,
      eStart_Mode_General_Initialization,
      eStart_Mode_General_Video_Control,
      eStart_Mode_MaxIndex
   };

   enum DB_SETTINGS_KEY_T
   {
      DB_KEY_PHOTO_FRAME = 0,                             /**for general*/
      DB_KEY_PHOTO_FRAME_IMAGE,
      DB_KEY_SUMMER_TIME,
      DB_KEY_GPS_TIME_SETTINGS ,
      DB_KEY_DISPLAY_CLOCK_AT_AUDIO_END,
      DB_KEY_DISPLAY_CLOCK,
      DB_KEY_CLOCK_TYPE,
      DB_KEY_TIME_TYPE,
      DB_KEY_CALENDAR_TYPE,
      DB_KEY_LANGUAGE_TYPE,
      DB_KEY_TEMPERATURE_TYPE,
      DB_KEY_APPROVAL,
      DB_KEY_LOCKREARMONITOR_DISPLAY,                     /**for system*/
      DB_KEY_LOCKREARMONITOR_FUNCTION,
      DB_KEY_VIDEO_BRIGHTNESS,                            /**for screen*/
      DB_KEY_VIDEO_SATURATION,
      DB_KEY_VIDEO_HUE,
      DB_KEY_VIDEO_CONTRAST,
      DB_KEY_IMAGE_BRIGHTNESS,
      DB_KEY_EXPOSURE,
      DB_KEY_ASPECT_RADIO,
      DB_KEY_DVD_SUBTITLE_LANGUAGE,                       /**for DVD*/
      DB_KEY_DVD_AUDIO_LANGUAGE,
      DB_KEY_DVD_ANGLE,
      DB_KEY_SOUND_BALANCE,                               /**for Sound*/
      DB_KEY_SOUND_FADER,
      DB_KEY_SOUND_LOWTONE,
      DB_KEY_SOUND_MIDTONE,
      DB_KEY_SOUND_HIGHTONE,
      DB_KEY_SOUND_VOLUME_RATIO,
      DB_KEY_SOUND_POWERBASS,
      DB_KEY_SOUND_POWERTREBLE,
      DB_KEY_SOUND_SURROUND, 
      DB_KEY_SOUND_ACTIVE,
      DB_KEY_SOUND_SPEED,
      DB_KEY_SOUND_BEEP,
      DB_KEY_SOUND_VEQ,
      DB_KEY_VOICE_VOICECOMMAND,
      DB_KEY_KEYPAD,
      DB_KEY_WINDOWS_INTERLOCKING,
      DB_KEY_DISTANCE_UNIT,
      DB_KEY_APPROACH_SENSOR,
      DB_KEY_QUANTUMLOGIC,
      DB_KEY_DATEFORMAT_TYPE,
      DB_KEY_DIVX_REG_STATE,
      DB_KEY_VIDEO_SCREENSETTINGS,
      DB_KEY_FRONT_SCREENBRIGHTNESS,
      DB_KEY_REAR_SCREENBRIGHTNESS,
      DB_KEY_FIRST_CAPITAL,
      DB_KEY_ENGLISH_KEYPAD,
      DB_KEY_KOREAN_KEYPAD,
      DB_KEY_ARABIC_KEYPAD,
      DB_KEY_CHINA_KEYPAD,
      DB_KEY_EUROPE_KEYPAD,
      DB_KEY_RUSSIAN_KEYPAD,
      DB_KEY_CURRENT_REGION,
      DB_KEY_AUX_VIDEOIN,
      DB_KEY_BT_VOLUME_LEVEL,
      DB_KEY_BT_RINGTONE,
      DB_KEY_BL_VOLUME_LEVEL,
      DB_KEY_BL_RINGTONE,
      DB_KEY_AUTO_TIMEZONE,
      DB_KEY_AUTO_TIMEZONE_SET,
      DB_KEY_SUMMER_TIME_SET,
      DB_KEY_VR_VOLUME_LEVEL,
      DB_KEY_VR_PHONE_PRIORITY,
      DB_KEY_REAR_ON,
      DB_KEY_HYUNDAY_KEYPAD,
      DB_KEY_SCROLL_TICKER,
      DB_KEY_LREAR,
      DB_KEY_RREAR,
      DB_KEY_MAX
   };
};

namespace AppSettingsShared {

struct DB_SETTINGS_KEYS_T
{
    AppSettingsDef::DB_SETTINGS_KEY_T keyId;
    const char *keyString;
};

// Table of settings variables
static const DB_SETTINGS_KEYS_T SETTINGS_DB_VARIABLES_KEYS[] =
{
    { AppSettingsDef::DB_KEY_PHOTO_FRAME,                  "mPhotoFrameKey"             },
    { AppSettingsDef::DB_KEY_PHOTO_FRAME_IMAGE,            "mPhotoFrameImageKey"        },
    { AppSettingsDef::DB_KEY_SUMMER_TIME,                  "mSummerTimeKey"             },
    { AppSettingsDef::DB_KEY_GPS_TIME_SETTINGS,            "mGPSTimeSettingKey"         },
    { AppSettingsDef::DB_KEY_DISPLAY_CLOCK_AT_AUDIO_END,   "mDisplayClockAtAudioEndKey" },
    { AppSettingsDef::DB_KEY_DISPLAY_CLOCK,                "mDisplayClockKey"           },
    { AppSettingsDef::DB_KEY_CLOCK_TYPE,                   "mClockTypeKey"              },
    { AppSettingsDef::DB_KEY_TIME_TYPE,                    "mTimeTypeKey"               },
    { AppSettingsDef::DB_KEY_CALENDAR_TYPE,                "mCalendarTypeKey"           },
    { AppSettingsDef::DB_KEY_LANGUAGE_TYPE,                "mLanguageKey"               },
    { AppSettingsDef::DB_KEY_TEMPERATURE_TYPE,             "mTemperatureKey"            },
    { AppSettingsDef::DB_KEY_APPROVAL,                     "mApprovalKey"               },
    { AppSettingsDef::DB_KEY_LOCKREARMONITOR_DISPLAY,      "mDisplay"                   },
    { AppSettingsDef::DB_KEY_LOCKREARMONITOR_FUNCTION,     "mFunction"                  },
    { AppSettingsDef::DB_KEY_VIDEO_BRIGHTNESS,             "mVideoBrightness"           },
    { AppSettingsDef::DB_KEY_VIDEO_SATURATION,             "mVideoSaturation"           },
    { AppSettingsDef::DB_KEY_VIDEO_HUE,                    "mVideoHue"                  },
    { AppSettingsDef::DB_KEY_VIDEO_CONTRAST,               "mVideoContrast"             },
    { AppSettingsDef::DB_KEY_IMAGE_BRIGHTNESS,             "mImegeBrightness"           },
    { AppSettingsDef::DB_KEY_EXPOSURE,                     "mExposure"                  },
    { AppSettingsDef::DB_KEY_ASPECT_RADIO,                 "mAspectRadio"               },
    { AppSettingsDef::DB_KEY_DVD_SUBTITLE_LANGUAGE,        "mDvdSubtitleLanguage"       },
    { AppSettingsDef::DB_KEY_DVD_AUDIO_LANGUAGE,           "mDvdAudioLanguage"          },
    { AppSettingsDef::DB_KEY_DVD_ANGLE,                    "mDvdAngle"                  },
    { AppSettingsDef::DB_KEY_SOUND_BALANCE,                "mSoundBalance"              },
    { AppSettingsDef::DB_KEY_SOUND_FADER,                  "mSoundFader"                },
    { AppSettingsDef::DB_KEY_SOUND_LOWTONE,                "mSoundLowTone"              },
    { AppSettingsDef::DB_KEY_SOUND_MIDTONE,                "mSoundMidTone"              },
    { AppSettingsDef::DB_KEY_SOUND_HIGHTONE,               "mSoundHighTone"             },
    { AppSettingsDef::DB_KEY_SOUND_VOLUME_RATIO,           "mSoundVolumeRatio"          },
    { AppSettingsDef::DB_KEY_SOUND_POWERBASS,              "mSoundPowerBass"            },
    { AppSettingsDef::DB_KEY_SOUND_POWERTREBLE,            "mSoundPowerTreble"          },
    { AppSettingsDef::DB_KEY_SOUND_SURROUND,               "mSoundSurround"             },
    { AppSettingsDef::DB_KEY_SOUND_ACTIVE,                 "mSoundActive"               },
    { AppSettingsDef::DB_KEY_SOUND_SPEED,                  "mSoundSpeed"                },
    { AppSettingsDef::DB_KEY_SOUND_BEEP,                   "mSoundBeep"                 },
    { AppSettingsDef::DB_KEY_SOUND_VEQ,                    "mVEQ"                       },
    { AppSettingsDef::DB_KEY_VOICE_VOICECOMMAND,           "mVoiceCommand"              },
    { AppSettingsDef::DB_KEY_KEYPAD,                       "mKeyPad"                    },
    { AppSettingsDef::DB_KEY_WINDOWS_INTERLOCKING,         "mWindowsInterlocking"       },
    { AppSettingsDef::DB_KEY_DISTANCE_UNIT,                "mDistanceUnit"              },
    { AppSettingsDef::DB_KEY_APPROACH_SENSOR,              "mApproachSensor"            },
    { AppSettingsDef::DB_KEY_QUANTUMLOGIC,                 "mApproachSensor"            },
    { AppSettingsDef::DB_KEY_DATEFORMAT_TYPE,              "mDateFormat"                },
    { AppSettingsDef::DB_KEY_DIVX_REG_STATE,               "mDivxRegState"              },
    { AppSettingsDef::DB_KEY_VIDEO_SCREENSETTINGS,         "mScreenSettings"            },
    { AppSettingsDef::DB_KEY_FRONT_SCREENBRIGHTNESS,       "mFrontScreenSettings"       },
    { AppSettingsDef::DB_KEY_REAR_SCREENBRIGHTNESS,        "mRearScreenSettings"        },
    { AppSettingsDef::DB_KEY_FIRST_CAPITAL,                "mFirstCapital"              },
    { AppSettingsDef::DB_KEY_ENGLISH_KEYPAD,               "mEnglishKeypad"             },
    { AppSettingsDef::DB_KEY_KOREAN_KEYPAD,                "mKoreanKeypad"              },
    { AppSettingsDef::DB_KEY_ARABIC_KEYPAD,                "mArabicKeypad"              },
    { AppSettingsDef::DB_KEY_CHINA_KEYPAD,                 "mChinaKeypad"               },
    { AppSettingsDef::DB_KEY_EUROPE_KEYPAD,                "mEuropeKeypad"              },
    { AppSettingsDef::DB_KEY_RUSSIAN_KEYPAD,               "mRussianKeypad"             },
    { AppSettingsDef::DB_KEY_CURRENT_REGION,               "mCurrentRegion"             },
    { AppSettingsDef::DB_KEY_AUX_VIDEOIN,                  "mAuxVideoIn"                },
    { AppSettingsDef::DB_KEY_BT_VOLUME_LEVEL,              "mBtVolume"                  },
    { AppSettingsDef::DB_KEY_BT_RINGTONE,                  "mBtRingtone"                },
    { AppSettingsDef::DB_KEY_BL_VOLUME_LEVEL,              "mBlVolume"                  },
    { AppSettingsDef::DB_KEY_BL_RINGTONE,                  "mBlRingtone"                },
    { AppSettingsDef::DB_KEY_AUTO_TIMEZONE,                "mAutoTimeZone"              },
    { AppSettingsDef::DB_KEY_AUTO_TIMEZONE_SET,            "mAutoTimeZoneSet"           },
    { AppSettingsDef::DB_KEY_SUMMER_TIME_SET,              "mSummerTimeSet"             },
    { AppSettingsDef::DB_KEY_VR_VOLUME_LEVEL,              "mVrVolume"                  },
    { AppSettingsDef::DB_KEY_VR_PHONE_PRIORITY,            "mVrPhonePriority"           },
    { AppSettingsDef::DB_KEY_REAR_ON,                      "mRearScreenOn"              },
    { AppSettingsDef::DB_KEY_HYUNDAY_KEYPAD,               "mHyndaiDefaultKeypad"       },
    { AppSettingsDef::DB_KEY_SCROLL_TICKER,                "mGeneralScrollingTicker"    },
    { AppSettingsDef::DB_KEY_LREAR,                        "mLeftRear"                  },
    { AppSettingsDef::DB_KEY_RREAR,                        "mRightRear"                 }
};
}

enum ASPECT_RATIO_T {
     ASPECT_RATIO_FULL,
     ASPECT_RATIO_16_9,
     ASPECT_RATIO_4_3
    };



struct VideoWidgetProps
{
    ASPECT_RATIO_T  aspectRatio;
    bool            isFrontDisplay;
    int             displayX;
    int             displayY;
    int             displayWidth;
    int             displayHeight;
};

struct AppSettingsStartParameter
{
    AppSettingsDef::EAppSettingsStartState startState;
    bool transparentBG;
    bool divxDvdTabDimmed;
};

enum registrationState
{
   SETTINGS_DRM_GENERAL_ERROR = 0,
   SETTINGS_DRM_SUCCESS,
   SETTINGS_DRM_NEVER_REGISTERED,
   SETTINGS_DRM_NOT_REGISTERED
};

struct DivxRegInfo
{
    registrationState isActivated;
    char deregCode[8];
    char regCode[10];
};

enum VC_DATA
{
    VC_DATA_CAPTIONS,
    VC_DATA_VOICELANG,
    VC_DATA_MENULANG,
    VC_DATA_ANGLES
};

struct VCInfo
{
    int activeCaptionLangCode;
    int activeAudioLangCode;
    int activeMenuLangCode;
};

struct VCItem
{
    VC_DATA infoType;
    int code;
};

#endif //DHAVN_APPSETTINGS_SHARED_H
