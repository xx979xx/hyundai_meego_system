/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_musicid.h
 *
 *	Support for MusicID Data objects and lookup
 *
 *	These APIs provide the developer with an opaque interface for populating
 *	and retrieving results in a MusicID data object, as well as performing
 *	lookups on these data objects.
 *
 */

#ifndef _GN_MUSICID_H_
#define _GN_MUSICID_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_album_track_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Constants and typedefs
 */

/*  gn_musicid_data_t
 * Primary data structure for holding all relevant data about a MusicID data
 * object.
 */
typedef void*		gn_musicid_data_t;

/*  gn_musicid_data_list_t
 * Primary data structure for holding a list of MusicID data objects.
 */
typedef void* gn_musicid_data_list_t;

/*  gn_musicid_flag_t
 * Enumerated types to specify options for MusicID lookup.
 */
typedef gn_uint32_t	gn_musicid_flag_t;

/* GN_MUSICID_FLAG_RETURN_SINGLE: Return a single result to the application.
 *     Gracenote service may return multiple fingerprint matches to the client
 *     library. In this case, the results will just contain partial data for
 *     each match. The Gracenote client will use provided text inputs and other
 *     information to determine which is the best result. The client will then
 *     make a second connection to Gracenote service to retrieve the full data
 *     for the selected match.
 * GN_MUSICID_FLAG_RETURN_ALL: Return all results to the application. In this
 *     case if Gracenote Serice returns multiple matches, all of those matches
 *     will be available to the application. Each will just have partial data
 *     which can be presented to the end user for selection. At that point the
 *     client will make a second connection to Gracenote Service to fetch the
 *     full metadata for the selected match.
 * GN_MUSICID_FLAG_SINGLE_CONNECT: This forces Gracenote Service to return the
 *     full metadata for the the single best match based on fingerprint alone.
 */
#define GN_MUSICID_FLAG_INVALID			0
#define GN_MUSICID_FLAG_RETURN_SINGLE	0x00000001
#define GN_MUSICID_FLAG_RETURN_ALL		0x00000002
#define GN_MUSICID_FLAG_SINGLE_CONNECT	0x00000004

/*  gn_musicid_confidence_t
 * Enumerated types to describe confidence of MusicID matches.
 */
typedef gn_uint32_t gn_musicid_confidence_t;

#define GN_MUSICID_CONFIDENCE_INVALID	0
#define GN_MUSICID_CONFIDENCE_HIGH		1
#define GN_MUSICID_CONFIDENCE_LOW		2

/*  gn_musicid_status_t
 * Enumerated types to describe status of a MusicID lookup.
 */
typedef gn_uint32_t gn_musicid_status_t;

#define GN_MUSICID_STATUS_UNKNOWN					0
#define GN_MUSICID_STATUS_GATHER_FINGERPRINT		1
#define GN_MUSICID_STATUS_LOOKING_UP_TAGID			2
#define	GN_MUSICID_STATUS_LOOKING_UP_CDDB_IDS		3
#define GN_MUSICID_STATUS_LOOKING_UP_FINGERPRINT	4
#define GN_MUSICID_STATUS_LOOKING_UP_TEXT			5
#define GN_MUSICID_STATUS_CHECK_FOR_ABORT			6
#define GN_MUSICID_STATUS_GATHER_TEXT				7

/*
 * Callbacks
 */

/* gn_musicid_callback_t
 *
 * Callback executed during MusicID lookup operations.
 *
 * This callback provides lookup status, lazy fingerprint generation,
 * and abort functionality.
 *
 * Parameters:
 *
 *   IN
 *	status			: The current status of the lookup.
 *
 *   IN/OUT
 *	musicid_data	: The MusicID Data object used in the lookup.
 *
 *   OUT
 *	abort			: Flag to indicate abort lookup.
 */
typedef	void (*gn_musicid_callback_t)(
	gn_musicid_status_t status,
	const gn_musicid_data_t musicid_data,
	gn_bool_t* abort
	);

/* gn_musicid_libraryid_callback_t
 *
 * Callback executed during LibraryID lookup operations.
 *
 * This callback provides LibraryID lookup results and abort functionality.
 *
 * To conserve memory, the application may set the free_elements parameter to
 * GN_TRUE. This will free all data list elements and results as they are
 * processed.
 *
 * Parameters:
 *
 *   IN
 *	data_list		: The MusicID Data List object containing
 *						LibraryID results.
 *
 *   OUT
 *	free_elements	: Flag to indicate abort lookup.
 *	abort			: Flag to indicate abort lookup.
 */
typedef	void (*gn_musicid_libraryid_callback_t)(
	const gn_musicid_data_list_t data_list,
	gn_bool_t* free_elements,
	gn_bool_t* abort
	);

/*
 * Public API declarations
 */

/* Create/Free */

/* gn_musicid_data_create
 *
 * Create and initialize a MusicID data object, based on input parameters.
 *
 * Memory is allocated by this call. The gn_musicid_data_free function should
 * be called once the MusicID data object is no longer needed.
 *
 * Parameters:
 *   OUT
 *	musicid_data	: An initialized MusicID Data object.
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	musicid_data	: An initialized MusicID data object.
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	musicid_data	: Will not have been modified.
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_create(
	gn_musicid_data_t* musicid_data
	);

/* gn_musicid_data_free
 *
 * Free a MusicID-File object created by gn_musicid_data_create.
 *
 * Parameters:
 *   IN/OUT
 *	musicid_data	: A MusicID Data object to be freed
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	musicid_data	: Freed and set to GN_NULL.
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	musicid_data	: Will not have been modified.
 *
 *	Errors include:
 *	  - invalid argument
 */
gn_error_t
gn_musicid_data_free(
	gn_musicid_data_t* musicid_data
	);


/* gn_musicid_data_list_create
 *
 * Create and initialize a MusicID data list object.
 *
 * Memory is allocated by this call. The gn_musicid_data_list_free function
 * should be called once the MusicID data object is no longer needed.
 *
 * Parameters:
 *   OUT
 *	musicid_data_list	: An initialized MusicID Data list object.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	musicid_data_list	: An initialized MusicID data list object.
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	musicid_data_list	: Will not have been modified.
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_create(
	gn_musicid_data_list_t* musicid_data_list
	);

/* gn_musicid_data_list_free
 *
 * Free a MusicID-File data list object created by gn_musicid_data_list_create.
 *
 * Parameters:
 *   IN/OUT
 *	musicid_data_list	: A MusicID Data list object to be freed
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	musicid_data_list	: Freed and set to GN_NULL.
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	musicid_data_list	: Will not have been modified.
 *
 *	Errors include:
 *	  - invalid argument
 */
gn_error_t
gn_musicid_data_list_free(
	gn_musicid_data_list_t* musicid_data_list
	);

/* Data List Management */

/*	gn_musicid_data_list_set_libraryid_batch_size
 * Description: Sets the LibraryID maximum batch size for lookups.
 *			LibraryID splits the input into batches to conserve resources.
 *
 * Args:	musicid_data_list		- gn_musicid_data_list_t structure
 *			libraryid_batch_size	- Maximum size of a LibraryID batch.
 */
gn_error_t
gn_musicid_data_list_set_libraryid_batch_size(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uint32_t libraryid_batch_size
	);

/*	gn_musicid_data_list_set_libraryid_callback
 * Description: Sets the LibraryID callback in a gn_musicid_data_list_t object.
 *			This callback is used by LibraryID to return results, and provide
 *			abort functionality to the application.
 *
 * Args:	musicid_data_list	- gn_musicid_data_list_t structure
 *			libraryid_callback	- Address of a user defined callback function or
 *								GN_NULL to remove the callback.
 */
gn_error_t
gn_musicid_data_list_set_libraryid_callback(
	const gn_musicid_data_list_t musicid_data_list,
	gn_musicid_libraryid_callback_t libraryid_callback
	);

/* gn_musicid_data_list_element_count
 *
 * Returns the number of MusicID data objects in the list.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data list object.
 *
 *   OUT
 *	count				: Number of MusicID Data objects in the list.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	count				: Number of MusicID Data objects in the list.
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	count				: Will not have been modified.
 *
 *	Errors include:
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_element_count(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uint32_t* count
	);

/* gn_musicid_data_list_element_get
 *
 * Returns a MusicID Data object.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data list object.
 *	index				: Zero-based index of the MusicID Data object to
 *							retrieve.
 *
 *   OUT
 *	musicid_data		: MusicID Data object retrieved
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	musicid_data		: MusicID Data object retrieved
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	musicid_data		: Will not have been modified.
 *
 *	Errors include:
 *	  - out of range
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_element_get(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uint32_t index,
	gn_musicid_data_t* musicid_data
	);

/* gn_musicid_data_list_element_attach
 *
 * Attaches a MusicID data object to a list.
 *
 * Upon success, memory ownership is transferred to the MusicID data list.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data list object.
 *
 *   IN/OUT
 *	musicid_data		: A MusicID Data object to attach to the list.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	musicid_data_list	: Modified to include the MusicID data object
 *	musicid_data		: Set to GN_NULL, indicating memory ownership transfer
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	musicid_data_list	: Will not have been modified.
 *	musicid_data		: Will not have been modified.
 *
 *	Errors include:
 *	  - already in list
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_element_attach(
	gn_musicid_data_list_t musicid_data_list,
	gn_musicid_data_t* musicid_data
	);

/* Serialize/Deserialize */

/* gn_musicid_data_serialize
 *
 * Creates a serialized version of the MusicID data object.
 * If a lookup has not yet taken place, relevant online lookup information is
 * serialized, including ClientID.
 * If a lookup has already occurred, the album result data is serialized.
 *
 * Memory is allocated by this call. The gn_musicid_data_serialize_free()
 * function should be called once the serialized data is no longer needed.
 *
 * Parameters:
 *   IN
 *	musicid_data	: An initialized MusicID Data object.
 *
 *   OUT
 *	serialized		: Pointer to a serialized string of the MusicID data object.
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	serialized		: NULL-terminated string representing the MusicID data
 *						object.
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	serialized		: Will not have been modified.
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_serialize(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** serialized
	);

/* gn_musicid_data_serialize_free
 *
 * Free a serialized string created by gn_musicid_data_serialize().
 *
 * Parameters:
 *   IN/OUT
 *	serialized	: A serialized string
 *
 * Return Values:
 *   On success:
 *	error		: GN_SUCCESS
 *	serialized	: Freed and set to GN_NULL.
 *
 *   On error:
 *	error		: Gracenote Error Value
 *	serialized	: Will not have been modified.
 *
 *	Errors include:
 *	  - invalid argument
 */
gn_error_t
gn_musicid_data_serialize_free(
	gn_uchar_t** serialized
	);

/* gn_musicid_data_deserialize
 *
 * Creates a MusicID data object from a serialized version..
 *
 * Memory is allocated by this call. The gn_musicid_data_free() function should
 * be called once the MusicID data object is no longer needed.
 *
 * Parameters:
 *   IN
 *	serialized		: Serialized string created by gn_musicid_data_serialize().
 *
 *   OUT
 *	musicid_data	: Pointer to a MusicID data object to be created.
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	musicid_data	: Initialized and populated MusicID data object.
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	musicid_data	: Will not have been modified.
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_deserialize(
	const gn_uchar_t* serialized,
	gn_musicid_data_t* musicid_data
	);

/* gn_musicid_data_list_serialize
 *
 * Creates a serialized version of the MusicID Data List object.
 * If a lookup has not yet taken place, relevant online lookup information is
 * serialized, including ClientID.
 * If a lookup has already occurred, the album result data is serialized.
 *
 * Memory is allocated by this call. The gn_musicid_data_serialize_free()
 * function should be called once the serialized data is no longer needed.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data List object.
 *
 *   OUT
 *	serialized			: Pointer to a serialized string of the MusicID Data
 *							List object.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	serialized			: NULL-terminated string representing the MusicID Data
 *							List object.
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	serialized			: Will not have been modified.
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_serialize(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uchar_t** serialized
	);

/* gn_musicid_data_list_deserialize
 *
 * Creates a MusicID Data List object from a serialized version..
 *
 * Memory is allocated by this call. The gn_musicid_data_list_free() function
 * should be called once the MusicID Data List object is no longer needed.
 *
 * Parameters:
 *   IN
 *	serialized			: Serialized string created by
 *							gn_musicid_data_list_serialize().
 *
 *   OUT
 *	musicid_data_list	: Pointer to a MusicID Data List object to be created.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	musicid_data_list	: Initialized and populated MusicID Data List object.
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	musicid_data_list	: Will not have been modified.
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_deserialize(
	const gn_uchar_t* serialized,
	gn_musicid_data_list_t* musicid_data_list
	);

/* Lookup/Retrieval */

/* gn_musicid_lookup_trackid
 *
 * Perform a MusicID TrackID lookup.
 *
 * Parameters:
 *   IN
 *	musicid_data	: An initialized MusicID Data object.
 *	musicid_flags	: Logically OR'd gn_musicid_flag_t.
 *   OUT
 *	match_count		: Pointer to number of matches.
 *
 * Return Values:
 *   On success (match):
 *	error			: GN_SUCCESS
 *	match_count		: GN_MUSICID_FLAG_RETURN_SINGLE -> 1
 *                  : GN_MUSICID_FLAG_SINGLE_CONNECT -> 1
 *					: GN_MUSICID_FLAG_RETURN_ALL -> 1 or more
 *
 *   On success (no match):
 *	error			: GN_SUCCESS
 *	match_count		: 0
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	match_count		: unchanged
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_lookup_trackid(
	const gn_musicid_data_t musicid_data,
	gn_musicid_flag_t musicid_flags,
	gn_uint32_t* match_count
	);

/* gn_musicid_lookup_albumid
 *
 * Perform a MusicID AlbumID lookup.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data object.
 *	musicid_flags		: Logically OR'd gn_musicid_flag_t.
 *
 * Return Values:
 *   On success (match):
 *	error				: GN_SUCCESS
 *
 *   On success (no match):
 *	error				: GN_SUCCESS
 *
 *   On error:
 *	error				: Gracenote Error Value
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_lookup_albumid(
	gn_musicid_data_list_t musicid_data_list,
	gn_musicid_flag_t musicid_flags
	);

/* gn_musicid_lookup_libraryid
 *
 * Perform a MusicID LibraryID lookup.
 * LibraryID sorts and batches the MusicID Data list to improve performance.
 * This process alters the ordering of the MusicID Data List elements.
 * Ordering of the input list is not preserved after a call to this API.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data object.
 *	musicid_flags		: Logically OR'd gn_musicid_flag_t.
 *
 * Return Values:
 *   On success (match):
 *	error				: GN_SUCCESS
 *
 *   On success (no match):
 *	error				: GN_SUCCESS
 *
 *   On error:
 *	error				: Gracenote Error Value
 *
 *	Errors include:
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_lookup_libraryid(
	gn_musicid_data_list_t musicid_data_list,
	gn_musicid_flag_t musicid_flags
	);

/* gn_musicid_data_get_match_count
 *
 * Retrieve the match count following a successful lookup in
 * gn_musicid_lookup_trackid().
 *
 * Parameters:
 *   IN
 *	musicid_data	: An initialized MusicID Data object,
 *						following a successful lookup.
 *   OUT
 *	match_count		: Pointer to the number of matches.
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	match_count		: number of matches
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	match_count		: unchanged
 *
 *	Errors include:
 *	  - result not available
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_get_match_count(
	const gn_musicid_data_t musicid_data,
	gn_uint32_t* match_count
	);

/* gn_musicid_data_get_album
 *
 * Retrieve a match following a successful lookup from
 * gn_musicid_lookup_trackid().
 * The caller should free palbum using gn_album_data_release_album().
 *
 * Note that the album is not guaranteed to be complete until
 * gn_musicid_data_lookup_album_match() is called.
 *
 * Parameters:
 *   IN
 *	musicid_data	: An initialized MusicID Data object,
 *						following a successful lookup.
 *	match_index		: zero-based index of match to retrieve
 *   OUT
 *	palbum			: Pointer to the album to retrieve
 *	track_index		: Pointer to the index of the identified track
 *						Also known as "Matched Track Index" (0-based)
 *						This may be passed into gn_album_data_get_album_track()
 *	track_ord		: Pointer to the ordinality of the identified track
 *						Also known as "Matched Track Number" (1-based)
 *						This may be passed into
 *						gn_album_data_get_album_track_by_ord()
 *	confidence		: Pointer to the confidence of this match
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	palbum			: Album result
 *	track_ord		: Ordinality of the identified track
 *	confidence		: Confidence of Album result
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	palbum			: unchanged
 *	track_ord		: unchanged
 *	confidence		: unchanged
 *
 *	Errors include:
 *	  - result not available
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_get_album(
	const gn_musicid_data_t musicid_data,
	gn_uint32_t match_index,
	gn_palbum_t* palbum,
	gn_uint32_t* track_index,
	gn_uint32_t* track_ord,
	gn_musicid_confidence_t* confidence
	);

/* gn_musicid_data_lookup_album_match
 *
 * Retrieves complete metadata for a match, following a successful lookup from
 * gn_musicid_lookup_trackid().
 * The caller should free palbum using gn_album_data_release_album().
 *
 * Parameters:
 *   IN/OUT
 *	musicid_data	: An initialized MusicID Data object,
 *						following a successful lookup.
 *   IN
 *	match_index		: zero-based index of match to lookup
 *	select			: Boolean to indicate selection of this match.
 *						Setting this to GN_TRUE will result in freeing all
 *						any other matches associated with this MusicID Data
 *						object. Subsequent calls to this API,
 *						gn_musicid_data_get_match_count(), or
 *						gn_musicid_data_get_album() will behave as if there is
 *						a single match at index zero.
 *   OUT
 *	palbum			: Pointer to the album to lookup
 *	track_index		: Pointer to the index of the identified track
 *						Also known as "Matched Track Index" (0-based)
 *						This may be passed into gn_album_data_get_album_track()
 *	track_ord		: Pointer to the ordinality of the identified track
 *						Also known as "Matched Track Number" (1-based)
 *						This may be passed into
 *						gn_album_data_get_album_track_by_ord()
 *	confidence		: Pointer to the confidence of this match
 *
 * Return Values:
 *   On success:
 *	error			: GN_SUCCESS
 *	palbum			: Album result
 *	track_index		: Index of the identified track
 *	track_ord		: Ordinality of the identified track
 *	confidence		: Confidence of Album result
 *
 *   On error:
 *	error			: Gracenote Error Value
 *	palbum			: unchanged
 *	track_index		: unchanged
 *	track_ord		: unchanged
 *	confidence		: unchanged
 *
 *	Errors include:
 *	  - result not available
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_lookup_album_match(
	const gn_musicid_data_t musicid_data,
	gn_uint32_t match_index,
	gn_bool_t select,
	gn_palbum_t* palbum,
	gn_uint32_t* track_index,
	gn_uint32_t* track_ord,
	gn_musicid_confidence_t* confidence
	);

/* gn_musicid_data_list_album_result_count
 *
 * Returns the number of Album results in the list, following an
 * AlbumID or LibraryID lookup.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data list object,
 *							populated with AlbumID or LibraryID results.
 *
 *   OUT
 *	album_result_count	: Number of album results in the list.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	album_result_count	: Number of album results in the list.
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	album_result_count	: Will not have been modified.
 *
 *	Errors include:
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_album_result_count(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uint32_t* album_result_count
	);

/* gn_musicid_data_list_album_result_get
 *
 * Retrieve a match following a successful lookup from
 * gn_musicid_lookup_albumid() or gn_musicid_lookup_libraryid().
 * The caller should free palbum using gn_album_data_release_album().
 *
 * Note that the album is not guaranteed to be complete until
 * gn_musicid_data_list_album_result_lookup() is called.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data object,
 *							following a successful lookup.
 *	album_result_index	: zero-based index of the Album Result
 *
 *   OUT
 *	palbum				: Pointer to the album to retrieve
 *	data_count			: Pointer to the number of Data Objects matching to this
 *							album.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	palbum				: Album Result
 *	data_count			: Number of Data Objects matching to this album
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	palbum				: unchanged
 *	data_count			: unchanged
 *
 *	Errors include:
 *	  - result not available
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_album_result_get(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uint32_t album_result_index,
	gn_palbum_t* palbum,
	gn_uint32_t* data_count
	);

/* gn_musicid_data_list_album_result_lookup
 *
 * Retrieves complete metadata for an Album Result match, following a successful
 * lookup from gn_musicid_lookup_albumid() or gn_musicid_lookup_libraryid().
 * The caller should free palbum using gn_album_data_release_album().
 *
 * Parameters:
 *   IN/OUT
 *	musicid_data_list	: An initialized MusicID Data List object,
 *							following a successful lookup.
 *   IN
 *	album_result_index	: zero-based index of Album Result to lookup
 *
 *   OUT
 *	palbum				: Pointer to the album to lookup
 *	data_count			: Pointer to the number of Data Objects matching to this
 *							album.
 *
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	palbum				: Album result
 *	data_count			: Number of Data Objects matching to this album
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	palbum				: unchanged
 *	data_count			: unchanged
 *
 *	Errors include:
 *	  - result not available
 *	  - memory allocation
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_album_result_lookup(
	const gn_musicid_data_t musicid_data_list,
	gn_uint32_t album_result_index,
	gn_palbum_t* palbum,
	gn_uint32_t* data_count
	);

/* gn_musicid_data_list_album_result_data_get
 *
 * Returns a MusicID Data object, specified by Album Result.
 *
 * Parameters:
 *   IN
 *	musicid_data_list	: An initialized MusicID Data list object, populated
 *							with album results.
 *	album_result_index	: Zero-based index of the Album Result to retrieve.
 *	data_index			: Zero-based index of the Data Object to retrieve
 *							from the Album Result.
 *
 *   OUT
 *	musicid_data		: MusicID Data object, matching to the Album Result
 *	track_index			: Pointer to the index of the identified track
 *							Also known as "Matched Track Index" (0-based)
 *							This may be passed into gn_album_data_get_album_track()
 *	track_ord			: Pointer to the ordinality of the identified track
 *							Also known as "Matched Track Number" (1-based)
 *							This may be passed into
 *							gn_album_data_get_album_track_by_ord()
 * Return Values:
 *   On success:
 *	error				: GN_SUCCESS
 *	musicid_data		: MusicID Data object retrieved
 *	track_index			: Index of the identified track
 *	track_ord			: Ordinality of the identified track
 *
 *   On error:
 *	error				: Gracenote Error Value
 *	musicid_data		: unmodified
 *	track_index			: unmodified
 *	track_ord			: unmodified
 *
 *	Errors include:
 *	  - out of memory
 *	  - out of range
 *	  - not initialized
 */
gn_error_t
gn_musicid_data_list_album_result_data_get(
	const gn_musicid_data_list_t musicid_data_list,
	gn_uint32_t album_result_index,
	gn_uint32_t data_index,
	gn_musicid_data_t* musicid_data,
	gn_uint32_t* track_index,
	gn_uint32_t* track_ord
	);

/* Get/Set */

/*	gn_musicid_data_set_callback
 * Description: Sets the callback in a gn_musicid_data_t object.
 *			This callback is used by the MusicID to report status, gather
 *			fingerprint, and provide abort functionality to the application.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			callback		- Address of a user defined callback function or
 *								GN_NULL to remove the callback.
 */
gn_error_t
gn_musicid_data_set_callback(
	const gn_musicid_data_t musicid_data,
	gn_musicid_callback_t callback
	);

/*	gn_musicid_data_get_filepath
 * Description: Retrieves a pointer to the filepath (path + filename) stored in
 *				a gn_musicid_data_t structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			filepath		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL filename
 */
gn_error_t
gn_musicid_data_get_filepath(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** filepath
	);

/*	gn_musicid_data_set_filepath
 * Description: Sets the filepath (path + filename) string in a
 *				gn_musicid_data_t structure.
 *				If the field was previously populated, it is freed before
 *				setting.
 *				This field may be used by the application to uniquely
 *				identify the file being processed, this information is not used
 *				for identification. To enabled identication based on filename,
 *				use gn_musicid_data_parse_filename().
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			filepath		- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_filepath(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* filepath
	);

/*	gn_musicid_data_parse_filename
 * Description: Parses the filename (no path) string into a
 *				gn_musicid_data_t structure.
 *				If the filename was previously parsed, it is freed before
 *				setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			filename		- A string that holds the data.
 *								This string is parsed into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_parse_filename(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* filename
	);

/*	gn_musicid_data_get_user_data
 * Description: Retrieves a pointer to the user_data stored in a
 *				gn_musicid_data_t structure.
 *				This user_data may be used by the application to uniquely
 *				identify the file being processed, this information is not used
 *				for identification.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			user_data		- the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL user_data
 */
gn_error_t
gn_musicid_data_get_user_data(
	const gn_musicid_data_t musicid_data,
	gn_uint32_t* user_data
	);

/*	gn_musicid_data_set_user_data
 * Description: Sets the user_data in a gn_musicid_data_t structure
 *			This user_data is used by the application to uniquely identify the
 *			file being processed, this information is not used for
 *			identification.
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			user_data		- the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_user_data(
	const gn_musicid_data_t musicid_data,
	const gn_uint32_t user_data
	);

/*	gn_musicid_data_get_fingerprint
 * Description: Retrieves a pointer to the fingerprint stored in a
 *				gn_musicid_data_t structure.
 *				This string must originate from the
 *				gn_fpx_fingerprint_serialize() API.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			fingerprint		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL fingerprint
 */
gn_error_t
gn_musicid_data_get_fingerprint(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** fingerprint
	);

/*	gn_musicid_data_set_fingerprint
 * Description: Sets the serialized fingerprint string in a gn_musicid_data_t
 *				structure. This string must originate from the
 *				gn_fpx_fingerprint_serialize() API.
 *				If the field was previously populated, it is freed before
 *				setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			fingerprint		- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_fingerprint(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* fingerprint
	);

/*	gn_musicid_data_get_tag_id
 * Description: Retrieves a pointer to the tag_id stored in a gn_musicid_data_t
 *				structure
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			tag_id			- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL tag_id
 */
gn_error_t
gn_musicid_data_get_tag_id(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** tag_id
	);

/*	gn_musicid_data_set_tag_id
 * Description: Sets the tag_id in a gn_musicid_data_t structure
 *				If the field was previously populated, it is freed before
 *				setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			tag_id			- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_tag_id(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* tag_id
	);

/*	gn_musicid_data_get_cddb_ids
 * Description: Retrieves a pointer to the cddb_ids stored in a
 *				gn_musicid_data_t structure
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			cddb_ids		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL cddb_ids
 */
gn_error_t
gn_musicid_data_get_cddb_ids(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** cddb_ids
	);

/*	gn_musicid_data_set_cddb_ids
 * Description: Sets the tag_id in a gn_musicid_data_t structure
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			cddb_ids		- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_cddb_ids(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* cddb_ids
	);

/*	gn_musicid_data_get_disc_artist
 * Description: Retrieves a pointer to the disc artist stored in a
 *				gn_musicid_data_t structure
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			disc_artist		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL disc_artist
 */
gn_error_t
gn_musicid_data_get_disc_artist(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** disc_artist
	);

/*	gn_musicid_data_set_disc_artist
 * Description: Sets the disc artist in a gn_musicid_data_t structure
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			disc_artist		- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_disc_artist(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* disc_artist
	);

/*	gn_musicid_data_get_disc_title
 * Description: Retrieves a pointer to the disc title stored in a
 *				gn_musicid_data_t structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *	 		disc_title		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL disc_title
 */
gn_error_t
gn_musicid_data_get_disc_title(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** disc_title
	);

/*	gn_musicid_data_set_disc_title
 * Description: Sets the disc title in a gn_musicid_data_t structure
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			disc_title		- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_disc_title(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* disc_title
	);

/*	gn_musicid_data_get_track_artist
 * Description: Retrieves a pointer to the track artist stored in a
 *				gn_musicid_data_t structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_artist	- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL track_artist
 */
gn_error_t
gn_musicid_data_get_track_artist(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** track_artist
	);

/*	gn_musicid_data_set_track_artist
 * Description: Sets the track artist in a gn_musicid_data_t structure
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_artist	- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_track_artist(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* track_artist
	);

/*	gn_musicid_data_get_track_title
 * Description: Retrieves a pointer to the track title stored in a
 *				gn_musicid_data_t structure
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_title		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL track_title
 */
gn_error_t
gn_musicid_data_get_track_title(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** track_title
	);

/*	gn_musicid_data_set_track_title
 * Description: Sets the track title in a gn_musicid_data_t structure
 *				If the field was previously populated, it is freed before
 *				setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_title		- A string that holds the data.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_track_title(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* track_title
	);

/*	gn_musicid_data_get_track_num
 * Description: Retrieves the track_num stored in a gn_musicid_data_t structure
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_num		- pointer to an integer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				zero track_num
 */
gn_error_t
gn_musicid_data_get_track_num(
	const gn_musicid_data_t musicid_data,
	gn_uint32_t* track_num
	);

/*	gn_musicid_data_set_track_num
 * Description: Sets the track_num in a gn_musicid_data_t structure.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_num		- An integer of the track number.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 */
gn_error_t
gn_musicid_data_set_track_num(
	const gn_musicid_data_t musicid_data,
	const gn_uint32_t track_num
	);

/*	gn_musicid_data_get_track_count
 * Description: Retrieves the track_count stored in a gn_musicid_data_t
 *				structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_count		- pointer to an integer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				zero track_count
 */
gn_error_t
gn_musicid_data_get_track_count(
	const gn_musicid_data_t musicid_data,
	gn_uint32_t* track_count
	);

/*	gn_musicid_data_set_track_count
 * Description: Sets the track_count in a gn_musicid_data_t structure.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			track_count		- An integer of the track count.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 */
gn_error_t
gn_musicid_data_set_track_count(
	const gn_musicid_data_t musicid_data,
	const gn_uint32_t track_count
	);


/*	gn_musicid_data_get_parent_folder
 * Description: Retrieves a pointer to the parent_folder stored in a
 *				gn_musicid_data_t structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			parent_folder	- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL parent_folder
 */
gn_error_t
gn_musicid_data_get_parent_folder(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** parent_folder
	);

/*	gn_musicid_data_set_parent_folder
 * Description: Sets the parent_folder in a gn_musicid_data_t structure.
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			parent_folder	- String holding the name of the parent folder of
 *								the file being analyzed.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_parent_folder(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* parent_folder
	);


/*	gn_musicid_data_get_g_parent_folder
 * Description: Retrieves a pointer to the g_parent_folder stored in a
 *				gn_musicid_data_t structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			g_parent_folder	- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL g_parent_folder
 */
gn_error_t
gn_musicid_data_get_g_parent_folder(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** g_parent_folder
	);

/*	gn_musicid_data_set_g_parent_folder
 * Description: Sets the g_parent_folder in a gn_musicid_data_t structure
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data	- gn_musicid_data_t structure
 *			g_parent_folder	- String holding the name of the parent folder of
 *								the file being analyzed.
 *								This string is copied into the gn_musicid_data_t
 *								structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_g_parent_folder(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* g_parent_folder
	);

/*	gn_musicid_data_get_gg_parent_folder
 * Description: Retrieves a pointer to the gg_parent_folder stored in a
 *				gn_musicid_data_t structure.
 *				Memory is NOT allocated by this function.
 *
 * Args:	musicid_data		- gn_musicid_data_t structure
 *			gg_parent_folder	- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				NULL gg_parent_folder
 */
gn_error_t
gn_musicid_data_get_gg_parent_folder(
	const gn_musicid_data_t musicid_data,
	gn_uchar_t** gg_parent_folder
	);

/*	gn_musicid_data_set_gg_parent_folder
 * Description: Sets the gg_parent_folder in a gn_musicid_data_t structure
 *			If the field was previously populated, it is freed before setting.
 *
 * Args:	musicid_data		- gn_musicid_data_t structure
 *			gg_parent_folder	- String holding the name of the parent folder
 *									of the file being analyzed.
 *									This string is copied into the
 *									gn_musicid_data_t structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL musicid_data
 *				memory allocation error
 */
gn_error_t
gn_musicid_data_set_gg_parent_folder(
	const gn_musicid_data_t musicid_data,
	const gn_uchar_t* gg_parent_folder
	);

#ifdef __cplusplus
}
#endif

#endif /* _GN_MUSICID_H_ */
