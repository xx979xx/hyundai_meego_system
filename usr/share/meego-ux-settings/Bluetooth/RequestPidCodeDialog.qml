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
    signal replyRequestPidCode(string reply)
    property string deviceName
    property string replyValue: legacyPair ? "" : Math.floor(Math.random()*999999)
    property bool legacyPair: false

    width: parent.width
    spacing: 2
    Text {
        id: textlabel
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Enter the following code on %1").arg(deviceName)
        width: parent.width
        height: 30
    }

    MeeGo.TextEntry {
        id: textInputField
        width: parent.width
        text: replyValue

    }

    MeeGo.Button {
        id: acceptButton
        anchors.left: parent.left
        width: parent.width
        height: 50
        text: qsTr("Accept")
        onClicked: {
            console.log(deviceName + " replying with key: " + textInputField.text)
            replyRequestPidCode(textInputField.text);
        }
    }

    ///we do this because this property is actually set post onCompleted:
    onLegacyPairChanged: {
        console.log("legacy pair? " + legacyPair)
        if(!legacyPair) {
            replyRequestPidCode(textInputField.text);
            console.log(deviceName + " replying with key: " + replyValue)
        }
    }

   /* states: [
        State{
            when: legacyPair
            PropertyChanges {
                target: acceptButton
                visible: true
            }
            PropertyChanges {
                target: textInputField
                textInput.readOnly: false
            }
            PropertyChanges {
                target: textlabel
                text: qsTr("Enter the PIN code for %1").arg(deviceName)
            }
        }
    ] */

}
