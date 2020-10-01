/*
 * Copyright (c) 2004 - 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_album_types.h - album data structures and types.
 *
 *  IT IS RECOMMENDED THAT YOU USE THE INTERFACE DEFINED IN gn_album_track_types.h.
 *  THIS INTERFACE IS INCLUDED FOR BACKWARDS COMPATIBILITY ONLY.
 */

#ifndef	_GN_ALBUM_TYPES_H_
#define _GN_ALBUM_TYPES_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_album_track_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */

/* Identify the "alternate" status of the phonetic. */
#define		GN_ALBUM_DATA_PHONETIC_PREFERRED		0	/* The preferred phonetic representation. */
#define		GN_ALBUM_DATA_PHONETIC_ALTERNATE_BASE	1	/* An alternate phonetic representation. Multiple alternates can exist. */

/* A default phonetic data source. A value of GN_NULL indicates that the accessors should retrieve the first */
/* phonetic string found. */
#ifndef GN_ALBUM_DATA_PHONETIC_SOURCE_1
#define	GN_ALBUM_DATA_PHONETIC_SOURCE_1				GN_NULL
#endif

/* Identify the "type" of the display string (for names and titles. */
#define		GN_ALBUM_DATA_DISPLAY_UNKNOWN			0	/* The display string is an unknown variant of the display string. */
#define		GN_ALBUM_DATA_DISPLAY_TLS				1	/* The display string conforms to the TLS format. */
#define		GN_ALBUM_DATA_DISPLAY_OFFICIAL			2	/* The display string reflects the official name or title. */
#define		GN_ALBUM_DATA_DISPLAY_ALTERNATE			3	/* The display string is an alternate variant of the name or title. */


/*
 * Structures and typedefs.
 */

/* Opaque pointers to underlying C data structures. */
/* Always access data fields via the data accessor functions declared here. */

typedef void* gn_pxid_t;				/* Opaque pointer to external id data (album or track). */

#ifdef __cplusplus
}
#endif 


#endif /* _GN_ALBUM_TYPES_H_ */
