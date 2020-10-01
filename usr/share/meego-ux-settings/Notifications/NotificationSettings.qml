/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1 as MeeGo
import MeeGo.Settings 0.1

MeeGo.AppPage {
    id: notificationsPage
    pageTitle: qsTr("Notifications")

    NotificationTypes{
        id: notificationTypes
    }

    NotificationModel{
        id: notificationModel
    }

    Flickable {
        contentHeight: childrenRect.height
        anchors.fill: parent
        clip: true
        Column {
            id: notificationColumn
            width: parent.width
            height: childrenRect.height
            spacing: 10

            Image {
                id: customizeableNotifications
                width: parent.width
                height: childrenRect.height
                source: "image://theme/settings/subheader"

                Text{
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("By default, phone and messaging notifications will be shown on the lockscreen.");
                    font.pixelSize: theme_fontPixelSizeLargest3
                    //height: parent.height
                    width: parent.width
                    //elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Image {
                id: notificationsLabel
                source: "image://theme/pulldown_box"
                width: parent.width

                Text {
                    id: notificationsLabelText
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("You may select up to 4 additional notifications to receive on the lockscreen");
                    font.pixelSize: theme_fontPixelSizeLargest2 //theme_fontPixelSizeLarge
                    height: parent.height
                    wrapMode: Text.Wrap
                    width: parent.width - 10
                }
            }

            GridView{
                id: notificationsListView
                model: notificationModel
                delegate: notificationsDelegate
                width: parent.width
                height: childrenRect.height + 50
                cellWidth: 360
                cellHeight: 50
            }

            Component{
                id:notificationsDelegate
                MeeGo.Button {
                    id: buttonId
                    text: name

                    width: 350
                    active: !notificationTypes.maxNotifications() || notificationTypes.isActive(type)

                    bgSourceUp: notificationTypes.isActive(type) ?  "image://theme/btn_blue_up" : "image://theme/btn_grey_up"
                    bgSourceActive: bgSourceUp
		    bgSourceDn:  notificationTypes.isActive(type) ?  "image://theme/btn_blue_dn" : "image://theme/btn_grey_dn"

                    onClicked: {

                        if (notificationTypes.isActive(type) == false)
                        {
                            if (!notificationTypes.maxNotifications())
                            {
                                bgSourceUp = "image://theme/btn_blue_up"
				bgSourceActive = bgSourceUp
                                bgSourceDn = "image://theme/btn_blue_dn"
                                notificationTypes.addType(type);
                            }
                        }
                        else
                        {
                            bgSourceUp = "image://theme/btn_grey_up"
			    bgSourceActive = bgSourceUp
                            bgSourceDn = "image://theme/btn_grey_dn"
                            notificationTypes.removeType(type);
                        }

                    }
                    Connections {
                        target: notificationTypes
                        onNotificationNumberChanged: {
                            buttonId.active = !notificationTypes.maxNotifications() || notificationTypes.isActive(type)
                        }
                    }
                }
            }
        }
    }
}


