import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootKeypadManager
    name: "RootKeypad"
    width: parent.width
    height: parent.height
    default_x: 0
    default_y: 1
    property bool is_focused_BackButton: false

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SETTINGS_KEYPAD_TITLE"

        onFocus_visibleChanged: {
            if(focus_visible)
            {
                if (rootKeypadMainLoader.status == Loader.Ready)
                {
                    rootKeypadMainLoader.item.setVisualCue(false, true, false, false)
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
        id: rootKeypadMainLoader

        focus_x: 0
        focus_y: 1

        source: "DHAVN_AppSettings_OnlyKeypad_Menu.qml"

        //added for NA Keyboard Setting Right Menu UI Delay Issue
        property string nested_state: APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO //APP.const_SETTINGS_CLOCK_GPS_TIME

        onVisibleChanged:
        {
            if(!visible) hideFocus()
        }

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootKeypadMainLoader.item.init()
                rootKeypadMainLoader.item.state = nested_state
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
        Connections{
            target:SettingsStorage

            onHyunDaiKeypadChanged:
            {
                console.log("kjw :: OnlyKeypad.qml :: Enter onHyunDaiKeypadChanged ")

                //rootKeypadMainLoader.source = "DHAVN_AppSettings_OnlyKeypad_Menu.qml"
            }
        }
    }
}
