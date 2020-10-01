import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import AppEngineQMLConstants 1.0


DHAVN_AppSettings_FocusedItem{
    id: rootSoundManager
    anchors.fill:parent
    name: "RootSoundManager"
    default_x: 0
    default_y: 1
    focus_x: 0
    focus_y: 0
    property bool is_focused_BackButton: false

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SETTINGS_SOUND_TITLE"

        onFocus_visibleChanged: {
            if(focus_visible)
            {
                if (rootSoundMainLoader.status == Loader.Ready)
                {
                    rootSoundMainLoader.item.setVisualCue(false, true, false, false)
                }
            }
        }

        onJogDown:
        {
            //console.log("[QML][Sound]onJogDown:focus_visible:"+focus_visible)
            if(focus_visible)
                is_focused_BackButton = true
        }
    }

    DHAVN_AppSettings_FocusedLoader
    {
        id: rootSoundMainLoader
        focus_x: 0
        focus_y: 1

        source: "DHAVN_AppSettings_Sound_Menu.qml"

        property string nested_state: SettingsStorage.isNaviVariant ?
                                          APP.const_APP_SETTINGS_SOUND_STATE_VOLUME_RATIO_CONTROL : APP.const_APP_SETTINGS_SOUND_STATE_BALANACE
        onVisibleChanged:
        {
            if(!visible) hideFocus()
        }

        onStatusChanged:
        {
            if(status == Loader.Ready)
            {
                rootSoundMainLoader.item.init()
                rootSoundMainLoader.item.state = SettingsStorage.isNaviVariant ?
                            APP.const_APP_SETTINGS_SOUND_STATE_VOLUME_RATIO_CONTROL : APP.const_APP_SETTINGS_SOUND_STATE_BALANACE
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                titleBar.hideFocus()
        }
    }
}
