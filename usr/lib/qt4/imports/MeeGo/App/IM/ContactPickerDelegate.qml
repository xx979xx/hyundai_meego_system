/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.IM 0.1
import TelepathyQML 0.1

Item {
    id: contactDelegate

    width: parent.width
    height: childrenRect.height
    property bool active: (model.presenceType == TelepathyTypes.ConnectionPresenceTypeAvailable
                           || model.presenceType == TelepathyTypes.ConnectionPresenceTypeBusy
                           || model.presenceType == TelepathyTypes.ConnectionPresenceTypeAway
                           || model.presenceType == TelepathyTypes.ConnectionPresenceTypeExtendedAway)

    property bool selected: contactPickerPage.isItemSelected(model.id)

    Component.onCompleted: {
        if(model.presenceMessage != "") {
            message.text = model.presenceMessage;
        } else {
            message.text = presenceStatusText(model.presenceType);
        }
    }

    Item {
        id: mainArea
        width: parent.width
        height: contentRow.height

        ContentRow {
            id: contentRow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            smooth: true
            active:  selected
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(selected == false) {
                    contactPickerPage.itemSelected(model.parentId, model.id);
                } else {
                    contactPickerPage.itemDeselected(model.parentId, model.id);
                }
                selected = contactPickerPage.isItemSelected(model.id)
            }
        }

        BorderImage {
            id: activeBorder
            opacity: selected
            source: "image://themedimage/widgets/common/toolbar-item/toolbar-item-background-active"
            anchors.fill: contentRow
            border.left: 5; border.top: 5
            border.right: 5; border.bottom: 5
        }

        Avatar {
            id: avatar
            active: contactDelegate.active
            source: model.avatar
            anchors.left: parent.left
            anchors.top:  parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 3
        }

        Column {
            id: nameColumn

            anchors {
                left: avatar.right
                right: mainArea.right
                top: mainArea.top
                bottom: mainArea.bottom
                margins: 10
            }

            Text {
                id: displayText
                // TODO: check width and display alias or username accordingly
                text: model.aliasName
                width: parent.width
                elide: Text.ElideRight
                font.weight: Font.Bold
                color: theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
            }

            Row {
                spacing: 5
                width: parent.width
                height: parent.height - displayText.height

                PresenceIcon {
                    id: presence
                    status: model.presenceType
                    anchors.verticalCenter: message.verticalCenter
                    anchors.topMargin: 5
                }

                Text {
                    id: message
                    text: ""
                    width: parent.width - presence.width - 10
                    //elide: Text.ElideRight
                    color: theme_fontColorInactive
                    font.pixelSize: theme_fontPixelSizeLarge
                    elide: Text.ElideRight
                }

            }
        }
    }

    function presenceStatusText(type)
    {
        if(type == TelepathyTypes.ConnectionPresenceTypeAvailable) {
            return qsTr("Available");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeBusy) {
            return qsTr("Busy");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeAway) {
            return qsTr("Away");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeExtendedAway) {
            return qsTr("Extended away");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeOffline) {
            return qsTr("Offline");
        } else if(type == TelepathyTypes.ConnectionPresenceTypeHidden) {
            return qsTr("Invisible");
        } else {
            return "";
        }
    }
}
