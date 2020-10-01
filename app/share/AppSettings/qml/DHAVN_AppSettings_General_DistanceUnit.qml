import QtQuick 1.1
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as HM
import "SimpleItems"

DHAVN_AppSettings_FocusedItem{
    id: distanceUnitMain

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
        if(SettingsStorage.distanceUnit == 0)   // km
            radiolist.currentindex = 1
        else                                    // mile
            radiolist.currentindex = 0
    }

    Timer {
        id: menuSelectTimer
        running: false
        repeat: false
        interval: 300
        onTriggered:
        {
            if(radiolist.currentindex == 1) // km
            {
                // set Settings variable
                SettingsStorage.distanceUnit = 0
                SettingsStorage.SaveSetting( 0, Settings.DB_KEY_DISTANCE_UNIT )

                EngineListener.SendDistanceUnit( 0 )
                EngineListener.NotifyApplication( Settings.DB_KEY_DISTANCE_UNIT, 0,"")
                EngineListener.NotifyDistanceUnitChanged( 0 )
            }
            else            // mile
            {
                // set Settings variable
                SettingsStorage.distanceUnit = 1
                SettingsStorage.SaveSetting( 1, Settings.DB_KEY_DISTANCE_UNIT )

                EngineListener.SendDistanceUnit( 1 )
                EngineListener.NotifyApplication( Settings.DB_KEY_DISTANCE_UNIT, 1,"")
                EngineListener.NotifyDistanceUnitChanged( 1 )
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

        width: 560
        height: 552

        anchors.top: parent.top
        anchors.left: parent.left

        radiomodel: myListModelId
        focus_id: 0
        defaultValueIndex: HM.const_SETTINGS_GENERAL_DISTANCE_UNIT_DEFAULT_VALUE
        onIndexSelected:
        {
            if(!isJog)
            {
                distanceUnitMain.hideFocus()
                distanceUnitMain.setFocusHandle(0,0)
                focus_index= nIndex
                distanceUnitMain.showFocus()
            }

            if(menuSelectTimer.running)
                menuSelectTimer.restart()
            else
                menuSelectTimer.start()

        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                rootGeneral.setVisualCue(true, false, true, false)
        }

        onMovementEnded:
        {
            if(!focus_visible)
            {
                distanceUnitMain.hideFocus()
                distanceUnitMain.setFocusHandle(0,0)

                if(defaultValueIndex == currentindex)
                    focus_index = defaultValueIndex + 1
                else
                    focus_index = defaultValueIndex

                if(isShowSystemPopup == false)
                {
                    distanceUnitMain.showFocus()
                }
            }
        }
    }

    ListModel{
        id: myListModelId

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_DISTANCE_MILE")
            enable: true
        }

        ListElement{
            title_of_radiobutton: QT_TR_NOOP("STR_SETTING_GENERAL_DISTANCE_KM")
            enable: true
        }
    }

    Connections{
        target: SettingsStorage
        onChangeDistanceUnit:
        {
            //console.log("[QML][DistanceUnit]SettingsStorage.distanceUnit:"+SettingsStorage.distanceUnit)
            init()
        }
    }
}
