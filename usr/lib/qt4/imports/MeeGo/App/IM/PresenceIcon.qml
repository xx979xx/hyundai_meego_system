/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import TelepathyQML 0.1

Item {
    height:  12
    width: 12
    property int status: 0

    onStatusChanged: {
        iconImage.source = iconImage.statusIcon(status);
    }

    Image {
        id: iconImage
        height: parent.height
        width: parent.width
        source: statusIcon(parent.status)
        anchors.verticalCenter: parent.verticalCenter
        smooth: true

        function statusIcon(type) {
            var icon
            switch (type) {
            case TelepathyTypes.ConnectionPresenceTypeAvailable:
                icon = "image://themedimage/widgets/apps/contacts/contact-available";
                break;
            case TelepathyTypes.ConnectionPresenceTypeBusy:
                icon = "image://themedimage/widgets/apps/contacts/contact-busy";
                break;
            case TelepathyTypes.ConnectionPresenceTypeAway:
            case TelepathyTypes.ConnectionPresenceTypeExtendedAway:
                icon = "image://themedimage/widgets/apps/contacts/contact-idle";
                break;
            case TelepathyTypes.ConnectionPresenceTypeHidden:
            case TelepathyTypes.ConnectionPresenceTypeUnknown:
            case TelepathyTypes.ConnectionPresenceTypeError:
            default:
                icon = "";
                break;
            }
            return icon;
        }
    }
}
