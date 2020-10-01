import QtQuick 1.1
import com.settings.variables 1.0
import com.settings.defines 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: main

    property string textVal: "Sound_Variable_EQ"

    state: ""
    name: "Sound_Variable_EQ"
    width: parent.width
    height: 554
    anchors.left: parent.left
    anchors.leftMargin: 708
    anchors.top:parent.top
    anchors.topMargin: 73

    default_x: 0
    default_y: 0

    function init()
    {
        radioList.currentindex = SettingsStorage.variableEQ

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function setState(index)
    {
        switch(index)
        {
        case 0: main.state = HM.const_APP_SETTINGS_SOUND_STATE_VEQ_INNOCENTE
            break;
        case 1: main.state = HM.const_APP_SETTINGS_SOUND_STATE_VEQ_FORZA
            break;
        case 2: main.state = HM.const_APP_SETTINGS_SOUND_STATE_VEQ_CONCERTO
            break;
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: variableEQArea
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
                title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ_INNOCENTE")
                enable: true
            }
            ListElement{
                title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ_FORZA")
                enable: true
            }
            ListElement{
                title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ_CONCERTO")
                enable: true
            }
        }

        DHAVN_AppSettings_SI_RadioList{
            id: radioList

            property string name: "RadioList"
            property int focus_x: 0
            property int focus_y: 0

            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.left: parent.left

            radiomodel:  list2
            currentindex: SettingsStorage.variableEQ
            focus_id: 0
            defaultValueIndex: HM.const_SETTINGS_SOUND_VARIABLE_EQ_DEFAULT_VALUE
            onIndexSelected:
            {
                if(!isJog)
                {
                    variableEQArea.hideFocus()
                    variableEQArea.setFocusHandle(0,0)
                    focus_index= nIndex
                    variableEQArea.showFocus()
                }

                SettingsStorage.variableEQ = nIndex
                SettingsStorage.SaveSetting( nIndex, Settings.DB_KEY_SOUND_VEQ )
                EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_VEQ, nIndex, "", UIListener.getCurrentScreen())
            }

            Component.onCompleted:
            {
                main.setState(radioList.currentindex)
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
        visible : main.state == HM.const_APP_SETTINGS_SOUND_STATE_VEQ_INNOCENTE
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ_INNOCENTE_INFO")) + LocTrigger.empty
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
        visible : main.state == HM.const_APP_SETTINGS_SOUND_STATE_VEQ_FORZA
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ_FORZA_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    Text{
        id: appText3
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : main.state == HM.const_APP_SETTINGS_SOUND_STATE_VEQ_CONCERTO
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_VARIABLE_EQ_CONCERTO_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_SOUND_STATE_VEQ_INNOCENTE
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_STATE_VEQ_FORZA
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_STATE_VEQ_CONCERTO
        }
    ]

    Connections{
        target:SettingsStorage

        onVariableEQChanged:
        {
            //console.log("called onVariableEQChanged :"+SettingsStorage.variableEQ)
            init()
        }
    }
}
