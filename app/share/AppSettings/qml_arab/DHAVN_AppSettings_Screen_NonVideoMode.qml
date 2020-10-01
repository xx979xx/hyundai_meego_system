import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "Components/ResetButton"
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/ScrollingTicker"
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: nonVideoModeMain
    property int currentOption: 0
    property int const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS: 10
    width: 530
    height: 554

    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 20

    name: "TonesItem"
    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    function init()
    {
        slider_low.rScrollCurrentValue = SettingsStorage.frontScreenBrightness
        slider_mid.rScrollCurrentValue = SettingsStorage.rearScreenBrightness

        activeResetButton()
    }

    function activeResetButton()
    {
        if( slider_low.rScrollCurrentValue== nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS &&
                slider_mid.rScrollCurrentValue == nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS )
            resetbutton.setState("inactive")
        else
            resetbutton.setState("active")
    }

    function setTimer()
    {
        switch(currentOption)
        {
        case 0: //frontScreen Brightness
        {
            if(frontScreenSaveTimer.running)    frontScreenSaveTimer.restart()
            else                                frontScreenSaveTimer.start();
        }
        break;
        case 1: //rearScreen Brightness
        {
            if(rearScreenSaveTimer.running)     rearScreenSaveTimer.restart()
            else                                rearScreenSaveTimer.start();
        }
        break;
        }
    }

    function saveFrontBrightnessDB()
    {
        SettingsStorage.frontScreenBrightness = Math.floor(slider_low.rScrollCurrentValue)
        //SettingsStorage.SaveSetting( Math.floor(slider_low.rScrollCurrentValue),Settings.DB_KEY_FRONT_SCREENBRIGHTNESS ) // delete for ISV 100925
        EngineListener.NotifyDisplayBrightnessChange(1, Math.floor(slider_low.rScrollCurrentValue))
        EngineListener.NotifyApplication( Settings.DB_KEY_FRONT_SCREENBRIGHTNESS,
                                         Math.floor(slider_low.rScrollCurrentValue),
                                         "",   UIListener.getCurrentScreen())
        EngineListener.NotifyFrontScreenBrightness(Math.floor(slider_low.rScrollCurrentValue))
    }

    function saveRearBrightnessDB()
    {
        SettingsStorage.rearScreenBrightness = Math.floor(slider_mid.rScrollCurrentValue)
        //SettingsStorage.SaveSetting( Math.floor(slider_mid.rScrollCurrentValue),Settings.DB_KEY_REAR_SCREENBRIGHTNESS ) // delete for ISV 100925
        EngineListener.NotifyDisplayBrightnessChange(0, Math.floor(slider_mid.rScrollCurrentValue))
        EngineListener.NotifyApplication( Settings.DB_KEY_REAR_SCREENBRIGHTNESS,
                                         Math.floor(slider_mid.rScrollCurrentValue),
                                         "",   UIListener.getCurrentScreen())

        EngineListener.NotifyRearScreenBrightness(Math.floor(slider_mid.rScrollCurrentValue))
    }


    Timer{
        id : frontScreenSaveTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: nonVideoModeMain.saveFrontBrightnessDB()
    }

    Timer{
        id : rearScreenSaveTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: nonVideoModeMain.saveRearBrightnessDB()
    }

    DHAVN_AppSettings_FocusedItem{
        id: tonesframeArea
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.left:parent.left
        width: 572
        height: 178

        container_is_widget: true

        name: "TonesFrameArea"
        focus_x: 0
        focus_y: 0

        Image{
            id: lineList
            anchors.left: parent.left
            anchors.leftMargin: 59
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -4
            source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
            visible: true
        }

        Image{
            id: focusBorder;
            visible:tonesframeArea.container_is_focused
            source: "/app/share/images/AppSettings/settings/bg_bright_f.png"
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.leftMargin: -6
        }

        ScrollingTicker {
            id: lowtext
            height:parent.height
            width: 465
            scrollingTextMargin: 120
            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: -117
            anchors.right: lineList.right
            anchors.rightMargin: 29
            isScrolling: tonesframeArea.container_is_focused && isParkingMode
            fontPointSize: 32
            clip: true
            fontFamily: EngineListener.getFont(false)
            text: SettingsStorage.rearMonitor ?
                      qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_LCD_FRONT")) + LocTrigger.empty
                    : qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_LCD_BRIGHTNESS")) + LocTrigger.empty
            fontColor: HM.const_COLOR_TEXT_BRIGHT_GREY
        }

        DHAVN_AppSettings_SI_ModScrollBar{
            id: slider_low
            property string name: "SliderLow"
            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: -55

            anchors.left:parent.left
            anchors.leftMargin:83
            rScrollValueMax:  HM.const_APP_SETTINGS_SCREEN_BRIGHTNESS_MAX_VALUE
            rScrollValueMin:  HM.const_APP_SETTINGS_SCREEN_BRIGHTNESS_MIN_VALUE
            rScrollCurrentValue: SettingsStorage.frontScreenBrightness
            bFocused: tonesframeArea.focus_visible
            bScrollLocation: false
            bBgTextPng: false
            focus_id: 0

            onSwitchPressed:
            {
                activeResetButton()

                if(!SettingsStorage.rearMonitor)
                {
                    if(resetbutton.active)
                        rootScreen.setVisualCue(true, true, false, true)
                    else
                        rootScreen.setVisualCue(true, false, false, true)
                }

                nonVideoModeMain.currentOption = 0
                setTimer()
            }

            onTouch:
            {
                nonVideoModeMain.hideFocus()
                parent.setFocusHandle(0, 0)
                nonVideoModeMain.showFocus()
            }
        }



        onWidgetJogPressed:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if(SettingsStorage.rearMonitor)
                    moveFocus(0,1)
            }
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
            {
                if(SettingsStorage.rearMonitor)
                {
                    rootScreen.setVisualCue(true, true, false, true)
                }
                else
                {
                    if(resetbutton.active)
                        rootScreen.setVisualCue(true, true, false, true)
                    else
                        rootScreen.setVisualCue(true, false, false, true)
                }
            }
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: midframeArea

        anchors.top: tonesframeArea.bottom
        anchors.left:parent.left
        width: 572
        height: 178
        container_is_widget: true
        visible: SettingsStorage.rearMonitor
        is_focusMovable: SettingsStorage.rearMonitor
        name: "midToneseArea"
        focus_x: SettingsStorage.rearMonitor ? 0 : -1
        focus_y: SettingsStorage.rearMonitor ? 1 : -1

        //default_x: 0
        //default_y: 0

        Image{
            id: lineList1
            anchors.left: parent.left
            anchors.leftMargin: 59
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -4
            source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
            visible: true
        }

        Image{
            id: focusBorder2;
            visible:midframeArea.container_is_focused
            source: "/app/share/images/AppSettings/settings/bg_bright_f.png"
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.leftMargin: -6
        }

        ScrollingTicker {
            id: midtext
            height:parent.height
            width: 465
            scrollingTextMargin: 120
            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: -117
            anchors.right: lineList1.right
            anchors.rightMargin: 29
            isScrolling: midframeArea.container_is_focused && isParkingMode
            fontPointSize: HM.const_APP_SETTINGS_FONT_SIZE_TEXT_32PT
            clip: true
            fontFamily: EngineListener.getFont(false)
            text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_LCD_BACK")) + LocTrigger.empty
            fontColor: HM.const_COLOR_TEXT_BRIGHT_GREY
        }

        DHAVN_AppSettings_SI_ModScrollBar{
            id: slider_mid

            property string name: "SliderMid"

            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: -55

            anchors.left:parent.left
            anchors.leftMargin:83

            rScrollValueMax:  HM.const_APP_SETTINGS_SCREEN_BRIGHTNESS_MAX_VALUE
            rScrollValueMin:  HM.const_APP_SETTINGS_SCREEN_BRIGHTNESS_MIN_VALUE
            rScrollCurrentValue: SettingsStorage.rearScreenBrightness
            bFocused: midframeArea.focus_visible
            bScrollLocation: false
            bBgTextPng: false
            focus_id: 1

            onSwitchPressed:
            {
                activeResetButton()

                if(resetbutton.active)
                    rootScreen.setVisualCue(true, true, false, true)
                else
                    rootScreen.setVisualCue(true, false, false, true)

                nonVideoModeMain.currentOption = 1
                setTimer()
            }

            onTouch:
            {
                nonVideoModeMain.hideFocus()
                parent.setFocusHandle(0, 0)
                nonVideoModeMain.showFocus()
            }
        }



        onWidgetJogPressed:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if(SettingsStorage.rearMonitor)
                    moveFocus(0,-1)
            }
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
            {
                if(resetbutton.active)
                    rootScreen.setVisualCue(true, true, false, true)
                else
                    rootScreen.setVisualCue(true, false, false, true)
            }
        }
    }

    DHAVN_AppSettings_ResetButton{
        id: resetbutton

        anchors.top: parent.top
        anchors.topMargin: 455
        anchors.left: parent.left
        anchors.leftMargin:114

        is_focusMovable: active

        focus_x: 0
        focus_y: SettingsStorage.rearMonitor ? 2 : 1

        function reset()
        {
            SettingsStorage.frontScreenBrightness = nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS
            SettingsStorage.SaveSetting( nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS ,Settings.DB_KEY_FRONT_SCREENBRIGHTNESS )
            EngineListener.NotifyApplication( Settings.DB_KEY_FRONT_SCREENBRIGHTNESS,
                                             nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS,
                                             "",   UIListener.getCurrentScreen())
            EngineListener.NotifyDisplayBrightnessChange(1, nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS)

            SettingsStorage.rearScreenBrightness = nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS
            SettingsStorage.SaveSetting( nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS ,Settings.DB_KEY_REAR_SCREENBRIGHTNESS )
            EngineListener.NotifyApplication( Settings.DB_KEY_REAR_SCREENBRIGHTNESS,
                                             nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS,
                                             "",   UIListener.getCurrentScreen())
            EngineListener.NotifyDisplayBrightnessChange(0, nonVideoModeMain.const_APP_SETTINGS_DEFAULT_IMAGE_BRIGHTNESS)

            slider_low.rScrollCurrentValue = SettingsStorage.frontScreenBrightness
            slider_mid.rScrollCurrentValue = SettingsStorage.rearScreenBrightness

            SettingsStorage.SendVideoDefaultSetMost( Settings.SETTINGS_VDS_S_LCD_BRIGHTNESS )

            resetbutton.setState("inactive")
        }

        onResetButtonClicked:
        {
            reset()
            nonVideoModeMain.hideFocus()
            parent.setFocusHandle(0, 0)
            if(SettingsStorage.rearMonitor)
                moveFocus(0,-2)
            else
                moveFocus(0,-1)
            nonVideoModeMain.showFocus()
        }

        onResetButtonReleased:
        {
            if(resetbutton.active)
            {
                reset()
                if(SettingsStorage.rearMonitor)
                    moveFocus(0,-2)
                else
                    moveFocus(0,-1)
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
                if(SettingsStorage.rearMonitor)
                    moveFocus(0,-2)
                else
                    moveFocus(0,-1)
            }
        }
    }


    Connections{
        target: SettingsStorage

        onFrontScreenBrightnessChanged:
        {
            //console.log("called onFrontScreenBrightnessChanged :"+SettingsStorage.frontScreenBrightness)
            slider_low.rScrollCurrentValue = SettingsStorage.frontScreenBrightness
            activeResetButton()
        }

        onRearScreenBrightnessChanged:
        {
            //console.log("called onRearScreenBrightnessChanged :"+SettingsStorage.rearScreenBrightness)
            slider_mid.rScrollCurrentValue = SettingsStorage.rearScreenBrightness
            activeResetButton()
        }
    }
}
