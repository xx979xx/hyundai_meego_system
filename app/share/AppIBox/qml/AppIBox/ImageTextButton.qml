import QtQuick 1.0
import "DRSPopUp.js" as DRSPopUp

Item
{
    id: container
    property string text: ""
    property string img_n: ""
    property string img_p: ""
    property bool bPressed: false
    signal clicked()
    signal buttonStateChanged( bool pressed );
    width: 121
    height: 73

    MouseArea
    {
        id: mouse_area
        x: 0
        y: 0
        width: container.width
        height: container.height
        anchors.fill: parent
        onClicked:
        {
            container.clicked()
        }

        onPressed:
        {
            bPressed = true
            container.buttonStateChanged( bPressed )
        }

        onExited:
        {
            bPressed = false
            container.buttonStateChanged( bPressed )
        }

        onReleased:
        {
            bPressed = false
            container.buttonStateChanged( bPressed )
        }
    }

    Image
    {
        id: image
        width: container.width
        height: container.height
        anchors.fill: parent
        source: container.img_n
    }

    Text
    {
        id: text
        text: container.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: DRSPopUp.const_COLOR_TEXT_BRIGHT_GREY
        font.pixelSize: DRSPopUp.const_APP_IBOX_FONT_SIZE_TEXT_30PT
        font.family: "DH_HDB"
        anchors.fill: parent
        anchors.centerIn: parent
    }

    states: [
        State
        {
            name: "pressed"; when: ( bPressed )
            PropertyChanges { target: image; source: container.img_p }
        },
        State
        {
            name: "normal"; when: ( bPressed == false )
            PropertyChanges { target: image; source: container.img_n }
        }
    ]
}
