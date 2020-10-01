import Qt 4.7
import "DHAVN_AppClock_Main.js" as HM

Item
{
    id: clockOff
    anchors.fill: parent

    Rectangle
    {
       id: photo_frame_off
       anchors.fill: parent
       color: HM.const_APPCLOCK_COLOR_BLACK
    }
    Component.onCompleted:
    {
    }
}
