/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import MeeGo.Settings 0.1

Item {
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: "#eaf6fb"
    }
    Flickable {
        clip: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonBar.top
        contentWidth: content.width
        contentHeight: content.height
        flickableDirection: Flickable.VerticalFlick
        Item {
            width: settingsPage.width
            ControlGroup {
                id: content
                children: [
                Item { width: 1; height: 20; },
                TextControl {
                    label: qsTr("Account description:")
                    Component.onCompleted: setText(emailAccount.description)
                    enabled: false
                    // hide this field for "other" type accounts
                    visible: emailAccount.preset != 0
                },
                TextControl {
                    id: nameField
                    label: qsTr("Your name:")
                    Component.onCompleted: setText(emailAccount.name)
                    onTextChanged: emailAccount.name = text
                },
                TextControl {
                    id: addressField
                    label: qsTr("Email address:")
                    Component.onCompleted: setText(emailAccount.address)
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly
                    onTextChanged: emailAccount.address = text
                },
                PasswordControl {
                    id: passwordField
                    label: qsTr("Password:")
                    Component.onCompleted: setText(emailAccount.password)
                    onTextChanged: emailAccount.password = text
                },
                Item { width: 1; height: 40; }
                ]
            }
        }
    }
    ModalMessageBox {
        id: verifyCancel
        acceptButtonText: qsTr ("Yes")
        cancelButtonText: qsTr ("No")
        title: qsTr ("Discard changes")
        text: qsTr ("You have made changes to your settings, are you sure you want to cancel?")
        onAccepted: {
            settingsPage.state = settingsPage.getHomescreen();
        }
    }

    //FIXME use standard action bar here
    Rectangle {
        id: buttonBar
        anchors.bottom: parent.bottom
        width: parent.width
        height: 70
        color: "grey"
        Button {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 200
            height: 45
            anchors.margins: 10
            //color: "white"
            text: qsTr("Next")
            function validate() {
                var errors = 0;
                if (nameField.text.length === 0) {
                    nameField.errorText = qsTr("This field is required");
                    errors++;
                } else {
                    nameField.errorText = "";
                }
                if (addressField.text.length === 0) {
                    addressField.errorText = qsTr("This field is required");
                    errors++;
                } else {
                    addressField.errorText = "";
                }
                if (passwordField.text.length === 0) {
                    passwordField.errorText = qsTr("This field is required");
                    errors++;
                } else {
                    passwordField.errorText = "";
                }
                return errors === 0;
            }
            onClicked: {
                if (validate()) {
                    emailAccount.applyPreset();
                    if (emailAccount.preset != 0) {
                        settingsPage.state = "DetailsScreen";
                    } else {
                        settingsPage.state = "ManualScreen";
                        loader.item.message = qsTr("Please fill in account details:");
                    }
                }
            }
        }
        Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 200
            height: 45
            anchors.margins: 10
            //color: "white"
            text: qsTr("Cancel")
            onClicked: {
                verifyCancel.show();
            }
        }
    }
}
