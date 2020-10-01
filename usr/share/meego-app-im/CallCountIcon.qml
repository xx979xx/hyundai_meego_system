/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    property int messageCount: 0
    property int missedAudioCalls: 0
    property int missedVideoCalls: 0
    property bool openChat: false

    property bool showChat: ((openChat || messageCount > 0) && (missedAudioCalls + missedVideoCalls) == 0)
    property bool showAudio: (missedAudioCalls > 0 && missedVideoCalls == 0)
    property bool showMissed: ((missedAudioCalls + missedVideoCalls) > 0)
    property int callsCount: (missedAudioCalls + missedVideoCalls)

    width: containerRow.width

    Row {
        id: containerRow
        height: parent.height
        spacing: 10

        Item {
            height: parent.height
            width: childrenRect.width
            anchors.verticalCenter: parent.verticalCenter

            visible: showChat && messageCount > 0

            BorderImage {
                source: "image://themedimage/widgets/apps/chat/message-unread-background"
                width: chatCount.width + border.left + border.right
                anchors.verticalCenter: parent.verticalCenter
                smooth: true

                // TODO: replace by the .sci file once we discover how to use that
                // and the image provider
                border.left:   17
                border.top:    17
                border.bottom: 17
                border.right:  17

                Text {
                    id: chatCount
                    text: messageCount
                    visible: showChat

                    anchors.centerIn:  parent
                    horizontalAlignment: Text.AlignHCenter
                    color: theme_buttonFontColor
                    font.bold: true
                    font.pixelSize: theme_fontPixelSizeLarge
                    smooth: true
                }
            }
        }

        Item {
            height: parent.height
            width: childrenRect.width
            anchors.verticalCenter: parent.verticalCenter

            visible: showMissed

            BorderImage {
                source: "image://themedimage/widgets/apps/chat/message-unread-background"
                width: callCount.width + border.left + border.right
                anchors.verticalCenter: parent.verticalCenter
                smooth: true

                // TODO: replace by the .sci file once we discover how to use that
                // and the image provider
                border.left:   17
                border.top:    17
                border.bottom: 17
                border.right:  17

                Text {
                    id: callCount
                    text: callsCount
                    visible: showMissed

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    color: theme_buttonFontColor
                    font.bold: true
                    smooth: true
                }
            }
        }

        Image {
            id: chatImage
            source: "image://themedimage/widgets/apps/chat/message-unread"
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: showChat
        }

        Image {
            id: audioImage
            source: "image://themedimage/widgets/apps/chat/call-audio-missed"
            height: 37
            width: 37
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: showAudio
        }

        Image {
            id: videoImage
            source: "image://themedimage/widgets/apps/chat/call-video-missed"
            height: 27
            width: 37
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: missedVideoCalls > 0
        }
    }
}
