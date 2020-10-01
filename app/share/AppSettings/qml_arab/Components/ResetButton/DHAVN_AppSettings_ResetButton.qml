import QtQuick 1.1
import "../../DHAVN_AppSettings_General.js" as HM
import "../../DHAVN_AppSettings_Resources.js" as RES
import "../.."
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: btn_reset
    property bool active: true

    //added for DH PE Display String Issue
    property string resetButtonStr: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_RESET")) + LocTrigger.empty

    signal resetButtonClicked()
    signal resetButtonReleased()

    function setState(s)
    {
        switch (s)
        {
        case "active":
        {
            btn_reset.active = true
        }
        break
        case "inactive":
        {
            btn_reset.active = false

            if( btn_p.visible )
                btn_p.visible = false
        }
        break

        }
    }

    name: "ResetButton"

    Image{
        id:btn_image
        source: RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_N

        MouseArea{
            id: btn_image_area
            anchors.fill: parent
            beepEnabled: false

            onPressed:
            {
                if( btn_reset.active )
                {
                    btn_p.visible = true
                    //btn_image.source = RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_P
                }
            }

            onReleased:
            {
                if( btn_reset.active )
                {
                    if (btn_p.visible)
                    {
                        SettingsStorage.callAudioBeepCommand()
                        resetButtonClicked()
                    }

                    btn_p.visible = false
                }
            }

            onExited:
            {
                btn_p.visible = false
            }
        }
    }

    Image{
        id: btn_f
        source: RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_F
        visible: btn_reset.focus_visible && (!btn_p.visible)
    }

    Image{
        id: btn_p
        source: RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_P
        visible: false
    }


    onJogSelected:
    {
        switch ( status )
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
        {
            if( btn_reset.active )
            {
                btn_p.visible = true
            }
        }
        break

        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            if( btn_reset.active )
            {
                btn_p.visible = false
                resetButtonReleased()
            }
        }
        break

        case UIListenerEnum.KEY_STATUS_CANCELED:
        {
            btn_p.visible = false
        }
        break
        }
    }

    Text{
        id: btnreset_text
        width: 344
        height: 69
        anchors.left: btn_image.left
        anchors.leftMargin: 14
        anchors.top: btn_image.top
        anchors.topMargin: 1
        //text:  qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_RESET")) + LocTrigger.empty
        text: resetButtonStr //added for DH PE Display String Issue
        font.pointSize: 32
        color: btn_reset.active ? HM.const_COLOR_TEXT_BRIGHT_GREY : HM.const_COLOR_TEXT_DISABLE_GREY
        font.family: EngineListener.getFont(false)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
}
