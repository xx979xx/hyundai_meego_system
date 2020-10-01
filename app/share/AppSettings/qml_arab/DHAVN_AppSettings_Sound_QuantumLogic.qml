import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: soundQuantumLogic

    state: ""
    name: "Quantum_Logic_Surround"
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34

    default_x: 0
    default_y: 0

    function init()
    {
        radioList.currentindex = SettingsStorage.quantumLogic

        if(!focus_visible)
            setState(radioList.currentindex)
    }

    function setState(index)
    {
        switch(index)
        {
        case 0: soundQuantumLogic.state = HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_OFF
            break;
        case 1: soundQuantumLogic.state = HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_AUDIENCE
            break;
        case 2: soundQuantumLogic.state = HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_STAGE
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
            var quantumVal = radioList.currentindex

            SettingsStorage.quantumLogic = quantumVal
            SettingsStorage.SaveSetting( quantumVal, Settings.DB_KEY_QUANTUMLOGIC )
            //EngineListener.NotifyApplication(Settings.DB_KEY_QUANTUMLOGIC, quantumVal, "", UIListener.getCurrentScreen())
        }
    }

    DHAVN_AppSettings_SI_RadioList{
        id: radioList

        width: 560
        height: 552

        property string name: "RadioList"
        property int focus_x: 0
        property int focus_y: 0

        anchors.top: parent.top
        anchors.left: parent.left
        currentindex: SettingsStorage.quantumLogic
        radiomodel: myListModelId
        focus_id: 0
        bInteractive: false
        defaultValueIndex: HM.const_SETTINGS_SOUND_RATIO_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                parent.hideFocus()
                parent.setFocusHandle(0,0)
                focus_index= nIndex
                parent.showFocus()
            }

            if(menuSelectTimer.running)
                menuSelectTimer.restart()
            else
                menuSelectTimer.start()
        }

        onFocus_indexChanged:
        {
            if(radioList.focus_index>=0 && radioList.focus_index<=myListModelId.count && radioList.focus_visible)
            {
                soundQuantumLogic.setState(radioList.focus_index)
            }
        }

        onFocus_visibleChanged:
        {
            if(radioList.focus_visible)
            {
                rootSound.setVisualCue(true, false, false,true)
                soundQuantumLogic.setState(radioList.focus_index)
            }
            else
            {
                soundQuantumLogic.setState(radioList.currentindex)
            }
        }

        Component.onCompleted:
        {
            soundQuantumLogic.setState(radioList.currentindex)
        }
    }

    ListModel{
        id: myListModelId

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_OFF")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_AUDIENCE")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_SOUND_STAGE")
            enable: true
        }
    }

    Image{
        id: quantuImage
        source: "/app/share/images/AppSettings/settings/logo_quantum_logic.png"
        y : (soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_OFF)? 353 : 302
        width : 352
        height: 104
        anchors.left: parent.left
        anchors.leftMargin: 103
    }

    Text{
        id: appText
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 475
        anchors.left: parent.left
        anchors.leftMargin: 14
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP(" ")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 24
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_OFF
    }

    Text{
        id: appText_Audience
        width: 510
        height: 110
        x: 20
        y: 468+152-191-12
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_AUDIENCE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 24
        font.family: EngineListener.getFont(false)
        lineHeight: 12+font.pointSize
        lineHeightMode: Text.FixedHeight
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_AUDIENCE
    }

    Text{
        id: appText_OnStage
        width: 510
        height: 110
        x: 20
        y: 468+152-191-12
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_ONSTAGE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 24
        lineHeight: 12+font.pointSize
        lineHeightMode: Text.FixedHeight
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_STAGE
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_OFF
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_AUDIENCE
        },
        State{
            name: HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_STAGE
        }
    ]

    Connections{
        target:SettingsStorage

        onQuantumLogicChanged:
        {
            init()
        }
    }
}
