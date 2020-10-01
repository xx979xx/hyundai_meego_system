/*
 * Copyright (c) 2000 - 2005 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_local_lookup.h - Application interface definition for the "toc lookup" module.
 */


#ifndef _GN_LOCAL_LOOKUP_H_
#define _GN_LOCAL_LOOKUP_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_lookup_defs.h"
#include "gn_descriptors.h"
#include "gn_album_track_types.h"
#include "gn_dvd_video_data_types.h"


#ifdef __cplusplus
extern "C"{
#endif 



/*
 * Prototypes.
 */

/* Given a TOC, looks up an album in the local database.  The lookup will check
 * both the lookup cache and the local base + updates database.  If a match is
 * found in only one or the other location, that will be the result.  If a
 * match is found in both locations, the result will be the match with the 
 * higher revision.
 *
 * Parameters:
 *  IN: toc_str - A NULL terminated character array with the ordered TOC
 *                represented in decimal format and separated by white space.
 *      lu_options - Modifiers for the default function behavior.
 *                Can be TLOPT_Default or TLOPT_ExactOnly or TLOPT_AutoFuzzy.
 *                TLOPT_ExactOnly: Accept only exact matches to the given TOC.
 *                TLOPT_AutoFuzzy: In the event of non-exact, aka "fuzzy",
 *                    match to multiple albums, auto-select the result which is
 *                    the best match to the given TOC.
 *                TLOPT_Default: Prefer exact matches.  If no exact match is found,
 *                    try a fuzzy match.  If there are multiple fuzzy matches, all
 *                    are accessible with gnllu_select_album_match().
 *             NOTE: TLOPT_ExactOnly and TLOPT_AutoFuzzy are mutually exclusive.
 *  OUT: match_type - Indicates the type of result which was found.
 *                 If the function returns GN_SUCCESS, match_type will have one
 *                 of the following values, defined in gn_lookup_defs.h.
 *                TLMATCH_None: No match was found.
 *                TLMATCH_Exact: A single exact match was found.
 *                TLMATCH_MultiExact: Multiple exact matches were found.
 *                TLMATCH_Fuzzy: One or more fuzzy matches was found.
 *                TLMATCH_LUCache: Indicates the match came from the lookup
 *                  cache.  In this case there will be exactly one match and it
 *                  will be exact.
 *              NOTE: If TLOPT_AutoFuzzy is selected, match_type can take on
 *                  the following values.
 *                TLMATCH_None: No match was found.
 *                TLMATCH_Exact: A single exact match was found OR a single
 *                  fuzzy was found OR a multiple fuzzy matches were found and
 *                  have been resolved to a single fuzzy.
 *                TLMATCH_MultiExact: Multiple exact matches were found.
 *                TLMATCH_LUCache: Indicates the match came from the lookup
 *                  cache.  In this case there will be exactly one match and it
 *                  will be exact.
 *
 * -- If match_type != TLMATCH_LUCache and match_type != TLMATCH_None, then once a single result has been selected, if necessary,
 *    the result should be added to the lookup cache via a call to gn_lookup_cache_add_last_result().  There are two cases where this might be the case.
 *    1) Not in the cache.  In this case, just add the result.
 *    2) Version in the cache is older than version in database.
 *    You can distinguish between the two by calling gn_lookup_cache_toc_is_present().
 */
gn_error_t
gnllu_cache_and_local_toc_lookup(
	const gn_uchar_t*      toc_str,
	const gn_lu_options_t lu_options,
	gn_lu_match_t*        match_type
	);


/* General local lookup function. */
/* The value1 and value2 parameters are interpreted by the values */
/* assigned to lu_options. Values can include: */
/*		TLOPT_TOC_LOOKUP		Perform a TOC lookup. value1 == toc, value2 ignored */
/*		TLOPT_TUI_LOOKUP		Perform a TUI lookup. value1 == TUI, value2 ignored. */
/*		TLOPT_FP_LOOKUP			Perform a fingerprint lookup. value1 == fingerprint, value2 == algorithm info */
/* Assigning more than one of these values produces undefined behavior. */
/* If lu_options includes TLOPT_AutoFuzzy, exactly zero or one */
/* match will be returned, and match_type will be TLMATCH_None or TLMATCH_Exact, */
/* even if the actual lookup resulted in a fuzzy match. */
gn_error_t
gnllu_local_lookup(
	gn_edb_handle_t handle,
	gn_custr_t value1,
	gn_custr_t value2,
	gn_lu_options_t lu_options,
	gn_lu_match_t* match_type
	);

/* Select a matching album, using the 0-based match_index. */
/* Retrieve the full data for the selected result. */
gn_error_t
gnllu_lookup_match(
	gn_edb_handle_t handle,
	gn_size_t       match_index
	);

/* Get the number of matches from the last successful local lookup. */
gn_error_t
gnllu_get_match_count(
	gn_edb_handle_t handle,
	gn_size_t* match_count
	);


/* DEPRECATED
 *
 * In the current library this will only tell you if you have an exact match, 
 * which you will get from the match type returned from gnllu_local_lookup.
 *
 * If we have an album match; this will have been set by a previous call
 * to gnllu_select_album_match.  Regardless of the number of results returned
 * by the lookup, the caller has the option of using only one result and
 * treating the lookup as a single exact match.
 */
gn_error_t
gnllu_has_album_match(
	gn_edb_handle_t		handle,
	gn_bool_t*			has_match
	);


/* DEPRECATED
 *
 * In the current library this will only tell you if you have an exact match, 
 * which you will get from the match type returned from gnllu_local_lookup.
 *
 * Also, since has_match will only be tru if there is an exact match, 
 * the only possible values for index are -1 or 0.
 *
 * If we have an album match then the index will be valid, otherwise the index
 * will hold (-1) cast to an unsigned int, i.e. all of the bits will be set.
 * Regardless of the number of results returned
 * by the lookup, the caller has the option of using only one result and
 * treating the lookup as a single exact match.
 */
gn_error_t
gnllu_get_album_match_index(
	gn_edb_handle_t		handle,
	gn_bool_t*			has_match,
	gn_size_t*			index
	);


/* Get the rank of a fuzzy match from the last successful local lookup. */
/* The rank indicates the statistical proximity of the TOC being looked up */
/* and the TOC being presented as a match. */
/* The lower the rank value, the better the statistical match. */
/* A successful local lookup must be performed before this function is called. */
gn_error_t
gnllu_get_rank(
	gn_edb_handle_t handle,
	gn_size_t match_index,
	gn_int32_t* rank
	);

/* Convert all data related to the most recent successful local album lookup */
/* that is associated with "handle". */
/* "All data" includes album metadata, external IDs, phonetic data, etc. */
/* For single matches, the "match_index" parameter will be ignored. */
/* For multiple matches, use the zero-based "match_index" to convert the album */
/* metadata for a specific lookup match. Data conversion in this circumstance is */
/* intended to provide summary information for the purpose of selecting a candi- */
/* date for an single match lookup. */
/* Assign GN_TRUE to the minimum parameter when converting data for summary */
/* information display. */
gn_error_t
gnllu_convert_album_data(
	gn_edb_handle_t handle,
	gn_size_t match_index,
	gn_palbum_t* album,
	gn_bool_t minimum
	);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_LOCAL_LOOKUP_H_ */
