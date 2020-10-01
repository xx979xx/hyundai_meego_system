/*
******************************************************************
*        COPYRIGHT (C) Teleca AB      *
*----------------------------------------------------------------*
* MODULE     :  DHAVN_TrackerAbstractor                             *
*
* PROGRAMMER :  Chetan Nanda                                   *
* DATE       :  12 September 2011                                    *
* VERSION    :  1.0                                              *
*
*----------------------------------------------------------------*
*                                                                *
* MODULE SUMMARY : This file defines constants    *
*                  used by different content providers and applications     *
*                                                                *
*----------------------------------------------------------------*
*
* MODIFICATION RECORDS :                                         *
*
* VERSION   DATE                     PROGRAMMER              COMMENT
******************************************************************
* 1.0       12 September 2011  Chetan Nanda           Draft version
******************************************************************
*/

#ifndef DHAVN_SQLITEABSTRACTOR_CONSTANTS_H
#define DHAVN_SQLITEABSTRACTOR_CONSTANTS_H

#include <QString>
#include <QMap>
#include <QStringList>

const int  MAX_QUEUE_SIZE =  10;
const int  MAX_TIME_LIMIT = 30000;
#define EVOLUME_TYPE_SIZE 10
#define QUERY_OFFSET 		0
#define QUERY_LIMIT 		10
#define NUM_NUMBER_TBL  	(1)
#define NUM_ENGLISH_TBL  	(26)
#define NUM_KOREAN_TBL  	(14)
#define NUM_EXTRA_TBL  		(4)
#define NUM_UNICODE_TBL  	(NUM_NUMBER_TBL+NUM_ENGLISH_TBL+NUM_KOREAN_TBL+NUM_EXTRA_TBL)

enum ESQLiteAbstarctor_ErrorType
{
    eNullStringParameter = 0,
    eEmptyString,
    eErrorInQueryExecution,
    eErrorInQuery,
    eQueryMappingError,
    eCoverArtImageNotFound,
    eErrorEmptyURL,
    eErrorNoThumbnailData,
    eErrorDirPathNotExists,
    eErrorDeviceId,
    eErrorDBFileError
};

/**
   * Enums for query Id used to identify respective query
   */
enum ESQLiteAbstarctor_Query_Ids
{
    eDefault_Id = 0,    /**< Default Id for intialization */

	/* ---- PhoneBook Data Provider - SQLite ---- */
    eGetAllPhoneContactsQuery_Id = 300,
	eGetAllRecentCallQuery_Id = 301,
	eGetAllReceivedCallQuery_Id = 302,
	eGetAllMissedCallQuery_Id = 303,
	eGetAllCallHistoryQuery_Id = 304,
	eGetAllFavoriteContactsQuery_Id = 305,
	/* ---- PhoneBook Data Search - SQLite ---- */
    eGetContactDetailsByNameQuery_Id = 310,
    eGetAllContactsByKeywordForBDAdressQuery_Id = 311,
    //eGetContactByNumberQuery_Id = 312,
    eGetContactByNumberForForeignQuery_Id = 312,
    eGetContactByNumberForDomesticQuery_Id = 313,
    eGetFavoriteContactByNameAndNumberQuery_Id = 314,
    eGetContactByCallHistoryInfoQuery_Id = 315,
    //eGetContactByNumberForCallHistoryNameQuery_Id = 315,
    eGetContactByNumberForForeignCallHistoryNameQuery_Id = 316,
    eGetContactByNumberForDomesticCallHistoryNameQuery_Id = 317,
    eGetContactByCallHistoryInfoQuery_Id_KR_NA = 318,
    //eGetContactByNumberForCallHistoryNameQuery_Id_KR_NA = 317,
    eGetContactByNumberForCallHistoryNameQuery_Id_KR = 319,
    eGetContactByNumberForCallHistoryNameQuery_Id_CN = 320,
    eGetContactByNumberForCallHistoryNameQuery_Id_NA = 321,
    eGetPhoneBookHashValueByBDAddressQuery_Id = 322,

    eGetContactByNumberQuery_Id_KR = 323,
    eGetContactByNumberQuery_Id_CN = 324,
    eGetContactByNumberQuery_Id_NA = 325,
    /* ---- PhoneBook Data Count - SQLite ---- */

    /////SUPPORT_MIDDLE_NAME
    eMidGetContactByNumberForDomesticQuery_Id = 306,
    eMidGetContactByNumberForDomesticCallHistoryNameQuery_Id = 307,
    //eMidGetContactByNumberForForeignCallHistoryNameQuery_Id = 308,
    eMidGetAllFavoriteContactsForForeignQuery_Id = 308,
    eMidGetAllFavoriteContactsForDomesticQuery_Id = 309,
    eMidGetAllPhoneContactsForForeignQuery_Id = 326,
    eMidGetAllPhoneContactsForDomesticQuery_Id = 327,
    eMidGetContactByCallHistoryInfoQuery_Id = 328,
    eMidGetFavoriteContactByNameAndNumberQuery_Id = 329,
    //eMidGetContactByCallHistoryInfoQuery_Id_KR_NA = 329,
    /////SUPPORT_MIDDLE_NAME
    ePinyinGetAllSelectedPhoneContactsForDomesticQuery_id = 357,
    /* FEATURE_ORDER_BY_PINYIN */

    eGetAllPhoneContactCountQuery_Id = 330,
    eGetAllRecentCallCountQuery_Id = 331,
    eGetAllReceivedCallCountQuery_Id = 332,
    eGetAllMissedCallCountQuery_Id = 333,
    eGetAllCallHistoryCountQuery_Id = 334,
    eGetAllFavoriteContactCountQuery_Id = 335,
    eGetAllPhoneContactsForForeignQuery_Id = 336,
    eGetAllPhoneContactsForDomesticQuery_Id = 337,
	eGetAllFavoriteContactsForForeignQuery_Id = 338,
	eGetAllFavoriteContactsForDomesticQuery_Id = 339,    
	/* ---- PhoneBook Data Updater - SQLite ---- */
    eInsertContactsToDBaseQuery_Id = 340,
    eRemovePhoneBookDataBySelectionQuery_Id = 341,
    eRemoveContactDataQuery_Id = 342,
    eRemoveContactDataByIndexQuery_Id = 343
};

enum ESQLiteAbstarctor_RequestStates
{
    eDefaultRequest = 0,
    eProcessRequest,
    eWaitRequest,
    eCancelRequest,
    eProcesscomplete
};

// Unicode Table for a letter
const ushort  Letter_Tbl[NUM_UNICODE_TBL] = {
    0x0020, // ' ' //0x0000, //changed by junam 2013.07.25 for ITS_EU_180117
    0x0023, // '#' (Numeric)
    0x0000, // NULL
	0x0041, // 'A
	0x0042, // 'B
	0x0043, // 'C'
	0x0044, // 'D'
	0x0045, // 'E'
	0x0046, // 'F'
	0x0047, // 'G'
	0x0048, // 'H'
	0x0049, // 'I'
	0x004A, // 'J'
	0x004B, // 'K'
	0x004C, // 'L'
	0x004D, // 'M'
	0x004E, // 'N'
	0x004F, // 'O'
	0x0050, // 'P'
	0x0051, // 'Q'
	0x0052, // 'R'
	0x0053, // 'S'
	0x0054, // 'T'
	0x0055, // 'U'
	0x0056, // 'V'
	0x0057, // 'W'
	0x0058, // 'X'
	0x0059, // 'Y'
	0x005A,	// 'Z'
	0x0000, // NULL
    0x3131, // 'ㄱ'
    0x3134, // 'ㄴ'
    0x3137, // 'ㄷ'
    0x3139, // 'ㄹ'
    0x3141, // 'ㅁ'
    0x3142, // 'ㅂ'
    0x3145, // 'ㅅ'
    0x3147, // 'ㅇ'
    0x3148, // 'ㅈ'
    0x314A, // 'ㅊ'
    0x314B, // 'ㅋ'
    0x314C, // 'ㅌ'
    0x314D, // 'ㅍ'
    0x314E, // 'ㅎ'
    0x0000  // NULL
};		

// Unicode Range Table for a letter
const ushort Letter_Unicode_Map_Tbl[NUM_UNICODE_TBL][2] = {
	{0x0000, 0x002F},	// First ~ '0'
	{0x0030, 0x0039},	// '0' ~ '9' : Numeric
	{0x003A, 0x0040},	// '9' ~ 'A'
    {0x0041, 0x0041},	// 'A' => Alphabet Begin
	{0x0042, 0x0042},	// 'B'
	{0x0043, 0x0043},	// 'C'
	{0x0044, 0x0044},	// 'D'
	{0x0045, 0x0045},	// 'E'
	{0x0046, 0x0046},	// 'F'
	{0x0047, 0x0047},	// 'G'
	{0x0048, 0x0048},	// 'H'
	{0x0049, 0x0049},	// 'I'
	{0x004A, 0x004A},	// 'G'
	{0x004B, 0x004B},	// 'K'
	{0x004C, 0x004C},	// 'L'
	{0x004D, 0x004D},	// 'M'
	{0x004E, 0x004E},	// 'N'
	{0x004F, 0x004F},	// 'O'
	{0x0050, 0x0050},	// 'P'
	{0x0051, 0x0051},	// 'Q'
	{0x0052, 0x0052},	// 'R'
	{0x0053, 0x0053},	// 'S'
	{0x0054, 0x0054},	// 'T'
	{0x0055, 0x0055},	// 'U'
	{0x0056, 0x0056},	// 'V'
	{0x0057, 0x0057},	// 'W'
	{0x0058, 0x0058},	// 'X'
	{0x0059, 0x0059},	// 'Y'
    {0x005A, 0x005A},	// 'Z' <= Alphabet End
    {0x005B, 0xABFF},	//
    {0xac00, 0xb097},	// '가~'
    {0xb098, 0xb2e3},	// '나~'
    {0xb2e4, 0xb77b},	// '다~'
    {0xb77c, 0xb9c7},	// '라~'
    {0xb9c8, 0xbc13},	// '마~'
    {0xbc14, 0xc0ab},	// '바~'
    {0xc0ac, 0xc543},	// '사~'
    {0xc544, 0xc78f},	// '아~'
    {0xc790, 0xcc27},	// '자~'
    {0xcc28, 0xce73},	// '차~'
    {0xce74, 0xd0bf},	// '카~'
    {0xd0c0, 0xd30b},	// '타~'
    {0xd30c, 0xd557},	// '파~'
    {0xd558, 0xd7a3},	// '하~'
    {0xD7A4, 0xFFFF}	// 
};

// { added by jaehwan.lee  13.01.04 for audio contents sort issue 

/*
const QChar  gKorBegin1(0x1100); 
const QChar  gKorEnd1(0x1200); 
const QChar  gKorBegin2(0x3130); 
const QChar  gKorEnd2(0x3190); 
const QChar  gKorBegin3(0xAC00); 
const QChar  gKorEnd3(0xD7B0); 
*/
//const QChar  gKorBegin1(0x3131);
//const QChar  gKorEnd1(0x3150);
const QChar  gKorBegin2(0x1160); //not used
const QChar  gKorEnd2(0x11A3); 

const QChar  gKorBegin1(0x3131); //modified by honggi.shin 2013.12.05
const QChar  gKorEnd1(0xD7A3);


//const QChar  gArbBegin1(0x0600);
//const QChar  gArbEnd1(0x0700);
//const QChar  gArbBegin2(0x0750);
//const QChar  gArbEnd2(0x0780);
//const QChar  gArbBegin3(0x08A0);  //not used
//const QChar  gArbEnd3(0x0900);
//const QChar  gArbBegin4(0xFB50);
//const QChar  gArbEnd4(0xFF00);
//const QChar  gArbBegin5(0xFE70);
//const QChar  gArbEnd5(0xFF00);


//{ modified by honggi.shin 2013.12.05
const QChar  gArbBegin1(0x0621); 
const QChar  gArbEnd1(0x0623);
const QChar  gArbSpecial1(0x0625);
const QChar  gArbBegin2(0x0627);
const QChar  gArbEnd2(0x064A);
const QChar  gArbSpecial2(0x0624);
const QChar  gArbSpecial3(0x0626);
//} modified by honggi.shin

//{ modified by honggi.shin 2013.12.05
const QString  gOrderByKor = "!(?%1 < 'A') "
                             "!((?%1>='%2')&&(?%1 <= '%3%3%3%3%3')) ";  //modified by honggi.shin 2013.12.05
//} modified by honggi.shin


//{ modified by honggi.shin 2013.12.05
const QString  gOrderByArb = "!(?%1 < 'A') "
                             "!((?%1 >= '%2') && (?%1 <= '%3%6%6%6%6%6%6%6%6%6')) "
                             "!((?%1 >= '%4') && (?%1 <= '%4%6%6%6%6%6%6%6%6%6')) "
                             "!((?%1 >= '%5') && (?%1 <= '%6%6%6%6%6%6%6%6%6%6')) "
                             "!((?%1 >= '%7') && (?%1 <= '%7%6%6%6%6%6%6%6%6%6')) "
                             "!((?%1 >= '%8') && (?%1 <= '%8%6%6%6%6%6%6%6%6%6')) ";  //modified by honggi.shin 2013.12.05
//} modified by honggi.shin 

//{ modified by jaeh7.lee 2013.12.27
const QString  gOrderByZh = "!(?%1 < 'A') "
                             "!((?%1>='%2')&&(?%1 <= '%3%3%3%3%3')) ";  //modified by honggi.shin 2013.12.05
//} modified by honggi.shin


/**
  * Contact Data Structures
  */
enum BT_PBAP_DB_TYPE{
      DB_PHONE_BOOK
    , DB_RECENT_CALLS
    , DB_RECEIVED_CALLS
    , DB_MISSED_CALLS
    , DB_COMBINED_CALLS
    , DB_CALL_HISTORY
    , DB_FAVORITE_PHONE_BOOK
    , DB_ALL_TYPE
/////SUPPORT_MIDDLE_NAME
    , DB_MID_PHONEBOOK
    , DB_MID_FAVORITE
/////SUPPORT_MIDDLE_NAME
    , DB_PINYIN_PHONEBOOK
    /* FEATURE_ORDER_BY_PINYIN */
};

enum BT_PBAP_DB_MEMORY{
    DB_PHONE_MEMORY,
    DB_SIM_MEMORY,
    DB_ALL_MEMORY
};

enum BT_PBAP_DB_SORTING{
    DB_SORT_BY_INDEX,
    DB_SORT_BY_FIRST_NAME,
    DB_SORT_BY_LAST_NAME,
    DB_SORT_BY_FORMMATED_NAME,
    DB_SORT_BY_TIME_STAMP
};

struct BT_PBAP_DB_CONTACT{
    QString bd_address;
    quint16 index;
    BT_PBAP_DB_TYPE type;
    BT_PBAP_DB_MEMORY memory_Type;
    QString first_name;
    QString crypto_hash;
    QString last_name;
    QString formatted_name;
    quint8 num_type1;
    QString number1;
    quint8 num_type2;
    QString number2;
    quint8 num_type3;
    QString number3;
    quint8 num_type4;
    QString number4;
    quint8 num_type5;
    QString number5;
    QString time_stamp;         // time stamp should be in "2011-11-14T17:40:00Z"  format
    QString middle_name;
    QString pinyin;
    quint8 use_pinyin;
    QString pinyin_order;
    /* FEATURE_ORDER_BY_PINYIN */
};

/**
  * Remove BT contact Structure
  */
struct SRemoveBTContact
{
	QString bd_address;
	quint16 index;
	QString first_name;
	BT_PBAP_DB_MEMORY memoryType;
	BT_PBAP_DB_TYPE dbType;
};

/**
   * Mapping function to map query with respective query ids
   */
static QMap<QString, ESQLiteAbstarctor_Query_Ids> GetMapQueryIds() {
    QMap<QString, ESQLiteAbstarctor_Query_Ids> mapQueryIds;
    return mapQueryIds;
};

static const QMap<QString, ESQLiteAbstarctor_Query_Ids> MAP_QUERY_IDS = GetMapQueryIds();

/* ------------------------------------ PhoneBook Data Provider - SQLite ------------------------------------ */
const QString gGetAllSelectedPhoneContactsFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5"
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY %3 ";
const int PHONE_BOOK_DATA_TYPE_COUNT = 14;

/////SUPPORT_MIDDLE_NAME1
const QString gMidGetAllSelectedPhoneContactsFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5"
      ",middle_name"
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY %3 ";
/////SUPPORT_MIDDLE_NAME

const QString gGetAllSelectedPhoneContactsForForeignFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((first_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY contact_name COLLATE NOCASE";

/////ORDER BY idx
const QString gIdxGetAllSelectedPhoneContactsForForeignFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((first_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY idx ";
/////ORDER BY idx

/////SUPPORT_MIDDLE_NAME2
const QString gMidGetAllSelectedPhoneContactsForForeignFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((first_name||middle_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY contact_name COLLATE NOCASE";
/////SUPPORT_MIDDLE_NAME

const QString gGetAllSelectedPhoneContactsForDomesticFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY contact_name COLLATE NOCASE";

/////ORDER BY idx
const QString gIdxGetAllSelectedPhoneContactsForDomesticFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY idx ";
/////ORDER BY idx

/////SUPPORT_MIDDLE_NAME3
const QString gMidGetAllSelectedPhoneContactsForDomesticFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||middle_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY contact_name COLLATE NOCASE";
/////SUPPORT_MIDDLE_NAME

const QString gPinyinGetAllSelectedPhoneContactsForDomesticFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",pinyin,middle_name,use_pinyin"
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY use_pinyin, pinyin_order, pinyin COLLATE NOCASE";
    /* FEATURE_ORDER_BY_PINYIN */

/////ORDER BY idx
const QString gIdxMidGetAllSelectedPhoneContactsForDomesticFromSQLiteDBQuery
= "SELECT memory_type,first_name,last_name,formatted_name,"
  "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
  ",COALESCE(NULLIF((last_name||middle_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
  ",middle_name"
  " FROM PhoneTable "
  " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
  " ORDER BY idx ";
/////ORDER BY idx

const int PHONE_CONTACTS_DATA_TYPE_COUNT = 16;

const QString gGetAllSelectedCallHistoryFromSQLiteDBQuery
    = "SELECT idx,db_type,memory_type,bd_address,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,time_stamp "
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY %3 ";


/////SUPPORT_MIDDLE_NAME4
const QString gMidGetAllSelectedCallHistoryFromSQLiteDBQuery
    = "SELECT idx,db_type,memory_type,bd_address,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,time_stamp "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE bd_address=\"%1\" AND db_type=\"%2\" "
      " ORDER BY %3 ";
/////SUPPORT_MIDDLE_NAME


const QString gGetAllCallHistoryFromSQLiteDBQuery
/////IQS_15MY
#if 0
    = "SELECT idx,db_type,memory_type,bd_address,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,time_stamp "
      " FROM PhoneTable "
      " WHERE ( db_type='1' OR db_type='2' OR db_type='3' ) AND bd_address=\"%1\" "
      " ORDER BY %2 ";
#else
    = "SELECT idx,db_type,memory_type,bd_address,first_name,last_name,formatted_name,"
      " num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,time_stamp "
      " FROM PhoneTable "
      " WHERE ( db_type='1' OR db_type='2' OR db_type='3' ) AND bd_address=\"%1\" "
      " ORDER BY CASE"
      " WHEN time_stamp=\"\" AND db_type='1' THEN 3"
      " WHEN time_stamp=\"\" AND db_type='3' THEN 2"
      " WHEN time_stamp=\"\" AND db_type='2' THEN 1"
      " ELSE"
      " time_stamp"
      " END DESC";
#endif  /* 0 */
/////IQS_15MY


const int CALL_HISTORY_DATA_TYPE_COUNT = 18;


/////SUPPORT_MIDDLE_NAME5
const QString gMidGetAllCallHistoryFromSQLiteDBQuery
    = "SELECT idx,db_type,memory_type,bd_address,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,time_stamp "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE ( db_type='1' OR db_type='2' OR db_type='3' ) AND bd_address=\"%1\" "
      " ORDER BY %2 ";
/////SUPPORT_MIDDLE_NAME


/* ------------------------------------ PhoneBook Data Search - SQLite ------------------------------------ */
const QString gGetContactDetailsByNameFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND (first_name=\"%2\" OR last_name=\"%2\" OR formatted_name=\"%2\") "
      " ORDER BY first_name ";

const QString gGetAllContactsByKeywordForBDAdressFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND "
      " ( first_name LIKE \"%2\" OR last_name LIKE \"%2\" OR formatted_name LIKE \"%2\" OR "
      " number1 LIKE \"%2\" OR number2 LIKE \"%2\" OR "
      " number3 LIKE \"%2\" OR number4 LIKE \"%2\" OR "
      " number5 LIKE \"%2\" ) "
      " ORDER BY first_name ";

const QString gGetContactByNumberForForeignFromSQLiteDBQuery 
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5"
      ",COALESCE(NULLIF((first_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( number1=\"%2\" OR number2=\"%2\" OR number3=\"%2\" OR number4=\"%2\" OR number5=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

const QString gGetContactByNumberForDomesticFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,COALESCE(NULLIF((last_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( number1=\"%2\" OR number2=\"%2\" OR number3=\"%2\" OR number4=\"%2\" OR number5=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

/////SUPPORT_MIDDLE_NAME6
const QString gMidGetContactByNumberForDomesticFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||middle_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( number1=\"%2\" OR number2=\"%2\" OR number3=\"%2\" OR number4=\"%2\" OR number5=\"%2\" ) "
      " ORDER BY pinyin, use_pinyin, contact_name COLLATE NOCASE";
    /* FEATURE_ORDER_BY_PINYIN */

const QString gGetContactByNumberFromSQLiteDBQuery_KR
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5"
      ",COALESCE(NULLIF((last_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( substr(number1, \"%3\")=\"%2\" OR substr(number2, \"%3\")=\"%2\" OR substr(number3, \"%3\")=\"%2\" OR substr(number4, \"%3\")=\"%2\" OR substr(number5, \"%3\")=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

const QString gGetContactByNumberFromSQLiteDBQuery_CN
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5"
      ",COALESCE(NULLIF((first_name||middle_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( substr(number1, \"%3\")=\"%2\" OR substr(number2, \"%3\")=\"%2\" OR substr(number3, \"%3\")=\"%2\" OR substr(number4, \"%3\")=\"%2\" OR substr(number5, \"%3\")=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

const QString gGetFavoriteContactByNameAndNumberFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
      " FROM PhoneTable "
      " WHERE db_type='6' AND bd_address=\"%1\" AND first_name=\"%2\" AND last_name=\"%3\" AND ( number1=\"%4\" OR number2=\"%4\" OR number3=\"%4\" OR number4=\"%4\" OR number5=\"%4\" ) "
      " ORDER BY first_name ";
const int PHONE_BOOK_SEARCH_RESULT_DATA_TYPE = 14;

/////SUPPORT_MIDDLE_NAME7
const QString gMidGetFavoriteContactByNameAndNumberFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
      "middle_name"
      " FROM PhoneTable "
      " WHERE db_type='6' AND bd_address=\"%1\" AND first_name=\"%2\" AND last_name=\"%3\" AND middle_name=\"%4\" AND ( number1=\"%5\" OR number2=\"%5\" OR number3=\"%5\" OR number4=\"%5\" OR number5=\"%5\" ) "
      " ORDER BY first_name ";
/////SUPPORT_MIDDLE_NAME

const QString gGetContactByNumberForForeignCallHistoryNameFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((first_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( number1=\"%2\" OR number2=\"%2\" OR number3=\"%2\" OR number4=\"%2\" OR number5=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";


/////SUPPORT_MIDDLE_NAME8
const QString gMidGetContactByNumberForForeignCallHistoryNameFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((first_name||middle_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( number1=\"%2\" OR number2=\"%2\" OR number3=\"%2\" OR number4=\"%2\" OR number5=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";
/////SUPPORT_MIDDLE_NAME


const QString gGetContactByNumberForDomesticCallHistoryNameFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( substr(number1, \"%3\")=\"%2\" OR substr(number2, \"%3\")=\"%2\" OR substr(number3, \"%3\")=\"%2\" OR substr(number4, \"%3\")=\"%2\" OR substr(number5, \"%3\")=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

/////SUPPORT_MIDDLE_NAME9
const QString gMidGetContactByNumberForDomesticCallHistoryNameFromSQLiteDBQuery
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||middle_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( substr(number1, \"%3\")=\"%2\" OR substr(number2, \"%3\")=\"%2\" OR substr(number3, \"%3\")=\"%2\" OR substr(number4, \"%3\")=\"%2\" OR substr(number5, \"%3\")=\"%2\" ) "
      " ORDER BY pinyin, use_pinyin, contact_name COLLATE NOCASE";
    /* FEATURE_ORDER_BY_PINYIN */

const QString gGetContactByNumberForCallHistoryNameFromSQLiteDBQuery_KR
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((last_name||first_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( substr(number1, \"%3\")=\"%2\" OR substr(number2, \"%3\")=\"%2\" OR substr(number3, \"%3\")=\"%2\" OR substr(number4, \"%3\")=\"%2\" OR substr(number5, \"%3\")=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

const QString gGetContactByNumberForCallHistoryNameFromSQLiteDBQuery_CN
    = "SELECT memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,idx"
      ",COALESCE(NULLIF((first_name||middle_name||last_name), \"\"), NULLIF(formatted_name,\"\"), number1) 'contact_name' "
      ",middle_name"
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND ( substr(number1, \"%3\")=\"%2\" OR substr(number2, \"%3\")=\"%2\" OR substr(number3, \"%3\")=\"%2\" OR substr(number4, \"%3\")=\"%2\" OR substr(number5, \"%3\")=\"%2\" ) "
      " ORDER BY contact_name COLLATE NOCASE";

const QString gGetContactByCallHistoryInfoFromSQLiteDBQuery
    = "SELECT idx,memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND first_name=\"%2\" AND last_name=\"%3\" AND ( number1=\"%4\" OR number2=\"%4\" OR number3=\"%4\" OR number4=\"%4\" OR number5=\"%4\" ) "
      " ORDER BY first_name ";

/////SUPPORT_MIDDLE_NAME10
const QString gMidGetContactByCallHistoryInfoFromSQLiteDBQuery
    = "SELECT idx,memory_type,first_name,last_name,formatted_name,"
      "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
      ", middle_name"
      " FROM PhoneTable "
      " WHERE db_type='0' AND bd_address=\"%1\" AND first_name=\"%2\" AND last_name=\"%3\" AND middle_name=\"%4\" AND ( number1=\"%5\" OR number2=\"%5\" OR number3=\"%5\" OR number4=\"%5\" OR number5=\"%5\" ) "
      " ORDER BY first_name ";
/////SUPPORT_MIDDLE_NAME

const QString gGetContactByCallHistoryInfoFromSQLiteDBQuery_KR_NA
    =  "SELECT idx,memory_type,first_name,last_name,formatted_name,"
       "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5 "
       " FROM PhoneTable "
       " WHERE db_type='0' AND bd_address=\"%1\" AND first_name=\"%2\" AND last_name=\"%3\" AND ( substr(number1, \"%5\")=\"%4\" OR substr(number2, \"%5\")=\"%4\" OR substr(number3, \"%5\")=\"%4\" OR substr(number4, \"%5\")=\"%4\" OR substr(number5, \"%5\")=\"%4\" ) "
       " ORDER BY first_name ";
const int CALL_HISTORY_SEARCH_RESULT_DATA_TYPE = 15;

const QString gGetPhoneBookHashValueByBDAddressFromSQLiteDBQuery =  "SELECT crypto_hash "
        " FROM PhoneTable "
        " WHERE db_type='0' AND bd_address=\"%1\" ";
const int PHONE_BOOK_CRYPTO_HASH_RESULT_DATA_TYPE = 1;

/* ------------------------------------ PhoneBook Data Count - SQLite ------------------------------------ */
const QString gGetAllSelectedPhoneContactsCountFromSQLiteDBQuery = " SELECT COUNT(*) "
                                                           " FROM PhoneTable "
                                                           " WHERE  bd_address=\"%1\" AND db_type=\"%2\" ";

const QString gGetAllCallHistoryCountFromSQLiteDBQuery = " SELECT COUNT(*) "
															" FROM PhoneTable "
                                                     		" WHERE (db_type='1' OR db_type='2' OR db_type='3') AND bd_address=\"%1\" ";
const int PHONE_BOOK_COUNT_DATA_TYPE = 1;

/* ------------------------------------ PhoneBook Data Updater - SQLite ------------------------------------ */
const QString gInsertContactIntoDBFromSQLiteDBQuery = " INSERT INTO PhoneTable "
	"(idx,db_type,memory_type,bd_address,first_name,crypto_hash,last_name,formatted_name,"
    "num_type1,number1,num_type2,number2,num_type3,number3,num_type4,number4,num_type5,number5,time_stamp,middle_name,"
    "pinyin,use_pinyin,pinyin_order)";
    /* FEATURE_ORDER_BY_PINYIN */

const QString gRemoveAllPhoneBookFromSQLiteDBQuery = " DELETE FROM PhoneTable ";

const QString gRemoveAllDataByBDAddressFromSQLiteDBQuery = " DELETE FROM PhoneTable "
	" WHERE bd_address=\"%1\" ";

const QString gRemoveSelectedDataOfBDAddressFromSQLiteDBQuery = " DELETE FROM PhoneTable "
	" WHERE bd_address=\"%1\" AND db_type=\"%2\" ";

const QString gRemoveAllCallHistoryOfBDAddressFromSQLiteDBQuery = " DELETE FROM PhoneTable "
	" WHERE (db_type='1' OR db_type='2' OR db_type='3') AND bd_address=\"%1\"";

const QString gRemoveContactDataByNameFromSQLiteDBQuery = " DELETE FROM PhoneTable "
	" WHERE db_type='0' AND bd_address=\"%1\" AND first_name=\"%2\" AND memory_type=\"%3\" ";

const QString gRemoveContactDataByIndexFromSQLiteDBQuery = " DELETE FROM PhoneTable "
	" WHERE db_type='0' AND bd_address=\"%1\" AND idx=\"%2\" AND memory_type=\"%3\" ";

#endif // DHAVN_TRACKERABSTRACTOR_CONSTANTS_H
