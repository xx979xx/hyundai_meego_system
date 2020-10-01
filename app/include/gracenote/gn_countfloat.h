/*
 * Copyright (c) 2004 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_countfloat.h - Function prototypes for counting floating point
 *    operations while the code is running. These functions are part of
 *    the abstract layer routines.
 *
 *    Internal floating point counting will be compiled in only if
 *    GN_COUNTFLOAT is defined at compile time.
 *
 * The function prototypes listed below should never be called directly.
 * Instead the macro wrappers for these functions should be called. This
 * allows the calls to be compiled out for release versions of the library.
 *
 * The macro wrappers are:
 * GNCNT_FLOAT_ADD(a)
 * GNCNT_FLOAT_SUB(a)
 * GNCNT_FLOAT_MUL(a)
 * GNCNT_FLOAT_DIV(a)
 * GNCNT_FLOAT_ASMD(a, s, m, d)
 * GNCNT_FLOAT_SQRT(a)
 * GNCNT_FLOAT_SIN(a)
 * GNCNT_FLOAT_COS(a)
 * GNCNT_FLOAT_FABS(a)
 * GNCNT_FLOAT_FLOOR(a)
 * GNCNT_FLOAT_LOG(a)
 * GNCNT_FLOAT_EXP(a)
 * GNCNT_FLOAT_POW(a)
 * GNCNT_FLOAT_INIT()
 * GNCNT_FLOAT_DISABLE()
 * GNCNT_FLOAT_RESUME()
 * GNCNT_FLOAT_SHUTDOWN()
 *
 * It is up to the person writing the code module that performs floating
 * point math to remember to add the appropriate counting calls near the
 * location where the operations are taking place.
 *
 * Example:
 *
 *	gn_flt64_t a = 42.1;
 *	gn_flt64_t b = 19.8;
 *	gn_flt64_t c = 0;
 *
 *	GNCNT_FLOAT_ASMD(3, 0, 1, 0);
 *
 *  c = (a * 3.2) + 17.694 + (b + a);
 *
 *
 * NOTE: This file only needs porting if you are interested in
 *       floating point statistics on your platform.
 */

#ifndef _GN_COUNTFLOAT_H_
#define _GN_COUNTFLOAT_H_

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


#if defined(GN_COUNTFLOAT)

/* Initialize the float counting system.
 * This will reset all counts to zero and perform any additional
 * initialization necessary for the float counting system.
 */
void gn_countfloat_init(void);

/* Disable functionality of float counting until resume is called.
 * This will cause all additional calls to the float counting functions
 * to be ignored intil the resume function is called. This can be used
 * in case there is a region of code that should not be profiled.
 */
void gn_countfloat_disable(void);

/* Resume functionality of float counting calls.
 * This should be called after disable is called in order to
 * resume the counting of floating point operations.
 */
void gn_countfloat_resume(void);

/* Terminate float counting and record/display statistics.
 * This will shut down floating point counting and report floating point
 * usage statistics in whatever method was specified by the developer's
 * abstract layer implementation of this function.
 */
void gn_countfloat_shutdown(void);

/* Add count to the number of floating point additions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_add(gn_uint32_t count, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of floating point subtractions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_sub(gn_uint32_t count, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of floating point multiplications performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_mul(gn_uint32_t count, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of floating point divisions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_div(gn_uint32_t count, const gn_uchar_t* file, gn_int32_t line);

/* Add counts to the number of floating point additions, subtractions,
 * multiplications, and divisions performed.
 *
 * a:     The number to add to the existing additions
 * s:     The number to add to the existing subtractions
 * m:     The number to add to the existing multiplications
 * d:     The number to add to the existing divisions
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_asmd(gn_uint32_t a, gn_uint32_t s, gn_uint32_t m, gn_uint32_t d, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of sqrt functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_sqrt(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of sin functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_sin(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of cos functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_cos(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of fabs functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_fabs(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of floor functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_floor(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of log functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_log(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of exp functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_exp(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);

/* Add count to the number of pow functions performed.
 *
 * count: The number to add to the existing count
 * file:  The file this function was called from
 * line:  The line number this function was called from
 */
void gn_countfloat_pow(gn_uint32_t a, const gn_uchar_t* file, gn_int32_t line);


#define GNCNT_FLOAT_INIT()		gn_countfloat_init()
#define GNCNT_FLOAT_DISABLE()	gn_countfloat_disable()
#define GNCNT_FLOAT_RESUME()	gn_countfloat_resume()
#define GNCNT_FLOAT_SHUTDOWN()	gn_countfloat_shutdown()

#define GNCNT_FLOAT_ADD(a)				gn_countfloat_add(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_SUB(a)				gn_countfloat_sub(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_MUL(a)				gn_countfloat_mul(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_DIV(a)				gn_countfloat_div(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_ASMD(a, s, m, d)	gn_countfloat_asmd(a, s, m, d, ((gn_uchar_t*)__FILE__), __LINE__)

#define GNCNT_FLOAT_SQRT(a)				gn_countfloat_sqrt(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_SIN(a)				gn_countfloat_sin(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_COS(a)				gn_countfloat_cos(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_FABS(a)				gn_countfloat_fabs(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_FLOOR(a)			gn_countfloat_floor(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_LOG(a)				gn_countfloat_log(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_EXP(a)				gn_countfloat_exp(a, ((gn_uchar_t*)__FILE__), __LINE__)
#define GNCNT_FLOAT_POW(a)				gn_countfloat_pow(a, ((gn_uchar_t*)__FILE__), __LINE__)

#else  /* #if defined(GN_COUNTFLOAT) */

/* If GN_COUNTFLOAT is not defined then these macros evaluate to nothing */

#define GNCNT_FLOAT_INIT()
#define GNCNT_FLOAT_DISABLE()
#define GNCNT_FLOAT_RESUME()
#define GNCNT_FLOAT_SHUTDOWN()

#define GNCNT_FLOAT_ADD(a)
#define GNCNT_FLOAT_SUB(a)
#define GNCNT_FLOAT_MUL(a)
#define GNCNT_FLOAT_DIV(a)
#define GNCNT_FLOAT_ASMD(a, s, m, d)

#define GNCNT_FLOAT_SQRT(a)
#define GNCNT_FLOAT_SIN(a)
#define GNCNT_FLOAT_COS(a)
#define GNCNT_FLOAT_FABS(a)
#define GNCNT_FLOAT_FLOOR(a)
#define GNCNT_FLOAT_LOG(a)
#define GNCNT_FLOAT_EXP(a)
#define GNCNT_FLOAT_POW(a)

#endif	/* #if defined(GN_COUNTFLOAT) */


#ifdef __cplusplus
}
#endif


#endif  /* _GN_COUNTFLOAT_H_ */
