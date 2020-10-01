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
    title: qsTr("You haven't added any videos recently")
    description: qsTr("Download or copy your videos onto the tablet. Connect the tablet to your computer with a USB cable, via WiFi or bluetooth.\n\nYou can also record your own videos using the tablet.")
    button1Text: qsTr("Record a video")
    button2Text: qsTr("See all videos")
    onButton1Clicked: {
        appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --app meego-app-camera --fullscreen")
    }
    onButton2Clicked: {
        selectView("all")
    }
    help: HelpContent {
        id: help
        helpHeading1: qsTr("What are recently added videos?")
        helpText1: qsTr("Here you'll find the last videos you loaded onto your tablet.")
        helpHeading2: qsTr("How do I add videos?")
        helpText2: qsTr("You can download or copy videos onto your tablet. You can record videos with it too.")
    }
    Component.onCompleted: {
        if (settings.get("AddedOpenedBefore")) {
            help.visible = false;
        } else {
            settings.set("AddedOpenedBefore", 1)
        }
    }
}
