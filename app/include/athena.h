#ifndef __ATHENA_H__
#define __ATHENA_H__

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define ATHENA_EXPORT_API __attribute__((visibility("default")))

enum EventType {
    eStartEvent = 1,
    eButtonEvent,
    eKeyEvent,
    eMouseEvent,
    ePopupEvent,
};

// export API
ATHENA_EXPORT_API int athenaOpen(int enable = 1, int port = 27000);
ATHENA_EXPORT_API int athenaSendObject(int param1 = 1, int param2= 0, int param3 = 0, int param4 = 0);
ATHENA_EXPORT_API int athenaClose(int param = 0); 

#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif



