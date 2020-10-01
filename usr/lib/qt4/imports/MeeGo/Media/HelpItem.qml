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
    id: helpItem
    property alias heading: headingText.text
    property alias text: helpText.text
    property alias image: screenshot.source
    property alias buttonText: button.text
    property bool landscape: true

    signal buttonClicked()

    Grid {
        width: parent.width
        height: parent.height
        columns: landscape ? 1 : 2
        Item {
            width: landscape ? parent.width : parent.width/2
            height: landscape ? parent.height/2 : parent.height
            Image {
                id: screenshot
                anchors.top: parent.top
                anchors.topMargin: noContentSpacing
                anchors.horizontalCenter: parent.horizontalCenter
                width: source != "" ? Math.min(sourceSize.width, parent.width - noContentSpacing) : parent.width
                height: source != "" ? Math.min(sourceSize.height, parent.height - noContentSpacing) : parent.height
                Button {
                    id: button
                    visible: text != ""
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: noContentSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        helpItem.buttonClicked();
                    }
                }
            }
        }
        Column {
            width: landscape ? parent.width : parent.width/2
            Item {
                width: parent.width
                height: 2*noContentSpacing
            }
            Text {
                id: headingText
                width: parent.width - noContentSpacing
                font.pixelSize: theme_fontPixelSizeLarge
                wrapMode: Text.WordWrap
                height: paintedHeight + noContentSpacing
            }
            Text {
                id: helpText
                width: parent.width - noContentSpacing
                font.pixelSize: theme_fontPixelSizeNormal
                wrapMode: Text.WordWrap
            }
        }
    }
}
