import Qt 4.7
import "DHAVN_AppClock_Main_DHPE.js" as HM

Item
{
    id: clockAnalog
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property string __current_hours: "60"
    property string __current_minutes: "60"
    property int langId: EngineListener.GetLanguageID()
    property bool powerStatus : EngineListener.getPowerOff()

//  time changed
    function timeChangedAnalog(cur_hour, cur_minute)
    {
       var hours = cur_hour
       var minutes = cur_minute

       if ( cur_hour == -1 ) {
           __current_hours = "60"
           __current_minutes = "60"
           return;
       }

       /** hours */
       if (hours >= HM.const_APPCLOCK_TWELVE)
       {
          hours = hours - HM.const_APPCLOCK_TWELVE
       }

       hours = hours*HM.const_APPCLOCK_ANALOG_SHIFT_HOUR + Math.floor( minutes/HM.const_APPCLOCK_TWELVE )

       if (hours < HM.const_APPCLOCK_TEN)
       {
          __current_hours = HM.const_APPCLOCK_ZERO + hours
       }
       else
       {
          __current_hours = hours
       }

       /** minutes */
       minutes = minutes
       if ( minutes == 0 )
           __current_minutes = "60"
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
    Rectangle
    {
       id: bgImage
       anchors.fill: parent
       color: "black"
    }

//analog clock
    Image
    {
       id: analogClock;
       x: (powerStatus == false) ? HM.const_APPCLOCK_ANALOG_BG_X : 457
       y: (powerStatus == false) ? HM.const_APPCLOCK_ANALOG_BG_Y : 144
       source: (powerStatus == false) ? "/app/share/images/AppStandBy/clock_DHPE/clock_analog.png"
                                      : "/app/share/images/AppStandBy/clock_DHPE/clock_off_analog.png"
    }

    Image
    {
       id: minuteImage
       anchors.left: analogClock.left
       anchors.top: analogClock.top
       source: (powerStatus == false) ? "/app/share/images/AppStandBy/clock_DHPE/minute/clock_minute_" + __current_minutes + ".png"
                                      : "/app/share/images/AppStandBy/clock_DHPE/minute/clock_off_minute_" + __current_minutes + ".png"
    }

    Image
    {
       id: hourImage
       anchors.left: analogClock.left
       anchors.top: analogClock.top
       source: (powerStatus == false) ? "/app/share/images/AppStandBy/clock_DHPE/hour/clock_hour_" + __current_hours + ".png"
                                      : "/app/share/images/AppStandBy/clock_DHPE/hour/clock_off_hour_" + __current_hours + ".png"
    }

    Image
    {
       id: center
       anchors.left: analogClock.left
       anchors.top: analogClock.top
       anchors.leftMargin: (powerStatus == false) ? 141 : 169
       anchors.topMargin: (powerStatus == false) ? 141 : 169
       source: (powerStatus == false) ? "/app/share/images/AppStandBy/clock_DHPE/clock_center.png"
                                      : "/app/share/images/AppStandBy/clock_DHPE/clock_off_center.png"
    }

    Loader
    {
        id: calendarAnalog
        anchors.fill: parent
        source:  "DHAVN_AppClock_Calendar_DHPE.qml"
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

        onSignalPower:
        {
            powerStatus = EngineListener.getPowerOff()
        }
    }
    Component.onCompleted:
    {
    }
}
