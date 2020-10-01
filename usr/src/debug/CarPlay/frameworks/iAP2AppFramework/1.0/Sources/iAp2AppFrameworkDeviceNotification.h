/*
    File:       iAp2AppFrameworkDeviceNotification.h
    Package:    LG iAP2 Application Framework
    Author:     Yongil Park (yongil.park@lge.com)
    Copyright © [2014-2016] by LG Electronics Inc.

    This program or software including the accompanying associated documentation
    (“Software”) is the proprietary software of LG Electronics Inc. and or its
    licensors, and may only be used, duplicated, modified or distributed pursuant
    to the terms and conditions of a separate written license agreement between you
    and LG Electronics Inc. (“Authorized License”). Except as set forth in an
    Authorized License, LG Electronics Inc. grants no license (express or implied),
    rights to use, or waiver of any kind with respect to the Software, and LG
    Electronics Inc. expressly reserves all rights in and to the Software and all
    intellectual property therein. If you have no Authorized License, then you have
    no rights to use the Software in any ways, and should immediately notify LG
    Electronics Inc. and discontinue all use of the Software.
*/

#ifndef IAP2APPFRAMEWORKDEVICENOTIFICATION_H_
#define IAP2APPFRAMEWORKDEVICENOTIFICATION_H_

#include <stdint.h>
#include <stddef.h>

#include "iAp2AppFrameworkCommon.h"
#include "iAp2AppFrameworkExternal.h"
#include "iAp2AppFrameworkExternal_command.h"
#include "iAp2AppFrameworkExternal_event.h"
#ifdef __cplusplus
extern "C" {
#endif

//===========================================================================================================================
//    Definitions
//===========================================================================================================================
/*!
 * @defgroup DevcieNotification
 * @brief Group about Devcie Notification in the iAP2 Message 
 * @{
 */
 
/*!
 * @brief This function is callback to send DeviceInformationUpdate message to Application.
 * @param inContext handle value
 * @param inCbArg Payload Data of DeviceInformationUpdate Message, Refer @ref DeviceInformationUpdateCbArg type
 * @return 0 : No error occurred.\n -6700 ~ -6779 : Generic error codes.
 */
typedef int (*iAp2AppDeviceInformationUpdate_f)(void* inContext, DeviceInformationUpdateCbArg* inCbArg);

/*!
 * @brief This function is callback to send DeviceLanguageUpdate message to Application.
 * @param inContext handle value
 * @param inCbArg Payload Data of DeviceLanguageUpdate Message, Refer @ref DeviceLanguageUpdateCbArg type
 * @return 0 : No error occurred.\n -6700 ~ -6779 : Generic error codes.
 */
typedef int (*iAp2App2DeviceLanguageUpdate_f)(void* inContext, DeviceLanguageUpdateCbArg* inCbArg);
/*! @} */

//===========================================================================================================================
//    Declarations
//===========================================================================================================================
int iAp2ConectionHandleEventDeviceInformationUpdate(iAp2AppRef inRef, unsigned char* pRxData);
int iAp2ConectionHandleEventDeviceLanguageUpdate(iAp2AppRef inRef, unsigned char* pRxData);
#ifdef __cplusplus
}
#endif

#endif /* IAP2APPFRAMEWORKDEVICENOTIFICATION_H_ */


