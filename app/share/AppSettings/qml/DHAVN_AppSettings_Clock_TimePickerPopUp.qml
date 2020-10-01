import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.settings.defines 1.0
import AppEngineQMLConstants 1.0
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import "DHAVN_AppSettings_General.js" as HM

DHAVN_AppSettings_FocusedItem{
    id: root

    signal closePopUp(bool isYesPressed, int popup_type)

    x:0; y:0; width: 1280; height: 720

    //anchors.fill: parent
    property string dayOfWeekCalendar:""
    //property string titleForPopup:""

    name: "TimePickerPopupPopUp"
    default_x: 0
    default_y: 0

    function showPopUp( )
    {
        TimeInfo.initTimeInfo(UIListener.getCurrentScreen())
        timepicker.focus_index = 0
        EngineListener.setTimePickerPopupStatus(true)
    }

    PopUpTimePicker{
        id: timepicker

        amPMModel:myAmPmModel
        buttons:buttonModel
        btwentyFourh: (SettingsStorage.timeType == 1)? true : false

        year_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_YEAR")) + LocTrigger.empty
        month_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_MONTH")) + LocTrigger.empty
        day_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_DAY")) + LocTrigger.empty
        am_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_AM")) + LocTrigger.empty
        pm_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_PM")) + LocTrigger.empty
        hour_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_HOUR")) + LocTrigger.empty
        minute_text:qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_MINUTE")) + LocTrigger.empty

        z: 10000

        property int focus_x: 0
        property int focus_y: 0
        property string name: "PopUpTimePicker"
        focus_id: 0

        onBtwentyFourhChanged:
        {
            TimeInfo.initTimeInfo(UIListener.getCurrentScreen())
        }
    }

    Connections{
        target:timepicker
        onUpdateCurrentTime:
        {
            //console.log("hanuk: year:"+year+", month:"+month+", day:"+day+",hour:"+hour+",minute:"+minute+",am_pm:"+am_pm)

            var nAmPm = 0
            var nHour = -1
            nHour = hour

            if(SettingsStorage.timeType == APP.const_SETTINGS_CLOCK_TIME_24HR)
            {
                if(nHour >= 12)
                    nAmPm = 1
                else
                    nAmPm = 0

                if(nHour > 12)
                    nHour = hour-12

                EngineListener.SetSystemTime(year,month,day,nHour,minute,nAmPm)
            }
            else
            {
                EngineListener.SetSystemTime(year,month,day,nHour,minute,am_pm)
            }

            EngineListener.setTimePickerPopupStatus(false)

            TimeInfo.initTimeInfo(UIListener.getCurrentScreen())
            closePopUp(true, Settings.SETTINGS_TIME_PICKER_POPUP)
        }

        onCloseBtnClicked:
        {
            EngineListener.setTimePickerPopupStatus(false)
            closePopUp(false, Settings.SETTINGS_TIME_PICKER_POPUP)
        }

        onVisibleChanged:
        {
            if(visible)
            {
                focus_index = 0
            }
        }
    }

    Connections{
        target: TimeInfo

        onTimeUpdated:
        {
            if(screen != UIListener.getCurrentScreen())
                return

            var nHour = -1
            nHour = hour

            if(SettingsStorage.timeType == APP.const_SETTINGS_CLOCK_TIME_24HR) // Display to 24hr
            {
                timepicker.setCurrentTime(year, month, day, timeType, nHour, minute)
                timepicker.focus_index = 0
            }
            else // Display to 12hr
            {
                if(timeType == APP.const_SETTINGS_CLOCK_TIME_24HR) // pm
                {
                    if(hour != 12)
                    {
                        nHour = hour - 12;
                    }
                }

                if (hour == 0)
                {
                    nHour = 12;
                }

                timepicker.setCurrentTime(year, month, day, timeType, nHour, minute)
                timepicker.focus_index = 0
            }
            //console.log("year:"+year+", month:"+ month+", day:"+day+", timeType:"+timeType+", nHour:"+nHour+", minute:"+minute)

            //root.titleForPopup = "" + year +"-" + month +"-"+ day +" " + root.dayOfWeekCalendar
            //timepicker.updateTimePickerTitle(root.titleForPopup)
        }
    }


    ListModel{
        id: buttonModel

        ListElement{
            msg: QT_TR_NOOP("STR_POPUP_OK")
            btn_id: "OkId"
        }
        ListElement{
            msg: QT_TR_NOOP("STR_POPUP_CANCEL")
            btn_id: "CancelId"
        }
    }


    ListModel{
        id: myAmPmModel
        ListElement{
            text: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_AM")
        }
        ListElement{
            text: QT_TR_NOOP("STR_SETTING_GENERAL_CLOCK_PM")
        }
    }

    Connections {
        target: LocTrigger

        onRetrigger: {
            timepicker.amPMModel = buttonModel
            timepicker.amPMModel = myAmPmModel
        }
    }
}
