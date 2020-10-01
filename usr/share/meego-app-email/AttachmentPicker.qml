/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

BorderImage {
    id: attachmentPickerButton

    property Component pickerComponent
    property alias pickerLabel: thePickerLabel.text
    property string pickerImage

    source: "image://theme/settings/btn_settingentry_up"
    border.left:   5
    border.right:  5
    border.top:    5
    border.bottom: 5

    width:  parent.width
    height: Math.max(pickerIcon.height, pickerLabel.height, arrowRight.height)

    MouseArea {
        anchors.fill: parent

        onClicked: {
            addPicker(pickerComponent);
        }
    }

    Rectangle {
        id: pickerIcon

        // @todo We create an opaque rectangle to make the inverted
        //       (light on transparent) images we're using visible.
        //       Remove this rectangle when more suitable images are available.

        color: "lightblue"
        height: 50
        width: 60
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10

        Image {
            id: theIcon
            anchors.centerIn: parent
            source: pickerImage
        }
    }

    Text {
        id: thePickerLabel
        anchors.verticalCenter: parent.verticalCenter
        x: 90  // Force alignment of all picker labels

        color: theme.fontColorNormal
        font.pixelSize: theme.fontPixelSizeNormal
        text: pickerLabel
    }

    // @todo This doesn't work because the Picker hasn't been created yet!
//    Image {
//        id: contentModelCount
//        anchors.right: arrowRight.left
//        anchors.rightMargin:10
//        anchors.verticalCenter: parent.verticalCenter
//        width: 50
//        fillMode: Image.Stretch
//        source: "image://themedimage/widgets/apps/email/accounts-unread"

//        Text {
//            id: text
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.horizontalCenter: parent.horizontalCenter
//            verticalAlignment: Text.AlignVCenter
//            text: pickerComponent.model.count
//            font.pixelSize: theme.fontPixelSizeMedium
//            color: theme.fontColorNormal
//        }
//    }

    Item {
        id: arrowRight
        height: rightIcon.height + 10
        width:  rightIcon.width + 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        Image {
            id: rightIcon
            anchors.centerIn: parent
            source: "image://theme/arrow-right"
        }
    }
}
