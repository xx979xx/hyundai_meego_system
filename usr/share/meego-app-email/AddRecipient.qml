/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.App.Email 0.1


BorderImage {
    id: container
    property EmailRecipientEntry recipients
    property string label

    border.top: 10
    border.bottom: 10
    border.left: 10
    border.right: 10

    anchors.verticalCenter: parent.verticalCenter

    source: "image://theme/email/btn_addperson"

    Component {
        id: contactsPicker

        Labs.ContactsPicker {
            onContactSelected: {
                for (var count = 0; count < contact.emails.length; ++count) {
                    recipients.model.append({"name":"", "email":contact.emails[count].emailAddress});
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            var picker = contactsPicker.createObject (container);
            //: The contact (e-mail recipient) picker title.
            picker.promptString = qsTr ("Select \"%1\" recipient").arg(label);
            picker.show ();
        }
    }
}
