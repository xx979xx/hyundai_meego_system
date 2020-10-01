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

Item {
    id: container

    property variant overlay: null

    function previousClicked() {
        pathview.incrementCurrentIndex()
    }

    function nextClicked() {
        pathview.decrementCurrentIndex()
    }

    function enterClicked() {
        if (model.get(pathview.currentIndex).name == "Panels") {
            qApp.showPanels()
        }
        else if (overlay == null) {
            overlay = spinnerOverlayComponent.createObject(appwindow)
            favorites.append(model.get(pathview.currentIndex).filename)
            qApp.launchDesktopByName(model.get(pathview.currentIndex).filename)
        }
    }

    function goToApplication(app) {
        var count = 5;
        while (model.get(pathview.currentIndex).name.toLowerCase() != app.toLowerCase() && count > 0) {
            pathview.incrementCurrentIndex()
            console.log ("increment")
            console.log (model.get(pathview.currentIndex).name)
            count--
        }
    }

    Labs.FavoriteApplicationsModel {
        id: favorites
    }

    Component {
        id: spinnerOverlayComponent
        Item {
            id: spinnerOverlayInstance
            anchors.fill: parent

            Connections {
                target: qApp
                onWindowListUpdated: {
                    spinnerOverlayInstance.destroy();
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.7
            }

            Labs.Spinner {
                anchors.centerIn: parent
                spinning: true
                onSpinningChanged: {
                    if (!spinning) {
                        spinnerOverlayInstance.destroy()
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                // eat all mouse events
            }
        }
    }

    ListModel {
        id: model

        ListElement {
            name: "Navigation"
            icon: "/usr/share/icons/hicolor/128x128/apps/navit.png"
            filename: "/usr/share/applications/navit.desktop"
        }
        ListElement {
            name: "Panels"
            icon: "/usr/share/themes/1024-600-10/icons/launchers/meego-app-panels.png"
        }
        ListElement {
            name: "Web"
            icon: "/usr/share/themes/1024-600-10/icons/launchers/meego-app-browser.png"
            filename: "/usr/share/applications/meego-app-browser.desktop"
        }
        ListElement {
            name: "Dialer"
            icon: "/usr/share/themes/meego/meegotouch/dialer/images/icons-Applications-dialer.png"
            filename: "/usr/share/applications/dialer.desktop"
        }
        ListElement {
            name: "Settings"
            icon: "/usr/share/themes/1024-600-10/icons/launchers/meego-app-settings.png"
            filename: "/usr/share/meego-ux-ivi/applications/meego-ux-settings.desktop"
        }
    }

    Rectangle {
        id: rect
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height
        color: "transparent"

        Component {
            id: delegate
            Item {
                id: scrollitem
                width: 250
                height: 120
                scale: PathView.iconScale
                visible: (appwindow.state == "showScrollMenu") ? false : true

                Rectangle {
                    id: itembackground
                    anchors.fill: parent
                    color: "lightgrey"
                    radius: 5
                    opacity: 0.2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Code.desktopMenuGrabFocus();
                            if (pathview.currentIndex != index) {
                                pathview.currentIndex = index
                            }
                            else {
                                if (name == "Panels") {
                                    qApp.showPanels()
                                }
                                else if (overlay == null) {
                                    overlay = spinnerOverlayComponent.createObject(appwindow)
                                    qApp.launchDesktopByName(filename)
                                }
                            }
                        }
                    }
                }

                Column {
                    id: wrapper
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 64; height: 64
                        source: icon
                    }
                    Text {
                        id: nameText
                        width: scrollitem.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: PathView.isCurrentItem ? "white" : "lightgrey"
                        font.pointSize: 26
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        text: name
                    }
                }
            }
        }

        PathView {
            id: pathview
            anchors.fill: parent
            focus: true
            Keys.onLeftPressed: decrementCurrentIndex()
            Keys.onRightPressed: incrementCurrentIndex()
            model: model
            delegate: delegate
            pathItemCount: 5

            path: Path {
                startX: rect.width * 0.5; startY: rect.height * 0.8
                PathAttribute { name: "iconScale"; value: 1 }
                PathQuad { x: rect.width * 0.2; y: rect.height * 0.3; controlX: rect.width * 0.2; controlY: rect.height * 0.8 }
                PathAttribute { name: "iconScale"; value: 0.5 }
                PathQuad { x: rect.width * 0.4; y: rect.height * 0.1; controlX: rect.width * 0.2; controlY: rect.height * 0.2 }
                PathAttribute { name: "iconScale"; value: 0.3 }
                PathQuad { x: rect.width * 0.6; y: rect.height * 0.1; controlX: rect.width * 0.5; controlY: rect.height * 0.1 }
                PathAttribute { name: "iconScale"; value: 0.3 }
                PathQuad { x: rect.width * 0.8; y: rect.height * 0.3; controlX: rect.width * 0.8; controlY: rect.height * 0.2 }
                PathAttribute { name: "iconScale"; value: 0.5 }
                PathQuad { x: rect.width * 0.5; y: rect.height * 0.8; controlX: rect.width * 0.8; controlY: rect.height * 0.8 }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Code.desktopMenuGrabFocus();
                }
            }

            onCurrentIndexChanged: {
                Code.textToSpeech(model.get(pathview.currentIndex).name)
            }
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            if (appwindow.state != "showDesktopMenu") {
                console.log ("MainContent - desktop has active focus")
                appwindow.state = "showDesktopMenu"
                pathview.focus = true
            }
        }
    }
}
