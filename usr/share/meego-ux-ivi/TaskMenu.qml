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

FocusScope {
    id: container
    clip: true

    signal raise(int windowId)
    signal close(int windowId)

    property variant overlay: null
    property alias menutitle: display.text

    function backClicked() {
        console.log ("TaskMenu - backClicked()")
        Code.desktopMenuGrabFocus();
    }

    function taskClicked() {
        console.log ("TaskMenu - taskClicked()")
        Code.desktopMenuGrabFocus();
    }

    function enterClicked() {
        qApp.click()
    }

    Rectangle { width: parent.width; height: parent.height; color: "black" }

    Rectangle { id: seperator; width: parent.width; height: 1; color: "#D1DBBD" }

    Rectangle {
        y: 1; width: parent.width; height: 20
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3E606F" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Rectangle {
        y: parent.height - 20; width: parent.width; height: 20
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#3E606F" }
            GradientStop { position: 0.0; color: "transparent" }
        }
    }

    Text {
        id: display
        width: parent.width - 100
        anchors.top: seperator.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        elide: Text.ElideRight
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: (appwindow.state == "showTaskMenu") ? true : false
    }

    Image {
        id: showtaskbutton
        width: 48
        height: 48
        source: "/usr/share/themes/1024-600-10/icons/ivi/open.png"
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        visible: (appwindow.state == "showTaskMenu") ? false : true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Code.taskMenuGrabFocus();
            }
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

    GridView {
        id: appView
        anchors.fill: parent; anchors.topMargin: 50; anchors.bottomMargin: 0
        cellWidth: 100; cellHeight: 100
        flow: GridView.TopToBottom
        focus: true
        model: favorites

        KeyNavigation.up: desktopmenu

        delegate: Item {
            id: dinstance
            width: GridView.view.cellWidth; height: GridView.view.cellHeight

            Rectangle {
                id: content
                color: "transparent"
                smooth: true
                anchors.fill: parent
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                radius: 5

                Rectangle { id: itemColor;  color: "black"; anchors.fill: parent; anchors.margins: 2; radius: 5; smooth: true }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (overlay == null) {
                            overlay = spinnerOverlayComponent.createObject(appwindow)
                            qApp.launchDesktopByName(filename)
                        }
                    }
                }
/*
                Item {
                    id: closeIcon
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: 20
                    height: 20
                    property variant image: ""

                    Image {
                        anchors.centerIn: parent
                        source: parent.image
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(dinstance.activeFocus && GridView.view.currentIndex == index) {
                                qApp.closeDesktopByName(filename)
                            }   
                        }
                    }
                }
*/
                Item {
                    id: itemIcon
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: parent.height - 40

                    Image {
                        anchors.centerIn: parent
                        width: 80
                        height:  80
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        source: icon
                    }
                }

                Text  {
                    id: itemTitle
                    width: parent.width - 10
                    elide: Text.ElideRight
                    color: "darkgrey"
                    font.pixelSize: 14
                    anchors.bottom: content.bottom
                    anchors.horizontalCenter: content.horizontalCeter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: title
                }
            }
/*
            states: State {
                name: "active"; when: dinstance.activeFocus
                PropertyChanges { target: content; color: "white"; scale: 1.1 }
                PropertyChanges { target: itemColor; color: "grey";}
                PropertyChanges { target: itemTitle; color: "white" }
                PropertyChanges { target: closeIcon; image: "images/close.png" }
            }

            transitions: Transition {
                NumberAnimation { properties: "scale"; duration: 100 }
            }
*/
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            if (appwindow.state != "showTaskMenu") {
                console.log ("TaskMenu - taskmenu has active focus")
                appwindow.state = "showTaskMenu"
                console.log ("TaskMenu - appwindow.state = showTaskMenu")
            }
        }
    }
}
