/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/* gn_registeration.h
 *
 * Contains declarations of public items involving client and user registration 
 * with the Gracenote Service.
 */

/*
 * gn_gcsp_register.h - GCSP REGISTER Implementation.
 */

#ifndef	_GN_REGISTRATION_H_
#define _GN_REGISTRATION_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_online_lookup.h"

#ifdef __cplusplus
extern "C"{
#endif

/*
 * gn_registration_callback_t
 *
 * A function with this prototype may implemented by the developer to capture user registration attempts
 *
 * Parameters:
 *  [IN]
 *    user_data         Address of optional user defined data that was set in the initial
 *                      call to gn_set_registration_callback().
 *
 *    client_id         Client ID new user was registered for.
 *
 *    client_id_tag     Tag to validate the Client ID.
 *
 *    user_id           The User ID used to uniquely identify the new user to Service.
 *
 *    user_id_tag       Tag to validate the User ID.
 */
typedef void (*gn_registration_callback_t)(
	void*                          user_data,
	gn_uchar_t const*              client_id,
	gn_uchar_t const*              client_id_tag,
	gn_uchar_t const*              user_id,
	gn_uchar_t const*              user_id_tag
);

/*
 * gn_set_registration_callback
 *
 * Set a callback function that the EMMS library will call after registering a new user.
 *
 * Return Value:
 *    GN_SUCCESS        This function always returns GN_SUCCESS.
 *
 * Parameters:
 *   IN
 *    callback_func     Address of a user defined callback function or GN_NULL to remove
 *                      the callback.
 *
 *    user_data         Address of optional user defined data that will be passed to the user's
 *                      callback function when it needs to be called. 
 *                      Pass GN_NULL if no data is to be provided.
 */
gn_error_t
gn_set_registration_callback(
	gn_registration_callback_t       callback_func,
	void*                            user_data
	);

#ifdef __cplusplus
}
#endif 

#endif /* _GN_REGISTRATION_H_ */
