/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_lookup_cache.h - Application interface to the local lookup cache.
 *
 *  In some eMMS product configurations the local database is kept fresh by
 *  periodically replacing the entire database.  This can have the unfortunate
 *  effect that music meta-data which has been available, and even viewed by
 *  the end user, will no longer be available after a database update.
 *
 *  The lookup cache module addresses this effect.  Meta-data which has been
 *  returned from a TOC lookup can be stored in the lookup cache.  The lookup
 *  cache is not modified during the database replacement operation and so
 *  results which have been added to the cache will always be available, thus
 *  providing a seamless user experience across replacements.
 *
 *  Considerations:
 *
 *  1) The cache associates a single album with the TOC which was used to look
 *     it up in the local database. That TOC can be used to access the album's
 *     metadata from the cache at a later date.  If the user wants to associate
 *     a different album with a TOC already in the cache, the current record
 *     with that TOC must first be removed from the cache.  An API is provided.
 *  2) In rare situations, certain types of metadata, e.g. cover art, might
 *     bloat the cache beyond an acceptable size.  Two configuration parameters
 *     are available (see the definition of gn_emms_configuration_t in
 *     gn_init_emms.h) to define an acceptable lookup cache file size.  These
 *     can be used to set a warning limit and a hard-limit on the size of the
 *     cache. In addition to those parameters, a function is available to
 *     compact the cache.
 */


#ifndef _GN_LOOKUP_CACHE_H_
#define _GN_LOOKUP_CACHE_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"

#if defined(GN_CD_ONLINE)
#include "gn_online_lookup.h"
#endif

#if defined(GN_COVER_ART)
#include "gn_coverart_types.h"
#endif

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Data types
 */

/*
 * Prototypes.
 */

/* Determines whether a record keyed on the given TOC is present in the lookup
 * cache.
 *
 * Paramaters
 *  IN: toc_str - The TOC to check.  The format of toc_str is as described in
 *                the gnllu_cache_and_local_toc_lookup() comment in
 *                gn_local_lookup.h.
 *  OUT: is_present - If a record with the given TOC is present in the lookup
 *                    cache, then is_present will be set to GN_TRUE when the
 *                    function returns.  Otherwise it will be set to GN_FALSE>
 *
 * Return values:
 *  GN_SUCCESS indicates that the function executed normally.
 *  Any other value indicates an error was detected.  In this case, the value of
 *  if_present can not be trusted when the function returns.
 */
gn_error_t
gn_lookup_cache_toc_is_present(
	const gn_uchar_t* toc_str,
	gn_bool_t*        is_present
	);

/* Add the most recent TOC lookup result to the lookup cache.
 *
 * NOTE: If cover art is available, it will only be added to the cache if it
 *       has been retrieved prior to calling gn_lookup_cache_add_last_result().
 *       Only one image will be cached. Either the ablum or the artist image
 *       depending on which image was retrieved.
 *
 * Parameters:
 *  OUT: size_warning - If after the add operation the cache file exceeds the
 *           file size warning value (either the default value or the value
 *           set at configuration time in a gn_emms_configuration_t
 *           structure) the GN_TRUE will be returned.
 *           A GN_TRUE value of size_warning indicates that the cache should be
 *           compacted soon because it is approaching the maximum size of the
 *           cache file (also configurable).
 *
 * Return values:
 *  GN_SUCCESS indicates that the result of the previous lookup was successfully
 *             added to the lookup cache and will be available for subsequent
 *             lookups.
 *
 *  Error value:
 *       Indicates some sort of error occured.
 */
gn_error_t
gn_lookup_cache_add_last_result(
	gn_bool_t* size_warning
	);

#if defined(GN_CD_ONLINE)
/* Add the most recent online TOC lookup result to the lookup cache.
 *
 * NOTE: If cover art is available, it will only be added to the cache if
 *       cover art is retrieved before the call is made to
 *       gn_lookup_cache_add_last_online_result(..).
 *       Only one image will be cached. Either the ablum or the artist image
 *       depending on which image was retrieved.
 *
 * Parameters:
 *  IN:  olc_handle - Reserved, should be set to GN_NULL.
 *  OUT: size_warning - If after the add operation the cache file exceeds the
 *           file size warning value (either the default value or the value
 *           set at configuration time in a gn_emms_configuration_t
 *           structure) the GN_TRUE will be returned.
 *           A GN_TRUE value of size_warning indicates that the cache should be
 *           compacted soon because it is approaching the maximum size of the
 *           cache file (also configurable).
 *
 * Return values:
 *  GN_SUCCESS indicates that the result of the previous online lookup was
 *             successfully added to the lookup cache and will be available
 *             for subsequent lookups.
 *
 *  Error value:
 *       Indicates some sort of error occured.
 */
gn_error_t
gn_lookup_cache_add_last_online_result(
	gn_olc_handle_t olc_handle,
	gn_bool_t*      size_warning
	);
#endif 

/* Logically deletes the entry matching the given toc from the lookup cache.
 *
 * Logical deletion does not change the size of the cache file.  A call to
 * gn_lookup_cache_compact() will result in all logically deleted items being
 * physically deleted from the file.
 *
 * Parameters:
 *  IN: toc_str - The TOC of the record to be deleted.  The format of toc_str is
 *                as described in the gnllu_cache_and_local_toc_lookup()
 *                comment in gn_local_lookup.h.
 *
 * Return values:
 *  GN_SUCCESS if the deletion was successful, otherwise an error value will
 *             be returned
 */
gn_error_t
gn_lookup_cache_delete_entry(
	const gn_uchar_t* toc_str
	);

#if defined(GN_COVER_ART)
/* Add an unattached coverart to the lookup cache
 *
 * NOTE: Only images retrieved from an online source are cached by this API.
 *       All other image sources will NOT be cached but still return GN_SUCCESS.
 *
 * Parameters:
 *  IN: coverart - The coverart to add to the cache
 *  OUT: size_warning - If after the add operation the cache file exceeds the
 *           file size warning value (either the default value or the value
 *           set at configuration time in a gn_emms_configuration_t
 *           structure) the GN_TRUE will be returned.
 *           A GN_TRUE value of size_warning indicates that the cache should be
 *           compacted soon because it is approaching the maximum size of the
 *           cache file (also configurable).
 *
 * Return values:
 *  GN_SUCCESS  indicates that the coverart was successfully added to the lookup 
 *              cache, and will be available for future coverart lookups.
 *
 *  Error value:
 *       Indicates some sort of error occured.
 */
gn_error_t
gn_lookup_cache_add_coverart(
        gn_coverart_t   coverart,
        gn_bool_t*      size_warning
        );
#endif 

/* Get the current "maximum" file size setting (in bytes) for the local
 * lookup cache file.
 *
 * size: The current configuration setting for the maximum file size
 */
gn_error_t
gn_lookup_cache_get_max_size(
	gn_uint32_t *size
	);

/* Get the current "warning" file size setting (in bytes) for the local
 * lookup cache file.
 *
 * size: The current warning level configuration setting
 */
gn_error_t
gn_lookup_cache_get_warning_size(
	gn_uint32_t *size
	);

/* Compacts the lookup cache data file.
 *
 * Deleting an item from the lookup cache with gn_lookup_cache_delete_entry()
 * only logically deletes that item. It does not shrink the lookup cache file,
 * though it does make the space in the file available for future additions.
 * After many deletions the lookup cache can become fragmented. Compaction
 * defragments the cache, shrinking its size and increasing its efficiency.
 *
 * Arguments:	None
 */
gn_error_t
gn_lookup_cache_compact(void);

/* Makes a backup copy of the lookup cache data file. If a backup is already
 * present, it will be replaced by the new backup.
 *
 * Arguments:	None
 */
gn_error_t
gn_lookup_cache_backup(void);

/* Replaces the lookup cache with its backup. If a backup is not present,
 * EDBIMERR_RevertMissingBackup error will be returned. In this case, if the
 * cache is corrupt, it will likely be necessary to delete it with
 * gn_lookup_cache_delete().
 *
 * Arguments:	None
 */
gn_error_t
gn_lookup_cache_revert(void);

/* Deletes the lookup cache file and, if present, the backup file.
 *
 * Arguments:	None
 */
gn_error_t
gn_lookup_cache_delete(void);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_LOOKUP_CACHE_H_ */
