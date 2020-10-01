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

Item {
    id: container

    anchors.fill: parent
    anchors.margins: 20

    property string icon
    property string storage
    property string service
    property string name
    property string username
    property string password    
    property variant theLoginDialog: null


    FuzzyDateTime {
        id: fuzz
    }

    Theme {
        id: theme
    }

    // Our link to the underlying sync engine.
    SyncFwClient {
        id: bridge

        service:  container.service   // Needed for credentials removal.
        storage:  container.storage   // Used in soft notifications.
        name:     container.name
        username: container.username  // To be potentially stored.
        password: container.password

        Component.onCompleted: {
            // Display the last time a successful sync occurred, or how the last sync failed or
            // perform an initial sync if one has not been run.

            // @todo Not happy that I have to go through QML to get a fuzzy time string.

            bridge.doPostInit(fuzz.getFuzzy(bridge.lastSyncTime(name)), false);

            syncMe.enabled = true;
        }
    }

    function executeOnSignin(u, p) {
        username = u;
        password = p;
        bridge.doPostInit("", true);
    }

    Component {
        id: cardMe

        SyncLoginDialog {
            username: container.username
            password: container.password
            serviceName: container.service
            loginOwner: container
        }
    }

    Column {
        anchors.fill: parent
        spacing: 10

        BorderImage {
            id: serviceInfo
            source: "image://theme/settings/btn_settingentry_up"
            border.left: 5
            border.right: 5
            border.top: 5
            border.bottom: 5
            width: parent.width - 10
            height: syncSummary.height + syncToggleContainer.height + 10

            Item {
                id: syncSummary
                height: {
                    Math.max(serviceIcon.height, serviceStatus.height, syncMe.height) + 10
                }
                width: parent.width - 10
                anchors.horizontalCenter: serviceInfo.horizontalCenter

                Item {
                    id: serviceIcon
                    anchors.verticalCenter: syncSummary.verticalCenter
                    height: theIcon.height + 10
                    width: theIcon.width + 10

                    Image {
                        id: theIcon
                        source: icon
                        anchors.centerIn: serviceIcon
                    }
                }

                Column {
                    id: serviceStatus
                    spacing: 5
                    anchors.verticalCenter: serviceIcon.verticalCenter
                    anchors.left: serviceIcon.right

                    Text {
                        id: serviceName
                        color: theme.fontColorNormal
                        font.pixelSize: theme.fontPixelSizeLarge
                        font.bold: true
                        // @todo Pull display name and storage profile name from C++ side.
                        //: Arg 1 is the name of the sync service (e.g. "Yahoo!") and arg 2 is the name of the storage (e.g. "Contacts" or "Calendar").
                        text: qsTr("%1 %2").arg(service).arg(storage)
                    }

                    Text {
                        id: syncResult
                        color: theme.fontColorNormal
                        font.pixelSize: theme.fontPixelSizeNormal
                        text: bridge.status
                    }


                }

                Button {
                    id: syncMe
                    anchors.verticalCenter: serviceIcon.verticalCenter
                    anchors.right: syncSummary.right

                    //: Text displayed in "sync now" button.
                    text: qsTr("Sync now")
                    enabled: false

                    onClicked: {
                        // Manually run sync on selected profile.
                        bridge.syncNow(name)
                    }
                }
            }

            Item {
                id: syncToggleContainer
                anchors.horizontalCenter: serviceInfo.horizontalCenter
                anchors.top: syncSummary.bottom
                height: childrenRect.height + 10
                width: parent.width - 10

                Text {
                    id: syncToggleLabel
                    anchors.verticalCenter: syncToggleContainer.verticalCenter
                    color: theme.fontColorNormal
                    font.pixelSize: theme.fontPixelSizeLarge
                    //: Argument is sync storage (e.g. "Contacts" or "Calendar").
                    text: qsTr("Sync %1").arg(storage)
                }

                ToggleButton {
                    anchors.verticalCenter: syncToggleContainer.verticalCenter
                    anchors.right: syncToggleContainer.right
                    on: bridge.scheduled

                    onToggled: {
                        bridge.enableAutoSync(isOn);
                    }
                }
            }
        }

        BorderImage {
            id: syncAccountDetails
            source: "image://theme/settings/btn_settingentry_up"
            border.left: 5
            border.right: 5
            border.top: 5
            border.bottom: 5
            width: serviceInfo.width
            height: {
                Math.max(details.height, forget.height) + 10
            }

            Column {
                id: details
                spacing: 10
                anchors.verticalCenter: syncAccountDetails.verticalCenter
                x: 5

                Text {
                    id: detailsLabel
                    color: theme.fontColorNormal
                    font.pixelSize: theme.fontPixelSizeLarge
                    font.bold: true
                    //: Title of "account details" area of page.
                    text: qsTr("Sync account details")
                }

                Text {
                    color: theme.fontColorNormal
                    font.pixelSize: theme.fontPixelSizeNormal
                    text: bridge.username
                }
            }

            Button {
                id: forget
                anchors.margins: 5
                anchors.verticalCenter: syncAccountDetails.verticalCenter
                anchors.right: syncAccountDetails.right

                //: Text displayed in "forget this" button (used to remove current sync account).
                text: qsTr("Forget this")

                onClicked: {
                    // Disable the "Sync Now" button auto-sync toggle switch.
                    syncMe.enabled = false;

                    // Remove account login information from profile on disk.  Note that we're
                    // removing all profiles for the given service provider (e.g. all Google
                    // profiles).
                    bridge.forgetProfile();
                }
            }
        }
    }

    Connections {
        target: bridge
        onProfileRemoved: {
            // Sync profile no longer exists return to main sync UI page.
            popPage();
        }

        onAuthenticationFailed: {
            // Give the user an opportunity to reenter login credentials.
            theLoginDialog = cardMe.createObject(container);
        }
    }
}
