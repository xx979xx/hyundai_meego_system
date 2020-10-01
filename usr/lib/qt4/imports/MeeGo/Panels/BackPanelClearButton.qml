/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

TileItem {
    id: container
    separatorVisible: true
    width: parent.width
    signal clearHistClicked()
    contents: Item {
        height: bpClearButton.height + 2*panelSize.contentTopMargin
        Button {
            id: bpClearButton
            active: true
            text: qsTr("Clear history")
            font.family: panelSize.fontFamily
            font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
            maxWidth: parent.width
            anchors.bottomMargin: panelSize.contentTopMargin
            anchors.topMargin: panelSize.contentTopMargin
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                container.clearHistClicked()
            }
        }
    }
}
