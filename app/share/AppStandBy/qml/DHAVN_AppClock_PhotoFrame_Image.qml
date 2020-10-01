import Qt 4.7
import "DHAVN_AppClock_Main.js" as HM

Item
{
    id: clockImage
    anchors.fill: parent
//    property string pathImage:  ClockUpdate.getKeyPathImage()

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Image
    {
       id: imagePhotoFrame
       width: parent.width
       height: parent.height
       fillMode: Image.PreserveAspectFit
       source: ClockUpdate.keyPathImage
//       source: pathImage
    }
    Component.onCompleted:
    {
    }
}
