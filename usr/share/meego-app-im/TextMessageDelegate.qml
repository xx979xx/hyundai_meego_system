/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.IM 0.1
import MeeGo.Components 0.1

Item {
    id: bubbleMessage
    width: parent.width
    height: childrenRect.height

    property string bubbleColor : "white"
    property alias avatarSource : avatar.source
    property alias presence : presence.status
    property alias sender : contact.text
    property alias time : time.text
    property alias message : messageBody.text
    property alias messageColor : messageBody.color

    property alias messageTopItem : messageTop
    property alias messageHeaderItem : messageHeader

    Avatar {
        id: avatar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 8
        anchors.leftMargin: 5
        height: 100
    }

    Item {
        id: messageBubble
        anchors.top: parent.top
        anchors.left: avatar.right
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.bottomMargin: 5
        anchors.leftMargin: -19
        anchors.rightMargin: 0
        smooth: true
        height: Math.max(childrenRect.height, avatar.height)

        BorderImage {
            id: messageTop
            source: "image://themedimage/widgets/apps/chat/bubble-" + bubbleMessage.bubbleColor + "-top"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            border.left: 40
            border.right: 10
            border.top: 5
        }

        BorderImage {
            id: messageCenter
            source: "image://themedimage/widgets/apps/chat/bubble-" + bubbleMessage.bubbleColor + "-middle"
            border.left: messageTop.border.left
            border.right: messageTop.border.right
            anchors.top: messageTop.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: messageBottom.top
        }

        BorderImage {
            id: messageBottom
            source: "image://themedimage/widgets/apps/chat/bubble-" + bubbleMessage.bubbleColor + "-bottom"
            border.left: messageTop.border.left
            border.right: messageTop.border.right
            border.bottom: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
        }

        Item {
            id: textMessage
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height + 10

            Item {
                id: messageHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height

                PresenceIcon {
                    id: presence
                    anchors.left: parent.left
                    anchors.verticalCenter: contact.verticalCenter
                    anchors.margins: 5
                    anchors.leftMargin: messageTop.border.left
                }

                Text {
                    id: contact
                    anchors.left: presence.right
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.leftMargin:5
                    anchors.right: time.left
                    anchors.rightMargin: 10
                    color: Qt.rgba(0.3,0.3,0.3,1)
                    font.pixelSize: theme_fontPixelSizeSmall
                    elide: Text.ElideRight
                    text: bubbleMessage.sender
                }

                Text {
                    id: time
                    anchors.right: parent.right
                    anchors.bottom: contact.bottom
                    anchors.rightMargin: messageTop.border.right
                    color: Qt.rgba(0.3,0.3,0.3,1)
                    font.pixelSize: theme_fontPixelSizeSmall
                }
            }

            /*
                FIXME: enable Text and remove TextEdit once meego-ux-componets supports
                CCPContextArea for Text components.
            */
            /*
            Text {
                id: messageBody
                anchors.top: messageHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 15
                anchors.leftMargin: messageTop.border.left
                anchors.rightMargin: messageTop.border.right
                wrapMode: Text.Wrap
                textFormat: Text.RichText
            }*/

            TextEdit {
                id: messageBody
                anchors.top: messageHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 15
                anchors.leftMargin: messageTop.border.left
                anchors.rightMargin: messageTop.border.right
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                readOnly: true
                font.pixelSize: theme_fontPixelSizeLarge
                visible: text != ""

                CCPContextArea {
                    editor: parent
                    copyOnly: true
                    enabled: messageBody.visible
                }
            }
        }
    }
}
