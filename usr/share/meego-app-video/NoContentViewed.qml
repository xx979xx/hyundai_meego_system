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
    title: qsTr("You haven't viewed any videos recently")
    button1Text: qsTr("Watch a video")
    onButton1Clicked: {
        selectView("all")
    }
    help: HelpContent {
        id: help
        helpHeading1: qsTr("What are recently viewed videos?")
        helpText1: qsTr("Here you'll find the videos you watched last time you used your tablet.")
        helpHeading2: qsTr("How do I get videos?")
        helpText2: qsTr("You can download or copy videos onto your tablet. You can record videos with it too.")
        helpButton2Text: qsTr("Record a video")
        onHelpButton2Clicked: {
            appsModel.launch( "/usr/bin/meego-qml-launcher --opengl --app meego-app-camera --fullscreen")
        }
    }
    Component.onCompleted: {
        if (settings.get("ViewedOpenedBefore")) {
            help.visible = false;
        } else {
            settings.set("ViewedOpenedBefore", 1)
        }
    }
}
