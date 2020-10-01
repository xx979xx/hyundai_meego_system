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

    Flickable {
        clip: true
        anchors.fill: parent
        contentWidth: content.width
        contentHeight: content.height
        flickableDirection: Flickable.VerticalFlick
        Column {
            id: content
            width: settingsPage.width
            spacing: 2
            Text {
                font.pixelSize: theme.fontPixelSizeLarge
                font.weight: Font.Bold
                //color: "white"
                text: qsTr("Account set up successfully!")
            }
            Subheader { text: qsTr("Accounts") }
            Repeater {
                model: accountSettingsModel
                delegate: AccountExpandobox {}
                Component.onCompleted: accountSettingsModel.reload();
            }
            Image {
                source: "image://theme/pulldown_box"
                anchors.left: parent.left
                anchors.right: parent.right
                height: 77
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 45
                    width: 300
                    //font: "Droid Sans"
                    //color: "white"
                    text: qsTr("Done")
                    onClicked: settingsPage.returnToEmail()
                }
            }
            Column {
                spacing: 10
                width: parent.width
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: theme.  fontPixelSizeMedium
                    font.weight: Font.Bold
                    //color: "white"
                    text: qsTr("Set up another account?")
                }
                WelcomeButtons {}
            }
        }
    }
}
