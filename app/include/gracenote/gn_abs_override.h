/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_abs_override.h - This header may be used to override the type 
 *                     definitions in 'gn_abs_types.h'
 */

#ifndef	_GN_ABS_OVERRIDE_H_
#define _GN_ABS_OVERRIDE_H_

#ifdef __cplusplus
extern "C"{
#endif 

/* 
 * Platform Specific Type Definitions
 *
 * If you find it necessary to override any Gracenote typedefs or constants 
 * on your target platform, do so here.                                          
 *
 * Example:                                                                      
 *                                                                               
 *   #define     GN_ULONG_MAX      0xffffffff                                    
 *   #define     GN_LONG_MAX       2147483647                                    
 *   #define     GN_LONG_MIN       (-GN_LONG_MAX - 1)                            
 *                                                                               
 *   typedef int gn_int32_t;                                                     
 *   #define     GN_INT32_T                                                      
 *
 *   typedef unsigned int gn_uint32_t;
 *   #define     GN_UINT32_T
 *    
 *   typedef unsigned int gn_size_t;
 *   #define     GN_SIZE_T
 *
 */

#ifdef __cplusplus
}
#endif 

#endif /* _GN_DEFINES_H_ */
