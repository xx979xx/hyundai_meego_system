import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: clockTypeMain
    name: "ClockType"

    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 34
    default_x: 0
    default_y: 0

    function init()
    {
        setRadiolistCurrentIndex()
    }

    function setRadiolistCurrentIndex()
    {
        if(SettingsStorage.clockType == 0) radiolist.currentindex = 1
        else radiolist.currentindex = 0
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if( radiolist.currentindex == 1)    // Analog
            {
                // set Settings variable
                SettingsStorage.clockType = 0
                SettingsStorage.SaveSetting( 0,  Settings.DB_KEY_CLOCK_TYPE )
                EngineListener.NotifyApplication(Settings.DB_KEY_CLOCK_TYPE, 0, "", UIListener.getCurrentScreen())
            }
            else                // Digital
            {
                // set Settings variable
                SettingsStorage.clockType = 1
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_CLOCK_TYPE )
                EngineListener.NotifyApplication(Settings.DB_KEY_CLOCK_TYPE, 1, "", UIListener.getCurrentScreen())
            }

        }
    }

    DHAVN_AppSettings_SI_RadioList{
        id: radiolist

        property string name: "RadioList"
        property int default_x: 0
        property int default_y: 0
        property int focus_x: 0
        property int focus_y: 0

        anchors.top: parent.top
        anchors.left: parent.left
        width: 560
        height: 552
        countDispalyedItems: 6
        bInteractive: false

        focus_id: 0
        radiomodel: myListClockType
        defaultValueIndex: HM.const_SETTINGS_CLOCK_TYPE_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                clockTypeMain.hideFocus()
                clockTypeMain.setFocusHandle(0,0)
                focus_index= nIndex
                clockTypeMain.showFocus()
            }

            if(menuSelectTimer.running)
                menuSelectTimer.restart()
            else
                menuSelectTimer.start()
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
                rootClockMain.setVisualCue(true, false, false, true)
        }
    }

    Text{
        id: appText1
        width: 510
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 367
        anchors.left: parent.left
        anchors.leftMargin: 14
        text: qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_TYPE_INFO")) + LocTrigger.empty
        color: HM.const_COLOR_TEXT_DIMMED_GREY
        font.pointSize: 32
        font.family: EngineListener.getFont(false)
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.WordWrap
    }

    ListModel{
        id: myListClockType

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_DIGITAL")
            enable: true
            item_id: 0
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_ANALOG")
            enable: true
            item_id: 1
        }
    }


    Connections{
        target:SettingsStorage

        onClockTypeChanged:
        {
            //console.log("[QML][ClockType] onClockTypeChanged :"+SettingsStorage.clockType)
            init()
        }
    }
}
