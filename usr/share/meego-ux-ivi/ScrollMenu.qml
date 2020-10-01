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

    property variant overlay: null
    property bool showdetail: false
    property string selectedappname: ""
    property string selectedappfilename: ""
    property alias currentIndex: appsView.currentIndex

    function backClicked() {
        console.log ("ScrollMenu - backClicked()")
        if (appsModel.isRoot()) {
            appsView.currentIndex = 0
            showdetail = false
            Code.desktopMenuGrabFocus();
        }
        else {
            appsModel.setRootIndexToParent()
            showdetail = false
            appsView.currentIndex = 0
        }
    }

    function homeClicked() {
        console.log ("ScrollMenu - homeClicked()")
        if (appsModel.isRoot() && appsView.currentIndex == 0) {
            showdetail = false
            Code.desktopMenuGrabFocus();
        }
        else {
            appsModel.setRootIndex("")
            appsView.currentIndex = 0
            showdetail = false
        }
    }

    function previousClicked() {
        if (appsView.currentIndex == 0)
            appsView.currentIndex = appsView.count - 1
        else
            appsView.decrementCurrentIndex()
    }

    function nextClicked() {
        if (appsView.currentIndex == appsView.count - 1)
            appsView.currentIndex = 0
        else
            appsView.incrementCurrentIndex()
    }

    function enterClicked() {
        if (!showdetail && appsModel.getChildCount(appsView.currentIndex) > 0) {
            appsModel.setRootIndex(container.selectedappname)
            appsView.currentIndex = 0
        }
        else if (showdetail && container.selectedappfilename != "") {
            if (overlay == null) {
                overlay = spinnerOverlayComponent.createObject(appwindow)
                favorites.append(container.selectedappfilename)
                qApp.launchDesktopByName(container.selectedappfilename)
                container.close()
            }
        }
    }

    function close() {
        appsModel.setRootIndex("")
        container.showdetail = false
        Code.desktopMenuGrabFocus()
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

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            id: seperator
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 5
            height: parent.height

            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: "lightsteelblue" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        MenuModel {
            id: appsModel
            type: "Application"
            directories: [
                "/usr/share/meego-ux-ivi/applications",
                "/usr/share/applications",
                "~/.local/share/applications"
            ]

            onAppsChanged: {
               appsModel.setRootIndex("")
               container.showdetail = false
            }
        }

        Component {
            id: appsDelegate
            Item {
                width: appsView.width; height: appsView.height / 5
                focus: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //container.forceActiveFocus()
                        if (appsView.currentIndex != index) {
                            container.showdetail = false
                            appsView.currentIndex = index
                        }
                        if (!filename && appsModel.getChildCount(index) > 0) {
                            appsModel.setRootIndex(name)
                            appsView.currentIndex = 0
                        }
                    }
                }

                Item {
                    id: labelItem
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: parent.width - 60
                    height: parent.height

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 25
                        anchors.rightMargin: 5
                        height: 20
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WordWrap
                        color: "white"
                        font.pointSize: ListView.isCurrentItem ? 12 : 10
                        font.bold: ListView.isCurrentItem ? true : false
                        smooth: true
                        text: name
                    }
                }

                Image {
                    anchors.left: labelItem.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    fillMode: Image.PreserveAspectFit
                    source: icon
                    visible: {
                        if (!ListView.isCurrentItem || filename == "") {
                            return true
                        }
                        return false
                    }
                }

                Rectangle {
                    anchors.left: labelItem.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    radius: 10
                    color: "lightgrey"
                    visible: {
                        if (!ListView.isCurrentItem || filename == "") {
                            return false
                        }
                        return true
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "black"
                        font.pointSize: 10
                        smooth: true
                        text: "OPEN"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (overlay == null) {
                                overlay = spinnerOverlayComponent.createObject(appwindow)
                                favorites.append(filename)
                                qApp.launchDesktopByName(filename)
                                container.close()
                            }
                        }
                    }
                }
            }
        }

        Component {
            id: appHighlight
            Rectangle {
                radius: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: "lightsteelblue" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        ListView {
            id: appsView
            anchors.fill: parent
            model: appsModel
            delegate: appsDelegate
            highlight: appHighlight
            highlightMoveSpeed: 1000
            highlightMoveDuration: 100
            focus: true
            KeyNavigation.right: desktopmenu

            onCurrentIndexChanged: {
                Code.textToSpeech(appsModel.getNameByIndex(currentIndex))
                container.selectedappname = appsModel.getNameByIndex(currentIndex)
                if (appsModel.getFileNameByIndex(currentIndex) != "") {
                    if(!container.showdetail) {
                        container.showdetail = true
                    }
                    appdetail.setImage(appsModel.getIconByIndex(currentIndex))
                    appdetail.setName(appsModel.getNameByIndex(currentIndex))
                    appdetail.setComment(appsModel.getCommentByIndex(currentIndex))
                    container.selectedappfilename = appsModel.getFileNameByIndex(currentIndex)
                }
            }
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            if (appwindow.state != "showScrollMenu") {
                console.log ("ScrollMenu - scrollmenu has active focus")
                Code.textToSpeech(appsModel.getNameByIndex(currentIndex))
                appwindow.state = "showScrollMenu"

                if (appsModel.getFileNameByIndex(currentIndex) != "") {
                    if(!container.showdetail) {
                        container.showdetail = true
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "showAppDetail"
            when: showdetail == true
            PropertyChanges { target: appdetail; x: appwindow.width / 3 }
        }
    ]
}
