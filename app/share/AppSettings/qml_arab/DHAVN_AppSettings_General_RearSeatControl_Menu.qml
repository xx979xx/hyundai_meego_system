import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as HM
import "DHAVN_AppSettings_Resources.js" as RES
import "Components/RearScreenOffButton"

DHAVN_AppSettings_FocusedItem {
    id: rearSeatControlMain

    width: 593
    height: 720-166
    anchors.top: parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 46

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    DHAVN_AppSettings_FocusedLoader{
        id: displayOffLoader

        focus_x: 0
        focus_y: 0
        source: "DHAVN_AppSettings_General_DisplayOff.qml"

        focus_visible: item != null ? item.focus_visible : false

        onFocus_visibleChanged:
        {
            if(focus_visible)
                rearSeatItem.hideFocus()
        }

    }

    DHAVN_AppSettings_FocusedItem{
        id: rearSeatItem
        width: 593
        height: 187
        anchors.top: parent.top
        anchors.topMargin: 365 //367
        anchors.left: parent.left

        focus_x: 0
        focus_y: 1

        is_focusMovable: EngineListener.isAccStatusOnf
        visible: SettingsStorage.rearRRCVariant

        property bool pressed: false

        Image{
            id: line_id
            anchors.top:parent.bottom
            anchors.topMargin: -185
            anchors.left:parent.left
            anchors.leftMargin: 33
            source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
        }

        Image{
            id: focusImage
            source: RES.const_URL_IMG_SETTINGS_REAR_SEAT_LOCK_FOCUSED
            visible: rearSeatItem.focus_visible && !rearSeatItem.pressed
        }

        Image{
            id: pressImage
            source: RES.const_URL_IMG_SETTINGS_REAR_SEAT_LOCK_PRESSED
            visible: rearSeatItem.pressed
        }

        Text{
            id: lockRearSeatTitleText
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 33
            anchors.left:checkButton.right
            anchors.leftMargin: 15
            width: 477
            horizontalAlignment: Text.AlignRight

            text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_LOCK_REAR_MONITOR_AND_FUNC")) + LocTrigger.empty
            color: EngineListener.isAccStatusOn ? HM.const_COLOR_TEXT_BRIGHT_GREY : HM.const_COLOR_TEXT_DISABLE_GREY
            font.family: EngineListener.getFont(false)
            font.pointSize: 30
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        Text{
            id: lockRearSeatInfoText
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 114
            anchors.left:checkButton.right
            anchors.leftMargin: 15
            width: 477
            horizontalAlignment: Text.AlignRight

            text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_REAR_LOCK_INFO")) + LocTrigger.empty
            color: EngineListener.isAccStatusOn ? HM.const_COLOR_TEXT_DIMMED_GREY : HM.const_COLOR_TEXT_DISABLE_GREY
            font.family: EngineListener.getFont(false)
            font.pointSize: (lineCount > 3) ? 22:24
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            lineHeightMode: (lineCount > 1) ? Text.FixedHeight : Text.ProportionalHeight
            lineHeight: (lineHeightMode == Text.FixedHeight) ? ((lineCount > 3) ? 28:30) : 1
        }

        Image{
            id: checkButton;
            source: (EngineListener.isAccStatusOn)? ((SettingsStorage.rearLockScreen) ? RES.const_URL_IMG_SETTINGS_B_CHECKED_S_URL : RES.const_URL_IMG_SETTINGS_B_CHECKED_N_URL)
                                                  : RES.const_URL_IMG_SETTINGS_B_CHECKED_D_URL
            anchors.top: parent.top
            anchors.topMargin: (EngineListener.isAccStatusOn)? 89:91
            anchors.left:parent.left
            anchors.leftMargin: (EngineListener.isAccStatusOn)? 4:5
        }

        MouseArea{
            id: mouse_area1
            anchors.fill: parent
            enabled: EngineListener.isAccStatusOn

            onPressed:
            {
                rearSeatItem.pressed = true
            }

            onReleased:
            {
                if(rearSeatItem.pressed)
                {
                    rearSeatItem.pressed = false

                    rearSeatControlMain.hideFocus()
                    rearSeatControlMain.setFocusHandle(0,1)
                    rearSeatControlMain.showFocus()

                    var rearLockValue = SettingsStorage.rearLockScreen

                    if(rearLockValue) rearLockValue = false;
                    else rearLockValue = true;

                    SettingsStorage.rearLockScreen = rearLockValue

                    SettingsStorage.SaveSetting( rearLockValue, Settings.DB_KEY_LOCKREARMONITOR_FUNCTION )
                    EngineListener.NotifyApplication(Settings.DB_KEY_LOCKREARMONITOR_FUNCTION,
                                                     rearLockValue, "", UIListener.getCurrentScreen())
                }
            }

            onExited:
            {
                rearSeatItem.pressed = false
            }
        }

        onJogSelected:
        {
            if(EngineListener.isAccStatusOn)
            {
                if(EngineListener.dcSwapped)
                {
                    if(UIListener.getCurrentScreen() == HM.const_SETTINGS_FRONT_SCREEN)
                    {
                        if(SettingsStorage.rearLockScreen)
                            return
                    }
                }
                else
                {
                    if(UIListener.getCurrentScreen() == HM.const_SETTINGS_REAR_SCREEN)
                    {
                        if(SettingsStorage.rearLockScreen)
                            return
                    }
                }

                switch( status )
                {
                case UIListenerEnum.KEY_STATUS_PRESSED:
                {
                    rearSeatItem.pressed = true
                }
                break
                case UIListenerEnum.KEY_STATUS_RELEASED:
                {
                    if(rearSeatItem.pressed)
                    {
                        rearSeatItem.pressed = false

                        var rearLockValue = SettingsStorage.rearLockScreen

                        if(rearLockValue) rearLockValue = false;
                        else rearLockValue = true;

                        SettingsStorage.rearLockScreen = rearLockValue

                        SettingsStorage.SaveSetting( rearLockValue, Settings.DB_KEY_LOCKREARMONITOR_FUNCTION )
                        EngineListener.NotifyApplication(Settings.DB_KEY_LOCKREARMONITOR_FUNCTION,
                                                         rearLockValue, "", UIListener.getCurrentScreen())
                    }
                }
                break

                case UIListenerEnum.KEY_STATUS_CANCELED:
                {
                    rearSeatItem.pressed = false
                }
                break
                }
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                rootGeneral.setVisualCue(true, false, false, true)
        }
    }
}
