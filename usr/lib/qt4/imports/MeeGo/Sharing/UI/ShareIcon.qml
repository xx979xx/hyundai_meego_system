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
    width: shareImg.width
    height: shareImg.height

    id: shareContainer

    signal shareAllClicked();

    property bool shareAll: false
    property int mouseX
    property int mouseY

    function doShareAll() {
        if (shareCount == 0)
            return;
        var pos = mapToItem(topItem.topItem, mouseX /*shareImg.x+shareImg.width*/, mouseY /*shareImg.y*/);
        showContextTypes(pos.x, pos.y);
    }

    TopItem {
        id: topItem
    }

    IconButton {
        id: shareImg
        icon: "image://themedimage/images/media/icn_share_up"
        iconDown: "image://themedimage/images/media/icn_share_dn"

        anchors.top: parent.top
        anchors.left: parent.left

        enabled: {
            if ((shareCount != 0) || shareAll)
                return true;
            return false;
        }

        onClicked: {
            if (shareAll && shareCount == 0) {
                shareContainer.mouseX = mouse.x;
                shareContainer.mouseY = mouse.y;
                shareContainer.shareAllClicked();
            } else {
                var pos = mapToItem(topItem.topItem, mouse.x /*shareImg.x+shareImg.width*/, mouse.y /*shareImg.y*/);
                parent.showContextTypes(pos.x, pos.y);
            }
        }
    }
}
