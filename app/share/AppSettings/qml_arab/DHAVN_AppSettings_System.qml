import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.defines 1.0
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import PopUpConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: rootSystemManager
    name: "SystemMain"

    anchors.top: parent.top
    anchors.left: parent.left
    width: 1280
    height: 627

    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 1
    property bool is_focused_BackButton: false

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SYSTEM_INFO"

        onFocus_visibleChanged: {
            if(focus_visible)
            {
                if (rootSystemMainLoader.status == Loader.Ready)
                {
                    rootSystemMainLoader.item.setVisualCue(false, true, false, false)
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
        id: rootSystemMainLoader
        focus_x: 0
        focus_y: 1

        source: "DHAVN_AppSettings_System_Menu.qml"
        property string nested_state: APP.const_APP_SETTINGS_SYSTEM_STATE_SYSTEM_INFO

        onVisibleChanged:
        {
            if(!visible) hideFocus()
        }

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootSystemMainLoader.item.init()
                rootSystemMainLoader.item.state = nested_state
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
    }
}
