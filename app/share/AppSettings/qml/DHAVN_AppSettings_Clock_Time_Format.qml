import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: timeFormatMain
    name: "TimeFormat"
    width: parent.width
    height: 554
    anchors.top:parent.top
    anchors.topMargin: 73
    anchors.left: parent.left
    anchors.leftMargin: 699
    default_x: 0
    default_y: 0

    function init( )
    {
        setRadiolistCurrentIndex()
    }

    function setRadiolistCurrentIndex()
    {
        radiolist.currentindex = SettingsStorage.timeType
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            SettingsStorage.timeType = radiolist.currentindex
            SettingsStorage.SaveSetting( radiolist.currentindex, Settings.DB_KEY_TIME_TYPE )
            EngineListener.SetTimeFormat( radiolist.currentindex )
            SettingsStorage.TimeFormatechanged( radiolist.currentindex );
            EngineListener.NotifyApplication(Settings.DB_KEY_TIME_TYPE, radiolist.currentindex, "", UIListener.getCurrentScreen())
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

        focus_id: 0
        radiomodel: myListTimeFormat
        defaultValueIndex: HM.const_SETTINGS_CLOCK_TIME_FORMAT_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                timeFormatMain.hideFocus()
                timeFormatMain.setFocusHandle(0,0)
                focus_index= nIndex
                timeFormatMain.showFocus()
            }

            if(menuSelectTimer.running)
                menuSelectTimer.restart()
            else
                menuSelectTimer.start()
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
                rootClockMain.setVisualCue(true, false, true, false)
        }

        onMovementEnded:
        {
            if(!focus_visible)
            {
                timeFormatMain.hideFocus()
                timeFormatMain.setFocusHandle(0,0)

                if(defaultValueIndex == currentindex)
                    focus_index = defaultValueIndex + 1
                else
                    focus_index = defaultValueIndex

                if(isShowSystemPopup == false)
                {
                    timeFormatMain.showFocus()
                }
            }
        }
    }

    ListModel{
        id: myListTimeFormat

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_12H")
            enable: true
            item_id: 0
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_24H")
            enable: true
            item_id: 1
        }
    }

    Connections{
        target:SettingsStorage

        onTimeTypeChanged:
        {
            //console.log("called onTimeTypeChanged :"+SettingsStorage.DB_KEY_TIME_TYPE)
            init()
        }
    }
}
