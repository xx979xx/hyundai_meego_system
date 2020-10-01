/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

TileItem {
    id: fpITI
    property string imageSource
    property string imageBackground: "item"
    property bool zoomImage: false
    property bool hasImage: true
    property string fallBackImage: ""
    property variant fillMode: Image.PreserveAspectCrop

    mouseAreaActive: true

    contents: Item {
        id: tileImage
        visible: hasImage
        height: icon.height + panelSize.secondaryTileGridVSpacing
        width: icon.width + panelSize.secondaryTileGridHSpacing
        onWidthChanged: {
            fpITI.width = width
            // console.log("size: " + width+" x "+height)
        }
        // onHeightChanged: {
        //     console.log("size: " + width+" x "+height)
        // }
        TileIcon {
            id: icon
            imageHeight: panelSize.secondaryIconImageSize
            imageWidth: panelSize.secondaryIconImageSize
            imageSource: fpITI.imageSource
            imageBackground: fpITI.imageBackground
            fillMode: fpITI.fillMode
            zoomImage: fpITI.zoomImage
            fallBackImage: fpITI.fallBackImage
        }
    }
}
