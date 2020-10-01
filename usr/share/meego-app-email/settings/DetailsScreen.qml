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
import "settings.js" as Settings

Item {
    id: root
    property variant overlay: null

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
            Column {
                id: content
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                spacing: 10
                Text {
                    font.weight: Font.Bold
                    text: qsTr("Account details")
                }
                Text {
                    text: qsTr("Account: %1").arg(emailAccount.description)
                }
                Text {
                    text: qsTr("Name: %1").arg(emailAccount.name)
                }
                Text {
                    text: qsTr("Email address: %1").arg(emailAccount.address)
                }
                Item {
                    width: 1
                    height: 20
                }
                Text {
                    text: qsTr("Receiving:")
                }
                Text {
                    text: qsTr("Server type: %1").arg(Settings.serviceName(emailAccount.recvType))
                }
                Text {
                    text: qsTr("Server address: %1").arg(emailAccount.recvServer)
                }
                Text {
                    text: qsTr("Port: %1").arg(emailAccount.recvPort)
                }
                Text {
                    text: qsTr("Security: %1").arg(Settings.encryptionName(emailAccount.recvSecurity))
                }
                Text {
                    text: qsTr("Username: %1").arg(emailAccount.recvUsername)
                }
                Item {
                    width: 1
                    height: 20
                }
                Text {
                    text: qsTr("Sending:")
                }
                Text {
                    text: qsTr("Server address: %1").arg(emailAccount.sendServer)
                }
                Text {
                    text: qsTr("Port: %1").arg(emailAccount.sendPort)
                }
                Text {
                    text: qsTr("Authentication: %1").arg(Settings.authenticationName(emailAccount.sendAuth))
                }
                Text {
                    text: qsTr("Security: %1").arg(Settings.encryptionName(emailAccount.sendSecurity))
                }
                Text {
                    text: qsTr("Username: %1").arg(emailAccount.sendUsername)
                }
            }
        }
    }
    ModalMessageBox {
        id: verifyCancel
        acceptButtonText: qsTr ("Yes")
        cancelButtonText: qsTr ("No")
        title: qsTr ("Discard changes")
        text: qsTr ("You have made changes to your settings, are you sure you want to cancel?")
        onAccepted: { settingsPage.state = settingsPage.getHomescreen() }
    }
    ModalMessageBox {
        id: errorDialog
        acceptButtonText: qsTr("OK")
        showCancelButton: false
        title: qsTr("Error")
        text: qsTr("Error %1: %2").arg(emailAccount.errorCode).arg(emailAccount.errorMessage)
        onAccepted: {
            settingsPage.state = "ManualScreen";
            loader.item.message = qsTr("Sorry, we can't automatically set up your account. Please fill in account details:");
        }
    }

    // spinner overlay
    ModalSpinner { id: spinner }

    //FIXME use standard action bar here
    Rectangle {
        id: buttonBar
        anchors.bottom: parent.bottom
        width: parent.width
        height: 70
        color: "grey"
        Button {
            id: next
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 45
            anchors.margins: 10
            //color: "white"
            text: qsTr("Next")
            onClicked: {
                emailAccount.save();
                emailAccount.test();
                spinner.show();
            }
            Connections {
                target: emailAccount
                onTestSucceeded: {
                    spinner.hide();
                    settingsPage.state = "ConfirmScreen";
                }
                onTestFailed: {
                    spinner.hide();
                    errorDialog.show();
                    emailAccount.remove();
                }
            }
        }
        Button {
            anchors.left: next.right
            anchors.verticalCenter: parent.verticalCenter
            height: 45
            anchors.margins: 10
            //color: "white"
            text: qsTr("Manual Edit")
            onClicked: {
                settingsPage.state = "ManualScreen";
                loader.item.message = qsTr("Please fill in account details:");
            }
        }
        Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
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
