/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_textid_file_data.h
 *
 *	Support file recognition
 *
 *	These APIs provide the developer with an opaque interface for populating and
 *	modifying a file_data_t structure for TextID lookups and adding MLDB entries
 *
 * Data fields accessible in this data structure:
 *	
 *	filename
 *	path					- full path, no filename
 *
 *	parent_folder
 *	g_parent_folder			- grandparent folder
 *	gg_parent_folder		- great grandparent folder
 *
 *	album
 *	title
 *	track_artist
 *	disc_artist
 *	genre
 *	year
 *	original_release_year
 *	track_num
 *	length
 *	size
 *	bpm
 *	tagid
 *
 *	gn_pext_data			- extended data container
 *
 */

#ifndef	_GN_FILE_DATA_H_
#define _GN_FILE_DATA_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_ext_data.h"

#ifdef __cplusplus
extern "C"{
#endif

/*
 * Constants
 */

/*
 * Data types
 */

/* Opaque pointer to underlying C data structure.
 *
 * Always access data fields via the data accessor functions declared below
 */

/*  gn_pfile_data_t
 * Primary data structure for holding all relevant data about a particular file
 */
typedef void*	gn_pfile_data_t;


/*
 * Prototypes
 */


/*  gn_textid_file_data_init
 * Description: Allocates and initializes memory for a new file data structure.
 * Args: 	pfile_data	- pointer to the file data structure to be allocated and initialized
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_init(
	gn_pfile_data_t* pfile_data
	);

/*  gn_textid_file_data_smart_free
 * Description: Release the memory used by a file data structure, and sets the pointer to GN_NULL
 *				This function also releases memory used by the fields of the structure.
 * Args: 	pfile_data		- pointer to the file data structure to be allocated
 *			pfile_data_cfg	- pointer to a gn_textid_file_data_cfg_t structure for setting configuration options (this parameter can be GN_NULL)
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 */
gn_error_t
gn_textid_file_data_smart_free(
	gn_pfile_data_t* pfile_data
	);


/*  gn_textid_file_data_parse_filename
 * Description: Parse the file name and populate the gn_pfile_data_t fields
 *				that relate to values derived from the file name.
 *				This function does not allocate memory for the structure, but
 *				it does allocate memory for the fields that it populates.
 *
 * Args:	filename	- file name to parse; the file name should not have
 *						  any path information
 *			pfile_data	- file data structure to be populated
 *
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL filename
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_parse_filename(
	const gn_uchar_t* filename,
	gn_pfile_data_t pfile_data
	);

/*
 * Accessors / Modifiers
 */

/*	gn_textid_file_data_get_ext_data
 * Description: Retrieves a pointer to the ext_data stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			pext_data	- pointer to a gn_pext_data structure to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL pext_data
 *				Field not found
 */
gn_error_t
gn_textid_file_data_get_ext_data(
	const gn_pfile_data_t pfile_data,
	gn_pext_data_t* pext_data
	);

/*	gn_textid_file_data_set_ext_data
 * Description: Sets the ext_data in a pfile_data_t structure
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			pext_data	- pointer to a gn_pext_data structure
 *						  this structure is copied into the pfile_data structure
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL pext_data
 */
gn_error_t
gn_textid_file_data_set_ext_data(
	gn_pfile_data_t pfile_data,
	const gn_pext_data_t pext_data
	);

/*	gn_textid_file_data_get_parent_folder
 * Description: Retrieves a pointer to the parent_folder stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_parent_folder(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_parent_folder
 * Description: Sets the parent_folder in a pfile_data_t structure.
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			parent_folder	- String holding the name of the parent folder of the file being analyzed.
 *						      This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_parent_folder(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* parent_folder
	);


/*	gn_textid_file_data_get_g_parent_folder
 * Description: Retrieves a pointer to the g_parent_folder stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_g_parent_folder(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_g_parent_folder
 * Description: Sets the g_parent_folder in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			g_parent_folder	- String holding the name of the parent folder of the file being analyzed.
 *							  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_g_parent_folder(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* g_parent_folder
	);

/*	gn_textid_file_data_get_gg_parent_folder
 * Description: Retrieves a pointer to the gg_parent_folder stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_gg_parent_folder(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_gg_parent_folder
 * Description: Sets the gg_parent_folder in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			gg_parent_folder	- String holding the name of the parent folder of the file being analyzed.
 *								  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_gg_parent_folder(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* gg_parent_folder
	);

/*	gn_textid_file_data_get_filename
 * Description: Retrieves a pointer to the filename stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_filename(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_filename
 * Description: Sets the filename in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			filename	- A string that holds the data.
 *						  This string is copied into the pfile_data structure
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_filename(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* filename
	);

/*	gn_textid_file_data_get_path
 * Description: Retrieves a pointer to the path stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_path(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_path
 * Description: Sets the path in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			path		- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_path(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* path
	);

/*	gn_textid_file_data_get_track_artist
 * Description: Retrieves a pointer to the track artist stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_track_artist(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_track_artist
 * Description: Sets the track artist in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			track_artist	- A string that holds the data.
 *							  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_track_artist(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* track_artist
	);

/*	gn_textid_file_data_get_disc_artist
 * Description: Retrieves a pointer to the disc artist stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_disc_artist(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_disc_artist
 * Description: Sets the disc artist in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			disc_artist	- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_disc_artist(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* disc_artist
	);

/*	gn_textid_file_data_get_composer
 * Description: Retrieves a pointer to the disc artist stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_composer(
									const gn_pfile_data_t pfile_data,
									const gn_uchar_t** buffer
									);

/*	gn_textid_file_data_set_composer
 * Description: Sets the composer in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			composer	- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_composer(
									gn_pfile_data_t pfile_data,
									const gn_uchar_t* composer
									);
	
/*	gn_textid_file_data_get_disc_title
 * Description: Retrieves a pointer to the disc title stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_disc_title(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_disc_title
 * Description: Sets the disc title in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			disc_title	- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_disc_title(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* disc_title
	);

/*	gn_textid_file_data_get_track_title
 * Description: Retrieves a pointer to the track title stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_track_title(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_track_title
 * Description: Sets the track title in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			track_title	- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_track_title(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* track_title
	);

/*	gn_textid_file_data_get_genre
 * Description: Retrieves a pointer to the genre stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_genre(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_genre
 * Description: Sets the genre in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			genre		- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_genre(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* genre
	);


/*	gn_textid_file_data_get_year
 * Description: Retrieves a pointer to the year stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_year(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_year
 * Description: Sets the year in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			year		- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_year(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* year
	);


/*	gn_textid_file_data_get_original_release_year
 * Description: Retrieves a pointer to the original_release_year stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_original_release_year(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_original_release_year
 * Description: Sets the original_release_year in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			original_release_year	- A string that holds the data.
 *									  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_original_release_year(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* original_release_year
	);


/*	gn_textid_file_data_get_track_num
 * Description: Retrieves a pointer to the track_num stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_track_num(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_track_num
 * Description: Sets the track_num in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			track_num	- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_track_num(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* track_num
	);


/*	gn_textid_file_data_get_length
 * Description: Retrieves a pointer to the length stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_length(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_length
 * Description: Sets the music file length, in milliseconds, in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			length		- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_length(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* length
	);

/*	gn_textid_file_data_get_size
 * Description: Retrieves a pointer to the size stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_size(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_size
 * Description: Sets the file size, in bytes, in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			size		- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_size(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* size
	);

/*	gn_textid_file_data_get_bpm
 * Description: Retrieves a pointer to the bpm stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_bpm(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_bpm
 * Description: Sets the beats per minute in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			bpm			- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_bpm(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* bpm
	);


/*	gn_textid_file_data_get_tagid
 * Description: Retrieves a pointer to the tagid stored in a pfile_data_t structure
 * 				Memory is NOT allocated by this function.
 * Args: 	pfile_data	- pfile_data structure
 * 			buffer		- pointer to a buffer to hold the data
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				NULL buffer
 *				field not found
 */
gn_error_t
gn_textid_file_data_get_tagid(
	const gn_pfile_data_t pfile_data,
	const gn_uchar_t** buffer
	);

/*	gn_textid_file_data_set_tagid
 * Description: Sets the tagid in a pfile_data_t structure
 *				If the field was previously populated, it is freed before setting.
 *
 * Args: 	pfile_data	- pfile_data structure
 * 			tagid		- A string that holds the data.
 *						  This string is copied into the pfile_data structure.
 * Returns:	GN_SUCCESS upon success or an error.
 *			Failure conditions include:
 *				NULL pfile_data
 *				memory allocation error
 */
gn_error_t
gn_textid_file_data_set_tagid(
	gn_pfile_data_t pfile_data,
	const gn_uchar_t* tagid
	);

#ifdef __cplusplus
}
#endif

#endif /* _GN_FILE_DATA_H_ */

