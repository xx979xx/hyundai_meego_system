import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.variables 1.0
import com.settings.defines 1.0
import PopUpConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootGeneralMananger

    property bool is_focused_BackButton: false

    x: 0; y: 0; width: 1280; height: 627

    name: "RootGeneralMananger"
    anchors.top: parent.top
    anchors.left: parent.left
    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 1

    function requestChangeNestedState(nestedState)
    {
        //console.log("General.qml : requestChangeNestedState() : nestedState:"+nestedState)
        rootGeneralMainLoader.nested_state = nestedState
    }

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SETTINGS_GENERAL_TITLE"

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                if(rootGeneralMainLoader.status == Loader.Ready)
                {
                    rootGeneralMainLoader.item.setVisualCue(false, true, false, false)
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
        id: rootGeneralMainLoader
        focus_x: 0
        focus_y: 1
        source: "DHAVN_AppSettings_General_Menu.qml"

        property string nested_state: APP.const_APP_SETTINGS_GENERAL_STATE_LANGUAGE

        onVisibleChanged:
        {
            if(!visible) hideFocus()
        }

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootGeneralMainLoader.item.init()
                rootGeneralMainLoader.item.state = nested_state
            }
        }

        onNested_stateChanged:
        {
            if(status == Loader.Ready)
            {
                rootGeneralMainLoader.item.state = nested_state
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
    }
}
