/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_build.h - The declarations below provide access to the library build
 *              information, e.g. build date and product configuration, as well
 *              the installed database revision and, if applicable, the levels
 *              of any installed updates.
 */


#ifndef	_GN_BUILD_H_
#define _GN_BUILD_H_


/*
 * Dependencies.
 */

#include	"gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/**
 ** structures and typedefs
 **/

/* The following types are used to indicate revision information of the
 * installed database.
 * Note, this does not refer to user created files which are supported in some
 * configurations, such as playlist metadata databases, the user playlist
 * generator database, the lookup_cache, etc.
 */
typedef gn_uint32_t gn_db_rev_t;
typedef gn_uint32_t gn_upd_lvl_t;

/* This is the size of the ASCII character array which holds the export date of the base database. */
/* As of this writing, the required size of the array is 21 elements, including the terminal '\0'. */
/* The additional 10 characters accommodate a 4 digit "partial-time" with a leading '.' and the */
/* replacement of the "time-offset", 'Z', with a "time-numoffset" of the form "hh:mm". */
#define MAX_EXPORT_TIME_SIZE 32

/* gn_sys_install_profile_t
 *
 *   lfs_revision:     Revision of the installed LFS set for this configuration.
 *   base_db_revision: Revision of database snapshot included in the initially
 *                     installed, i.e. base, local database.
 *   data_snapshot_date: Date and time when the local database snapshot was
 *                       made. The format follows the RFC 3339 specification,
 *                       with the added requirement that the parenthetically
 *                       suggested replacement of the "T" time separator with a
 *                       space is the only allowable time separator replacement
 *                       character.
 *   update_count:    Total number of updates performed.
 *   update_lvl_element_count: Number of elements in update_level_list.
 *   update_lvl_list: Identifier of each update which has been applied to the
 *                    local database.
 */
typedef struct sys_install_profile
{
	gn_uint32_t    lfs_revision;
	gn_db_rev_t    base_db_revision;
	gn_uchar_t     data_snapshot_date[MAX_EXPORT_TIME_SIZE];
	gn_uint32_t    update_count;
	gn_uint32_t    update_lvl_element_count;
	gn_upd_lvl_t*  update_lvl_list;
} gn_sys_install_profile_t;


/**
 ** Prototypes.
 **/

/* Get build string containing much of the information provided by the rest of
 * the functions declared below.
 *   The summary contains: library build data and time,
 *                         client ID and client ID tag,
 *                         eMMS library version,
 *                         common and platform specific abstract layer version
 *                         vendor's software and hardware versions,
 *                         a description of the product configuration.
 */
gn_uchar_t*
gn_get_build_summary(void);

/* Get vendor/build strings */

/* Returns the date at which the library was built. */
const gn_uchar_t*
gn_get_build_date(void);

/* Returns the time at which the library was build. */
const gn_uchar_t*
gn_get_build_time(void);

/* Returns pointer client ID. */
const gn_uchar_t*
gn_get_client_id(void);

/* Return pointer to client ID tag */
const gn_uchar_t*
gn_get_cid_tag(void);


/* Returns the eMMS library version number of the build. */
const gn_uchar_t*
gn_get_emms_version(void);

/* gn_sys_get_install_profile
 *
 *   Behavior: Checks that the version information (profile) of all files in
 *             the database installation matches.
 *             If so provides a copy of that information to the caller via the
 *             install_profile output argument.
 *             If not returns an error and does not modify the output argument.
 *
 *   Args: OUT: install_profile - Upon successful return, holds the version
 *               information of the installed database.
 *
 *   NOTE: On successful completion, this function will have allocated memory
 *         for *install_profile. You must free it with
 *         gn_sys_destroy_install_profile().
 */
gn_error_t
gn_sys_get_install_profile(
	gn_sys_install_profile_t** install_profile
);

/* gn_sys_destroy_install_profile
 *
 * Behavior: If install_profile != GN_NULL and *install_profile != GN_NULL,
 *           this function releases all memory held by *install_profile and
 *           sets it to GN_NULL.
 */
gn_error_t
gn_sys_destroy_install_profile(
	gn_sys_install_profile_t** install_profile
);

#ifdef __cplusplus
}
#endif 


#endif /* _BUILD_H_ */
