import QtQuick 1.0

import "../DH" as MComp
import "../../system/DH" as MSystem

Rectangle {
    id:progress_BG
    color: colorInfo.transparent
    width: parent.width; height: 35

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    property int progressLevel: 0
    property string imgFolderSettings : imageInfo.imgFolderSettings

    signal slideReleased(int level)

    Component.onCompleted: { slider.x = 165 }

    Rectangle {
        id: container
//        anchors { bottom: parent.bottom; left: parent.left
//            right: parent.right; leftMargin: 20; rightMargin: 20
//            bottomMargin: 10
//        }
        color:colorInfo.transparent
        width: parent.width
        height: 16
        smooth: true

        Image {
            x:0; y:0
            id:progressBarBg
            height: 21
            width: parent.width
            source: imgFolderSettings+"graph_bg.png"
        }

        Image{
            x:0; y:0
            id:brSlide
            width: slider.x+32; height: 21
            source: imgFolderSettings+"graph_bar.png"
            smooth: true
        }


        Rectangle {
            width: 64; height: 130
            x:0; y:0

            id: slider
            color:colorInfo.transparent
            radius: 6
            smooth: true
                MouseArea {
                    anchors.fill: parent
                    drag.target: parent; drag.axis: Drag.XAxis
                    drag.minimumX: -24; drag.maximumX: progressBarBg.width-32

                    onClicked: {
                        progressLevel = slider.x
                    }

                    onPositionChanged: {
                        progressLevel = ((slider.x * 100) / (container.width - 28))+6
                        slideReleased(progressLevel)
                }
            }
        }
    }
}

