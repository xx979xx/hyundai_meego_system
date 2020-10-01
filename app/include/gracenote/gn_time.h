/*
 *  gn_time.h	- Basic time support.
 *
 *	Copyright (c) 2008 Gracenote.
 *
 *	This software may not be used in any way or distributed without
 *	permission. All rights reserved.
 *
 *	Some code herein may be covered by US and international patents.
 */

#ifndef _GN_TIME_HEADER_
#define _GN_TIME_HEADER_

/*
 * Dependencies.
 */

#include "gn_abs_types.h"


#ifdef __cplusplus
extern "C"{
#endif 

/*
 * Prototypes.
 */


/*
 *	gn_get_time
 *
 *	Return the current time if this platform supports a time function.  If time is not supported
 *	then return 0 for each parameter.  In either case GN_SUCCESS is always returned.
 *
 *	However your system's time function is implemented the values returned by this function
 *	must adhere to the following protocol:
 *
 *		year	- the current year relative to 2000 being year 0
 *		month	- the current month of the year, a number from 1 to 12
 *		day		- the current day of the month, a number from 1 to 32
 *		hour	- the current hour of the day, a number from 0 to 23  (a 24 hour clock)
 *		minute	- the current minute of the hour, a number from 0 to 59
 *		second	- the current second of the minute, a number from 0 to 59
 *
 *	If the date today was January 11, 2008 and the time was 4:21:00 pm then this function should
 *	return these values:
 *
 *		year	8
 *		month	1
 *		day		11
 *		hour	16
 *		minute	21
 *		second	0
 *
 *	If any of the parameters are GN_NULL then those values will not be returned.
 */
gn_error_t
gn_get_time(
	gn_uint32_t		*year,	
	gn_uint32_t		*month, 
	gn_uint32_t		*day, 
	gn_uint32_t		*hour, 
	gn_uint32_t		*minute,
	gn_uint32_t		*second
	);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_TIME_HEADER_ */
