import QtQuick 1.1
import "../../DHAVN_AppSettings_General.js" as HM
import "../../DHAVN_AppSettings_Resources.js" as RES
import "../.."
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: btn_reset
    property bool active: true

    signal resetButtonClicked()

    function setState(s)
    {
        switch (s)
        {
        case "active":
        {
            btn_reset.active = true
            btnreset_text.color= HM.const_COLOR_TEXT_BRIGHT_GREY // BRIGHT_GREY
        }
        break
        case "inactive":
        {
            btn_reset.active = false
            btnreset_text.color= HM.const_COLOR_TEXT_DISABLE_GREY // DISABLE_GREY

            if( btn_p.visible )
                btn_p.visible = false
        }
        break

        }
    }

    name: "InitializeBalanceButton"

    Image{
        id:btn_image
        source: "/app/share/images/AppSettings/settings/btn_ini_n.png"

        MouseArea{
            anchors.fill: parent
            id: btn_image_area
            beepEnabled: false

            onPressed:
            {
                if(btn_reset.active)
                {
                    //btn_image.source= "/app/share/images/AppSettings/settings/btn_ini_p.png"
                    btn_p.visible = true
                }
            }

            onReleased:
            {
                if(btn_reset.active)
                {
                    if (btn_p.visible)
                    {
                        SettingsStorage.callAudioBeepCommand()
                        btnreset_text.color= HM.const_COLOR_TEXT_DISABLE_GREY
                        resetButtonClicked()
                    }

                    btn_p.visible = false
                }
            }

            onExited:
            {
                btn_p.visible = false
                //btn_image.source= "/app/share/images/AppSettings/settings/btn_ini_n.png"
            }
        }
    }

    Image{
        id: btn_f
        source: "/app/share/images/AppSettings/settings/btn_ini_f.png"
        visible: btn_reset.focus_visible && (!btn_p.visible)
    }

    Image{
        id: btn_p
        source: "/app/share/images/AppSettings/settings/btn_ini_p.png" //fp image (non exist)
        visible: false
    }


    onJogSelected:
    {
        switch ( status )
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
        {
            if ( btn_reset.focus_visible && btn_reset.active )
            {
                btn_p.visible = true
            }
        }
        break

        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            btn_p.visible = false
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
        anchors.left: btn_image.left
        anchors.top: btn_image.top
        anchors.horizontalCenter : btn_image.horizontalCenter
        anchors.verticalCenter : btn_image.verticalCenter

        text:  qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_RESET")) + LocTrigger.empty
        font.pointSize: 32
        color: HM.const_COLOR_TEXT_BRIGHT_GREY
        font.family: EngineListener.getFont(false)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
}
