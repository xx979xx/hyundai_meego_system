/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_platform.h - Sets the platform define based upon compiler definitions.
 */

#ifndef	_GN_PLATFORM_H_
#define _GN_PLATFORM_H_

/*
 * Platform-specific #defines should be placed in "platform.h"
 *
 */

#include "platform.h"

#ifdef __cplusplus
extern "C"{
#endif 

#if defined(GN_READONLY)

#ifdef GN_UPDATES
#undef GN_UPDATES
#endif

#endif /* #if defined(GN_READONLY) */

#ifdef __cplusplus
}
#endif

#endif /* _GN_PLATFORM_H_ */
