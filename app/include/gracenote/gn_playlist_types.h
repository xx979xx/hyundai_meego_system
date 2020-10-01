/*
 * Copyright (c) 2005 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_playlist_types.h
 *
 * ePlaylist 2.5 public types 
 */

#ifndef _GN_PLAYLIST_TYPES_H_
#define _GN_PLAYLIST_TYPES_H_

#include "gn_defines.h"
#include "gn_playlist_enums.h"


/*
 * Defines.
 */

#define GN_MAX_TAG_ID_SIZE		64

#define	GNPL_CORRELATES_MICRO_GENRE		1
#define	GNPL_CORRELATES_MACRO_GENRE		2

/*
 * Typedefs.
 */

/*** Playlist 2.5 types ***/


/*
 *	Opaque pointer to the MLDB track entrydata.
 */
typedef void * gnplaylist_entrydata_t;


/*	gnpl_timestamp_t
 *
 *	This date structure is used by the public playlist API that operate on MLDB date fields.
 *	Use the gnplaylist_get_timestamp() API to obtain the current date and time.  Note that
 *	date support depends on your system and how you implement the gn_get_time() function in
 *	the abstract_layer for your platform.
 */
typedef struct
{
	gn_uint32_t		minute;		/*	0 to 59											*/
	gn_uint32_t		hour;		/*	0 to 23											*/
	gn_uint32_t		day;		/*	1 to maximum days for the month					*/
	gn_uint32_t		month;		/*	1 to 12											*/
	gn_uint32_t		year;		/*	relative to 0 being year 2000, 1 for 2001, etc.	*/
} gnpl_timestamp_t;


/* for generators and their lists */
typedef void * gnpl_playlist_gen_handle_t;
typedef void * gnpl_playlist_gen_list_handle_t;


/* playlist 2.5 criterion (rule) handle */
typedef void * gnpl_crit_handle_t;

/* playlist per-field ranking criteria structure */

/* playlist 2.5 rank handle */
typedef void * gnplaylist_rank_crit_handle_t;

/* playlist 2.5 morelikethis config */
typedef void * gnplaylist_morelikethis_cfg_t;


/* DEPRECATED 2.0 rank type */
typedef struct gnpl_playlist_rank_t {
    gnpl_crit_field_t field;
    gnpl_rank_order_t rank_order;
} gnpl_playlist_rank_t;

/* convenience structure */
typedef struct gnpl_range_t {
    gn_int32_t range_start;
    gn_int32_t range_end;
} gnpl_range_t;

/*
 *	Types used for multiple MLDB collections.
 *
 *	gn_collection_id_t
 *		This is the unique id returned by the gnplaylist_create_collection_id
 *		function and used in subsequent calls to the gnplaylist functions.
 *
 *	GN_INVALID_COLLECTION_ID
 *		Represents an invalid collection id <TODO> say more about this!
 *
 *	gn_collection_id_list_t
 *		This list is allocated and returned by the gnplaylist_get_enabled_for_playlisting_list
 *		function. It contains a simple array of gn_collection_id_t ids that are currently
 *		enabled for playlisting.
 *
 *		The list is freed by the gnplaylist_free_collection_id_list function.
 */

typedef gn_uint32_t gn_collection_id_t;

#define GN_INVALID_COLLECTION_ID 0

typedef struct
{
	gn_uint32_t			 id_count;
	gn_collection_id_t	*ids;
} gn_collection_id_list_t;


/*
 *	Populated generated playlist result.
 *	See the gnplaylist_get_results_data API definition for how this struct is populated.
 */
typedef struct
{
	gn_collection_id_t	collection_id;	/* the collection from which the result came */
	gn_uchar_t*			filename;
	gn_uchar_t*			path;
	gn_uchar_t*			artist;
	gn_uchar_t*			album;
	gn_uchar_t*			title;
	gn_uint32_t			length_secs;
	gn_uint32_t			bitrate;
	gn_uint32_t			size_bytes;
	gn_uchar_t			tag_id[GN_MAX_TAG_ID_SIZE];
	gn_uint32_t			tui_id;
	gn_uint32_t			user_rating;
	gn_uint32_t			release_year;		/* gnpl_crit_field_track_releaseyear: added for 5.1 */
	gnpl_timestamp_t	lastplayed_date;	/* gnpl_crit_field_file_lastplayed_date: added for 5.1 */
	gn_uchar_t*			devfield1;
} gnpl_result_t;

/* for arrays of generated playlist results */
typedef struct
{
	gnpl_result_t**		results;
	gn_uint32_t			count;
} gnpl_results_t;

/* handle to results returned from a playlist generation request */
typedef void* gnplaylist_results_handle_t;

/* iterator data - for browsing the database */
typedef void* gnplaylist_findinfo_t;
typedef void* gnplaylist_iterator_handle_t;

#endif /* _GN_PLAYLIST_TYPES_H_ */
