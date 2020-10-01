/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: dialog

    property alias info: label.text

    signal okClicked()

    anchors.fill: parent

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        color: theme_dialogFogColor
        opacity: theme_dialogFogOpacity
        Behavior on opacity {
            PropertyAnimation { duration: theme_dialogAnimationDuration }
        }
    }

    BorderImage {
        source: "image://theme/notificationBox_bg"
        border { top: 10; right: 10; bottom: 10; left: 10 }

        anchors.centerIn: parent
        width: idealWidth()
        height: idealHeight()

        function idealWidth()
        {
            var marging = 40;
            var maxWidth = dialog.width - marging;
            var widjetsWidth = Math.max(label.width, okButton.width) + marging;
            return Math.min(widjetsWidth, maxWidth);
        }

        function idealHeight()
        {
            var marging = 40;
            var maxHeight = dialog.height - marging;
            //multiplication for 2 is neccessary for extra space between label and button
            var widjetsHeight = label.height + label.anchors.topMargin + okButton.height + 2 * okButton.anchors.bottomMargin;
            return Math.min(widjetsHeight, maxHeight);
        }

        Text {
            id: label

            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 20
            verticalAlignment: Text.AlignHCenter
            horizontalAlignment: Text.AlignVCenter
        }

        Button {
            id: okButton

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            width: 120
            height: 40
            bgSourceUp: "image://theme/btn_blue_up"
            bgSourceDn: "image://theme/btn_blue_dn"
            text: qsTr("OK")

            onClicked: dialog.okClicked()
        }
    }
}
