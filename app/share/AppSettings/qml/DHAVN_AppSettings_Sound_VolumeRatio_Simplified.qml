import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/ScrollingTicker"

DHAVN_AppSettings_FocusedItem{
    id: soundVolumeRatio

    name: "Volume_Ratio_Control"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699

    default_x: 0
    default_y: 0

    function init()
    {
        checkboxitem.checked = SettingsStorage.volumeRatio
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            var ratioVal = checkboxitem.checked
            if( ratioVal == false )
                ratioVal = 0
            else
                ratioVal = 2
            SettingsStorage.volumeRatio = ratioVal
            SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_SOUND_VOLUME_RATIO )
            EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_VOLUME_RATIO, ratioVal, "", UIListener.getCurrentScreen())
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: checkboxitem
        width: 560
        height: 90//552

        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12

        focus_x: 0
        focus_y: 0

        property bool pressed: false
        property bool checked: false

        Image{
            id: line_image
            x:9; y:89
            source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
        }

        Image{
            id:checkbox_f_id
            anchors.top: line_image.top
            anchors.topMargin: -90
            anchors.left: line_image.left
            anchors.leftMargin: -9
            source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_FOCUSED
            visible: checkboxitem.focus_visible && !checkboxitem.pressed && !checkbox_p_id.visible
        }

        Image{
            id:checkbox_p_id
            anchors.top: line_image.top
            anchors.topMargin: -90
            anchors.left: line_image.left
            anchors.leftMargin: -9
            source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_PRESSED
            visible: checkboxitem.pressed
        }

        ScrollingTicker {
            id: scrollingTicker
            clip: true
            width: 443
            height: 89
            scrollingTextMargin: 120
            anchors.verticalCenter: line_image.top
            anchors.verticalCenterOffset: -45
            anchors.left: line_image.left
            anchors.leftMargin: 14
            isScrolling: checkboxitem.focus_visible && isParkingMode
            fontPointSize: 40
            fontFamily: EngineListener.getFont(false)
            text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")) + LocTrigger.empty
            fontStyle: Text.Sunken
            fontColor: HM.const_COLOR_BRIGHT_GREY
        }

        Image{
            id: checkboxImage
            anchors.top: line_image.top
            anchors.topMargin: -68
            anchors.left: line_image.left
            anchors.leftMargin: 473
            source: checkboxitem.checked ? RES.const_URL_IMG_SETTINGS_B_CHECKED_N_URL : RES.const_URL_IMG_SETTINGS_B_CHECKED_S_URL
        }

        MouseArea{
            id: mouse_area1
            //anchors.fill: checkboxitem
            enabled: EngineListener.isAccStatusOn

            x:0
            y:0
            width: 560
            height: 90

            onPressed:
            {
                checkboxitem.pressed = true
            }

            onReleased:
            {
                if(checkboxitem.pressed)
                {
                    checkboxitem.pressed = false

                    parent.hideFocus()
                    parent.setFocusHandle(0,0)
                    parent.showFocus()

                    if(SettingsStorage.volumeRatio) SettingsStorage.volumeRatio = 0
                    else SettingsStorage.volumeRatio = 2

                   if(menuSelectTimer.running)
                        menuSelectTimer.restart()
                   else
                        menuSelectTimer.start()
                }
            }

            onExited:
            {
                checkboxitem.pressed = false
            }
        }

        onJogSelected:
        {
            switch( status )
            {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                checkboxitem.pressed = true
            }
            break
            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
                if(checkboxitem.pressed)
                {
                    checkboxitem.pressed = false

                    parent.hideFocus()
                    parent.setFocusHandle(0,0)
                    parent.showFocus()                    

                    if(SettingsStorage.volumeRatio) SettingsStorage.volumeRatio = 0
                    else SettingsStorage.volumeRatio = 2

                    if(menuSelectTimer.running)
                         menuSelectTimer.restart()
                    else
                         menuSelectTimer.start()
                }
            }
            break

            case UIListenerEnum.KEY_STATUS_CANCELED:
            {
                 checkboxitem.pressed = false
            }
            break
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                rootSound.setVisualCue(true, false, true, false)
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 314
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : true
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_VOL_RATIO_DESCRIPTION")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 28//32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    Connections{
        target:SettingsStorage

        onVolumeRatioChanged:
        {            
            init()
        }
    }
}
