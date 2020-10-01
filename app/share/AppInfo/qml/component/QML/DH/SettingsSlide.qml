import QtQuick 1.0

import "../DH" as MComp
import "../../system/DH" as MSystem

Rectangle {
    id:slider_BG
    color: colorInfo.transparent
    width: parent.width; height: 91

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    property int level: 50
    property int checkX: 50
    
    property string click: "slider_cursor_n.png"
    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string visibleSetting: "false"
    signal slideReleased(int level)

    Component.onCompleted: { slider.x = 165 }

    Rectangle {
        id: container
        anchors { bottom: parent.bottom; left: parent.left
            right: parent.right; leftMargin: 20; rightMargin: 20
            bottomMargin: 10
        }
        color:colorInfo.transparent
        width: parent.width
        height: 16
        radius: 8

        smooth: true
        Image {
            source: imgFolderSettings+"slider_n.png"
            width: parent.width
        }
        MouseArea{
            anchors.fill: parent
            width: parent.width
            height: parent.height


            onClicked:{
                if(visibleSetting==true){
                bubble.visible=true
                }
                else{
                bubble.visible=false
                }

                slider.x=mouse.x-20
                level = ((slider.x * 100) / (container.width - 28))+6
                click="slider_cursor_s.png"
                slideReleased(level)
            }
        }

        Rectangle{
            id:brSlide
            y:2
            width: slider.x+32; height: 14
            radius: 6
            smooth: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: colorInfo.dimmedBlue }
                GradientStop { position: 1.0; color: colorInfo.dimmedBlue }
            }
        }

        Rectangle {
            width: 64
            height: 130
            y:-22
            x:-24

            id: slider
            color:colorInfo.transparent
            radius: 6
            smooth: true
            Image {
                id:bubble
                y:-45
                source: imgFolderSettings+"bubble.png"
                visible: false
                MComp.Label{
                    anchors.top: bubble.top
                    anchors.verticalCenter: bubble.verticalCenter
                    text: level
                    fontSize: 36
                }
            }
            Image {            
		source: imgFolderSettings+click
            }

            MouseArea {
                anchors.fill: parent
                drag.target: parent; drag.axis: Drag.XAxis
                drag.minimumX: -24; drag.maximumX: container.width-50

                onReleased:{
                    click="slider_cursor_n.png"
                    bubble.visible=false
                }

                onPositionChanged: {
                    click="slider_cursor_s.png"
                    if(visibleSetting==true){
                    bubble.visible=true
                    }
                    else{
                    bubble.visible=false
                    }

                    level = ((slider.x * 100) / (container.width - 28))+6
                    slideReleased(level)
                }
            }
        }
    }
}

