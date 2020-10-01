/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs

Item {
    id: container

    property int mindex: index
    property alias list: thumbnailList
    property alias model: thumbnailList.model

    ListView {
        id: thumbnailList
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: Labs.BackgroundModel { path: "~/.local/share/wallpapers/"}
        delegate: Item {
            id: thumbnail
            width: height/2
            height: thumbnailList.height
            property bool pressed: false
            Rectangle {
                anchors.fill: parent
                color: "yellow"
                opacity: active ? 0.4 : 0.0
            }
            Image {
                anchors.fill: parent
                anchors.margins: 10
                sourceSize.height: height
                fillMode: Image.PreserveAspectCrop
                source: uri
                clip: true
                asynchronous: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // set background
                    thumbnailList.model.select(index);
                    personalizeContainer.close();
                }
                onPressed: thumbnail.pressed = true
                onReleased: thumbnail.pressed = false
                onCanceled: thumbnail.pressed = false
            }
            states: [
                State {
                    name: "pressed"
                    when: thumbnail.pressed
                    PropertyChanges {
                        target: thumbnail
                        scale: 1.5
                    }
                }
            ]
            transitions: [
                Transition {
                    NumberAnimation {
                        properties: "scale"
                        duration: 250
                        easing.type: Easing.OutSine
                    }
                }
            ]
        }
    }
}
