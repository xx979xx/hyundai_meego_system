/*
 * Copyright (c) 2003 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_descriptors.h - API for generic data access descriptors.
 */


#ifndef _GN_DESCRIPTORS_H_
#define _GN_DESCRIPTORS_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"


#ifdef __cplusplus
extern "C"{
#endif 


/**
 ** The only symbols in this header file that applications should reference are
 ** the following.
 **
 **  - ALBUMLOCAL to select the local album database if local lookups are
 **               supported
 **  - SCNDUPDLOC to select the secondary update database if local lookups and
 **               secondary database updates are supported
 **
 ** Though these are currently defined in terms of gnedb_get_handle(), this may
 ** not always be the case, and so the macros should be used rather than the
 ** function.
 **/

/*
 * Constants and Macros.
 */

#define	EDB_INVALID_DB_HANDLE	((gn_edb_handle_t)GN_NULL)

/* selector bits */
#define	LU_MEDIA_TYPE_ID_CD				0x00000001
#define	LU_MEDIA_TYPE_ID_DVD			0x00000002

#define	LU_DATA_STORE_TYPE_DB			0x00001000
#define	LU_DATA_STORE_TYPE_CACHE		0x00002000

#define	LU_DESCRIMINATOR_CD_SCNDUPD		0x00100000
#define	LU_DESCRIMINATOR_CD_ALBUM		0x00200000


#define		SCNDUPD_SEL		(LU_DATA_STORE_TYPE_DB | LU_MEDIA_TYPE_ID_CD | LU_DESCRIMINATOR_CD_SCNDUPD)
#define		ALBUMLOC_SEL	(LU_DATA_STORE_TYPE_DB | LU_MEDIA_TYPE_ID_CD | LU_DESCRIMINATOR_CD_ALBUM)

/**
 ** The following symbols are the only symbols in this header file which an
 ** application should need to reference.
 **/
#define		SCNDUPDLOC		gnedb_get_handle(SCNDUPD_SEL)
#define		ALBUMLOCAL		gnedb_get_handle(ALBUMLOC_SEL)

/*
 * Typedefs
 */

typedef gn_uint32_t		gn_selector_t;
typedef gn_selector_t	gn_db_selector_t;

typedef void*			gn_edb_handle_t;

/*
 * Prototypes
 */

/* Get the local DB handle that corresponds to the selector value. */
/* Returns GN_NULL if the local DB handle does not exist. */
gn_edb_handle_t
gnedb_get_handle(gn_db_selector_t selector);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_DESCRIPTORS_H_ */
