import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "Components/ResetButton"
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "DHAVN_AppSettings_Default_Values.js" as HD
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: main

    property int currentTones: 0

    Timer{
        id : highSaveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            main.saveHighTone()
        }
    }

    Timer{
        id : midSaveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            main.saveMidTone()
        }
    }

    Timer{
        id : lowSaveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            main.saveLowTone()
        }
    }

    function setTimer()
    {
        switch(currentTones)
        {
        case 0: //highTone
        {
            if(highSaveTimer.running)   highSaveTimer.restart()
            else                        highSaveTimer.start();
        }
        break;
        case 1: //midTone
        {
            if(midSaveTimer.running)    midSaveTimer.restart()
            else                        midSaveTimer.start();
        }
        break;
        case 2: //lowTone
        {
            if(lowSaveTimer.running)    lowSaveTimer.restart();
            else                        lowSaveTimer.start();
        }
        break;
        }
    }

    function saveHighTone()
    {
        SettingsStorage.highTone = Math.floor(slider_high.rScrollCurrentValue)
        //console.log("Tones:: SettingsStorage.highTone:: "+SettingsStorage.highTone)
        //SettingsStorage.SaveSetting( Math.floor(slider_high.rScrollCurrentValue),Settings.DB_KEY_SOUND_HIGHTONE ) // delete for ISV 100925
        SettingsStorage.NotifyTrebleChanged( Math.floor(slider_high.rScrollCurrentValue) + 10) // add for ISV 100925
        EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_HIGHTONE,
                                         Math.floor(slider_high.rScrollCurrentValue),
                                         "",  UIListener.getCurrentScreen())

        if(highSaveTimer.running) highSaveTimer.stop()
    }

    function saveMidTone()
    {
        SettingsStorage.midTone = Math.floor(slider_mid.rScrollCurrentValue)
        //console.log("Tones:: SettingsStorage.midTone:: "+SettingsStorage.midTone)
        //SettingsStorage.SaveSetting( Math.floor(slider_mid.rScrollCurrentValue),Settings.DB_KEY_SOUND_MIDTONE ) // delete for ISV 100925
        SettingsStorage.NotifyMidChanged( Math.floor(slider_mid.rScrollCurrentValue) + 10 ) // add for ISV 100925
        EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_MIDTONE,
                                         Math.floor(slider_mid.rScrollCurrentValue),
                                         "",  UIListener.getCurrentScreen())

        if(midSaveTimer.running) midSaveTimer.stop()
    }

    function saveLowTone()
    {
        SettingsStorage.lowTone = Math.floor(slider_low.rScrollCurrentValue)
        //console.log("Tones:: SettingsStorage.lowTone:: "+SettingsStorage.lowTone)
        //SettingsStorage.SaveSetting( Math.floor(slider_low.rScrollCurrentValue),Settings.DB_KEY_SOUND_LOWTONE ) // delete for ISV 100925
        SettingsStorage.NotifyBassChanged( Math.floor(slider_low.rScrollCurrentValue) + 10 ) // add for ISV 100925
        EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_LOWTONE,
                                         Math.floor(slider_low.rScrollCurrentValue),
                                         "",  UIListener.getCurrentScreen())

        if(lowSaveTimer.running) lowSaveTimer.stop()
    }

    function init()
    {
        slider_low.rScrollCurrentValue = SettingsStorage.lowTone
        slider_mid.rScrollCurrentValue = SettingsStorage.midTone
        slider_high.rScrollCurrentValue = SettingsStorage.highTone

        if( slider_low.rScrollCurrentValue== HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES &&
                slider_mid.rScrollCurrentValue == HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES &&
                slider_high.rScrollCurrentValue == HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES )
            resetbutton_tones.setState("inactive")
        else
            resetbutton_tones.setState("active")
    }

    function activeResetButton()
    {
        if( Math.floor(slider_low.rScrollCurrentValue)== HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES &&
                Math.floor(slider_mid.rScrollCurrentValue) == HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES &&
                Math.floor(slider_high.rScrollCurrentValue) == HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES )
        {
            resetbutton_tones.setState("inactive")
        }
        else
        {
            resetbutton_tones.setState("active")
        }
    }

    width: parent.width
    height:parent.height
    anchors.left: parent.left
    anchors.top:parent.top

    name: "TonesItem"
    default_x: 0
    default_y: 0

    focus_x: 0
    focus_y: 0

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
        anchors.leftMargin: 708

        width: 530
        height: 554

        DHAVN_AppSettings_FocusedItem{
            id: highframeArea
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.left:parent.left
            width: 572
            height: 134//111
            container_is_widget: true

            name: "HighFrameArea"
            focus_x: 0
            focus_y: 0

            Image{
                id: lineList
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -3
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: true
            }

            Image{
                id: focusBorder;
                visible:highframeArea.container_is_focused
                source: "/app/share/images/AppSettings/settings/bg_bright_f.png"
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.leftMargin: -9
                height: 136
            }

            Text{
                id: slider_high_text
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -93//-68
                anchors.left:parent.left
                anchors.leftMargin:29
                width:300

                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_HIGH")) + LocTrigger.empty
                font.pointSize: 32
                color: HM.const_COLOR_TEXT_BRIGHT_GREY
                font.family: EngineListener.getFont(false)
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootSound.setVisualCue(true, true, true, false)
                }
            }

            DHAVN_AppSettings_SI_CenterScrollBarForNA{
                id: slider_high

                property string name: "SliderHight"
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -41//-26

                anchors.left:parent.left
                anchors.leftMargin:26
                rScrollValueMax:  HM.const_APP_SETTINGS_SOUND_TONES_MAX_VALUE
                rScrollValueMin:  HM.const_APP_SETTINGS_SOUND_TONES_MIN_VALUE
                rScrollCurrentValue: SettingsStorage.highTone
                bFocused: highframeArea.focus_visible
                bScrollLocation: false
                bBgTextPng: false
                focus_id: 0

                onSwitchPressed:
                {
                    activeResetButton()

                    main.currentTones=0
                    main.setTimer()
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
        }

        DHAVN_AppSettings_FocusedItem{
            id: midframeArea

            anchors.top: highframeArea.bottom
            anchors.left:parent.left
            width: 572
            height: 134//111
            container_is_widget: true

            name: "MidToneseArea"
            focus_x: 0
            focus_y: 1

            Image{
                id: lineList1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -3
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: true
            }

            Image{
                id: focusBorder1;
                visible:midframeArea.container_is_focused
                source: "/app/share/images/AppSettings/settings/bg_bright_f.png"
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.leftMargin: -9
                height: 136
            }

            Text{
                id: midtext
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -93//-68
                anchors.left:parent.left
                anchors.leftMargin:29
                width:300
                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_MID")) + LocTrigger.empty
                font.pointSize: HM.const_APP_SETTINGS_FONT_SIZE_TEXT_32PT
                color: HM.const_COLOR_TEXT_BRIGHT_GREY
                font.family: EngineListener.getFont(false)
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootSound.setVisualCue(true, true, true, false)
                }
            }

            DHAVN_AppSettings_SI_CenterScrollBarForNA{
                id: slider_mid

                property string name: "SliderMid"

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -41//-26

                anchors.left:parent.left
                anchors.leftMargin:26

                rScrollValueMax:  HM.const_APP_SETTINGS_SOUND_TONES_MAX_VALUE
                rScrollValueMin:  HM.const_APP_SETTINGS_SOUND_TONES_MIN_VALUE
                rScrollCurrentValue: SettingsStorage.midTone
                bFocused: midframeArea.focus_visible
                bScrollLocation: false
                bBgTextPng: false
                focus_id: 1

                onSwitchPressed:
                {
                    activeResetButton()

                    main.currentTones=1
                    main.setTimer()
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
        }

        DHAVN_AppSettings_FocusedItem{
            id: lowframeArea

            anchors.top: midframeArea.bottom
            anchors.left:parent.left

            width: 572
            height: 134//111

            container_is_widget: true

            name: "LowFrameArea"
            focus_x: 0
            focus_y: 2

            Image{
                id: lineList2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -3
                source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                visible: true
            }

            Image{
                id: focusBorder2;
                visible:lowframeArea.container_is_focused
                source: "/app/share/images/AppSettings/settings/bg_bright_f.png"
                anchors.left:parent.left
                anchors.leftMargin: -9
                height: 136
            }

            Text{
                id: lowtext

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -93//-68

                anchors.left:parent.left
                anchors.leftMargin:29
                width:300

                text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_LOW")) + LocTrigger.empty
                font.pointSize: HM.const_APP_SETTINGS_FONT_SIZE_TEXT_32PT
                color: HM.const_COLOR_TEXT_BRIGHT_GREY
                font.family: EngineListener.getFont(false)
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    if (resetbutton_tones.active)
                        rootSound.setVisualCue(true, true, true, false)
                    else
                        rootSound.setVisualCue(true, false, true, false)
                }
            }

            DHAVN_AppSettings_SI_CenterScrollBarForNA{
                id: slider_low

                property string name: "SliderLow"

                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -41//-26

                anchors.left:parent.left
                anchors.leftMargin:26

                rScrollValueMax:  HM.const_APP_SETTINGS_SOUND_TONES_MAX_VALUE
                rScrollValueMin:  HM.const_APP_SETTINGS_SOUND_TONES_MIN_VALUE
                rScrollCurrentValue: SettingsStorage.lowTone
                bFocused: lowframeArea.focus_visible
                bScrollLocation: false
                bBgTextPng: false
                focus_id: 2

                onSwitchPressed:
                {
                    activeResetButton()

                    if (resetbutton_tones.active)
                        rootSound.setVisualCue(true, true, true, false)
                    else
                        rootSound.setVisualCue(true, false, true, false)

                    main.currentTones=2
                    main.setTimer()
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
        }

        DHAVN_AppSettings_ResetButton{
            id: resetbutton_tones
            anchors.top: parent.top
            anchors.topMargin: 455
            anchors.left: parent.left
            anchors.leftMargin:66

            is_focusMovable: active

            focus_x: 0
            focus_y: 3

            function reset()
            {
                if(SettingsStorage.NotifySoundToneResetChanged())
                {
                    SettingsStorage.lowTone = HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES
                    EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_LOWTONE,
                                                     HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES,
                                                     "",
                                                     UIListener.getCurrentScreen())

                    SettingsStorage.midTone = HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES
                    EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_MIDTONE,
                                                     HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES,
                                                     "",
                                                     UIListener.getCurrentScreen())

                    SettingsStorage.highTone = HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES
                    EngineListener.NotifyApplication( Settings.DB_KEY_SOUND_HIGHTONE,
                                                     HD.const_APP_SETTINGS_DEFAULT_SOUND_TONES,
                                                     "",
                                                     UIListener.getCurrentScreen())

                    slider_low.rScrollCurrentValue = SettingsStorage.lowTone
                    slider_low.leftCount = 10
                    slider_low.rightCount = 0
                    slider_mid.rScrollCurrentValue = SettingsStorage.midTone
                    slider_mid.leftCount = 10
                    slider_mid.rightCount = 0
                    slider_high.rScrollCurrentValue = SettingsStorage.highTone
                    slider_high.leftCount = 10
                    slider_high.rightCount = 0

                    resetbutton_tones.setState("inactive")
                }
            }

            onFocus_visibleChanged:
            {
                if (focus_visible)
                {
                    rootSound.setVisualCue(true, false, true, false)
                }
            }

            onResetButtonClicked:
            {
                if(resetbutton_tones.active)
                {
                    reset()
                    content_area.hideFocus()
                    parent.setFocusHandle(0, 0)
                    moveFocus(0,-3)
                    content_area.showFocus()
                }
            }

            onResetButtonReleased:
            {
                if(resetbutton_tones.active)
                {
                    reset()
                    moveFocus(0,-3)
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

        onHighToneChanged:
        {
            EngineListener.printLogMessage("onHighToneChanged----------------- " + SettingsStorage.highTone)
            //console.log("called onHighToneChanged :"+SettingsStorage.highTone)
            slider_high.rScrollCurrentValue = SettingsStorage.highTone
            activeResetButton()
        }

        onMidToneChanged:
        {
            EngineListener.printLogMessage("onMidToneChanged----------------- " + SettingsStorage.midTone)
            //console.log("called onMidToneChanged :"+SettingsStorage.midTone)
            slider_mid.rScrollCurrentValue = SettingsStorage.midTone
            activeResetButton()
        }

        onLowToneChanged:
        {
            EngineListener.printLogMessage("onLowToneChanged----------------- " + SettingsStorage.lowTone)
            //console.log("called onLowToneChanged :"+SettingsStorage.lowTone)
            slider_low.rScrollCurrentValue = SettingsStorage.lowTone
            activeResetButton()
        }

        onResetSliderGUIForNA:{
            EngineListener.printLogMessage("[Sound]onResetSliderGUIForNA -------------");

            slider_low.leftCount = 10
            slider_low.rightCount = 0

            slider_mid.leftCount = 10
            slider_mid.rightCount = 0

            slider_high.leftCount = 10
            slider_high.rightCount = 0
        }
    }
}
