/*
* Copyright (c) 2007 Gracenote.
*
* This software may not be used in any way or distributed without
* permission. All rights reserved.
*
* Some code herein may be covered by US and international patents.
*/

/*
* gnex_error_values.h - Error values, used and returned by each package.
*/

#ifndef _GNEX_ERROR_VALUES_H_
#define _GNEX_ERROR_VALUES_H_

/*
* Dependencies
*/

#include "gnex_error_codes.h"


#ifdef __cplusplus
extern "C"{
#endif

/* To do - once c files are branched over, take a survey of what error         */
/* values can be deleted.                                                      */

/* Generic errors */
#define	GNEX_GENERR_NoError							0
#define	GNEX_GENERR_NoMemory						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_NoMemory)
#define	GNEX_GENERR_NotFound						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_NotFound)
#define	GNEX_GENERR_IOError							GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_IOError)
#define	GNEX_GENERR_InvalidArg						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_InvalidArg)
#define	GNEX_GENERR_Busy							GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_Busy)
#define	GNEX_GENERR_NotInited						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_NotInited)
#define	GNEX_GENERR_OVERFLOW						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_OVERFLOW)
#define	GNEX_GENERR_Unknown							GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_Unknown)
#define	GNEX_GENERR_BufferTooSmall					GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_BufferTooSmall)
#define	GNEX_GENERR_InvalidFormat					GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_InvalidFormat)
#define	GNEX_GENERR_InitFailed						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_InitFailed)
#define	GNEX_GENERR_UnsupportedFunctionality		GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_UnsupportedFunctionality)
#define GNEX_GENERR_IckyError						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_GEN_CODE_IckyError)
#define GNEX_GENERR_FileExists						GNEX_MAKE_VALUE(GNEX_GNPKG_Generic, GNEX_EPAL_CODE_FileExists)


/* Errors returned from the file subsystem in GN EPAL */
#define GNEX_EPAL_FSERR_InvalidAccess				GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileInvalidAccess)
#define GNEX_EPAL_FSERR_NotFound 					GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileNotFound)
#define GNEX_EPAL_FSERR_FileExists					GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileExists)
#define GNEX_EPAL_FSERR_NoSpace						GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileNoSpace)
#define GNEX_EPAL_FSERR_Toomanyopen					GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileTooManyOpen)
#define GNEX_EPAL_FSERR_Invalidhandle				GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileInvalidHandle)
#define GNEX_EPAL_FSERR_Invalidfilename				GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_FileInvalidName)
#define GNEX_EPAL_FSERR_EOF							GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_EPAL_CODE_EOF)
#define GNEX_EPAL_FSERR_InvalidArg					GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_GEN_CODE_InvalidArg)
#define GNEX_EPAL_FSERR_IOError						GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_GEN_CODE_IOError)
#define GNEX_EPAL_FSERR_IckyError					GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_FileSystem, GNEX_GEN_CODE_IckyError)

/* Errors returned from other parts of GNEPAL */
#define GNEX_EPAL_InvalidArg					GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_GEN_CODE_InvalidArg)
#define GNEX_EPAL_NoUTF8Representation			GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_EPAL_CODE_NoUTF8Representation)
#define GNEX_EPAL_NoLocalCodePageRepresentation GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_EPAL_CODE_NoLocalCodePageRepresentation)
#define GNEX_EPAL_BadUTF8						GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_EPAL_CODE_BadUTF8)
#define GNEX_EPAL_CouldNotFetchLocalTime		GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_EPAL_CODE_CouldNotFetchLocalTime)
#define GNEX_EPAL_IckyError						GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_GEN_CODE_IckyError)
#define GNEX_EPAL_BufferTooSmall				GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_GEN_CODE_BufferTooSmall)
#define GNEX_EPAL_NoMemory						GNEX_MAKE_VALUE(GNEX_GNPKG_EPAL_GENERAL, GNEX_GEN_CODE_IckyError)

/* */
/* Errors returned by example code outside of GNEPAL                         */
/* */

/* Errors returned from the example code ID3 library */
#define GNEX_ID3ERR_NoError							0
#define GNEX_ID3ERR_InvalidArg						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_InvalidArg)
#define GNEX_ID3ERR_IOError							GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_IOError)
#define GNEX_ID3ERR_NoMemory						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_NoMemory)
#define GNEX_ID3ERR_NotFound						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_NotFound)
#define GNEX_ID3ERR_InvalidHeader					GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidHeader)
#define GNEX_ID3ERR_InvalidTag						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidTag)
#define GNEX_ID3ERR_InvalidFrame					GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidFrame)
#define GNEX_ID3ERR_InvalidFlags					GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidFlags)
#define GNEX_ID3ERR_EndOfTag						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_EndOfTag)
#define GNEX_ID3ERR_Padding							GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_Padding)
#define GNEX_ID3ERR_IckyError						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_IckyError)
#define GNEX_ID3ERR_StringConv						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_StringConv)
#define GNEX_ID3ERR_InvalidURL						GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidURL)
#define GNEX_ID3ERR_UnsupportedFunctionality		GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_UnsupportedFunctionality)
#define GNEX_ID3ERR_DecompressNotAvailable			GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_DecompressNotAvailable)
#define GNEX_ID3ERR_CompressNotAvailable			GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_CompressNotAvailable)
#define GNEX_ID3ERR_TagConversionUnsupported		GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_TagConversionUnsupported)
#define GNEX_ID3ERR_InvalidUnicodeCodePoint			GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidUnicodeCodePoint)
#define GNEX_ID3ERR_InvalidUTFEncoding				GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_InvalidUTFEncoding)
#define GNEX_ID3ERR_MissingUnicodeBOM				GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_ID3_CODE_MissingUnicodeBOM)
#define GNEX_ID3ERR_BufferTooSmall					GNEX_MAKE_VALUE(GNEX_GNPKG_ID3, GNEX_GEN_CODE_BufferTooSmall)

/* Errors returned from the example code GNWaveFile library */
#define GNEX_GNWAV_NoError							0
#define GNEX_GNWAV_AllocationError      		 	GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_AllocationError)
#define GNEX_GNWAV_FileError             			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_FileError)
#define GNEX_GNWAV_InvalidParameter      			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_InvalidParameter)
#define GNEX_GNWAV_InvalidFormat         			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_InvalidFormat)
#define GNEX_GNWAV_HeaderBufferTooSmall  			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_HeaderBufferTooSmall)
#define GNEX_GNWAV_SpoolBufferTooSmall   			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_SpoolBufferTooSmall)
#define GNEX_GNWAV_NotASpool             			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_NotASpool)
#define GNEX_GNWAV_EndOfFile             			GNEX_MAKE_VALUE(GNEX_GNPKG_GNWAV, GNEX_GNWAV_CODE_EndOfFile)

/* Errors returned from the example code Phonetic Conversion Library */
#define GNEX_PHOCVRT_NoError						0
#define GNEX_PHOCVRT_NoMemory						GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_NoMemory)
#define GNEX_PHOCVRT_InvalidArg						GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_InvalidArg)
#define GNEX_PHOCVRT_InvalidAlgID					GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_InvalidAlgID)
#define GNEX_PHOCVRT_RuleNotFound					GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_RuleNotFound)
#define GNEX_PHOCVRT_FileNotFound					GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_FileNotFound)
#define GNEX_PHOCVRT_InvalidFile					GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_InvalidFile)
#define GNEX_PHOCVRT_MapNotFound					GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_MapNotFound)
#define GNEX_PHOCVRT_InvalidValidation				GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_InvalidValidation)
#define GNEX_PHOCVRT_InvalidConversion				GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_InvalidConversion)
#define GNEX_PHOCVRT_InvalidLanguage				GNEX_MAKE_VALUE(GNEX_GNPKG_PHOCVRT, GNEX_PHOCVRT_CODE_InvalidLanguage)

#ifdef __cplusplus
}
#endif

#endif /* _GNEX_ERROR_VALUES_H_ */

