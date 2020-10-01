/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1 as MeeGo

Column {
    width: parent.width
    signal replyRequestPasskey(int reply)
    property string deviceName
    spacing: 2
    Text {
        id: textlabel
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Enter passcode to use:")
        width: parent.width
    }

    MeeGo.TextEntry {
        id: textInput
        width: parent.width
        textInput.inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhDigitsOnly | ImhNoPredictiveText
        textInput.inputMask: "999999"
    }

    MeeGo.Button {
        id: acceptButton
        anchors.left: parent.left
        width: parent.width
        height: 50
        text: qsTr("Accept")
        onClicked: {
            nearbyDevicesModel.replyRequestPasskey(textInput.text);
        }
    }
}
