import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: soundVolumeRatio1

    state: ""
    name: "Volume_Ratio_Control"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    default_x: 0
    default_y: 0

    //signal updateCurrentType(int type)
    signal updateHyundayType()
    is_focusMovable: true

    function init()
    {
        console.log("kjw :: 28")
        /*
        switch(SettingsStorage.hyunDaiKeypad)
        {
        case 0:
            radioList.currentindex = 0
            break
        case 1:
            radioList.currentindex = 1
            break
        }
        */
        if(SettingsStorage.hyunDaiKeypad == 0)
            radioList.currentindex = 1
        else
            radioList.currentindex = 0

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function getCurrentIndex()
    {
        console.log("kjw :: 29")
        /*
        switch(SettingsStorage.hyunDaiKeypad)
        {
        case 0: return 0
        case 1: return 1
        }
        */
        if(SettingsStorage.hyunDaiKeypad == 0)
            return 1
        else
            return 0
    }

    function setState(index)
    {
        console.log("kjw :: 30")
        console.log("kjw :: setState :: index : ", index)
        switch(index)
        {
        case 0: soundVolumeRatio1.state = HM.const_APP_SETTINGS_SOUND_NAVI_VOLUME
            break;
        case 1: soundVolumeRatio1.state = HM.const_APP_SETTINGS_SOUND_AUDIO_VOLUME
            break;
        }
    }

    function setKeypadSettings(index)
    {
        console.log("kjw :: 31")
        //console.log("kjw :: setKeypadSettings :: index : ", index)
/*
        SettingsStorage.koreanKeypad = index
        SettingsStorage.SaveSetting( index, Settings.DB_KEY_HYUNDAY_KEYPAD )
        soundVolumeRatio.updateCurrentType(Settings.DB_KEY_KOREAN_KEYPAD)
        SettingsStorage.UpdateKeyboardData()
        EngineListener.NotifyApplication( Settings.DB_KEY_KOREAN_KEYPAD, index, "", UIListener.getCurrentScreen())
*/
        SettingsStorage.hyunDaiKeypad = index
        SettingsStorage.SaveSetting( index, Settings.DB_KEY_HYUNDAY_KEYPAD )
        soundVolumeRatio1.updateHyundayType()
        EngineListener.NotifyApplication( Settings.DB_KEY_HYUNDAY_KEYPAD, index, "", UIListener.getCurrentScreen())

    }

    function getlistmodel()
    {
        console.log("kjw :: 32")
        switch(SettingsStorage.currentRegion)
        {
        case 0: return list_model_Domestic_General; break;
        case 1: return list_model_NA; break;
        case 2: return list_model_China; break;
        case 3: return list_model_Domestic_General; break;
        case 4: return list_model_Arabic; break;
        case 5: return list_model_europe; break;
        case 6: return list_model_NA; break;
        case 7: return list_model_russia; break;
        default: return list_model_Domestic_General; break;
        }
    }

    function getindex(index)
    {
        console.log("kjw :: 33")
        //console.log("kjw :: getindex :: index : ", index)
        switch(SettingsStorage.currentRegion)
        {
        case 0:
        case 3:
                return 0; break;
        case 1:
        case 6:
            if(index == 0)
                return 1
            else
                return 0; break;
        case 2:
            if(index == 0)
                return 3
            else
                return 0; break;
        case 4:
            if(index == 0)
                return 2
            else
                return 0; break;
        case 5:
        case 7:
            if(index == 0)
                return 4
            else
                return 0; break;
        default: return 0
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_area
        width: 560
        height: 552

        anchors.top: parent.top
        anchors.left: parent.left

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
                id: list_model_Domestic_General

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }
            }
            ListModel{
                id: list_model_China

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_CHINA")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
                    enable: true
                }
            }
            ListModel{
                id: list_model_NA

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_ENGLISH_LATIN")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
                    enable: true
                }
            }
            ListModel{
                id: list_model_Arabic

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_ARABIC")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
                    enable: true
                }
            }
            ListModel{
                id: list_model_europe

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_EUROPE")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
                    enable: true
                }
            }
            ListModel{
                id: list_model_russia

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_CYRILIC")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_KEYPAD_HYUNDAI_KOREAN") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
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
                radiomodel: getlistmodel()
                focus_id: 0
                bInteractive: true //modify for ITS 245368 UI Drag Issue
                defaultValueIndex: HM.const_SETTINGS_SOUND_RATIO_DEFAULT_VALUE
                onIndexSelected:
                {
                    console.log("kjw :: currentindex : ", currentindex)
                    console.log("kjw :: focus_index", focus_index)
                    console.log("kjw :: nIndex", nIndex)
                    if( ( currentindex == 1 && SettingsStorage.hyunDaiKeypad != 0 ) || ( currentindex == 0 && SettingsStorage.hyunDaiKeypad == 0 ) )
                    {
                        console.log("kjw :: 34")
                        if(!isJog)
                        {
                            console.log("kjw :: 34-1")
                            radiolistarea.hideFocus()
                            radiolistarea.setFocusHandle(0,0)
                            focus_index= nIndex
                            radiolistarea.showFocus()
                        }

                        console.log("kjw :: here??? !!!")
                        soundVolumeRatio1.setKeypadSettings(soundVolumeRatio1.getindex(radioList.currentindex))
                        //setKeypadSettings(radioList.currentindex)
                    }
                    else
                    {
                        if(!isJog)
                        {
                            console.log("kjw :: 34-1")
                            radiolistarea.hideFocus()
                            radiolistarea.setFocusHandle(0,0)
                            focus_index= nIndex
                            radiolistarea.showFocus()
                        }
                    }
                }

                onFocus_indexChanged:
                {
                    console.log("kjw :: 35")
                    //console.log("kjw :: onFocus_indexChanged :: radioList.focus_index : ", radioList.focus_index)
                    if(radioList.focus_index>=0 && radioList.focus_index<=generalModel.count && radioList.focus_visible)
                    {
                        console.log("kjw :: 35-1")
                        //console.log("kjw :: 1")
                        soundVolumeRatio1.setState(radioList.focus_index)
                    }
                }

                onFocus_visibleChanged:
                {
                    console.log("kjw :: 36")


                    //console.log("kjw :: onFocus_visibleChanged :: radioList.focus_index : ", radioList.focus_index)
                    //console.log("kjw :: onFocus_visibleChanged :: radioList.currentindex : ", radioList.currentindex)
                    //console.log("kjw :: add new !!!")
                    //console.log("kjw :: onFocus_visibleChanged :: radioList.focus_visible : ", radioList.focus_visible)
                    console.log("kjw :: add new !!!")
                    if(radioList.focus_visible)
                    {
                        console.log("kjw :: Here is Visual Cue !!!!")
                        rootSystem.setVisualCue(true, false, true, false)
                        soundVolumeRatio1.setState(radioList.focus_index)
                    }
                    else
                    {
                        //console.log("kjw :: 36-3")
                        soundVolumeRatio1.setState(radioList.currentindex)
                    }
                }
                //modify for ITS 245368 UI Drag Issue
                onMovementEnded:
                {
                    if(!focus_visible)
                    {
                        soundVolumeRatio1.hideFocus()
                        soundVolumeRatio1.setFocusHandle(0,0)

                        if(defaultValueIndex == currentindex)
                            focus_index = defaultValueIndex + 1
                        else
                            focus_index = defaultValueIndex

                        if(isShowSystemPopup == false)
                        {
                            soundVolumeRatio1.showFocus()
                        }
                    }
                }
                Component.onCompleted:
                {
                    console.log("kjw :: 37")
                    //console.log("kjw :: Component.onCompleted: !!!")
                    soundVolumeRatio1.setState(radioList.currentindex)
                    //rootSystem.init()
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

        onHyunDaiKeypadChanged:
        {
            console.log("kjw :: why!!!!!")
            //console.log("kjw :: onHyunDaiKeypadChanged :: focus_index : ", focus_index)
            //soundVolumeRatio.setState(radioList.focus_index)
            console.log("kjw :: onHyunDaiKeypadChanged :: radioList.focus_index : ", radioList.focus_index)
            //radioList.focus_visible = true
            rootSystem.init_list()
        }
    }
    Connections{
        //target: visual_cue_bg.visible ? UIListener : null
        target: UIListener
        onSignalJogNavigation:
        {
            console.log("kjw :: 40")
            //console.log("kjw :: enter jog")
            switch ( arrow )
            {
            case UIListenerEnum.JOG_LEFT:
            {
                //console.log("kjw :: onSignalJogNavigation:")
                //isChangeDefault = false
                //isChangeDefault2 = false
                //console.log("kjw :: onSignalJogNavigation :: isChangeDefault : ", isChangeDefault)
                //radioList.focus_visible = false


                break
            }

            }
        }
    }

}
