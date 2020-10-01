import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: soundVolumeRatio

    state: ""
    name: "VolumeRatioControl"
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    default_x: 0
    default_y: 0

    function init()
    {
        if(SettingsStorage.currentRegion == 0)
        {
            radioList.currentindex = SettingsStorage.volumeRatio
        }
        else
        {
            switch(SettingsStorage.volumeRatio)
            {
            case 0:
                radioList.currentindex = 0
                break
            case 2:
                radioList.currentindex = 1
                break
            }
        }

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function getCurrentIndex()
    {
        if(SettingsStorage.currentRegion == 0)
        {
            return SettingsStorage.volumeRatio
        }
        else
        {
            switch(SettingsStorage.volumeRatio)
            {
            case 0: return 0
            case 2: return 1
            }
        }
    }

    function setState(index)
    {
        if(SettingsStorage.currentRegion == 0)
        {
            switch(index)
            {
            case 0: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_NAVI_VOLUME
                break;
            case 1: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_AUDIO_VOLUME
                break;
            case 2: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_SAME_VOLUME
                break;
            }
        }
        else
        {
            switch(index)
            {
            case 0: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_NAVI_VOLUME
                break;
            case 1: soundVolumeRatio.state = HM.const_APP_SETTINGS_SOUND_SAME_VOLUME
                break;
            }
        }
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(SettingsStorage.currentRegion == 0)
            {
                SettingsStorage.volumeRatio = radioList.currentindex
                SettingsStorage.SaveSetting( radioList.currentindex, Settings.DB_KEY_SOUND_VOLUME_RATIO )
                EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_VOLUME_RATIO, radioList.currentindex, "", UIListener.getCurrentScreen())
            }
            else
            {
                var ratioVal = radioList.currentindex
                if(ratioVal == 1) ratioVal = 2

                SettingsStorage.volumeRatio = ratioVal
                SettingsStorage.SaveSetting( ratioVal, Settings.DB_KEY_SOUND_VOLUME_RATIO )
                EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_VOLUME_RATIO, ratioVal, "", UIListener.getCurrentScreen())
            }
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
            anchors.left: parent.left
            width:parent.width
            height:parent.height

            default_x:0
            default_y:0
            focus_x: 0
            focus_y: 0

            ListModel{
                id: generalModel

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
                    enable: true
                }
            }

            ListModel{
                id: domesticModel

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")//qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_NAV") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_AUDIO") // qsTranslate ("main", "STR_SETTING_SOUND_LOUDER_VOL_AUDIO") + LocTrigger.empty; //QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_AUDIO")
                    enable: true
                }

                ListElement{
                    title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL") //qsTranslate ("main", "STR_SETTING_SOUND_SAME_VOL") + LocTrigger.empty; //;QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL")
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
                radiomodel: (SettingsStorage.currentRegion == 0) ? domesticModel : generalModel
                focus_id: 0
                bInteractive: false
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

                    if(menuSelectTimer.running)
                        menuSelectTimer.restart()
                    else
                        menuSelectTimer.start()
                }

                onFocus_indexChanged:
                {
                    if(SettingsStorage.currentRegion == 0)
                    {
                        if(radioList.focus_index>=0 && radioList.focus_index<=domesticModel.count && radioList.focus_visible)
                        {
                            soundVolumeRatio.setState(radioList.focus_index)
                        }
                    }
                    else
                    {
                        if(radioList.focus_index>=0 && radioList.focus_index<=generalModel.count && radioList.focus_visible)
                        {
                            soundVolumeRatio.setState(radioList.focus_index)
                        }
                    }
                }

                onFocus_visibleChanged:
                {
                    if(radioList.focus_visible)
                    {
                        rootSound.setVisualCue(true, false, false, true)
                        soundVolumeRatio.setState(radioList.focus_index)
                    }
                    else
                    {
                        soundVolumeRatio.setState(radioList.currentindex)
                    }
                }

                Component.onCompleted:
                {
                    soundVolumeRatio.setState(radioList.currentindex)
                }
            }
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: (SettingsStorage.currentRegion == 0) ? 408 : 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : soundVolumeRatio.state == HM.const_APP_SETTINGS_SOUND_NAVI_VOLUME
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_NAV_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
    }

    Text{
        id: appText2
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : soundVolumeRatio.state == HM.const_APP_SETTINGS_SOUND_AUDIO_VOLUME
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_LOUDER_VOL_AUDIO_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
    }

    Text{
        id: appText3
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: (SettingsStorage.currentRegion == 0) ? 408 : 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : soundVolumeRatio.state == HM.const_APP_SETTINGS_SOUND_SAME_VOLUME
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_SAME_VOL_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
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

        onVolumeRatioChanged:
        {
            //console.log("called onvolumeRatioChanged :"+SettingsStorage.volumeRatio)
            init()
        }
    }
}
