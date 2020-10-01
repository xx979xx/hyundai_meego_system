import QtQuick 1.0
import "DHAVN_AppClock_Main.js" as HM

Item
{
   id: clockDigital
   anchors.fill: parent

   property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
   //true- "Am" , false-"PM"
   property bool __time_am_pm: true

   //true- "12h" , false-"24h"
   property bool __is_12h_type: (!ClockUpdate.keyType12hTime)

   property int __current_hours_1: 0
   property int __current_minutes_1: 0
   property int __current_hours_2: 0
   property int __current_minutes_2: 0

   property int langId: EngineListener.GetLanguageID()

   //  time changed
   function timeChanged(cur_hour, cur_minute)
   {
      var hours = cur_hour
      var minutes = cur_minute

      if ( cur_hour == -1 ) {
          __current_hours_1 = -1
          __current_minutes_1 = -1
          __current_hours_2 = -1
          __current_minutes_2 = -1
          return;
      }

      if( hours < 12 )
      {
         __time_am_pm = true
      }
      else
      {
         __time_am_pm = false
      }

      /** Hours */

      if( (hours > 12) && clockDigital.__is_12h_type )
      {
         hours = hours - 12
      }
      else
      {
         if (hours==0)
         {
            if (clockDigital.__is_12h_type)   hours = 12
            else if (!clockDigital.__is_12h_type)  hours = 0
         }
      }

      if (hours < HM.const_APPCLOCK_TEN)
      {
         __current_hours_1 = 0
         __current_hours_2 = hours
      }
      else
      {
         if (hours < HM.const_APPCLOCK_20)
         {
            __current_hours_1 = 1
         }
         else
         {
            __current_hours_1 = 2
         }
         __current_hours_2 = hours%( HM.const_APPCLOCK_TEN * __current_hours_1 )
      }

      /** minutes */

      if (minutes < HM.const_APPCLOCK_TEN)
      {
         __current_minutes_1 = 0
         __current_minutes_2 = minutes
      }
      else
      {
         __current_minutes_1 = Math.floor( minutes/HM.const_APPCLOCK_TEN )
         __current_minutes_2 = minutes%( HM.const_APPCLOCK_TEN * __current_minutes_1 )
      }
   }

   /** bg */
   Image
   {
      id: bgDigitalClock
      anchors.fill: parent
//      source: "/app/share/images/AppStandBy/clock/bg_clock_flip.png"
      source: vehicleVariant == 1 ? "/app/share/images/AppStandBy/clock/bg_clock_digi.png" : "/app/share/images/AppStandBy/clock/bg_clock.png"
   }

//   Image
//   {
//      id: bgBoxL
//      x: HM.const_DIGITAL_X_BGBOXL
//      y: HM.const_DIGITAL_Y_BGBOXL
//      source: "/app/share/images/AppStandBy/clock/clock_flip.png" //clock_flip.png  - wait resource
//   }

   /** num */
   Image
   {
      id: hour_1
      x:  clockDigital.__is_12h_type ? HM.const_DIGITAL_HOUR1_X : HM.const_DIGITAL_HOUR1_24H_X
      y: HM.const_DIGITAL_HOUR_Y
//      anchors.left: bgBoxL.left
//      anchors.top: bgBoxL.top
//      anchors.leftMargin: HM.const_DIGITAL_HURE1_LEFT_MARGIN
//      anchors.topMargin: HM.const_DIGITAL_HURE1_TOP_MARGIN
      source: "/app/share/images/AppStandBy/clock/num/clock_num_" + __current_hours_1 + ".png"
      visible: !clockDigital.__is_12h_type ||  __current_hours_1 != 0
   }

   Image
   {
      id: hour_2
      x: HM.const_DIGITAL_HOUR2_X + hour_1.x
      y: HM.const_DIGITAL_HOUR_Y
//      anchors.left: hour_1.left
//      anchors.top: hour_1.top
//      anchors.leftMargin: HM.const_DIGITAL_HURE2_LEFT_MARGIN
      source: "/app/share/images/AppStandBy/clock/num/clock_num_" + __current_hours_2 + ".png"
   }

   Image
   {
      id: clock_colon
      x: HM.const_DIGITAL_COLON_X + hour_2.x
      y: HM.const_DIGITAL_COLON_Y
//      anchors.left: hour_2.left
//      anchors.top: hour_2.top
//      anchors.leftMargin: HM.const_DIGITAL_MINUTE1_LEFT_MARGIN
      source: "/app/share/images/AppStandBy/clock/clock_colon.png"
   }

   Image
   {
      id: minute_1
      x: HM.const_DIGITAL_MINUTE1_X + clock_colon.x
      y: HM.const_DIGITAL_HOUR_Y
//      anchors.left: hour_2.left
//      anchors.top: hour_2.top
//      anchors.leftMargin: HM.const_DIGITAL_MINUTE1_LEFT_MARGIN
      source: "/app/share/images/AppStandBy/clock/num/clock_num_" + __current_minutes_1 + ".png"
   }

   Image
   {
      id: minute_2
      x: HM.const_DIGITAL_MINUTE2_X + minute_1.x
      y: HM.const_DIGITAL_HOUR_Y
//      anchors.left: minute_1.left
//      anchors.top: minute_1.top
//      anchors.leftMargin: HM.const_DIGITAL_MINUTE2_LEFT_MARGIN
      source: "/app/share/images/AppStandBy/clock/num/clock_num_" + __current_minutes_2 + ".png"
   }

// "PM" or "AM"
   Image
   {
      id: timePM_AM
      x: 910
      y: 344
//      anchors.left: bgBoxL.left
//      anchors.top: bgBoxL.top
//      anchors.leftMargin: HM.const_DIGITAL_TEXT_AMPM_LEFT_MARGIN
//      anchors.topMargin: HM.const_DIGITAL_TEXT_AMPM_TOP_MARGIN-timePM_AM.height/2
      source: (clockDigital.__time_am_pm) ?  "/app/share/images/AppStandBy/clock/clock_am.png"
                                        :  "/app/share/images/AppStandBy/clock/clock_pm.png"
      visible: clockDigital.__is_12h_type && __current_hours_1 != -1
   }
   Loader
   {
       id: calendarDigital
       anchors.fill: parent
       source: "DHAVN_AppClock_CalendarDigital.qml"
   }

   Connections
   {
      target: ClockUpdate
      onDataTimeSync:
      {
         timeChanged(cur_hour, cur_minute);
      }
   }
   Connections
   {
       target: EngineListener
       onRetranslateUi:
           langId = language
   }
}
