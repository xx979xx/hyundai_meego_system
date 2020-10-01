/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_abs_version.h - Abstract Layer versioning APIs
 */

#ifndef	_GN_ABS_VERSION_H_
#define _GN_ABS_VERSION_H_

/*
 * Dependencies.
 */

#include	"gn_abs_types.h"


#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants.
 */


/*
 * Typedefs.
 */


/*
 * Prototypes.
 */

/* Return the version string for the common portion of the
 * Abstract Layer
 */
const gn_uchar_t* gn_abs_get_common_version(void);

/* Return the version string for the platform specific portion of the
 * Abstract Layer
 */
const gn_uchar_t* gn_abs_get_platspec_version(void);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_ABS_VERSION_H_ */
