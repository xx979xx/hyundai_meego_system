/**
 ** Declarations for displaying contents of a database validation data structure.
 ** Current for the 4.8.5 code base.
 **/

#include "gn_validate.h"

/*
 * Display the contents of the given validation data structure using printf().
 * Params:
 *  validation            [IN]    Validation data structure from 'gninit_initialize_emms_safe()'
 *  display_level         [IN]    If this is > 1, then all elements of the validation structure will be displayed.
 *                                Otherwise, only information about corrupt items will be displayed.
 *  display_validation    [OUT]   Buffer that will contain validation info to display
 *                                This function allocates memory, it is the callers responsability 
 *                                to free 'display_validation' when they are finished with it.
 */ 
void
gn_validation_display(
	gn_validate_t*	validation,
	gn_uint32_t		display_level,
	gn_uchar_t**	display_validation
);
