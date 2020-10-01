/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Media 0.1

NoContent {
    title: qsTr("You don't have any unwatched videos")
    description: qsTr("Download or copy your videos onto the tablet. Connect the tablet to your computer with a USB cable, via WiFi or bluetooth.\n\nYou can also record your own videos using the tablet.")

    button1Text: qsTr("Record a video")
    onButton1Clicked: {
        appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --app meego-app-camera --fullscreen")
    }
    button2Text: qsTr("See all videos")
    onButton2Clicked: {
        selectView("all")
    }
}
