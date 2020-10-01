/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gnepal_abs_version.h - Abstract Layer versioning APIs
 */

#ifndef	_GNEPAL_ABS_VERSION_H_
#define _GNEPAL_ABS_VERSION_H_

/*
 * Dependencies.
 */

#include	"gn_defines.h"
#include	"gn_platform.h"


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

/* Return the version string for the platform specific portion of the 
 * Example Abstract Layer
 */
const gn_uchar_t* gnepal_get_version(void);


#ifdef __cplusplus
}
#endif 

#endif /* _GNEPAL_ABS_VERSION_H_ */
