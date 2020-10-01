/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.App.Email 0.1

Item {
    id: container
    anchors.bottom: parent.bottom
    width: parent.width
    height: navigationBarImage.height

    Labs.ApplicationsModel {
        id: appModel
    }

    BorderImage {
        id: navigationBarImage
        width: parent.width
        verticalTileMode: BorderImage.Stretch
        source: "image://theme/navigationBar_l"
    }
    Item {
        anchors.fill: parent

      
        ToolbarButton {
            id: accountSetting
            anchors.left: parent.left 
            anchors.top: parent.top
            iconName: "show-settings"

            onClicked: {
                var cmd = "/usr/bin/meego-qml-launcher --app meego-ux-settings --opengl --fullscreen --cmd showPage --cdata \"Email\"";  //i18n ok
                appModel.launch(cmd);
            }
        }

        Image {
            id: division1
            anchors.left: accountSetting.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            source: "image://theme/email/div"
        }

        Image {
            id: division2
            anchors.right: refreshButton.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            source: "image://theme/email/div"
        }
        Item {
            id:refreshButton 
            anchors.right: parent.right
            anchors.top: parent.top
            height: container.height
            width: refreshImage.width
            Image {
                id: refreshImage
                anchors.centerIn: parent
                opacity: window.refreshInProgress ? 0 : 1
                source: "image://themedimage/icons/actionbar/view-sync"
            }

            EmailSpinner {
                id: spinner
                anchors.centerIn: parent
                opacity: window.refreshInProgress ? 1 : 0
                spinning: window.refreshInProgress
                maxSpinTime: 3600000
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (window.refreshInProgress == true)
                    {
                        emailAgent.cancelSync();
                        window.refreshInProgress = false;
                    }
                    else
                    {
                        emailAgent.accountsSync();
                        window.refreshInProgress = true;
                    }
                }
            }
        }
    }
}
