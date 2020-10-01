/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import MeeGo.Sync 0.1

BorderImage {
    id: syncListData
    source: "image://theme/settings/btn_settingentry_up"
    border.left: 5
    border.right: 5
    border.top: 5
    border.bottom: 5

    property bool pressed: false

    height: {
        Math.max(serviceIcon.height, serviceLabel.height, scheduledStatus.height, arrowRight.height)
    }

    width: parent.width

    Theme {
        id: theme
    }

    Component {
        id: syncDetails

        AppPage {
            id: syncDetailsPage
            anchors.fill: parent
            pageTitle: model.storage

//            onSearch: {
//                    console.log("application search query: " + needle)
//            }

            SyncDetails {
                id: fnord
                icon:     model.image
                storage:  model.storage
                service:  model.displayName
                name:     model.name
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            addPage(syncDetails);
        }

        onPressed:  parent.pressed = true
        onReleased: parent.pressed = false
    }

    Item {
        id: serviceIcon
        height: theIcon.height + 10
        width: theIcon.width + 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Image {
            id: theIcon
            source: image
            anchors.centerIn: serviceIcon
        }
    }

    Text {
        id: serviceLabel
        anchors.verticalCenter: parent.verticalCenter
        x: 110  // Force alignment of all service labels

        color: themefontColorNormal
        font.pixelSize: theme.fontPixelSizeNormal

        //: Arg 1 is the sync service name (e.g. "Yahoo!") and arg 2 is the storage name (e.g. "Contacts" or "Calendar".
        text: qsTr("%1 %2").arg(displayName).arg(storage)
    }

    Item {
        id: scheduledStatus
        height: scheduledIcon.height + 10
        width: scheduledIcon.width + 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: arrowRight.left

        Image {
            id: scheduledIcon
            anchors.centerIn: parent
            source: active ? "image://theme/btn_tickbox_dn" : ""
        }
    }

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


    states: [
        State {
            name: "pressed"
            when: syncListData.pressed
            PropertyChanges {
                target: syncListData
                source: "image://theme/settings/btn_settingentry_dn"
            }
        }
    ]
}
