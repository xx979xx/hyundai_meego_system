import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: setDimmingMain

    state: ""
    name: "ScreenSetDimming"

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
        radioList.currentindex = SettingsStorage.exposure

        if(!focus_visible)
            setDimmingMain.setState( radioList.currentindex )
    }

    function setState(index)
    {
        switch( index )
        {
        case 0: setDimmingMain.state = HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_AUTOMATIC
            break
        case 1: setDimmingMain.state = HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_DAYTIME
            break
        case 2: setDimmingMain.state = HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_NIGHT
            break

        default:
            break
        }
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 50
        onTriggered:
        {
            SettingsStorage.exposure = radioList.currentindex
            //SettingsStorage.SaveSetting(radioList.currentindex,Settings.DB_KEY_EXPOSURE);
            EngineListener.NotifyDisplayModeChange(radioList.currentindex);
            EngineListener.NotifySetIlluminationMostManager(radioList.currentindex);
            //EngineListener.NotifyApplication( Settings.DB_KEY_EXPOSURE,
            //                                 radioList.currentindex,
             //                                "",
             //                                UIListener.getCurrentScreen());
        }
    }

    DHAVN_AppSettings_SI_RadioList{
        id: radioList

        property string textVal: QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING")
        property int default_x: 0
        property int default_y: 0
        property int focus_x: 0
        property int focus_y: 0

        width: 560
        height: 552

        anchors.top: parent.top
        anchors.left: parent.left
        currentindex: SettingsStorage.exposure
        radiomodel: myListModelId
        state: HM.const_APP_SETTINGS_INPUT_FROM_HU
        bInteractive: false

        focus_id: 0
        defaultValueIndex: HM.const_SETTINGS_SCREEN_DIMMING_DEFAULT_VALUE
        onIndexSelected:
        {
            //! If setting value is changed on HU side
            if ( radioList.state == HM.const_APP_SETTINGS_INPUT_FROM_HU )
            {
                if(!isJog)
                {
                    parent.hideFocus()
                    parent.setFocusHandle(0,0)
                    focus_index= nIndex
                    parent.showFocus()
                }

                // set Settings variable
                if(menuSelectTimer.running)
                    menuSelectTimer.restart()
                else
                    menuSelectTimer.start()
            }
            else
            {
                radioList.state = HM.const_APP_SETTINGS_INPUT_FROM_HU;
            }
        }

        onFocus_indexChanged:
        {
            if(radioList.focus_index>=0 && radioList.focus_index<=myListModelId.count && radioList.focus_visible) setDimmingMain.setState(radioList.focus_index)
        }

        onFocus_visibleChanged:
        {
            if(radioList.focus_visible)
            {
                rootScreen.setVisualCue(true, false, true, false)
                setDimmingMain.setState(radioList.focus_index)
            }
            else
            {
                setDimmingMain.setState(radioList.currentindex)
            }
        }

        Component.onCompleted:
        {
            setDimmingMain.setState(radioList.currentindex)
        }
    }



    ListModel{
        id: myListModelId

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING_AUTOMATIC")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING_DAYTIME")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING_NIGHT")
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
        visible : setDimmingMain.state == HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_AUTOMATIC
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING_AUTOMATIC_INFO")) + LocTrigger.empty
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
        anchors.verticalCenterOffset: 408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : setDimmingMain.state == HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_DAYTIME
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING_DAYTIME_INFO")) + LocTrigger.empty
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
        anchors.verticalCenterOffset: 408
        anchors.left: parent.left
        anchors.leftMargin: 14
        visible : setDimmingMain.state == HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_NIGHT
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_DISPLAY_DIMMING_NIGHT_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
    }

    states: [
        State{
            name: HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_AUTOMATIC
        },
        State{
            name: HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_DAYTIME
        },
        State{
            name: HM.const_APP_SETTINGS_SCREEN_SET_DIMMING_NIGHT
        },
        State{
            name: HM.const_APP_SETTINGS_INPUT_FROM_IBOX
        },
        State{
            name: HM.const_APP_SETTINGS_INPUT_FROM_HU
        }
    ]

    Connections{
        target: SettingsStorage

        onExposureChanged:
        {
            //console.log("called onExposureChanged :"+SettingsStorage.exposure)
            init();
        }
    }
}
