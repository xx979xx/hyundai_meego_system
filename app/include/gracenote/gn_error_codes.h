/*
* Copyright (c) 2001 Gracenote.
*
* This software may not be used in any way or distributed without
* permission. All rights reserved.
*
* Some code herein may be covered by US and international patents.
*/

/*
* gn_error_codes.h - Package code definitions and string access.
*/

/*
 * Note: all values are expressed in hexadecimal form.
 */


#ifndef	_GN_ERROR_CODES_H_
#define _GN_ERROR_CODES_H_

/*
* Dependencies
*/

#include "gn_defines.h"


#ifdef __cplusplus
extern "C"{
#endif

/*
 * NOTE: Additional package identifiers and error codes can be found in gn_abs_errors.h
 */

/*
 * Constants
 */

/* Package/library identifiers. */
#define GNPKG_Generic					(BASE_GNERR_PKG_ID+0x00)
#define GNPKG_Abstraction				(BASE_GNERR_PKG_ID+0x01)
#define GNPKG_DBEngine					(BASE_GNERR_PKG_ID+0x02)
#define GNPKG_XML						(BASE_GNERR_PKG_ID+0x03)
#define GNPKG_Translator				(BASE_GNERR_PKG_ID+0x04)
#define GNPKG_EmbeddedDB				(BASE_GNERR_PKG_ID+0x05)
#define GNPKG_TOCLookup					(BASE_GNERR_PKG_ID+0x06)
#define GNPKG_Crypto					(BASE_GNERR_PKG_ID+0x07)
#define GNPKG_OnlineProtocol			(BASE_GNERR_PKG_ID+0x09)
#define GNPKG_DynBuf					(BASE_GNERR_PKG_ID+0x0A)
#define GNPKG_Updater					(BASE_GNERR_PKG_ID+0x0B)
#define GNPKG_Utils						(BASE_GNERR_PKG_ID+0x0C)
#define GNPKG_System					(BASE_GNERR_PKG_ID+0x0D)
#define GNPKG_EmbeddedDBIM				(BASE_GNERR_PKG_ID+0x0E)
#define GNPKG_LocalDataCache			(BASE_GNERR_PKG_ID+0x0F)
#define GNPKG_DVDEngine					(BASE_GNERR_PKG_ID+0x12)
#define	GNPKG_PLDBEngine				(BASE_GNERR_PKG_ID+0x13)
#define GNPKG_PLMEngine					(BASE_GNERR_PKG_ID+0x14)
#define GNPKG_Compression				(BASE_GNERR_PKG_ID+0x15)
#define GNPKG_Checksum					(BASE_GNERR_PKG_ID+0x16)
#define GNPKG_GCSP						(BASE_GNERR_PKG_ID+0x17)
#define GNPKG_MusicID					(BASE_GNERR_PKG_ID+0x18)
#define GNPKG_Lists						(BASE_GNERR_PKG_ID+0x19)
#define GNPKG_LINK						(BASE_GNERR_PKG_ID+0x1A)
#define GNPKG_StrConv					(BASE_GNERR_PKG_ID+0x1B)
#define GNPKG_FAPI						(BASE_GNERR_PKG_ID+0x1D)
#define GNPKG_TextID					(BASE_GNERR_PKG_ID+0x1E)
#define GNPKG_DataEncode				(BASE_GNERR_PKG_ID+0x1F)
#define GNPKG_Content					(BASE_GNERR_PKG_ID+0x20)
#define	GNPKG_Random					(BASE_GNERR_PKG_ID+0x21)
#define	GNPKG_Encode					(BASE_GNERR_PKG_ID+0x22)
#define GNPKG_DataAccess				(BASE_GNERR_PKG_ID+0x23)
#define GNPKG_AltPhrase					(BASE_GNERR_PKG_ID+0x24)
#define GNPKG_Transcript				(BASE_GNERR_PKG_ID+0x25)
#define GNPKG_CoverArt					(BASE_GNERR_PKG_ID+0x26)
#define GNPKG_LookupCache				(BASE_GNERR_PKG_ID+0x27)
#define GNPKG_UniversalHeader           (BASE_GNERR_PKG_ID+0x28)
#define GNPKG_Validation				(BASE_GNERR_PKG_ID+0x29)
#define GNPKG_OnDemandLookups			(BASE_GNERR_PKG_ID+0x30)
#define GNPKG_Online					(BASE_GNERR_PKG_ID+0x31)
#define GNPKG_Util						(BASE_GNERR_PKG_ID+0x32)
#define GNPKG_Cantametrix				(BASE_GNERR_PKG_ID+0x33)
#define GNPKG_FPX						(BASE_GNERR_PKG_ID+0x34)
#define GNPKG_Manifest					(BASE_GNERR_PKG_ID+0x35)
#define GNPKG_TextCorr					(BASE_GNERR_PKG_ID+0x36)
#define GNPKG_Installer					(BASE_GNERR_PKG_ID+0x37)
#define GNPKG_PB						(BASE_GNERR_PKG_ID+0x38)
#define GNPKG_DBHeader					(BASE_GNERR_PKG_ID+0x39)
#define GNPKG_Cache						(BASE_GNERR_PKG_ID+0x3A)
#define GNPKG_PhonemeConversion			(BASE_GNERR_PKG_ID+0x3B)
#define	MAX_GNERR_PKG_ID				(BASE_GNERR_PKG_ID+0x3B)


/* Error Codes */
/*
 * Codes are grouped by the package that usually (if not exclusively)
 * returns the code. For example, GNERR_MemLeak is grouped with the
 * Abstraction Layer codes.
 * Values for each group of error codes begin with a multiple of 0x40.
 * This allows for numbering consistency when defining new codes within
 * a group. Note that this scheme is motivated by aesthetic (not functional)
 * reasons; error code origination is determined by the package id field
 * of the error value, not by the value of the error code field.
 */

/* General Errors */
#define	GNERR_NoError					(BASE_GNERR_CODE)
#define	GNERR_NotFound					(BASE_GNERR_CODE+0x0002)	/* Item not found */
#define	GNERR_OVERFLOW					(BASE_GNERR_CODE+0x0007)	/* Result too large */
#define	GNERR_Unknown					(BASE_GNERR_CODE+0x0008)	/* Unknown Parameter */
#define	GNERR_IckyError					(BASE_GNERR_CODE+0x0009)	/* Really, really bad error which can't be fathomed */
#define	GNERR_BufferTooSmall			(BASE_GNERR_CODE+0x000A)	/* Input buffer is too small for available data */
#define	GNERR_InvalidFormat				(BASE_GNERR_CODE+0x000B)	/* Invalid format in file or data structure */
#define	GNERR_InitFailed				(BASE_GNERR_CODE+0x000C)
#define	GNERR_UnknownChecksumAlg		(BASE_GNERR_CODE+0x000D)
#define	GNERR_ChecksumMismatch			(BASE_GNERR_CODE+0x000E)
#define	GNERR_UnsupportedFunctionality	(BASE_GNERR_CODE+0x000F)
#define	GNERR_UnsupportedOption			(BASE_GNERR_CODE+0x0010)
#define GNERR_ArrayOverflow				(BASE_GNERR_CODE+0x0011)	/* Attempt to read or write past end of array. */
#define GNERR_DatabaseRevisionError		(BASE_GNERR_CODE+0x0012)
#define GNERR_OperationCanceled			(BASE_GNERR_CODE+0x0013)	/* User requested cancelation of current operation */
#define GNERR_NoEntitlement				(BASE_GNERR_CODE+0x0014)	/* Access entitled data */
#define GNERR_InvalidFeatureConfig		(BASE_GNERR_CODE+0x0015)
#define GNERR_InvalidEntitlementKey		(BASE_GNERR_CODE+0x0016)

/* Local Data Cache */
#define	GNERR_CacheDataError			(BASE_GNERR_CODE+0x0081)
#define	GNERR_CacheInitedForLookups		(BASE_GNERR_CODE+0x0082)
#define	GNERR_CacheInitedForUpdates		(BASE_GNERR_CODE+0x0083)
#define	GNERR_NoCache					(BASE_GNERR_CODE+0x0084)


/* Crytographic Subsystem */
#define	GNERR_UnsupportedAlg			(BASE_GNERR_CODE+0x0161)
#define	GNERR_InvalidKeyAreaSize		(BASE_GNERR_CODE+0x0162)

/* Embedded Database Integrity Management */
#define	GNERR_CorruptData				(BASE_GNERR_CODE+0x0201)
#define	GNERR_InvalidData				(BASE_GNERR_CODE+0x0202)
#define	GNERR_LostBackup				(BASE_GNERR_CODE+0x0203)
#define	GNERR_NoLiveUpdateDB			(BASE_GNERR_CODE+0x0205)
#define	GNERR_NoBackupUpdateDB			(BASE_GNERR_CODE+0x0206)
#define	GNERR_NoUpdateDB				(BASE_GNERR_CODE+0x0207)
#define	GNERR_BadUpdateDB				(BASE_GNERR_CODE+0x0208)
#define	GNERR_BackupOutOfSync			(BASE_GNERR_CODE+0x0209)
#define	GNERR_CoreDBError				(BASE_GNERR_CODE+0x020A)
#define	GNERR_LiveUpdateDBError			(BASE_GNERR_CODE+0x020B)
#define	GNERR_BackupUpdateDBError		(BASE_GNERR_CODE+0x020C)
#define	GNERR_UpdateDBError				(BASE_GNERR_CODE+0x020D)
#define	GNERR_NoLiveCache				(BASE_GNERR_CODE+0x020E)
#define	GNERR_NoBackupCache				(BASE_GNERR_CODE+0x020F)
#define	GNERR_LiveCacheError			(BASE_GNERR_CODE+0x0210)
#define	GNERR_BackupCacheError			(BASE_GNERR_CODE+0x0211)
#define	GNERR_CacheError				(BASE_GNERR_CODE+0x0212)
#define	GNERR_LiveUpdateCRCError		(BASE_GNERR_CODE+0x0213)
#define	GNERR_BackupUpdateCRCError		(BASE_GNERR_CODE+0x0214)
#define	GNERR_LiveCacheCRCError			(BASE_GNERR_CODE+0x0215)
#define	GNERR_BackupCacheCRCError		(BASE_GNERR_CODE+0x0216)
#define	GNERR_NotInitializedForUpdates	(BASE_GNERR_CODE+0x0217)
#define	GNERR_InvalidDataFormatVersion	(BASE_GNERR_CODE+0x0218)
#define	GNERR_CodeDataMismatch			(BASE_GNERR_CODE+0x0219)
#define	GNERR_InvalidUniversalDataFormat	(BASE_GNERR_CODE+0x021A)
#define	GNERR_NoDB						(BASE_GNERR_CODE+0x021B)
#define	GNERR_PartialDB					(BASE_GNERR_CODE+0x021C)
#define GNERR_NoLiveDB					(BASE_GNERR_CODE+0x021C)
#define GNERR_IllegalEndian				(BASE_GNERR_CODE+0x021D)
#define GNERR_IncompleteImplementation  (BASE_GNERR_CODE+0x021E)
#define GNERR_UninitializedTable		(BASE_GNERR_CODE+0x021F)
#define GNERR_InvalidInstallProfile		(BASE_GNERR_CODE+0x0221)
#define GNERR_MultipleBaseDBTables		(BASE_GNERR_CODE+0x0222)
#define GNERR_MultipleUpdDBTables		(BASE_GNERR_CODE+0x0223)
#define GNERR_MissingBaseDBTable		(BASE_GNERR_CODE+0x0224)
#define GNERR_MissingUpdDBTable			(BASE_GNERR_CODE+0x0225)
#define GNERR_BaseUpdFileTypeMismatch	(BASE_GNERR_CODE+0x0226)
#define GNERR_MaxFileNameSize			(BASE_GNERR_CODE+0x0227)
#define GNERR_MissingFilename			(BASE_GNERR_CODE+0x0228)
#define GNERR_FilesAlreadyOpen			(BASE_GNERR_CODE+0x0229)
#define GNERR_UnknownCollection			(BASE_GNERR_CODE+0x0230)
#define GNERR_RevertMissingBackup		(BASE_GNERR_CODE+0x0231)
#define GNERR_UnknownUniversalHeaderErr	(BASE_GNERR_CODE+0x0232)
#define GNERR_IncorrectFileType			(BASE_GNERR_CODE+0x0233)
#define GNERR_UpdateLevelCountTooHigh	(BASE_GNERR_CODE+0x0234)
#define GNERR_InvalidUniversalHdrMagic	(BASE_GNERR_CODE+0x0235)
#define GNERR_InvalidConfigXMLFile		(BASE_GNERR_CODE+0x0236)
#define GNERR_CollectionConfigSynchErr	(BASE_GNERR_CODE+0x0237)
#define GNERR_FileTableNotFlatOrIndex	(BASE_GNERR_CODE+0x0238)
#define GNERR_MaxCollectionID			(BASE_GNERR_CODE+0x0239)
#define GNERR_MLDBFilesExist		    (BASE_GNERR_CODE+0x023A)
#define GNERR_BadTimestampFormat		(BASE_GNERR_CODE+0x023B)

/* 7 TOC Lookup Package */
#define	GNERR_InvalidTOC				(BASE_GNERR_CODE+0x0241)
#define	GNERR_IDNotFound				(BASE_GNERR_CODE+0x0242)
#define	GNERR_BadResultFormat			(BASE_GNERR_CODE+0x0243)
#define	GNERR_Missing_Client_ID			(BASE_GNERR_CODE+0x0244)
#define	GNERR_Missing_User_ID			(BASE_GNERR_CODE+0x0246)

/* Data Translator */
#define	GNERR_BadXMLFormat				(BASE_GNERR_CODE+0x0281)

/* Updater Subsystem */
#define	GNERR_IncompleteUpdate			(BASE_GNERR_CODE+0x0321)
#define	GNERR_UpdateLevelMismatch		(BASE_GNERR_CODE+0x0322)
#define GNERR_UpdFileBaseDBRevision		(BASE_GNERR_CODE+0x0323)
#define GNERR_UpdateFileType			(BASE_GNERR_CODE+0x0324)

/* Micro XML Package */
#define	GNERR_XMLSyntaxError			(BASE_GNERR_CODE+0x0361)
#define	GNERR_IllegalXMLCharacter		(BASE_GNERR_CODE+0x0362)
#define	GNERR_XMLUnexpectedEndOfInput	(BASE_GNERR_CODE+0x0363)

/* Database Engine */
#define	GNERR_NestedCall				(BASE_GNERR_CODE+0x0401)
#define	GNERR_PermissionError			(BASE_GNERR_CODE+0x0402)
#define	GNERR_ReadErr					(BASE_GNERR_CODE+0x0403)
#define	GNERR_WriteErr					(BASE_GNERR_CODE+0x0404)
#define	GNERR_UnknownVersion			(BASE_GNERR_CODE+0x0405)
#define	GNERR_InvalidFile				(BASE_GNERR_CODE+0x0406)
#define	GNERR_AlreadyAdded				(BASE_GNERR_CODE+0x0407)
#define	GNERR_InvalidBlock				(BASE_GNERR_CODE+0x0408)
#define	GNERR_Aborted					(BASE_GNERR_CODE+0x0409)
#define	GNERR_NoSpace					(BASE_GNERR_CODE+0x040A)
#define	GNERR_BadIndex					(BASE_GNERR_CODE+0x040B)
#define	GNERR_BadFreeList				(BASE_GNERR_CODE+0x040C)
#define	GNERR_BadRecord					(BASE_GNERR_CODE+0x040D)
#define	GNERR_BadBlock					(BASE_GNERR_CODE+0x040E)
#define	GNERR_IndexPastEOF				(BASE_GNERR_CODE+0x040F)
#define	GNERR_RecordPastEOF				(BASE_GNERR_CODE+0x0410)
#define	GNERR_IndexInFreeList			(BASE_GNERR_CODE+0x0411)
#define	GNERR_RecordInFreeList			(BASE_GNERR_CODE+0x0412)
#define	GNERR_BlockInFreeList			(BASE_GNERR_CODE+0x0413)
#define	GNERR_IncompatibleDBs			(BASE_GNERR_CODE+0x0414)
#define	GNERR_KeyNotRead				(BASE_GNERR_CODE+0x0415)
#define	GNERR_InvalidByteOrder			(BASE_GNERR_CODE+0x0416)
#define GNERR_UnknownFSError			(BASE_GNERR_CODE+0x0417)
#define	GNERR_InvalidIterator			(BASE_GNERR_CODE+0x0418)
#define	GNERR_BadHeader					(BASE_GNERR_CODE+0x0419)
#define	GNERR_CriticalSection			(BASE_GNERR_CODE+0x041A)
#define	GNERR_ThreadError				(BASE_GNERR_CODE+0x041B)
#define	GNERR_ReadLocked				(BASE_GNERR_CODE+0x041C)
#define	GNERR_WriteLocked				(BASE_GNERR_CODE+0x041D)

/* Embedded Database Interface */
#define	GNERR_DataError					(BASE_GNERR_CODE+0x0441)
#define	GNERR_Decrypt					(BASE_GNERR_CODE+0x0442)
#define	GNERR_DecryptFmt				(BASE_GNERR_CODE+0x0443)
#define	GNERR_UnComp					(BASE_GNERR_CODE+0x0444)
#define	GNERR_UnCompFmt					(BASE_GNERR_CODE+0x0445)
#define	GNERR_InitedForLookups			(BASE_GNERR_CODE+0x0446)
#define	GNERR_InitedForUpdates			(BASE_GNERR_CODE+0x0447)
#define	GNERR_ErrorWritingData			(BASE_GNERR_CODE+0x0448)
#define	GNERR_ErrorWritingIndex			(BASE_GNERR_CODE+0x0449)
#define	GNERR_NoRecordActive			(BASE_GNERR_CODE+0x044A)
#define GNERR_NullHandleFromOpen		(BASE_GNERR_CODE+0x044B)
#define GNERR_ListModelNotSet			(BASE_GNERR_CODE+0x044C)

/* Online Protocol */
#define	GNERR_NotRegistered				(BASE_GNERR_CODE+0x0481)
#define	GNERR_WrongServerPublicKey		(BASE_GNERR_CODE+0x0482)
#define	GNERR_UnknownCompression		(BASE_GNERR_CODE+0x0483)
#define	GNERR_UnknownEncryption			(BASE_GNERR_CODE+0x0484)
#define	GNERR_UnknownEncoding			(BASE_GNERR_CODE+0x0485)
#define	GNERR_NotCDDBMSG				(BASE_GNERR_CODE+0x0486)
#define	GNERR_NoPROTOCOLElement			(BASE_GNERR_CODE+0x0487)
#define	GNERR_NoSTATUSElement			(BASE_GNERR_CODE+0x0488)
#define	GNERR_NoDATAElement				(BASE_GNERR_CODE+0x0489)
#define	GNERR_NoDataContents			(BASE_GNERR_CODE+0x048A)
#define	GNERR_NoENCODINGElement			(BASE_GNERR_CODE+0x048B)
#define	GNERR_NoENCRYPTIONElement		(BASE_GNERR_CODE+0x048C)
#define	GNERR_NoCOMPRESSIONElement		(BASE_GNERR_CODE+0x048D)
#define	GNERR_NotRESULTS				(BASE_GNERR_CODE+0x048E)
#define	GNERR_RESULTNotFound			(BASE_GNERR_CODE+0x048F)
#define	GNERR_Base64Decode				(BASE_GNERR_CODE+0x0490)
#define	GNERR_Base64Encode				(BASE_GNERR_CODE+0x0491)
#define	GNERR_ZipCompress				(BASE_GNERR_CODE+0x0492)
#define	GNERR_ZipUncompress				(BASE_GNERR_CODE+0x0493)
#define	GNERR_WrongEncryptionStep		(BASE_GNERR_CODE+0x0494)
#define	GNERR_MissingCLNTKEY			(BASE_GNERR_CODE+0x0495)
#define	GNERR_MissingSRVRKEY			(BASE_GNERR_CODE+0x0496)
#define	GNERR_MissingKeyAlgorithm		(BASE_GNERR_CODE+0x0497)
#define	GNERR_UnknownKeyAlgorithm		(BASE_GNERR_CODE+0x0498)
#define	GNERR_WrongClientPublicKey		(BASE_GNERR_CODE+0x0499)
#define	GNERR_MissingKeyValue			(BASE_GNERR_CODE+0x049A)
#define	GNERR_NoServerResponse			(BASE_GNERR_CODE+0x049B)
#define	GNERR_BadRegResultFormat		(BASE_GNERR_CODE+0x049C)
#define	GNERR_KeyTooLarge				(BASE_GNERR_CODE+0x049D)
#define	GNERR_MissingSTATUSCODE			(BASE_GNERR_CODE+0x049F)
#define	GNERR_ServerError				(BASE_GNERR_CODE+0x04A0)
#define	GNERR_NotRESULT					(BASE_GNERR_CODE+0x04A1)
#define	GNERR_MissingRESULTCODE			(BASE_GNERR_CODE+0x04A2)
#define	GNERR_NoTransaction				(BASE_GNERR_CODE+0x04A3)
#define	GNERR_CRCError					(BASE_GNERR_CODE+0x04A4)
#define GNERR_ServerChecksumMismatch	(BASE_GNERR_CODE+0x04A5)
#define GNERR_ServerEncryptionError		(BASE_GNERR_CODE+0x04A6)
#define GNERR_ServerDecryptionError		(BASE_GNERR_CODE+0x04A7)
#define GNERR_ServerMalformedInput		(BASE_GNERR_CODE+0x04A8)
#define GNERR_ServerConcurrencyNotInitialized	(BASE_GNERR_CODE+0x04A9)
#define GNERR_ServerUnsupportedCommand	(BASE_GNERR_CODE+0x04AA)
#define GNERR_ServerDVDLookupError		(BASE_GNERR_CODE+0x04AB)
#define GNERR_ServerArgumentOutOfRange	(BASE_GNERR_CODE+0x04AC)
#define GNERR_ServerCDDBServerNotFound	(BASE_GNERR_CODE+0x04AD)
#define GNERR_ServerSocketCreateFailed	(BASE_GNERR_CODE+0x04AE)
#define GNERR_ServerCDDBServerResponseGarbled	(BASE_GNERR_CODE+0x04AF)
#define GNERR_ServerCDDBServerTimeout	(BASE_GNERR_CODE+0x04B0)
#define GNERR_ServerCDDBHTTPError		(BASE_GNERR_CODE+0x04B1)
#define GNERR_ServerCDDBServiceError	(BASE_GNERR_CODE+0x04B2)
#define GNERR_ServerCDDBServiceInvalidField	(BASE_GNERR_CODE+0x04B3)
#define GNERR_ServerCDDBQueryLimitReached	(BASE_GNERR_CODE+0x04B4)
#define GNERR_ServerInvalidArgument		(BASE_GNERR_CODE+0x04B5)
#define GNERR_InvalidRegFile			(BASE_GNERR_CODE+0x04B6)
#define GNERR_NoRegistrationFile		(BASE_GNERR_CODE+0x04B7)
#define GNERR_InvalidRegistration		(BASE_GNERR_CODE+0x04B8)
#define GNERR_ClientIDNotSet			(BASE_GNERR_CODE+0x04B9)
#define GNERR_ClientIDTagNotSet			(BASE_GNERR_CODE+0x04BA)
#define GNERR_BadRangeSpec				(BASE_GNERR_CODE+0x04BB)


/* Playlist Embedded Database */
#define GNERR_InvalidKey				(BASE_GNERR_CODE+0x0501)
#define GNERR_NoMatch					(BASE_GNERR_CODE+0x0502)
#define GNERR_CollectionNotOpened		(BASE_GNERR_CODE+0x0503)

/* GCSP */
#define GNERR_ExpiredKey				(BASE_GNERR_CODE+0x0541)
#define GNERR_CorruptEncryptData		(BASE_GNERR_CODE+0x0542)
#define GNERR_CorruptCompressData		(BASE_GNERR_CODE+0x0543)
#define	GNERR_RequestError				(BASE_GNERR_CODE+0x0544)
#define	GNERR_CommandError				(BASE_GNERR_CODE+0x0545)
#define	GNERR_NoRegistration			(BASE_GNERR_CODE+0x0546)
#define	GNERR_QuotaExceeded				(BASE_GNERR_CODE+0x0547)
#define	GNERR_ClientCompression			(BASE_GNERR_CODE+0x0548)
#define	GNERR_ClientEncryption			(BASE_GNERR_CODE+0x0549)
#define	GNERR_GEMPError					(BASE_GNERR_CODE+0x054A)
#define	GNERR_InvalidRequestCommand		(BASE_GNERR_CODE+0x054B)
#define	GNERR_MissingRequestCmdField	(BASE_GNERR_CODE+0x054C)
#define	GNERR_InvalidRequestCmdArg		(BASE_GNERR_CODE+0x054D)
#define	GNERR_RequestCmdServerError		(BASE_GNERR_CODE+0x054E)
#define	GNERR_RequestCmdClientError		(BASE_GNERR_CODE+0x054F)
#define	GNERR_RequestCmdNoReg			(BASE_GNERR_CODE+0x0550)
#define	GNERR_RequestCmdAlreadyReg		(BASE_GNERR_CODE+0x0551)
#define	GNERR_BadRequest				(BASE_GNERR_CODE+0x0552)
#define	GNERR_BadReqClient				(BASE_GNERR_CODE+0x0553)
#define	GNERR_BadReqServer				(BASE_GNERR_CODE+0x0554)
#define	GNERR_BadReqInvalidArg			(BASE_GNERR_CODE+0x0555)
#define GNERR_InvalidUser				(BASE_GNERR_CODE+0x0556)
#define GNERR_InvalidClient				(BASE_GNERR_CODE+0x0557)
#define GNERR_MissingField				(BASE_GNERR_CODE+0x0558)
#define GNERR_InvalidArgument			(BASE_GNERR_CODE+0x0559)
#define GNERR_InvalidRegKey				(BASE_GNERR_CODE+0x055A)
#define GNERR_EmptyResponse				(BASE_GNERR_CODE+0x055B)
#define	GNERR_Missing_Client_ID_Tag		(BASE_GNERR_CODE+0x055C)
#define	GNERR_Missing_User_ID_Tag		(BASE_GNERR_CODE+0x055D)


/* Compression */
#define	GNERR_UnknownCompressionType	(BASE_GNERR_CODE+0x05C1)

/* MusicID */
#define GNERR_NotReady					(BASE_GNERR_CODE+0x0601)
#define GNERR_NothingToDo				(BASE_GNERR_CODE+0x0602)
#define GNERR_ColumnHasNoZones			(BASE_GNERR_CODE+0x0603)
#define GNERR_EndOfSearch				(BASE_GNERR_CODE+0x0604)
#define GNERR_IllegalFingerprint		(BASE_GNERR_CODE+0x0605)
#define GNERR_UnsupportedFPAlg			(BASE_GNERR_CODE+0x0606)
#define GNERR_MissingClassicalData		(BASE_GNERR_CODE+0x0607)

/* Lists */
#define GNERR_InvalidListFile			(BASE_GNERR_CODE+0x0701)
#define GNERR_Unavailable				(BASE_GNERR_CODE+0x0702)
#define GNERR_BadCategoryLevel			(BASE_GNERR_CODE+0x0703)
#define GNERR_BadDispHierType			(BASE_GNERR_CODE+0x0704)

/* Unicode String Conversion */
#define GNERR_ERange					(BASE_GNERR_CODE+0x0801)
#define GNERR_InvalidCharacter			(BASE_GNERR_CODE+0x0802)
#define GNERR_NoBOM						(BASE_GNERR_CODE+0x0803)

/* Text ID */
#define GNERR_TextidResultNotAvailable	(BASE_GNERR_CODE+0x0841)
#define GNERR_TextidResultOutOfRange	(BASE_GNERR_CODE+0x0842)
#define GNERR_UnknownMatchType			(BASE_GNERR_CODE+0x0843)
#define GNERR_UnknownLookupOption		(BASE_GNERR_CODE+0x0844)
#define GNERR_ExactLookupFailed			(BASE_GNERR_CODE+0x0845)
#define GNERR_InternalError				(BASE_GNERR_CODE+0x0846)
#define GNERR_InconsistentState			(BASE_GNERR_CODE+0x0847)
#define GNERR_InvalidTextidFile			(BASE_GNERR_CODE+0x0848)
#define GNERR_InvalidContributorInfo	(BASE_GNERR_CODE+0x0849)
#define GNERR_InvalidStateSetup			(BASE_GNERR_CODE+0x084A)
#define GNERR_MediavocsDataPresent		(BASE_GNERR_CODE+0x084B)
#define GNERR_InvalidUpdateFileRecordVersion (BASE_GNERR_CODE+0x084C)
#define GNERR_InvalidUpdateFileRecord	(BASE_GNERR_CODE+0x084D)
#define GNERR_UnknownFileSystemError	(BASE_GNERR_CODE+0x084E)
#define GNERR_InvalidTextDBRecord		(BASE_GNERR_CODE+0x084F)
#define GNERR_NoTextDBData				(BASE_GNERR_CODE+0X0850)
#define	GNERR_MGRInvalidHandle			(BASE_GNERR_CODE+0X0851)
#define	GNERR_MGRHandleHasNoOpenDBs		(BASE_GNERR_CODE+0X0852)
#define GNERR_BadMatchSource            (BASE_GNERR_CODE+0X0853)
#define GNERR_BadAlbumV1Genre           (BASE_GNERR_CODE+0X0854)
#define GNERR_InvalidAlbumInfo			(BASE_GNERR_CODE+0X0855)
#define GNERR_InvalidRecordType			(BASE_GNERR_CODE+0X0856)
#define GNERR_MinimizedFileHandles		(BASE_GNERR_CODE+0X0857)
#define GNERR_IDFetchNotFound           (BASE_GNERR_CODE+0X0858)
#define GNERR_BadResultIDValue			(BASE_GNERR_CODE+0X0859)

/* Transcript */
#define GNERR_BadConfigurationData		(BASE_GNERR_CODE+0x0861)
#define GNERR_InvalidSpokenLanguageID	(BASE_GNERR_CODE+0x0862)
#define GNERR_UnknownPhonemeMapFileVersion		(BASE_GNERR_CODE+0x0863)
#define GNERR_UnrecognizedPhonemeMapFileFlag	(BASE_GNERR_CODE+0x0864)
#define GNERR_NoTargetLangaugesInPhonemeMapFile  (BASE_GNERR_CODE+0x0865)
#define GNERR_MissingPhonemeMapData					(BASE_GNERR_CODE+0x0866)
#define GNERR_InvalidUnencryptedSizeForMap (BASE_GNERR_CODE+0x0867)

/* Lookup Cache */
#define GNERR_IncompleteRecord			(BASE_GNERR_CODE+0x0880)
#define GNERR_LookupNotReady			(BASE_GNERR_CODE+0x0881)
#define GNERR_LookupNoMatch				(BASE_GNERR_CODE+0x0882)

/* Database validation errors. */
#define GNERR_InvalidDatabase			(BASE_GNERR_CODE+0x0890)
#define GNERR_InvalidActionBaseRpl		(BASE_GNERR_CODE+0x0891)
#define GNERR_FileNameNotSet            (BASE_GNERR_CODE+0x0892)

/* Online subsystem errors. */
#define GNERR_InvalidMetadataLanguageID	(BASE_GNERR_CODE+0x0901)
#define GNERR_MatchResolutionFailed		(BASE_GNERR_CODE+0x0902)

/* APM (Alt Phrase) errors */
#define GNERR_NoOfficialRepresentation	(BASE_GNERR_CODE+0x0920)

#define GNERR_ContentNeedsLookup				(BASE_GNERR_CODE+0x0930)
#define GNERR_ContentNeedsResolution			(BASE_GNERR_CODE+0x0931)
#define GNERR_ContentUnsupportedContentType		(BASE_GNERR_CODE+0x0932)

/* Utility Library */
#define GNERR_InvalidArrayObject		(BASE_GNERR_CODE+0x0950)
#define GNERR_InvalidArrayIndex			(BASE_GNERR_CODE+0x0951)
#define GNERR_CallbackValue				(BASE_GNERR_CODE+0x0952)
#define GNERR_KeyExists					(BASE_GNERR_CODE+0x0953)
#define GNERR_TooManyDigits				(BASE_GNERR_CODE+0x0954)
#define GNERR_NotNumeric				(BASE_GNERR_CODE+0x0955)

/* Fingerprint Library */
#define GNERR_FingerprintAcquired		(BASE_GNERR_CODE+0x0960)
#define GNERR_FingerprintNotAcquired	(BASE_GNERR_CODE+0x0961)

/* LDAC */
#define GNERR_LDACKeyNotSet				(BASE_GNERR_CODE+0x0980)
#define GNERR_LDACKeyUnsupportedVersion	(BASE_GNERR_CODE+0x0981)
#define GNERR_LDACKeyMagicNumber		(BASE_GNERR_CODE+0x0982)
#define GNERR_LDACKeyPayloadLength		(BASE_GNERR_CODE+0x0983)
#define GNERR_LDACKeyInvalidFormat		(BASE_GNERR_CODE+0x0984)

/* Initialize */
#define GNERR_ConfigNull				(BASE_GNERR_CODE+0x0990)
#define GNERR_BadListFile				(BASE_GNERR_CODE+0x0991)

/* Installer */
#define GNERR_LFSNotFound				(BASE_GNERR_CODE+0x09A0)
#define GNERR_ProductNotFound			(BASE_GNERR_CODE+0x09A1)
#define GNERR_ManifestNotFound			(BASE_GNERR_CODE+0x09A2)
#define GNERR_BadInitState				(BASE_GNERR_CODE+0x09A3)
#define GNERR_BadInstallPath			(BASE_GNERR_CODE+0x09A4)
#define GNERR_BaseDataNotFound			(BASE_GNERR_CODE+0x09A5)
#define GNERR_BaseIndexNotFound			(BASE_GNERR_CODE+0x09A6)
#define GNERR_PCXNotFound				(BASE_GNERR_CODE+0x09A7)
#define GNERR_ListsNotFound				(BASE_GNERR_CODE+0x09A8)
#define GNERR_CorrelatesNotFound		(BASE_GNERR_CODE+0x09A9)
#define GNERR_CoverArtBaseDataNotFound	(BASE_GNERR_CODE+0x09B0)
#define GNERR_CoverArtBaseIndexNotFound	(BASE_GNERR_CODE+0x09B1)
#define GNERR_InventoryFileNotFound		(BASE_GNERR_CODE+0x09B2)
#define GNERR_PDLPresetsNotFound		(BASE_GNERR_CODE+0x09B3)
#define GNERR_ContribTblNotFound		(BASE_GNERR_CODE+0x09B4)
#define GNERR_GenreTblNotFound			(BASE_GNERR_CODE+0x09B5)
#define GNERR_AlbumTblNotFound			(BASE_GNERR_CODE+0x09B6)
#define GNERR_GenreArtBaseDataNotFound	(BASE_GNERR_CODE+0x09B7)
#define GNERR_GenreArtBaseIndexNotFound	(BASE_GNERR_CODE+0x09B8)
#define GNERR_FPX_NotFound				(BASE_GNERR_CODE+0x09B9)
/* Updates Specific Missing File Errors */
#define GNERR_AudioWorkRecordsNotFound	(BASE_GNERR_CODE+0x09BA)

/* PB */
#define GNERR_InvalidMessageFormat		(BASE_GNERR_CODE+0x09C0)
#define GNERR_InvalidType				(BASE_GNERR_CODE+0x09C1)
#define GNERR_InvalidWireType			(BASE_GNERR_CODE+0x09C2)
#define GNERR_InvalidInt				(BASE_GNERR_CODE+0x09C3)
#define GNERR_InvalidMember				(BASE_GNERR_CODE+0x09C4)
#define GNERR_DataTooShort				(BASE_GNERR_CODE+0x09C5)
#define GNERR_UnterminatedVarInt		(BASE_GNERR_CODE+0x09C6)
#define GNERR_ParsingError				(BASE_GNERR_CODE+0x09C7)

/* Data Encode */
#define GNERR_IncorrectBufferType		(BASE_GNERR_CODE+0x1001)

/* ODL */
#define GNERR_ObjectDataMissing			(BASE_GNERR_CODE+0x09D0)

/* Phonetic Conversion */
#define GNERR_InvalidPhonemeFile		(BASE_GNERR_CODE+0x09E0)
#define GNERR_InvalidConversionFile		(BASE_GNERR_CODE+0x09E1)
#define GNERR_InvalidConversion			(BASE_GNERR_CODE+0x09E2)
#define GNERR_MapNotFound				(BASE_GNERR_CODE+0x09E3)
#define GNERR_GroupNotFound				(BASE_GNERR_CODE+0x09E4)
#define GNERR_InvalidAlgID				(BASE_GNERR_CODE+0x09E5)
#define GNERR_ValidationFailed			(BASE_GNERR_CODE+0x09E6)

#ifdef __cplusplus
}
#endif

#endif /* _GN_ERROR_CODES_H_ */
