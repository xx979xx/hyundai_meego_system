import QtQuick 1.1
import com.settings.defines 1.0
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES


DHAVN_AppSettings_FocusedItem{
    id: rootVoice

    anchors.top: parent.top
    anchors.left: parent.left

    width: 1280
    height: 554
    name: "VoiceMain"
    default_x: 0
    default_y: 0

    function init()
    {
        content_voice.hideFocus();
        content_voice.setFocusHandle(0,0)
        content_voice.showFocus();
    }

    function setVisualCue(up, down, left, right)
    {
        visualCue.upArrow = up
        visualCue.downArrow = down
        visualCue.leftArrow = left
        visualCue.rightArrow = right
    }

    function showAlertPopup()
    {
        switch(SettingsStorage.currentRegion)
        {
        case 0:
        {
            if(SettingsStorage.languageType != Settings.SETTINGS_LANGUAGE_KO)
            {
                EngineListener.showPopapInMainArea(Settings.SETTINGS_VR_NOT_SUPPORT_POPUP, UIListener.getCurrentScreen())
            }
            else
            {
                rootPopUpLoader.visible = false
            }

            break;
        }
        case 1:
        case 6:
        {
            if(SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_KO)
            {
                EngineListener.showPopapInMainArea(Settings.SETTINGS_VR_NOT_SUPPORT_POPUP, UIListener.getCurrentScreen())
            }
            else
            {
                rootPopUpLoader.visible = false
            }

            break;
        }
        case 4:
        {
            if(SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_KO || SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_EN_UK)
            {
                EngineListener.showPopapInMainArea(Settings.SETTINGS_VR_NOT_SUPPORT_POPUP, UIListener.getCurrentScreen())
            }
            else
            {
                rootPopUpLoader.visible = false
            }

            break;
        }
        case 5:
        {
            if(SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_KO || SettingsStorage.languageType == Settings.SETTINGS_LANGUAGE_SK)
            {
                EngineListener.showPopapInMainArea(Settings.SETTINGS_VR_NOT_SUPPORT_POPUP, UIListener.getCurrentScreen())
            }
            else
            {
                rootPopUpLoader.visible = false
            }

            break;
        }
        }
    }

    function setFocusCurrentMenu()
    {
        content_voice.__current_x = 0
        content_voice.__current_y = 0

        var index = content_voice.searchIndex( content_voice.__current_x, content_voice.__current_y)
        content_voice.__current_index = index

        content_voice.setFocus(content_voice.focus_x, content_voice.focus_y)
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_voice
        name: "content_voice"

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height
        default_x: 0
        default_y: 0
        focus_x: 0
        focus_y: 0

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                is_focused_BackButton = false
            }
        }

        // Bg Border
        DHAVN_AppSettings_Cue_Bg_Main{
            id: idCueSettings
            property bool isRightBg:false
            z:1
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: (!idCueSettings.isRightBg) && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_L_BRIGHT
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: idCueSettings.isRightBg && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_R_BRIGHT
        }

        DHAVN_AppSettings_Menu{
            id: menu

            property int region : SettingsStorage.currentRegion
            property bool tempValue

            anchors.top: parent.top
            anchors.topMargin: APP.const_APP_SETTINGS_MENU_TOP_MARGIN
            anchors.right: parent.right

            menu_model: list_model
        }

        DHAVN_AppSettings_FocusedLoader{
            id: voice_command

            name: "VoiceCommandLoader"
            focus_x: 0
            focus_y: 0

            visible: rootVoice.state == APP.const_APP_SETTINGS_VOICE_STATE_VOICE_RECOGNITION
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible && status != Loader.Ready )
                {
                    source = "DHAVN_AppSettings_Voice_VoiceRecognition.qml"
                }

                if(!visible) voice_command.hideFocus()
            }

            onStatusChanged:
            {
                if ( status == Loader.Ready )
                {
                    voice_command.item.init()
                }
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = voice_command.focus_visible
                    menu.hideFocus()
                }
            }
        }
    }

    ListModel{
        id: list_model

        Component.onCompleted:
        {
            list_model.append({"isCheckNA":false,  "isChekedState":false, "isDimmed":false, "isPopupItem":false, "dbID": 0,
                                  name:QT_TR_NOOP("STR_SETTING_VOICE_GUIDANCE")})
        }
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_VOICE_STATE_VOICE_RECOGNITION
            PropertyChanges { target: menu; selected_item: 0 }
        }
    ]

    Connections{
        target:SettingsStorage

        onLanguageTypeChanged:
        {
            if(rootVoice.visible)
            {
                rootVoice.showAlertPopup()
            }
        }
    }

    onVisibleChanged:
    {
        if(visible)
            rootVoice.showAlertPopup()
    }
}
