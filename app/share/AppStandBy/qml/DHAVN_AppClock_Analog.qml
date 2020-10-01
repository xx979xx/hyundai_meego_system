import Qt 4.7
import "DHAVN_AppClock_Main.js" as HM

Item
{
    id: clockAnalog
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property string __current_hours: "01"
    property string __current_minutes: "01"
    property int langId: EngineListener.GetLanguageID()

//  time changed
    function timeChangedAnalog(cur_hour, cur_minute)
    {
       var hours = cur_hour
       var minutes = cur_minute

       if ( cur_hour == -1 ) {
           __current_hours = "01"
           __current_minutes = "01"
           return;
       }

       /** hours */
       if (hours >= HM.const_APPCLOCK_TWELVE)
       {
          hours = hours - HM.const_APPCLOCK_TWELVE
       }

       hours = hours*HM.const_APPCLOCK_ANALOG_SHIFT_HOUR + Math.floor( minutes/HM.const_APPCLOCK_TWELVE ) + 1

       if (hours < HM.const_APPCLOCK_TEN)
       {
          __current_hours = HM.const_APPCLOCK_ZERO + hours
       }
       else
       {
          __current_hours = hours
       }

       /** minutes */
       minutes = minutes + 1
       if ( minutes == 0 )
           __current_minutes = "_0060_60"
       else if (minutes < HM.const_APPCLOCK_TEN)
       {
          __current_minutes = HM.const_APPCLOCK_ZERO + minutes
       }
       else
       {
          __current_minutes = minutes
       }
    }

    anchors.fill: parent

// background
    Image
    {
       id: bgImage
       anchors.fill: parent
       source: "/app/share/images/AppStandBy/clock/bg_clock.png"
       visible: parent.visible
    }

//analog clock
    Image
    {
       id: analogClock;
       x: langId == 20 ? HM.const_APPCLOCK_ANALOG_BG_ME_X : HM.const_APPCLOCK_ANALOG_BG_CALENDAR_X
       y: HM.const_APPCLOCK_ANALOG_BG_Y
       source: "/app/share/images/AppStandBy/clock/clock_analog.png"
    }

    Image
    {
       id: minuteImage
       anchors.left: analogClock.left
       anchors.top: analogClock.top
       anchors.leftMargin: 2
       anchors.topMargin: 3
       source: "/app/share/images/AppStandBy/clock/minute/clock_minute_" + __current_minutes + ".png"
    }

    Image
    {
       id: hourImage
       anchors.left: analogClock.left
       anchors.top: analogClock.top
       anchors.leftMargin: 2
       anchors.topMargin: 3
       source: "/app/share/images/AppStandBy/clock/hour/clock_hour_" + __current_hours + ".png"
    }

    Image
    {
       id: light
       anchors.left: analogClock.left
       anchors.top: analogClock.top
       anchors.leftMargin: vehicleVariant == 2 ? 241 + 2 : 202 + 2
       anchors.topMargin: vehicleVariant == 2 ? 208 : 202 + 3
       source: "/app/share/images/AppStandBy/clock/clock_center.png"
    }

    Loader
    {
        id: calendarAnalog
        anchors.fill: parent
        source:  "DHAVN_AppClock_CalendarAnalog.qml"
    }


    Connections
    {
       target: ClockUpdate
       onDataTimeSync:
       {
          clockAnalog.timeChangedAnalog(cur_hour, cur_minute);
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
