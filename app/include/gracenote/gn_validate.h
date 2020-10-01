/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_validate.h - The declarations below facilite validation and recovery of
 *                 the embedded database files. Note that the types of database
 *                 errors from which the eMMS library can recover is limited to
 *                 errors with the database update files. This is because the
 *                 eMMS library does not keep backup copies of the base
 *                 database files. If your product configuration supports
 *                 database updates, you can find the recovery interface in
 *                 gn_updater.h.
 */


#ifndef	_GN_VALIDATE_H_
#define _GN_VALIDATE_H_


/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_build.h"

#ifdef __cplusplus
extern "C"{
#endif 

/**
 ** constants
 **/

/* The following constants are used to guide validation which is performed by
 * gninit_initialize_emms_safe(). Details can be found gn_validate.h.
 *
 * GN_VALIDATE_OPS_HEADERS:  Check validity of file headers. This also checks
 *                           - consistency of profile information across files
 *                           - if upd and bkp are present, that their headers
 *                             match
 * GN_VALIDATE_OPS_UPD_CRC:  If upd is present check that the stored CRC is
 *                         correct. This requires calculating the CRC of the
 *                         update files. This implies checking headers of
 *                         update files. If a header error is detected, the crc
 *                         will not be checked.
 * GN_VALIDATE_OPS_BKP_CRC:  If bkp is present check that the stored CRC is
 *                         correct. This requires calculating the CRC of the
 *                         backup files. This implies checking headers of
 *                         backup files. If a header error is detected, the crc
 *                         will not be checked.
 * GN_VALIDATE_OPS_UPD_SPOT: If upd and bkp are present do a "spot-check" that
 *                         they match. This means comparing a preset number of
 *                         bytes at a few evenly spaced locations within the
 *                         files.
 * GN_VALIDATE_OPS_UPD_IDX_BYTE: If upd and bkp are present do a byte-by-byte
 *                             comparison to see if the files match.
 * GN_VALIDATE_OPS_UPD_FLAT_BYTE: If upd and bkp are present do a byte-by-byte
 *                             comparison to see if the files match.
 * GN_VALIDATE_OPS_IDX_CRC:  Check the CRC of all base index files. This turns
 *                         on checking the headers of base index files. If a
 *                         header error is detected, the crc will not be
 *                         checked.
 * GN_VALIDATE_OPS_FLAT_CRC:  Check the CRC of all base flat files. Because flat
 *                         file corruption is often less detrimental than index
 *                         file corruption, and because flat files are often
 *                         larger, thereby making CRC calculation more time
 *                         consuming, flat file CRC checks are enabled
 *                         independently of index file CRC checks. This implies
 *                         checking the headers of base flat files.
 * GN_VALIDATE_OPS_INIT_MODE: Used internally by the library. If a header error
 *                          is detected, the crc will not be checked.
 *
 * Note that this set of constants provides alternative ways of doing exactly
 * the same level of validation. This is in recognition of the fact that there
 * may be differences as to which operations are more efficient on different
 * platforms. It is up to you to determine the level of validation you wish to
 * to do in a given circumstance, which options are more efficient on your
 * platform and to avoid including redundant, time-consuming validation. For
 * example, if your ops includes x_HEADERS, x_UPD_CRC and x_BKP_CRC, then
 * including x_UPD_SPOT, x_UPD_IDX_BYTE or x_UPD_FLT_BYTE will not yield any
 * additional information.
 */
#define GN_VALIDATE_OPS_HEADERS       0x001
#define GN_VALIDATE_OPS_UPD_CRC       0x002
#define GN_VALIDATE_OPS_BKP_CRC       0x004
#define GN_VALIDATE_OPS_UPD_SPOT      0x008
#define GN_VALIDATE_OPS_UPD_IDX_BYTE  0x010
#define GN_VALIDATE_OPS_UPD_FLAT_BYTE 0x020
#define GN_VALIDATE_OPS_IDX_CRC       0x040
#define GN_VALIDATE_OPS_FLAT_CRC      0x080
#define GN_VALIDATE_OPS_INIT_MODE     0x100

/* GN_VALIDATE_OPS_INIT_OPS: Indicates what validation steps will be done during
 *                         Embedded MMS initialization. You can override this
 *                         via the validation_init_ops member of a
 *                         gninit_configuration_t structure.
 */
#define GN_VALIDATE_OPS_INIT_OPS (GN_VALIDATE_OPS_HEADERS)

/* The following constants indicate the result of the validation. They are bits
 * assigned to the status word of gn_validate_file_t, gn_validate_file_table_t
 * and gn_validate_t structures.
 *
 * GN_VALIDATE_STATUS_OK - All OK. All bits cleared.
 * GN_VALIDATE_STATUS_Failure - An error has been detected at a lower level. No
 *   additional bits will be set at this level.
 *
 *   The next set apply only to gn_validate_file_t structures.
 * GN_VALIDATE_STATUS_FileOpenError
 * GN_VALIDATE_STATUS_UniversalHeaderLoadError
 * GN_VALIDATE_STATUS_InvalidUniversalHdrMagic
 * GN_VALIDATE_STATUS_InvalidDataFormatVersion
 * GN_VALIDATE_STATUS_UnknownUniversalHeaderErr
 * GN_VALIDATE_STATUS_CRCError
 * GN_VALIDATE_STATUS_InvalidByteOrder
 * GN_VALIDATE_STATUS_IncorrectFileType
 * GN_VALIDATE_STATUS_UpdateLevelCountTooHigh
 *
 *   The next set apply only to gn_validate_file_table_t structures.
 * GN_VALIDATE_STATUS_NoDB
 * GN_VALIDATE_STATUS_NoUpdateDB
 * GN_VALIDATE_STATUS_NoBackupUpdateDB
 * GN_VALIDATE_STATUS_UpdBkpDBRevsDiffer
 * GN_VALIDATE_STATUS_BkpMissingLevels
 * GN_VALIDATE_STATUS_UpdMissingLevels
 * GN_VALIDATE_STATUS_UpdBkpLevelsDiffer
 * GN_VALIDATE_STATUS_UpdBkpDiffer
 *
 *   The next set apply only to gn_validate_t structures.
 * GN_VALIDATE_STATUS_DBRevsDiffer
 * GN_VALIDATE_STATUS_LevelsDiffer
 * GN_VALIDATE_STATUS_LFSIDsDiffer
 */
#define GN_VALIDATE_STATUS_OK                                 0
#define GN_VALIDATE_STATUS_Failure                          0x1
#define GN_VALIDATE_STATUS_FileOpenError                    0x2
#define GN_VALIDATE_STATUS_UniversalHeaderLoadError			0x4
#define GN_VALIDATE_STATUS_InvalidUniversalHdrMagic         0x8
#define GN_VALIDATE_STATUS_InvalidDataFormatVersion        0x10
#define GN_VALIDATE_STATUS_UnknownUniversalHeaderErr       0x20
#define GN_VALIDATE_STATUS_InvalidByteOrder                0x40
#define GN_VALIDATE_STATUS_IncorrectFileType               0x80
#define GN_VALIDATE_STATUS_UpdateLevelCountTooHigh        0x100
#define GN_VALIDATE_STATUS_NoDB                           0x200
#define GN_VALIDATE_STATUS_NoUpdateDB                     0x400
#define GN_VALIDATE_STATUS_NoBackupUpdateDB               0x800
#define GN_VALIDATE_STATUS_CRCError                      0x1000
#define GN_VALIDATE_STATUS_UpdBkpDBRevsDiffer            0x2000
#define GN_VALIDATE_STATUS_BkpMissingLevels              0x4000
#define GN_VALIDATE_STATUS_UpdMissingLevels              0x8000
#define GN_VALIDATE_STATUS_UpdBkpLevelsDiffer           0x10000
#define GN_VALIDATE_STATUS_UpdBkpDiffer                 0x20000
#define GN_VALIDATE_STATUS_DBRevsDiffer                 0x40000
#define GN_VALIDATE_STATUS_LevelsDiffer                 0x80000
#define GN_VALIDATE_STATUS_LFSIDsDiffer                0x100000

/* GN_VALIDATE_COMPARE_POINTS: In the event that GN_VALIDATE_OPS_UPD_SPOT is
 *   set, this indicates the number of points within the file which will be
 *   compared.
 * GN_VALIDATE_COMPARE_SIZE: In the event that GN_VALIDATE_OPS_UPD_SPOT is set,
 *   this indicates the number of bytes which are compared each comparison
 *   point.
 *
 * NOTE: If (GN_VALIDATE_COMPARE_POINTS * GN_VALIDATE_COMPARE_SIZE) is greater
 *       than the size of the update file, then a full file comparison will be
 *       done even if GN_VALIDATE_OPS_UPD_SPOT is set.
 */
#define GN_VALIDATE_COMPARE_POINTS      5
#define GN_VALIDATE_COMPARE_SIZE     1024

/* The following constants are used to indicate the type of action which will
 * fix a database. These values are assigned to the "action" member of the
 * validation data structures during the validation process, i.e to
 *    gn_validate_t.action  or  gn_validate_t.lfs_action
 * or to
 *    gn_validate_t.file_detail[i]->action
 * Some of the values can only be assigned at either the gn_validate_t level or
 * at the gn_validate_file_table_t level.
 *
 * The meanings of the action values are different depending on where they are
 * assigned.
 *
 * At the gn_validate_t level the value indicates what the caller should do to
 * get the database to a good running state.
 *
 * At the gn_validate_t.file_detail[i]->action level the value indicates what
 * will happen to the particular update and update backup files described
 * under file_detail[i] if the application calls gn_update_recover().
 *
 * GN_VALIDATE_ACTION_NONE: If assigned to both gn_validate_t.action and
 *   gn_validate_t.lfs_action, indicates no problems were detected with the
 *   Embedded MMS database when validated with a given validation ops. If
 *   assigned to a gn_validate_file_table_t.action, indicates that if the
 *   application calls gn_update_recover(), the files associated with this
 *   gn_validate_file_table_t will not be affected.
 *
 * GN_VALIDATE_ACTION_BACKUP: This can only be assigned to the
 *   gn_validate_file_table_t.action. It indicates that if the application
 *   calls gn_update_recover() a backup of the update file associated with this
 *   gn_validate_file_table_t will be generated. If a backup file already
 *   exists, it will be replaced.
 *
 * GN_VALIDATE_ACTION_REVERT: This can only be assigned to the
 *   gn_validate_file_table_t.action. It indicates that if the application
 *   calls gn_update_recover() the backup file associated with this
 *   gn_validate_file_table_t will be copied over the update file for the files
 *   associated. This is the opposite action from GN_VALIDATE_ACTION_BACKUP.
 *
 * GN_VALIDATE_ACTION_DELETE: This can only be assigned to the
 *   gn_validate_file_table_t.action. It indicates that if the application
 *   calls gn_update_recover() both the update and the backup file associated
 *   with this gn_validate_file_table_t will be deleted. This could indicate
 *   that both of these files are corrupt. It could also indicate that a set
 *   of consistent, valid update files could not be found across all database
 *   files of a given group, e.g. all list based files or all non-list based
 *   files.
 *
 * GN_VALIDATE_ACTION_RECOVER: This can only be assigned to the
 *   gn_validate_t.action. It indicates that there is a problem with the one or
 *   more embedded database files, but that calling gn_update_recover() should
 *   restore the database files to a valid state. In this case, the action
 *   members of the individual gn_validate_file_table_t instances can be
 *   examined to determine the action that will be applied to that table.
 *
 * GN_VALIDATE_ACTION_BASE_RESTORE: This indicates that there is a problem with
 *   the database files which can be corrected by restoring the base database
 *   files which were initially installed on the device. The Embedded MMS
 *   library can not perform this operation. However, if a copy of the base
 *   database files are available to you, you can issue gninit_shutdown_emms(),
 *   replace the database files and attempt to reinitialize.
 *
 *   If assigned to gn_validate_t.action it indicates that at least one member
 *   of the gn_validate_t.file_detail array of gn_validate_file_t instances has
 *   this action set. If assigned to a gn_validate_file_t.action, it indicates
 *   that the specific (base) file, gn_validate_file_t.base.file_name, must be
 *   replaced. 
 *
 *   In the event that the validation determines a base restore is required, it
 *   does not attempt to indicate corrective actions for the update files, i.e
 *   status values will be set at lower levels of the validation structure, but
 *   actions will only be set for gn_validate_file_t members for which a base
 *   restore is required. If status is GN_VALIDATE_ACTION_BASE_RESTORE and you
 *   restore the base database files from a backup copy, problems may still be
 *   detected in the update files the next time you initialize the library.
 *
 *   If status = GN_VALIDATE_ACTION_BASE_RESTORE and you do not have access to a
 *   copy of the base database files, then the application will not be able to
 *   recover from the validation error.
 *
 * GN_VALIDATE_ACTION_UNKNOWN: This can only be assigned to the
 *   gn_validate_t.action. It indicates that there is a problem with the
 *   database, but that not enough information was available to determine the
 *   best corrective action. This may be the case if the validation options were
 *   set too low. In this case, you can do one of two things. You can issue a
 *   gn_update_recover(). This could perform a more drastic corrective action
 *   than is required, e.g. it may delete files that don't necessarily need to
 *   be deleted. Or, you could increase the validation options an rerun the
 *   validation, i.e. call gninit_initialize_emms_safe() again.
 *
 *   As an example, if your update and backup files were found to differ for
 *   gn_validate_t.file_detail[i], and these files have a CRC but you did not
 *   include CRC checking in the validation options, your gn_validate_t->action
 *   would be UNKNOWN and gn_validate_t.file_detail[i].action would be DELETE.
 *   If you issue gn_update_recover(), these files and all files in the same
 *   group (lfs or non-lfs), would be deleted. However, if you repeated the
 *   validation with CRC checking on, perhaps you would find that the update
 *   file was corrupt. In this case, gn_validate_t->action would come back as
 *   RECOVER and gn_validate_t.file_detail[i]->action would come back as REVERT.
 *
 *   As another example, if your update and backup files were found to differ
 *   for gn_validate_t.file_detail[i], and these files do not have a CRC, then
 *   regardless of whether or not you included CRC checking in your options, it
 *   is likely gn_validate_t.action would come back as RECOVER and
 *   gn_validate_t.file_detail[i].action would come back as DELETE.
 *
 * NOTES:
 *   If local database updates are not supported, the only values action can
 *   take are GN_VALIDATE_ACTION_ACTION_NONE and GN_VALIDATE_ACTION_BASE_RESTORE.
 *
 *   The actions GN_VALIDATE_ACTION_RECOVER and GN_VALIDATE_ACTION_UNKNOWN can
 *   only be set at the gn_validate_t level, not at the gn_validate_file_table_t
 *   level.
 *
 *   The actions GN_VALIDATE_ACTION_BACKUP, GN_VALIDATE_ACTION_REVERT and
 *   GN_VALIDATE_ACTION_DELETE can only be set at the gn_validate_file_table_t
 *   level, not at the gn_validate_t level.
 */

#define GN_VALIDATE_ACTION_NONE         0x1
#define GN_VALIDATE_ACTION_BACKUP       0x2
#define GN_VALIDATE_ACTION_REVERT       0x3
#define GN_VALIDATE_ACTION_DELETE       0x4
#define GN_VALIDATE_ACTION_RECOVER      0x5
#define GN_VALIDATE_ACTION_BASE_RESTORE 0x6
#define GN_VALIDATE_ACTION_UNKNOWN      0x7

/**
 ** structures and typedefs
 **/

/* The following types are used to declare symbols for assigning values of the
 * GN_VALIDATE_OPS_* and GN_VALIDATE_ACTION_* constants respectively.
 */
typedef gn_uint32_t gn_validate_ops_t;
typedef gn_uint32_t gn_validate_recover_enum_t;

/* For the structures gn_validate_file_t, gn_validate_file_table_t and
 * gn_validate_t, only those members which are consistent with the
 * validate_mask which was used to generate the information will be valid.
 */

/* NOTE: gn_validate_file_t is a member of gn_validate_file_table_t which in
 * turn is a member of gn_validate_t. When studying these three structures, it
 * is recommended that you start with gn_validate_t and work your way back to
 * gn_validate_file_t.
 */

/* gn_validate_file_t
 *
 * This structure contains information describing the state of a particular
 * database file.
 *
 * status - Status code from validation. Any non-GN_VALIDATE_STATUS_OK value
 *   indicates a problem with this file.
 *   Possible values of status are
 *     GN_VALIDATE_STATUS_OK - Indicates no problems with this file.
 *     GN_VALIDATE_STATUS_FileOpenError - Indicates that a file was found but
 *       that it could not be opened. For index files this could indicate a bad
 *       file format. For flat files it could indicate a file system problem.
 *     GN_VALIDATE_STATUS_InvalidUniversalHdrMagic - Indicates the file header
 *       could not be validated. No further validation could be done on this
 *       file.
 *     GN_VALIDATE_STATUS_InvalidDataFormatVersion - Indicates the file header
 *       version is incorrect. No further validation could be done on this file.
 *     GN_VALIDATE_STATUS_UnknownUniversalHeaderErr - Indicates an unknown
 *       error has been detected in the file header. No further validation
 *       could be done on this file.
 *     GN_VALIDATE_STATUS_InvalidByteOrder - Indicates the endianess of the
 *       data is not correct.
 *     GN_VALIDATE_STATUS_IncorrectFileType - Indicates the type field in the
 *       header is not consistent with the name of the file.
 *     GN_VALIDATE_STATUS_UpdateLevelCountTooHigh - Indicates an invalid value
 *       for the number of update levels. The profile information for this file
 *       will not be loaded.
 *     GN_VALIDATE_STATUS_CRCError - Indicates that the calculated CRC did not
 *       match the CRC value stored in the file.
 * file_name - Null terminated string with the name of the file. Path
 *   information is not included.
 * exists - A boolean value indicating whether or not the file is present.
 * has_crc - A boolean indicating whether the file has a CRC. Some larg files
 *           which are created by the library do not have CRC's calculated. An
 *           example of this is the CD metadata update file, emms.udt.
 * CRC - The CRC read from the file.
 * crc_checked - Boolean indicating whether CRC has been set.
 * profile - Database revision information of the file. If this represents a
 *   base database file only the base_db_revision will be set. If it represents
 *   an update file or an update backup file, only the update_level_* members
 *   will be set.
 */
typedef struct gn_validate_file_s
{
	gn_uint32_t               status;
	gn_uchar_t*               file_name;
	gn_bool_t                 exists;
	gn_bool_t                 has_crc;
	gn_uint32_t               CRC;
	gn_bool_t                 crc_checked;
	gn_sys_install_profile_t* profile;
} gn_validate_file_t;

/* gn_validate_file_table_t
 *
 * This structure contains information describing the state of a particular
 * base database file along with its update and update backup files.
 *
 * status - Status code from validation. Any non-GN_VALIDATE_STATUS_OK value
 *   indicates a problem with the files.
 *   Possible values of status are:
 *     GN_VALIDATE_STATUS_OK - No problems were detected at this level or in
 *       any of its members.
 *     GN_VALIDATE_STATUS_Failure - Indicates that at least one of the files
 *       had a status which was not GN_VALIDATE_STATUS_OK.
 *     GN_VALIDATE_STATUS_NoDB - Base database file is missing.
 *     GN_VALIDATE_STATUS_NoUpdateDB - Indicates that there is an update backup
 *       file but no live update file. This value will never be set if update
 *       backups have been disabled.
 *     GN_VALIDATE_STATUS_NoBackupUpdateDB - Indicates that the update file was
 *       present, but there was no backup file. This value will never be set if
 *       update backups have been disabled.
 *     GN_VALIDATE_STATUS_UpdBkpDBRevsDiffer - The base DB revision of the
 *       update file differs from that of the backup file.
 *     GN_VALIDATE_STATUS_UpdBkpLevelsDiffer - The update and backup file
 *       revision level values have differences.
 *     GN_VALIDATE_STATUS_BkpMissingLevels - The backup file has fewer update
 *       levels than the update file, but the values which are there match.
 *     GN_VALIDATE_STATUS_UpdMissingLevels - The update file has fewer update
 *       levels than the backup file, but the values which are there match.
 *     GN_VALIDATE_STATUS_UpdBkpDiffer - The update and backup files differ.
 *       This can only be set if one of the file compare options is selected,
 *       i.e. CRC, spot or byte-by-byte comparison. If the file header has been
 *       read and it shows differences, then one of the more specific errors,
 *       above in this list, will be set.
 * action - This value will indicate what action will applied to the files
 *   represented by the upd and bkp elements of this structure if
 *   gn_update_recover() is executed with the parent gn_validate_t structure
 *   passed in.
 * base - A gn_validate_file_t structure with the results of validation on the
 *   indicated base database file.
 * upd - A gn_validate_file_t structure with the results of validation on the
 *   indicated update database file. If updates are not supported this will
 *   always be set to GN_NULL.
 * bkp - A gn_validate_file_t structure with the results of validation on the
 *   indicated update backup database file. If update backups are not supported
 *   this will always be set to GN_NULL.
 * in_lfs - A value of GN_TRUE indicates the database is a member of the list
 *   file set. The meaning of the gn_sys_install_profile_t elements is different
 *   for members and non-members of the list file set. The profile
 *   consistency check across fill tables is made separately for tables which
 *   are in the list file set and tables which are not. In addition, members of
 *   the list file set are not required to have the base_db_revision of the
 *   base database file match that of the update and backup database files.
 *   This member will only be set if the profile information is available.
 * profile - If the profile of the upd and bkp elements of this structure match
 *   then this will contain that information along with the base revision value
 *   of the base element. Otherwise it will be GN_NULL. In that case, look to
 *   the profile members of the base, upd and bkp members for the profile
 *   information of each set of files. That will help you identify the
 *   inconsistency at this level.
 */
typedef struct gn_validate_file_table_s
{
	gn_uint32_t                status;
	gn_validate_recover_enum_t action;
	gn_validate_file_t*        base;
	gn_validate_file_t*        upd;
	gn_validate_file_t*        bkp;
	gn_bool_t                  in_lfs;
	gn_sys_install_profile_t*  profile;
} gn_validate_file_table_t;

/* gn_validate_t
 *
 * This structure contains information describing the state of the local
 * database. It can be used to guide the application in recovering from a
 * corrupt database situation, or it can be passed directly to
 * gn_update_recover() which will perform recovery operations described by the
 * structure.
 *
 * ops - The validation ops bits which were used to generate this structure.
 * live_db_path - The path to the base database files. This path can be
 *   provided by a gn_emms_configuration_t during system initialization. If a
 *   configuration structure is not provided or if the path was not set, this
 *   will be GN_NULL and base database files are assumed to be in the working
 *   directory.
 * update_db_path - The path to the update database files. This path can be
 *   provided by a gn_emms_configuration_t during system initialization. If a
 *   configuration structure is not provided or if the path was not set, this
 *   will be GN_NULL and update database files are assumed to be in the working
 *   directory.
 * backup_db_path - The path to update backup database files.  This path can be
 *   provided by a gn_emms_configuration_t during system initialization. If a
 *   configuration structure is not provided or if the path was not set, this
 *   will be GN_NULL and backup database files are assumed to be in the working
 *   directory.
 * has_updates - Indicates whether any update or update backup files were
 *   present for non-List File Set files.
 * status - Status code from validation. Any non-GN_VALIDATE_STATUS_OK value
 *   indicates a problem with the database.
 *   Possible values of status follow.
 *     GN_VALIDATE_STATUS_OK - Indicates no problems with the local database.
 *     GN_VALIDATE_STATUS_Failure - Indicates that at least one member of the
 *       file_detail[] array had a status value which was not
 *       GN_VALIDATE_STATUS_OK.
 *     GN_VALIDATE_STATUS_DBRevsDiffer - One or more of the non-List File Set
 *       database files have different DB revision levels.
 *     GN_VALIDATE_STATUS_LevelsDiffer - One or more of the non-List File Set
 *       database files have update levels which differ.
 * action - This value will indicate to the application what action to take in
 *   order to recover from a corrupt database. If status is
 *   GN_VALIDATE_STATUS_OK, this value will be GN_VALIDATE_ACTION_NONE.
 * lfs_has_updates - Indicates whether any update or update backup files were
 *   present for List File Set files.
 * lfs_status - Status code from validation. Any non-GN_VALIDATE_STATUS_OK
 *   value indicates a problem with the database.
 *   Possible values of status follow.
 *     GN_VALIDATE_STATUS_OK - Indicates no problems with the local database.
 *     GN_VALIDATE_STATUS_Failure - Indicates that at least one member of the
 *       file_detail[] array had a status value which was not
 *       GN_VALIDATE_STATUS_OK.
 *     GN_VALIDATE_STATUS_LFSIDsDiffer - One or more of the database files in
 *       the List File Set have a different revision.
 * lfs_action - This value will indicate to the application what action to take
 *   in order to recover from a corrupt database. If lfs_status is
 *   GN_VALIDATE_STATUS_OK, this value will be GN_VALIDATE_ACTION_NONE.
 * file_count - The number of members in the file_detail array.
 * file_detail - An array of gn_validate_file_table_t structure references
 *   containing the validation results for each base file and its associated
 *   update and update backup files.
 * profile - If the profile of all members of gn_validate_file_table_t which
 *   have in_lfs = GN_FASE are identical, then this will be a copy of that data.
 *   Otherwise it will be GN_NULL. In that case, look to the profile members of
 *   the lower level structures, i.e. the members of the file_detail array, for
 *   the profile information of each set of files. That will help you identify
 *   the inconsistency at this level.
 * lfs_rev - If the profile.base_db_revision of the gn_validate_file_table_t
 *   which have in_lfs = GN_TRUE all match, then this will be that value.
 */
typedef struct gn_validate_s
{
	gn_validate_ops_t          ops;
	gn_uchar_t*                live_db_path;
	gn_uchar_t*                update_db_path;
	gn_uchar_t*                backup_db_path;
	gn_bool_t                  has_updates;
	gn_uint32_t                status;
	gn_validate_recover_enum_t action;
	gn_bool_t                  lfs_has_updates;
	gn_uint32_t                lfs_status;
	gn_validate_recover_enum_t lfs_action;
	gn_uint32_t                file_count;
	gn_validate_file_table_t** file_detail;
	gn_sys_install_profile_t*  profile;
	gn_uint32_t                lfs_rev;
} gn_validate_t;


/**
 ** prototpyes
 **/

/* gn_validation_smart_free_validation
 *
 * Behavior: If validation != GN_NULL and *validation != GN_NULL, this function
 *           releases all memory held by *validation and sets it to GN_NULL.
 */
gn_error_t
gn_validation_smart_free_validation(
	gn_validate_t** validation
);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_VALIDATE_H_ */
