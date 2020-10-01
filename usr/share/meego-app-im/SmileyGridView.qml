/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.IM 0.1

Item {
    id: container

    width: 318
    height: 318

    signal smileyClicked(string sourceName)

    GridView {

        anchors.top: parent.top
        anchors.left: parent.left

        width: 200
        height: 200


        model: SmileyModel {}
        delegate: smileyDelegate

        cellHeight: 65
        cellWidth: 65
        Component {
            id: smileyDelegate

            Item {
                width: 65
                height: 65

                Image {
                    id: smileyButton

                    source: "/usr/share/themes/" + theme_name + "/" + model.source

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            container.smileyClicked("/usr/share/themes/" + theme_name + "/" + model.source);
                        }
                    }
                }
            }
        }
    }
}
