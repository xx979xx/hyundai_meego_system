/*
 * Copyright (c) 2000, 2008 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_video_toc.h
 *   Declarations to support TOC generation for video content
 */


#ifndef _GN_VIDEO_TOC_H_
#define _GN_VIDEO_TOC_H_

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

/* For Flags for gn_video_toc_extra_id_t field of gn_video_add_ext_id_to_toc()
 * function.
 */
#define GN_VIDEO_TOC_EXTRA_ID_AACS 1


/* These bit flags are used in the gn_video_generate_toc_ex() function
 */
#define GN_VIDEO_TOC_GEN_FLAG_SHORT      1  /* Generate a "short" toc (DVD only) */
#define GN_VIDEO_TOC_GEN_FLAG_AACS_ONLY  2  /* Read only the AACS-CCID and skip TOC generation (Blu-ray only) */


/*
 * Structures and typedefs
 */

typedef void* gn_video_toc_info_t;
typedef gn_uint32_t gn_video_toc_extra_id_t;


/*
 * Prototypes
 */

/* gn_video_generate_toc
 *
 *
 * Args:
 *   path       - The path to the root of the video content
 *   video_toc  - The Allocated, populated TOC data that will be used by the
 *                video lookup APIs.
 *
 * This function will generate a TOC for the media pointed to by the specified
 * path. The function will generate a TOC for either a DVD or a Blu-ray disc.
 *
 * The TOC structure should be freed with gn_video_smart_free_toc().
 */
gn_error_t
gn_video_generate_toc(
	const gn_uchar_t* path,
	gn_video_toc_info_t *video_toc
);


/* gn_video_generate_toc_ex
 *
 * NOTE - This extended function should only be used after consultation with
 * Gracenote. By default the gn_video_generate_toc() function should be used
 * unless it has been determined that due to platform limitations it is
 * necessary to specify one or more TOC modification fields when generating
 * the TOC.
 *
 * Args:
 *   path       - The path to the root of the video content
 *   video_toc  - The Allocated, populated TOC data that will be used by the
 *                video lookup APIs.
 *
 * This function will generate a TOC for the media pointed to by the specified
 * path. The function will generate a TOC for either a DVD or a Blu-ray disc.
 *
 * The TOC structure should be freed with gn_video_smart_free_toc().
 */
gn_error_t
gn_video_generate_toc_ex(
	const gn_uchar_t* path,
	gn_video_toc_info_t *video_toc,
	gn_uint32_t toc_gen_flags
);

/* gn_video_smart_free_toc
 *
 *
 * Args:
 *   video_toc - The TOC to free
 *
 * This function frees the TOC data and sets the associated TOC pointer to
 * GN_NULL
 */
gn_error_t
gn_video_smart_free_toc(
	gn_video_toc_info_t *video_toc
);


/* gn_video_get_toc_string
 *
 *
 * Args:
 *   video_toc  - The TOC to get the string from
 *   toc_string - The generated TOC string in a format suitable for printing
 *                or storage
 *
 * This function will generate a TOC for the media pointed to by the specified
 * path. The function will generate a TOC for either a DVD or a Blu-ray disc.
 *
 * The TOC structure should be freed with gn_video_smart_free_toc().
 *
 * The TOC string should be freed with a call to gn_video_smart_free_toc_string()
 */
gn_error_t
gn_video_get_toc_string(
	const gn_video_toc_info_t *video_toc,
	gn_uchar_t **toc_string
);


/* gn_video_smart_free_toc_string
 *
 *
 * Args:
 *   toc_string - The Video TOC string to free
 *
 * This function frees the TOC string and sets the associated string pointer to
 * GN_NULL
 */
gn_error_t
gn_video_smart_free_toc_string(
	gn_uchar_t **toc_string
);

/*
 * gn_video_populate_toc_info
 *
 * Args:
 *   id   			pointer to gn_video_toc_info_t
 *   toc	 		GN internal format DVD/Bluray TOC string
 *   disc_type		GN_MEDIA_TYPE_ID_DVD |  GN_MEDIA_TYPE_ID_BD  
 *   				(optional for version 1 TOC strings: dvd assumed)
 *   fps			frames per second as a string (optional)
 *   region_code	region code (optional, dvd only)
 *   angles			boolean as to whether a DVD contains angles or not.
 *
 *
 * This function parses a TOC string (versions 1 through 3, Bluray and DVD) into a toc info
 * structure.  On success, GN_SUCCESS is returned, with a toc info structure via the pointer
 * "id".
 *
 * 
 *   Note: the information presented through the disc_type, fps, region_code, and angles
 *   parameters will only be included in the toc info structure if that information is NOT
 *   present in the TOC string.  If a version 1 string is passed in, it is automatically
 *   assumed to be a DVD toc; Bluray support was added with version 2 strings.
 *
 *
 * On failure, an error is returned, and the contents of "id" should remain NULL.
 *
 */
gn_error_t
gn_video_populate_toc_info(
	gn_video_toc_info_t* id, 	
	gn_uchar_t* toc, 			
	gn_uchar_t* disc_type, 		
	gn_uchar_t* fps, 			
	gn_uchar_t* region_code, 	
	gn_uchar_t* tv_system, 		
	gn_bool_t	angles			
	);


/*
 * gn_video_add_ext_id_to_toc
 *
 * Args:
 *   id		 	A gn_video_toc_info_t value representing the TOC to add an external ID to.
 *   id_type	ID type, such as GN_VIDEO_TOC_EXTRA_ID_AACS
 *   id_str		String containing the ID data, such as "012345"
 *   id_strsrc	String containing the physical source of data string, such as a filename "Content001.CER"
 *
 *	On success, GN_SUCCESS is returned, and the ID is added to the toc structure.  The id will
 *	automatically be freed when the TOC structure is freed.
 *
 *	On failure, an error is returned, and the TOC structure is not modified.
 *
 */
gn_error_t
gn_video_add_ext_id_to_toc(
	gn_video_toc_info_t id, 
	gn_video_toc_extra_id_t id_type, 
	gn_uchar_t* id_str,    
	gn_uchar_t* id_strsrc  
	);


#ifdef __cplusplus
}
#endif

#endif /* _GN_VIDEO_TOC_H_ */
