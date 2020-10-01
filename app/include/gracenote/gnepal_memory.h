/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 * gnepal_memory.h - Abstraction header file containing the declaration 
 * of memory related functions for cross platform compatibility.
 */

#ifndef _GNEPAL_MEMORY_H_
#define _GNEPAL_MEMORY_H_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gn_platform.h"
#include "gnex_errors.h"

/*
 * If p and *p are not null, calls gnepal_mem_free on *p and sets *p to null.
 * Useful for freeing a pointer and setting its value to null in one step.
 */
#define gnepal_smart_free(p)	if(p&&*p){ gnepal_mem_free(*p); *p=GN_NULL; }


#ifdef __cplusplus
extern "C"{
#endif 


/*
 * Prototypes.
 */

/* Allocate memory from the heap */
void* 
gnepal_mem_malloc(gn_size_t size);

/* Reallocate the memory for the block */
void* 
gnepal_mem_realloc(void *ptr, gn_size_t size);

/* Free the allocated block */
gnex_error_t 
gnepal_mem_free(void *block);

#ifdef __cplusplus
}
#endif 

#endif /* _GNEPAL_MEMORY_H_ */

