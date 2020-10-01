// defined with this macro as being exported.

//

/*=======================================================================================================
SMILib Wrapped API class
=========================================================================================================

* Create : 2007. 3

* Modified 2012.11.15

--------------------------------------------------------------------------------------------------------
designed by Louis. Lee
Copyright(c) 2011-2013
=======================================================================================================*/

/**
@mainpage	MultiMedia Player .

@section	intro 
- SMI subtitle parser library

@section	dev 
- CPU : X86
- OS : Ubuntu
- Devtool : gcc 

@section	company 
- CoreEmbedded
- www.ceinside.co.kr

@section	date 
- 2012-11-15

@section	author 
- Mr. Seo
- master@ceinside.co.kr
*/

#define FALSE		0
#define TRUE		1

#define SMILIB_API
#define USE_LIBGUESS // The detecting lib is changed with libguess.


// This class is exported from the SMILib
class SMILIB_API CSMILib {
public:
	CSMILib(void);
	/// @brief Caption Lang (Multi cpation support)
	enum { 
		All=-1,		
		Korean=0,	
		English,	
		Japanesse,
		Chinesse,
	};
	virtual ~CSMILib();

	/// @brief Erase the drawn caption on current screen
	int DrawSubtitleText(int bErase=FALSE);

	/// @brief : Subtitle parse Enable, Disable
	/// @return : NONE
	/// @param : T, F
	void EnableSubtitle(int bEnable) ;

	/// @brief Is Enable Subtitle parse?
	/// @return T, F
	/// @param NONE
	int IsEnableSubtitle() { return m_bEnableSubtitle; }

	/// @brief : Is Valid SMI Subtitle File?
	/// @return T, F
	/// @param NONE
	int HasSubtitle() { return m_bHasSubtitle; }

	void SetSubtitleLang(int nLang);
	int GetSubtitleLang() { return m_nSubTitleLang; }

	/// @brief Get subtitle SyncTime.
	/// @return Sync Time (milisec)
	/// @param NONE
	int GetSubtitleSyncTime() { return m_nSubtitleSyncTime; }

	/// @brief Set Subtitle SyncTime.
	/// @param Sync Time (milisec)
	/// @return NONE
	void SetSubtitleSyncTime(int nSyncTime) { m_nSubtitleSyncTime = nSyncTime; }

#ifdef USE_LIBGUESS
	const char* GetRegion(void) { return m_pRegion; }
	void SetDefaultRegion(int nRegion) { m_nDefRegion = nRegion; }
	int  GetDefaultRegion(void) { return m_nDefRegion; }
#endif
	// Subtitle Text Start is Top Area
	int             m_bSubTextTop;

#ifdef USE_UNICODE
	wchar_t*        m_pszSubtitleText;
#else
	char*           m_pszSubtitleText;
	wchar_t*        m_lpszSubtitleText;
#endif

protected:
	unsigned long   m_dwMMTimer;
	unsigned long   m_dwTimerInterval;
	int             m_bHasSubtitle;
	int             m_nSubTitleLangSave;
	int             m_nSubtitleSyncTime;

	void*           m_pSamiParser;
	void*           m_pCurrentCaption;
	void*           m_pAllCurrentCaption;

	// Informations
	wchar_t*        m_pszMediaFileName;
	int             m_bEnableSubtitle;
	unsigned long   m_clSubtitleColor;
	int             m_nSubTitleLang;

	unsigned long   m_clSubtitleText;

	int             m_bUnicode;

#ifdef USE_LIBGUESS
	const char      *m_pRegion; // by libguess
	int             m_nDefRegion;
#endif

public:
	/// @brief Load Smi subtitle file 
	/// @return T,F
	/// @param SMI File Full Path
	int LoadSmi(const wchar_t* pszFileName);
	//Close SMI File
	void CloseSMI(void);

	/// @brief Update Media Current Time
	/// @return NONE
	/// @param dwPos = Current Time ,dwDuration = Total Duration Time
	int OnUpdateTimer(unsigned long dwPos, unsigned long dwDuration);
	/// @brief Get Caption String in Current Time
	/// @return NONE
	/// @param Current Caption String
	void GetSubtitleStr(char* szSubStr);
	/// @brief This Func Call When Manual Changed Media Position ( When Seek Position)
	/// @return NONE
	/// @param Will be changed Media pos Time(MilliSec)
	void PosChange(unsigned long dwTime);
	// SubTitle Language Count return
	int GetSubLangCount(void);
};
