/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import "home.js" as Code

FocusScope {
    id: container

    function previousClicked() {
        desktopContent.previousClicked()
    }

    function nextClicked() {
        desktopContent.nextClicked()
    }

    function enterClicked() {
        desktopContent.enterClicked()
    }

    function goToApplication(app) {
        desktopContent.goToApplication(app)
    }

    Item {
        anchors.fill: parent

        Rectangle {
            id: background
            anchors.fill: parent
            color: "black"

            Labs.BackgroundModel {
                id: backgroundModel
            }

            Image {
                id: backgroundImage
                anchors.fill: parent
                source: "/usr/share/themes/1024-600-10/backgrounds/ivi/wallpaper.png"
                onSourceChanged: {
                    sourceSize.width = parent.width;
                    sourceSize.height = 0;
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log ("Desktop clicked")
                        Code.desktopMenuGrabFocus();
                    }
                }
            }
        }

        MainContent {
            id: desktopContent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: parent.height - 100
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            if (appwindow.state != "showDesktopMenu") {
                console.log ("DesktopMenu - desktop has active focus")
                appwindow.state = "showDesktopMenu"
            }
        }
    }
}
