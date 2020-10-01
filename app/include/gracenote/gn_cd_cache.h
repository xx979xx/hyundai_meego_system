/*
 * Copyright (c) 2001 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_cd_cache.h - Application and mid-level interface definition for
 *				the module supporting local caching of online and local
 *				CD lookup information.
 */


#ifndef _GN_CD_CACHE_H_
#define _GN_CD_CACHE_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */

/** These are deprecated.
 ** They have been replaced by gn_odl_cache_delete() and gn_odl_cache_revert()
 **/

gn_error_t
gn_cd_cache_revert(void);

gn_error_t
gn_cd_cache_delete(void);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_CD_CACHE_H_ */
