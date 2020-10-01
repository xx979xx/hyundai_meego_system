/*
 * Copyright (c) 2007 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *	gnepal_time.h - Get the current time.
 */

#ifndef _GNEPAL_TIME_
#define _GNEPAL_TIME_

/*
 * Dependencies.
 */

#include "gn_defines.h"
#include "gnex_errors.h"

#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */

/* gnepal_get_time                                                           */
/* Gets the current time                                                     */
/* Parameters:                                                               */
/*	year 	- yields the current year which should be greater or equal than  */
/*				2007.                                                        */
/*	month 	- yields the current month which should be a number between 1    */ 
/*				and 12.                                                      */
/*	day 	- yields the day of the month, which should be a number between  */
/*	 			1 and 32.                                                    */
/*	hour 	- yields the hour of the day which should be a number between 0  */
/*         		and 23.                                                      */
/*	minute 	- yields the minute of the hour, which should be a number        */
/*				between 0 and 59.                                            */
/*                                                                           */
/*	Any of the aforementioned parameters may be substituted with the value   */
/*  GN_NULL.                                                                 */
/*                                                                           */
/* Remarks:                                                                  */	        
/*	The time that is returned is in 24 hour format and is no more granular   */
/*  than a minute.  The date that is returned should be in a format analogous*/
/*  to what one might see on a calendar.   For example, if the date today was*/ 
/*  Thursday, September 20th and the time was 14:41 then the function  would */
/*  yield the following values:                                              */
/*                                                                           */
/*      *year = 2007                                                         */
/* 		*month = 11                                                          */
/*      *day = 20                                                            */
/*      *hour = 14                                                           */
/*      *minute = 41                                                         */

gnex_error_t
gnepal_get_time(
			gn_uint32_t *year,	
			gn_uint32_t *month, 
			gn_uint32_t *day, 
			gn_uint32_t *hour, 
			gn_uint32_t *minute
			);

#ifdef __cplusplus
}
#endif 


#endif /* _GNEPAL_TIME_ */
