import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: soundQuantumLogic

    state: ""
    name: "Quantum_Logic_Surround"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699

    default_x: 0
    default_y: 0

    function init()
    {
        //radioList.currentindex = SettingsStorage.quantumLogic
        //Added for QuantumLogic set Micom value issue
        if(SettingsStorage.quantumLogic == 1)
        {
            radioList.currentindex = 2
        }
        else if(SettingsStorage.quantumLogic == 2)
        {
            radioList.currentindex = 1
        }
        else
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

    //Added for QuantumLogic set Micom value issue
    function initValue()
    {
        switch(SettingsStorage.quantumLogic)
        {
        case 0:
            return 0;
        case 1:
            return 2;
        case 2:
            return 1;
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

            //Added for QuantumLogic set Micom value issue
            if(radioList.currentindex == 1)
            {
                quantumVal = 2
            }
            else if(radioList.currentindex == 2)
            {
                quantumVal = 1
            }
            else
                quantumVal = radioList.currentindex

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
        currentindex: initValue//SettingsStorage.quantumLogic //Added for QuantumLogic set Micom value issue
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
                rootSound.setVisualCue(true, false, true, false)
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
        x: 90
        y : (soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_OFF)? 353 : 302
        width : 352
        height: 104

    }

    Text{
        id: appText
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 480/*470*/
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

    // [2016.05.19 minyeong] display string
    Text{
        id: appText_Audience
        width: 510
        height: 110
        x: 11
        y: (appText_OnStage.lineCount == 2)? 468+152-191-12:(appText_OnStage.lineCount == 3)? 600-176-12 : 601-172-11 //510//480/*470*/
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_AUDIENCE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: (tmpAppText_Audience_24.lineCount < 4)? 24 : ((tmpAppText_Audience_22.lineCount <= 4)? 22 : ((tmpAppText_Audience_20.lineCount <= 4)? 20 : 18))
        font.family: EngineListener.getFont(false)
        lineHeight:(tmpAppText_Audience_24.lineCount < 4)? 12+font.pointSize : 6+font.pointSize
        lineHeightMode: Text.FixedHeight
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_AUDIENCE
    }

    // [2016.05.19 minyeong] for counting Text line
    Text{
        id: tmpAppText_Audience_24
        width: 510
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_AUDIENCE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 24
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: false
    }

    // [2016.05.19 minyeong] for counting Text line
    Text{
        id: tmpAppText_Audience_22
        width: 510
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_AUDIENCE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 22
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: false
    }

    // [2016.05.19 minyeong] for counting Text line
    Text{
        id: tmpAppText_Audience_20
        width: 510
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_AUDIENCE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 20
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: false
    }

    // [2016.05.19 minyeong] display string
    Text{
        id: appText_OnStage
        width: 510
        height: 110
        x: 11
        y: (appText_OnStage.lineCount == 2)? 468+152-191-12:(appText_OnStage.lineCount == 3)? 600-176-12 : 601-172-11//(appText_OnStage.lineCount == 4)?510
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_ONSTAGE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize:(tmpAppText_OnStage_24.lineCount < 4)? 24 : ((tmpAppText_OnStage_22.lineCount <= 4)? 22 : ((tmpAppText_OnStage_20.lineCount <= 4)? 20:18))
        font.family: EngineListener.getFont(false)
        lineHeight:(tmpAppText_OnStage_24.lineCount < 4)? 12+font.pointSize : 6+font.pointSize
        lineHeightMode: Text.FixedHeight
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: soundQuantumLogic.state == HM.const_APP_SETTINGS_SOUND_QUANTUM_MODE_STAGE
    }

    // [2016.05.19 minyeong] for counting Text line
    Text{
        id: tmpAppText_OnStage_24
        width: 510//510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 510//480/*470*/
        anchors.left: parent.left
        anchors.leftMargin: -20//14
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_ONSTAGE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize:24
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: false
    }

    // [2016.05.19 minyeong] for counting Text line
    Text{
        id: tmpAppText_OnStage_22
        width: 510//510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 510//480/*470*/
        anchors.left: parent.left
        anchors.leftMargin: -20//14
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_ONSTAGE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize:22
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: false
    }

    // [2016.05.19 minyeong] for counting Text line
    Text{
        id: tmpAppText_OnStage_20
        width: 510//510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 510//480/*470*/
        anchors.left: parent.left
        anchors.leftMargin: -20//14
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_PE_ONSTAGE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize:20
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        visible: false
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
