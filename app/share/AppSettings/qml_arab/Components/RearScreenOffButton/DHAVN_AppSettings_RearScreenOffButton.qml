import QtQuick 1.1
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "../../DHAVN_AppSettings_General.js" as HM
import "../../DHAVN_AppSettings_Resources.js" as RES
import "../.."

DHAVN_AppSettings_FocusedItem{
    id: rearScreenButton

    signal rearOn()
    signal rearOff()

    signal clicked()
    signal jogClicked()

    Image{
        id:btn_image
        source: RES.const_URL_IMG_SETTINGS_SCREEN_REAR_N

        MouseArea{
            anchors.fill: parent
            id: btn_image_area
            beepEnabled: false

            onPressed:
            {
                //btn_image.source =  RES.const_URL_IMG_SETTINGS_SCREEN_REAR_P
                btn_p.visible = true
            }

            onReleased:
            {
                if (btn_p.visible)
                {
                    SettingsStorage.callAudioBeepCommand()
                    rearScreenButton.clicked()
                }

                btn_p.visible = false
            }

            onExited:
            {
                //btn_image.source = RES.const_URL_IMG_SETTINGS_SCREEN_REAR_N
                btn_p.visible = false
            }
        }
    }

    Image{
        id: btn_f
        source: RES.const_URL_IMG_SETTINGS_SCREEN_REAR_F
        visible: rearScreenButton.focus_visible && (!btn_p.visible)
    }

    Image{
        id: btn_p
        source: RES.const_URL_IMG_SETTINGS_SCREEN_REAR_P
        visible: false
    }

    Text{
        id: rearTurnOn
        anchors.verticalCenter: btn_image.top
        anchors.verticalCenterOffset: 34
        anchors.left: btn_image.left
        anchors.leftMargin: 12
        width: 211
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_TURN_ON_REAR")) + LocTrigger.empty
        color: HM.const_APP_SETTINGS_COLOR_TEXT_WHITE
        font.pointSize: 28
        font.family: EngineListener.getFont(false)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        visible: !SettingsStorage.LeftRearScreen
    }

    Text{
        id: rearTurnOff
        anchors.verticalCenter: btn_image.top
        anchors.verticalCenterOffset: 34
        anchors.left: btn_image.left
        anchors.leftMargin: 12
        width: 211
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_TURN_OFF_REAR")) + LocTrigger.empty
        color: HM.const_APP_SETTINGS_COLOR_TEXT_WHITE
        font.pointSize: 28
        font.family: EngineListener.getFont(false)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        visible: SettingsStorage.LeftRearScreen
    }

    onJogSelected:
    {
        switch ( status )
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
        {
            btn_p.visible = true
        }
        break

        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            btn_p.visible = false
            jogClicked()
        }
        break

        case UIListenerEnum.KEY_STATUS_CANCELED:
        {
            btn_p.visible = false
        }
        break
        }
    }

    Connections{
        target:SettingsStorage

        onLeftRearScreenChanged:  {
            if (SettingsStorage.LeftRearScreen) rearOn()
            else rearOff()
        }
    }
}

