/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Item {
    // email address
    property string emailAddress: ""
    property string givenName: ""
    property bool known: givenName != ""
    property bool added: true;

    width: left.width + middle.width + right.width
    height: 35

    signal clicked

    Image {
        id: left
        width: 10
        height: 35
        source: "image://theme/email/btn_person_left"
    }

    Image {
        id: middle
        anchors.left: left.right
        width: content.width
        height: 35
        source: "image://theme/email/btn_person_middle"

        Text {
            id: content
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (known) {
                    return givenName;
                } else {
                    return emailAddress;
                }
            }
        }
    }

    Image {
        id: right
        anchors.left: middle.right
        height: 35
/*
        source: added? "image://theme/email/btn_person_right_added" : "image://theme/email/btn_person_right_add"
*/
        source: "image://theme/email/btn_person_right"
    }

    MouseArea {
        anchors.fill: parent

        onClicked: { parent.clicked (); }
    }
}
