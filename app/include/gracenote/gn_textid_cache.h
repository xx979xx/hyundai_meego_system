/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/* gn_textid_cache.h - Interface for managing the in-memory TextID
 *		cache.
 */


#ifndef _GN_TEXTID_CACHE_
#define _GN_TEXTID_CACHE_

/*
 * Dependencies.
 */

#include	"gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif
	

/*
 * gn_textid_cache_free_all
 * 
 * Free's the textid album, composer, lead performer, and genre data caches.  
 * Useful for low-memory situations on the device.
 * 
 * Note: It is NOT necessary to call this function before shutting
 * down the library.
 *
 * Return Values:
 *   On success:
 *      error                   : GN_SUCCESS
 *   On error:
 *      error                   : Gracenote Error Value
 */

gn_error_t
gn_textid_cache_free_all();


#ifdef __cplusplus
}
#endif

#endif /* _GN_TEXTID_CACHE_ */
