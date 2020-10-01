import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: voiceRecognition
    name: "VoiceRecognition"
    state: ""
    property string textVal: "Auto Guide"

    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    function init()
    {
        rootVoice.setVisualCue(true, false, false, false)

        radioList.currentindex = SettingsStorage.voiceCommand

        if(!focus_visible)
            voiceRecognition.setState(radioList.currentindex)
    }

    function setState(index)
    {
        switch ( index )
        {
        case 0: voiceRecognition.state = HM.const_APP_SETTINGS_VOICE_STATE_VOICE_CONTROL_DETAIL_GUIDE
            break
        case 1: voiceRecognition.state = HM.const_APP_SETTINGS_VOICE_STATE_VOICE_CONTROL_SIMPLE_GUIDE
            break
        case 2: voiceRecognition.state = HM.const_APP_SETTINGS_VOICE_STATE_VOICE_VOICE_CONTROL_NONE
            break
        }

    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            //set Settings variable
            SettingsStorage.voiceCommand = radioList.currentindex
            SettingsStorage.SaveSetting( radioList.currentindex,
                                        Settings.DB_KEY_VOICE_VOICECOMMAND )

            switch(radioList.currentindex)
            {
            case 0: radioList.textVal = QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_DETAIL_GUIDE"); break;
            case 1: radioList.textVal = QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_SIMPLE_GUIDE"); break;
            case 2: radioList.textVal = QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_NONE"); break;
            }

            EngineListener.NotifyApplication(Settings.DB_KEY_VOICE_VOICECOMMAND, radioList.currentindex, radioList.textVal, UIListener.getCurrentScreen())
        }
    }

    DHAVN_AppSettings_SI_RadioList{
        id: radioList

        property string textVal: ""
        property int default_x: 0
        property int default_y: 0
        property int focus_x: 0
        property int focus_y: 0

        width: 560
        height: 552

        anchors.top: parent.top
        anchors.left: parent.left
        radiomodel:  guideListModel
        currentindex: SettingsStorage.voiceCommand
        focus_id: 0
        bInteractive: false
        defaultValueIndex: HM.const_SETTINGS_VOICE_RECOGNITION_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                voiceRecognition.hideFocus()
                voiceRecognition.setFocusHandle(0,0)
                radioList.focus_index= nIndex
                voiceRecognition.showFocus()
            }

            if(menuSelectTimer.running)
                menuSelectTimer.restart()
            else
                menuSelectTimer.start()
        }

        onFocus_indexChanged:
        {
            if(radioList.focus_index>=0 &&
                    radioList.focus_index <= guideListModel.count && radioList.focus_visible)
                voiceRecognition.setState(radioList.focus_index)
        }

        onFocus_visibleChanged:
        {
            if(radioList.focus_visible)
            {
                voiceRecognition.setState(radioList.focus_index)
                rootVoice.setVisualCue(true, false, false, false)
            }
            else
            {
                voiceRecognition.setState(radioList.currentindex)
            }
        }

        Component.onCompleted:
        {
            voiceRecognition.setState(radioList.currentindex)
        }
    }


    ListModel{
        id: guideListModel

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_DETAIL_GUIDE")
            enable: true
        }
        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_SIMPLE_GUIDE")
            enable: true
        }
        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_NONE")
            enable: true
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : voiceRecognition.state == HM.const_APP_SETTINGS_VOICE_STATE_VOICE_CONTROL_DETAIL_GUIDE
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_DETAIL_GUIDE_INFO")) + LocTrigger.empty
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
        visible : voiceRecognition.state == HM.const_APP_SETTINGS_VOICE_STATE_VOICE_CONTROL_SIMPLE_GUIDE
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_SIMPLE_GUIDE_INFO")) + LocTrigger.empty
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
        anchors.verticalCenterOffset: 408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : voiceRecognition.state == HM.const_APP_SETTINGS_VOICE_STATE_VOICE_VOICE_CONTROL_NONE
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_VOICE_CONTROL_NONE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_VOICE_STATE_VOICE_CONTROL_DETAIL_GUIDE
        },
        State{
            name: HM.const_APP_SETTINGS_VOICE_STATE_VOICE_CONTROL_SIMPLE_GUIDE
        },
        State{
            name: HM.const_APP_SETTINGS_VOICE_STATE_VOICE_VOICE_CONTROL_NONE
        }
    ]

    Connections{
        target:SettingsStorage

        onVoiceCommandChanged:
        {
            //console.log("called onVoiceCommandChanged :"+SettingsStorage.voiceCommand)
            init();
        }
    }
}
