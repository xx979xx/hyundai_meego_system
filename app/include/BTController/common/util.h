#ifndef __UTIL_H__
#define __UTIL_H__

#include <QByteArray>
#include "common/common.h"

#define IOCTLTEST_MAGIC    't'
 
/* Struct for 32bit (default) */
typedef struct
{
	unsigned long base_addr; 
	unsigned long offset;
	unsigned long value; 
} __attribute__ ((packed)) ioctl_test_info;

/* Struct for 16bit */
typedef struct
{
	unsigned long  base_addr; 
	unsigned long  offset;
	unsigned short value; 
} __attribute__ ((packed)) ioctl_test_info_16bit;

/* Struct for 8bit */
typedef struct
{
	unsigned long base_addr; 
	unsigned long offset;
	unsigned char value; 
} __attribute__ ((packed)) ioctl_test_info_8bit;


#define DEVICE_FILENAME  "/dev/ioctldev"

#define IOCTLTEST_TEST		_IO( IOCTLTEST_MAGIC, 0 )

#define IOCTLTEST_READ		_IOR( IOCTLTEST_MAGIC,  1, ioctl_test_info ) 
#define IOCTLTEST_WRITE		_IOW( IOCTLTEST_MAGIC,  2, ioctl_test_info )
#define IOCTLTEST_RW		_IOWR( IOCTLTEST_MAGIC, 3, ioctl_test_info )

#define IOCTLTEST_READ_16	_IOR( IOCTLTEST_MAGIC,  4, ioctl_test_info ) 
#define IOCTLTEST_WRITE_16	_IOW( IOCTLTEST_MAGIC,  5, ioctl_test_info )
#define IOCTLTEST_RW_16		_IOWR( IOCTLTEST_MAGIC, 6, ioctl_test_info )

#define IOCTLTEST_READ_8	_IOR( IOCTLTEST_MAGIC,  7, ioctl_test_info ) 
#define IOCTLTEST_WRITE_8	_IOW( IOCTLTEST_MAGIC,  8, ioctl_test_info )
#define IOCTLTEST_RW_8		_IOWR( IOCTLTEST_MAGIC, 9, ioctl_test_info )

#define IOCTLTEST_MAXNR 	10

BOOL SetBtDeviceID(BT_DEVICE_ID btDeviceId, QByteArray *baDeviceId);
BOOL GetBtDeviceID(QByteArray baDeviceId, BT_DEVICE_ID *btDeviceId);
BOOL GetServiceDescription(UINT16 usServiceDescr, BT_SERVICE_DESCR *btServiceDescr);
BOOL GetByteArraytoDecimal(QByteArray baParameter, char *strParameter);
BOOL GetQStringBDAddress(UINT8 *m_usAddress, QString *qstrAddress);
void InitializeQByteArray(QByteArray *baQByteArray, INT32 iLength);
void InitializeBtCmdParam(BT_COMMAND_PARAM* p_btCommandParam);

#endif // __UTIL_H__
