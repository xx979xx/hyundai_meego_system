/* Copyright (c) 2010 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/* gnepal_comm_native.h
 *
 * Interface to platform-specific routines for the communications layer
 *
 */

#ifndef _GNEPAL_COMM_NATIVE_H_
#define _GNEPAL_COMM_NATIVE_H_

#include "gn_abs_types.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Constants
 */
 
#define GNEPAL_COMM_NATIVE_HTTP_ACTION_GET				"GET"
#define GNEPAL_COMM_NATIVE_HTTP_ACTION_POST				"POST"

/* Types of notifications Gracenote eMMS expects during an HTTP Request */
#define GNEPAL_COMM_HTTP_NOTIFY_RECV_HEADER		((gnepal_comm_http_notify_t)0)
#define GNEPAL_COMM_HTTP_NOTIFY_RECV_DATA		((gnepal_comm_http_notify_t)1)

/*
 * Typedefs
 */

/* Type of HTTP data recieved */
typedef gn_uint32_t					gnepal_comm_http_notify_t;

/* Opaque pointer used by eMMS to store context information for a particular HTTP request */
typedef void*						gnepal_comm_http_context_t;

/* Callback proc used by http request to process recieved headers and body. */
typedef gn_error_t					(*gnepal_comm_http_callback_t)
										(gnepal_comm_http_context_t context, gnepal_comm_http_notify_t notification, void* recv_data, gn_int32_t recv_size);

/*
 * Prototypes
 */

/* Process an http request */
gn_error_t 
gnepal_comm_native_http_request(
	gn_uchar_t const*                	url,			/* Full URL of resource  */

	gn_uchar_t const*                	serverName,		/* Server name to conect to, for convenience, contained in URL */
	gn_int32_t							serverPort,		/* Server port to connect to, for convenience, contained in URL */
	gn_uchar_t const*                	target,			/* Target for the specified action, for convenience, contained in URL */

	gn_uchar_t const*               	action,         /* Action to perform: "GET" or "POST" */

	gn_uchar_t const*                	user_agent,		/* User agent to send as part of request */

	gn_uchar_t const*                	send_headers,   /* Additional headers to send with HTTP request */
	void const*                      	send_buffer,	/* Buffer of data to send with request, may be null */
	gn_int32_t                      	send_size,		/* Size of send_buffer in bytes */

	gnepal_comm_http_callback_t				callback,		/* Callback function to use to process headers and recieve data */
	gnepal_comm_http_context_t				context			/* context of http request, must be passed to callback */
);

#ifdef __cplusplus
}
#endif

#endif	/* ifndef _COMM_NATIVE_H_ */
