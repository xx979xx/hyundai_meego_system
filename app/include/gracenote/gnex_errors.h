/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gnex_errors.h - Definitions for error handling with embedded CDDB.
 */

#ifndef	_GNEX_ERRORS_H_
#define _GNEX_ERRORS_H_

/*
 * Background.
 */

/*
 * ERROR CODE FORMAT VERSION 1
 */
/*
 *  Gracenote Example Platform Abstraction Layer error codes (gnex_error_t)
 *  [version 1] are 32-bit values layed out as follows:
 *
 *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
 *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 *  +-+-----+-----+-+---------------+---------------+---------------+
 *  |s| ver | rsvd|e|  package/lib  |          error code           |
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
 *      e - external bit indicates that the error came from outside eMMS
 *
 *      package/lib - which library or package is the source of the error.
 *
 *      errror code - as defined in gn_error_codes.h.
 */

/*
 * Dependencies.
 */

#include "gn_defines.h"


#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Types.
 */

	typedef gn_uint32_t gnex_error_t;

/*
 * Constants.
 */

/* Success */
#define GNEX_SUCCESS (0)

/* Offsets into error code */
#define	GNEX_CODE_OFFSET	    0
#define	GNEX_PKG_OFFSET			16
#define GNEX_EXT_BIT_OFFSET		24
#define	GNEX_VER_OFFSET			28
#define	GNEX_SEV_OFFSET			31

/* Masks for fields within error code */
#define	GNEX_CODE_MASK			0xFFFF
#define	GNEX_PKG_MASK			0xFF0000
#define	GNEX_VER_MASK			0x70000000

/* Sizes (in bits) of fields within error code */
#define	GNEX_CODE_SIZE			16
#define	GNEX_PKG_SIZE			8
#define	GNEX_VER_SIZE			3
#define	GNEX_SEV_SIZE			1

#define	GNEX_MAX_PACKAGE_STRING	32
#define	GNEX_MAX_CODE_STRING	64
#define	GNEX_MAX_MESSAGE_STRING	(GNEX_MAX_PACKAGE_STRING + GNEX_MAX_CODE_STRING + 64)


/*
 * Macros.
 */

/* Form error value from package id and error code */
#define		GNEX_MAKE_VALUE(package_id,error_code)	\
				((gnex_error_t)(((gn_uint32_t)0x01 << GNEX_SEV_OFFSET)	|		\
							((gn_uint32_t)0x001 << GNEX_EXT_BIT_OFFSET)		|\
							((gn_uint32_t)0x001 << GNEX_VER_OFFSET)		|\
							((gn_uint32_t)package_id << GNEX_PKG_OFFSET)		|\
							((gn_uint32_t)error_code << GNEX_CODE_OFFSET)))

/* Extract error code */
#define		GNEX_ERROR_CODE(error_code)	\
\
				((gn_uint16_t)((((gn_uint32_t)error_code & GNEX_CODE_MASK) >> GNEX_CODE_OFFSET) &	\
				(((gn_uint32_t)0x01 << (GNEX_CODE_SIZE + 1)) - 1)))

/* Extract package id */
#define		GNEX_PKG_ID(package_id)	\
\
				((gn_uint16_t)((((gn_uint32_t)package_id & GNEX_PKG_MASK) >> GNEX_PKG_OFFSET) &		\
				(((gn_uint32_t)0x01 << (GNEX_PKG_SIZE + 1)) - 1)))
				
/* Make sure an error code came from GN EPAL */
#define		GNEX_IS_EPAL_ERROR(error) \
					((gn_bool_t)(1 == (((gn_uint32_t)0x001 << GNEX_EXT_BIT_OFFSET) & error) >> GNEX_EXT_BIT_OFFSET))


/*
 * Prototypes
 */

/* get a descriptive message reflecting the package id and error value */
gn_uchar_t*
gnex_err_get_error_message(gnex_error_t error_value);


#ifdef __cplusplus
}
#endif 


#endif /* #ifndef _GNEX_ERRORS_H_ */
