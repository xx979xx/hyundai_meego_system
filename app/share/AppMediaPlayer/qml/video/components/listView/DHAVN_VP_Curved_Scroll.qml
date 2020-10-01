// { modified by Sergey 08.05.2013
import Qt 4.7
import QtQuick 1.1

Image
{
    id: image1

    source: "/app/share/images/general/scroll_menu_bg.png"
    mirror: east

    property real verticalOffset: 0
    property real coverage: 0
    property real pageSize: 0 // added by wspark 2013.02.19 for ISV 73445
    property bool east: false

    Item
    {
        clip: true
        width: image1.width
	//modified by aettie.ji 20130925 ux fix
        height: (image1.height*coverage) >= 80 ? (image1.height*coverage) : 80
        y: image1.height*verticalOffset

        Image
        {
            id: image2
            anchors.horizontalCenter: image1.horizontalCenter
            y: - image1.height*verticalOffset
            source: "/app/share/images/general/scroll_menu.png"
            mirror: east
        }
    }
}
// } modified by Sergey 08.05.2013