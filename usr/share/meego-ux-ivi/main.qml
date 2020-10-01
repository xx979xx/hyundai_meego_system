/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Labs.IVI 0.1
import MeeGo.Components 0.1
import "home.js" as Code

Labs.Window {
    id: scene
    anchors.centerIn: parent
    showtoolbar: true
    fullscreen: false
    fullContent: true
    //width: 800
    //height: 480

    function controllerClicked(type, code, value) {
        if (type == 0x01) {
            // EV_KEY
            if (code == 0x104 && value ==1) {
                // BTN_4
                if (scene.foreground)
                    topmenu.backClicked()
                else
                    qApp.goHome()
            }
            else if (code == 0x105 && value ==1) {
                // BTN_5
                if (scene.foreground)
                    topmenu.homeClicked()
            }
            else if (code == 0x106 && value ==1) {
                // BTN_6
                if (scene.foreground) {
                    if (appwindow.state == "showScrollMenu")
                        scrollmenu.enterClicked()
                    else if (appwindow.state == "showTaskMenu")
                        taskmenu.enterClicked()
                    else
                        desktopmenu.enterClicked()
                }
            }
        }
        else if (type == 0x02) {
            // EV_REL
            if (code == 0x08 && value == -1) {
                // REL_WHEEL LEFT
                if (scene.foreground) {
                    if (appwindow.state == "showScrollMenu")
                        scrollmenu.previousClicked()
                    else if (appwindow.state == "showTaskMenu")
                        taskmenu.previousClicked()
                    else
                        desktopmenu.previousClicked()
                }
            }
            if (code == 0x08 && value == 1) {
                // REL_WHEEL RIGHT
                if (scene.foreground) {
                    if (appwindow.state == "showScrollMenu")
                        scrollmenu.nextClicked()
                    else if (appwindow.state == "showTaskMenu")
                        taskmenu.nextClicked()
                    else
                        desktopmenu.nextClicked()
                }
            }
        }

    }

    Rectangle {
        id: appwindow

        anchors.fill: parent
        anchors.topMargin: scene.statusBar.height

        state: "showDesktopMenu"

        FocusScope {
            id: mainView

            anchors.fill: parent
            //focus: true
            Keys.onPressed: {
                if (event.key == Qt.Key_Home) {
                    topmenu.homeClicked()
                }
                else if (event.key == Qt.Key_Backspace) {
                    topmenu.backClicked()
                }
                else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                    if (appwindow.state == "showScrollMenu")
                        scrollmenu.enterClicked()
                    else if (appwindow.state == "showDesktopMenu") {
                        desktopmenu.enterClicked()
                    }
                }
            }

            InputControl {
                id: inputControl
                devicePath: "/dev/input/by-id/usb-Contour_Design_ShuttleXpress-event-if00"

                onInputTriggered: controllerClicked(type, code, value)
            }

            TTSControl {
                id: ttsControl
                onIsOnChanged: {
                    topmenu.ttsToggle.on = ttsControl.isOn
                }
            }

            VoiceControl {
                id: voiceControl
                accousticModel: "/usr/share/pocketsphinx/model/hmm/en_US/hub4wsj_sc_8k"
                dictionary: "/usr/share/meego-ux-ivi/voicerecognition/meego-ux-ivi.dic"
                grammar: "/usr/share/meego-ux-ivi/voicerecognition/meego-ux-ivi.fsg"

                onIsOnChanged: {
                    topmenu.voiceToggle.on = voiceControl.isOn
                }

                onSpeechRecognized: {
                    Code.handleVoiceCommand(str)
                }
            }

            DesktopMenu {
                id: desktopmenu
                anchors.fill: parent
            }

            TopMenu {
                id: topmenu
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width
                height: 50
            }

            TaskMenu {
                id: taskmenu
                y: parent.height - 50
                width: parent.width
                height: 150
                menutitle: "Top Applications"
            }

            Rectangle {
                id: shade
                anchors.top: topmenu.bottom
                anchors.bottom: taskmenu.top
                width: parent.width
                color: "black"
                opacity: 0
            }

            AppDetail {
                id: appdetail
                x: parent.width + 5
                y: 50
                width: parent.width / 3 * 2
                height: parent.height - 100
            }

            ScrollMenu {
                id: scrollmenu
                x: (-1 * (parent.width / 3)) - 5
                y: 50
                width: parent.width / 3
                height: parent.height - 100
            }

            Item {
                id: ttsOverlay
                property alias text: ttsText.text
                property alias textColor: ttsText.color
                property alias fadeaway: animateOpacity
                width: 200
                height: 32
                anchors.top: topmenu.bottom
                anchors.right: topmenu.right
                anchors.margins: 10
                clip: true
                z: 2

                Text {
                    id: ttsText
                    anchors.fill: parent
                    wrapMode: Text.WordWrap
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: ""
                }

                PropertyAnimation {
                    id: animateOpacity
                    target: ttsText
                    properties: "opacity"
                    from: "100"
                    to: "0"
                    duration: 1000
                    easing.type: Easing.OutQuint
                }
            }
        }

        states: [
            State {
                name: "showDesktopMenu"
                PropertyChanges { target: scrollmenu; showdetail: false }
            },
            State {
                name: "showScrollMenu"
                PropertyChanges { target: scrollmenu; x: 0 }
                PropertyChanges { target: shade; opacity: 0.75 }
            },
            State {
                name: "showTaskMenu"
                PropertyChanges { target: taskmenu; y: parent.height - 150 }
                PropertyChanges { target: scrollmenu; showdetail: false }
            }
        ]

        transitions: Transition {
            NumberAnimation { properties: "x,opacity"; duration: 600; easing.type: Easing.OutQuint }
            NumberAnimation { properties: "y"; duration: 600; easing.type: Easing.OutQuint }
        }
    }
}
