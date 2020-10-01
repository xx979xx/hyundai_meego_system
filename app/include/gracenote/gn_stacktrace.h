/*
 * Copyright (c) 2003 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_stacktrace.h - Function prototypes for doing simple stack tracing
 *    while the code is running. Implementation of these functions is
 *    up to the developer. These functions are part of the abstract layer
 *    routines.
 *
 *    Internal stacktracing will be compiled in only if GN_STACKTRACE is
 *    defined at compile time.
 */

#ifndef _GN_STACKTRACE_H_
#define _GN_STACKTRACE_H_

/*
 * Dependencies
 */
#include "gn_abs_types.h"


#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Function prototypes
 */


#if defined(GN_STACKTRACE)

/* Initialize the starting point of the stack trace */
void gn_stacktrace_init(const gn_uchar_t* file, gn_int32_t line);

/* Trace the stack usage of the calling function */
void gn_stacktrace(const gn_uchar_t* file, gn_int32_t line);

/* Disable functionality of gn_stacktrace until resumed */
void gn_stacktrace_disable(const gn_uchar_t* file, gn_int32_t line);

/* resume functionality of gn_stacktrace calls */
void gn_stacktrace_resume(const gn_uchar_t* file, gn_int32_t line);

/* Terminate stack trace and record/display stack usage statistics */
void gn_stacktrace_shutdown(const gn_uchar_t* file, gn_int32_t line);

#define GN_DOSTACKTRACE_INIT()		gn_stacktrace_init((const gn_uchar_t*)__FILE__, __LINE__)
#define GN_DOSTACKTRACE()			gn_stacktrace((const gn_uchar_t*)__FILE__, __LINE__)
#define GN_DOSTACKTRACE_DISABLE()	gn_stacktrace_disable((const gn_uchar_t*)__FILE__, __LINE__)
#define GN_DOSTACKTRACE_RESUME()	gn_stacktrace_resume((const gn_uchar_t*)__FILE__, __LINE__)
#define GN_DOSTACKTRACE_SHUTDOWN()	gn_stacktrace_shutdown((const gn_uchar_t*)__FILE__, __LINE__)

#else  /* #if defined(GN_STACKTRACE) */

#define GN_DOSTACKTRACE_INIT()
#define GN_DOSTACKTRACE()
#define GN_DOSTACKTRACE_DISABLE()
#define GN_DOSTACKTRACE_RESUME()
#define GN_DOSTACKTRACE_SHUTDOWN()

#endif  /* #if defined(GN_STACKTRACE) */


#ifdef __cplusplus
}
#endif


#endif  /* _GN_STACKTRACE_H_ */
