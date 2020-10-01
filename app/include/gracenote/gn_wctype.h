/*
 * Copyright (c) 2003 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gn_wctype.h - Wide Character Manipulation functions
 */

#ifndef	_GN_WCTYPE_H_
#define _GN_WCTYPE_H_

/*
 * Dependencies.
 */

#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */

gn_int32_t gn_iswlower(gn_unichar_t c);
gn_unichar_t gn_towupper(gn_unichar_t c);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_WCTYPE_H_ */
