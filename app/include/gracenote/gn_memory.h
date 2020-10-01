/*
 * Copyright (c) 2000 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gn_memory.h - Abstraction header file containing the declaration 
 * of memory related functions for cross platform compatibility.
 */

#ifndef _GN_MEMORY_H_
#define _GN_MEMORY_H_

/*#define	_GN_LOG_MEM_*/

/*
 * Dependencies.
 */

#include "gn_abs_types.h"

/* Define the main memory system functions, if the logging variant */
/* has not already done so. */
/*
 * Macros
 */

#ifndef gnmem_malloc
#define gnmem_malloc(size)			_gnmem_malloc(size)
#endif

#ifndef gnmem_realloc
#define gnmem_realloc(ptr,size)		_gnmem_realloc(ptr,size)
#endif

#ifndef gnmem_free
#define gnmem_free(ptr)				_gnmem_free(ptr)
#endif


/*
 * If p and *p are not null, calls gnmem_free on *p and sets *p to null.
 * Useful for freeing a pointer and setting its value to null in one step.
 */
#define gn_smart_free(p)	if(p&&*p){ gnmem_free(*p); *p=GN_NULL; }


#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Prototypes.
 */

/* Determine whether the memory system is compiled into the code, */
/* and is initialized for use. */
gn_error_t
gnmem_query_availability(gn_uint32_t* feature_mask);

/* Initialize the memory manager */
gn_error_t
gnmem_initialize_v2(void);

/* Shut down the memory manager when we're done with it */
gn_error_t
gnmem_shutdown(void);

/* Allocate memory from the heap */
void* 
_gnmem_malloc(gn_size_t size);

/* Reallocate the memory for the block */
void* 
_gnmem_realloc(void *ptr, gn_size_t size);

/* Free the allocated block */
gn_error_t 
_gnmem_free(void *block);

#ifdef __cplusplus
}
#endif 

#endif

