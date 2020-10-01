/**
 *
 */
import QtQuick 1.1


MouseArea
{
    width: 60
    height: 40
    visible: debugOnOff

    opacity: 0.8

    x: column * 60 + column * 2
    y: systemInfo.lcdHeight - ((row + 1) * 40) - ((0 < row) ? 2 * row : 0)


    property color boxColor: "Yellow"
    property int column: 0
    property int row: 0


    Rectangle {
        anchors.fill:parent
        color: boxColor
    }

    Text {
        anchors.fill: parent
        text: column + ", " + row
    }

    onClicked: {}
}
/* EOF */
