import QtQuick 1.1
import "../../DHAVN_AppSettings_General.js" as HM
import "../../DHAVN_AppSettings_Resources.js" as RES
import "../.."
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: changeButton
    property bool active: false

    signal changeButtonClicked()
    signal changeButtonReleased()

    function setState(s)
    {
        switch (s)
        {
        case "active":
        {
            changeButton.active = true
        }
        break
        case "inactive":
        {
            changeButton.active = false

            if( btn_p.visible )
                btn_p.visible = false
        }
        break

        }
    }

    name: "ChangeButton"

    Image{
        id:btn_image
        source: RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_N

        MouseArea{
            anchors.fill: parent
            id: btn_image_area
            beepEnabled: false

            onPressed:
            {
                if (changeButton.active)
                {
                    btn_p.visible = true
                }
            }

            onReleased:
            {
                if (changeButton.active)
                {
                    if (btn_p.visible)
                    {
                        SettingsStorage.callAudioBeepCommand()
                        changeButtonClicked()
                    }

                    btn_p.visible = false
                }
            }

            onExited:
            {
                btn_p.visible = false
                //btn_image.source = RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_N
            }
        }
    }

    Image{
        id: btn_f
        source: RES.const_URL_IMG_SETTINGS_BUTTON_INI_L_F
        visible: changeButton.focus_visible && (!btn_p.visible)
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
            if ( changeButton.focus_visible && changeButton.active )
            {
                btn_p.visible = true
            }
        }
        break

        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            if ( changeButton.focus_visible && changeButton.active)
            {
                btn_p.visible = false
                changeButtonReleased()
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
        id: btnFormat_text
        width: 344
        height: 69
        anchors.left: btn_image.left
        anchors.leftMargin: 14
        anchors.top: btn_image.top
        anchors.topMargin: 1
        text:  qsTranslate (HM.const_APP_SETTINGS_LANGCONTEXT, "STR_SETTING_SYSTEM_JUKEBOX_FORMAT") + LocTrigger.empty
        font.pointSize: 32
        color: changeButton.active ? HM.const_COLOR_TEXT_BRIGHT_GREY : HM.const_COLOR_TEXT_DISABLE_GREY
        font.family: EngineListener.getFont(false)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    onFocus_visibleChanged:
    {
        if(!focus_visible)
        {
            if (btn_p.visible)
                btn_p.visible = false
        }
    }
}

