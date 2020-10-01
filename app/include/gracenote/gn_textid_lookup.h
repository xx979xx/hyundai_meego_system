/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_textid_lookup.h - Public API for textid lookups.
 */

#ifndef	_GN_TEXTID_LOOKUP_H_
#define _GN_TEXTID_LOOKUP_H_

/* Required headers. */
#include "gn_defines.h"

/* textid headers. */
#include "gn_textid_file_data.h"

/* Other headers. */

#include "gn_playlist_types.h"	/* for gnplaylist_entrydata_t and all other playlist data types */
#include "gn_genre.h"			/* for gn_pgenre_arr_t */

#ifdef GN_MEDIAVOCS
#include "gn_transcript_types.h"
#endif
#include "gn_displayhierarchy.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * defines
 */

/* Match types.
 *   GN_TEXTID_MATCH_TYPE_NOT_AVAILABLE Could indicate a lookup has not been
 *                                      performed.
 *   GN_TEXTID_MATCH_TYPE_NONE          No matches were found.
 *   GN_TEXTID_MATCH_TYPE_SINGLE_EXACT  A single exact match was found.
 *   GN_TEXTID_MATCH_TYPE_MULTI_EXACT   More than one exact match was found.
 *   GN_TEXTID_MATCH_TYPE_SINGLE_FUZZY  A single fuzzy match was found.
 *   GN_TEXTID_MATCH_TYPE_MULTI_FUZZY   More than one fuzzy match was found.
 */
#define GN_TEXTID_MATCH_TYPE_NOT_AVAILABLE 1
#define GN_TEXTID_MATCH_TYPE_NONE          2
#define GN_TEXTID_MATCH_TYPE_SINGLE_EXACT  3
#define GN_TEXTID_MATCH_TYPE_MULTI_EXACT   4
#define GN_TEXTID_MATCH_TYPE_SINGLE_FUZZY  5
#define GN_TEXTID_MATCH_TYPE_MULTI_FUZZY   6

/* Match sources.
 *  GN_TEXTID_MATCH_SOURCE_NONE     May indicate a lookup hasn't been performed
 *  GN_TEXTID_MATCH_SOURCE_CONTRIB  Text matched on lead performer in the contributor database
 *  GN_TEXTID_MATCH_SOURCE_GENRE    Text matched on the genre database
 *  GN_TEXTID_MATCH_SOURCE_ALBUM    Text matched on the album database
 *  GN_TEXTID_MATCH_SOURCE_COMPOSER	Text matched on a composer in the contributor database
 *  GN_TEXTID_MATCH_SOURCE_ONLINE	Text matched by online server on filename and metadata tags
 */
#define GN_TEXTID_MATCH_SOURCE_NONE			1
#define GN_TEXTID_MATCH_SOURCE_CONTRIB		2
#define GN_TEXTID_MATCH_SOURCE_GENRE		3
#define GN_TEXTID_MATCH_SOURCE_ALBUM		4
#define GN_TEXTID_MATCH_SOURCE_COMPOSER		5
#define GN_TEXTID_MATCH_SOURCE_ONLINE		6

/* Text ID Local Lookup modes.
 *   Set the following bits of the options argument of gn_textid_local_lookup
 *   to define the lookup mode.
 *
 *   GN_TEXTID_LU_FLAG_DFLT         Default behavior is described in the
 *                                  description of each flag.
 *   GN_TEXTID_LU_FLAG_EXACT_ONLY   Only look for exact matches.  By default,
 *                                  both fuzzy and exact matches are tried.
 *   GN_TEXTID_LU_FLAG_INTERACTIVE  If there are multiple matches, perform
 *                                  interactive selection. Default is
 *                                  auto-select and return 1 result.
 *   GN_TEXTID_LU_FLAG_NO_COMPOSER  Do not attempt a composer match.
 *   GN_TEXTID_LU_FLAG_NO_ALBUM     Do not attempt an album match.
 *   GN_TEXTID_LU_FLAG_MASK         bitwise 'or' of the lookup flags; Intended
 *                                  for internal use only.
 */
#define GN_TEXTID_LU_FLAG_DFLT         0x00
#define GN_TEXTID_LU_FLAG_EXACT_ONLY   0x01
#define GN_TEXTID_LU_FLAG_INTERACTIVE  0x02
#define GN_TEXTID_LU_FLAG_NO_COMPOSER  0x04
#define GN_TEXTID_LU_FLAG_NO_ALBUM     0x08
#define GN_TEXTID_LU_FLAG_MASK         0x0F

/*
 * Structures and typedefs.
 */

/* gn_textid_match_type_t: use for GN_TEXTID_MATCH_TYPE_* defines. */
typedef gn_uchar_t  gn_textid_match_type_t;

/* gn_textid_match_source_t: use for GN_TEXTID_MATCH_SOURCE_* defines. */
typedef gn_uchar_t  gn_textid_match_source_t;

/* gn_textid_lu_flags_t: use for GN_TEXTID_LU_FLAG_* defines. */
typedef gn_uchar_t  gn_textid_lu_flags_t;

/* A converted lookup result.  Accessor declarations follow. */
typedef void* gn_textid_presult_data_t;

/*
 * Function Prototypes.
 */

/* NOTE: The listed error return values may not be exhaustive.  An attempt has
 *       been made list all which originiate within the specified function.
 *       Errors originating in functions which it calls might not be listed.
 */

/* gn_textid_lookup_begin
 *   Behavior: Opens all files which might be accessed during textid lookups.
 *             If you set the minimize_file_handles configuration parameter to 
 *             true during library initialization, then this function should be
 *             called before executing one or more textid lookups.
 *
 *             This function along with gn_textid_lookup_end(), allows
 *             executing textid lookups in a batch mode while only keeping
 *             files open for the duration of the batch lookup.
 *
 *   Args: None
 *
 *   Remarks: Calling this function when minimize_file_handles has not been set
 *            will result in an error.
 *
 *            After textid lookups are complete, you should call
 *            gn_textid_lookup_end() to close all files which were opened by
 *            gn_textid_lookup_begin().
 */
gn_error_t
gn_textid_lookup_begin(void);

/* gn_textid_lookup_end
 *   Behavior: Closes all files which were opened by gn_texid_lookup_begin().
 *             If you set the minimize_file_handles configuration parameter to 
 *             true during library initialization, then this function should be
 *             called after completion of a batch of textid lookups.
 *
 *   Args: None
 *
 *   Remarks: Calling this function when minimize_file_handles has not been set
 *            will result in an error.
 */
gn_error_t
gn_textid_lookup_end(void);

/* gn_textid_local_lookup
 *   Behavior: Given text information extracted from the file name and metadata
 *             tags and supplied through the 'lookup_info' argument, retrieves
 *             the associated metadata from the local database.  This function
 *             will clean up after the previous lookup if necessary.
 *
 *   Args: IN: lookup_info - Contains information supplied by the caller used
 *               by the lookup function.
 *         IN: flags - The meanings of the flag bits are defined by the
 *               GN_TEXTID_LU_FLAG_ macros.
 *         OUT: match_source - The available values are defined by the
 *               GN_TEXTID_MATCH_SOURCE_* macros.
 *         OUT: match_type - The available values are defined by the
 *               GN_TEXTID_MATCH_TYPE_* macros.
 *         OUT: match_count - Indicates the number of matching database entries
 *               returned. If match_type is
 *                 GN_TEXTID_MATCH_TYPE_SINGLE this will be 1.  If match_type is
 *                 GN_TEXTID_MATCH_TYPE_NONE this will be 0.
 *
 *   Remarks: After calling this function, results from a previous lookup will
 *            no longer be available.
 *
 *   Return values: Output args only have meaning if GN_SUCCESS is returned.
 *                  Errors which can originate in this function are
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_InvalidArg indicates one of the pointer
 *                     arguments was GN_NULL.
 *                   - GNTEXTIDERR_UnknownLookupOption indicates an
 *                     unrecognized value for options.
 *                   - GNTEXTIDERR_UnknownMatchType indicates the match type
 *                     returned by the low level lookup
 *                     subsystem was not recognized by the textid system. This
 *                     indicates a bug.
 *                   - GNTEXTIDERR_ExactLookupFailed indicates that a single
 *                     result was returned from the text lookup, but the ID
 *                     lookup attempted on that result failed.
 *                     text lookup result returned no results.
 *                   - GNTEXTIDERR_InternalError indicates an internal library
 *                     error, e.g. the interactive flag was not specified but a
 *                     multi-fuzzy match was returned by the database.
 */
gn_error_t
gn_textid_local_lookup(
	const gn_pfile_data_t		lookup_info,
	const gn_textid_lu_flags_t	flags,
	gn_textid_match_source_t*	match_source,
	gn_textid_match_type_t*		match_type,
	gn_uint32_t*				match_count
);


/*	Online lookup options for the 'flags' argument of gn_textid_online_lookup to define
 *	the online lookup mode.  For now there is only one option: accept the single lookup
 *	result as the best.  This will be the default.
 */
typedef gn_uchar_t	gn_textid_online_lu_flags_t;

#define GN_TEXTID_ONLINE_LU_FLAG_DFLT			(gn_textid_online_lu_flags_t)0x00
	/*	New option flags may be introduced later if needed.  Flags will follow a bit mask
	 *	patern so they can be or'ed together.
	 */


/*	gn_textid_online_lookup
*
 *	Behavior: Given text information extracted from the file name and metadata tags and
 *	supplied through the 'lookup_info' argument, retrieves the associated metadata from an
 *	online database.  This function will clean up after the previous lookup if necessary.
 *
 *	Args:
 *		IN: lookup_info - Contains information supplied by the caller used
 *				by the lookup function.
 *		IN: flags - The meanings of the flag bits are defined by the
 *				GN_TEXTID_ONLINE_LU_FLAG_ macros.
 *		OUT: match_source - The available values are defined by the
 *				GN_TEXTID_MATCH_SOURCE_* macros.
 *		OUT: match_type - The available values are defined by the
 *				GN_TEXTID_MATCH_TYPE_* macros.
 *		OUT: match_count - Indicates the number of matching database entries
 *				returned. If match_type is
 *					GN_TEXTID_MATCH_TYPE_SINGLE this will be 1.  If match_type is
 *					GN_TEXTID_MATCH_TYPE_NONE this will be 0.
 *		OUT: list_update_required - Upon successful return, this will indicate whether
 *			or not the currently installed list and list dependent databases
 *			require updating. If this is GN_TRUE upon return, then it is suggested
 *			that you call gnolu_update_list_data() prior to getting the result strings.
 *
 *	Remarks: After calling this function, results from any previous lookup (either
 *	gn_textid_online_lookup or gn_textid_local_lookup) will no longer be available.
 *
 *	The operation of updating list data may take some time which could, for example, adversely
 *	affect the responsiveness of a GUI in which lookuk results are presented. Because of this,
 *	it is possible to convert the album data without updating the lists. However, doing so may
 *	lead to some display strings being unavailable.
 *
 *	Return values: Output args only have meaning if GN_SUCCESS is returned.
 *	Errors which can originate in this function are
 *
 *	GNTEXTIDERR_UnsupportedFunctionality
 *			The emms library is not configured for online lookups.
 *
 *	GNTEXTIDERR_NotInited
 *			indicates the textid subsystem is not initialized for lookups.
 *
 *	GNTEXTIDERR_InvalidArg
 *			indicates one of the pointer arguments was GN_NULL.
 *
 *	GNTEXTIDERR_UnknownLookupOption
 *			indicates an unrecognized value for options.
 *
 *	GNTEXTIDERR_UnknownMatchType
 *			indicates the match type returned by the low level lookup subsystem was not
 *			recognized by the textid system.  This indicates a bug.
 *
 *	GNTEXTIDERR_ExactLookupFailed
 *			indicates that a single result was returned from the text lookup, but the ID
 *			lookup attempted on that result failed.  Text lookup result returned no results.
 *
 *	GNTEXTIDERR_InternalError
 *			indicates an internal library error, e.g. the interactive flag was not specified
 *			but a multi-fuzzy match was returned by the database.
 */
gn_error_t
gn_textid_online_lookup(
	const gn_pfile_data_t				lookup_info,
	const gn_textid_online_lu_flags_t	flags,
	gn_textid_match_source_t*			match_source,
	gn_textid_match_type_t*				match_type,
	gn_uint32_t*						match_count,
	gn_bool_t*							list_update_required
	);


/* gn_textid_cleanup_lookup
 *   Behavior: Cleans up (releases memory, etc) the most recent call to
 *             gn_textid_local_lookup().
 *
 *   Remarks: It is not necessary to call this function.  Cleanup is also
 *            performed as the first step of a lookup if necessary, and also
 *            when the textid system is shut down, which happend with
 *            gninit_shutdown_emms(). This function is available to allow
 *            freeing the memory between lookups if desired.
 *
 *   Return values: Errors which can originate in this function are
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 &                     not initialized for lookups.
 */
gn_error_t
gn_textid_cleanup_lookup(void);

/* gn_textid_get_matched_string_at_index
 *   Behavior: Hands back in the output argument the string on which a text
 *             match was made.
 *   Args: IN: index - The 1-based index of the result to examine.  This value must
 *                     satisfy (1 <= index <= match_count) where match_count is
 *                     the value handed back by gn_textid_local_lookup().
 *         OUT: matched_str - The matched string.
 *   Remarks: The matched string is the  string in the Gracenote TextID database system
 *				that most closely matched one of the lookup_info fields.  It may be
 *				an official or alternate representation of a Gracenote Normalized contributor
 *				name, composer name or album title.
 *
 *				This should only be called if match_source returned by the lookup was neither  
 *				GN_TEXTID_MATCH_SOURCE_NONE nor GN_TEXTID_MATCH_SOURCE_GENRE.
 */
gn_error_t
gn_textid_get_matched_string_at_index(
	const gn_uint32_t	index,
	const gn_uchar_t**	matched_str
);

/* gn_textid_get_correlation_at_index
 *   Behavior: Hands back in the output argument the correlation between the
 *             matched string and the Gracenote Normalized string.
 *   Args: IN: index - The 1-based index of the result to examine.  This value must
 *                     satisfy (1 <= index <= match_count) where match_count is
 *                     the value handed back by gn_textid_local_lookup().
 *         OUT: matched_correlation - The correlation value.  
 */
gn_error_t
gn_textid_get_correlation_at_index(
	const gn_uint32_t	index,
	gn_uint32_t*		matched_correlation
);

/* gn_textid_get_secondary_match_source_at_index
 *   Behavior: Hands back in the output argument the secondary match source.
 *   Args: IN: index - The 1-based index of the result to examine.  This value must
 *                     satisfy (1 <= index <= match_count) where match_count is
 *                     the value handed back by gn_textid_local_lookup().
 *         OUT: match_source - The match source. GN_TEXTID_MATCH_SOURCE_CONTRIB
 *						or GN_TEXTID_MATCH_SOURCE_NONE.
 *	Remarks: Currently only a primary match source of GN_TEXTID_MATCH_SOURCE_COMPOSER
 *			can produce a secondary match source.  The only possible secondary match 
 *			source is GN_TEXTID_MATCH_SOURCE_CONTRIB.  If no secondary match
 *			occurred, GN_TEXTID_MATCH_SOURCE_NONE is returned.
 *
 */
gn_error_t
gn_textid_get_secondary_match_source_at_index(
	 const gn_uint32_t			index,
	 gn_textid_match_source_t*	match_source
);

/* gn_textid_get_secondary_matched_string_at_index
 *   Behavior: Hands back in the output argument the string on which a secondary text
 *             match was made.
 *   Args: IN: index - The 1-based index of the result to examine.  This value must
 *                     satisfy (1 <= index <= match_count) where match_count is
 *                     the value handed back by gn_textid_local_lookup().
 *         OUT: matched_str - The matched string.
 *   Remarks: The secondary match string is the  string in the Gracenote TextID database system
 *				that was a secondary match to one of the lookup_info fields.  A secondary match
 *              helps provide richer Gracenote metadata and/or disambiguate multiple results.
 *				Currently, secondary matches only occur on official or alternate representation 
 *				of a Gracenote Normalized composer name.
 *
 *			  Should only be called if a call to gn_textid_get_secondary_match_source_at_index
 *				yielded a match_source equal to GN_TEXTID_MATCH_SOURCE_CONTRIB.
 */
gn_error_t
gn_textid_get_secondary_matched_string_at_index(
	const gn_uint32_t	index,
	const gn_uchar_t**	matched_str
);

/* gn_textid_get_secondary_correlation_at_index
 *   Behavior: Hands back in the output argument the correlation between a
 *				secondary input string used in matching and a Gracenote 
 *				Normalized string.
 *   Args: IN: index - The 1-based index of the result to examine.  This value must
 *                     satisfy (1 <= index <= match_count) where match_count is
 *                     the value handed back by gn_textid_local_lookup().
 *         OUT: matched_correlation - The correlation value. 
 *   Remarks: Should only be called if a call to gn_textid_get_secondary_match_source_at_index
 *				yielded a match_source equal to GN_TEXTID_MATCH_SOURCE_CONTRIB.
 */
gn_error_t
gn_textid_get_secondary_correlation_at_index(
	const gn_uint32_t	index,
	gn_uint32_t*		matched_correlation
);

/*	MARK: DEPRECATED - gn_textid_result_to_mldb_entrydata
 *
 *	This api has been deprecated.
 *
 *	This function does not support entrydata updates for older MLDBs
 *	It is recomended that you use the new gn_textid_result_to_entrydata api instead.
 *
 *   Behavior: Adds the relevant members of the chosen gn_textid_local_lookup()
 *             result to the given gn_pfile_data_t struct and then uses that
 *             data to construct a new gnplaylist_entrydata_t suitable for
 *             adding to the MLDB via gnplaylist_addentry().
 *             If index is 0, no lookup result data will be added; only the
 *             gn_pfile_data_t object will be used to construct the MLDB entry.
 *
 *             The returned object, entry_data, must eventually be freed with
 *             by the caller by gnplaylist_freeentry().
 *
 *             If the primary match source GN_TEXTID_MATCH_SOURCE_COMPOSER,
 *             the composer information overrides any lead performer contributor 
 *             information in the Playlist entry data structure.
 *            
 *             NOTE: This function should only be called with a single index
 *                   for a given lookup, i.e. for a given file_data object.
 *
 *   Args: IN: index - The 1-based index of the result to add to file_data.  To
 *                     add a lookup result, this value must be in the range
 *                     (1 <= index <= match_count) where match_count is the
 *                     value handed back by gn_textid_local_lookup().
 *                     A value of 0 indicates that only file_data will be used
 *                     to create entry_data. This is useful to create an MLDB
 *                     entry even in the event that the textid lookup failed to
 *                     find a match.
 *             file_data - The gn_pfile_data_t structure which was used in the
 *                         call to gn_textid_local_lookup().
 *         OUT: entry_data - The gnplaylist_entrydata_t structure constructed
 *                           from file_data and the lookup result.
 *
 *   Return values: No assumptions should be made regarding whether the data
 *                  has been added to entry_data unless GN_SUCCESS is returned.
 *                  Errors which can originate in this function are
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_TextidResultNotAvailable indicates that a
 *                     lookup has not been performed since initialization or
 *                     since the last call to gn_textid_cleanup_lookup.
 *                   - GNTEXTIDERR_TextidResultOutOfRange indicates
 *                     (index >= match_count).
 *                   - GNTEXTIDERR_InvalidArg probably indicates file_data or
 *                     entry_data is GN_NULL
 */
gn_error_t
gn_textid_result_to_mldb_entrydata(
	const gn_uint32_t		index,
	gn_pfile_data_t			file_data,
	gnplaylist_entrydata_t*	entry_data
);


/*	gn_textid_result_to_entrydata
 *
 *	This function replaces the older gn_textid_result_to_mldb_entrydata which has been deprecated.
 *
 *	Constructs a new Playlist entry data structure from a specified result of the most recent
 *	text-based music lookup, after adding its relevant members to the gn_pfile_data_t structure
 *	supplied as the file_data parameter. The resulting entry data structure is suitable for adding
 *	to an mldb with gnplaylist_addentry.
 *
 *	If the last text-based music lookup returned a primary match source of
 *	GN_TEXTID_MATCH_SOURCE_COMPOSER, the composer information overrides any lead performer
 *	contributor information in the entry data structure.
 *
 *	Because this function modifies the file_data structure, it should be called only on a single
 *	lookup result. If the previous text-based music lookup produced multiple matches, you should
 *	resolve the match to the one desired result before calling this function.
 *
 *	Memory allocated for the entry_data object is owned by the caller.  When no longer needed, it
 *	must be freed with gnplaylist_freeentry.
 *
 *	Parameters:
 *		collection_id:
 *			The ID of the MLDB for which the entrydata is intended.  Necessary for backward
 *			compatibility version support when updating older MLDBs.  If the collection_id is
 *			not known then use GN_INVALID_COLLECTION_ID for current MLDB version support.
 *
 *		index:
 *			Index (1 based) of lookup result to convert to an MLDB entry. Must be in the
 *			range (1 <= index <= match_count), where match_count is the match count value
 *			returned by the last text-based music lookup.
 *
 *			A value of 0 indicates that only the file_data parameter should be used to create
 *			the entry data structure, without reference to the results of any previous lookup.
 *			This is useful for creating an MLDB entry from available data even in the event
 *			that a text-based music lookup did not return a match.
 *
 *		file_data:
 *			Lookup information used in previous text-based music lookup.
 *
 *		entry_data:
 *			The gnplaylist_entrydata_t structure constructed from file_data and the lookup
 *			result.
 *
 *	Return values:
 *		GN_SUCCESS
 *			No errors encountered. No assumptions should be made regarding whether the data
 *			has been added to entry_data unless GN_SUCCESS is returned.
 *
 *		GNTEXTIDERR_NotInited
 *			TextID subsystem not initialized for lookups.
 *
 *		GNTEXTIDERR_TextidResultNotAvailable
 *			No lookup performed since initialization or last TextID cleanup.
 *
 *		GNTEXTIDERR_TextidResultOutOfRange
 *			The index exceeds the match count from last text-based music lookup.
 *
 *		GNTEXTIDERR_InvalidArg
 *			Null pointer supplied for file_data or entry_data parameter.
 */
gn_error_t
gn_textid_result_to_entrydata(
	gn_collection_id_t		collection_id,
	const gn_uint32_t		index,
	gn_pfile_data_t			file_data,
	gnplaylist_entrydata_t*	entry_data
	);
	
/* gn_textid_get_result
 *   Behavior: Returns the selected member of the results returned by the most
 *             recent call to gn_textid_local_lookup() in a form suitable for
 *             input to calls to the accessor functions,
 *               gn_textid_get_...(gn_textid_presult_data_t, &result).
 *             Memory allocated to result is owned by the caller. You must free
 *             it with a call to gn_textid_free_result().
 *
 *   Args: IN: index - The 1-based index of the result to get.  This value must
 *                     satisfy (1 <= index <= match_count) where match_count is
 *                     the value handed back by gn_textid_local_lookup().
 *         OUT: result - The results data which is handed back.
 *
 *   Remarks: If the match type was GN_TEXTID_MATCH_TYPE_MULTI_FUZZY, the
 *            results are sorted by quality of match, with lower values of
 *            index being better (higher correlation).
 *
 *   Return values: The value handed back in result only has meaning if
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_TextidResultNotAvailable indicates that a
 *                     lookup has not been performed since initialization or
 *                     since the last call to gn_textid_cleanup_lookup().
 *                   - GNTEXTIDERR_TextidResultOutOfRange indicates
 *                     (index >= match_count).
 *                   - GNTEXTIDERR_InvalidArg probably indicates
 *                     (result == GN_NULL)
 *                   - GNTEXTIDERR_ExactLookupFailed indicates that an ID
 *                     lookup attempted on the specified text lookup result
 *                     returned no results.
 *                   - GNTEXTIDERR_NoMemory indicates *result could not be
 *                     allocated.
 */
gn_error_t
gn_textid_get_result(
	const gn_uint32_t         index,
	gn_textid_presult_data_t* result
);

/* gn_textid_free_result
 *   Behavior: Releases all memory held by the given gn_textid_presult_data_t
 *             instance and sets it to GN_NULL. If *result = GN_NULL on input,
 *             no action is taken and GN_SUCCESS is returned.
 *
 *   Args: result - The instance to be freed.
 *
 *   Remarks: If this instance is still owned by the transaction handle, it
 *            will be cleaned up there as well.
 *
 *   Return values: The value handed back in target only has meaning if
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are
 *                   - GNTEXTIDERR_InvalidArg indicates that result = GN_NULL
 */
gn_error_t
gn_textid_free_result(
	gn_textid_presult_data_t* result
);

/*
 * Accessors for a converted lookup result.
 */

/*** The following applies to all gn_textid_presult_data_t accessors.
 *
 *   Behavior: Hands back in an output argument a requested piece of data
 *             available via a given gn_textid_presult_data_t instance.
 *
 *   Args: IN: result - The gn_textid_presult_data_t from which to get the data.
 *         OUT: The output argument used to hand back the requested data.
 *
 *   Remark: Not all possible data will be available for a given lookup result.
 *           If a requested piece of information is not present in the result
 *           structure.  In such circumstances, if the output argument is a string
 *           value it will be set to GN_NULL. If the output argument is an integer
 *			 value then it will be set to 0.  In both cases GN_SUCCESS will be
 *			 returned unless there exists another error condition.
 *
 * NOTE: Only the orthography and genre array accessors allocates memory
 *       which must be freed by the caller.
 *       All of the other accessors which follow return references to objects
 *       owned by a gn_textid_presult_data_t instance.
 *       The data retrieved by these accessors should not be freed, and the
 *       containing gn_textid_presult_data_t instance should not be freed as
 *       long as the data is needed
 *
 *   Return values: The value handed back in the output argument only has
 *                  meaning if GN_SUCCESS is returned.
 *                  Errors which can originate in these functions are
 *                   - GNTEXTIDERR_InvalidArg indicates that one of the
 *                     arguments == GN_NULL
 *					 - GNTEXTIDERR_BadMatchSource - indicates that the match
 *                     source was not one of the allowed values for the
 *                     accessor.  This error indicates that an accessor
 *                     function is being called incorrectly.
 */

/* gn_textid_get_mapped_genre_string
 *   Behavior: Hands back in the output argument the Gracenote genre string of
 *             the given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_GENRE.
 *           If match_source was GN_TEXTID_MATCH_SOURCE_CONTRIB, the genre
 *           associated with the matched contributor can be retrieved with
 *           gn_textid_get_contributor_genre().
 *
 *           If match_source was GN_TEXTID_MATCH_SOURCE_ALBUM, the genre
 *           associated with the matched contributor can be retrieved with
 *           gn_textid_get_album_genre().
 */
gn_error_t
gn_textid_get_mapped_genre_string(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             genre_str
);

/* gn_textid_get_contributor_genre
 *   Behavior: Hands back in the output argument the contributor genre of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the primary or secondary
 *    match source is GN_TEXTID_MATCH_SOURCE_CONTRIB
 */
gn_error_t
gn_textid_get_contributor_genre(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             contributor_genre
);

/* gn_textid_get_album_genre
 *   Behavior: Hands back in the output argument the album genre of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_genre(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             album_genre
);

/* gn_textid_get_contributor_era
 *   Behavior: Hands back in the output argument the contributor era of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_CONTRIB (primary or secondary),
 *           GN_TEXTID_MATCH_SOURCE_ONLINE, or
 *           or GN_TEXTID_MATCH_SOURCE_ALBUM (primary only).
 */
gn_error_t
gn_textid_get_contributor_era(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             contributor_era
);

/* gn_textid_get_contributor_origin
 *   Behavior: Hands back in the output argument the contributor origin of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_CONTRIB (primary or secondary),
 *           GN_TEXTID_MATCH_SOURCE_ONLINE, or
 *           GN_TEXTID_MATCH_SOURCE_ALBUM (primary only).
 */
gn_error_t
gn_textid_get_contributor_origin(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             contributor_origin
);

/* gn_textid_get_contributor_type
 *   Behavior: Hands back in the output argument the contributor type of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_CONTRIB (primary or secondary),
 *           GN_TEXTID_MATCH_SOURCE_ONLINE, or
 *           GN_TEXTID_MATCH_SOURCE_ALBUM (primary only).
 */
gn_error_t
gn_textid_get_contributor_type(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             contributor_type
);

/*	gn_textid_get_contributor_keyedvalue
 *    Behavior: Returns a pointer to an indicated value associated with the
 *              matched contributor.
 *
 *	Parameters not described above.
 *      key    A string indicating which associated value to fetch
 *
 *  The available "key" types are application dependent. Those available to
 *  your application will be communicated to you directly.
 *
 *  Remark: This data is available only if the primary or secondary
 *   match source is GN_TEXTID_MATCH_SOURCE_CONTRIB
 */
gn_error_t
gn_textid_get_contributor_keyedvalue(
	const gn_textid_presult_data_t result,
	const gn_uchar_t*              key,
	const gn_uchar_t**             value
);

/* gn_textid_get_album_release_year
 *   Behavior: Hands back in the output argument the album release year of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *          GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_release_year(
	const gn_textid_presult_data_t result,
	gn_uint32_t*                   album_release_year
);

/* gn_textid_get_album_track_count
 *   Behavior: Hands back in the output argument the track count of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE
 */
gn_error_t
gn_textid_get_album_track_count(
	const gn_textid_presult_data_t result,
	gn_uint32_t*                   track_count
);

/*	gn_textid_get_album_primary_credit_keyedvalue
 *    Behavior: Returns a pointer to an indicated value associated with the
 *              primary artist of the matched album.
 *
 *	Parameters not described above.
 *      key    A string indicating which associated value to fetch
 *
 *  The available "key" types are application dependent. Those available to
 *  your application will be communicated to you directly.
 *
 *  Remark: This data is available only if the match_source was
 *          GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_primary_credit_keyedvalue(
	const gn_textid_presult_data_t result,
	const gn_uchar_t*              key,
	const gn_uchar_t**             value
);

/*	gn_textid_get_album_title_keyedvalue
 *    Behavior: Returns a pointer to an indicated value associated with the
 *              title of the matched album.
 *
 *	Parameters not described above.
 *      key    A string indicating which associated value to fetch
 *
 *  The available "key" types are application dependent. Those available to
 *  your application will be communicated to you directly.
 *
 *  Remark: This data is available only if the match_source was
 *          GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_title_keyedvalue(
	const gn_textid_presult_data_t result,
	const gn_uchar_t*              key,
	const gn_uchar_t**             value
);

/* gn_textid_get_album_tagid
 *   Behavior: Hands back in the output argument the album's tagid of the
 *             given gn_textid_presult_data_t instance.
 *
 *  Remark: This data is available only if the match_source was
 *          GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_tagid(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             tagid
);

/* gn_textid_get_composer_genre
 *   Behavior: Hands back in the output argument the composer genre of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the primary match_source 
 *          was GN_TEXTID_MATCH_SOURCE_COMPOSER.
 */
gn_error_t
gn_textid_get_composer_genre(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             composer_genre
);

/* gn_textid_get_composer_era
 *   Behavior: Hands back in the output argument the composer era of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the primary match_source 
 *			was GN_TEXTID_MATCH_SOURCE_COMPOSER.
 */
gn_error_t
gn_textid_get_composer_era(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             composer_era
);

/* gn_textid_get_composer_origin
 *   Behavior: Hands back in the output argument the composer origin of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the primary match source
 *			 was GN_TEXTID_MATCH_SOURCE_COMPOSER.
 */
gn_error_t
gn_textid_get_composer_origin(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             composer_origin
);

/* gn_textid_get_composer_type
 *   Behavior: Hands back in the output argument the composer type of the
 *             given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the primary match source
 *			 was GN_TEXTID_MATCH_SOURCE_COMPOSER.
 */
gn_error_t
gn_textid_get_composer_type(
	const gn_textid_presult_data_t result,
	const gn_uchar_t**             composer_type
);

/*	gn_textid_get_composer_keyedvalue
 *    Behavior: Returns a pointer to an indicated value associated with the
 *              matched contributor.
 *
 *	Parameters not described above.
 *      key    A string indicating which associated value to fetch
 *
 *  The available "key" types are application dependent. Those available to
 *  your application will be communicated to you directly.
 *
 *  Remark: This data is available only if the primary match source
 *			 was GN_TEXTID_MATCH_SOURCE_COMPOSER.
 */
gn_error_t
gn_textid_get_composer_keyedvalue(
	const gn_textid_presult_data_t result,
	const gn_uchar_t*              key,
	const gn_uchar_t**             value
);

/* gn_textid_get_primary_artist_representation_array
 *
 *
 *   Access the array of orthographies related to the contributor or the
 *   album's primary contributor matched in the most recent textid lookup.
 *
 *   Note that primary artist orthographies will be available if the primary or secondary
 *   match source is GN_TEXTID_MATCH_SOURCE_CONTRIB, or the primary match source is
 *   GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 *
 */
gn_error_t
gn_textid_get_primary_artist_representation_array(
	const gn_textid_presult_data_t result,
	gn_prep_array_t* const         representation_array
);

/* gn_textid_get_album_title_representation_array
 *
 *
 *   Access the array of orthographies related to the album title matched
 *   in the most recent textid lookup.
 *
 *   Note that contributor orthographies will only be available if the primary match
 *   source is GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_title_representation_array(
	const gn_textid_presult_data_t result,
	gn_prep_array_t* const         representation_array
);

/* gn_textid_get_composer_representation_array
 *
 *   Access the array of orthographies related to the contributor or the
 *   album's composer matched in the most recent textid lookup.
 *
 *   Note that contributor orthographies will only be available if the
 *   primary match source is GN_TEXTID_MATCH_SOURCE_COMPOSER.
 */
gn_error_t
gn_textid_get_composer_representation_array(
	const gn_textid_presult_data_t result,
	gn_prep_array_t* const         representation_array
);

#ifdef GN_MEDIAVOCS
/*
 *	MediaVOCS provides phonetic transcriptions in a target spoken language for use in an
 *	ASR/TTS system and also provides support for the recognition of alternate phrases.
 */

/*	gn_textid_cache_alternate_phrases
 *
 *	Add alternate phrases for artist and album to the APM cache.  The result data
 *	from the most recent TextID lookup must be from a GN_TEXTID_MATCH_SOURCE_ALBUM,
 *	GN_TEXTID_MATCH_SOURCE_ONLINE, GN_TEXTID_MATCH_SOURCE_CONTRIB, or
 *  GN_TEXTID_MATCH_SOURCE_COMPOSER match source.
 *
 *	This function is typically called after a successful textid lookup.
 *	See gn_textid_local_lookup() and gn_textid_get_result().  Phrases are retrieved from
 *	the cache with gn_apm_get_official_phrase_array().
 *
 *	Error Return:
 *		GN_SUCCESS		Alternate phrases were written to the cache.
 *
 *		GNTEXTIDERR_UnsupportedFunctionality
 *						Your configuration does not support this operation.
 *
 *		GNTEXTIDERR_InvalidArg
 *						The parameter is not a proper textid result.
 *
 *		GNTEXTIDERR_BadMatchSource
 *						The textid result is neither a GN_TEXTID_MATCH_SOURCE_ALBUM,
 *						GN_TEXTID_MATCH_SOURCE_ONLINE, GN_TEXTID_MATCH_SOURCE_CONTRIB,
 *                      nor a GN_TEXTID_MATCH_SOURCE_COMPOSER match source.
 *
 *		GNAPMERR_NotInited
 *						The APM cache system has not been initialized.
 *
 *		GNAPMERR_NoMemory
 *						There is not enough memory to complete this request.
 *
 *		DBERR_NoSpace
 *						There is not enough file space to write the APM cache.
 *
 *	This function is available only in configurations that support MediaVOCS.
 */
gn_error_t
gn_textid_cache_alternate_phrases(
	const gn_textid_presult_data_t	result
);
#endif	/* GN_MEDIAVOCS */

/*	gn_textid_get_genre_array
 *
 *	Get the genre array associated with the textid result..
 *	Call this function when populating your ASR/TTS dictionaries and grammars.
 *
 *	Parameters
 *		result:			The textid result object containing the genre.
 *		genre_array:	A pointer to the genre array. This memory for this
 *						array is owned by the caller. Call the function
 *						gn_genre_array_smart_free to free the allocated array.
 *
 *	Error Return
 *		GN_SUCCESS				The genre array was successfully retrieved.
 *		GNTEXTIDERR_InvalidArg	At least one of the parameters is a NULL
 *								pointer.
 *		GNLISTSERR_NotInited	The list subsystem has not been initialized.
 *		GNLISTSERR_NoMemory		Memory allocation error.
 *		GNLISTSERR_NotFound		Display information does not exist for the
 *								genre master ID.
 *
 *	Remarks:
 *		The function will allocate memory internally the for gn_pgenre_arr_t.
 *		The caller must free genre_array by calling gn_genre_array_smart_free.
 *		If the error return value is GN_SUCCESS, then the *genre_array value
 *		will not be GN_NULL.
 *		If the error return value is not GN_SUCCESS, then the *genre_array
 *		value is indeterminate.
 *		The match source value associated with the textid result can be
 *		GN_TEXTID_MATCH_SOURCE_CONTRIB, GN_TEXTID_MATCH_SOURCE_COMPOSER,
 *		GN_TEXTID_MATCH_SOURCE_GENRE, GN_TEXTID_MATCH_SOURCE_ALBUM,
 *      or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_genre_array(
	const gn_textid_presult_data_t	result,
	gn_pgenre_arr_t*				genre_array
);

/*  gn_textid_get_album_artist_match_confidence
 *    Behavior: Returns a pointer to a value indicating the album match confidence.  
 *      The match confidence is based on the similarity
 *      between the lookup_info, also passed into gn_textid_local_lookup(), and the 
 *      album results's artist information.
 *
 *   Args: IN: file_data - The gn_pfile_data_t structure which was used in the
 *                         call to gn_textid_local_lookup().
 *             result - The gn_textid_presult_data_t fetched after the lookup.
 *
 *         OUT: confidence - The confidence of the album match at the specified index.
 *
 *  Remark: This data is available only if the match_source was
 *          GN_TEXTID_MATCH_SOURCE_ALBUM.
 *
 *          Album lookup results are sorted by confidence, therefore, the first result,
 *          index 1 is guaranteed to have the highest confidence level.
 *   Return values: The value handed back in result only has meaning if 
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are:
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_InvalidArg indicates one of the parameters 
 *                     was invalid. 
 *
 */
gn_error_t
gn_textid_get_album_artist_match_confidence(
		const gn_pfile_data_t			file_data,
		const gn_textid_presult_data_t  result,
		gn_uint32_t*					confidence
);

/* gn_textid_result_match_source
 *   Behavior: Gets the match source of the result.
 *
 *   Args: IN:  result - The gn_textid_presult_data_t fetched after the lookup.
 *
 *         OUT: match_source - The match source of the lookup.
 *              
 *
 *   Remarks: This function is useful for determining the match source of the result, 
 *            after the lookup has taken place.
 *            This function should also be used to determine if the result of 
 *            gn_textid_browse_fetch_result_data is a composer or lead performer.
 *
 *   Return values: The value handed back in result only has meaning if 
 *                  GN_SUCCESS is returned.
 *                  Errors which can originate in this function are:
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_InvalidArg indicates one of the parameters 
 *                     was invalid.
 */
gn_error_t
gn_textid_get_result_match_source(
	const gn_textid_presult_data_t  result,
	gn_textid_match_source_t*		match_source
);

/*
 * MARK: -
 * MARK: Deprecated Functions
 * MARK: -
 *
 * MARK: Deprecated: Fetching the official name or official title
 *
 * The following functions fetch either an official contributor name or album title.  They have been deprecated
 * in favor of the representation array.  Calling these functions results in a the full result being fetched
 * and thus has an impact on performance.
 *
 * For presenting the user with a listing of matches, it is better to call gn_textid_get_matched_string_at_index()
 * since this likely to present a string closer to the one in the input data (for example if an alternate
 * or nickname was matched, that string is fetched instead of the official name).
 *
 * To fetch the official representation, first fetch the full result using gn_textid_get_result()
 * and then fetch the appropriate representation array.
 */

/* gn_textid_result_get_contributor_name
 *   Behavior: Returns the official contributor name for the selected
 *             gn_textid_local_lookup() result. The returned contributor_name
 *             must be freed with gn_textid_result_free_contributor_name().
 *
 *   Args: IN: index - The 1-based index of the result. This value must satisfy
 *                     (1 <= index <= match_count) where match_count is the
 *                     value handed back by gn_textid_local_lookup().
 *         OUT: contributor_name - The official contributor name.
 *
 *   Return values: Errors which can originate in this function are
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_TextidResultNotAvailable indicates that a
 *                     lookup has not been performed since initialization or
 *                     since the last call to gn_textid_cleanup_lookup().
 *                   - GNTEXTIDERR_TextidResultOutOfRange indicates
 *                     (index >= match_count).
 *                   - GNTEXTIDERR_InvalidArg probably indicates that
 *                     contributor_name is GN_NULL.
 *                   - GNTEXTIDERR_BadMatchType indicates that match_source
 *                   - was not GN_TEXTID_MATCH_SOURCE_CONTRIB
 *
 *   Remark: This data is only available if match_source was
 *           GN_TEXTID_MATCH_SOURCE_CONTRIB.
 */
gn_error_t
gn_textid_result_get_contributor_name(
	const gn_uint32_t index,
	gn_uchar_t**      contributor_name
);

/* gn_textid_result_free_contributor_name
 *   Behavior: Frees a contributor name retrieved via
 *             gn_textid_result_get_contributor_name().
 *
 *   Args: IN: contributor_name - The contributor name.
 *
 *   Return values: Errors which can originate in this function are
 *                   - GNTEXTIDERR_InvalidArg probably indicates
 *                     contributor_name is GN_NULL.
 */
gn_error_t
gn_textid_result_free_contributor_name(
	gn_uchar_t** contributor_name
);

/* gn_textid_result_get_album_title
 *
 *   Behavior: Returns the official album title for the selected
 *             gn_textid_local_lookup() result. The returned album_name
 *             must be freed with gn_textid_result_free_album_title().
 *
 *   Args: IN: index - The 1-based index of the result. This value must satisfy
 *                     (1 <= index <= match_count) where match_count is the
 *                     value handed back by gn_textid_local_lookup().
 *         OUT: album_title - The official contributor name.
 *
 *   Return values: Errors which can originate in this function are
 *                   - GNTEXTIDERR_NotInited indicates the textid subsystem is
 *                     not initialized for lookups.
 *                   - GNTEXTIDERR_TextidResultNotAvailable indicates that a
 *                     lookup has not been performed since initialization or
 *                     since the last call to gn_textid_cleanup_lookup().
 *                   - GNTEXTIDERR_TextidResultOutOfRange indicates
 *                     (index >= match_count).
 *                   - GNTEXTIDERR_InvalidArg probably indicates that
 *                     album_title is GN_NULL.
 *                   - GNTEXTIDERR_BadMatchType indicates that match_source
 *                   - was not GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 *
 *   Remark: This data is only available if match_source was
 *           GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_result_get_album_title(
	const gn_uint32_t index,
	gn_uchar_t**      album_title
);

/* gn_textid_result_free_album_title
 *
 *   Behavior: Frees an album title retrieved via
 *             gn_textid_result_get_album_title().
 *
 *   Args: IN: album_title - The album title.
 *
 *   Return values: Errors which can originate in this function are
 *                   - GNTEXTIDERR_InvalidArg probably indicates
 *                     album_title is GN_NULL.
 */
gn_error_t
gn_textid_result_free_album_title(
	gn_uchar_t** album_title
);

/*
 * MARK: Deprecated: Result based accessors
 */

/* gn_textid_get_matched_string
 *
 * deprecated in favor of gn_textid_get_matched_string_at_index
 *
 *   Behavior: Hands back in the output argument the string on which a text
 *             match was made.
 */
gn_error_t
gn_textid_get_matched_string(
	const gn_textid_presult_data_t	result,
	const gn_uchar_t**				matched_str
);

/* gn_textid_get_correlation
 *
 * deprecated in favor of gn_textid_get_correlation_at_index
 * 
 *   Behavior: Hands back in the output argument the correlation between the
 *             matched string and the Gracenote Normalized string.
 */
gn_error_t
gn_textid_get_correlation(
	const gn_textid_presult_data_t	result,
	gn_uint32_t*					matched_correlation
);

/* MARK: Deprecated: Album title display string accessor */

/* gn_textid_get_album_primary_credit_display_string
 *
 *   Deprecated: Use gn_textid_get_primary_artist_representation_array
 *
 *   Behavior: Hands back in the output argument the album's primary credit display
 *             string of the given gn_textid_presult_data_t instance.
 *
 *   Remark: This data is available only if the match_source was
 *           GN_TEXTID_MATCH_SOURCE_ALBUM or GN_TEXTID_MATCH_SOURCE_ONLINE.
 */
gn_error_t
gn_textid_get_album_primary_credit_display_string(
	const gn_textid_presult_data_t	result,
	const gn_uchar_t**				album_credit_display_string
);

/* MARK: Deprecated: Orthography array accessors */

#ifdef GN_MEDIAVOCS
/* gn_textid_get_contributor_orthography_array
 *
 *
 *   Deprecated: Use gn_textid_get_primary_artist_representation_array
 *
 *   Access the array of orthographies related to the contributor or the
 *   album's primary contributor matched in the most recent textid lookup.
 *
 *   Note that contributor orthographies will not be available if the match
 *   source is GN_TEXTID_MATCH_SOURCE_GENRE.
 *
 *   Even with a match source of GN_TEXTID_MATCH_SOURCE_CONTRIB or
 *   GN_TEXTID_MATCH_SOURCE_ALBUM, it is possible that orthographies will
 *   not be available. In that case, this function returns GN_SUCCESS and
 *   sets contributor_orthography_array to GN_NULL.
 */
gn_error_t
gn_textid_get_contributor_orthography_array(
	const gn_textid_presult_data_t	result,
	gn_prep_array_t* const			contributor_orthography_array
);

/* gn_textid_get_album_orthography_array
 *
 *
 *	Deprecated: Use gn_textid_get_album_title_representation_array
 *
 *   Access the array of orthographies related to the album title matched
 *   in the most recent textid lookup.
 *
 *   Note that contributor orthographies will only be available if the match
 *   source is GN_TEXTID_MATCH_SOURCE_ALBUM.
 *
 *   Even so, it is possible that orthographies will not be available. In that
 *   case, this function returns GN_SUCCESS and sets album_orthography_array
 *   to GN_NULL.
 */
gn_error_t
gn_textid_get_album_orthography_array(
	const gn_textid_presult_data_t	result,
	gn_prep_array_t* const			album_orthography_array
);
#endif /* GN_MEDIAVOCS */

#ifdef __cplusplus
}
#endif

#endif	/* _GN_TEXTID_LOOKUP_H_ */
