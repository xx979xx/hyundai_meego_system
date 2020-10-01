/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import "home.js" as Code

FocusScope {
    id: container
    clip: true

    property variant ttsToggle: ttstogglebutton
    property variant voiceToggle: voicetogglebutton
    property string voicecmd

    function backClicked() {
        console.log ("TopMenu - backClicked()")
        if (appwindow.state == "showScrollMenu") {
            console.log ("in state showScrollMenu")
            scrollmenu.backClicked()
        }

        if (appwindow.state == "showTaskMenu") {
            console.log ("in state showTaskMenu")
            taskmenu.backClicked()
        }
    }

    function homeClicked() {
        console.log ("TopMenu - homeClicked()")
        if (appwindow.state == "showScrollMenu") {
            console.log ("in state showScrollMenu")
            scrollmenu.homeClicked()
        }
        else {
            Code.scrollMenuGrabFocus();
        }
    }

    function enterClicked() {
        if (appwindow.state == "showScrollMenu") {
            scrollmenu.enterClicked()
        }
        else if (appwindow.state == "showTaskMenu") {
            taskmenu.enterClicked()
        }
    }

    Rectangle { width: parent.width; height: parent.height; color: "black" }

    Rectangle { id: seperator; anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#D1DBBD" }

    Image {
        id: backbutton
        width: 48
        height: 48
        source: "/usr/share/themes/1024-600-10/icons/ivi/back.png"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        MouseArea {
            anchors.fill: parent
            onClicked: backClicked()
        }
    }

    Image {
        id: homebutton
        width: 48
        height: 48
        source: "/usr/share/themes/1024-600-10/icons/ivi/home.png"
        anchors.left: backbutton.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        MouseArea {
            anchors.fill: parent
            onClicked: homeClicked()
        }
    }


    Rectangle {
        id: ttstoggle
        anchors.left: homebutton.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        width: 150
        height: 40
        color: "transparent"
        clip: true

        Image {
            id: ttslabel
            width: 48
            height: 48
            source: "/usr/share/themes/1024-600-10/icons/ivi/text-to-speech.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        ToggleButton {
            id: ttstogglebutton
            anchors.left: ttslabel.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 1
            labelColorOn: "black"
            labelColorOff: "black"
            on: ttsControl.isOn
            onToggled: {
                ttsControl.setIsOn(isOn)
            }
        }
    }

    Rectangle {
        id: voicetoggle
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 150
        height: 40
        color: "transparent"
        clip: true

        Image {
            id: voicelabel
            width: 48
            height: 48
            source: "/usr/share/themes/1024-600-10/icons/ivi/voice-recognition.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        ToggleButton {
            id: voicetogglebutton
            anchors.left: voicelabel.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 1
            labelColorOn: "black"
            labelColorOff: "black"
            on: voiceControl.isOn
            onToggled: {
                voiceControl.setIsOn(isOn)
            }
        }
    }
}
