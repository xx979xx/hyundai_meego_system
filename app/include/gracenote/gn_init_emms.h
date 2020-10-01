/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_init_emms.h:
 *
 *   This header declares the primary interface of the initialization subsystem
 *
 *   This subsystem provides an integrated interface for initialization of the
 *   eMMS library. It also provides support for operations related to
 *   initialization, e.g. configuration, update and recovery.
 *
 *   The complete set of functionality supported by the initialization
 *   subsystem is
 *     library initialization
 *     library configuration
 *     database updates
 *     database validation
 *     database recovery
 *     retrieval of product information
 *
 *   The subsystem's interface is declared in the the following header files.
 *     gn_init_emms.h
 *       - Library initialization and configuration.
 *     gn_validate.h
 *       - Database validation interface. (Some validation is done during
 *         system initialization and also during database updates.)
 *     gn_build.h
 *       - Retrieval of product information.
 *          - library version and build time
 *          - product configuration
 *          - database version and applied update levels, if applicable
 *          - database validation interface
 *     gn_updater.h
 *       - Database integrated update interface.
 *       - Database recovery interface.
 *         The recovery functions declared in gn_updater.h are for recovering
 *         files which are updated via the integrated update process, also
 *         declared in gn_updater.h.
 */

#ifndef	_GN_INIT_EMMS_H_
#define	_GN_INIT_EMMS_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_validate.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Macros
 */

/* String values for true and false for setting the configuration values marked
 * "bool" in gn_emms_configuration_t.
 */
#define GN_STR_TRUE					"TRUE"
#define GN_STR_FALSE				"FALSE"

/* Macrose to be assigned to symbols of type gninit_install_flags. */
#define GNINIT_INSTALL_LFS			0x1
#define GNINIT_INSTALL_PRODUCT		0x2
#define GNINIT_INSTALL_ALL			(GNINIT_INSTALL_LFS | GNINIT_INSTALL_PRODUCT)

/*
 * Typedefs
 */

typedef gn_uint32_t gninit_install_flags;


/* gn_emms_configuration_t: configuration structure for the emms library
 *
 * Parameter values are represented as strings in the structure.
 *   Any parameter can be set to GN_NULL for the default value of that
 *   parameter to be taken. In most cases, the default value will be fine.
 *
 *   Parameters which are not GN_NULL are converted from their string
 *   representations as follows:
 *     bool: If not GN_NULL must be either GN_STR_FALSE or GN_STR_TRUE for
 *           false or true respectively
 *     unsigned: If not GN_NULL must be a string representation of a 32-bit unsigned
 *           integer in base 10 e.g. "1234567890".
 *     string: Will be >copied< to a new string by the initialization routine.
 *
 *   Ownership of all parameters is retained by the original owner.  If a
 *   configuration struct was passed in to gninit_initialize_emms(), it is
 *   safe to free that struct and all of its elements upon return.
 *
 * The various "_path" members of the configuration structure determine the
 * locations of different local database files used by the library. The
 * following table shows which local database files' locations are controlled
 * by each of the "_path" members of a gn_emms_configuration_t. For any
 * "_path" member of the configuration structure which is not set, the
 * corresponding files will be located in the working directory. In the table,
 * items with angled bracket text, e.g. l<region><lang>.db, represent multiple
 * files. In the actual filename, the angled bracket text is substituted with a
 * filename substring.
 *
 * Note, the table lists the complete set of files available. Your product will
 * have a subset of these files. A description of which files are required for
 * each product feature can be found in the Library Reference Manual. From that
 * you can determine which files are actually installed on your device.
 *
 *         MEMBER                            ASSOCIATED FILES
 *
 * base_database_path              emms.idx, emms.mdt, emms.fpx
 *                                 elists.inv, l<region><lang>.db
 *                                 cddbplm.gcf, pstplgen.bml
 *                                 contrib.tbl, genres.tbl, album.tbl
 *                                 emms.pmx
 *                                 emms.cax, emms.cam, emms.cgx, emms.cgm
 * update_database_path            emms.udx, emms.udt, emms.upx
 *                                 emms.xdx, emms.xdt
 *                                 elists.unv, l<region><lang>.udb
 *                                 cddbplm.ucf, pstplgen.uml
 *                                 contrib.ubl, genres.ubl, album.ubl
 *                                 emms.umx
 *                                 emms.uax, emms.uam, emms.ugx, emms.ugm
 * backup_database_path            emms_bk.udx, emms_bk.udt, emms_bk.upx
 *                                 emms_bk.xdx, emms_bk.xdt
 *                                 elistsbk.unv, l<region><lang>b.udb
 *                                 cddbplmb.ucf, pstpl_bk.uml
 *                                 contribb.ubl, genresbk.ubl, album_bk.ubl
 *                                 emms_bk.umx,
 *                                 emms_bk.uax, emms_bk.uam, emms_bk.ugx, emms_bk.ugm
 * playlist_data_file_path         usrplgen.bml
 *                                 imgr_cnf.xml
 *                                 mldb<collection_ID>.idx
 *                                 mldb<collection_ID>.pdb
 * playlist_backup_data_file_path  usrpl_bk.bml
 *                                 mldb<collection_ID>b.idx
 *                                 mldb<collection_ID>b.pdb
 * apm_cache_path                  emms.ach
 * apm_cache_backup_path           emms_bk.ach
 * lookup_cache_path               emms.chx
 * lookup_cache_backup_path        emms_bk.chx
 * cd_cache_path                   emms.cch
 * cd_cache_backup_path            emms_bk.cch
 *
 * The following path configuration members will override the above values for
 * the specified files in the event of conflicts.
 *
 * The text id files are often accessed in a batch lookup mode with potentially
 * many random file accesses per lookup. For this reason, it may be useful for
 * some applications to be able to split these files off onto faster storage.
 * Note that the genres.tbl is updated via online LFS updates while updates for
 * contrib.tbl and album.tbl are not supported at this time.
 * The following path elements allow this to be done.
 *
 * textid_database_path            contrib.tbl, genres.tbl, album.tbl
 * textid_update_database_path     genres.ubl
 * textid_backup_database_path     genresbk.ubl
 *
 * The local cover art database files are significantly larger than other local
 * database files. For this reason, it may be useful for some applications to
 * be able to split these files off onto dedicated storage.
 *
 * cover_art_database_path            emms.cax, emms.cam
 *
 * TextID In-Memory Caching
 *
 * The TextID cache is made up of 4 indivual caches:
 * a cache for album results, a cache for composer results,
 * a cache for lead performer results, and a cache for genre
 * results.
 * Each of these caches can have user selectable maximum values or can be turned 
 * off indepently.
 * Setting a value of 0 will result in the cache being turned off.
 * A positive, non-zero maximum value will result in a cache
 * being created that will not exceed the specified number of
 * records.
 *
 * The following fields can be set to limit or turn off a
 * particular cache.
 *
 * textid_lead_performer_cache_max
 * textid_composer_cache_max
 * textid_genre_cache_max
 * textid_album_cache_max
 *
 * If any of these values are left unset, a default cache maximum is used.
 */
typedef struct gn_emms_configuration_s
{
	/* configure the path for installed local databases */
	gn_uchar_t* base_database_path;                         /* string */
	gn_bool_t   set_base_database_path;

	/* Local database validation to do during system initialization. */
	gn_uchar_t* validation_init_ops;                        /* unsigned */
	gn_bool_t   set_validation_init_ops;

	/* Client ID, Client ID Tag and local entitlements key. */
	gn_uchar_t* client_id;                                  /* string */
	gn_bool_t   set_client_id;
	gn_uchar_t* client_id_tag;                              /* string */
	gn_bool_t   set_client_id_tag;
	gn_uchar_t* LDAC_key;                                   /* string */
	gn_bool_t   set_LDAC_key;

	/* If set to GN_TRUE, files will be opened and closed as needed by eMMS. */
	/* If not set, most files will be opened by gninit_initialize_emms() and */
	/* remain open until gninit_shutdown_emms() is called. If set to GN_TRUE */
	/* there will be fewer open file handles but performance may be impacted */
	/* for some operations. */
	gn_uchar_t* minimize_file_handles;                      /* bool */
	gn_bool_t   set_minimize_file_handles;

	/* configure "lists" subsystem */
	gn_uchar_t* list_db_buffer_size;                        /* unsigned */
	gn_bool_t   set_list_db_buffer_size;
	gn_uchar_t* display_language_id;                        /* string */
	gn_bool_t   set_display_language_id;
	gn_uchar_t* genre_display_hierarchy_id;                 /* string */
	gn_bool_t   set_genre_display_hierarchy_id;
	gn_uchar_t* genre_display_level;                        /* unsigned */
	gn_bool_t   set_genre_display_level;
	gn_uchar_t* video_genre_display_level;                  /* unsigned */
	gn_bool_t   set_video_genre_display_level;

	/* enable video lookup functionality */
	gn_uchar_t* enable_video;                               /* bool */
	gn_bool_t   set_enable_video;

	/* enable and configure Playlist functionality */
	gn_uchar_t* playlist_data_file_path;                    /* string */
	gn_bool_t   set_playlist_data_file_path;
	gn_uchar_t* playlist_backup_data_file_path;             /* string */
	gn_bool_t   set_playlist_backup_data_file_path;
	gn_uchar_t* playlist_mldb_buffer_size;                  /* unsigned */
	gn_bool_t   set_playlist_mldb_buffer_size;
	gn_uchar_t* genre_correlates_db_buffer_size;            /* unsigned */
	gn_bool_t   set_genre_correlates_db_buffer_size;
	gn_uchar_t* enable_playlist;                            /* bool */
	gn_bool_t   set_enable_playlist;

		/*	enable_mldb_lite_index set to TRUE is intended for Playlist configurations running on low-end
		 *	hardware with slow file I/O. It effects the creation of the Playlist MLDB by reducing the
		 *	number of index fields to the bare minimum necessary for MoreLikeThis. This results in
		 *	faster MLDB creation but very limited playlisting capabilities.
		 *
		 *	This option is not meant to be changed on the fly. You either ship your product with this
		 *	option set TRUE or let it default to FALSE.
		 *
		 *	See the reference manual for complete information before using this option.
		 */
	gn_uchar_t* enable_mldb_lite_index;						/* bool */
	gn_bool_t   set_enable_mldb_lite_index;

	/* enable and configure local CD lookup functionality */
	gn_uchar_t* album_db_lookup_buffer_size;                /* unsigned */
	gn_bool_t   set_album_db_lookup_buffer_size;
	gn_uchar_t* album_db_update_buffer_size;                /* unsigned */
	gn_bool_t   set_album_db_update_buffer_size;
	gn_uchar_t* enable_cd_local;                            /* bool */
	gn_bool_t   set_enable_cd_local;

	/* enable and configure "textid" functionality to support Playlist Plus */
	gn_uchar_t* textid_database_path;                       /* string */
	gn_bool_t   set_textid_database_path;
	gn_uchar_t* textid_update_database_path;                /* string */
	gn_bool_t   set_textid_update_database_path;
	gn_uchar_t* textid_backup_database_path;                /* string */
	gn_bool_t   set_textid_backup_database_path;
	gn_uchar_t* textid_contrib_table_path;                  /* string */
	gn_bool_t   set_textid_contrib_table_path;
	gn_uchar_t* textid_db_update_buffer_size;               /* unsigned */
	gn_bool_t   set_textid_db_update_buffer_size;
	gn_uchar_t* textid_db_lookup_buffer_size;               /* unsigned */
	gn_bool_t   set_textid_db_lookup_buffer_size;
	gn_uchar_t* enable_textid;								/* bool */
	gn_bool_t   set_enable_textid;
	/* textid in memory result cache */
	gn_uchar_t* textid_lead_performer_cache_max;            /* unsigned */
	gn_bool_t   set_textid_lead_performer_cache_max;
	gn_uchar_t* textid_composer_cache_max;                  /* unsigned */
	gn_bool_t   set_textid_composer_cache_max;
	gn_uchar_t* textid_genre_cache_max;                     /* unsigned */
	gn_bool_t   set_textid_genre_cache_max;
	/* album lookups for textid */
	gn_uchar_t* enable_textidalb;                           /* bool */
	gn_bool_t   set_enable_textidalb;	
	gn_uchar_t* textid_album_cache_max;                     /* unsigned */
	gn_bool_t   set_textid_album_cache_max;	

	/* enable classical music support */
	gn_uchar_t* enable_classical;                           /* bool */
	gn_bool_t   set_enable_classical;

	/* enable and configure MediaVOCs functionality */
/* DEPRECATED */
/* Has no effect on the behavior of MediaVOCS */
	gn_uchar_t* default_spoken_language_id;                 /* string */
	gn_bool_t   set_default_spoken_language_id;
/* END DEPRECATED */
	gn_uchar_t* enable_mediavocs;                           /* bool */
	gn_bool_t   set_enable_mediavocs;
	gn_uchar_t* apm_cache_path;                             /* string */
	gn_bool_t   set_apm_cache_path;
	gn_uchar_t* apm_cache_backup_path;
	gn_bool_t   set_apm_cache_backup_path;
	gn_uchar_t* apm_cache_db_buffer_size;
	gn_bool_t   set_apm_cache_db_buffer_size;

	/* enable and configure cover art functionality */
	gn_uchar_t* cover_art_database_path;                    /* string */
	gn_bool_t   set_cover_art_database_path;
	gn_uchar_t* cover_art_db_buffer_size;                   /* unsigned */
	gn_bool_t   set_cover_art_db_buffer_size;
	gn_uchar_t* enable_cvrt_local;                          /* bool */
	gn_bool_t   set_enable_cvrt_local;
	gn_uchar_t* cover_art_online_image_dimension;           /* unsigned */
	gn_bool_t   set_cover_art_online_image_dimension;

	/* configure the local lookup cache */
	gn_uchar_t* lookup_cache_warn_size;                     /* unsigned */
	gn_bool_t   set_lookup_cache_warn_size;	
	gn_uchar_t* lookup_cache_max_size;                      /* unsigned */
	gn_bool_t   set_lookup_cache_max_size;
	gn_uchar_t* lookup_cache_path;                          /* string */
	gn_bool_t   set_lookup_cache_path;
	gn_uchar_t* lookup_cache_backup_path;                   /* string */
	gn_bool_t   set_lookup_cache_backup_path;
	gn_uchar_t* lookup_cache_db_buffer_size;                /* unsigned */
	gn_bool_t   set_lookup_cache_db_buffer_size;
	/* cover art in the local lookup cache */
	gn_uchar_t* lookup_cache_cover_art_max_count;           /* unsigned */
	gn_bool_t   set_lookup_cache_cover_art_max_count;	
	gn_uchar_t* lookup_cache_cover_art_max_age;             /* unsigned */
	gn_bool_t   set_lookup_cache_cover_art_max_age;	

	/* configure incremental updates, LFS updates and secondary updates */
	gn_uchar_t* update_database_path;                       /* string */
	gn_bool_t   set_update_database_path;
	gn_uchar_t* backup_database_path;                       /* string */
	gn_bool_t   set_backup_database_path;
	gn_uchar_t* no_update_backups;                          /* bool */
	gn_bool_t   set_no_update_backups;
	gn_uchar_t* transfer_buffer;                            /* unsigned */
	gn_bool_t   set_transfer_buffer;
	gn_uchar_t* validation_upd_ops;                         /* unsigned */
	gn_bool_t   set_validation_upd_ops;

	/* configure fingerprint lookups */
	gn_uchar_t* max_fingerprint_results;                    /* unsigned */
	gn_bool_t   set_max_fingerprint_results;

	/* configure the on-demand lookup cache */
	gn_uchar_t* cd_cache_path;                              /* string */
	gn_bool_t   set_cd_cache_path;
	gn_uchar_t* cd_cache_backup_path;                       /* string */
	gn_bool_t   set_cd_cache_backup_path;
	gn_uchar_t* cd_cache_db_lookup_buffer_size;             /* unsigned */
	gn_bool_t   set_cd_cache_db_lookup_buffer_size;
	gn_uchar_t* cd_cache_db_update_buffer_size;             /* unsigned */
	gn_bool_t   set_cd_cache_db_update_buffer_size;

	/* enable and configure online lookups and On-Demand Lookups */
	gn_uchar_t* reg_file_path;                              /* string */
	gn_bool_t   set_reg_file_path;
	gn_uchar_t* preferred_language_id;                      /* string */
	gn_bool_t   set_preferred_language_id;

	/* enable and configure online lookups */
	gn_uchar_t* enable_online;                              /* bool */
	gn_bool_t   set_enable_online;
	gn_uchar_t* online_proxy_url;                           /* string */
	gn_bool_t   set_online_proxy_url;
	gn_uchar_t* online_proxy_username;                      /* string */
	gn_bool_t   set_online_proxy_username;
	gn_uchar_t* online_proxy_password;                      /* string */
	gn_bool_t   set_online_proxy_password;
} gn_emms_configuration_t;

/*
 * Prototypes.
 */

/* gnconf_initialize_configuration
 *
 *  Behavior: Sets pointer members of the given configuration structure to
 *            GN_NULL and other members to 0.  Calling this function is
 *            recommended prior to assigning any members to their desired
 *            values.
 *
 *  Args:	IN: configuration - Refer to comments at the head of the structure
 *                              declaration for details and cautions.
 *
 *  Remarks: This function does not rely on the emms system having been
 *           initialized.
 *           It does not free any memory.  It only assigns structure members
 *           to GN_NULL or 0.
 *
 *  Return values: If GN_SUCCESS is returned, the structure has been properly
 *                 initialized.
 *                 Errors which can originate in this function are
 *                 - GENERR_InvalidArg: indicates config was GN_NULL on input
 */
gn_error_t
gnconf_initialize_configuration(
	gn_emms_configuration_t* configuration
);

/* gninit_initialize_emms
 *
 * Behavior: Initializes all required Embedded MMS subsystems.
 *
 *  Args: IN: configuration - A configuration structure. 
 *              See comments before the declaration of
 *              gn_emms_configuration_t declaration for details about this
 *              structure.
 */
gn_error_t
gninit_initialize_emms(
	gn_emms_configuration_t* configuration
);

/* gninit_initialize_emms_safe
 *
 * Behavior: Initializes all required Embedded MMS subsystems in safe mode. In
 *    safe mode, database files are not opened. This allows initialization in
 *    the event of a corrupt database so that recovery can be attempted. Invoke
 *    gninit_initialize_emms_safe() in the following situations.
 *
 *    - gninit_initialize_emms() returned VALIDATEERR_InvalidDatabase
 *
 *    - if gninit_initialize_emms() returned GN_SUCCESS but library behavior
 *      causes you to suspect a corrupt database. In this case, you may want
 *      to elevate the level of validation which is done during initialization
 *      by providing a gn_emms_configuration_t structure with the
 *      validation_init_ops member set. See gn_validate.h for details.
 *
 *    If gninit_initialize_emms_safe() returns GN_SUCCESS, error analysis can
 *    be performed by examining the validation output argument.
 *    See gn_validate.h for details.
 *
 *    Validation will be performed by gninit_initialize_emms_safe() according
 *    to the validation_init_ops member of the configuration structure or, if
 *    that was not set, according to GN_VALIDATE_OPS_INIT_OPS.
 *
 * Args: IN: configuration - Should be the same configuration structure which
 *             was passed to the failed call to gninit_initialize_emms(), or
 *             GN_NULL if a configuration structure was passed to
 *             gninit_initialize_emms(). If GN_SUCCESS was returned by
 *             gninit_initialize_emms() but subsequent library behavior causes
 *             you to suspect a corrupt database, you may wish to shutdown the
 *             library and call this function with an elevated value of
 *             validation_init_ops. See gn_validate.h for details.
 *       OUT: validation - On successful return, this will be an allocated
 *             gn_validate_t structure, suitable for gn_update_recover(). It
 *             may also be examined by the application understand what
 *             gn_update_recover() would do, giving the application the chance
 *             to perform a different action, e.g. gn_update_revert(),
 *             gn_update_backup() or gn_update_delete().
 *
 * NOTE: The validation output argument must be freed by you via a call to
 *       gn_validation_smart_free_validation().
 */
gn_error_t
gninit_initialize_emms_safe(
	gn_emms_configuration_t* configuration,
	gn_validate_t**           validation
);

/* gninit_shutdown_emms
 *
 * Behavior: Cleanly shuts down all emms subsystems. This function must be
 *           before the application exits or the database files may be left in
 *           an invalid state which will cause an error the next time
 *           gninit_initialize_emms() is called.
 *
 *           After this function executes, no Embedded MMS functionality will
 *           be available.
 */
gn_error_t
gninit_shutdown_emms(void);

/* gninit_check_indexfile_crc
 *
 * Behavior: Check the CRC value in the given index file.
 *           NOTE: This function calculates the CRC of the given file and
 *                 so may may require some time to complete.
 *
 * Args: IN: filename - Filename, with any necessary path components, of the
 *             file to be checked.
 *       OUT: crc_ok - This argument only has meaning if the function returns
 *             GN_SUCCESS. If crc_ok is handed back as GN_FALSE, the crc in the
 *             file header is inconsistent with the crc calculated by this
 *             function.
 */
gn_error_t
gninit_check_indexfile_crc(
	const gn_uchar_t* filename,
	gn_bool_t*        crc_ok
);

/* gninit_check_flatfile_crc
 *
 * Behavior: Check the CRC value in the given flat file.
 *           NOTE: This function calculates the CRC of the given file and
 *                 so may may require some time to complete.
 *
 * Args: IN: filename - Filename, with any necessary path components, of the
 *             file to be checked.
 *       OUT: crc_ok - This argument only has meaning if the function returns
 *             GN_SUCCESS. If crc_ok is handed back as GN_FALSE, the crc in the
 *             file header is inconsistent with the crc calculated by this
 *             function.
 */
gn_error_t
gninit_check_flatfile_crc(
	const gn_uchar_t* filename,
	gn_bool_t*        crc_ok
);

/*
 * gninit_install_local_db
 * 
 * Behavior:	Installs all required database files for the features enabled
 *				in the gn_emms_configuration_t data structure from the install
 *				package located at install_package_path.
 *				
 * Args: IN: configuration - A configuration structure. If this
 *              See comments before the declaration of
 *              gn_emms_configuration_t declaration for details about this
 *              structure.
 *			 install_package_path - The directory that contains the install
 *				package. Must include the final directory delimiter.
 *           client_lfs_id - The List File Set ID provided by Gracenote.
 *           flags - Determines whether to install the List File Set files, the product files or both.
 */
gn_error_t
gninit_install_local_db(
	gn_emms_configuration_t*	configuration,
	gn_uchar_t*					install_package_path,
	gn_uint32_t					client_lfs_id, 
	gninit_install_flags		flags
);

/* gninit_uninstall_local_db
 *
 * Behavior: Removes all local database files which were installed by the most recent call to gnini_install_local_db.
 *               Does not remove update database files.
 *               This function may be used in the event that database validation detects an issue with the base database files,
 *               i.e. gninit_initialize_emms_safe() indicates an action or an lfs_action of GN_VALIDATE_ACTION_BASE_RESTORE.
 *
 *               Note, emms should be shut down prior to executing this command.
 *
 * Args: IN: flags - Determines whether to remove the List File Set files, the product files or both.
 */
gn_error_t
gninit_uninstall_local_db(
	gn_emms_configuration_t*	configuration,
	gninit_install_flags		flags
);

#ifdef __cplusplus
}
#endif

#endif
