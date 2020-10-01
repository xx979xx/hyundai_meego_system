import QtQuick 1.1
import AppEngineQMLConstants 1.0
import com.settings.variables 1.0
import "Components/ResetButton"
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "DHAVN_AppSettings_Default_Values.js" as HD
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: main

    property int currentOption: 0

    function init()
    {
        slider_low.rScrollCurrentValue = SettingsStorage.brightness
        slider_mid.rScrollCurrentValue = SettingsStorage.saturation
        slider_higher.rScrollCurrentValue = SettingsStorage.contrast

        activeResetButton()
    }

    function activeResetButton()
    {
        if( Math.floor(slider_low.rScrollCurrentValue)== HD.const_APP_SETTINGS_DEFAULT_VIDEO_BRIGHTNESS &&
                Math.floor(slider_mid.rScrollCurrentValue) == HD.const_APP_SETTINGS_DEFAULT_VIDEO_SATURATION &&
                Math.floor(slider_higher.rScrollCurrentValue) == HD.const_APP_SETTINGS_DEFAULT_VIDEO_CONTRAST)
            resetbutton_videoimage.setState("inactive")
        else
            resetbutton_videoimage.setState("active")
    }

    Timer{
        id : brightnessSaveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            main.saveBrightnessDB()
        }
    }

    Timer{
        id : contrastSaveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            main.saveContrastDB()
        }
    }

    Timer{
        id : saturationSaveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            main.saveSaturationDB()
        }
    }

    function setTimer()
    {
        switch(currentOption)
        {
        case 0: //brightness
        {
            if(brightnessSaveTimer.running)     brightnessSaveTimer.restart()
            else                                brightnessSaveTimer.start();
        }
        break;
        case 1: //contrast
        {
            if(contrastSaveTimer.running)       contrastSaveTimer.restart()
            else                                contrastSaveTimer.start();
        }
        break;
        case 2: //saturation
        {
            if(saturationSaveTimer.running)     saturationSaveTimer.restart();
            else                                saturationSaveTimer.start();
        }
        break;
        }
    }

    function saveBrightnessDB()
    {
        SettingsStorage.brightness = Math.floor(slider_low.rScrollCurrentValue)

        // NotifyApplication : Needs App_ID ( APP_AVP, APP_DMB )
        EngineListener.NotifyApplication( Settings.DB_KEY_VIDEO_BRIGHTNESS,
                                         Math.floor(slider_low.rScrollCurrentValue),
                                         "",  UIListener.getCurrentScreen())

        if(brightnessSaveTimer.running) brightnessSaveTimer.stop()
    }

    function saveContrastDB()
    {
        SettingsStorage.contrast = Math.floor(slider_higher.rScrollCurrentValue)

        // NotifyApplication : Needs App_ID ( APP_AVP, APP_DMB )
        EngineListener.NotifyApplication( Settings.DB_KEY_VIDEO_CONTRAST,
                                         Math.floor(slider_higher.rScrollCurrentValue),
                                         "",  UIListener.getCurrentScreen())

        if(contrastSaveTimer.running) contrastSaveTimer.stop()
    }

    function saveSaturationDB()
    {
        SettingsStorage.saturation = Math.floor(slider_mid.rScrollCurrentValue)

        // NotifyApplication : Needs App_ID ( APP_AVP, APP_DMB )
        EngineListener.NotifyApplication( Settings.DB_KEY_VIDEO_SATURATION,
                                         Math.floor(slider_mid.rScrollCurrentValue),
                                         "",  UIListener.getCurrentScreen())

        if(saturationSaveTimer.running) saturationSaveTimer.stop()
    }

    anchors.top:parent.top
    anchors.left: parent.left

    name: "TonesItem"
    default_x: 0
    default_y: 0

    DHAVN_AppSettings_FocusedItem{
        id: content_area

        name: "TonesContent"
        focus_x: 0
        focus_y: 0
        default_x: 0
        default_y: 0

        anchors.top:parent.top
        anchors.topMargin: 73
        anchors.left: parent.left
        anchors.leftMargin: 20

        width: HM.const_APP_SETTINGS_B_STANDART_SIMPLE_MENU_SCREEN_CONTENTAREA_WIDTH
        height: HM.const_APP_SETTINGS_SOUND_CONTENTAREA_HEIGHT

        // tonesframeArea 밝기
        DHAVN_AppSettings_FocusedItem{
            id: tonesframeArea
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.left:parent.left
            width: 572
            height: 111
            container_is_widget: true

            name: "TonesFrameArea"
            focus_x: 0
            focus_y: 0
            default_x: 0
            default_y: 0

            Image{
                id: lineList
                anchors.left: parent.left
                anchors.leftMargin: 59
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -3
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: true
            }

            Image{
                id: focusBorder;
                visible:tonesframeArea.container_is_focused
                source: RES.const_URL_IMG_SETTINGS_SETTING_SLIDER_FOCUSED
                anchors.top:parent.top

                anchors.left: parent.left
                anchors.leftMargin: -6
            }

            Text{
                id: lowtext
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -68
                anchors.right: lineList.right
                anchors.rightMargin: 29
                width:300
                style: Text.Outline
                styleColor: "black"
                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_VIDEO_IMAGE_BRIGHTNESS")) + LocTrigger.empty
                font.pointSize: 32
                color: HM.const_COLOR_TEXT_BRIGHT_GREY
                font.family: EngineListener.getFont(false)
            }

            DHAVN_AppSettings_SI_ModScrollBarFromCenter{
                id: slider_low

                property string name: "SliderLow"

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -26

                anchors.left:parent.left
                anchors.leftMargin:83

                rScrollValueMax:  HM.const_APP_SETTINGS_VIDEO_IMAGE_MAX_VALUE
                rScrollValueMin:  HM.const_APP_SETTINGS_VIDEO_IMAGE_MIN_VALUE
                rScrollCurrentValue: SettingsStorage.brightness
                bFocused: tonesframeArea.focus_visible
                bScrollLocation: false
                bBgTextPng: false
                focus_id: 0

                onSwitchPressed:
                {
                    activeResetButton()

                    main.currentOption = 0
                    setTimer()
                }

                onTouch:
                {
                    content_area.hideFocus()
                    parent.setFocusHandle(0, 0)
                    content_area.showFocus()
                }
            }



            onWidgetJogPressed:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    moveFocus(0,1)
                }
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootScreen.setVisualCue(true, true, false, true)
                }
            }
        }

        // forframeAreaa 명암
        DHAVN_AppSettings_FocusedItem{
            id: forframeAreaa
            anchors.top: tonesframeArea.bottom
            anchors.left:parent.left
            width: 572
            height: 111
            container_is_widget: true

            name: "ForFrameArea"
            focus_x: 0
            focus_y: 1
            default_x: 0
            default_y: 0

            Image{
                id: lineList3
                anchors.left: parent.left
                anchors.leftMargin: 59
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -3
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: true
            }

            Image{
                id: focusBorder3;
                visible:forframeAreaa.container_is_focused
                source: RES.const_URL_IMG_SETTINGS_SETTING_SLIDER_FOCUSED
                anchors.left:parent.left
                anchors.leftMargin: -6
            }

            Text{
                id: fortext
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -68
                anchors.right: lineList3.right
                anchors.rightMargin: 29
                width:300
                style: Text.Outline
                styleColor: "black"
                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_VIDEO_IMAGE_DARKNESS")) + LocTrigger.empty
                font.pointSize: HM.const_APP_SETTINGS_FONT_SIZE_TEXT_32PT
                color: HM.const_COLOR_TEXT_BRIGHT_GREY
                font.family: EngineListener.getFont(false)
            }

            DHAVN_AppSettings_SI_ModScrollBarFromCenter{
                id: slider_higher

                property string name: "SliderHight"

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -26

                anchors.left:parent.left
                anchors.leftMargin:83

                rScrollValueMax: HM.const_APP_SETTINGS_VIDEO_IMAGE_MAX_VALUE
                rScrollValueMin: HM.const_APP_SETTINGS_VIDEO_IMAGE_MIN_VALUE
                rScrollCurrentValue: SettingsStorage.contrast
                bFocused: forframeAreaa.focus_visible
                bScrollLocation: false
                bBgTextPng: false
                focus_id: 1

                onSwitchPressed:
                {
                    activeResetButton()

                    main.currentOption = 1
                    setTimer()
                }

                onTouch:
                {
                    content_area.hideFocus()
                    parent.setFocusHandle(0, 0)
                    content_area.showFocus()
                }
            }



            onWidgetJogPressed:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    moveFocus(0,1)
                }
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootScreen.setVisualCue(true, true, false, true)
                }
            }
        }

        // midframeArea 채도
        DHAVN_AppSettings_FocusedItem{
            id: midframeArea
            anchors.top: forframeAreaa.bottom
            anchors.left:parent.left

            width: 572
            height: 111

            container_is_widget: true

            name: "midToneseArea"
            focus_x: 0
            focus_y: 2
            default_x: 0
            default_y: 0

            Image{
                id: lineList1
                anchors.left: parent.left
                anchors.leftMargin: 59
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -3
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: true
            }

            Image{
                id: focusBorder1;
                visible:midframeArea.container_is_focused
                source: RES.const_URL_IMG_SETTINGS_SETTING_SLIDER_FOCUSED
                anchors.left:parent.left
                anchors.leftMargin: -6
            }

            Text{
                id: midtext

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -68
                anchors.right: lineList1.right
                anchors.rightMargin: 29
                width:300
                style: Text.Outline
                styleColor: "black"
                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_VIDEO_IMAGE_SATURATION")) + LocTrigger.empty
                font.pointSize: HM.const_APP_SETTINGS_FONT_SIZE_TEXT_32PT
                color: HM.const_COLOR_TEXT_BRIGHT_GREY
                font.family: EngineListener.getFont(false)
            }

            DHAVN_AppSettings_SI_ModScrollBarFromCenter{
                id: slider_mid

                property string name: "SliderMid"

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -26

                anchors.left:parent.left
                anchors.leftMargin:83

                rScrollValueMax:  HM.const_APP_SETTINGS_VIDEO_IMAGE_MAX_VALUE
                rScrollValueMin:  HM.const_APP_SETTINGS_VIDEO_IMAGE_MIN_VALUE
                rScrollCurrentValue: SettingsStorage.saturation
                bFocused: midframeArea.focus_visible
                bScrollLocation: false
                bBgTextPng: false
                focus_id: 2

                onSwitchPressed:
                {
                    activeResetButton()

                    if(resetbutton_videoimage.active)
                        rootScreen.setVisualCue(true, true, false, true)
                    else
                        rootScreen.setVisualCue(true, false, false, true)

                    main.currentOption = 2
                    setTimer()
                }

                onTouch:
                {
                    content_area.hideFocus()
                    parent.setFocusHandle(0, 0)
                    content_area.showFocus()
                }
            }

            onWidgetJogPressed:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    moveFocus(0,-2)
                }
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    if(resetbutton_videoimage.active)
                        rootScreen.setVisualCue(true, true, false, true)
                    else
                        rootScreen.setVisualCue(true, false, false, true)
                }
            }
        }

        DHAVN_AppSettings_ResetButton{
            id: resetbutton_videoimage
            anchors.top: parent.top
            anchors.topMargin: 455 // 621 - 166- 6
            anchors.left: parent.left
            anchors.leftMargin:114

            is_focusMovable: active

            focus_x: 0
            focus_y: 3

            function reset()
            {
                SettingsStorage.brightness = HD.const_APP_SETTINGS_DEFAULT_VIDEO_BRIGHTNESS
                SettingsStorage.saturation = HD.const_APP_SETTINGS_DEFAULT_VIDEO_SATURATION
                SettingsStorage.contrast = HD.const_APP_SETTINGS_DEFAULT_VIDEO_CONTRAST

                slider_low.rScrollCurrentValue = SettingsStorage.brightness
                slider_mid.rScrollCurrentValue = SettingsStorage.saturation
                slider_higher.rScrollCurrentValue = SettingsStorage.contrast

                resetNotifyApplication()
                resetbutton_videoimage.setState("inactive")
            }

            function resetNotifyApplication()
            {
                // Notify
                EngineListener.NotifyApplication( Settings.DB_KEY_VIDEO_BRIGHTNESS, 0, "",  UIListener.getCurrentScreen())
                EngineListener.NotifyApplication( Settings.DB_KEY_VIDEO_CONTRAST, 0, "",  UIListener.getCurrentScreen())
                EngineListener.NotifyApplication( Settings.DB_KEY_VIDEO_SATURATION, 0, "",  UIListener.getCurrentScreen())

                //console.log("VideoImage : called resetNotifyApplication!!")
            }

            onResetButtonClicked:
            {
                reset()
                content_area.hideFocus()
                parent.setFocusHandle(0, 0)
                moveFocus(0,-3)
                content_area.showFocus()
            }

            onResetButtonReleased:
            {
                if(resetbutton_videoimage.active)
                {
                    reset()
                    moveFocus( 0, -3)
                }
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootScreen.setVisualCue(true, false, false, true)
                }
            }

            onActiveChanged:
            {
                if(!active)
                {
                    moveFocus( 0, -3)
                }
            }
        }
    }

    Connections{
        target:SettingsStorage

        onBrightnessChanged:
        {
            //console.log("called onBrightnessChanged :"+SettingsStorage.brightness)
            slider_low.rScrollCurrentValue = SettingsStorage.brightness
            activeResetButton()
        }

        onContrastChanged:
        {
            //console.log("called onContrastChanged :"+SettingsStorage.contrast)
            slider_higher.rScrollCurrentValue = SettingsStorage.contrast
            activeResetButton()
        }

        onSaturationChanged:
        {
            //console.log("called onSaturationChanged :"+SettingsStorage.saturation)
            slider_mid.rScrollCurrentValue = SettingsStorage.saturation
            activeResetButton()
        }
    }
}
