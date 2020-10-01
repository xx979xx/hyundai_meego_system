/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Sharing 0.1
import MeeGo.Components 0.1

ShareObj {

    id: shareContainer

    signal shareAllClicked();

    property bool shareAll: false
    property int mouseX
    property int mouseY

    function doShareAll() {
        if (shareCount == 0)
            return;
        var pos = mapToItem(topItem.topItem, mouseX, mouseY); //shareBtn.x+shareBtn.width, shareBtn.y);
        showContextTypes(pos.x, pos.y);
    }

    TopItem {
        id: topItem
    }

    Button {
        id: shareBtn
        width: 120  //TODO - theme/auto calc?
        height: 50  //TODO - theme/auto calc?
        enabled: {
            if ((shareCount != 0) || shareAll)
                return true;
            return false;
        }

        text: ((shareAll && shareCount == 0) ?
                qsTr("Share All") : qsTr("Share"))

        onClicked: {
            if (shareAll && shareCount == 0) {
                mouseX = mouse.x;
                mouseY = mouse.y;
                shareContainer.shareAllClicked();
            } else {
                var pos = mapToItem(topItem.topItem, mouse.x, mouse.y); //shareBtn.x+shareBtn.width, shareBtn.y);
                parent.showContextTypes(pos.x, pos.y);
            }
        }
    }
}
