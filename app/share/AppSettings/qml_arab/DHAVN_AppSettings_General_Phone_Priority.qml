import QtQuick 1.1
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: phonePriorityMain
    name: "Phone_priority"
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    default_x: 0
    default_y: 0
    state: ""

    function init()
    {
        radioList.currentindex = SettingsStorage.vrPhonePriority

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function setState(index)
    {
        switch(index)
        {
        case 0: phonePriorityMain.state = HM.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY_BLUETOOTH
            break;
        case 1: phonePriorityMain.state = HM.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY_BLUELINK
            break;
        }
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            SettingsStorage.vrPhonePriority = radioList.currentindex
            SettingsStorage.SaveSetting(radioList.currentindex, Settings.DB_KEY_VR_PHONE_PRIORITY )
            EngineListener.NotifyApplication(Settings.DB_KEY_VR_PHONE_PRIORITY, radioList.currentindex, "", UIListener.getCurrentScreen())
            EngineListener.SendPhonePrioritySettingToIBox(radioList.currentindex+1)
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: voicePhoneArea
        anchors.top: parent.top
        anchors.left:parent.left
        width:parent.width
        height:parent.height

        default_x:0
        default_y:0
        focus_x: 0
        focus_y: 0

        ListModel{
            id: list2

            ListElement{
                title_of_radiobutton: QT_TR_NOOP("STR_SETTING_VOICE_PHONE_BLUETOOTH")
                enable: true
            }
            ListElement{
                title_of_radiobutton: QT_TR_NOOP("STR_SETTING_VOICE_PHONE_BLUELINK")
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

            radiomodel:  list2
            currentindex: SettingsStorage.vrPhonePriority
            focus_id: 0
            bInteractive: false
            defaultValueIndex: HM.const_SETTINGS_GENERAL_PHONE_PRIORITY_DEFAULT_VALUE
            onIndexSelected:
            {
                var value

                switch(radioList.currentindex)
                {
                case 0: value = SettingsDef.SETTINGS_PHONE_PRIORITY_BLUETOOTH; break;
                case 1: value = SettingsDef.SETTINGS_PHONE_PRIORITY_BLUELINK; break;
                }

                if(!isJog)
                {
                    voicePhoneArea.hideFocus()
                    voicePhoneArea.setFocusHandle(0,0)
                    focus_index= nIndex
                    voicePhoneArea.showFocus()
                }

                if(menuSelectTimer.running)
                    menuSelectTimer.restart()
                else
                    menuSelectTimer.start()
            }

            onFocus_indexChanged:
            {
                if(radioList.focus_index>=0 && radioList.focus_index<=list2.count && radioList.focus_visible) phonePriorityMain.setState(radioList.focus_index)
            }

            onFocus_visibleChanged:
            {
                if(radioList.focus_visible)
                {
                    rootGeneral.setVisualCue(true, false, false, true)
                    phonePriorityMain.setState(radioList.focus_index)
                }
                else
                {
                    phonePriorityMain.setState(radioList.currentindex)
                }
            }

            Component.onCompleted:
            {
                phonePriorityMain.setState(radioList.currentindex)
            }
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : phonePriorityMain.state == HM.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY_BLUETOOTH
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_VOICE_PHONE_BLUETOOTH_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    Text{
        id: appText2
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : phonePriorityMain.state == HM.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY_BLUELINK
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_VOICE_PHONE_BLUELINK_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY_BLUETOOTH
        },
        State{
            name: HM.const_APP_SETTINGS_GENERAL_STATE_PHONE_PRIORITY_BLUELINK
        }
    ]


    Connections{
        target:SettingsStorage

        onVrPhonePriorityChanged:
        {
            //console.log("called onAVCChanged :"+SettingsStorage.vrPhonePriority)
            init()
        }
    }
}
