/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: avatar

    property bool active: true
    property alias source: avatarImage.source
    property alias noAvatarImage: noAvatar.source

    width: childrenRect.width
    height:  parent.height

    Image {
        id: avatarImage

        anchors.fill: avatarItem

        fillMode: Image.PreserveAspectFit

        visible: (source != ""? true : false)
        onStatusChanged: {
            if(status == Image.Error) {
                avatarImage.visible = false;
            }
        }
    }

    Item {
        id: avatarItem
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 2
        width: height
    }

    BorderImage {
        id: avatarBorder

        anchors.fill: avatarImage

        visible: avatarImage.visible

        source: (active ?
                     "image://themedimage/widgets/common/avatar/avatar-shadow" :
                     "image://themedimage/widgets/common/avatar/avatar-inactive-overlay")
    }

    BorderImage {
        id: noAvatar
        anchors.fill: avatarImage
        source: "image://themedimage/widgets/common/avatar/avatar-default"
        visible: !avatarImage.visible
    }
}
