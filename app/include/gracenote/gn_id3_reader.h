/*
 * Copyright (c) 2005 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

#ifndef _GNID3_READER_H
#define _GNID3_READER_H

#include "gn_defines.h"
#include "gnex_errors.h"

#ifdef __cplusplus
extern "C"{
#endif 

/* libiconv is currently supported only for Windows. */
#if defined(WIN32) && defined(GN_TEXTID)
	#define LIBICONV_SUPPORTED
#endif	/* WIN32 */

/*
 * Structs:
 */


typedef void* gnid3_reader_t;


/* 
 * Prototypes:
 */


gnex_error_t 
gnid3_reader_init(
	gnid3_reader_t* id3,
	const gn_uchar_t* file_name,
	gn_bool_t readV1,
	gn_bool_t readV2,
	gn_bool_t readLocalCodePage,
	gnex_error_t (*decompress) (gn_uchar_t *dest, 
							gn_uint32_t *destLen,
							gn_uchar_t *source, 
							gn_uint32_t sourceLen
							)
	);

gnex_error_t
gnid3_reader_shutdown( gnid3_reader_t* reader );

gnex_error_t
gnid3_reader_get_track_title(gnid3_reader_t id3, gn_uchar_t** title);

gnex_error_t
gnid3_reader_get_lead_performer(gnid3_reader_t id3, gn_uchar_t** artist);

gnex_error_t
gnid3_reader_get_composer(gnid3_reader_t id3, gn_uchar_t** composer);

gnex_error_t
gnid3_reader_get_album_title(gnid3_reader_t id3, gn_uchar_t** album);

/*	gnid3_reader_get_tagid 
 * Description: Gets the tagID found in the UFID field owned by the Gracenote URL.
 *				This function allocates memory for the tagid parameter.
 *				The caller must free the memory.
 * Args:	id3		- the id3 reader to get the tagid from.
 *			tagid	- pointer to a string to hold the tagid
 * Returns:	GNEX_SUCCESS upon success or an error.
 *
 */
gnex_error_t
gnid3_reader_get_tagid(gnid3_reader_t id3, gn_uchar_t** tagid);

gnex_error_t
gnid3_reader_get_genre(gnid3_reader_t id3, gn_uchar_t** genre);

gnex_error_t
gnid3_reader_get_release_year(gnid3_reader_t id3, gn_uchar_t** year);

gnex_error_t
gnid3_reader_get_disc_artist(gnid3_reader_t id3, gn_uchar_t** disc_artist);

/*	gnid3_reader_get_ext_data 
 * Description: Gets the serialized extended data found in the TXXX field owned by the GN_ExtData description.
 *				This function allocates memory for the ext_data parameter.
 *				The caller must free the memory.
 * Args:	id3		- the id3 reader to get the extended data from.
 *			ext_data	- pointer to a string to hold the ext_data
 * Returns:	GNEX_SUCCESS upon success or an error.
 *
 */
gnex_error_t
gnid3_reader_get_ext_data(gnid3_reader_t id3, gn_uchar_t** ext_data);

/*	gnid3_reader_get_cddb_ids
 * Description: Gets the CDDB IDs found in the comments field owned by the iTunes_CDDB_IDs description.
 *				This function allocates memory for the cddb_ids parameter.
 *				The caller must free the memory.
 * Args:	id3			- the id3 reader to get the CDDB IDs from.
 *			cddb_ids	- pointer to a string to hold the cddb_ids
 * Returns:	GNEX_SUCCESS upon success or an error.
 *
 */
gnex_error_t
gnid3_reader_get_cddb_ids(gnid3_reader_t id3, gn_uchar_t** cddb_ids);

gnex_error_t
gnid3_reader_get_track_num(
	gnid3_reader_t id3,
	gn_uint32_t* track,
	gn_uint32_t* num_tracks);


#ifdef __cplusplus
}
#endif 

#endif /* end _GNID3_READER_H */
