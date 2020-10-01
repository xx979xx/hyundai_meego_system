/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_coverart_types.h - Type definitions and constants for cover art delivery
 * mechanism.
 */

#ifndef _GN_COVERART_TYPES_H_
#define _GN_COVERART_TYPES_H_

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

/* Image source identifiers used by gn_coverart_source_t */
#define		GN_COVERART_SOURCE_NONE	                  0
#define		GN_COVERART_SOURCE_ONDEMAND_ALBUM_ART     1
#define		GN_COVERART_SOURCE_CACHED_ALBUM_ART       2
#define		GN_COVERART_SOURCE_ONLINE_ALBUM_ART       3
#define		GN_COVERART_SOURCE_LOCAL_ALBUM_ART        4
#define		GN_COVERART_SOURCE_LOCAL_GENRE_ART        5
#define		GN_COVERART_SOURCE_LOCAL_ARTIST_IMAGE       6
#define		GN_COVERART_SOURCE_ONLINE_ARTIST_IMAGE      7
#define		GN_COVERART_SOURCE_CACHED_ARTIST_IMAGE      8


/* Image type identifiers used by gn_coverart_format_t */
#define		GN_COVERART_FORMAT_JPEG				1

/* Cover art sizes used by gn_coverart_dimension_t */
#define		GN_COVERART_DIMENSION_NONE			0
#define		GN_COVERART_DIMENSION_THUMBNAIL		1
#define		GN_COVERART_DIMENSION_SMALL			2
#define		GN_COVERART_DIMENSION_MEDIUM		3
#define		GN_COVERART_DIMENSION_LARGE			4
#define		GN_COVERART_DIMENSION_XLARGE		5
#define		GN_COVERART_DIMENSION_300x300		6

/*
 * Typedefs
 */

 /* One of the GN_COVERART_SOURCE_* defines from above */
typedef gn_uint32_t 		gn_coverart_source_t;

/* One of the GN_COVERART_FORMAT_* defines from above */
typedef gn_uint32_t 		gn_coverart_format_t;

/* One of the GN_COVERART_DIMENSION_* defines from above */
typedef gn_uint32_t 		gn_coverart_dimension_t;

/* Primary data structure for holding all relevant data about coverart  */
typedef void* 			gn_coverart_t;

#ifdef __cplusplus
}
#endif


#endif /* _GN_COVERART_TYPES_H_ */
