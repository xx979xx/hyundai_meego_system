/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.IVI 0.1
import MeeGo.Components 0.1

FocusScope {
    id: container
    clip: true

    function setName(name) {
        itemname = name
    }


    function setImage(image) {
        itemimage = image
    }

    function setComment(comment) {
        itemcomment = comment
    }

    property string itemname
    property string itemimage
    property string itemcomment

    Rectangle {
        id: content
        color: "transparent"
        smooth: true
        anchors.fill: parent; anchors.margins: 5; radius: 5

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log ("AppDetail clicked")
                scrollmenu.enterClicked()
            }
        }
    }

    Item {
        id: itemIcon
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 50
        width: 100
        height: 100

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: itemimage
        }
    }

    Text  {
        id: itemTitle
        anchors.left: itemIcon.right
        anchors.verticalCenter: itemIcon.verticalCenter
        anchors.margins: 50
        width: parent.width - x - 50
        height: 20
        wrapMode: Text.WordWrap
        color: "white"
        font.pixelSize: 24
        font.bold: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        text: itemname
    }

    Text  {
        anchors.left: parent.left
        anchors.top: itemIcon.bottom
        anchors.margins: 50
        width: parent.width - x - 50
        height: parent.height - 50
        wrapMode: Text.WordWrap
        color: "lightgrey"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignLeft
        text: itemcomment
    }
}
