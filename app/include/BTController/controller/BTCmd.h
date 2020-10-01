#ifndef __BT_CMD_H__
#define __BT_CMD_H__

/*This is the list of all the AT commands sent by the BT Controller. */
typedef enum {
	BT_CMD_ECA,				// 0		/*Error Code Activate*/
	BT_CMD_BTSYS,			// 1		/*Enable/disable the Bluetooth function of BTM */
	BT_CMD_FRST,			// 2		/*Bluetooth Factory Reset */
	BT_CMD_SRST,			// 3		/*Soft Reset*/ 
	BT_CMD_SBR,				// 4		/*Set/Get UART baud rate*/
	BT_CMD_GBTMIF,			// 5		/*Get Bluetooth Module Information*/
	BT_CMD_CLDN,			// 6		/*Set/Get current local device name*/
	BT_CMD_BDADDR,			// 7		/*Set/Get current BD ADDRESS*/
	BT_CMD_RSSI,			// 8		/*Read the current RSSI value for a connection*/
	BT_CMD_BTSTATE,			// 9		/*Read the current status of each profile of the BTM*/
	BT_CMD_BTCFG,			// 10	/*Get Blluetooth Module Configuration*/
	BT_CMD_CMODE,			// 11	/*Set/Get connectable mode*/
	BT_CMD_DMODE,			// 12	/*Set/Get discoverable mode*/
	BT_CMD_BDI,				// 13	/*Start device inquiry*/
	BT_CMD_PAIRM,			// 14	/*Set/Get Pairing mode*/
	BT_CMD_PAIRQ,			// 15	/*Legacy Pairing request */
	BT_CMD_PAIRP,			// 16	/*Accept/Reject Incoming Pairing request */
	BT_CMD_SSPM,			// 17	/*Set/Get SSP mode*/
	BT_CMD_SSPP,			// 18	/*SSP request*/
	BT_CMD_LPBD,			// 19	/*Get paired devices list info*/
	BT_CMD_DPA,				// 20	/*Delete paired device*/
	BT_CMD_SDP,				// 21	/*Service Discovery Process Request*/
	BT_CMD_BSCQ,			// 22	/*Service connection/disconnection Request*/
	BT_CMD_BACM,			// 23	/*Bluetooth Auto-connection mode request*/
	BT_CMD_BACQ,			// 24	/*B;uetooth Auto-connection stran/stop reuquest*/
	BT_CMD_HFP_BRSF,		// 25	/*Get the HFP features supported by the peer */
	BT_CMD_HFP_ATD,			// 26	/*Dial Number*/
	BT_CMD_HFP_ATDM,		// 27	/*Memory/Speed Dial*/
	BT_CMD_HFP_BLDN,		// 28	/*Redial last dialled number*/
	BT_CMD_HFP_ATA,			// 29	/*Answer Call*/
	BT_CMD_HFP_CHUP,		// 30	/*Hangup Call*/
	BT_CMD_HFP_ECC,			// 31	/*Enhanced three way call control*/
	BT_CMD_HFP_CLCC,		// 32	/*Get current call info*/
	BT_CMD_HFP_CIND,		// 33	/*Configure call indicator control settings*/
	BT_CMD_HFP_CCWA,		// 34	/*Set/Get call waiting mode*/
	BT_CMD_HFP_CLIP,		// 35	/*Calling Line Identification settings*/
	BT_CMD_HFP_COPS,		// 36	/*Get current network operator details*/
	BT_CMD_HFP_CAUD,		// 37	/*Set/Get HFP Audio privacy mode*/
	BT_CMD_HFP_VTS,			// 38	/*Send DTMF Tones*/
	BT_CMD_HFP_MGC,			// 39	/*Set/Get Volume Gain Control*/
	BT_CMD_HFP_ECNRBTM,		// 40	/*Set/Get BTM EC/NR Control*/
	BT_CMD_HFP_ECNRAG,		// 41	/*Set/Get Audio Gateway EC/NR Control*/
	BT_CMD_HFP_CGMI,		// 42	/*Manuficturer identification request*/
	BT_CMD_HFP_CGMM,		// 43	/*Model identification request*/
	BT_CMD_HFP_CGMR,		// 44	/*Version identification request*/
	BT_CMD_PBAP_PBS,		// 45	/*Get Phone Book Size*/
	BT_CMD_PBAP_PBD,		// 46	/*Phone Book download*/
	BT_CMD_PBAP_PBA,		// 47	/*Phone Book download with AT command*/
	BT_CMD_PBAP_PBI,		// 48	/*Phone Book image download*/
	BT_CMD_PBAP_PBDA,		// 49	/*Phone Book download abort request*/
	BT_CMD_PBAP_PBDS,		// 50	/*Phone Book download status request*/
	BT_CMD_AV_AVOP,			// 51	/*AVRCP operation request*/
	BT_CMD_AV_AVPI,			// 52	/*Get current  play information*/
	BT_CMD_AV_AVPS,			// 53	/*AVRCP player setting*/
	BT_CMD_MAP_MANR,		// 54	/*Register Message Service Notification */
	BT_CMD_MAP_MAGM,		// 55	/*Get Message*/
	BT_CMD_MAP_MASST,		// 56	/*Set Message Status*/
	BT_CMD_MAP_MAA,			// 57	/*Message Abort*/
	BT_CMD_MAP_MAIU,		// 58	/*Message inbox update*/
	BT_CMD_MAP_MASF,		// 59	/*Message set folder*/
	BT_CMD_MAP_MAGF,		// 60	/*Get Message folder listing*/
	BT_CMD_MAP_MAGML,		// 61	/*Get Message list*/
	BT_CMD_SPP_SPTX,		// 62	/*Transmit data using SPP*/
	BT_CMD_SPP_SPMODE,		// 63	/*Serial Port Extension Mode*/
	BT_CMD_UPGRADE_UPLOAD,	// 64	/*Check Binary Update*/
	BT_CMD_UPGRADE_HSRDY,	// 65	/*Binary Upload Hand-Shake*/
	BT_CMD_UPGRADE_SIZE,	// 66	/*Send Binary File Size*/
	BT_CMD_UPGRADE_BIN,		// 67	/* Binary Data Upload*/
	BT_CMD_ECHO, 			// 68	/* Binary Data Upload*/
	BT_CMD_BSCC,			// 69	/*Reply to Incoming service connection request*/
	BT_CMD_BTM_TEST,		// 70	/* MODE 1 = UART loop-back, MODE 2 = SSP debug, MODE 3 = DUT */
	BT_CMD_APLIPM,			// 71	/* Mode 0 = disconnect, Mode 1 = connect */
	BT_CMD_BVRA_MODE,		// 72	/* Mode 0 = disable(default), Mode 1 = enable */
	BT_CMD_SIRI_EFM,		// 73	/* Mode 0 = disable(default), Mode 1 = enable */
	BT_CMD_HFP_FORD_MODE,	// 74	/* Mode 0 = General Mode(default), Mode 1 = FORD Mode */
	BT_CMD_AV_MUTE_MODE,	// 75	/* Mode 0 = Unmute Mode(default), Mode 1 = Mute Mode */
	BT_CMD_DIAGNOSTIC_FOR_DTC,		// 76
	BT_CMD_DIAGNOSTIC_FOR_RESET,	// 77
    BT_CMD_ALIVE,           // 78
    BT_CMD_GRDN,            // 79
    BT_CMD_HFP_SET_ECNR_VERSION,// 80
    BT_CMD_HFP_GET_ECNR_VERSION,//81
    BT_CMD_HFP_ECNR_PRAM,   //82
    BT_CMD_HFP_ECNR_SIZE,   //83
//#ifdef __PROJECTION__
    //projection
    BT_CMD_SSPOOBP,    //84
    BT_CMD_AAPM,       //85
    BT_CMD_FPM_FORD_MODE,  //86
//#endif
	BT_CMD_MAX_ID
}BT_COMMAND_ID;

#define BT_CMD_ECA_CMD				"AT&ECA"		// =<mode>
#define BT_CMD_BTSYS_CMD			"AT&BTSYS"		// =<on/off>
#define BT_CMD_FRST_CMD				"AT&FRST"		// NULL
#define BT_CMD_SRST_CMD				"AT&SRST"		//NULL
#define BT_CMD_SBR_CMD				"AT&SBR"		// ?	// =<Baudrate>
#define BT_CMD_GBTMIF_CMD			"AT&GBTMIF"		// ?
#define BT_CMD_CLDN_CMD				"AT&CLDN"		// ?	// =<Local_Name>
#define BT_CMD_BDADDR_CMD			"AT&BDADDR"		// ?	// =<BTM_Address>
#define BT_CMD_RSSI_CMD				"AT&RSSI"		// =<id>
#define BT_CMD_BTSTATE_CMD			"AT&BTSTATE"	// ?
#define BT_CMD_BTCFG_CMD			"AT&BTCFG"		// ?
#define BT_CMD_CMODE_CMD			"AT&CMODE"		// =<on/off>
#define BT_CMD_DMODE_CMD			"AT&DMODE"		// =<on/off>,<mode>
#define BT_CMD_BDI_CMD				"AT&BDI"		// =<mode>
#define BT_CMD_PAIRM_CMD			"AT&PAIRM"		// ?	//=<Pairing Mode>
#define BT_CMD_PAIRQ_CMD			"AT&PAIRQ"		// =<id>
#define BT_CMD_PAIRP_CMD			"AT&PAIRP"		// =<id>,<action>[,<PIN code>]
#define BT_CMD_SSPM_CMD				"AT&SSPM"		// ?	//<state>[,<SSPmode>]
#define BT_CMD_SSPP_CMD				"AT&SSPP"		// =<device id>,<SSP Answer>[,< numeric >]
#define BT_CMD_LPBD_CMD				"AT&LPBD"		// ?	// =<id>
#define BT_CMD_DPA_CMD				"AT&DPA"		// =<id>
#define BT_CMD_SDP_CMD				"AT&SDP"		// =<id>[,<service>]
#define BT_CMD_BSCQ_CMD				"AT&BSCQ"		// =<id>,<mode>,<serviceBit>
#define BT_CMD_BSCC_CMD				"AT&BSCC"		// =<id>,0,<serviceBit>[,<auth>]
#define BT_CMD_BACM_CMD				"AT&BACM"		// =<on/off>[,<mode>"
#define BT_CMD_BACQ_CMD				"AT&BACQ"		// =<start/stop>
#define BT_CMD_HFP_BRSF_CMD			"AT&BRSF"		// ?
#define BT_CMD_HFP_ATD_CMD			"ATD"			// <dial number>
#define BT_CMD_HFP_ATDM_CMD			"ATD>"			//<nnn>
#define BT_CMD_HFP_BLDN_CMD			"AT+BLDN"		// NULL
#define BT_CMD_HFP_ATA_CMD			"ATA"			// NULL
#define BT_CMD_HFP_CHUP_CMD			"AT+CHUP"		// NULL
#define BT_CMD_HFP_ECC_CMD			"AT&ECC"		// =<action>[,<call Index>]
#define BT_CMD_HFP_CLCC_CMD			"AT&CLCC"		// ?
#define BT_CMD_HFP_CLCCP_CMD		"AT+CLCC"		// ?
#define BT_CMD_HFP_CIND_CMD			"AT+CIND"		// ?
#define BT_CMD_HFP_CCWA_CMD			"AT+CCWA"		// ?	// =<mode>
#define BT_CMD_HFP_CLIP_CMD			"AT+CLIP"		// ?	// =<mode>
#define BT_CMD_HFP_COPS_CMD			"AT+COPS"		// ?
#define BT_CMD_HFP_CAUD_CMD			"AT&CAUD"		// ?	// =<mode>
#define BT_CMD_HFP_VTS_CMD			"AT+VTS"		// =<DTMF>
#define BT_CMD_HFP_MGC_CMD			"AT&MGC"		// ?	// =<mic gain>
#define BT_CMD_HFP_ECNRBTM_CMD		"AT&ECNRBTM"	// ?	// =<btm on/off>
#define BT_CMD_HFP_ECNRAG_CMD		"AT&ECNRAG"		// ?	// =<ag on/off>
#define BT_CMD_HFP_ECNR_VERSION_CMD "AT&ECNRVER"    // ?    // =<info1>,<info2>,<info3>
#define BT_CMD_HFP_ECNR_PRAM_CMD    "AT&ECNR"       //=<index>,<size>,<param>
#define BT_CMD_HFP_ECNR_SIZE_CMD    "AT&ECNRSIZE"   //=<size>
#define BT_CMD_HFP_CGMI_CMD			"AT+CGMI"		// NULL
#define BT_CMD_HFP_CGMM_CMD			"AT+CGMM"		// NULL
#define BT_CMD_HFP_CGMR_CMD			"AT+CGMR"		// NULL
#define BT_CMD_PBAP_PBS_CMD			"AT&PBS"		//=<id>,<src>,<type>
#define BT_CMD_PBAP_PBD_CMD			"AT&PBD"		// ?	// =<id>,<type>,<src>,<vacrd version>,<sindex>,Meindex>[,<vcard feld type>]
#define BT_CMD_PBAP_PBA_CMD			"AT&PBA"		// =<id>,<type>,<src>,<sindex>,<eindex>
#define BT_CMD_PBAP_PBI_CMD			"AT&PBI"		//=<id>,<type>,<src>,<sindex>,<eindex>
#define BT_CMD_PBAP_PBDA_CMD		"AT&PBDA"		//=<id>
#define BT_CMD_PBAP_PBDS_CMD		"AT&PBDS"		//?
#define BT_CMD_AV_AVOP_CMD			"AT&AVOP"		// =<id>,<OP>
#define BT_CMD_AV_AVPI_CMD			"AT&AVPI"		// =<id>,<info id>
#define BT_CMD_AV_AVPS_CMD			"AT&AVPS"		// ? // =<id>,<repeat>,<shuffle>
#define BT_CMD_MAP_MANR_CMD			"AT&MANR"		// =<id>,<mode>
#define BT_CMD_MAP_MAGM_CMD			"AT&MAGM"		// =<id>,<msg_id>
#define BT_CMD_MAP_MASST_CMD		"AT&MASST"		// =<id>,<msg_id>,<status_ind>
#define BT_CMD_MAP_MAA_CMD			"AT&MAA"		// =<id>
#define BT_CMD_MAP_MAIU_CMD			"AT&MAIU"		// =<id>
#define BT_CMD_MAP_MASF_CMD			"AT&MASF"		// =<id>,<mode>[,"<folder_name>"]
#define BT_CMD_MAP_MAGF_CMD			"AT&MAGF"		// NULL
#define BT_CMD_MAP_MAGML_CMD		"AT&MAGML"		// =<id>,<startIdx>,<size>[,"<f_name>"]
#define BT_CMD_SPP_SPTX_CMD			"AT&SPTX"		// =<size>,"<data>"
#define BT_CMD_SPP_SPMODE_CMD		"AT&SPMODE"		// =<mode>
#define BT_CMD_UPGRADE_UPLOAD_CMD	"AT&UPLOAD"
#define BT_CMD_UPGRADE_HSRDY_CMD	"AT&HSRDY"
#define BT_CMD_UPGRADE_SIZE_CMD		"AT&SIZE"
#define BT_CMD_UPGRADE_BIN_CMD		"AT&BIN"
#define BT_CMD_ECHO_CMD				"AT&ECHO"
#define BT_CMD_BTM_TEST_CMD			"AT&TESTCMD"	// =<mode>[,<on/off>]
#define BT_CMD_APLIPM_CMD			"AT&APLIPM"		// =<port>,<mode>,"<device name>"
#define BT_CMD_BVRA_MODE_CMD		"AT+BVRA"		// =<mode>
#define BT_CMD_SIRI_EFM_CMD			"AT+APLEFM"		// =<mode>
#define BT_CMD_HFP_FORD_MODE_CMD	"AT&HFM"		// =<mode>
#define BT_CMD_AV_MUTE_MODE_CMD		"AT&AVMUTE"		// =<mode>
#define BT_CMD_BTM_DTC_CMD			"AT&DTC"		//
#define BT_CMD_ALIVE_CMD            "AT&ALIVE"      // NULL
#define BT_CMD_GRDN_CMD             "AT&GRDN"       // ?

//#ifdef __PROJECTION__
//Projection
#define BT_CMD_SSPOOBP_CMD          "AT&SSPOOB"     //=<device id>,<BD Address>,<Hash>,<Randomizer>
#define BT_CMD_AAPM_CMD             "AT&AAPM"       //=<Port>,<Mode>,<BD Address>
#define BT_CMD_FPM_FORD_MODE_CMD    "AT&FPM"        //=<mode>
//#endif

#define BT_RS_OK_CMD				"OK"		// NULL
#define BT_RS_ERROR_CMD				"ERROR"		// NULL
#define BT_RS_ECA_CMD				"&ECA"		// :<mode>
#define BT_RS_BTRDY_CMD				"&BTRDY"	// :"<DeviceName>",<BDAddr>
#define BT_RS_BTSYS_CMD				"&BTSYS"	// NULL
#define BT_RS_SBR_CMD				"&SBR"		// :<baudrate>
#define BT_RS_GBTMIF_CMD			"&GBTMIF"	// :GBTMIF:"<»ý»êÀÚ ID>","<Model ID>","<hw_version>","<sw_version>"
#define BT_RS_CLDN_CMD				"&CLDN"		// :"<BTM Name>"
#define BT_RS_BDADDR_CMD			"&BDADDR"	// :<BTM_BD_ADDR>
#define BT_RS_RSSI_CMD				"&RSSI"		// :<device id>,<value>
#define BT_RS_BTSTATE_CMD			"&BTSTATE"	// : <GAP state>,<HF state>,<A2DP state>,<AVRCP state>,<PBAP state>,<MAP state>,<SPP state>[,<Connected Device ID>]
#define BT_RS_BTCFG_CMD				"&BTCFG"	// : <baudrate>,<auto connection mode>
#define BT_RS_CMODE_CMD				"&CMODE"	// :<on/off>
#define BT_RS_DMODE_CMD				"&DMODE"	// :<on/off>
#define BT_RS_BDIA_CMD				"&BDIA"		// :<device id N>,"<BT ADDR N>","<CoD N>"	// :END
#define BT_RS_BDIN_CMD				"&BDIN"		// :<device id N>,"<dev name N>","<BT ADDR N>","<CoD N>"	// :END
#define BT_RS_PAIRM_CMD				"&PAIRM"	// :<Pairing Mode>,["<Pin Code>"]
#define BT_RS_PAIRP_CMD				"&PAIRP"	// :<id>,"<bd_addr>","<device name>"
#define BT_RS_PAIRR_CMD				"&PAIRR"	// :<result>,<id>[,<paired_id>]
#define BT_RS_SSPM_CMD				"&SSPM"		// :<onoff>[,<SSPmode>]
#define BT_RS_SSPP_CMD				"&SSPP"		// :<id>,<SSPAuth>,"<deviceName>"[,"<numeric>"]
#define BT_RS_LPBD_CMD				"&LPBD"		// :<id1>,"<name1>","<bd_addr1>","<CoD1>",<connected1>,<last device>
#define BT_RS_SDP_CMD				"&SDP"		// :<id>,<result>,<service>
#define BT_RS_BSCC_CMD				"&BSCC"		// :<id>,0,<serviceBit>
#define BT_RS_BSCR_CMD				"&BSCR"		// :<id>,<mode>,<result>,<service>[,<service_info>][,"<device name>"]
#define BT_RS_HFP_BRSF_CMD			"&BRSF"		// :<id>,<feature>
#define BT_RS_HFP_CLCC_CMD			"&CLCC"		// :<id>,<dir>,<state>,<mode>,<multi>[,"<number>",<type>]
#define BT_RS_HFP_CLCCM_CMD			"&CLCCM"	// :<mode>[,<duration>]
#define BT_RS_HFP_CIND_CMD			"+CIND"		// :<service>,<call>,<callsetup>,<callheld>,<signal>,<roam>,<battchg>
#define BT_RS_HFP_CIEV_CMD			"+CIEV"		// :<id>,<ind>,<value>
#define BT_RS_HFP_RING_CMD			"+RING"		// NULL
#define BT_RS_HFP_BSIR_CMD			"+BSIR"		// :<bsir>
#define BT_RS_HFP_CCWA_CMD			"+CCWA"		// :<mode>	// :"<number>"
#define BT_RS_HFP_CLIP_CMD			"+CLIP"		// :<mode>	// :"<number",<type>
#define BT_RS_HFP_COPS_CMD			"+COPS"		// :<mode>[,<format>, "<operator>"]
#define BT_RS_HFP_CAUD_CMD			"&CAUD"		// :<mode>
#define BT_RS_HFP_MGC_CMD			"&MGC"		// :<mic gain>
#define BT_RS_HFP_ECNRBTM_CMD		"&ECNRBTM"	// :<btm on/Off> 
#define BT_RS_HFP_ECNRAG_CMD		"&ECNRAG"	// : <ag on/off)
#define BT_RS_HFP_ECNR_VERSION_CMD  "&ECNRVER"  // :<info1>,<info2>,<info3>
#define BT_RS_HFP_ECNR_PRAM_CMD     "&ECNR" //
#define BT_RS_HFP_CMER_CMD			"+CMER"		// :<err>
#define BT_RS_HFP_CGMI_CMD			"+CGMI"		// :<MobileManufactuere>
#define BT_RS_HFP_CGMM_CMD			"+CGMM"		// :<Phone Model>
#define BT_RS_HFP_CGMR_CMD			"+CGMR"		// :<RevisionId>
#define BT_RS_PBAP_PBS_CMD			"&PBS"		// :<id>,<result>,<pbsize>
#define BT_RS_PBAP_PBD_CMD			"&PBD"		// :<id>,<PB support>,< ATPB support >
#define BT_RS_PBAP_PBDI_CMD			"&PBDI"		// :<index>,"<name>","<FName>","<Mobile phone>","<HOME phone>","<WORK phone>","<fax>","<Other phone>","<timestamp>"
#define BT_RS_PBAP_PBDI_END_CMD		"&PBDI:END"	// :END:<id>,<result>,<total_sent_size>
#define BT_RS_PBAP_PBII_CMD			"&PBII"		// :<index>,<total size>,<total frame>,<currentframe>,"<data>"
#define BT_RS_PBAP_PBII_END_CMD		"&PBII:END"	// :END:<id>,<result>,<total_sent_size>
#define BT_RS_PBAP_PBDS_CMD			"&PBDS"		// :<id>,<pbState>,<CallListState>
#define BT_RS_AV_AVSI_CMD			"&AVSI"		// :<id>,<Event>[,<parameter>]
#define BT_RS_AV_AVPI_CMD			"&AVPI"		// :<id>,<info ID>,"<Data>"
#define BT_RS_AV_AVPS_CMD			"&AVPS"		// :<repeat><shuffle>
#define BT_RS_MAP_MANN_CMD			"&MANN"		// :<id>,<msg_id>
#define BT_RS_MAP_MAGM_CMD			"&MAGM"		// :<msg_id>,"<Name>","<FName>","<TEL>","<message_string>"
#define BT_RS_MAP_MAGF_CMD			"&MAGF"		// :"<f_name>"
#define BT_RS_MAP_MAGML_CMD			"&MAGML"	// :<idx>,"<subject>","<sender_name>","<sender_number>","<timestamp>",<msg_type>,<size>,<read>
#define BT_RS_SPP_SPRX_CMD			"&SPRX"		// :<size>,"<data>"
#define BT_RS_UPGRADE_HSRDY_CMD		"&HSRDY"
#define BT_RS_UPGRADE_BIN_CMD		"&BIN"
#define BT_RS_ECHO_CMD				"&ECHO"
#define BT_RS_BTMTEST_CMD			"&TESTCMD"	// =<mode>,<on/off>
#define BT_RS_APLIPM_CMD			"&APLIPM"	//:<port>,<mode>,"<device name>"
#define BT_RS_BVRA_MODE_CMD			"+BVRA"		// :<mode>
#define BT_RS_SIRI_STATUS_CMD		"+APLSIRI"	// :<value>
#define BT_RS_HFP_FORD_MODE_CMD		"&HFM"		// :<value>
#define BT_RS_AV_MUTE_MODE_CMD		"&AVMUTE"	// :<mode>
#define BT_RS_BTM_DTC_CMD			"&DTC"
#define BT_RS_BACM_CMD              "&BACM"     // :<mode>[,<device ID>]
#define BT_RS_ALIVE_CMD             "&ALIVE"    // NULL
#define BT_RS_GRDN_CMD              "&GRDN"     // :<remote device name length>, ?<remote device name>? OK

//#ifdef __PROJECTION__
//projection
#define BT_RS_AAPM_CMD              "&AAPM"     // <Port>,<Mode>,<BD Address>
#define BT_RS_FPM_FORD_MODE_CMD		"&FPM"		// :<value>
//#endif

#define BT_CMD_ECA_ERROR			"ECA"		// =<mode>
#define BT_CMD_BTSYS_ERROR			"BTSYS"		// =<on/off>
#define BT_CMD_FRST_ERROR			"FRST"		// NULL
#define BT_CMD_SRST_ERROR			"SRST"		//NULL
#define BT_CMD_SBR_ERROR			"SBR"		// ?	// =<Baudrate>
#define BT_CMD_GBTMIF_ERROR			"GBTMIF"		// ?
#define BT_CMD_CLDN_ERROR			"CLDN"		// ?	// =<Local_Name>
#define BT_CMD_BDADDR_ERROR			"BDADDR"		// ?	// =<BTM_Address>
#define BT_CMD_RSSI_ERROR			"RSSI"		// =<id>
#define BT_CMD_BTSTATE_ERROR		"BTSTATE"	// ?
#define BT_CMD_BTCFG_ERROR			"BTCFG"		// ?
#define BT_CMD_CMODE_ERROR			"CMODE"		// =<on/off>
#define BT_CMD_DMODE_ERROR			"DMODE"		// =<on/off>,<mode>
#define BT_CMD_BDI_ERROR			"BDI"		// =<mode>
#define BT_CMD_PAIRM_ERROR			"PAIRM"		// ?	//=<Pairing Mode>
#define BT_CMD_PAIRQ_ERROR			"PAIRQ"		// =<id>
#define BT_CMD_PAIRP_ERROR			"PAIRP"		// =<id>,<action>[,<PIN code>]
#define BT_CMD_SSPM_ERROR			"SSPM"		// ?	//<state>[,<SSPmode>]
#define BT_CMD_SSPP_ERROR			"SSPP"		// =<device id>,<SSP Answer>[,< numeric >]
#define BT_CMD_LPBD_ERROR			"LPBD"		// ?	// =<id>
#define BT_CMD_DPA_ERROR			"DPA"		// =<id>
#define BT_CMD_SDP_ERROR			"SDP"		// =<id>[,<service>]
#define BT_CMD_BSCQ_ERROR			"BSCQ"		// =<id>,<mode>,<serviceBit>
#define BT_CMD_BSCC_ERROR			"BSCC"		// =<id>,0,<serviceBit>[,<auth>]
#define BT_CMD_BACM_ERROR			"BACM"		// =<on/off>[,<mode>"
#define BT_CMD_BACQ_ERROR			"BACQ"		// =<start/stop>
#define BT_CMD_HFP_BRSF_ERROR		"BRSF"		// ?
#define BT_CMD_HFP_ATD_ERROR		"ATD"			// <dial number>
#define BT_CMD_HFP_ATDM_ERROR		"ATD>"			//<nnn>
#define BT_CMD_HFP_BLDN_ERROR		"BLDN"		// NULL
#define BT_CMD_HFP_ATA_ERROR		"ATA"			// NULL
#define BT_CMD_HFP_CHUP_ERROR		"CHUP"		// NULL
#define BT_CMD_HFP_ECC_ERROR		"ECC"		// =<action>[,<call Index>]
#define BT_CMD_HFP_CLCC_ERROR		"CLCC&"		// ?
#define BT_CMD_HFP_CLCCP_ERROR		"CLCC+"		// ?
#define BT_CMD_HFP_CIND_ERROR		"CIND"		// ?
#define BT_CMD_HFP_CCWA_ERROR		"CCWA"		// ?	// =<mode>
#define BT_CMD_HFP_CLIP_ERROR		"CLIP"		// ?	// =<mode>
#define BT_CMD_HFP_COPS_ERROR		"COPS"		// ?
#define BT_CMD_HFP_CAUD_ERROR		"CAUD"		// ?	// =<mode>
#define BT_CMD_HFP_VTS_ERROR		"VTS"		// =<DTMF>
#define BT_CMD_HFP_MGC_ERROR		"MGC"		// ?	// =<mic gain>
#define BT_CMD_HFP_ECNRBTM_ERROR	"ECNRBTM"	// ?	// =<btm on/off>
#define BT_CMD_HFP_ECNRAG_ERROR		"ECNRAG"		// ?	// =<ag on/off>
#define BT_CMD_HFP_CGMI_ERROR		"CGMI"		// NULL
#define BT_CMD_HFP_CGMM_ERROR		"CGMM"		// NULL
#define BT_CMD_HFP_CGMR_ERROR		"CGMR"		// NULL
#define BT_CMD_PBAP_PBS_ERROR		"PBS"		//=<id>,<src>,<type>
#define BT_CMD_PBAP_PBD_ERROR		"PBD"		// ?	// =<id>,<type>,<src>,<vacrd version>,<sindex>,Meindex>[,<vcard feld type>]
#define BT_CMD_PBAP_PBA_ERROR		"PBA"		// =<id>,<type>,<src>,<sindex>,<eindex>
#define BT_CMD_PBAP_PBI_ERROR		"PBI"		//=<id>,<type>,<src>,<sindex>,<eindex>
#define BT_CMD_PBAP_PBDA_ERROR		"PBDA"		//=<id>
#define BT_CMD_PBAP_PBDS_ERROR		"PBDS"		//?
#define BT_CMD_AV_AVOP_ERROR		"AVOP"		// =<id>,<OP>
#define BT_CMD_AV_AVPI_ERROR		"AVPI"		// =<id>,<info id>
#define BT_CMD_AV_AVPS_ERROR		"AVPS"		// ? // =<id>,<repeat>,<shuffle>
#define BT_CMD_MAP_MANR_ERROR		"MANR"		// =<id>,<mode>
#define BT_CMD_MAP_MAGM_ERROR		"MAGM"		// =<id>,<msg_id>
#define BT_CMD_MAP_MASST_ERROR		"MASST"		// =<id>,<msg_id>,<status_ind>
#define BT_CMD_MAP_MAA_ERROR		"MAA"		// =<id>
#define BT_CMD_MAP_MAIU_ERROR		"MAIU"		// =<id>
#define BT_CMD_MAP_MASF_ERROR		"MASF"		// =<id>,<mode>[,"<folder_name>"]
#define BT_CMD_MAP_MAGF_ERROR		"MAGF"		// NULL
#define BT_CMD_MAP_MAGML_ERROR		"MAGML"		// =<id>,<startIdx>,<size>[,"<f_name>"]
#define BT_CMD_SPP_SPTX_ERROR		"SPTX"		// =<size>,"<data>"
#define BT_CMD_SPP_SPMODE_ERROR		"SPMODE"		// =<mode>
#define BT_CMD_UPGRADE_UPLOAD_ERROR	"UPLOAD"
#define BT_CMD_UPGRADE_HSRDY_ERROR	"HSRDY"
#define BT_CMD_UPGRADE_SIZE_ERROR	"SIZE"
#define BT_CMD_UPGRADE_BIN_ERROR	"BIN"
#define BT_CMD_ECHO_ERROR			"ECHO"
#define BT_CMD_BTM_TEST_ERROR		"TESTCMD"	// =<mode>[,<on/off>]
#define BT_CMD_APLIPM_ERROR			"APLIPM"
#define BT_CMD_BVRA_MODE_ERROR		"BVRA"
#define BT_CMD_SIRI_EFM_ERROR		"APLEFM"
#define BT_CMD_HFP_FORD_MODE_ERROR	"HFM"
#define BT_CMD_AV_MUTE_MODE_ERROR	"AVMUTE"
#define BT_CMD_BTM_DTC_ERROR		"DTC"
#define BT_CMD_ALIVE_ERROR          "ALIVE"
#define BT_CMD_GRDN_ERROR           "GRDN"
#define BT_CMD_ECNR_ERROR           "ECNR"
#define BT_CMD_FPM_FORD_MODE_ERROR	"FPM"
#endif /* __BT_CMD_H__ */
