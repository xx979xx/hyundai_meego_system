import Qt 4.7
import "DHAVN_AppClock_Main.js" as HM
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
    function calendarChanged(cur_day, cur_month, cur_year, cur_dayOfWeek)
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
      id: calendarTextDigital
      x:  clockDigital.__is_12h_type ?  HM.const_APPCLOCK_DIGITAL_TEXT_X :  HM.const_APPCLOCK_DIGITAL_TEXT_24H_X
      y: HM.const_APPCLOCK_DIGITAL_TEXT_Y
      width: clockDigital.__is_12h_type ? HM.const_APPCLOCK_DIGITAL_TEXT_WIDTH : HM.const_APPCLOCK_DIGITAL_TEXT_24H_WIDTH
      color: vehicleVariant == 1 ? HM.const_COLOR_TEXT_COMMON_GREY : HM.const_COLOR_TEXT_BRIGHT_GREY
      font.pixelSize: HM.const_APPCLOCK_PIXEL_SIZE_52
      font.family: mainScreen.fontName
      horizontalAlignment: Text.AlignRight
      text:
      {
         var data
         switch (ClockUpdate.keyTypeDateFormat)
         {
             case EnumUpdateClock.CLOCK_DATEFORMAT_YYYYMMDD_DASH:
             data = clockCalendar.yearCalendar + ". " + clockCalendar.monthCalendar +". " + clockCalendar.dayCalendar
                break;
             case EnumUpdateClock.CLOCK_DATEFORMAT_MMDDYYYY_DASH:
             data = clockCalendar.monthCalendar + ". " +  clockCalendar.dayCalendar + ". " + clockCalendar.yearCalendar
                 break;
             case EnumUpdateClock.CLOCK_DATEFORMAT_DDMMYYYY_DASH:
             data = clockCalendar.dayCalendar +". " +  clockCalendar.monthCalendar + ". " + clockCalendar.yearCalendar
                 break;
      }
      return data  //+ HM.const_APPCLOCK_SLASH + clockCalendar.dayOfWeekCalendar;
      }
    }

   Text
    {
       id: calendarDayDigital
       x: calendarTextDigital.x
       y: calendarTextDigital.y + 70
       width: clockDigital.__is_12h_type ? HM.const_APPCLOCK_DIGITAL_TEXT_WIDTH : HM.const_APPCLOCK_DIGITAL_TEXT_24H_WIDTH
       color:  vehicleVariant == 1 ? HM.const_COLOR_TEXT_SELECT_RED : HM.const_APPCLOCK_COLOR_TEXT_DAY
       font.pixelSize: HM.const_APPCLOCK_PIXEL_SIZE_36
       font.family: mainScreen.fontName
       horizontalAlignment: Text.AlignRight
       text: clockCalendar.dayOfWeekCalendar
    }

   Connections
   {
      target: ClockUpdate
      onDataDateSync:
      {
         if (clockCalendar.visible)
         {
            calendarChanged(cur_day, cur_month, cur_year, cur_dayOfWeek);
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
