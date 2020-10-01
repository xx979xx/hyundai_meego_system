#ifndef __LG_IPC_H__
#define __LG_IPC_H__

#include <stdio.h>
#include <linux/types.h>
#include "spi_ipc_protocol.h"

#ifdef __cplusplus
extern "C" {
#endif 

#ifndef __cplusplus
typedef enum{false,true} bool;
#endif

typedef void (*OnK2LConnect)( void );
typedef void (*OnK2LDisconnect)( void );
typedef bool (*RecvCallback)( unsigned int, unsigned char * );

int lg_ipc_init( OnK2LConnect, RecvCallback );	
int lg_ipc_deinit( OnK2LDisconnect );

int ipc_senddata( pCMD_HEADER pHeader, unsigned int nLength, unsigned char *pData );
int lg_ipc_SendIPCData( unsigned int, unsigned char * );

#ifdef __cplusplus
}
#endif

#endif /* __LG_IPC_H__ */
