import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.variables 1.0
import com.settings.defines 1.0
import PopUpConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootGeneral
    name: "RootGeneral"
    property int currentRegion : SettingsStorage.currentRegion

    anchors.top: parent.top
    anchors.left: parent.left
    width: 1280
    height: 554

    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 0

    function init()
    {
        content_general.hideFocus()
        content_general.setFocusHandle(0,0)
        content_general.showFocus()
    }

    function setVisualCue(up, down, left, right)
    {
        visualCue.upArrow = up
        visualCue.downArrow = down
        visualCue.leftArrow = left
        visualCue.rightArrow = right
    }

    function getItemIndex(itemNumber)
    {
        var retVal = -1
        for(var index=0; index < general_list_model.count; index++)
        {
            if(general_list_model.get(index).itemNum == itemNumber)
            {
                retVal = index
                return retVal
            }
        }
        return retVal
    }

    function setRootState( index )
    {
        rootGeneral.state = general_list_model.get(index).nameOfState
    }

    function setVisualCueOnMenu( index )
    {
        switch (general_list_model.get(index).itemNum)
        {
        case APP.const_SETTINGS_GENERAL_LANGUAGE                       : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_GENERAL_KEYPAD                         : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_GENERAL_DISTANCE_UNIT                  : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_GENERAL_PHONE_PRIORITY                 : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_GENERAL_PHOTO_FRAME                    : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_GENERAL_APPROVAL                       : setVisualCue(true, false, false, false);
            if(SettingsStorage.rearRRCVariant)
                visualCue.longkey_other = true;
            else
                visualCue.longkey_other = false;
            break
        case APP.const_SETTINGS_GENERAL_REAR_SEAT_CONTROL_MENU         : setVisualCue(true, false, true, false); visualCue.longkey_other = false;  break
        case APP.const_SETTINGS_GENERAL_LOCK_REAR_MONITOR              : setVisualCue(true, false, false, false); visualCue.longkey_other = false; break
        // added for Media Notification(Idea Bank)
        case APP.const_SETTINGS_GENERAL_MEDIA_NOTIFICATION              : setVisualCue(true, false, false, false); visualCue.longkey_other = false; break
        }
    }

    function initialyseMenuItems()
    {
        for (var i = 0; i < general_list_model.count; i++ )
        {
            if (general_list_model.get(i).isCheckNA == true)
            {
                switch(general_list_model.get(i).dbID)
                {
                case Settings.DB_KEY_APPROVAL:
                {
                    general_list_model.setProperty(i,"isChekedState",SettingsStorage.approval)
                }
                break;
                case Settings.DB_KEY_LOCKREARMONITOR_FUNCTION:
                {
                    general_list_model.setProperty(i,"isChekedState",SettingsStorage.rearLockScreen)
                }
                break;
                // added for Media Notification(Idea Bank)
                case Settings.DB_KEY_MEDIA_NOTIFICATION:
                {
                    general_list_model.setProperty(i,"isChekedState",SettingsStorage.mediaNotification)
                }
                break;
                default:
                    //console.log("General.qml : DbID=>" + general_list_model.get(i).dbID + ", Reading Fail")
                    break;
                }
            }
        }
    }

    function setFocusCurrentMenu()
    {
        content_general.__current_x = 0
        content_general.__current_y = 0

        var index = content_general.searchIndex( content_general.__current_x, content_general.__current_y)
        content_general.__current_index = index

        content_general.setFocus(content_general.focus_x, content_general.focus_y)
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_general
        name: "content general"

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height

        focus_x: 0
        focus_y: 0
        default_x: 0
        default_y: 0

        //property bool bLeftMenuFocused: false

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                if(is_focused_BackButton)
                    generalMenu.moveFocus(1,0)

                is_focused_BackButton = false
            }
        }

        // Bg Border
        DHAVN_AppSettings_Cue_Bg_Main{
            id: idCueSettings
            property bool isRightBg:false
            z:1
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: (!idCueSettings.isRightBg) && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_L_BRIGHT
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: idCueSettings.isRightBg && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_R_BRIGHT
        }

        DHAVN_AppSettings_Menu{
            id: generalMenu

            property bool tempValue

            anchors.top: parent.top
            anchors.topMargin: 73
            anchors.right: parent.right

            menu_model: general_list_model

            focus_x: 0
            focus_y: 0

            onSelectItem:
            {
                if(!bJog)
                {
                    content_general.hideFocus()
                    setFocusCurrentMenu()
                }

                setRootState(item)

                if (general_list_model.get(item).isCheckNA == true)
                {
                    tempValue = general_list_model.get(item).isChekedState
                    SettingsStorage.SaveSetting( !(tempValue),
                                                general_list_model.get(item).dbID )
                    EngineListener.NotifyApplication(general_list_model.get(item).dbID,
                                                     !(tempValue), "", UIListener.getCurrentScreen())
                }

                switch(general_list_model.get(item).itemNum)
                {
                case APP.const_SETTINGS_GENERAL_APPROVAL:
                {
                    if(SettingsStorage.approval) SettingsStorage.approval = false;
                    else SettingsStorage.approval = true;
                }
                break
                case APP.const_SETTINGS_GENERAL_LOCK_REAR_MONITOR:
                {
                    if(SettingsStorage.rearLockScreen) SettingsStorage.rearLockScreen = false;
                    else SettingsStorage.rearLockScreen = true;
                }
                break
                // added for Media Notification(Idea Bank)
                case APP.const_SETTINGS_GENERAL_MEDIA_NOTIFICATION:
                {
                    if(SettingsStorage.mediaNotification) SettingsStorage.mediaNotification = false;
                    else SettingsStorage.mediaNotification = true;
                
                    EngineListener.NotifyMediaNotification( SettingsStorage.mediaNotification )
                }
                break;
                //default: console.log("[QML][General]SelectItemIndex:"+item)
                }

                if(!bJog)
                {
                    moveFocus(1,0)

                    content_general.showFocus()
                }
            }

            onCurrentIndexChanged:
            {
                setRootState(currentIndex)

                if(focus_visible)
                    rootGeneral.setVisualCueOnMenu(currentIndex)

                if(currentIndex >= 0)
                    generalMenu.selected_item = currentIndex
            }

            onFocus_visibleChanged:
            {
                //content_general.bLeftMenuFocused = focus_visible
                if(focus_visible)
                {
                    idCueSettings.isRightBg = false
                    rootGeneral.setVisualCueOnMenu(generalMenu.selected_item)
                }
            }

            onMovementEnded:
            {
                if(!focus_visible)
                {
                    content_general.hideFocus()
                    content_general.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        content_general.showFocus()
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: photoFrameSettings

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_PHOTO_FRAME
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_General_PhotoFrame.qml"
                    }
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    photoFrameSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = photoFrameSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: languageSettings

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_LANGUAGE
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready ) source = "DHAVN_AppSettings_General_Language.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    languageSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = languageSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        // added for Media Notification(Idea Bank)
        DHAVN_AppSettings_FocusedLoader{
            id: mediaNotificationSettings

            name: "MediaNotificationLoader"
            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_MEDIA_NOTIFICATION
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if ( status != Loader.Ready ) source = "DHAVN_AppSettings_General_MediaNotification.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = lockRearMonitorSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }


        DHAVN_AppSettings_FocusedLoader{
            id: approvalSettings

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_APPROVAL
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready ) source = "DHAVN_AppSettings_General_Approval.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = approvalSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: distanceUnitSettings

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_DISNANCE_UNIT
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready ) source = "DHAVN_AppSettings_General_DistanceUnit.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status == Loader.Ready)
                    distanceUnitSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = distanceUnitSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: keypadSettings

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_KEYPAD
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready ) source = "DHAVN_AppSettings_General_KeypadSettings.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    keypadSettings.item.init();
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = keypadSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: rearSeatControlMenuLoader
            name: "RearSeatControlMenuLoader"

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_REAR_SEAT_CONTROL_MENU
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready ) source = "DHAVN_AppSettings_General_RearSeatControl_Menu.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = rearSeatControlMenuLoader.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: lockRearMonitorSettings

            name: "LockRearMonitorLoader"
            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_LOCK_REAR_MONITOR
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if ( status != Loader.Ready ) source = "DHAVN_AppSettings_General_LockRearMonitor.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = lockRearMonitorSettings.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: voice_volume

            name: "VoiceVolumeLoader"

            focus_x: 1
            focus_y: 0

            visible: rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_General_Phone_Priority.qml"
                    }
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    voice_volume.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = voice_volume.focus_visible
                    generalMenu.hideFocus()
                }
            }
        }
    }

    ListModel{
        id: general_list_model

        Component.onCompleted:
        {
            general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_LANGUAGE, "isCheckNA": false,  "isChekedState": true, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                          name: QT_TR_NOOP("STR_SETTING_GENERAL_LAN"),
                                          nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_LANGUAGE})

            general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_KEYPAD, "isCheckNA": false,  "isChekedState": false, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                          name: QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD"),
                                          nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_KEYPAD})

           // added for Media Notification(Idea Bank)
            general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_MEDIA_NOTIFICATION ,"isCheckNA":true, "isChekedState":SettingsStorage.mediaNotification, "isDimmed":false, "isPopupItem":false, "dbID": Settings.DB_KEY_MEDIA_NOTIFICATION,
                                        name:QT_TR_NOOP("STR_SETTING_GENERAL_MEDIA_NOTIFICATION_MENU"),
                                        nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_MEDIA_NOTIFICATION})

            general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_PHOTO_FRAME ,"isCheckNA": false, "isChekedState": true, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                          name: QT_TR_NOOP("STR_SETTING_GENERAL_PHOTO_FRAME"),
                                          nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_PHOTO_FRAME})

            // delete for its 243652
            /*
            general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_APPROVAL ,"isCheckNA": true, "isChekedState": SettingsStorage.approval, "isDimmed": false, "isPopupItem":false, "dbID": Settings.DB_KEY_APPROVAL,
                                          name: QT_TR_NOOP("STR_SETTING_GENERAL_AGREEMENT"),
                                          nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_APPROVAL})
                                          */
            // delete for its 243652

            if(SettingsStorage.rearMonitor)
            {
                general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_REAR_SEAT_CONTROL_MENU ,"isCheckNA":false, "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID": 0,
                                              name:QT_TR_NOOP("STR_SETTING_GENERAL_REAR_SEAT_CONTROL"),
                                              nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_REAR_SEAT_CONTROL_MENU})
            }
            else
            {
                if(SettingsStorage.rearRRCVariant)
                {
                    general_list_model.append({"itemNum": APP.const_SETTINGS_GENERAL_LOCK_REAR_MONITOR ,"isCheckNA":true, "isChekedState":SettingsStorage.rearLockScreen, "isDimmed":!(EngineListener.isAccStatusOn), "isPopupItem":false, "dbID": Settings.DB_KEY_LOCKREARMONITOR_FUNCTION,
                                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_LOCK_REAR_MONITOR_AND_FUNC"),
                                                  nameOfState: APP.const_APP_SETTINGS_GENERAL_STATE_LOCK_REAR_MONITOR})
                }
            }

            initialyseMenuItems()
        }
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_PHOTO_FRAME
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_PHOTO_FRAME) }
        },
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_LANGUAGE
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_LANGUAGE) }
        },
        // added for Media Notification(Idea Bank)
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_MEDIA_NOTIFICATION
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_MEDIA_NOTIFICATION) }
         },
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_KEYPAD
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_KEYPAD) }
        },
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_APPROVAL
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_APPROVAL) }
        },
        State{
            name : APP.const_APP_SETTINGS_GENERAL_STATE_LOCK_REAR_MONITOR
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_LOCK_REAR_MONITOR) }
        },
        State{
            name : APP.const_APP_SETTINGS_GENERAL_STATE_REAR_SEAT_CONTROL_MENU
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_REAR_SEAT_CONTROL_MENU) }
        },
        State{
            name: APP.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY
            PropertyChanges { target: generalMenu; selected_item: getItemIndex(APP.const_SETTINGS_GENERAL_PHONE_PRIORITY) }
        }
    ]

    Connections{
        target:SettingsStorage

        onApprovalChanged:
        {
            //console.log("called onApprovalChanged :"+SettingsStorage.approval)
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_GENERAL_APPROVAL)

            if (index != -1)
                general_list_model.setProperty(index,"isChekedState",SettingsStorage.approval)
        }

        onRearLockScreenChanged:
        {
            //console.log("called onRearLockScreenChanged :"+SettingsStorage.rearLockScreen)

            var index = -1
            index = getItemIndex(APP.const_SETTINGS_GENERAL_LOCK_REAR_MONITOR)

            if (index != -1)
                general_list_model.setProperty(index,"isChekedState",SettingsStorage.rearLockScreen)
        }

        // added for Media Notification(Idea Bank)
        onMediaNotificationChanged:{
            var index = -1
            index = getItemIndex( APP.const_SETTINGS_GENERAL_MEDIA_NOTIFICATION )
            if(index != -1){
                general_list_model.setProperty(index,"isChekedState",SettingsStorage.mediaNotification)
            }
        }

    }

    Connections{
        target:EngineListener

        onIsAccStatusOnChanged:
        {
            //console.log("## QML General - onIsAccStatusOnChanged: Menu isDimmed:"+!(EngineListener.isAccStatusOn) )
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_GENERAL_LOCK_REAR_MONITOR)

            if (index != -1)
                general_list_model.setProperty(index,"isDimmed", !(EngineListener.isAccStatusOn) )

            if(rootGeneral.state == APP.const_APP_SETTINGS_GENERAL_STATE_LOCK_REAR_MONITOR)
            {
                var nextIndex = index-1
                if(nextIndex>=0)
                    rootGeneral.state = general_list_model.get(nextIndex).nameOfState
            }
        }
    }
}
