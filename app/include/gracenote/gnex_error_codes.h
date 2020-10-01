/*
* Copyright (c) 2007 Gracenote.
*
* This software may not be used in any way or distributed without
* permission. All rights reserved.
*
* Some code herein may be covered by US and international patents.
*/

/*
* gnex_error_codes.h - Package code definitions and string access.
*/

/*
 * Note: all values are expressed in hexadecimal form.
 */

/* To do - once c files are branched over, take a survey of what error         */
/* values can be deleted.                                                      */



#ifndef	_GNEX_ERROR_CODES_H_
#define _GNEX_ERROR_CODES_H_

/*
* Dependencies
*/

#include "gn_defines.h"


#ifdef __cplusplus
extern "C"{
#endif


/*
* Constants
*/

/* Package/library identifiers. */
#define GNEX_BASE_GNERR_PKG_ID				0

/* Generic Error Code package */
#define GNEX_GNPKG_Generic					(GNEX_BASE_GNERR_PKG_ID+0x00)
/* GN EPAL Error codes */
#define GNEX_GNPKG_EPAL_GENERAL				(GNEX_BASE_GNERR_PKG_ID+0x01)
#define GNEX_GNPKG_EPAL_FileSystem			(GNEX_BASE_GNERR_PKG_ID+0x02)
                                    
/* Packages outside of GN EPAL */
#define GNEX_GNPKG_ID3						(GNEX_BASE_GNERR_PKG_ID+0x03)
#define GNEX_GNPKG_GNWAV					(GNEX_BASE_GNERR_PKG_ID+0x04)
#define GNEX_GNPKG_PHOCVRT					(GNEX_BASE_GNERR_PKG_ID+0x05)
#define	GNEX_MAX_GNERR_PKG_ID				(GNEX_BASE_GNERR_PKG_ID+0x06)


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

#define	GNEX_BASE_GNERR_CODE					0

/* General Errors - included here for convenience */
#define	GNEX_GEN_CODE_NoError					0
#define	GNEX_GEN_CODE_NoMemory					(GNEX_BASE_GNERR_CODE+0x0001)	/* Memory allocation failure */
#define	GNEX_GEN_CODE_NotFound					(GNEX_BASE_GNERR_CODE+0x0002)	/* Item not found */
#define	GNEX_GEN_CODE_IOError					(GNEX_BASE_GNERR_CODE+0x0003)	/* Error reading or writing */
#define	GNEX_GEN_CODE_InvalidArg				(GNEX_BASE_GNERR_CODE+0x0004)	/* Invalid argument */
#define	GNEX_GEN_CODE_Busy						(GNEX_BASE_GNERR_CODE+0x0005)	/* System is busy */
#define	GNEX_GEN_CODE_NotInited					(GNEX_BASE_GNERR_CODE+0x0006)	/* System not initialized */
#define	GNEX_GEN_CODE_OVERFLOW					(GNEX_BASE_GNERR_CODE+0x0007)	/* Result too large */
#define	GNEX_GEN_CODE_Unknown					(GNEX_BASE_GNERR_CODE+0x0008)	/* Unknown Parameter */
#define	GNEX_GEN_CODE_IckyError					(GNEX_BASE_GNERR_CODE+0x0009)	/* Really, really bad error which can't be fathomed */
#define	GNEX_GEN_CODE_BufferTooSmall			(GNEX_BASE_GNERR_CODE+0x000A)	/* Input buffer is too small for available data */
#define	GNEX_GEN_CODE_InvalidFormat				(GNEX_BASE_GNERR_CODE+0x000B)	/* Invalid format in file or data structure */
#define	GNEX_GEN_CODE_InitFailed				(GNEX_BASE_GNERR_CODE+0x000C)
#define	GNEX_GEN_CODE_UnknownChecksumAlg		(GNEX_BASE_GNERR_CODE+0x000D)
#define	GNEX_GEN_CODE_ChecksumMismatch			(GNEX_BASE_GNERR_CODE+0x000E)
#define	GNEX_GEN_CODE_UnsupportedFunctionality	(GNEX_BASE_GNERR_CODE+0x000F)
#define	GNEX_GEN_CODE_UnsupportedOption			(GNEX_BASE_GNERR_CODE+0x0010)
#define GNEX_GEN_CODE_ArrayOverflow				(GNEX_BASE_GNERR_CODE+0x0011)	/* Attempt to read or write past end of array. */
#define GNEX_GEN_CODE_DatabaseRevisionError		(GNEX_BASE_GNERR_CODE+0x0012)
                                            
/* EPAL */
#define	GNEX_EPAL_CODE_FileInvalidAccess		(GNEX_BASE_GNERR_CODE+0x0037)
#define	GNEX_EPAL_CODE_FileNotFound				(GNEX_BASE_GNERR_CODE+0x0038)
#define	GNEX_EPAL_CODE_FileExists				(GNEX_BASE_GNERR_CODE+0x0039)
#define	GNEX_EPAL_CODE_FileNoSpace				(GNEX_BASE_GNERR_CODE+0x003A)
#define	GNEX_EPAL_CODE_FileTooManyOpen			(GNEX_BASE_GNERR_CODE+0x003B)
#define	GNEX_EPAL_CODE_FileInvalidHandle		(GNEX_BASE_GNERR_CODE+0x003C)
#define	GNEX_EPAL_CODE_FileInvalidName			(GNEX_BASE_GNERR_CODE+0x003D)
#define	GNEX_EPAL_CODE_EOF						(GNEX_BASE_GNERR_CODE+0x003E)
#define GNEX_EPAL_CODE_NoUTF8Representation		(GNEX_BASE_GNERR_CODE+0X003F)
#define GNEX_EPAL_CODE_NoLocalCodePageRepresentation (GNEX_BASE_GNERR_CODE+0X0040)
#define GNEX_EPAL_CODE_BadUTF8					(GNEX_BASE_GNERR_CODE+0X0041)
#define GNEX_EPAL_CODE_CouldNotFetchLocalTime	(GNEX_BASE_GNERR_CODE+0X0042)

/* ID3 Tagging */
#define GNEX_ID3_CODE_InvalidHeader				(GNEX_BASE_GNERR_CODE+0x0101)
#define GNEX_ID3_CODE_InvalidTag				(GNEX_BASE_GNERR_CODE+0x0102)
#define GNEX_ID3_CODE_InvalidFrame				(GNEX_BASE_GNERR_CODE+0x0103)
#define GNEX_ID3_CODE_InvalidFlags				(GNEX_BASE_GNERR_CODE+0x0104)
#define GNEX_ID3_CODE_EndOfTag					(GNEX_BASE_GNERR_CODE+0x0105)
#define GNEX_ID3_CODE_Padding					(GNEX_BASE_GNERR_CODE+0x0106)
#define GNEX_ID3_CODE_StringConv				(GNEX_BASE_GNERR_CODE+0x0107)
#define GNEX_ID3_CODE_InvalidURL				(GNEX_BASE_GNERR_CODE+0x0108)
#define GNEX_ID3_CODE_DecompressNotAvailable	(GNEX_BASE_GNERR_CODE+0x0109)
#define GNEX_ID3_CODE_CompressNotAvailable		(GNEX_BASE_GNERR_CODE+0x010A)
#define GNEX_ID3_CODE_TagConversionUnsupported  (GNEX_BASE_GNERR_CODE+0X010B)
#define GNEX_ID3_CODE_InvalidUnicodeCodePoint	(GNEX_BASE_GNERR_CODE+0X010C)
#define GNEX_ID3_CODE_InvalidUTFEncoding		(GNEX_BASE_GNERR_CODE+0X010D)
#define GNEX_ID3_CODE_MissingUnicodeBOM			(GNEX_BASE_GNERR_CODE+0X010E)

/*GNWaveFile */
#define GNEX_GNWAV_CODE_AllocationError       	(GNEX_BASE_GNERR_CODE+0x0201)
#define GNEX_GNWAV_CODE_FileError             	(GNEX_BASE_GNERR_CODE+0x0202)
#define GNEX_GNWAV_CODE_InvalidParameter      	(GNEX_BASE_GNERR_CODE+0x0203)
#define GNEX_GNWAV_CODE_InvalidFormat         	(GNEX_BASE_GNERR_CODE+0x0204)
#define GNEX_GNWAV_CODE_HeaderBufferTooSmall  	(GNEX_BASE_GNERR_CODE+0x0205)
#define GNEX_GNWAV_CODE_SpoolBufferTooSmall   	(GNEX_BASE_GNERR_CODE+0x0206)
#define GNEX_GNWAV_CODE_NotASpool             	(GNEX_BASE_GNERR_CODE+0x0207)
#define GNEX_GNWAV_CODE_EndOfFile             	(GNEX_BASE_GNERR_CODE+0x0208)

/*Phoneme Conversion Library */
#define GNEX_PHOCVRT_CODE_NoMemory					(GNEX_BASE_GNERR_CODE+0x0301)
#define GNEX_PHOCVRT_CODE_InvalidArg				(GNEX_BASE_GNERR_CODE+0x0302)
#define GNEX_PHOCVRT_CODE_InvalidAlgID				(GNEX_BASE_GNERR_CODE+0x0303)
#define GNEX_PHOCVRT_CODE_RuleNotFound				(GNEX_BASE_GNERR_CODE+0x0304)
#define GNEX_PHOCVRT_CODE_FileNotFound				(GNEX_BASE_GNERR_CODE+0x0305)
#define GNEX_PHOCVRT_CODE_InvalidFile				(GNEX_BASE_GNERR_CODE+0x0306)
#define GNEX_PHOCVRT_CODE_MapNotFound				(GNEX_BASE_GNERR_CODE+0x0307)
#define GNEX_PHOCVRT_CODE_InvalidValidation			(GNEX_BASE_GNERR_CODE+0x0308)
#define GNEX_PHOCVRT_CODE_InvalidConversion			(GNEX_BASE_GNERR_CODE+0x0309)
#define GNEX_PHOCVRT_CODE_InvalidLanguage			(GNEX_BASE_GNERR_CODE+0x0310)

/*
* Prototypes
*/

/* Return descriptive string associated with error code */
const gn_uchar_t*
gnex_get_code_desc(gn_uint16_t error_code);

/* Return descriptive string associated with package id */
const gn_uchar_t*
gnex_get_package_desc(gn_uint16_t package_id);


#ifdef __cplusplus
}
#endif

#endif /* _GNEX_ERROR_CODES_H_ */

