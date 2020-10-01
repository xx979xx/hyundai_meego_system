/**
 ** Declarations for displaying EMMS errors
 **/
#ifndef	_GN_DISPLAY_ERRORS_H_
#define _GN_DISPLAY_ERRORS_H_

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif

#define	GNERR_MAX_PACKAGE_STRING	32
#define	GNERR_MAX_CODE_STRING		64
#define	GNERR_MAX_MESSAGE_STRING	(GNERR_MAX_PACKAGE_STRING + GNERR_MAX_CODE_STRING + 64)

/* 
 * Map error code to string 
 * Params:
 *  error_code            [IN]    The error code
 */
const gn_uchar_t*
gnerr_get_code_desc(gn_uint16_t error_code);

/* 
 * Map package id to string 
 * Params:
 *  package_id            [IN]    The package id
 */
const gn_uchar_t*
gnerr_get_package_desc(gn_uint16_t package_id);

/*
 * Provide a friendly description of the specified EMMS error value
 * Params:
 *  error_value           [IN]    The error value
 */ 
gn_uchar_t const*
gnerr_get_error_message(gn_error_t error_value);

#ifdef __cplusplus
}
#endif
#endif	/* _GN_DISPLAY_ERRORS_H_ */
