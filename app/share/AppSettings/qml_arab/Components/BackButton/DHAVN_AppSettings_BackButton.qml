import QtQuick 1.1
import "../../DHAVN_AppSettings_General.js" as HM
import "../../DHAVN_AppSettings_Resources.js" as RES
import "../.."
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: btn_back

    signal backButtonByTouch()
    signal backButtonByJog(bool rrc)
    name: "BackButton"

    Image{
        id:btn_image
        source: "/app/share/images/AppSettings/arab/general/btn_title_back_n.png"

        MouseArea{
            id: btn_image_area
            anchors.fill: parent
            beepEnabled: false

            onPressed:
            {
                btn_p.visible = true
                //btn_image.source = "/app/share/images/AppSettings/arab/general/btn_title_back_p.png"
            }

            onReleased:
            {
                if (btn_p.visible)
                {
                    SettingsStorage.callAudioBeepCommand()
                    backButtonByTouch()
                }

                btn_p.visible = false
            }

            onExited:
            {
                btn_p.visible = false
            }
        }
    }

    Image{
        id: btn_f
        source: "/app/share/images/AppSettings/arab/general/btn_title_back_f.png"
        visible: btn_back.focus_visible && (!btn_p.visible)
    }

    Image{
        id: btn_p
        source: "/app/share/images/AppSettings/arab/general/btn_title_back_p.png"
        visible: false
    }


    onJogSelected:
    {
        switch ( status )
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
        {
            if ( btn_back.focus_visible )
            {
                btn_p.visible = true
            }
        }
        break

        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            btn_p.visible = false
            backButtonByJog(rrc)
        }
        break

        case UIListenerEnum.KEY_STATUS_CANCELED:
        {
            btn_p.visible = false
        }
        break
        }
    }
}
