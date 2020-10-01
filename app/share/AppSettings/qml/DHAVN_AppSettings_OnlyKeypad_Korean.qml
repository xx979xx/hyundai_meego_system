import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: soundVolumeRatio

    state: ""
    name: "Volume_Ratio_Control"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699

    default_x: 0
    default_y: 0

    signal updateCurrentType(int type)
    is_focusMovable: true

    function init()
    {
        console.log("kjw :: init()")
        console.log("kjw :: init() :: SettingsStorage.koreanKeypad : ", SettingsStorage.koreanKeypad)
        switch(SettingsStorage.koreanKeypad)
        {
        case 0:
            radioList.currentindex = 0
            break
        case 1:
            radioList.currentindex = 1
            break
        }

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function getCurrentIndex()
    {
        switch(SettingsStorage.koreanKeypad)
        {
        case 0: return 0
        case 1: return 1
        }
    }

    function setState(index)
    {
        switch(index)
        {
        case 0: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_NAVI_VOLUME
            break;
        case 1: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_AUDIO_VOLUME
            break;
        }
    }

    function setKeypadSettings(index)
    {
        console.log("kjw :: new")
        console.log("kjw :: enter setKeypadSettings(index) !!!")
        console.log("kjw :: index : ", index)

        SettingsStorage.koreanKeypad = index
        SettingsStorage.SaveSetting( index, Settings.DB_KEY_KOREAN_KEYPAD )
        soundVolumeRatio.updateCurrentType(Settings.DB_KEY_KOREAN_KEYPAD)
        SettingsStorage.UpdateKeyboardData()
        EngineListener.NotifyApplication( Settings.DB_KEY_KOREAN_KEYPAD, index, "", UIListener.getCurrentScreen())
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_area
        width: 560
        height: 552

        default_x: 0
        default_y:0
        focus_x: 0
        focus_y: 0

        DHAVN_AppSettings_FocusedItem{
            id: radiolistarea
            anchors.top: parent.top
            anchors.left:parent.left
            width:parent.width
            height:parent.height

            default_x:0
            default_y:0
            focus_x: 0
            focus_y: 0

            ListModel{
                id: generalModel

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD_2SET")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYBOARD_KOR") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
                    enable: true
                }
            }

            DHAVN_AppSettings_SI_RadioList{
                id: radioList

                property string name: "RadioList"
                property int focus_x: 0
                property int focus_y: 0

                anchors.top: parent.top
                anchors.left: parent.left
                currentindex: getCurrentIndex()
                //radiomodel: (SettingsStorage.currentRegion == 0) ? domesticModel : generalModel
                radiomodel: generalModel
                focus_id: 0
                bInteractive: true //modify for ITS 245368 UI Drag Issue
                defaultValueIndex: HM.const_SETTINGS_SOUND_RATIO_DEFAULT_VALUE
                onIndexSelected:
                {
                    if(!isJog)
                    {
                        radiolistarea.hideFocus()
                        radiolistarea.setFocusHandle(0,0)
                        focus_index= nIndex
                        radiolistarea.showFocus()
                    }
                    soundVolumeRatio.setKeypadSettings(radioList.currentindex)
                    //setKeypadSettings(index)
                }

                onFocus_indexChanged:
                {
                    if(radioList.focus_index>=0 && radioList.focus_index<=generalModel.count && radioList.focus_visible)
                    {
                        soundVolumeRatio.setState(radioList.focus_index)
                    }
                }

                onFocus_visibleChanged:
                {
                    if(radioList.focus_visible)
                    {
                        rootSystem.setVisualCue(true, false, true, false)
                        soundVolumeRatio.setState(radioList.focus_index)
                    }
                    else
                    {
                        soundVolumeRatio.setState(radioList.currentindex)
                    }
                }
                //modify for ITS 245368 UI Drag Issue
                onMovementEnded:
                {
                    if(!focus_visible)
                    {
                        soundVolumeRatio.hideFocus()
                        soundVolumeRatio.setFocusHandle(0,0)

                        if(defaultValueIndex == currentindex)
                            focus_index = defaultValueIndex + 1
                        else
                            focus_index = defaultValueIndex

                        if(isShowSystemPopup == false)
                        {
                            soundVolumeRatio.showFocus()
                        }
                    }
                }
                Component.onCompleted:
                {
                    soundVolumeRatio.setState(radioList.currentindex)
                }
            }
        }
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_SOUND_NAVI_VOLUME
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_AUDIO_VOLUME
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_SAME_VOLUME
        }
    ]

    Connections{
        target:SettingsStorage

        onKoreanKeypadChanged:
        {
            console.log("kjw :: enter onKoreanKeypadChanged !!!")
            init()
        }
        onChangeKeypadSettings:
        {
            console.log("kjw :: enter onChangeKeypadSettings !!!")
            init()
        }
    }
    Connections{
        target: rootPopUpLoader.item
        onUpdateCurrentType:
        {
            console.log("kjw :: onUpdateCurrentType !!!")
            init()
        }
    }
}