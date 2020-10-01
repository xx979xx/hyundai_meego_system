/*
 * Copyright (c) 2002 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_osa_device_id.h  - APIs for device identification strings information.
 *
 * NOTE: These functions are required only for devices that connect with
 * Gracenote servers online.
 */

#ifndef	_GN_DEVICE_ID_H_
#define _GN_DEVICE_ID_H_

/*
 * Dependencies
 */
#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes
 */

const gn_uchar_t*				gn_get_software_version(void);
const gn_uchar_t*				gn_get_hardware_version(void);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_DEVICE_ID_H_ */
