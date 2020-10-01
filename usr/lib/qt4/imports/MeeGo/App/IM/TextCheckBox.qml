/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: textCheckBox

    property alias checked: checkBox.isChecked
    property alias text: textLabel.text
    property alias font: textLabel.font
    property alias color: textLabel.color

    height: checkBox.height
    width: checkBox.width + textLabel.width

    Row {
        anchors.fill: parent
        spacing: 10
        CheckBox {
            id: checkBox
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: textLabel
            anchors.margins: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: textCheckBox.checked = !textCheckBox.checked
    }
}
