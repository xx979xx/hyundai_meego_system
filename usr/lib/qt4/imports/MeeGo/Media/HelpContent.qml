/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: helpContents

    anchors.fill: parent

    property alias helpHeading1: help1.heading
    property alias helpHeading2: help2.heading
    property alias helpHeading3: help3.heading
    property alias helpText1: help1.text
    property alias helpText2: help2.text
    property alias helpText3: help3.text
    property alias helpImage1: help1.image
    property alias helpImage2: help2.image
    property alias helpImage3: help3.image
    property alias helpButton1Text: help1.buttonText
    property alias helpButton2Text: help2.buttonText
    property alias helpButton3Text: help3.buttonText
    property int noContentSpacing: 10

    signal helpButton1Clicked()
    signal helpButton2Clicked()
    signal helpButton3Clicked()

    property int helpItemWidth
    property int helpItemHeight

    Flow {
        anchors.fill: parent
        HelpItem {
            id: help1
            width: helpItemWidth
            height: helpItemHeight
            landscape: window.inLandscape || window.inInvertedLandscape
            onButtonClicked: {
                helpContents.helpButton1Clicked();
            }
        }
        HelpItem {
            id: help2
            width: helpItemWidth
            height: helpItemHeight
            landscape: window.inLandscape || window.inInvertedLandscape
            onButtonClicked: {
                helpContents.helpButton2Clicked();
            }
        }
        HelpItem {
            id: help3
            width: helpItemWidth
            height: helpItemHeight
            landscape: window.inLandscape || window.inInvertedLandscape
            onButtonClicked: {
                helpContents.helpButton3Clicked();
            }
        }
    }
    states: [
        State {
            when: window.inLandscape || window.inInvertedLandscape
            PropertyChanges {
                target: helpContents
                helpItemWidth: Math.floor(helpContents.width/3)
                helpItemHeight: helpContents.height
            }
        },
        State {
            when: !(window.inLandscape || window.inInvertedLandscape)
            PropertyChanges {
                target: helpContents
                helpItemWidth: helpContents.width
                helpItemHeight: Math.floor(helpContents.height/3)
            }
        }
    ]
}
