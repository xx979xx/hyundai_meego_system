/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: container
    anchors.fill: parent
    property variant desktop
    property variant overlay: null

    TopItem {
        id: topItem
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
            Spinner {
                anchors.centerIn: parent
                spinning: true
                onSpinningChanged: {
                    if (!spinning)
                    {
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
        id: iconBackground
        anchors.centerIn: iconItem
        width: iconItem.width
        height: iconItem.height
        radius: 10
        opacity: selected ? 0.5 : 0.0
        color: validPosition ? "green" : "red"
    }
    Connections {
        target:  parent
        onClicked: {
            if (overlay == null)
            {
                overlay = spinnerOverlayComponent.createObject(container);
                overlay.parent = topItem.topItem;

                if (desktop.filename == "/usr/share/meego-ux-appgrid/virtual-applications/meego-app-panels.desktop")
                {
                    qApp.showPanels();
                }
                else
                {
                    appsModel.favorites.append(desktop.filename);
                    qApp.launchDesktopByName(desktop.filename);
                }
            }
        }
    }
    Image {
        id: iconItem
        width: 100
        height:  100
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        source: desktop.icon
    }
    Rectangle {
        anchors.top: iconItem.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        height: labelItem.height + 10
        width: labelItem.paintedWidth + 20
        color: theme_iconFontBackgroundColor
        radius: 5
        opacity: theme_iconFontBackgroundOpacity
    }
    Text {
        id: labelItem
        anchors.top: iconItem.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        height: 20
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme_iconFontColor
        font.pixelSize: theme_iconFontPixelSize
        font.bold: true
        smooth: true
        text: desktop.title
        style: Text.Raised 
        styleColor: theme_iconFontDropshadowColor
    }

    onWidthChanged: {
        if (labelItem.paintedWidth > width - 30)
            labelItem.width = width - 30;
    }
}
