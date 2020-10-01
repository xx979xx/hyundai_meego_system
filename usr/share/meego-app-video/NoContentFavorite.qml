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
    title: qsTr("You don't have any favourite videos")
    button1Text: qsTr("See all videos")
    onButton1Clicked: {
        selectView("all")
    }
    help: HelpContent {
        id: help
        helpHeading1: qsTr("What are favourites?")
        helpText1: qsTr("The place to keep the videos you like most.")
        helpHeading2: qsTr("How do I create favourites?")
        helpText2: qsTr("To add videos to your favourites, tap and hold a video you love. Then select 'Favourite'.")
        helpHeading3: qsTr("How do I get videos?")
        helpText3: qsTr("You can download or copy videos onto your tablet. You can record videos with it too.")
    }
    Component.onCompleted: {
        if (settings.get("FavoriteOpenedBefore")) {
            help.visible = false;
        } else {
            settings.set("FavoriteOpenedBefore", 1)
        }
    }
}
