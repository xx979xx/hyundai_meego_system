/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

//SecondaryTile - base class for standard content items in the

TileItem {
    id: fpITI
    property string imageSource
    property string imageBackground: "empty"
    property bool imageVisible: true
    property Component imageChildComponent
    property string text
    property Component descriptionComponent
    property bool zoomImage: false
    property string fallBackImage: ""
    property variant fillMode: Image.PreserveAspectCrop

    mouseAreaActive: true

    contents: Row {
        height: tileImage.height
        TileIcon {
            id: tileImage
            imageBackground: fpITI.imageBackground
            imageSource: fpITI.imageSource
            fillMode: fpITI.fillMode
            zoomImage: fpITI.zoomImage
            imageHeight: panelSize.secondaryIconImageSize
            imageWidth: panelSize.secondaryIconImageSize
            fallBackImage: fpITI.fallBackImage
        }
        Item {
            id: leftMargin
            width: panelSize.tileTextLeftMargin
            height: parent.height
        }
        Column {
            width: fpITI.width - tileImage.width - leftMargin.width
            Item {
                id: topMargin
                width: 1
                height: panelSize.tileTextTopMargin
            }
            Text {
                id: fpText
                text: fpITI.text
                font.family: panelSize.fontFamily
                font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                color: panelColors.tileMainTextColor //THEME - VERIFY
                width: parent.width
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }
            Loader {
                id: descContent
                sourceComponent: descriptionComponent
                width: parent.width
                height: fpITI.height - topMargin.height - fpText.height - bottomMargin.height
            }
            Item {
                id: bottomMargin
                width: 1
                height: panelSize.tileTextTopMargin
            }
        }
    }
}
