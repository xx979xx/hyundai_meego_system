import QtQuick 1.1

import com.settings.variables 1.0
import com.settings.defines 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootScreen

    //property bool isInitialized: false

    property bool _videostatus
    property bool screenRatioEnable: true

    width: 1280
    height: 627

    name: "RootScreen"

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    function init()
    {
        content_screen.hideFocus()
        content_screen.setFocusHandle(0,0)
        content_screen.showFocus()
    }

    function setVisualCue(up, down, left, right)
    {
        visualCue.upArrow = up
        visualCue.downArrow = down
        visualCue.leftArrow = left
        visualCue.rightArrow = right
    }

    function setVisualCueOnMenu( index )
    {
        switch (index)
        {
        case 0: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 1: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 2: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 3: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 4: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break //added for DH PE
        case 5: setVisualCue(true, false, false, false); visualCue.longkey_other = false; break
        }
    }

    function setRootState(index, isSelectItem)
    {
        switch(index)
        {
        case 0: rootScreen.state = "video_mode";        break;
        //case 1: rootScreen.state = "non_video_mode";    break;
        case 1: rootScreen.state = "illumination_daylight"; break;
        case 2: rootScreen.state = "illumination_night"; break;
        case 3: rootScreen.state = "screen_dimming";    break;
        case 4: rootScreen.state = "aspect_ratio";      break;
        case 5:
        {
            rootScreen.state = "screen_reset_all";
            if(isSelectItem)
            {
                EngineListener.showPopapInMainArea(Settings.SETTINGS_RESET_SCREEN_SETTINGS, UIListener.getCurrentScreen())
            }
            break;
        }
        }
    }

    function setFocusCurrentMenu()
    {
        content_screen.__current_x = 0
        content_screen.__current_y = 0

        var index = content_screen.searchIndex( content_screen.__current_x, content_screen.__current_y)
        content_screen.__current_index = index

        content_screen.setFocus(content_screen.focus_x, content_screen.focus_y)
    }

    function updateListItem( videoStatus )
    {
        //console.log("[QML][Screen]updateListItem(videoStatus):videoStatus:"+videoStatus)
        _videostatus = videoStatus

        menu.updateDimm()
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_screen
        anchors.fill:parent
        name: "content menu"
        default_x: 0
        default_y: 0
        focus_x: 0
        focus_y: 0

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                if(is_focused_BackButton)
                    menu.moveFocus(1,0)

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
            id: menu
            anchors.top: parent.top
            anchors.topMargin: 73
            anchors.left : parent.left

            menu_model: list_model

            focus_x: 0
            focus_y: 0

            onSelectItem:
            {
                if( item == 0 )
                {
                    bgShowAni.running = false
                    bgHideAni.running = true
                    //bg.opacity = 0.6
                }
                else
                {
                    //bgOpacityTimer.stop()
                    bgHideAni.running = false
                    bgShowAni.running = true
                    //bg.opacity = 1
                }

                if(!bJog)
                {
                    content_screen.hideFocus()
                    setFocusCurrentMenu()
                    //content_screen.setFocusHandle(0,0)
                }

                setRootState(item, true)
                //setVisualCueOnMenu(item)

                if(!bJog)
                {
                    moveFocus(1,0)

                    if(rootScreen.state != "screen_reset_all") // Screen Reset All
                        content_screen.showFocus()
                }
            }

            onCurrentIndexChanged:
            {
                if( currentIndex == 0 )
                {
                    bgShowAni.running = false
                    bgHideAni.running = true
                    //bg.opacity = 0.6
                }
                else
                {
                    //bgOpacityTimer.stop()
                    bgHideAni.running = false
                    bgShowAni.running = true
                    //bg.opacity = 1
                }

                setRootState(currentIndex, false)

                if(focus_visible)
                    setVisualCueOnMenu(currentIndex)
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = false
                    setVisualCueOnMenu(menu.selected_item)
                }
            }

            onMovementEnded:
            {
                if(!focus_visible && !root.getPopUpState()) //added for ITS 247055 two Focus Issue When show Reset PopUp // ITS 261652
                {
                    content_screen.hideFocus()
                    content_screen.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        content_screen.showFocus()
                    }
                }
            }

            function updateDimm()
            {
                if(rootScreen._videostatus)
                {
                    list_model.setProperty(0,"isDimmed",0)
                    rootScreen.state = "video_mode"
                    //menu.selected_item = 0
                }
                else
                {
                    list_model.setProperty(0,"isDimmed",1)

                    if(rootScreen.state == "video_mode")
                    {
                        //rootScreen.state = "non_video_mode"
                        rootScreen.state = "illumination_daylight"
                    }
                }

            }

            function updateRatioDim()
            {
                if(rootScreen.screenRatioEnable){
                    list_model.setProperty(4, "isDimmed", 0)
                }
                else{
                    list_model.setProperty(4, "isDimmed", 1)
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: videoSettings

            focus_x: 1
            focus_y: 0

            visible: rootScreen.state == "video_mode"
            opacity: visible ? 1 : 0
            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready ){
                        if( SettingsStorage.currentRegion != 1 )
                            source = "DHAVN_AppSettings_Screen_VideoImage.qml"
                        else
                            source = "DHAVN_AppSettings_Screen_VideoImage_ForNA.qml"
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
                    videoSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = videoSettings.focus_visible
                    menu.hideFocus()
                }
            }
        }

        /*
        DHAVN_AppSettings_FocusedLoader{
            id: nonvideoSettings

            focus_x: 1
            focus_y: 0

            visible: rootScreen.state == "non_video_mode"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Screen_NonVideoMode.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status== Loader.Ready)
                    nonvideoSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = nonvideoSettings.focus_visible
                    menu.hideFocus()
                }
            }
        }
        */

        DHAVN_AppSettings_FocusedLoader{
            id: illuminationDaylight

            focus_x: 1
            focus_y: 0

            visible: rootScreen.state == "illumination_daylight"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready ){
                        if( SettingsStorage.currentRegion != 1 )
                            source = "DHAVN_AppSettings_Screen_Illumination_Daylight.qml"
                        else
                            source = "DHAVN_AppSettings_Screen_Illumination_Daylight_ForNA.qml"

                    }

                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status== Loader.Ready)
                    illuminationDaylight.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = illuminationDaylight.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: illuminationNight

            focus_x: 1
            focus_y: 0

            visible: rootScreen.state == "illumination_night"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready ){
                        if( SettingsStorage.currentRegion != 1 )
                            source = "DHAVN_AppSettings_Screen_Illumination_Night.qml"
                        else
                            source = "DHAVN_AppSettings_Screen_Illumination_Night_ForNA.qml"
                    }

                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status== Loader.Ready)
                    illuminationNight.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = illuminationNight.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: dimmingSettings

            focus_x: 1
            focus_y: 0

            visible: rootScreen.state == "screen_dimming"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_Screen_SetDimming.qml"
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
                    dimmingSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = dimmingSettings.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: aspectRatioSettings

            focus_x: 1
            focus_y: 0

            visible: rootScreen.state == "aspect_ratio"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_Screen_SetAspectratio.qml"
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
                    aspectRatioSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = aspectRatioSettings.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: resetAll

            name: "ResetAllLoader"

            visible: rootScreen.state == "screen_reset_all"
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Screen_ResetAll.qml"
                }
                else
                {
                    hideFocus()
                }
            }
        }
    }

    ListModel{
        id: list_model

        Component.onCompleted:
        {
            list_model.append({"isCheckNA":false,  "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID":0,
                                  name:QT_TR_NOOP("STR_SETTING_DISPLAY_VIDEO_IMAGE")})
            if(SettingsStorage.exposure == 0x00) // Auto
            {
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_DAYLIGHT")})
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_NIGHT")})
            }
            else if(SettingsStorage.exposure == 0x01) //Day
            {
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_DAYLIGHT")})
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":true, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_NIGHT")})
            }
            else if(SettingsStorage.exposure == 0x02) //Night
            {
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":true, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_DAYLIGHT")})
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_NIGHT")})
            }
            else
            {
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_DAYLIGHT")})
                list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_DISPLAY_PE_LCD_BRIGHTNESS_SETTING_NIGHT")})
            }


            list_model.append({"isCheckNA":false,  "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING")})
            list_model.append({"isCheckNA":false, "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_DISPLAY_ASPECT_RATIO")})
            list_model.append({"isCheckNA":false, "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_INITIALIZE_RESET")})
        }
    }

    states:
        [
        State{
            name: "video_mode"
            PropertyChanges { target: menu; selected_item: 0 }
        },
        //State{
        //    name: "non_video_mode"
        //    PropertyChanges { target: menu; selected_item: 1 }
        //},
        State{
            name: "illumination_daylight"
            PropertyChanges { target: menu; selected_item: 1 }
        },
        State{
            name: "illumination_night"
            PropertyChanges { target: menu; selected_item: 2}
        },
        State{
            name:"screen_dimming"
            PropertyChanges { target: menu; selected_item: 3 }
        },
        State{
            name: "aspect_ratio"
            PropertyChanges { target: menu; selected_item: 4 }
        },
        State{
            name: "screen_reset_all"
            PropertyChanges { target: menu; selected_item: 5 }
        }
    ]

    Connections{
        target: SettingsStorage

        onExposureChanged:
        {

            if(SettingsStorage.exposure == 0x00) // Auto
            {
                list_model.setProperty(1,"isDimmed", false)
                list_model.setProperty(2,"isDimmed", false)

            }
            else if(SettingsStorage.exposure == 0x01) //Day
            {
                list_model.setProperty(1,"isDimmed", false)
                list_model.setProperty(2,"isDimmed", true)
            }
            else if(SettingsStorage.exposure == 0x02) //Night
            {
                list_model.setProperty(1,"isDimmed", true)
                list_model.setProperty(2,"isDimmed", false)
            }
            else
            {
                list_model.setProperty(1,"isDimmed", false)
                list_model.setProperty(2,"isDimmed", false)
            }
        }
    }

    Connections{
        target:EngineListener

        onVideoStatusChanged:
        {
            if(targetScreen == UIListener.getCurrentScreen())
            {
                _videostatus = enable
                //_videostatus = EngineListener.NotifyVideoMode (targetScreen)
                menu.updateDimm()
            }
        }
        onScreenRatioEnDisable:{
            EngineListener.printLogMessage("onScreenRatioEnDisable: targetScreen:: " + targetScreen);
            EngineListener.printLogMessage("onScreenRatioEnDisable: enable:: " + enable);
            if(targetScreen == UIListener.getCurrentScreen()){

                screenRatioEnable = enable
                menu.updateRatioDim()

            }

        }

        onSigCameraOnOff: {
            if(screen == UIListener.getCurrentScreen())
            {
                if (menu.selected_item == 0)
                {
                    if (cameraOnOff)  //camera on
                    {
                        bg.opacity = 1
                    }
                    else  // camera off
                    {
                        bgShowAni.running = false
                        bgHideAni.running = true
                    }
                }
            }
        }
    }
}
