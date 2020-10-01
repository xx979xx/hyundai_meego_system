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

    function init()
    {
        console.log("enter rootsystem init() !!!")
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
        case 0: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 1: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 2: setVisualCue(true, false, false, true); visualCue.longkey_other = true; break
        case 3: setVisualCue(true, false, false, true);  visualCue.longkey_other = false; break
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
/*
    function getKeypadModel()
    {
        console.log("kjw :: enter getKeypadModel()")
        console.log("kjw :: SettingsStorage.hyunDaiKeypad : ", SettingsStorage.hyunDaiKeypad)
        switch(SettingsStorage.hyunDaiKeypad)
        {
        case 0: return list_model_Domestic_General  // SETTINGS_HYUNDAI_KOREAN = 0
        case 1: return list_model_NA                // SETTINGS_HYUNDAI_ENGLISH_LATIN = 1
        case 2: return list_model_Arabic            // SETTINGS_HYUNDAI_ARABIC = 2
        case 3: return list_model_China             // SETTINGS_HYUNDAI_CHINA = 3
        case 4:
            if (SettingsStorage.currentRegion == 5)
                return list_model_europe            // SETTINGS_HYUNDAI_EUROPE = 4
            else if (SettingsStorage.currentRegion == 7)
                return list_model_russia
            break
        default:
            return list_model_Domestic_General;
        }
    }
*/
    function getKeypadModel()
    {
        console.log("kjw :: enter getKeypadModel()")
        console.log("kjw :: SettingsStorage.currentRegion : ", SettingsStorage.currentRegion)
        switch(SettingsStorage.currentRegion)
        {
        case 0: return list_model_Domestic_General; break;
        case 1: return list_model_NA; break;
        case 2: return list_model_China; break;
        case 3: return list_model_Domestic_General; break;
        case 4: return list_model_Arabic; break;
        case 5: return list_model_europe; break;
        case 6: return list_model_NA; break;
        case 7: return list_model_russia; break;
        default: return list_model_Domestic_General; break;
        }
    }

    function init_list()
    {
        console.log("kjw :: enter init_list() !!!")
        switch(SettingsStorage.currentRegion)
        {
        case 0:
        case 3:
            list_model_Domestic_General.setItems();
            break;
        case 1:
        case 6:
            list_model_NA.setItems();
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            else
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            break;

        case 2:
            list_model_China.setItems();
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            else
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            break;

        case 4:
            list_model_Arabic.setItems();
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            else
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Arab.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            break;

        case 5:
            list_model_europe.setItems();
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            else
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Euro.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            break;

        case 7:
            list_model_russia.setItems();
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            else
            {
                systemInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Euro.qml"
                jukeBoxInfoLoader.source = "DHAVN_AppSettings_OnlyKeypad_Russia.qml"
                upgradeLoader.source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
            }
            break;

        default:
            list_model_Domestic_General.setItems(); break;
        }

        //soundVolumeRatio1.init()
        systemInfoLoader.item.init()
        jukeBoxInfoLoader.item.init()
        upgradeLoader.item.init()

        rootSystem.hideFocus()
        rootSystem.setFocusHandle(1,0)
        rootSystem.showFocus()
        //contentArea.__current_index = 2
        //contentArea.setFocus(0, 2)
        //contentArea.setFocusHandle(0,2)
        //menu.moveFocus(0,2)
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
            menu_model: rootSystem.getKeypadModel()

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
                if(!focus_visible)
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

        DHAVN_AppSettings_FocusedLoader{ // 1
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
                        switch(SettingsStorage.currentRegion)
                        {
                        case 0:
                        case 3:
                            source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"; break;
                        case 1:
                        case 6:
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                            break;
                        case 2:
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                            break;
                        case 4:
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Arab.qml";
                            break;
                        case 5:
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Euro.qml";
                            break;
                        case 7:
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Euro.qml";
                            break;
                        }

                        //source = "DHAVN_AppSettings_OnlyKeypad_Korean.qml"
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
                if( status == Loader.Ready )
                    systemInfoLoader.item.init()
            }
        }

        DHAVN_AppSettings_FocusedLoader{ // 3
            id: upgradeLoader
            visible: rootSystem.state == APP.const_APP_SETTINGS_SYSTEM_STATE_UPDATE
            opacity: visible ? 1 : 0

            name: "UpgradeLoader"

            focus_x: 1
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if(status != Loader.Ready )
                    {
                        switch(SettingsStorage.currentRegion)
                        {
                        case 0:
                        case 3: // korea, general
                            source = ""; break;
                        case 1:
                        case 6: // NA
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
                            else
                                source = ""
                            break;
                        case 2: // china
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml";
                            else
                                source = ""
                            break;
                        case 4: // arab
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml";
                            break;
                        case 5: //europ
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml";
                            else
                                source = ""
                            break;
                        case 7: // russia
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml";
                            break;
                        }
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

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    upgradeLoader.item.init()
            }
        }

        DHAVN_AppSettings_FocusedLoader{ // 4
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
                        switch(SettingsStorage.currentRegion)
                        {
                        case 0:
                        case 3: // korea, general
                            source = ""; break;
                        case 1:
                        case 6: // NA
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = ""
                            else
                                source = ""
                            break;
                        case 2: // china
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "";
                            else
                                source = ""
                            break;
                        case 4: // arab
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "";
                            else
                                source = "";
                            break;
                        case 5: //europ
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "";
                            else
                                source = ""
                            break;
                        case 7: // russia
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "";
                            else
                                source = "";
                            break;
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
                    idCueSettings.isRightBg = resetAllLoader.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{ // 2
            id: jukeBoxInfoLoader
            visible: rootSystem.state == APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_JUKEBOX_INFO
            opacity: visible ? 1 : 0

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
                    if( status != Loader.Ready )
                    {
                        switch(SettingsStorage.currentRegion)
                        {
                        case 0:
                        case 3: // korea, general
                            source = "DHAVN_AppSettings_OnlyKeypad_English.qml"; break;
                        case 1:
                        case 6: // NA
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml"
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
                            break;
                        case 2: // china
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
                            break;
                        case 4: // arab
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml";
                            break;
                        case 5: //europ
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Default.qml"
                            break;
                        case 7: // russia
                            if(SettingsStorage.hyunDaiKeypad == 0)
                                source = "DHAVN_AppSettings_OnlyKeypad_English.qml";
                            else
                                source = "DHAVN_AppSettings_OnlyKeypad_Russia.qml";
                            break;
                        }
                    }
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
        }

    }

    ListModel{
        id: list_model_China

        //Component.onCompleted:
        function setItems()
        {
            list_model_China.clear()
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                list_model_China.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")})
            }

            list_model_China.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
            list_model_China.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
        }
        Component.onCompleted:
        {
            setItems()
        }
    }

    ListModel{
        id: list_model_NA

        //Component.onCompleted:
        function setItems()
        {
            list_model_NA.clear()
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                list_model_NA.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")})
            }
            list_model_NA.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
            list_model_NA.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
        }
        Component.onCompleted:
        {
            setItems()
        }
    }

    ListModel{
        id: list_model_Arabic

        //Component.onCompleted:
        function setItems()
        {
            list_model_Arabic.clear()
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                list_model_Arabic.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")})
                list_model_Arabic.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
                list_model_Arabic.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
            }
            else
            {
                list_model_Arabic.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ARABIC_KEYPAD")})
                list_model_Arabic.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
                list_model_Arabic.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
            }
        }
        Component.onCompleted:
        {
            setItems()
        }
    }

    ListModel{
        id: list_model_europe

        //Component.onCompleted:
        function setItems()
        {
            list_model_europe.clear()
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                list_model_europe.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")})
            }
            list_model_europe.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_TYPE")})
            list_model_europe.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
        }
        Component.onCompleted:
        {
            setItems()
        }
    }

    ListModel{
        id: list_model_russia

        //Component.onCompleted:
        function setItems()
        {
            console.log("enter setItems() !!!")
            list_model_russia.clear()
            if(SettingsStorage.hyunDaiKeypad == 0)
            {
                list_model_russia.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")})
                list_model_russia.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
                list_model_russia.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
            }
            else
            {
                list_model_russia.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
                list_model_russia.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CYRILIC_RUS")})
                list_model_russia.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_DEFAULT")})
            }
/*
            rootSystem.hideFocus()
            rootSystem.setFocusHandle(0,0)
            rootSystem.showFocus()*/
        }
        Component.onCompleted:
        {
            setItems()
            //contentArea.__current_index = 2
        }
    }

    ListModel{
        id: list_model_Domestic_General

        //Component.onCompleted:
        function setItems()
        {
            list_model_Domestic_General.clear()
            list_model_Domestic_General.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")})
            list_model_Domestic_General.append({"isCheckNA":false,  "isChekedState":true, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_ENGLISH_KEYPAD")})
        }
        Component.onCompleted:
        {
            setItems()
        }
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO
            PropertyChanges { target: menu; selected_item: 0 }
            PropertyChanges { target: root; bEnableLaunchMapCare: false }
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
