/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import QtMultimediaKit 1.1

Item {
    id: colorstripContainer

    signal createdColorbars(string colorbarPath)

    MouseArea {
        anchors.fill: parent
        onClicked: {
            colorstripContainer.destroy()
        }
    }

    Rectangle {
        id: preview

        anchors.top: parent.top
        width: parent.width
        height: parent.height * 2 / 3

        color: "black"

        clip: true

        Labs.PaintSpy {
            id: paintspy

            anchors.fill: parent
            delayMS: 100

            onColorsCaptured: {
                row.colors = list
            }

            Component.onCompleted: {
                function updateRect() {
                    var tlpoint = mapToItem(scene, highlight.x, highlight.y)
                    var brpoint = mapToItem(scene, highlight.x + highlight.width,
                                            highlight.y + highlight.height)

                    if (scene.orientation == 0) {  // right up
                        paintspy.setRegion(scene.width - brpoint.y, tlpoint.x,
                                           highlight.height, highlight.width)
                    }
                    else if (scene.orientation == 1) {  // top up
                        paintspy.setRegion(tlpoint.x, tlpoint.y,
                                           highlight.width, highlight.height)
                    }
                    else if (scene.orientation == 2) {  // left up
                        paintspy.setRegion(tlpoint.y, scene.height - brpoint.x,
                                           highlight.height, highlight.width)
                    }
                    else {  // top down
                        paintspy.setRegion(scene.width - brpoint.x, scene.height - brpoint.y,
                                           highlight.width, highlight.height)
                    }
                }

                highlight.xChanged.connect(updateRect)
                highlight.yChanged.connect(updateRect)
                highlight.widthChanged.connect(updateRect)
                highlight.heightChanged.connect(updateRect)
                camera.xChanged.connect(updateRect)
                camera.yChanged.connect(updateRect)
                updateRect()
            }

            Camera {
                id: camera

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                width: Math.max(parent.height, parent.width)
                height: width
            }
     }

        // T T T   top lowlight
        // L H R   left, right lowlight + "highlight" area in center
        // B B B   bottom lowlight

        Item {
            id: highlight

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            width: if (colorstripContainer.width < colorstripContainer.height) {
                return colorstripContainer.width / 4
            }
            else {
                return colorstripContainer.height / 4
            }

            height: width
        }

        Rectangle {  // top lowlight
            anchors.top: parent.top
            anchors.bottom: highlight.top
            width: parent.width

            color: "black"
            opacity: 0.5
        }

        Rectangle {  // bottom lowlight
            anchors.top: highlight.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            color: "black"
            opacity: 0.5
        }

        Rectangle {  // left lowlight
            anchors.top: highlight.top
            anchors.bottom: highlight.bottom
            anchors.left: parent.left
            anchors.right: highlight.left

            color: "black"
            opacity: 0.5
        }

        Rectangle {  // right lowlight
            anchors.top: highlight.top
            anchors.bottom: highlight.bottom
            anchors.left: highlight.right
            anchors.right: parent.right

            color: "black"
            opacity: 0.5
        }
    }

    Row {
        id: row

        anchors.top: preview.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        property variant colors: [ "#101040", "#3030c0", "#181860", "#202080" ]

        Repeater {
            id: bars

            model: 4

            Rectangle {
                width: parent.width / 4
                height: parent.height

                color: row.colors[index]
            }
        }

        IconButton {
            anchors.centerIn: parent

            icon: "image://theme/camera/camera_lens_sm_up"
            iconDown: "image://theme/camera/camera_lens_sm_dn"

            onClicked: {
                // always create in portrait so the vertical bars will scale/crop right
                var w = screenWidth < screenHeight ? screenWidth: screenHeight
                var h = screenWidth < screenHeight ? screenHeight : screenWidth
                var path = paintspy.saveFile("/tmp", w, h, row.colors)
                createdColorbars(path)
                colorstripContainer.destroy()
            }
        }
    }
}
