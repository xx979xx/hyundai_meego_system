/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_abs_types.h - The type definitions used by the eMMS library 
 * and the definition of macros.
 */

#ifndef	_GN_ABS_TYPES_H_
#define _GN_ABS_TYPES_H_

/*
 * Dependencies.
 */
 
#include "gn_abs_override.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Constants.
 */

#define GN_FALSE ((gn_bool_t)(0))
#define GN_TRUE ((gn_bool_t)(1))

#ifndef GN_NULL
	#define GN_NULL ((void *)0)
#endif

#ifndef GN_MAX_PATH
	#define		GN_MAX_PATH		260
#endif

#ifndef GN_URLSIZE
	#define		GN_URLSIZE		255
#endif

#ifndef GN_ULONG_MAX
	#define	GN_ULONG_MAX	4294967295UL
#endif

#ifndef GN_LONG_MAX
	#define	GN_LONG_MAX	2147483647L
#endif

#ifndef GN_LONG_MIN
	#define	GN_LONG_MIN	(-GN_LONG_MAX - 1L)
#endif


/*
 * Typedef
 */

#ifndef GN_CHAR_T
	typedef char gn_char_t;
	#define GN_CHAR_T
#endif

#ifndef GN_INT16_T
	typedef short gn_int16_t;
	#define GN_INT16_T
#endif

#ifndef GN_INT32_T
	typedef long gn_int32_t;
	#define GN_INT32_T
#endif

#ifndef GN_UNICHAR_T
	typedef unsigned short gn_unichar_t;
	#define GN_UNICHAR_T
#endif

#ifndef GN_UCHAR_T
	typedef unsigned char gn_uchar_t;
	#define GN_UCHAR_T
#endif

#ifndef GN_UINT16_T
	typedef unsigned short gn_uint16_t;
	#define GN_UINT16_T
#endif

#ifndef GN_UINT32_T
	typedef unsigned long gn_uint32_t;
	#define GN_UINT32_T
#endif

#ifndef GN_SIZE_T
	typedef unsigned long gn_size_t;
	#define GN_SIZE_T
#endif

#ifndef GN_STR_T
	typedef char* gn_str_t;
	#define GN_STR_T
#endif

#ifndef GN_USTR_T
	typedef unsigned char* gn_ustr_t;
	#define GN_USTR_T
#endif

#ifndef GN_CSTR_T
	typedef const char*  gn_cstr_t;
	#define GN_CSTR_T
#endif

#ifndef GN_CUSTR_T
	typedef const unsigned char*  gn_custr_t;
	#define GN_CUSTR_T
#endif

#ifndef GN_UNISTR_T
	typedef gn_unichar_t* gn_unistr_t;
	#define GN_UNISTR_T
#endif

#ifndef GN_CUNISTR_T
	typedef const gn_unichar_t* gn_cunistr_t;
	#define GN_CUNISTR_T
#endif

#ifndef GN_HANDLE_T
	typedef int gn_handle_t;
	#define GN_HANDLE_T
#endif

#ifndef GN_DVDHANDLE_T
	typedef int gn_dvdhandle_t;
	#define GN_DVDHANDLE_T
#endif

#ifndef GN_FLT32_T
	typedef float gn_flt32_t;
	#define GN_FLT32_T
#endif

#ifndef GN_FLT64_T
	typedef double gn_flt64_t;
	#define GN_FLT64_T
#endif

#ifndef GN_BOOL_T
	typedef char gn_bool_t;
	#define GN_BOOL_T
#endif

#ifndef GN_ERROR_T
	typedef gn_uint32_t gn_error_t;
	#define GN_ERROR_T
#endif

#ifdef __cplusplus
}
#endif 

#endif /* _GN_DEFINES_H_ */
