/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gnepal_strlocal.h - Abstraction of local code page to utf8 converion functions.
 *
 */

#ifndef	_GNEPAL_STRLOCAL_H_
#define _GNEPAL_STRLOCAL_H_

/*
 * Dependencies.
 */
#include "gn_defines.h"
#include "gnex_errors.h"

#ifdef __cplusplus
extern "C"{
#endif 

/* gnepal_local_to_utf8 */
/*                                                                           */
/* Return values include:                                                    */
/* 	GNEX_SUCCESS - no error occurred.                                        */
/* 	GNEX_EPAL_NoLocalCodePageRepresentation - the string 'local' could not be*/
/* 	represented in the UTF-8.                                                */
/* 	                                                                         */                              

gnex_error_t
gnepal_local_to_utf8(const gn_uchar_t* local, gn_size_t local_len, gn_uchar_t* utf8, gn_size_t* utf8_len);

/* gnepal_utf8_to_local */
/*                                                                           */
/* Return values include:                                                    */
/* 	GNEX_SUCCESS - no error occurred.                                        */
/* 	GNEX_EPAL_NoLocalCodePageRepresentation - the string 'utf8' could not be */
/* 	represented in the in host platform's code page or string encoding.      */

gnex_error_t 
gnepal_utf8_to_local(const gn_uchar_t* utf8, gn_size_t utf8_len, gn_uchar_t* local, gn_size_t* local_len);

#ifdef __cplusplus
}
#endif 
    
#endif /* _GNEPAL_STRLOCAL_H_ */
