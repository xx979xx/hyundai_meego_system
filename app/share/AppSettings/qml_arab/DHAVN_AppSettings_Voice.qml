import QtQuick 1.1
import com.settings.defines 1.0
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES


DHAVN_AppSettings_FocusedItem{
    id: rootVoiceMananger
    name: "RootVoiceMananger"
    anchors.top: parent.top
    anchors.left: parent.left
    width: 1280
    height: 627
    default_x: 0
    default_y: 1
    property bool is_focused_BackButton: false

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_VOICE_CONTROL"

        onFocus_visibleChanged: {
            if(focus_visible)
            {
                if (rootVoiceMainLoader.status == Loader.Ready)
                {
                    rootVoiceMainLoader.item.setVisualCue(false, true, false, false)
                }
            }
        }

        onJogDown:
        {
            if(focus_visible)
                is_focused_BackButton = true
        }
    }

    DHAVN_AppSettings_FocusedLoader
    {
        id: rootVoiceMainLoader
        focus_x: 0
        focus_y: 1

        source: "DHAVN_AppSettings_Voice_Menu.qml"

        property string nested_state: APP.const_APP_SETTINGS_VOICE_STATE_VOICE_RECOGNITION

        onVisibleChanged:
        {
            if(!visible) hideFocus()
        }

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootVoiceMainLoader.item.init()
                rootVoiceMainLoader.item.state = nested_state
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
    }
}
