/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.IM 0.1
import TelepathyQML 0.1

Item {
    id: container
    width: parent.width
    height: parent.height

    property alias radius: menu.radius
    property alias color: menu.color
    property alias menuWidth: menu.width
    property alias menuHeight: menu.height
    property alias menuX: menu.x
    property alias menuY: menu.y
    property variant model

    property alias menuOpacity: menu.opacity
    property alias fogOpacity: fog.opacity

    property variant payload
    property int itemHeight: 40
    property int fingerMode: 0

    property int fingerX: 0
    property int fingerY: 0

    property variant accountItem: accountsModel.accountItemForId(window.currentAccountId)
    Connections {
        target: accountItem
        // a small trick to trigger updates
        onChanged: container.accountItem = accountItem
    }

    onFocusChanged: inputElement.focus = true

    signal triggered(string playlist)
    signal close()

    Rectangle {
        id: fog
        anchors.fill: parent
        color: theme_dialogFogColor
        opacity: theme_dialogFogOpacity
        Behavior on opacity {
            PropertyAnimation { duration: theme_dialogAnimationDuration }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: container.close()

        Rectangle {
            id: menu
            color: theme_appMenuBackgroundColor
            radius: 40
            opacity: 0

            width: 230
            height: 150

            Behavior on opacity {
                PropertyAnimation { duration: 500 }
            }

            MouseArea {
                // prevent closing when touching the empty areas of the dialog
                anchors.fill: parent
            }

            Rectangle {
                id: finger
                parent: container
                width:Math.sqrt(2) * rect.width/2
                height:width*2
                color:"transparent"
                clip:true
                x: 0
                y: 0
                opacity:menu.opacity
                Rectangle {
                    id: rect
                    width: menu.radius
                    height: menu.radius
                    color: menu.color
                    rotation:  -45
                    transformOrigin:Item.TopLeft
                    y: finger.height/2
                }
            }

            Column {
                id: contextContent
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                Text {
                    id: statusLabel
                    text: qsTr("Change your picture:")
                    font.bold: true
                }

                Button {
                    id: takePictureButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Take picture")
                    width: 180
                    height: 40
                }
                Button {
                    id: choosePictureButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Choose picture")
                    width: 180
                    height: 40
                }
            }

            states: [
                State {
                    name: "left"
                    when: container.fingerMode == 0
                    PropertyChanges {
                        target: finger
                        x: fingerX+3
                        y: fingerY - finger.height/2
                    }
                },
                State {
                    name: "right"
                    when: container.fingerMode == 1
                    PropertyChanges {
                        target: finger
                        x: fingerX -finger.width -3 // there is a gap, don't know exactly why
                        y: fingerY - finger.height/2
                         rotation: 180
                    }
                },
                State {
                    name: "top"
                    when: container.fingerMode == 2
                    PropertyChanges {
                        target: finger
                        x: fingerX + (finger.width-finger.height)/2
                        y: fingerY + (finger.width -finger.height)/2
                        rotation: 90

                    }
                },
                State {
                    name: "bottom"
                    when: container.fingerMode == 3
                    PropertyChanges {
                        target: finger
                        x: fingerX  + (finger.width-finger.height)/2
                        y: fingerY  +(finger.width -finger.height)/2 - finger.width -2
                        rotation: 270

                    }
                }
            ]

        }
    }
}
