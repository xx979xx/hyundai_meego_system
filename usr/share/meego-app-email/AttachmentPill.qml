/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

Item {
    id: pill

    property string uri: ""
    property string name: "test"
    property int mX: 0
    property int mY: 0

    signal longPress (string uri, int mouseX, int mouseY);

    width: leftImage.width + centreImage.width + rightImage.width
    height: centreImage.height

    TopItem { id: topItem }

    onUriChanged: {
        name = uri.slice (uri.lastIndexOf ('/') + 1);
    }

    Image {
        id: leftImage
        anchors.left: parent.left
        source: "image://theme/email/btn_attachment_left"
    }

    Image {
        id: centreImage
        anchors.left: leftImage.right
        width: text.width
        fillMode: Image.TileHorizontally
        source: "image://theme/email/btn_attachment_middle"

        Text {
            id: text
            anchors.verticalCenter: parent.verticalCenter
            text: name
            font.pixelSize: theme.fontPixelSizeMedium
            color: theme.fontColorNormal
        }
    }

    Image {
        id: rightImage
        anchors.right: parent.right
        source: "image://theme/email/btn_attachment_right"
    }

    MouseArea {
        anchors.fill: parent

        onPressAndHold: {
            var map = mapToItem(topItem.topItem , mouseX, mouseY);
            mX = map.x;
            mY = map.y;
            pill.longPress (uri, mX, mY);
        }
    }
}
