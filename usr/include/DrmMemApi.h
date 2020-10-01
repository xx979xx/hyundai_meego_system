
// @brief : initialize the api accessing the secure area
// @return : 0 : SUCCESS
// @param : none
int drm_memory_init(void);

// @brief : finalize the api accessing the secure area
// @return : 0 : SUCCESS
// @param : none
int drm_memory_exit(void);

// @brief : read the data of insecure area.
// @return : 0 : SUCCESS
// @param : (in) unsigned char *buf (more than 48 bytes)
//          (in) int bufSize : the size of buffer
int drm_memory_read(unsigned char *buf, unsigned int bufSize);

// @brief : read the data of insecure area.
// @return : 0 : SUCCESS
// @param : (in/out) unsigned char *buf (more than 48 bytes)
//          (in) int bufSize : the size of buffer
int drm_memory_write(unsigned char *buf, unsigned int bufSize);

// @brief : read the data of secure area.
// @return : 0 : SUCCESS
// @param : (in/out) unsigned char *buf (more than 32bytes)
//          (in) int bufSize : the size of buffer
int drm_secured_memory_read(unsigned char *buf, unsigned int bufSize);

// @brief : show the state of that DRM memory is initialized or not.
// @return : 1 : should initialize DRM memory
//           0 : need not initialize DRM memory
//          -1 : error
// @param : none.
int need_init_drm_memory(void);

// @brief : write the EEPROM area for DRM to file system.
// @return : 0 : SUCCESS
// @param : none.
int drm_write_eeprom_to_fs(void);