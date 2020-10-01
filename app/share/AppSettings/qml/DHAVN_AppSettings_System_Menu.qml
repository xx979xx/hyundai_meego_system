import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.defines 1.0
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import PopUpConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: rootSystem
    name: "SystemMain"

    width: 1280; 
	height: 554

    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 0

    state: ""

    property int loopCount: 0

    function init()
    {
        contentArea.hideFocus()
        contentArea.setFocusHandle(0,0)
        contentArea.showFocus()
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
        case 0: setVisualCue(true, false, false, systemInfoLoader.is_focusMovable); visualCue.longkey_other = true; break
        case 1: setVisualCue(true, false, false, jukeBoxInfoLoader.is_focusMovable); visualCue.longkey_other = true; break
        case 2: setVisualCue(true, false, false, upgradeLoader.is_focusMovable); visualCue.longkey_other = true; break
        case 3: setVisualCue(true, false, false, false);  visualCue.longkey_other = false; break
        }
    }

    function setFocusCurrentMenu()
    {
        contentArea.__current_x = 0
        contentArea.__current_y = 0

        var index = contentArea.searchIndex( contentArea.__current_x, contentArea.__current_y)
        contentArea.__current_index = index

        contentArea.setFocus(contentArea.focus_x, contentArea.focus_y)
    }

    DHAVN_AppSettings_FocusedItem{
        id: contentArea
        name: "SystemContent"
        anchors.fill:parent

        focus_x: 0
        focus_y: 0
        default_x: 0
        default_y: 0

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
            x:0; y: 73
            menu_model: list_model

            focus_x: 0
            focus_y: 0

            name: "SystemMenu"

            onSelectItem:
            {
                if(!bJog)
                {
                    contentArea.hideFocus()
                    setFocusCurrentMenu()
                    //contentArea.setFocusHandle(0,0)
                }

                switch( item )
                {
                case 0:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO
                    break
                }
                case 1:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_JUKEBOX_INFO
                    break
                }
                case 2:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_UPDATE
                    break
                }
                case 3:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_RESET_ALL
                    EngineListener.showPopapInMainArea(Settings.SETTINGS_RESET_GENERAL_SETTINGS, UIListener.getCurrentScreen())
                    break
                }
                }

                if(!bJog)
                {
                    moveFocus(1,0)

                    if(item !=3) // if(item !=2 || item != 4)
                        contentArea.showFocus()
                }
            }

            onCurrentIndexChanged:
            {
                switch( currentIndex )
                {
                case 0:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO
                    break
                }
                case 1:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_JUKEBOX_INFO
                    break
                }
                case 2:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_UPDATE
                    break
                }
                case 3:
                {
                    rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_RESET_ALL
                    break
                }
                }

                if (focus_visible)
                    setVisualCueOnMenu(currentIndex)
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    idCueSettings.isRightBg = false
                    setVisualCueOnMenu(menu.selected_item)
                }
            }

            onMovementEnded:
            {
                if(!focus_visible && !root.getPopUpState()) //added for ITS 247055 two Focus Issue When show Reset PopUp // ITS 261652
                {
                    contentArea.hideFocus()
                    contentArea.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        contentArea.showFocus()
                    }
                }
            }
        }

        Binding {
            id: jukeBoxInfoLoaderIsEnableBinding
            target: jukeBoxInfoLoader
            property: "is_focusMovable"
            value: jukeBoxInfoLoader.item.is_focusMovable
        }

        Binding {
            id: systemInfoLoaderIsEnableBinding
            target: systemInfoLoader
            property: "is_focusMovable"
            value: systemInfoLoader.item.is_focusMovable
        }

        DHAVN_AppSettings_FocusedLoader{
            id: systemInfoLoader
            visible: rootSystem.state == APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO
            opacity: visible ? 1 : 0

            name: "SystemInfoLoader"

            focus_x: 1
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_System_SystemInfo.qml"
                    }
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
                    idCueSettings.isRightBg = systemInfoLoader.focus_visible
                    menu.hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status == Loader.Ready )
                    is_focusMovable = systemInfoLoader.item.is_focusMovable
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: upgradeLoader
            name: "UpgradeLoader"

            focus_x: 1
            focus_y: 0

            visible: rootSystem.state == APP.const_APP_SETTINGS_SYSTEM_STATE_UPDATE
            opacity: visible ? 1 : 0

            is_focusMovable: EngineListener.usbUpdatePresent

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_System_Update.qml"
                    }
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
                    idCueSettings.isRightBg = upgradeLoader.focus_visible
                    menu.hideFocus()
                }
            }

            onIs_focusMovableChanged:
            {
                if(!is_focusMovable && focus_visible && visible)
                    moveFocus(-1, 0)
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: resetAllLoader
            name: "ResetAllLoader"

            focus_x: 1
            focus_y: 0

            visible: rootSystem.state == APP.const_APP_SETTINGS_SYSTEM_STATE_RESET_ALL
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_System_Reset_All.qml"
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
                    idCueSettings.isRightBg = resetAllLoader.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: jukeBoxInfoLoader
            visible: rootSystem.state == APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_JUKEBOX_INFO
            opacity: visible ? 1 : 0

            source: "DHAVN_AppSettings_System_JukeBoxInfo.qml"
            name: "JukeBoxInfoLoader"
            focus_x: 1
            focus_y: 0

            function formatStartHandler()
            {
                if(focus_visible && visible)
                {
                    moveFocus(-1, 0)
                }
            }

            onVisibleChanged:
            {
                if ( visible )
                {
                    JukeBoxInfo.startUpdateInfo(false)
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status == Loader.Ready)
                {
                    JukeBoxInfo.startUpdateInfo(false)
                    jukeBoxInfoLoader.item.formatStart.connect(jukeBoxInfoLoader.formatStartHandler)
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = jukeBoxInfoLoader.focus_visible
                    menu.hideFocus()
                }
            }

            onIs_focusMovableChanged:
            {
                if(!is_focusMovable)
                {
                    if(focus_visible)
                    {
                        setFocusCurrentMenu()
                        rootSystem.showFocus()
                    }
                }
            }
            //added for AA/CP Setting
            Connections{
                target:EngineListener

                onSigConnectedCarMounted:
                {
                    if(root.isShowJukeboxPopup())
                    {
                        isJukeBoxFormatCP = true
                    }
                    EngineListener.printLogMessage("SystemInfo: onSigConnectedCarMounted: " + rootSystem.visible + targetScreen)
                    EngineListener.printLogMessage("SystemInfo: root.state : " + root.state)
                    EngineListener.printLogMessage("SystemInfo: mainMenuState : " + mainMenuState)
                    if(mainMenuState == APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM)
                    {
                        if(targetScreen == 2){//front enable, rear enable
                           if(EngineListener.isFrontSystem)//front system menu
                           {
                                 EngineListener.printLogMessage("front system info checked")
                                 root.backButtonHandler(1) //front
                            }
                           if(EngineListener.isRearSystem)//front system menu
                           {
                                 EngineListener.printLogMessage("rear system info checked")
                                 root.backButtonHandler(2) //rear
                           }
                        }
                        else if(targetScreen == 1){
                            root.backButtonHandler(2)
                        }
                        else //0(m_bFG_F && !m_bFG_R) //mainMenuState not properly
                        {
                            if(EngineListener.isFrontSystem)//front system menu
                            {
                                EngineListener.printLogMessage("front system info checked")
                                root.backButtonHandler(1)
                            }
                        }
                    }
                    isJukeBoxFormatCP =false;
                }

            }

            // add for ITS 242187 -->
            Connections{
                target:SettingsStorage

                onCalendarTypeChanged:
                {
                    // delete for its 243424
                    //rootSystem.state = APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_JUKEBOX_INFO
                    menu.moveFocus(1,0)
                }
            }
            // add for ITS 242187 <--

            // add for ITS 244219 -->
            Connections{
                target: JukeBoxInfo

                onJukeBoxInfoUpdated:
                {
                    //console.log("kjw :: usedMb : ", usedMb)
                    if(usedMb == 0)
                    {
                        setFocusCurrentMenu()
                        rootSystem.showFocus()
                    }
                    if(menu.selected_item == 1)
                    {
                        console.log("kjw :: enter")
                        if(usedMb == 0)
                        {
                            setVisualCue(true, false, false, false); visualCue.longkey_other = true;
                        }
                        else
                        {
                            setVisualCue(true, false, false, true); visualCue.longkey_other = true;
                        }
                    }
                }
            }
            // add for ITS 244219 <--
        }

    }

    ListModel{
        id: list_model

        Component.onCompleted:
        {
            list_model.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_SYSTEM_VERSION")})
            list_model.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_SYSTEM_JUKEBOX_INFO")})
            //list_model.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
            //                      name:QT_TR_NOOP("STR_SETTING_SYSTEM_JUKEBOX_LAUNCH_FORMAT")})
            list_model.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_SYSTEM_UPDATE")})
            list_model.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_RESET_ALL")})
        }
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO
            PropertyChanges { target: menu; selected_item: 0 }
            PropertyChanges { target: root; bEnableLaunchMapCare: true }
        },
        State{
            name: APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_JUKEBOX_INFO
            PropertyChanges { target: menu; selected_item: 1 }
            PropertyChanges { target: root; bEnableLaunchMapCare: false }
        },
        State{
            name: APP.const_APP_SETTINGS_SYSTEM_STATE_UPDATE
            PropertyChanges { target: menu; selected_item: 2 }
            PropertyChanges { target: root; bEnableLaunchMapCare: false }
        },
        State{
            name: APP.const_APP_SETTINGS_SYSTEM_STATE_RESET_ALL
            PropertyChanges { target: menu; selected_item: 3 }
            PropertyChanges { target: root; bEnableLaunchMapCare: false }
        }
    ]
}
