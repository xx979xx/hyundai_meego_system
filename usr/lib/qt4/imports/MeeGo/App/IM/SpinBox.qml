/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

TextEntry {
    id: input

    property int value: 0

    onValueChanged: {
        text = value
    }

    text: value

    onTextChanged: {
       value = parseInt(text);
    }

    validator: IntValidator { }


    Image {
        id: upImage
        source: "image://themedimage/images/popupbox_arrow_top"

        anchors.margins: 2
        anchors.top:  parent.top
        anchors.right: parent.right
        anchors.bottom: parent.verticalCenter
        width: height
        smooth: true

        MouseArea {
            anchors.fill: parent
            onClicked: value++
        }
    }

    Image {
        id: downImage
        source: "image://themedimage/images/popupbox_arrow_bottom"

        anchors.margins: 2
        anchors.top:  parent.verticalCenter
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: height
        smooth: true
        MouseArea {
            anchors.fill: parent
            onClicked: value--
        }
    }
}
