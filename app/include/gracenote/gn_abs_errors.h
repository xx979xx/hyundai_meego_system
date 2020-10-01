/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_abs_errors.h - Abstract Layer error APIs
 */

#ifndef	_GN_ABS_ERRORS_H_
#define _GN_ABS_ERRORS_H_

/*
 * Background.
 */

/*
 * ERROR CODE FORMAT VERSION 1
 */
/*
 *  Gracenote embedded CDDB error codes (gn_error_t) [version 1]
 *  are 32-bit values layed out as follows:
 *
 *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
 *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 *  +-+-----+-------+---------------+---------------+---------------+
 *  |s| ver | rsvd  |  package/lib  |          error code           |
 *  +-+-----+-----------------------+---------------+---------------+
 *
 *  where
 *
 *      s - severity - indicates success or failure
 *
 *          0 - success
 *          1 - failure
 *
 *      ver - version bits (value = 001).
 *
 *      rsvd - reserved portion of the error code.
 *
 *      package/lib - which library or package is the source of the error.
 *
 *      errror code - as defined in gn_error_codes.h.
 */


/*
 * Dependencies.
 */

#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants.
 */

/* Severity values */
#define GN_FAILURE (1)
#define GN_SUCCESS (0)

/* Offsets into error code */
#define	GNERR_CODE_OFFSET		0	/* new */
#define	GNERR_PKG_OFFSET		16
#define	GNERR_VER_OFFSET		28
#define	GNERR_SEV_OFFSET		31

/* Masks for fields within error code */
#define	GNERR_CODE_MASK			0xFFFF	/* new */
#define	GNERR_PKG_MASK			0xFF0000
#define	GNERR_VER_MASK			0x70000000

/* Sizes (in bits) of fields within error code */
#define	GNERR_CODE_SIZE			16	/* new */
#define	GNERR_PKG_SIZE			8
#define	GNERR_VER_SIZE			3
#define	GNERR_SEV_SIZE			1

/*
 * Macros.
 */

/* Form error value from package id and error code */
#define		GNERR_MAKE_VALUE(package_id,error_code)	\
				((gn_error_t)(((gn_uint32_t)0x01 << GNERR_SEV_OFFSET)		|		\
							((gn_uint32_t)0x001 << GNERR_VER_OFFSET)		|		\
							((gn_uint32_t)package_id << GNERR_PKG_OFFSET)	|		\
							((gn_uint32_t)error_code << GNERR_CODE_OFFSET)))

/* Extract error code */
#define		GNERR_ERROR_CODE(error_code)	\
				((((error_code & GNERR_CODE_MASK) >> GNERR_CODE_OFFSET) &	\
				(((gn_uint32_t)0x01 << (GNERR_CODE_SIZE + 1)) - 1)))


/* Extract package id */
#define		GNERR_PKG_ID(package_id)	\
				((gn_uint16_t)((((gn_uint32_t)package_id & GNERR_PKG_MASK) >> GNERR_PKG_OFFSET) &		\
				(((gn_uint32_t)0x01 << (GNERR_PKG_SIZE + 1)) - 1)))

/* Package/library identifiers. */
#define BASE_GNERR_PKG_ID				0

#define GNPKG_MemoryMgr					(BASE_GNERR_PKG_ID+0x10)
#define GNPKG_FileSystem				(BASE_GNERR_PKG_ID+0x11)
#define GNPKG_Communications			(BASE_GNERR_PKG_ID+0x08)
#define GNPKG_DSP						(BASE_GNERR_PKG_ID+0x1C)		


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

#define	BASE_GNERR_CODE					0

#define	GNERR_NoError					(BASE_GNERR_CODE)
#define	GNERR_NoMemory					(BASE_GNERR_CODE+0x0001)	/* Memory allocation failure */
#define	GNERR_InvalidArg				(BASE_GNERR_CODE+0x0004)	/* Invalid argument */
#define	GNERR_Busy						(BASE_GNERR_CODE+0x0005)	/* System is busy */
#define	GNERR_NotInited					(BASE_GNERR_CODE+0x0006)	/* System not initialized */
#define	GNERR_IOError					(BASE_GNERR_CODE+0x0003)	/* Error reading or writing */
#define	GNERR_IckyError					(BASE_GNERR_CODE+0x0009)	/* Really, really bad error which can't be fathomed */


/* Abstraction Layer */
#define	GNERR_MemLeak					(BASE_GNERR_CODE+0x0041)
#define	GNERR_MemCorrupt				(BASE_GNERR_CODE+0x0042)
#define	GNERR_MemInvalid				(BASE_GNERR_CODE+0x0043)
#define	GNERR_MemInvalidHeap			(BASE_GNERR_CODE+0x0044)
#define	GNERR_MemNoFreeHeaps			(BASE_GNERR_CODE+0x0045)
#define	GNERR_MemInvalidHeapSize		(BASE_GNERR_CODE+0x0046)
#define	GNERR_FileInvalidAccess			(BASE_GNERR_CODE+0x0047)
#define	GNERR_FileNotFound				(BASE_GNERR_CODE+0x0048)
#define	GNERR_FileExists				(BASE_GNERR_CODE+0x0049)
#define	GNERR_FileNoSpace				(BASE_GNERR_CODE+0x004A)
#define	GNERR_FileTooManyOpen			(BASE_GNERR_CODE+0x004B)
#define	GNERR_FileInvalidHandle			(BASE_GNERR_CODE+0x004C)
#define	GNERR_FileInvalidName			(BASE_GNERR_CODE+0x004D)
#define	GNERR_EOF						(BASE_GNERR_CODE+0x004E)

/* Remote Communications Management */
#define	GNERR_PlatformInitFailed		(BASE_GNERR_CODE+0x0121)
#define	GNERR_PlatformShutdownFailed	(BASE_GNERR_CODE+0x0122)
#define	GNERR_NoMoreConnections			(BASE_GNERR_CODE+0x0123)
#define	GNERR_CommInvalidAddress		(BASE_GNERR_CODE+0x0124)
#define	GNERR_CommInvalidHandle			(BASE_GNERR_CODE+0x0125)
#define	GNERR_Unsupported				(BASE_GNERR_CODE+0x0126)
#define	GNERR_Timeout					(BASE_GNERR_CODE+0x0127)
#define	GNERR_HTTPClientError			(BASE_GNERR_CODE+0x0128)
#define	GNERR_HTTPServerError			(BASE_GNERR_CODE+0x0129)
#define	GNERR_HTTPCancelled				(BASE_GNERR_CODE+0x012A)
#define	GNERR_ConnectionRefused			(BASE_GNERR_CODE+0x012B)
#define	GNERR_HTTPInvalidHeaderFormat	(BASE_GNERR_CODE+0x012C)
#define	GNERR_HTTPUnsuppProtocolVers	(BASE_GNERR_CODE+0x012D)
#define	GNERR_HTTPInvalidStatusCode		(BASE_GNERR_CODE+0x012E)
#define	GNERR_TransferBufferExhausted	(BASE_GNERR_CODE+0x012F)
#define	GNERR_NoMoreToReceive			(BASE_GNERR_CODE+0x0130)

/* Errors returned from the memory management subsystem */
#define MEMERR_NoError						0
#define MEMERR_Busy							GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_Busy)
#define MEMERR_NoMemory						GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_NoMemory)
#define MEMERR_Leak							GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_MemLeak)
#define MEMERR_Noinit						GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_NotInited)
#define MEMERR_Corrupt						GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_MemCorrupt)
#define MEMERR_Invalid_mem					GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_MemInvalid)
#define MEMERR_No_free_heaps				GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_MemNoFreeHeaps)
#define MEMERR_Invalid_heap_size			GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_MemInvalidHeapSize)
#define MEMERR_InvalidArg					GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_InvalidArg)
#define MEMERR_Invalid_mem_heap				GNERR_MAKE_VALUE(GNPKG_MemoryMgr, GNERR_MemInvalidHeap)


/* Errors returned from the file subsystem */
#define FSERR_NoError						0
#define FSERR_InvalidAccess					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileInvalidAccess)
#define FSERR_NotFound 						GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileNotFound)
#define FSERR_FileExists					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileExists)
#define FSERR_NoSpace						GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileNoSpace)
#define FSERR_Toomanyopen					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileTooManyOpen)
#define FSERR_Invalidhandle					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileInvalidHandle)
#define FSERR_Invalidfilename				GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_FileInvalidName)
#define FSERR_EOF							GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_EOF)
#define FSERR_Busy							GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_Busy)
#define FSERR_NotInited						GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_NotInited)
#define FSERR_InvalidArg					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_InvalidArg)
#define FSERR_IOError						GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_IOError)
#define FSERR_IckyError						GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_IckyError)
#define FSERR_Unsupported					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_Unsupported)
#define FSERR_MemoryError					GNERR_MAKE_VALUE(GNPKG_FileSystem, GNERR_NoMemory)

/* Errors returned from the Communication subsystem */
#define COMMERR_NoError 					0
#define COMMERR_NotInited					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_NotInited)
#define COMMERR_Busy						GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_Busy)
#define COMMERR_NotFound					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_NotFound)
#define COMMERR_InvalidArg					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_InvalidArg)
#define COMMERR_NoMemory					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_NoMemory)
#define COMMERR_IOError 					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_IOError)
#define COMMERR_AlreadyInitialized			GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_Busy)
#define COMMERR_PlatformInitFailed			GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_PlatformInitFailed)
#define COMMERR_PlatformShutdownFailed		GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_PlatformShutdownFailed)
#define COMMERR_NoMoreConnections			GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_NoMoreConnections)
#define COMMERR_InvalidAddress				GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_CommInvalidAddress)
#define COMMERR_InvalidHandle				GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_CommInvalidHandle)
#define COMMERR_Unsupported					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_Unsupported)
#define COMMERR_Timeout						GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_Timeout)
#define COMMERR_HTTPClientError				GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_HTTPClientError)
#define COMMERR_HTTPServerError				GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_HTTPServerError)
#define COMMERR_HTTPCancelled				GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_HTTPCancelled)
#define COMMERR_ConnectionRefused			GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_ConnectionRefused)
#define COMMERR_IckyError					GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_IckyError)
#define COMMERR_UnsupportedFunctionality	GNERR_MAKE_VALUE(GNPKG_Communications, GNERR_UnsupportedFunctionality)

/* Errors returned from the DSP subsystem */
#define GNDSPERR_NoError					0
#define GNDSPERR_InvalidArg					GNERR_MAKE_VALUE(GNPKG_DSP, GNERR_InvalidArg)
#define GNDSPERR_NoMemory					GNERR_MAKE_VALUE(GNPKG_DSP, GNERR_NoMemory)

/*
 * Error Logging - Requires abstract_diagnostics
 */
#ifdef GN_LOGGING

/*
 * Prototypes
 */

/* API to log or display the error information */
gn_error_t
gnerr_log_error(gn_error_t err,gn_int32_t line, gn_uchar_t filename[]);

/* API to log or display the context specific error information */
gn_error_t
gnerr_log_error_cntxt(gn_error_t code,gn_uchar_t* context_error_info,gn_int32_t line, gn_uchar_t filename[]);

#define		GNERR_LOG_ERR(code)			gnerr_log_error(code,__LINE__,((gn_uchar_t*)__FILE__))
#define		GNERR_LOG_ERR_CNTXT(code,context_info)		gnerr_log_error_cntxt(code,context_info,__LINE__,((gn_uchar_t*)__FILE__))

#else /* #ifdef GN_LOGGING */

#define		GNERR_LOG_ERR(code)						(code)
#define		GNERR_LOG_ERR_CNTXT(code,context_info)	(code)

#endif /* #ifdef GN_LOGGING */

#ifdef __cplusplus
}
#endif 

#endif /* _GN_ABS_ERRORS_H_ */
