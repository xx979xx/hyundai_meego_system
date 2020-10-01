#ifndef __TYPE_H__
#define __TYPE_H__

typedef bool	BOOL;
typedef quint8	UINT8;
typedef quint16	UINT16;
typedef quint32	UINT32;
typedef quint64	UINT64;
typedef qint8	INT8;
typedef qint16	INT16;
typedef qint32	INT32;
typedef qint64	INT64;

#define NULL4	(0x0F)			// 4-bit NULL Value
#define NULL8	(0xFF)			// 8-bit NULL Value
#define NULL12	(0x0FFF)		// 12-bit NULL Value
#define NULL16	(0xFFFF)		// 16-bit NULL Value
#define NULL32	(0xFFFFFFFF)	// 32-bit NULL Value

#endif	// __TYPE_H__
