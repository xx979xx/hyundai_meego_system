
import QtQuick 1.0
import "../DH" as MComp
import "../../system/DH" as MSystem

Rectangle {
    MSystem.ColorInfo { id: colorInfo }

    width: 300; height: 300
    property int valuenum: 0
    color: colorInfo.transparent

    MComp.Label {
        //y:331-98
        //x:210

        width:225+434; height: 32
        fontColor: colorInfo.brightGrey
        fontSize: 64
        text: valuenum
    }
    Rectangle {
        id: container
        anchors { bottom: parent.bottom; left: parent.left
            right: parent.right; leftMargin: 20; rightMargin: 20
            bottomMargin: 10
        }
        height: 16

        radius: 8
        opacity: 0.7
        smooth: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: "gray" }
            GradientStop { position: 1.0; color: "white" }
        }

        Rectangle {
            id: slider
            x: 1; y: 1; width: 30; height: 14
            radius: 6
            smooth: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#424242" }
                GradientStop { position: 1.0; color: "blue" }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -16 // Increase mouse area a lot outside the slider
                drag.target: parent; drag.axis: Drag.XAxis
                drag.minimumX: 2; drag.maximumX: container.width - 32
                onReleased: valuenum = slider.x * 100 / (container.width - 34)
            }
        }
    }
}
//! [0]
