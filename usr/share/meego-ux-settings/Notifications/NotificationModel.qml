/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Settings 0.1

ListModel {
    ListElement {
        name: "App Update"
        type: "app.update"
    }
    ListElement {
        name: "New IM"
        type: "im"
    }
    ListElement {
        name: "Bluetooth Device Disconnected"
        type: "bluetooth.devicedisconnected"
    }
    ListElement {
        name: "New Email"
        type: "email.arrived"
    }
    ListElement {
        name: "Social Web Friend Request"
        type: "social.friendrequest"
    }
    ListElement {
        name: "Download Completed"
        type: "transfer.complete"
    }
}
