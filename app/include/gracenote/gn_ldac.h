/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_ldac.h - Local Data Access Control mechanism.
 */

#ifndef	_GN_LDAC_H_
#define _GN_LDAC_H_

/*
 * Dependencies.
 */

#include "gn_errors.h"
#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */


/*
 * Typedefs
 */


/*
 * Prototypes
 */

/* gn_entitlement_is_data_source_entitled
 *
 * Query entitlement for a Data Source Identifier value.
 *
 * Parameters
 *
 *		data_source      Data Source Identifier value to be queried for
 *                      entitlement.
 *		entitled_access  True or False for entiled or not entitled 
 *                      respectively
 *
 * Returned Values
 *
 *		GN_SUCCESS								No error
 *		SYSERR_UnsupportedFunctionality		       LDAC is not initialized
 *		SYSERR_InvalidArg						Invalid parameter
 *
 */

gn_error_t 
gn_entitlement_is_data_source_entitled(
    const gn_uchar_t* data_source, 
    gn_bool_t* entitled_access
);


#ifdef __cplusplus
}
#endif 


#endif /* _GN_LDAC_H_ */
