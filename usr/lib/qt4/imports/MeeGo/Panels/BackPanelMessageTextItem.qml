/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

TileItem{
    //height: panelSize.secondaryTileHeight

    contents: Text {
        id: bpText
        height: bpText.paintedHeight + panelSize.contentTopMargin + panelSize.contentBottomMargin
        text: qsTr("To show items on the front of the panel select ON, to hide select OFF")
        anchors.left: parent.left
        anchors.right:  parent.right
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        font.family: panelSize.fontFamily
        font.pixelSize: panelSize.tileFontSize
        color: panelColors.tileDescTextColor
        wrapMode: Text.Wrap
    }
}



