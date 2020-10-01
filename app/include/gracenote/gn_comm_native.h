/* Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/* comm_native.h
 *
 * Interface to platform-specific routines for the communications layer
 *
 */

#ifndef _COMM_NATIVE_H_
#define _COMM_NATIVE_H_

#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */
 
#define GNCOMM_NATIVE_HTTP_ACTION_GET				"GET"
#define GNCOMM_NATIVE_HTTP_ACTION_POST				"POST"

/* Types of notifications Gracenote eMMS expects during an HTTP Request */
#define GNCOMM_HTTP_NOTIFY_RECV_HEADER		((gncomm_http_notify_t)0)
#define GNCOMM_HTTP_NOTIFY_RECV_DATA		((gncomm_http_notify_t)1)

/*
 * Typedefs
 */

/* HTTP action to perform */
typedef gn_uint32_t					gncomm_http_action_t;

/* Type of HTTP data recieved */
typedef gn_uint32_t					gncomm_http_notify_t;

/* Opaque pointer used by eMMS to store context information for a particular HTTP request */
typedef void*						gncomm_http_context_t;

/* Callback proc used by http request to process recieved headers and body. */
typedef gn_error_t					(*gncomm_http_callback_t)
										(gncomm_http_context_t context, gncomm_http_notify_t notification, void* recv_data, gn_int32_t recv_size);

/*
 * Prototypes
 */

/* Do any initialization or cleanup that may be required by the platform */
gn_error_t 
gncomm_native_initialize(void);

gn_error_t 
gncomm_native_shutdown(void);

/* Process an http request */
gn_error_t 
gncomm_native_http_request(
	gn_uchar_t const*                	url,			/* Full URL of resource  */

	gn_uchar_t const*                	serverName,		/* Server name to conect to, for convenience, contained in URL */
	gn_int32_t							serverPort,		/* Server port to connect to, for convenience, contained in URL */
	gn_uchar_t const*                	target,			/* Target for the specified action, for convenience, contained in URL */

	gn_uchar_t const*               	action,         /* Action to perform: "GET" or "POST" */

	gn_uchar_t const*                	user_agent,		/* User agent to send as part of request */

	gn_uchar_t const*                	send_headers,   /* Additional headers to send with HTTP request */
	void const*                      	send_buffer,	/* Buffer of data to send with request, may be null */
	gn_int32_t                      	send_size,		/* Size of send_buffer in bytes */

	gncomm_http_callback_t				callback,		/* Callback function to use to process headers and recieve data */
	gncomm_http_context_t				context			/* context of http request, must be passed to callback */
);

#ifdef __cplusplus
}
#endif

#endif	/* ifndef _COMM_NATIVE_H_ */
