import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import AppEngineQMLConstants 1.0


DHAVN_AppSettings_FocusedItem{
    id: rootSound

    anchors.top: parent.top
    anchors.left: parent.left

    width: 1280
    height: 554

    name: "RootSound"
    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    function init()
    {
        rootSoundItem.hideFocus()
        rootSoundItem.setFocusHandle(0,0)
        rootSoundItem.showFocus()
    }

    function setRootState( index )
    {
        rootSound.state = list_model.get(index).nameOfState
    }

    function getItemIndex(itemNumber)
    {
        var retVal = -1
        for(var i=0; i<list_model.count;i++)
        {
            if(list_model.get(i).itemNum == itemNumber)
            {
                retVal = i
                return retVal
            }
        }
        return retVal
    }

    function setVisualCue(up, down, left, right)
    {
        visualCue.upArrow = up
        visualCue.downArrow = down
        visualCue.leftArrow = left
        visualCue.rightArrow = right
    }

    function setVisualCueOnMenu( itemNumber )
    {
        switch (itemNumber)
        {
        case APP.const_SETTINGS_SOUND_VOLUME_RATIO  : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_SOUND_BALANCE       : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_SOUND_TONES         : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        //case APP.const_SETTINGS_SOUND_SURROUND      : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break // 2014.02.24 DH_PE Quantum logic
        case APP.const_SETTINGS_SOUND_CLARIFI       : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_SOUND_VIP_SOUND     : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_SOUND_SDVC          : setVisualCue(true, false, true, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_SOUND_BEEP          : setVisualCue(true, false, false, false); visualCue.longkey_other = true; break
        case APP.const_SETTINGS_SOUND_RESET_ALL     : setVisualCue(true, false, false, false); visualCue.longkey_other = false; break
        case APP.const_SETTINGS_SOUND_QUANTUMLOGIC  : setVisualCue(true, false, true, false); visualCue.longkey_other = true; break // 2014.02.24 DH_PE Quantum logic
        }
    }

    function setFocusCurrentMenu()
    {
        rootSoundItem.__current_x = 0
        rootSoundItem.__current_y = 0

        var index = rootSoundItem.searchIndex( rootSoundItem.__current_x, rootSoundItem.__current_y)
        rootSoundItem.__current_index = index

        rootSoundItem.setFocus(rootSoundItem.focus_x, rootSoundItem.focus_y)
    }

    Timer{
        id : surroundSaveTimer
        interval: 300
        running: false
        repeat: false

        onTriggered:
        {
            var tempValue = SettingsStorage.surround
            SettingsStorage.SaveSetting( tempValue, Settings.DB_KEY_SOUND_SURROUND )
            EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_SURROUND, tempValue, "", UIListener.getCurrentScreen())
        }
    }

    Timer{
        id : clariFiSaveTimer
        interval: 300
        running: false
        repeat: false

        onTriggered:
        {
            var tempValue = SettingsStorage.clariFi
            SettingsStorage.SaveSetting( tempValue, Settings.DB_KEY_CLARIFI )
            EngineListener.NotifyApplication(Settings.DB_KEY_CLARIFI, tempValue, "", UIListener.getCurrentScreen())
        }
    }

    Timer{
        id : vipSoundSaveTimer
        interval: 300
        running: false
        repeat: false

        onTriggered:
        {
            var tempValue = SettingsStorage.vipSound
            SettingsStorage.SaveSetting( tempValue, Settings.DB_KEY_VIP_SOUND )
            EngineListener.NotifyApplication(Settings.DB_KEY_VIP_SOUND, tempValue, "", UIListener.getCurrentScreen())
        }
    }

    Timer{
        id : beepSoundSaveTimer
        interval: 300
        running: false
        repeat: false

        onTriggered:
        {
            var tempValue = SettingsStorage.beepSound
            SettingsStorage.SaveSetting( tempValue, Settings.DB_KEY_SOUND_BEEP )
            EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_BEEP, tempValue, "", UIListener.getCurrentScreen())
        }
    }

    Timer{
        id : avcSaveTimer
        interval: 300
        running: false
        repeat: false

        onTriggered:
        {
            var tempValue = SettingsStorage.avc
            SettingsStorage.SaveSetting( tempValue, Settings.DB_KEY_SOUND_SPEED )
            EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_SPEED, tempValue, "", UIListener.getCurrentScreen())
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: rootSoundItem

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height

        name: "RootSoundItem"
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
            property bool tempValue

            anchors.top: parent.top
            anchors.topMargin: 73
            anchors.right: parent.right

            menu_model: list_model
            name: "Sound Menu"

            focus_x: 0
            focus_y: 0

            onSelectItem:
            {
                if(!bJog)
                {
                    rootSoundItem.hideFocus()
                    setFocusCurrentMenu()
                }

                setRootState(item)

                switch(list_model.get(item).itemNum)
                {
                case APP.const_SETTINGS_SOUND_SURROUND:
                {
                    if(SettingsStorage.surround) SettingsStorage.surround = false;
                    else SettingsStorage.surround = true;

                    surroundSaveTimer.restart()
                }
                break
                case APP.const_SETTINGS_SOUND_CLARIFI:
                {
                    if(SettingsStorage.clariFi) SettingsStorage.clariFi = false;
                    else SettingsStorage.clariFi = true;

                    clariFiSaveTimer.restart();
                }
                break;
                case APP.const_SETTINGS_SOUND_VIP_SOUND:
                {
                    if(SettingsStorage.vipSound) SettingsStorage.vipSound = false;
                    else SettingsStorage.vipSound = true;

                    vipSoundSaveTimer.restart()
                }
                break
                //case APP.const_SETTINGS_SOUND_SDVC:
                //{
                //    if(SettingsStorage.avc) SettingsStorage.avc = false;
                //    else SettingsStorage.avc = true;

                //    avcSaveTimer.restart()
                //}
                //break
                case APP.const_SETTINGS_SOUND_BEEP:
                {
                    if(SettingsStorage.beepSound) SettingsStorage.beepSound = false;
                    else SettingsStorage.beepSound = true;

                    EngineListener.SendBeepSettingToIBox(SettingsStorage.beepSound)

                    beepSoundSaveTimer.restart()
                }
                break
                case APP.const_SETTINGS_SOUND_RESET_ALL:
                {
                    rootSound.state = APP.const_APP_SETTINGS_SOUND_STATE_RESET_ALL;
                    EngineListener.showPopapInMainArea(Settings.SETTINGS_RESET_SOUND_SETTINGS, UIListener.getCurrentScreen())
                }
                break
                }

                if(!bJog)
                {
                    moveFocus(1,0)

                    if(list_model.get(item).itemNum != APP.const_SETTINGS_SOUND_RESET_ALL)
                        rootSoundItem.showFocus()
                }
            }

            onCurrentIndexChanged:
            {
                //console.log ("Sound Menu onCurrentIndexChanged = " + currentIndex)

                setRootState(currentIndex)
                if (focus_visible)  setVisualCueOnMenu(list_model.get(currentIndex).itemNum)
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    idCueSettings.isRightBg = false
                    setVisualCueOnMenu(list_model.get(selected_item).itemNum)
                }
            }

            onMovementEnded:
            {
                if(!focus_visible && !root.getPopUpState()) //added for ITS 247055 two Focus Issue When show Reset PopUp // ITS 261652
                {
                    rootSoundItem.hideFocus()
                    rootSoundItem.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        rootSoundItem.showFocus()
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: balance

            name: "BalanceLoader"
            focus_x: 1
            focus_y: 0

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_BALANACE
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_Balance.qml"
                }
                else
                {
                    balance.hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status== Loader.Ready)
                {
                    balance.item.init()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = balance.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: tones

            name: "TonesLoader"
            focus_x: 1
            focus_y: 0

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_TONES
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_Tones.qml"
                }
                else
                {
                    tones.hideFocus()
                }
            }

            onStatusChanged:
            {
                if(status == Loader.Ready)
                {
                    tones.item.init()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = tones.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: speed

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_SPEED_DEPENDENT_VC
            opacity: visible ? 1 : 0

            name: "SpeedLoader"
            focus_x: 1
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_PESpeed.qml"
                }
                else
                {
                    speed.hideFocus()
                }
            }
            onStatusChanged:
            {
                if( status == Loader.Ready )
                    speed.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = speed.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: beep

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_BEEP
            opacity: visible ? 1 : 0

            name: "BeepLoader"

            onVisibleChanged:
            {
                if ( visible )
                {
                    if ( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_Beep.qml"
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: volumeratiocontrol

            name: "VolumeratioLoader"

            focus_x: 1
            focus_y: 0

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_VOLUME_RATIO_CONTROL
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        // 2014.02.24 DH_PE Simplified VolumeRatio
                        //source = "DHAVN_AppSettings_Sound_VolumeRatioControl.qml"
                        source = "DHAVN_AppSettings_Sound_VolumeRatio_Simplified.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    volumeratiocontrol.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = volumeratiocontrol.focus_visible
                    menu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: surround

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_SURROUND
            opacity: visible ? 1 : 0

            name: "SurroundLoader"

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_Surround.qml"
                }
            }
        }

        // { 2014.02.24 DH_PE Quantum logic
        DHAVN_AppSettings_FocusedLoader{
            id: quantumLogic

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_QUANTUM_LOGIC
            opacity: visible ? 1 : 0

            focus_x: 1
            focus_y: 0

            name: "QuantumLogicLoader"

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_QuantumLogic.qml"
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    quantumLogic.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = quantumLogic.focus_visible
                    menu.hideFocus()
                }
            }
        }
	// } 2014.02.24 DH_PE

        /*
        DHAVN_AppSettings_FocusedLoader{
            id: variableEQ

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_VARIABLE_EQ
            opacity: visible ? 1 : 0

            name: "VariableEQLoader"
            focus_x: 1
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_VariableEQ.qml"
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    variableEQ.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = variableEQ.focus_visible
                    menu.hideFocus()
                }
            }
        }
        */

        DHAVN_AppSettings_FocusedLoader{
            id: clariFi

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_CLARIFI
            opacity: visible ? 1 : 0

            name: "ClariFiLoader"
            focus_x: 1
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible && status != Loader.Ready )
                {
                    source = "DHAVN_AppSettings_Sound_ClariFi.qml"
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                    idCueSettings.isRightBg = clariFi.focus_visible
            }
        }
        DHAVN_AppSettings_FocusedLoader{
            id: vipSound

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_VIP
            opacity: visible ? 1 : 0

            name: "VipSoundLoader"
            focus_x: 1
            focus_y: 0

            onVisibleChanged:
            {
                if ( visible && status != Loader.Ready )
                {
                    source = "DHAVN_AppSettings_Sound_VipSound.qml"
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                    idCueSettings.isRightBg = vipSound.focus_visible
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: resetAll

            visible: rootSound.state == APP.const_APP_SETTINGS_SOUND_STATE_RESET_ALL
            opacity: visible ? 1 : 0

            name: "ResetAllLoader"

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                        source = "DHAVN_AppSettings_Sound_ResetAll.qml"
                }
            }
        }

        //ScrollBar
        DHAVN_AppSettings_Menu_ScrollBar{
            id :menuScroll
            anchors.top: parent.top
            anchors.topMargin: APP.const_APP_SETTINGS_MENU_TOP_MARGIN
            anchors.right: parent.right
        }

        Binding {
            id: scrollbarHeightRatioBinding
            target: menuScroll
            property: "heightRatio"
            value: menu.heightRatio
        }

        Binding {
            id: scrollbarYPositionBinding
            target: menuScroll
            property: "yPosition"
            value: menu.yPosition
        }

        Binding {
            id: scrollbarListCountBinding
            target: menuScroll
            property: "listCount"
            value: menu.listCount
        }

    }

    ListModel{
        id: list_model

        Component.onCompleted:
        {
            if(SettingsStorage.isNaviVariant)
            {
                list_model.append({"itemNum": APP.const_SETTINGS_SOUND_VOLUME_RATIO, "isCheckNA":false, "isChekedState":true,  "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                      name:QT_TR_NOOP("STR_SETTING_SOUND_VOL_RADIO_CONTROL"),
                                      nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_VOLUME_RATIO_CONTROL})
            }

            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_BALANCE, "isCheckNA":false, "isChekedState":true,  "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_PREV_NEXT_BALANCE"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_BALANACE})

            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_TONES, "isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_LOW_MID_HIGH"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_TONES})

	    // { 2014.02.24 DH_PE Quantum logic
            //list_model.append({"itemNum": APP.const_SETTINGS_SOUND_SURROUND, "isCheckNA":true,  "isChekedState":SettingsStorage.surround,  "isDimmed":false, "isPopupItem":false, "dbID": Settings.DB_KEY_SOUND_SURROUND,
            //                      name:QT_TR_NOOP("STR_SETTING_SOUND_SURROUND"),
            //                      nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_SURROUND})

            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_QUANTUMLOGIC, "isCheckNA":false,  "isChekedState":false,  "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_QUANTUM_LOGIC"),
                              nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_QUANTUM_LOGIC})
	    // } 2014.02.24 DH_PE
            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_CLARIFI, "isCheckNA":true,  "isChekedState":SettingsStorage.clariFi, "isDimmed":false, "isPopupItem":false, "dbID": Settings.DB_KEY_CLARIFI,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_CLARIFI"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_CLARIFI})


            if(SettingsStorage.currentRegion != 1 && SettingsStorage.currentRegion != 5 &&
                    SettingsStorage.currentRegion != 6 && SettingsStorage.currentRegion != 7)
            {
                list_model.append({"itemNum": APP.const_SETTINGS_SOUND_VIP_SOUND, "isCheckNA":true,  "isChekedState":SettingsStorage.vipSound, "isDimmed":false, "isPopupItem":false, "dbID": Settings.DB_KEY_VIP_SOUND,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_VIP"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_VIP})
            }

            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_SDVC, "isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": Settings.DB_KEY_SOUND_SPEED,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_AUTO_VOL_CONTROL"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_SPEED_DEPENDENT_VC})

            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_BEEP, "isCheckNA":true,  "isChekedState":SettingsStorage.beepSound, "isDimmed":false, "isPopupItem":false, "dbID": Settings.DB_KEY_SOUND_BEEP,
                                  name:QT_TR_NOOP("STR_SETTING_SOUND_TOUCH_BUTTON"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_BEEP})

//                    list_model.append({"isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
//                                      name:QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ")})

            list_model.append({"itemNum": APP.const_SETTINGS_SOUND_RESET_ALL, "isCheckNA":false, "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_INITIALIZE_RESET"),
                                  nameOfState: APP.const_APP_SETTINGS_SOUND_STATE_RESET_ALL})
        }
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_VOLUME_RATIO_CONTROL
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_VOLUME_RATIO) }
        },
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_BALANACE
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_BALANCE) }
        },
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_TONES
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_TONES) }
        },
	// { 2014.02.24 DH_PE Quantum logic
        //State{
        //    name: APP.const_APP_SETTINGS_SOUND_STATE_SURROUND
        //    PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_SURROUND) }
        //},

        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_QUANTUM_LOGIC
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_QUANTUMLOGIC) }
        },
	// } 2014.02.24 DH_PE
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_CLARIFI
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_CLARIFI) }
        },
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_VIP
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_VIP_SOUND) }
        },
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_SPEED_DEPENDENT_VC
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_SDVC) }
        },
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_BEEP
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_BEEP) }
        },
        State{
            name: APP.const_APP_SETTINGS_SOUND_STATE_RESET_ALL
            PropertyChanges { target: menu; selected_item: getItemIndex(APP.const_SETTINGS_SOUND_RESET_ALL) }
        }
    ]

    Connections{
        target:SettingsStorage

        onClariFiChanged:
        {
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_SOUND_CLARIFI)

            if( index != -1)
                list_model.setProperty(index,"isChekedState",SettingsStorage.clariFi)
        }
        onVipSoundChanged:
        {
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_SOUND_VIP_SOUND)

            if( index != -1)
                list_model.setProperty(index,"isChekedState",SettingsStorage.vipSound)
        }

        onAvcChanged:
        {
            //var index = -1
            //index = getItemIndex(APP.const_SETTINGS_SOUND_SDVC)

            //if( index != -1)
            //    list_model.setProperty(index,"isChekedState",SettingsStorage.avc)
        }

        onBeepSoundChanged:
        {
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_SOUND_BEEP)

            if( index != -1)
                list_model.setProperty(index,"isChekedState",SettingsStorage.beepSound)
        }

        onSurroundChanged:
        {
            var index = -1
            index = getItemIndex(APP.const_SETTINGS_SOUND_SURROUND)

            if( index != -1)
                list_model.setProperty(index,"isChekedState",SettingsStorage.surround)
        }
    }
}
