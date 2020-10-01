/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.IM 0.1
import MeeGo.Media 0.1
import TelepathyQML 0.1
import "utils.js" as Utils

BottomToolBar {
    id: toolBar

    signal chatTextEnterPressed
    signal smileyClicked(string sourceName)

    // Bottom row to initiate calls & chat
    content: BottomToolBarRow {
        id: bottomRow

        leftContent: [
            IconButton {
                id: endCallButton
                width: 120
                active: window.callAgent != undefined &&
                        window.contactItem != undefined &&
                        window.contactItem.data(AccountsModel.AudioCallCapabilityRole) &&
                        window.callAgent.callStatus != CallAgent.CallStatusNoCall
                opacity: window.callAgent != undefined &&
                         window.callAgent.callStatus != CallAgent.CallStatusNoCall ? 1 : 0
                visible: opacity > 0

                icon: "image://themedimage/icons/actionbar/call-audio-stop"
                iconDown: icon + "-active"
                hasBackground: true
                bgSourceUp: "image://themedimage/images/btn_red_up"
                bgSourceDn: "image://themedimage/images/btn_red_dn"

                onClicked: {
                    window.callAgent.endCall();
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },

            
            IconButton {
                id: videoCallButton
                width: 60
                opacity: (window.callAgent == undefined && !window.chatAgent.isConference) ||
                         (!window.callAgent.existingCall &&
                        window.contactItem.data(AccountsModel.VideoCallWithAudioCapabilityRole) &&
                        window.callAgent != undefined &&
                        window.callAgent.callStatus == CallAgent.CallStatusNoCall &&
                        window.chatAgent != undefined &&
                        !window.chatAgent.isConference) ? 1 : 0
                visible: opacity > 0

                icon: "image://themedimage/icons/actionbar/turn-video-on"
                iconDown: icon + "-active"
                hasBackground: false
                onClicked: {
                    messageScreenPage.loadVideoWindow();
                    var videoWindow = messageScreenPage.getVideoWindow();
                    videoWindow.opacity = 1;
                    window.callAgent.setOutgoingVideo(videoWindow.cameraWindowSmall ? videoWindow.videoOutgoing : videoWindow.videoIncoming);
                    window.callAgent.onOrientationChanged(window.orientation);
                    window.callAgent.setIncomingVideo(videoWindow.cameraWindowSmall ? videoWindow.videoIncoming : videoWindow.videoOutgoing);
                    window.callAgent.videoCall();
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },

            IconButton {
                id: videoOnOffButton
                width: 60
                opacity: window.contactItem !== undefined &&
                        window.contactItem.data(AccountsModel.VideoCallWithAudioCapabilityRole) &&
                        window.callAgent != undefined && window.callAgent.existingCall &&
                        window.callAgent.callStatus != CallAgent.CallStatusNoCall &&
                        !(window.chatAgent != undefined && window.chatAgent.isConference) ? 1 : 0
                visible: opacity > 0

                icon: window.callAgent.videoSentOrAboutTo ?
                           "image://themedimage/icons/actionbar/turn-video-off" :
                           "image://themedimage/icons/actionbar/turn-video-on"
                iconDown: icon + "-active"
                hasBackground: false
                onClicked: {
                    window.callAgent.videoSent = !window.callAgent.videoSent;
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },

            IconButton {
                id: audioCallButton
                width: 60
                opacity: window.contactItem !== undefined &&
                         window.contactItem.data(AccountsModel.AudioCallCapabilityRole) &&
                         window.callAgent != undefined &&
                         window.callAgent.callStatus == CallAgent.CallStatusNoCall &&
                         window.chatAgent != undefined &&
                         !window.chatAgent.isConference ? 1 : 0
                visible: opacity > 0

                icon: "image://themedimage/icons/actionbar/call-audio-start"
                iconDown: icon + "-active"
                hasBackground: false
                onClicked: {
                    messageScreenPage.loadVideoWindow();
                    var videoWindow = messageScreenPage.getVideoWindow();
                    videoWindow.opacity = 1;
                    window.callAgent.setOutgoingVideo(videoWindow.cameraWindowSmall ? videoWindow.videoOutgoing : videoWindow.videoIncoming);
                    window.callAgent.onOrientationChanged(window.orientation);
                    window.callAgent.setIncomingVideo(videoWindow.cameraWindowSmall ? videoWindow.videoIncoming : videoWindow.videoOutgoing);
                    window.callAgent.audioCall();
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },

            IconButton {
                id: volumeOnButton
                width: 60
                icon: "image://themedimage/icons/actionbar/turn-audio-off"
                iconDown: icon + "-active"
                hasBackground: false
                onClicked: {
                    if (volumeLoader.sourceComponent != null ) {
                        volumeLoader.sourceComponent = null;
                    } else {
                        volumeLoader.sourceComponent = volumeControlComponent;
                        volumeLoader.item.parent = toolBar.parent;
                        volumeLoader.item.z = 1000
                        volumeLoader.item.volumeControl = volumeControl;
                        volumeLoader.item.volumeControlX = volumeOnButton.x + (volumeOnButton.width - volumeLoader.item.volumeWidth) / 2;
                        volumeLoader.item.volumeControlY = toolBar.y - volumeLoader.item.volumeHeight;
                        volumeLoader.item.closeTimer.interval = 3000;
                        volumeLoader.item.closeTimer.restart();
                    }
                }
                opacity: window.callAgent != undefined && window.callAgent.existingCall ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },
            
            IconButton {
                id: muteButton
                width: 60
                icon: window.callAgent.mutedCall ?
                        "image://themedimage/icons/actionbar/microphone-unmute" :
                        "image://themedimage/icons/actionbar/microphone-mute"
                iconDown: icon + "-active"
                hasBackground: false
                onClicked: {
                    window.callAgent.setMuteCall(!window.callAgent.mutedCall);
                }
                opacity: window.callAgent != undefined && window.callAgent.existingCall ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },
            
            IconButton {
                id: fullscreenButton
                width: 60
                icon: "image://themedimage/icons/actionbar/view-" +
                       (window.fullScreen ? "smallscreen" : "fullscreen")
                iconDown: icon + "-active"
                hasBackground: false
                onClicked: {
                    window.fullScreen = !window.fullScreen
                }
                opacity: (window.callAgent != undefined && window.callAgent.existingCall) ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            }
        ]

        rightContent: [
            Text {
                id: callInfoText
                elide: Text.ElideLeft
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: Utils.getCallStatusText(window.callAgent)
                color: theme_buttonFontColor

                Timer {
                    //running: window.callAgent.callStatus == CallAgent.CallStatusTalking
                    running: true
                    interval: 1000
                    repeat: true
                    onTriggered: {
                        callInfoText.text = Utils.getCallStatusText(window.callAgent);
                    }
                }
                opacity: window.callAgent != undefined && window.callAgent.existingCall ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    visible: insertSmileyButton.visible || sendFileButton.visible
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },

            IconButton {
                id: insertSmileyButton
                width: 60
                icon: "image://themedimage/icons/actionbar/insert-emote"
                iconDown: icon + "-active"
                hasBackground: false

                onClicked: {
                    smileyContextMenu.setPosition(insertSmileyButton.mapToItem(toolBar, insertSmileyButton.x, insertSmileyButton.y).x + insertSmileyButton.width / 2,
                                                  insertSmileyButton.mapToItem(window, insertSmileyButton.x, insertSmileyButton.y).y + 10);
                    smileyContextMenu.show();
                }
                opacity: !window.fullScreen ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    visible: sendFileButton.visible
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            },

            IconButton {
                id: sendFileButton
                width: 60
                icon: "image://themedimage/icons/actionbar/document-attach"
                iconDown: icon + "-active"
                onClicked: {
                    sendFileContextMenu.setPosition(sendFileButton.mapToItem(toolBar, sendFileButton.x, sendFileButton.y).x + sendFileButton.width / 2,
                                                    sendFileButton.mapToItem(window, sendFileButton.x, sendFileButton.y).y + 10);
                    sendFileContextMenu.show();
                }
                opacity: (!window.fullScreen && window.contactItem != undefined && window.contactItem.data(AccountsModel.FileTransferCapabilityRole)) ? 1 : 0
                visible: opacity > 0

                hasBackground: false
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                    }
                }
                Image
                {
                    anchors.right: parent.right
                    source: "image://themedimage/widgets/common/action-bar/action-bar-separator"
                    height: parent.height
                }
            }
        ]

        ContextMenu {
            id: smileyContextMenu

            content: SmileyGridView {
                id: smileyGrid
                height: 200
                width: 200

                onSmileyClicked: {
                    toolBar.smileyClicked(sourceName);
                    smileyContextMenu.hide();
                }
            }

            forceFingerMode: 3
            width: 200
            height: 200
        }

        ContextMenu {
            id: sendFileContextMenu

            content: SendFileView {
                id: sendFileView

                onFileSelected: {
                    fileTransferAgent.sendFile(fileName);
                    sendFileContextMenu.hide();
                }
                onCancelled: {
                    sendFileContextMenu.hide();
                }
            }

            forceFingerMode: 3

            Component.onCompleted: {
                if (sendFileContextMenu.content == null)
                    sendFileButton.visible = false
            }
        }

        Component {
            id: volumeControlComponent
            VolumeSlider {
                onClose: {
                    volumeLoader.sourceComponent = undefined;
                }
            }
        }

        Item {
            id: volumeControl

            property int volume: 100
            property bool mute: false

            onVolumeChanged: {
                window.callAgent.volume = volumeControl.volume / 100;
            }
            onMuteChanged: {
                window.callAgent.mutedCall = volumeControl.mute;
            }

            Component.onCompleted: {
                volumeControl.volume = window.callAgent.volume * 100;
                volumeControl.mute = window.callAgent.mutedCall;
            }
        }
        Loader {
            id: volumeLoader
        }
    }

    Component.onCompleted: {
        toolBar.show();
    }

}
