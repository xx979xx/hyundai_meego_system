/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item
{
    id:container

    property alias title: titleText.text
    property alias message: msgText.text
    property alias cancelText: cancelButton.text
    property alias okText: okButton.text

    signal dialogResponse(bool accepted);

    anchors.fill: parent
    visible:false

    Rectangle {
	id:fog
	anchors.fill: parent
	color: theme_dialogFogColor
	opacity:theme_dialogFogOpacity
        Behavior on opacity {
            PropertyAnimation { duration: theme_dialogAnimationDuration }
	}
        MouseArea
        {
            anchors.fill: parent
        }
    }
    BorderImage {
        id: dialog
        width: 360
        height: 200
        border.top: 50
        source: "image://theme/notificationBox_bg"
        anchors.centerIn: parent
        //	x: (screenWidth - width)/2
        //	y: (screenHeight - height)/2
        Column {
            id: contentColumn
            width: parent.width
            spacing: 10
            anchors { top: dialog.top; topMargin: 20 }
            anchors { left: dialog.left; leftMargin: 30 }

            Text {
                id:titleText
                //anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Confirm Dialog")
                width: parent.width - 30
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.Bold
                font.pixelSize: theme_fontPixelSizeLarge
                color:theme_fontColorInactive
            }
            Text {
                id:msgText
                //anchors { top: titleText.bottom; topMargin:20 }
                //anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Are you sure?")
                font.pixelSize:theme_fontPixelSizeLarge
                color: theme_fontColorInactive
                height: 60
                width: 300
                wrapMode: Text.Wrap
            }

            Row {
                id: buttonRow
                //anchors { bottom: contentColumn.bottom; bottomMargin: 20;left: parent.left }
                //anchors.leftMargin: (parent.width - cancelButton.width - okButton.width - buttonRow.spacing)/2

                //width: parent.width
                spacing: 20
                height: 50

                Button {
                    id: okButton
                    width: 140
                    height: 45
                    text: qsTr("OK")
                    font.pixelSize: theme_fontPixelSizeLarge
                    onClicked: {
                        container.visible=false
                        container.dialogResponse(true);
                    }
                }
                Button {
                    id: cancelButton
                    width: 140
                    height: 45
                    text: qsTr("Cancel")
                    font.pixelSize: theme_fontPixelSizeLarge
                    onClicked: {
                        container.visible=false
                        dialog.dialogResponse(false)
                    }
                }
            }
        }
    }
}
