import QtQuick 1.1

import com.settings.variables 1.0
import com.settings.defines 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as APP

DHAVN_AppSettings_FocusedItem{
    id: rootScreenManager

    property bool _videostatus

    width: 1280
    height: 627

    name: "RootScreenManager"

    default_x: 0
    default_y: 1
    focus_x: 0
    focus_y: 0
    property bool is_focused_BackButton: false

    function changeVideoMode()
    {
        rootScreenMainLoader.nested_state = APP.const_APP_SETTINGS_SCREEN_SET_VIDEO_MODE
    }

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SETTINGS_SCREEN_TITLE"

        onFocus_visibleChanged: {
            if(focus_visible)
            {
                if (rootScreenMainLoader.status == Loader.Ready)
                {
                    rootScreenMainLoader.item.setVisualCue(false, true, false, false)
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
        id: rootScreenMainLoader
        focus_x: 0
        focus_y: 1

        source: "DHAVN_AppSettings_Screen_Menu.qml"
        property string nested_state: APP.const_APP_SETTINGS_SCREEN_PE_ILLUMINATION_DAYLIGHT //added for DH PE

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootScreenMainLoader.item.init()
                //rootScreenMainLoader.item.state = nested_state

                if(root.isVideoMode)
                {
                    rootScreenMainLoader.item.state = APP.const_APP_SETTINGS_SCREEN_SET_VIDEO_MODE
                    rootScreenMainLoader.item.updateListItem(true)
                }
                else
                {
                    rootScreenMainLoader.item.state = APP.const_APP_SETTINGS_SCREEN_PE_ILLUMINATION_DAYLIGHT //added for DH PE
                    rootScreenMainLoader.item.updateListItem(false)
                }
            }
        }

        onNested_stateChanged:
        {
            if(status == Loader.Ready)
            {
                rootScreenMainLoader.item.state = nested_state
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
    }

    Connections{
        target: EngineListener

        onSetStateLCD:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;

            rootScreenMainLoader.item.state = APP.const_APP_SETTINGS_SCREEN_PE_ILLUMINATION_DAYLIGHT; //added for DH PE
        }

        onVideoStatusChanged:
        {
            if(targetScreen == UIListener.getCurrentScreen())
            {
                if(enable)
                    rootScreenMainLoader.nested_state = APP.const_APP_SETTINGS_SCREEN_SET_VIDEO_MODE
                else
                    rootScreenMainLoader.nested_state = APP.const_APP_SETTINGS_SCREEN_PE_ILLUMINATION_DAYLIGHT //added for DH PE
            }
        }
    }
}
