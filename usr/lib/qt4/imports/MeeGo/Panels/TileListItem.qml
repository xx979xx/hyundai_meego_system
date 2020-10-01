/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

//TileListItem - base class for standard list items in the
//panel - this contains standard visual properties that are common


TileItem {
    id: fpITI
    property string imageSource
    property string imageBackground: "empty"
    property string text: ""
    property string description: ""
    property bool zoomImage: false
    property bool hasImage: true
    property string fallBackImage: ""
    property variant fillMode: Image.Stretch

    mouseAreaActive: true

    contents: Row {
        height: tileImage.height
        width: parent.width
        TileIcon {
            id: tileImage
            visible: hasImage
            imageHeight: panelSize.tileListIconImageSize
            imageWidth: panelSize.tileListIconImageSize
            anchors.verticalCenter: parent.verticalCenter
            imageBackground: fpITI.imageBackground
            imageSource: fpITI.imageSource
            fillMode: fpITI.fillMode
            zoomImage: fpITI.zoomImage
            fallBackImage: fpITI.fallBackImage
        }
        Item {
            visible: hasImage
            width: panelSize.tileTextLeftMargin
            height: parent.height
        }
        Text {
            id: fpText
            text: fpITI.text + (fpITI.description && fpITI.text ? ", ":"")
            onTextChanged: {
                if (paintedWidth > parent.width - panelSize.tileTextLeftMargin - tileImage.width) {
                    elide = Text.ElideRight
                    width: parent.width - panelSize.tileTextLeftMargin - tileImage.width
                }
            }
            font.family: panelSize.fontFamily
            font.pixelSize: panelSize.tileFontSize
            color: panelColors.tileMainTextColor
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.NoWrap
        }
        Text {
            id: fpDesc
            text: fpITI.description
            width: parent.width - panelSize.tileTextLeftMargin - tileImage.width - fpText.width
            font.family: panelSize.fontFamily
            font.pixelSize: panelSize.tileFontSize
            color: panelColors.tileDescTextColor
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
}
