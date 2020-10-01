// defined with this macro as being exported.

//

/*=======================================================================================================
DivX DRM to be Wrapped in API header
=========================================================================================================

* Create : 2012.08.04

* Modified :

--------------------------------------------------------------------------------------------------------
designed by kwc38410
Copyright(c) 2012-2013
=======================================================================================================*/

/**
@mainpage	DivX DRM to be Wrapped in API header

@section	intro 
- This is API header that wraps the DivX DRM SDK API

@section	dev 
- CPU : X86
- OS : ubuntu
- Devtool : gcc 

@section	company 
- CoreEmbedded
- www.ceinside.co.kr

@section	date 
- 2012-08-09

@section	author 
- kwc38410@ceinside.co.kr
**/

/* the structure of buffer
/// Duration format : [HH:MM:SS.XXX-hh:mm:ss.xxx]
///
/// @note: This string is not null terminated!
///
char duration[27];

///
/// Dimensions and coordinates
///

unsigned short width; // 2 -> 29
unsigned short height; // 2 -> 31
unsigned short left; // 2 -> 33
unsigned short top; // 2 -> 35
unsigned short right; // -> 37
unsigned short bottom; // 2 -> 39
unsigned short field_offset; // 2 -> 41

unsigned char *bmp_data;
*/

// @brief @b InitDrmMemory
// This function must the first time the device is loaded up it's firmware from the factory.
// This function should be called only once from factory.
// When firmware is upgraded, DRM memory should be initialized.
// It sets the initial DrmMemory values, as expected by the rest of the system.
// @return : DRM_SUCCESS  = 0 : success
//           DRM_NOT_AUTHORIZED = 1 :  failure, could not save DrmMemory.
// @param :  none
int InitDrmMemory(void);

// @brief : initialize the DivX DRM API.
// @return : void
// @param : (in) void *avi_instance : avi demux instance
void decrypt_init_drm(void *avi_instance);

// @brief : finalize the DivX DRM API.
// @return : 0 : SUCCESS
// @param : (in) unsigned char *drmcontext
int decrypt_finalize_drm(unsigned char *drmContext);

// @brief : Get the buffer pointer
// @return : unsigned char*
// @param : (in) unsigned char *drmContext
unsigned char* get_divx_decryption_buffer(unsigned char *drmContext);

// @brief : Get the strd size
// @return : strd size
// @param : None
unsigned int get_strd_size(void);

// @brief : to decrypt the audio frame
// @return : void
// @param : (in) unsigned char *drmContex
//          (in) unsigned char *frame
//          (in) unsigned int frameSize
void decrypt_audio_frame(unsigned char *drmContext, unsigned char *frame, unsigned int frameSize);

// @brief : to decrypt the video frame
// @return : void
// @param : (in) unsigned char *drmContex
//          (in) unsigned char *frame
//          (in) unsigned int frameSize
void decrypt_video_frame(unsigned char *drmContext, unsigned char *frame, unsigned int frameSize);

// @brief : parsing xsub
// @return : int
// @param : (in) void *avi_instance
//          (in) void *stream_instance
//          (in) unsigned int stream_num
//          (in) void *rawbuf
int parsing_xsub_stream(void *avi_instance, void *stream_instance, unsigned int stream_num, void *rawbuf);

// @brief : Whether the device is registered or not.
// @return : unsigned int
//           DRM_SUCCESS = 0, : registered.
//           DRM_NOT_REGISTERED = 2 : not registered. But the device is registered once.
//           DRM_GENERAL_ERROR = 4 : Failure
//           DRM_NEVER_REGISTERED = 5 : Never registered.
// @param :  None.
unsigned int IsDeviceActivated( void );

// @brief  : The registration code is passed to param(pRegCode).
// @return : unsigned int
//           DRM_SUCCESS = 0 : success.
//           DRM_NOT_AUTHORIZED = 1 : failure or it is already registered.
// @param :  char *pRegCode
//           It is passed to the caller function
//           that pRegcode is registration code to enable the device.
//           pRegCode is 11 bytes with NULL.
unsigned int GetRegistrationCode( char *pRegCode );

// @brief  : The deregistration code is passed to param(pRegCode).
// @return : unsigned int
//           DRM_SUCCESS = 0 : success.
//           DRM_NOT_AUTHORIZED = 1 : failure
// @param :  char *pDeRegCode
//           It is passed to the caller function
//           that pDeRegcode is deregistration code to disable the device.
//           pDeRegCode is 11 bytes with NULL.
unsigned int GetDeregistrationCode( char *pDeRegCode );

// @brief : get DivX information of file path
// @return : int
//           -1 : Error
//            0 : Normal contents not to have strd.
//            1 : This contents is DivX.
//            2 : Not authorized
//            3 : Expired
// @param : (in) filepath : file path
//          (out) use limit (available value only at the return value is 0)
//          (out) use count (available value only at the return value is 0)
int getDivXInfoOfPath(char *filepath, int *useLimit, int *useCount);
