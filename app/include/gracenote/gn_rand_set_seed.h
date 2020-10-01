/*
 * Copyright (c) 2009 Gracenote.
 *
 * This software may not be used in any way or distributed without
 * permission. All rights reserved.
 *
 * Some code herein may be covered by US and international patents.
 */

/*
 *  gn_rand_set_seed.h
 */

#ifndef	_GN_RAND_SET_SEED_H_
#define _GN_RAND_SET_SEED_H_

#include "gn_defines.h"

#ifdef __cplusplus
extern "C"{
#endif 


/*	gn_rand_set_seed
 *
 *	This function can be called by the developer to set a new seed for the Gracenote internal
 *	pseudo-random sequence which is used by the Playlist and GCSP subsystems.
 *
 *	If you have the time() function available on your platform then it is suggested that you
 *	use the time of day past midnight in seconds as a seed.
 *
 *	Setting the seed to a constant can be usefull for testing playlist generation where you want
 *	the random order to be the same from one test to another.
 */ 
void
gn_rand_set_seed(
	gn_int32_t	seed
	);


#ifdef __cplusplus
}
#endif 

#endif /* _GN_RAND_SET_SEED_H_ */
