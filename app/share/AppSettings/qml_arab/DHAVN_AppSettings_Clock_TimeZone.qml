import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: timeZoneMain
    name: "TimeZone"
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
        switch(SettingsStorage.autoTimeZone)
        {
        case -540:  radiolist.currentindex = 0;  break;
        case -240:  radiolist.currentindex = 1;  break;
        case -360:  radiolist.currentindex = 2;  break;
        case -300:  radiolist.currentindex = 3;  break;
        case -600:  radiolist.currentindex = 4;  break;
        case -420:  radiolist.currentindex = 5;  break;
        case -210:  radiolist.currentindex = 6;  break;
        case -480:  radiolist.currentindex = 7;  break;
        default:
            radiolist.currentindex = 0
            SettingsStorage.autoTimeZone = -540
            SettingsStorage.SaveSetting( -540, Settings.DB_KEY_AUTO_TIMEZONE )
            SettingsStorage.setTimeZone(SettingsStorage.autoTimeZone, false)
            EngineListener.NotifyApplication( Settings.DB_KEY_AUTO_TIMEZONE, -540, "", UIListener.getCurrentScreen())
            break;
        }
    }

    function setTimeZone(nIndex)
    {
        var nTimeZone = 0
        switch (nIndex)
        {
        case 0: nTimeZone = -540; break;    //Alaska
        case 1: nTimeZone = -240; break;    //Atlantic
        case 2: nTimeZone = -360; break;    //Central
        case 3: nTimeZone = -300; break;    //Eastern
        case 4: nTimeZone = -600; break;    //Hawaii
        case 5: nTimeZone = -420; break;    //Mountain
        case 6: nTimeZone = -210; break;    //Newfoundland
        case 7: nTimeZone = -480; break;    //Pacific
        }

        SettingsStorage.setTimeZone(nTimeZone, false)
        SettingsStorage.autoTimeZone = nTimeZone
        SettingsStorage.SaveSetting( nTimeZone, Settings.DB_KEY_AUTO_TIMEZONE )
        EngineListener.NotifyApplication( Settings.DB_KEY_AUTO_TIMEZONE, nTimeZone, "", UIListener.getCurrentScreen())
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
        height: 552
        countDispalyedItems: 6

        focus_id: 0
        radiomodel: timeZoneList
        defaultValueIndex: HM.const_SETTINGS_CLOCK_TIMEZONE_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                timeZoneMain.hideFocus()
                timeZoneMain.setFocusHandle(0,0)
                focus_index= nIndex
                timeZoneMain.showFocus()
            }

            setTimeZone(nIndex)
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
                rootClockMain.setVisualCue(true, false, true, false)
            else
                isFocusedByFlicking = false
        }

        onMovementEnded:
        {
            if(!focus_visible)
            {
                timeZoneMain.hideFocus()
                timeZoneMain.setFocusHandle(0,0)

                if(radiolist.radiomodel.count <= 6)
                {
                    if(defaultValueIndex == currentindex)
                        focus_index = defaultValueIndex + 1
                    else
                        focus_index = defaultValueIndex
                }
                else
                {
                    if(defaultValueIndex >= currentTopIndex && defaultValueIndex < currentTopIndex+6)
                        focus_index = defaultValueIndex
                    else
                        focus_index = currentTopIndex
                }

                isFocusedByFlicking = true
                if(isShowSystemPopup == false)
                {
                    timeZoneMain.showFocus()
                }
            }
        }
    }

    ListModel{
        id: timeZoneList

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_ALASKA")
            enable: true
            item_id: 0
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_ATLANTIC")
            enable: true
            item_id: 1
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_CENTRAL")
            enable: true
            item_id: 2
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_EASTERN")
            enable: true
            item_id: 3
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_HAWAII")
            enable: true
            item_id: 4
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_MOUNTAIN")
            enable: true
            item_id: 5
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_NEWFOUNDLAND")
            enable: true
            item_id: 6
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_CLOCK_TIMEZONE_PACIFIC")
            enable: true
            item_id: 7
        }
    }

    Connections{
        target:SettingsStorage

        onAutoTimeZoneChanged:
        {
            if(timeZoneMain.visible)
                init()
        }
    }
}
