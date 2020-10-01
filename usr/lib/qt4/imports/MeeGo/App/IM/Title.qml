/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: titleItem

    property alias text: titleLabel.text
    property alias label: titleLabel
    property alias sublabel: subtitleLabel
    property alias subtext: subtitleLabel.text


    // the default anchoring
    anchors {
        left: parent.left
        right: parent.right
    }

    // just a default value
    height: (subtitleLabel.text == "" ? 50 : 75)

    BorderImage {
        id: titleBackground
        anchors.fill: parent

        //use big if a subtitle is present, otherwise use the small image
        source: (subtitleLabel.text == "" ?
                     "image://themedimage/widgets/common/header/header-small" :
                     "image://themedimage/widgets/common/header/header")
        border {
            left: 2
            top: 2
            right: 2
            bottom: 2
        }
    }

    Text {
        id: titleLabel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10

        font.pixelSize: theme_fontPixelSizeLarge
        color: theme_fontColorNormal
    }

    Text {
        id: subtitleLabel
        anchors.top: titleLabel.bottom
        anchors.left: parent.left
        anchors.margins: 10

        font.pixelSize: theme_fontPixelSizeSmall
        color: theme_fontColorNormal
        text:  ""
        visible:(subtitleLabel.text != "")
    }
}
