/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Item {
    id: container
    width: parent.width
    height: expandBar.height
    property bool expanded: false
    property Component barContent: null
    property Component content: null
    Rectangle {
        id: expandBar
        z: 1
        color: "white"
        anchors.left: parent.left
        anchors.right: parent.right
        height: 77
        MouseArea {
            anchors.fill: parent
            onClicked: { expanded = !expanded }
        }
        Loader {
            id: barLoader
            sourceComponent: barContent
            anchors.left: parent.left
            anchors.right: expandButton.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
        Image {
            id: expandButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 10
            source: "image://theme/settings/pulldown_arrow_dn"
        }
    }
    Loader {
        id: contentLoader
        sourceComponent: content
        visible: false
        opacity: 0.0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: expandBar.bottom
    }

    states: [
        State {
            name: "expanded"
            PropertyChanges { target: container; height: expandBar.height + contentLoader.height; }
            PropertyChanges { target: expandButton; source: "image://theme/settings/pulldown_arrow_up"; }          
            PropertyChanges { target: contentLoader; visible: true; opacity: 1.0 }
            PropertyChanges { target: expandBar; color: "#eaf6fb" }
            when: expanded
        }
    ]
    transitions: [
        Transition {
            PropertyAnimation { properties: "height,opacity"; duration: 500; easing.type: Easing.InOutQuad }
        }
    ]
}
