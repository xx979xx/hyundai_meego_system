import QtQuick 1.0
import "DHAVN_AppClock_Main_DHPE.js" as HM

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
   property bool powerStatus : EngineListener.getPowerOff()

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
   Rectangle
   {
      id: bgDigitalClock
      anchors.fill: parent
      color: "black"
   }

   /** num */
   Text {
       id: hour_1
       x: (powerStatus == false) ? (clockDigital.__is_12h_type ? HM.const_DIGITAL_HOUR1_X : HM.const_DIGITAL_HOUR1_24H_X)
                                  : (clockDigital.__is_12h_type ? 406 : 447)
       y: (powerStatus == false) ? HM.const_DIGITAL_HOUR_Y : 318+38-67 +8
       width: (powerStatus == false) ? HM.const_DIGITAL_WIDTH : 77
       height: (powerStatus == false) ? 112 : 134
       verticalAlignment: Text.AlignVCenter
       horizontalAlignment: Text.AlignHCenter
       text: __current_hours_1
       color:  Qt.rgba(170/255, 170/255, 170/255, 1)
       font.pixelSize: (powerStatus == false) ? 112 : 134
       font.family: HM.FONT_BOLD
       visible: !clockDigital.__is_12h_type || __current_hours_1 != 0
   }

   Text {
       id: hour_2
       x: (powerStatus == false) ? HM.const_DIGITAL_HOUR2_X + hour_1.x
                                  : 77+10 + hour_1.x
       y: (powerStatus == false) ? HM.const_DIGITAL_HOUR_Y : 318+38-67 +8
       width: (powerStatus == false) ? HM.const_DIGITAL_WIDTH : 77
       height: (powerStatus == false) ? 112 : 134
       verticalAlignment: Text.AlignVCenter
       horizontalAlignment: Text.AlignHCenter
       text: __current_hours_2
       color:  Qt.rgba(170/255, 170/255, 170/255, 1)
       font.pixelSize: (powerStatus == false) ? 112 : 134
       font.family: HM.FONT_BOLD
   }

   Image
   {
      id: clock_colon
      x: (powerStatus == false) ? HM.const_DIGITAL_COLON_X + hour_2.x
                                : 77+16 + hour_2.x
      y: (powerStatus == false) ? HM.const_DIGITAL_COLON_Y : 318
      source: (powerStatus == false) ? "/app/share/images/AppStandBy/clock_DHPE/clock_colon.png"
                                     : "/app/share/images/AppStandBy/clock_DHPE/clock_off_colon.png"
   }

   Text {
       id: minute_1
       x: (powerStatus == false) ? HM.const_DIGITAL_MINUTE1_X + clock_colon.x
                                 : 42 + clock_colon.x
       y: (powerStatus == false) ? HM.const_DIGITAL_HOUR_Y : 318+38-67 +8
       width: (powerStatus == false) ? HM.const_DIGITAL_WIDTH : 77
       height: (powerStatus == false) ? 112 : 134
       verticalAlignment: Text.AlignVCenter
       horizontalAlignment: Text.AlignHCenter
       text: __current_minutes_1
       color:  Qt.rgba(170/255, 170/255, 170/255, 1)
       font.pixelSize: (powerStatus == false) ? 112 : 134
       font.family: HM.FONT_BOLD
   }

   Text {
       id: minute_2
       x: (powerStatus == false) ? HM.const_DIGITAL_MINUTE2_X + minute_1.x
                                 : 77+10 + minute_1.x
       y: (powerStatus == false) ? HM.const_DIGITAL_HOUR_Y : 318+38-67 +8
       width: (powerStatus == false) ? HM.const_DIGITAL_WIDTH : 77
       height: (powerStatus == false) ? 112 : 134
       verticalAlignment: Text.AlignVCenter
       horizontalAlignment: Text.AlignHCenter
       text: __current_minutes_2
       color:  Qt.rgba(170/255, 170/255, 170/255, 1)
       font.pixelSize: (powerStatus == false) ? 112 : 134
       font.family: HM.FONT_BOLD
   }

// "PM" or "AM"
   Text {
       id: timePM_AM
       x: (powerStatus == false) ? HM.const_DIGITAL_AMPM_X + minute_2.x
                                 : 77+9 + minute_2.x
       y: (powerStatus == false) ? HM.const_DIGITAL_AMPM_Y : 318 + 38 +37 - 19
       text: (clockDigital.__time_am_pm) ? "AM" : "PM"
       height: font.pixelSize
       color:  Qt.rgba(170/255, 170/255, 170/255, 1)
       font.pixelSize: (powerStatus == false) ? 32 : 38
       font.family: HM.FONT_REGULAR
       verticalAlignment: Text.AlignVCenter
       horizontalAlignment: Text.AlignLeft
       visible: clockDigital.__is_12h_type && __current_hours_1 != -1
   }

   Loader
   {
       id: calendarDigital
       anchors.fill: parent
       source:  "DHAVN_AppClock_Calendar_DHPE.qml"
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

       onSignalPower:
       {
           powerStatus = EngineListener.getPowerOff()
       }
   }
}
