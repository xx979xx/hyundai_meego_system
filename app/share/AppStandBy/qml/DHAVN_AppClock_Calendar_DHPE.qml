import Qt 4.7
import "DHAVN_AppClock_Main_DHPE.js" as HM
import QmlClockAppClockEnum  1.0

Item
{
    id: clockCalendar

    property string dayCalendar
    property string dayOfWeekCalendar
    property string monthCalendar
    property string yearCalendar
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int langId: EngineListener.GetLanguageID()

// calendar Changed
   function calendarChanged(cur_day, cur_dayOfWeek, cur_month, cur_year)
   {
       if ( cur_day == -1 ) {
           clockCalendar.yearCalendar = "----"
           clockCalendar.monthCalendar = "--"
           clockCalendar.dayCalendar = "--"
           clockCalendar.dayOfWeekCalendar = ""
           return;
       }
        clockCalendar.yearCalendar = cur_year;
      switch (cur_dayOfWeek)
      {
         case 1:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_MON") + LocTrigger.empty
           break;
         case 2:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_TUES") + LocTrigger.empty
           break;
         case 3:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_WED") + LocTrigger.empty
           break;
         case 4:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_THUR") + LocTrigger.empty
           break;
         case 5:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_FRI") + LocTrigger.empty
           break;
         case 6:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_SAT") + LocTrigger.empty
           break;
         case 7:
           clockCalendar.dayOfWeekCalendar = qsTranslate(HM.const_APP_CLOCK_LANGCONTEXT,"STR_CLOCK_SUN") + LocTrigger.empty
           break;
      }
         clockCalendar.dayCalendar = cur_day
         clockCalendar.monthCalendar = cur_month
   }

    Text
     {
        id: calendarTextAnalog
        x: HM.const_APPCLOCK_CALENDAR_TEXT_X
        y: HM.const_APPCLOCK_CALENDAR_TEXT_Y
        width: HM.const_APPCLOCK_CALENDAR_TEXT_WIDTH
        color:  Qt.rgba(170/255, 170/255, 170/255, 1)
        font.pixelSize: 42
        font.family: HM.FONT_REGULAR
        horizontalAlignment: Text.AlignHCenter
        text: {
            var data
            switch (ClockUpdate.keyTypeDateFormat)
            {
                case EnumUpdateClock.CLOCK_DATEFORMAT_YYYYMMDD_DASH:
                data = clockCalendar.yearCalendar + ". " + clockCalendar.monthCalendar +". " + clockCalendar.dayCalendar + " " + clockCalendar.dayOfWeekCalendar
                   break;
                case EnumUpdateClock.CLOCK_DATEFORMAT_MMDDYYYY_DASH:
                data = clockCalendar.monthCalendar + ". " +  clockCalendar.dayCalendar + ". "  + clockCalendar.yearCalendar + " " + clockCalendar.dayOfWeekCalendar
                    break;
                case EnumUpdateClock.CLOCK_DATEFORMAT_DDMMYYYY_DASH:
                    data = clockCalendar.dayCalendar +". "   +  clockCalendar.monthCalendar + ". "  + clockCalendar.yearCalendar + " " + clockCalendar.dayOfWeekCalendar
                    break;
            }
              return data
         }
     }

   Connections
   {
      target: ClockUpdate
      onDataDateSync:
      {
         if (clockCalendar.visible)
         {
            calendarChanged(cur_day, cur_dayOfWeek, cur_month, cur_year);
         }
      }
   }
   Connections
   {
       target: EngineListener
       onRetranslateUi:
       {
           langId = language
       }
   }
   Component.onCompleted:
   {
   }
}
