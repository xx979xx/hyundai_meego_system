/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_secondary_update.h - Secondary update interface.
 */

#ifndef	_GN_SECONDARY_UPDATE_H_
#define _GN_SECONDARY_UPDATE_H_

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 

/* gn_secondary_update_apply_update
 *
 *   Behavior: Applies the update in the given update package file to the local
 *             database using the secondary update mechanism.
 *
 *             This is a special update mechanism which allows for updating in a
 *             "broadcast" mode, i.e. one in which the same package is broadcast
 *             to multiple installations, each of which is capable of extracting
 *             the update from the package.
 *
 *             This is not the most common update mode.  It is only available
 *             to devices which are configured to support secondary updates.
 *
 *   Args: IN: package_file_name (required) - Filename, including any necessary
 *                path information, to the update package to apply.
 */
gn_error_t
gn_secondary_update_apply_update(
	const gn_uchar_t* package_file_name
);

/* gn_secondary_update_backup
 *
 *  Behavior: Generates a backup copy of the secondary update database files.
 *
 *            Normally this is done automatically at the end of the application
 *            of an update. However, if the process is interrupted during the
 *            generation of the backup files, you may need to initiate the
 *            backup process "by hand" in order to reach a consistent state.
 *
 *            Calling this function after an update returns will have NO
 *            PRACTICAL EFFECT, whether or not the update returned GN_SUCCESS
 *            or an error value.
 */
gn_error_t
gn_secondary_update_backup(void);

/* gn_secondary_update_revert
 *
 *  Behavior: Revert the secondary update database to the state it was in just
 *            after the most recent successful update.
 *
 *            The secondary update database files are generated the first time
 *            a secondary update is applied. Subsequent updates modify this
 *            file. The last step of the update process is to make a backup
 *            copy of the secondary update files. If the next update should be
 *            interrupted, the update files might be left in a corrupt state.
 *            In this case, you can call gn_secondary_update_revert()
 *            to fall back to the state after the previous, successful, update.
 *
 *            Note, it is possible to disable the generation of the backup file
 *            via the configuration structure provided to the library
 *            initialization function, gninit_initialize_emms(). In this case,
 *            gn_secondary_update_revert() will simply delete the update
 *            database. You should only disable the generation of backup files
 *            if disk space is extremely critical and you are willing to risk
 *            needing to reapply all updates if something goes wrong during an
 *            update.
 *
 *            Calling this function if gn_secondary_update_apply_update()
 *            finishes, whether it returns GN_SUCCESS or an error value, will
 *            normally have NO PRACTICAL EFFECT. In the event that an error is
 *            returned, the update process will automatically revert to the
 *            backup files if necessary.
 */
gn_error_t
gn_secondary_update_revert(void);

/* gn_secondary_update_delete
 *
 *   Behavior: Delete the secondary update database and its backup.
 *
 *             In the unlikely event that both the update and the backup files
 *             are corrupt, it may be necessary to delete both. In this case,
 *             all updates which have been applied will need to be reapplied in
 *             order to have the most current database. Because of this,
 *             issuing gn_secondary_update_delete() is a last resort. Prior to
 *             issuing gn_secondary_update_delete(), you may wish to provide
 *             additional analytics in the application.
 */
gn_error_t
gn_secondary_update_delete(void);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_SECONDARY_UPDATE_H_ */
