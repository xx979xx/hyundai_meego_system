/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

//PrimaryTile - base class for standard content items in the

TileItem {
    id: fpITI
    property string imageSource
    property string imageBackground: "normal"
    property string text
    property string fallBackImage

    mouseAreaActive: true

    contents: Item {
        height: fpIconBackground.height + panelSize.primaryTileGridVSpacing
        width: fpIconBackground.width + panelSize.primaryTileGridHSpacing
        onWidthChanged: {
            fpITI.width = width
            // console.log("size: " + width+" x "+height)
        }
        // onHeightChanged: {
        //     console.log("size: " + width+" x "+height)
        // }
        TileIcon {
            id: fpIconBackground
            imageWidth: panelSize.primaryTileContentWidth
            imageHeight: panelSize.primaryTileContentHeight
            imageSource: fpITI.imageSource
            fillMode: Image.PreserveAspectCrop
            zoomImage: true
            imageBackground: fpITI.imageBackground
            fallBackImage: fpITI.fallBackImage
            // TODO: use .sci once there is support in image provider
            // (and an .sci file)
            anchors.verticalCenter: parent.verticalCenter
            imageChild: Item {
                anchors.fill: parent
                Rectangle {
                    id: shade
                    visible: fpText.visible
                    width: parent.width
                    height: panelSize.primaryTileTextHeight
                    anchors.bottom: parent.bottom
                    color: "black"
                    opacity: 0.7 // THEME
                }
                Text {
                    id: fpText
                    visible: text
                    text: fpITI.text
                    anchors.bottom: parent.bottom
                    anchors.top: shade.top
                    anchors.left: parent.left
                    anchors.leftMargin: panelSize.tileTextLeftMargin
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter
                    font.family: panelSize.fontFamily
                    font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                    color: theme.buttonFontColor //THEME - VERIFY
                    wrapMode: Text.NoWrap
                    elide: Text.ElideRight
                }
            }
        }
    }
}
