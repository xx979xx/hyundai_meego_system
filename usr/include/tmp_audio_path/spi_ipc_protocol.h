#ifndef __SPI_IPC_PROTOCOL_H__
#define __SPI_IPC_PROTOCOL_H__

#ifdef __cpluscplus
extern "c" {
#endif

/* Data Format 
	   0   1   2   3   D1  D2  D3             Dn       (bytes )
	 +---+---+---+---+---+---+---+---+---+---+---+---+
	 |  (1)  |  (2)  |(3)|   |   |  .......  |   |(4)| 
   +---+---+---+---+---+---+---+---+---+---+---+---+
	 (1) Command 
	 (2) Data Size : D1 ~ Dn ( MAX 1024byte for HD-Audio )
	 (3) Data 
	 (4) Checksum : (1)^(2)^(3)
*/
// packet field length : byte(s)
#define DUMMY_HEADER_LENGTH							(1)
#define CMD_FIELD_LENGTH								(2)
#define SIZE_FIELD_LENGTH								(2)
#ifdef __NO_CHECKSUM__
#define CHKSUM_FIELD_LENGTH							(0)
#else
#define CHKSUM_FIELD_LENGTH							(1)
#endif


/* Command structure (1)
	 Bit        15    14    13    12    11    10     9     8   
						+-----+-----+-----+-----+-----+-----+-----+-----+
	 0th Byte | (1) |    (2)    |             (3)             |
	          +-----+-----+-----+-----+-----+-----+-----+-----+
	 Bit         7     6     5     4     3     2     1     0
	 				  +-----+-----+-----+-----+-----+-----+-----+-----+
	 1st Byte |                      (4)                      |
	          +-----+-----+-----+-----+-----+-----+-----+-----+
	 (1) Request / Response 
	 (2) Reserved 
	 (3) Main group
	 (4) Sub group
*/

// Dummy Header 
#define DUMMY_HEADER										(0xAA)

// Request/Response field
#define REQUEST_MESSAGE									(0)
#define RESPONSE_MESSAGE								(1)

// Main Group field
#define CONTROL_MESSAGE									(0x01)
#define ASK_MESSAGE 										(0x02)
#define EVENT_MESSAGE										(0x03)
#define CAN_MESSAGE											(0x04)
#define MOST_MESSAGE										(0x05)
#define ENGINEERING_MESSAGE							(0x06)

/* Sub Group field 
		System group	: 0x00 ~ 0x0F
		Audio group 	: 0x10 ~ 0x1F
		Radio group 	: 0x20 ~ 0x2F
		RDS group 		: 0x30 ~ 0x3F
		TMC group 		: 0x40 ~ 0x4F
		HD Radio group: 0x50 ~ 0x5F
		HW Ctrl group	: 0x60 ~ 0x6F
		TBD   				: 0x70 ~ 0x7F
		TBD   				: 0x80 ~ 0x8F
		Etc group			: 0x90 ~ 0x9F
*/
// Audio group
#define AUDIO_CTRL_MAIN_CH_CHANGE							(0x10)
#define AUDIO_CTRL_SUB_CH_CHANGE							(0x11)
#define AUDIO_CTRL_MIXING_CH_CHANGE						(0x12)
#define AUDIO_CTRL_VOLUME_CONTROL							(0x13)
#define AUDIO_CTRL_SETUP_CONTROL							(0x14)
#define AUDIO_CTRL_BEEP_CONTROL								(0x15)
#define AUDIO_CTRL_MUTE_CONTROL								(0x16)

#define AUDIO_ASK_SOUND_SETUP_INFO						(0x10)
#define AUDIO_ASK_VOLUME_INFO									(0x11)
#define AUDIO_ASK_LAST_MEMORY									(0x12)

#define AUDIO_EVENT_VOLUME_STEP								(0x10)

// RADIO group
#define RADIO_ASK_PRESET											(0x20)
#define RADIO_ASK_BROADCASTING_INFO						(0x21)
#define RADIO_ASK_RADIO_EACH_PRESET_INFO			(0x22)

#define RADIO_EVENT_BSM_PRESET_UPDATE					(0x20)
#define RADIO_EVENT_SEARCH_FINISH							(0x21)
#define RADIO_EVENT_TUNER_STEREO_STATUS				(0x22)

// RDS group
#define RDS_CTRL_OPTIONS_SETS									(0x30)
#define RDS_CTRL_INFO_CANCEL									(0x31)
#define RDS_CTRL_CHECK_ENABLE									(0x32)

#define RDS_EVENT_INFO_START									(0x30)
#define RDS_EVENT_INFO_FINISH									(0x31)
#define RDS_EVENT_PTY_STATION_EXIT						(0x32)
#define RDS_EVENT_EXPANDED_DATA_UPDATE				(0x33)
#define RDS_EVENT_TEXT_UPDATE									(0x34)
#define RDS_EVENT_TP_LOSS											(0x35)

// TMC group
#define TMC_CTRL_DECODING_ENABLE							(0x40)
#define TMC_CTRL_MANUAL_FREQ_CHANGE						(0x41)
#define TMC_CTRL_PLAY_SET											(0x42)
#define TMC_CTRL_OTHER_COUNTRY_SET						(0x43)
#define TMC_CTRL_INVALID_STATION							(0x44)

#define TMC_EVENT_INFO_UPDATE									(0x40)
#define TMC_EVENT_INFO_DECODE_COMPLETE				(0x41)

// HD Radio group
#define HDR_CTRL_TUNE													(0x50)
#define HDR_CTRL_CA_SEND_EMM									(0x51)
#define HDR_CTRL_CA_DATA											(0x52)

#define HDR_EVENT_PSD_DATA										(0x50)
#define HDR_EVENT_SIS_DATA										(0x51)
#define HDR_EVENT_SPS_STATUS									(0x52)
#define HDR_EVENT_STATUS_INFO									(0x53)
#define HDR_EVENT_CA_INFO											(0x54)
#define HDR_EVENT_CA_CALL_MESSAGE							(0x55)

// HW Ctrl group
#define HWCTRL_CTRL_POWERKEY									(0x60)
#define HWCTRL_CTRL_LCD_BACKLIGHT							(0x61)
#define HWCTRL_CTRL_LCD_PWM										(0x62)
#define HWCTRL_CTRL_FAN												(0x63)
#define HWCTRL_CTRL_PERIPHERAL_RESET					(0x64)
#define HWCTRL_CTRL_MIC												(0x65)
#define HWCTRL_CTRL_RTC_SET										(0x66)
#define HWCTRL_CTRL_CAMERA_POWER							(0x67)

// TBD ( 0x70 ~ 0x7F )
#define KEY_EVENT_FRONT_PANNEL								(0x70)
#define KEY_EVENT_CCP													(0x71)
#define KEY_EVENT_RRP													(0x72)
#define KEY_EVENT_SWC													(0x73)
#define KEY_EVENT_TOUCH												(0x74)

// Etc group
#define ETC_CTRL_GUI_MODE											(0x90)
#define ETC_CTRL_APP_BOOT_COMPLETE						(0x91)
#define ETC_CTRL_FACTORY_SETTING							(0x92)
#define ETC_CTRL_OPTION_SET										(0x93)
#define ETC_CTRL_SLEEP_CONFIRM								(0x94)
#define ETC_CTRL_EEPROM_WRITE									(0x95)

#define ETC_ASK_LCD_SET_INFO									(0x90)
#define ETC_ASK_RTC_INFO											(0x91)

#define ETC_EVENT_ACC_SIGNAL_STATUS						(0x90)
#define ETC_EVENT_CAR_INTERFACE_STATUS				(0x91)
#define ETC_EVENT_DAY_AND_NIGHT_STATUS				(0x92)
#define ETC_EVENT_POPUP												(0x93)
#define ETC_EVENT_SPEED_VALUE									(0x94)
#define ETC_EVENT_SLEEP_REQUEST								(0x95)
#define ETC_EVENT_MOTION_SENSOR								(0x96)


/*
// Audio Mode Change Data Format
#define AMCHG_0TH_AV_OFF											(0x00)
#define AMCHG_0TH_FM1													(0x01)
#define AMCHG_0TH_FM2													(0x02)
#define AMCHG_0TH_AM													(0x03)
#define AMCHG_0TH_DVD_DECK										(0x04)
#define AMCHG_0TH_CD_DECK											(0x05)
#define AMCHG_0TH_USB1												(0x06)
#define AMCHG_0TH_USB2												(0x07)
#define AMCHG_0TH_IPOD1												(0x08)
#define AMCHG_0TH_IPOD2												(0x09)
#define AMCHG_0TH_VCDC												(0x0A)
#define AMCHG_0TH_JUKEBOX											(0x0B)
#define AMCHG_0TH_BT_AUDIO										(0x0C)
#define AMCHG_0TH_BT_PANDORA									(0x0D)
#define AMCHG_0TH_DMB1												(0x0E)
#define AMCHG_0TH_DMB2												(0x0F)
#define AMCHG_0TH_CMMB1												(0x10)
#define AMCHG_0TH_CMMB2												(0x11)
#define AMCHG_0TH_XM1													(0x12)
#define AMCHG_0TH_XM2													(0x13)
#define AMCHG_0TH_DAB1												(0x14)
#define AMCHG_0TH_DAB2												(0x15)
#define AMCHG_0TH_AUX1												(0x16)
#define AMCHG_0TH_AUX2												(0x17)
#define AMCHG_0TH_IBOX_AUDIO									(0x18)
#define AMCHG_0TH_HD_RADIO										(0x19)
#define AMCHG_0TH_TTS													(0x1A)

// Audio Mixing Channel control Data Format 
#define AMCON_0TH_NAVIGATION									(0x00)
#define AMCON_0TH_VR													(0x01)
#define AMCON_0TH_BT_PHONE										(0x02)
#define AMCON_0TH_BT_BELL											(0x03)
#define AMCON_0TH_IBOX_PHONE_FRONT						(0x04)
#define AMCON_0TH_IBOX_PHONE_REAR							(0x05)
#define AMCON_0TH_IBOX_BELL										(0x06)
#define AMCON_1ST_CHANNEL_OFF									(0x00)
#define AMCON_1ST_CHANNEL_ON									(0x01)

// Audio Volume Control Data Format ( 1st byte is a gain value )
#define AVOLCON_0TH_MAIN											(0x00)
#define AVOLCON_0TH_AUX												(0x01)
#define AVOLCON_0TH_NAVI											(0x02)
#define AVOLCON_0TH_VR												(0x03)
#define AVOLCON_0TH_BT_PHONE									(0x04)
#define AVOLCON_0TH_RDS_TA										(0x05)
#define AVOLCON_0TH_RDS_NEWS									(0x06)
#define AVOLCON_0TH_RDS_ALARM									(0x07)
#define AVOLCON_0TH_TTS												(0x08)
#define AVOLCON_0TH_WELCOMING									(0x09)
#define AVOLCON_0TH_TMU_CALL									(0x0A)
#define AVOLCON_0TH_TMU_TBT										(0x0B)
#define AVOLCON_0TH_IBOX_PHONE								(0x0C)
#define AVOLCON_0TH_IBOX_BELL									(0x0D)

// Audio Setup Control Data Format 
#define ASCON_0TH_BASS												(0x00)
#define ASCON_0TH_MID													(0x01)
#define ASCON_0TH_TREBLE											(0x02)
#define ASCON_0TH_BALANCE											(0x03)
#define ASCON_0TH_FADER												(0x04)
#define ASCON_0TH_VARIABLE_EQ									(0x05)
#define ASCON_0TH_SDVC_AVC										(0x06)
#define ASCON_0TH_SURROUND										(0x07)
#define ASCON_0TH_BEEP												(0x08)
#define ASCON_0TH_ADJUST_VOLUME_RATIO					(0x09)
#define ASCON_0TH_BASS_MID_TREBLE_CENTER			(0x0A)
#define ASCON_0TH_BALANCE_FADER_CENTER				(0x0B)
#define ASCON_0TH_WELCOMING										(0x0C)
#define ASCON_0TH_ALL_INITIALIZE							(0x0F)
*/

// command field structure 
typedef struct st_cmd_header
{
	unsigned char nMainGroup:5;
	unsigned char nResrv:2;
	unsigned char nFlag:1;
	unsigned char nSubGroup:8;
} CMD_HEADER, *pCMD_HEADER;


int parse_spi_protocol( unsigned char * );
void gen_spi_protocol( pCMD_HEADER, unsigned char *, int, unsigned char * );

#ifdef __cpluspluc
extern "c" }
#endif

#endif /* __SPI_IPC_PROTOCOL_H__ */
