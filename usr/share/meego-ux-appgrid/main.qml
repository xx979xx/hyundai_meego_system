/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Labs.Components 0.1 as Labs

Window {
    id: window
    anchors.centerIn: parent
    fullScreen: true

    Labs.BackgroundModel {
        id: backgroundModel
    }

    onOrientationChanged: {
        if (bgRect.bgImage1) {
            if (window.orientation & 1)
            {
                bgRect.bgImage2 = bgImageLandscape.createObject(bgRect);
            }
            else
            {
                bgRect.bgImage2 = bgImagePortrait.createObject(bgRect);
            }
            animBG2In.start();
        }
        else
        {
            if (window.orientation & 1)
            {
                bgRect.bgImage1 = bgImageLandscape.createObject(bgRect);
            }
            else
            {
                bgRect.bgImage1 = bgImagePortrait.createObject(bgRect);
            }
            animBG1In.start();
        }
    }

    Rectangle {
        id: bgRect
        anchors.fill: parent
        z: -1
        color: "black"
        property QtObject bgImage1: null
        property QtObject bgImage2: null

        //Get around the animations complaining about null objects
        Component.onCompleted: {
            bgImage2 = dummyImage.createObject(bgRect);
        }

        Component {
            id: dummyImage
            Image {
            }
        }

        Connections {
            target: bgRect.bgImage1
            onStatusChanged: {
                if (bgRect.bgImage1.status == Image.Ready) {
                    animBG1In.start();
                }
            }
        }

        Connections {
            target: bgRect.bgImage2
            onStatusChanged: {
                if (bgRect.bgImage2.status == Image.Ready) {
                    animBG2In.start();
                }
            }
        }

        SequentialAnimation {
            id: animBG1In
            ParallelAnimation {
                NumberAnimation {
                    target: bgRect.bgImage1
                    property: "opacity"
                    to: 1.0
                    duration: 500
                }
                NumberAnimation {
                    target: bgRect.bgImage2
                    property: "opacity"
                    to: 0
                    duration: 500
                }
            }
            ScriptAction {
                script: { bgRect.bgImage2.destroy(); bgRect.bgImage2 = null; }
            }
        }

        SequentialAnimation {
            id: animBG2In
            ParallelAnimation {
                NumberAnimation {
                    target: bgRect.bgImage2
                    property: "opacity"
                    to: 1.0
                    duration: 500
                }
                NumberAnimation {
                    target: bgRect.bgImage1
                    property: "opacity"
                    to: 0
                    duration: 500
                }
            }
            ScriptAction {
                script: { bgRect.bgImage1.destroy(); bgRect.bgImage1 = null; }
            }
        }


        Component {
            id: bgImageLandscape
            Image {
                id: bgImageLPrivate
                anchors.fill: parent
                asynchronous: true
                source: backgroundModel.activeWallpaper
                fillMode: Image.PreserveAspectCrop
                opacity: 0.0

                Component.onCompleted: {
                    sourceSize.height = bgRect.height;
                    rotation = (window.orientation == 1) ? 0 : 180;
                }
            }
        }

        Component {
            id: bgImagePortrait
            Image {
                id: bgImagePPrivate
                asynchronous: true
                source: backgroundModel.activeWallpaper
                opacity: 0.0
                anchors.fill: parent
                height: bgRect.width
                width: bgRect.height
                fillMode: Image.PreserveAspectCrop

                Component.onCompleted: {
                    sourceSize.height = bgRect.width;
                    rotation = (window.orientation == 2) ? 270 : 90;
                }
            }
        }
    }

    overlayItem: Item {
        id: deviceScreen
        x: 0
        y: 0
        width: parent.width
        height: parent.height + parseInt(theme_statusBarHeight)

        StatusBar {
            anchors.top: parent.top
            width: parent.width
            height: theme_statusBarHeight
            active: window.isActiveWindow
            backgroundOpacity: theme_panelStatusBarOpacity
        }

        MainContent {
            id: gridContent
            anchors.top: parent.top
            anchors.topMargin: theme_statusBarHeight
            width: parent.width
            height: parent.height
        }
    }
}

