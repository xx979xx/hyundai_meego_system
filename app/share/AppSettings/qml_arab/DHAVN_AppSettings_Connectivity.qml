import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.variables 1.0
import com.settings.defines 1.0
import PopUpConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootConnectivityMananger

    property bool is_focused_BackButton: false

    property int currentTargetScreen: EngineListener.getCureentTargetScreen() //added for ITS 248636 Rear Seat Control UI Issue

    //x: 0; y: 0;
    anchors.top: parent.top
    anchors.left: parent.left
    width: 1280; height: 554

    name: "RootConnectivityMananger"
    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 1

    function requestChangeNestedState(nestedState)
    {
        //console.log("Connectivity.qml : requestChangeNestedState() : nestedState:"+nestedState)
        rootConnectivityMainLoader.nested_state = nestedState
    }

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SETTINGS_CONNECTIVITY_TITLE"

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                if(rootConnectivityMainLoader.status == Loader.Ready)
                {
                    rootConnectivityMainLoader.item.setVisualCue(false, true, false, false)
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
        id: rootConnectivityMainLoader
        focus_x: 0
        focus_y: 1
        source: "DHAVN_AppSettings_Connectivity_Menu.qml"

        property string nested_state: APP.const_APP_SETTINGS_CONNECTIVITY_STATE_ANDRIOID

        onVisibleChanged:
        {
            if(!visible) hideFocus()
        }

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootConnectivityMainLoader.item.init()
                rootConnectivityMainLoader.item.state = nested_state
            }
        }

        onNested_stateChanged:
        {
            if(status == Loader.Ready)
            {
                rootConnectivityMainLoader.item.state = nested_state
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
    }
}

