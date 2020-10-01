/*
 * Copyright (c) 2006 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_apm.h - Alternate Phrase Mapper
 */

/*
 * MediaVOCs supports alternate phrases (nicknames, short names, etc.)
 * for data fields such as contributor names, album and track titles,
 * and genre names.
 *
 * Any phrase (i.e., string) can be considered a possible alternate
 * phrase.
 *
 */


#ifndef	_GN_APM_H_
#define _GN_APM_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_apm_types.h"

#ifdef __cplusplus
extern "C"{
#endif

/*
 * Data types.
 */
typedef struct gn_apm_phrase_array_s
{
	gn_uchar_t**	phrase_array;
	gn_uint32_t		phrase_count;
} gn_apm_phrase_array_t;

/*
 * Prototypes
 */

/* Map a candidate alternate phrase to its associated official phrase.
 * Matches are exact; multiple official phrases can match a single alternate
 * phrase. The input phrase is not, in general, known to be an alternate
 * phrase; failure to find an official phrase match would lead one to conclude
 * that the input phrase is not an alternate.
 * Parameters:
 *   candidate_alternate_phrase   The candidate alternate phrase
 *   desired_phrase_type          The type of phrase this is.
 *                                Refer to the GN_APM_ constants
 *                                (gn_apm_types.h) for allowed values
 *   official_phrase_array        A gn_apm_phrase_array_t structure.  If any
 *                                official phrases are found for the input
 *                                candidate phrase, this structure will be
 *                                created and filled with the official phrases.
 *                                If any official phrases are found, memory is
 *                                allocated for this argument and must be freed
 *                                by the caller with gn_apm_free_phrase_array
 *                                when the no longer needed.
 *   official_phrase_found_flag   The flag is set to GN_TRUE if a match has
 *                                been found between the candidate input
 *                                alternate phrase, and one or more official
 *                                phrases
 */
gn_error_t
gn_apm_get_official_phrase_array(
	const gn_uchar_t*		candidate_alternate_phrase,
	const gn_apm_type_t		desired_phrase_type,
	gn_apm_phrase_array_t**	official_phrase_array,
	gn_bool_t*				official_phrase_found_flag
);

/* Release all memory held by a gn_apm_phrase_array_t, created via a call to
 * gn_apm_get_official_phrase_array(), and sets the pointer to GN_NULL.
 *
 * Pramaeters:
 *   official_phrase_array: The gn_apm_phrase_array_t to be freed.
 */
gn_error_t
gn_apm_free_phrase_array(
	gn_apm_phrase_array_t**	official_phrase_array
);


/* Functions to manipulate the APM cache */

/* Deletes the apm cache file and, if present, the backup file.
 *
 * Arguments:	None
 */
gn_error_t
gn_apm_cache_delete(void);

/* Replaces the apm cache with its backup. If a backup is not present,
 * EDBIMERR_RevertMissingBackup error will be returned. In this case, if the
 * cache is corrupt, it will likely be necessary to delete it with
 * gn_apm_cache_delete().
 *
 * Arguments:	None
 */
gn_error_t
gn_apm_cache_revert(void);

/* Makes a backup copy of the apm cache data file. If a backup is already
 * present, it will be replaced by the new backup.
 *
 * Arguments:	None
 */
gn_error_t
gn_apm_cache_backup(void);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_APM_H_ */


