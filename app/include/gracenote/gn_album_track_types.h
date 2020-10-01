/*
 * Copyright (c) 2004 - 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_album_track_types.h - album data structures and types.
 */

#ifndef	_GN_ALBUM_TRACK_TYPES_H_
#define _GN_ALBUM_TRACK_TYPES_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */

/* Identify the popularity duration. */
#define		GN_ALBUM_DATA_POP_DURATION_30			1	/* Popularity over a 30 day period. */
#define		GN_ALBUM_DATA_POP_DURATION_LIFETIME		2	/* Popularity over the entire lifetime of the album. */


/*
 * Structures and typedefs.
 */

typedef void* gn_palbum_t;				/* Opaque pointer to album data. */
typedef void* gn_palbum_track_t;		/* Opaque pointer to track-level data. */

typedef void* gn_pcredit_t;				/* Opaque pointer to credit data (album and/or track). */
typedef void* gn_pcredit_array_t;		/* Opaque pointer to a container holding one or more gn_pcredit_t instances. */

typedef void* gn_pwork_t;               /* Opaque pointer to a container for classical works data. */


#ifdef __cplusplus
}
#endif 


#endif /* _GN_ALBUM_TRACK_TYPES_H_ */
