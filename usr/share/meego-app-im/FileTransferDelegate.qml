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
import TelepathyQML 0.1

Item {
    id: root
    width: parent.width
    height: childrenRect.height

    property string bubbleColor : "white"
    property alias avatarSource : avatar.source
    property alias presence : presence.status
    property alias sender : contact.text
    property alias time : time.text
    property int transferState
    property variant item
    property alias fileName : fileName.text
    property alias fileSize : fileSize.text
    property string filePath
    property bool incomingTransfer
    property int transferStateReason
    property double percentTransferred

    property bool pending: transferState == TelepathyTypes.FileTransferStatePending
    property bool active: transferState == TelepathyTypes.FileTransferStateOpen
    property bool finished: transferState == TelepathyTypes.FileTransferStateCompleted
    property bool canceled: transferState == TelepathyTypes.FileTransferStateCancelled

    Behavior on height {
        NumberAnimation {
            duration: 250
        }
    }

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
            source: "image://themedimage/widgets/apps/chat/bubble-" + root.bubbleColor + "-top"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            border.left: 40
            border.right: 10
            border.top: 5
        }

        BorderImage {
            id: messageCenter
            source: "image://themedimage/widgets/apps/chat/bubble-" + root.bubbleColor + "-middle"
            border.left: messageTop.border.left
            border.right: messageTop.border.right
            anchors.top: messageTop.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: messageBottom.top
        }

        BorderImage {
            id: messageBottom
            source: "image://themedimage/widgets/apps/chat/bubble-" + root.bubbleColor + "-bottom"
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
                    text: root.sender
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

            Item {
                id: messageBody
                anchors.top: messageHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 15
                anchors.leftMargin: messageTop.border.left
                anchors.rightMargin: messageTop.border.right
                height: childrenRect.height + 10

                Text {
                    id: fileName
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                    color: theme_fontColorNormal
                }

                Text {
                    id: fileSize
                    anchors.verticalCenter: fileName.verticalCenter
                    anchors.left: fileName.right
                    anchors.margins: 5
                    color: theme_fontColorInactive
                }

                Button {
                    id: openButton
                    anchors.top: fileName.bottom
                    anchors.left: fileName.left
                    anchors.topMargin: 10
                    text: qsTr("Open")
                    textColor: theme_buttonFontColor
                    bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                    bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"

                    onClicked: {
                        var cmd = "xdg-open \"" + root.filePath + "\"";
                        createAppModel();
                        appModel.launch(cmd);
                    }

                    visible: finished && root.incomingTransfer
                }

                Text {
                    id: errorText
                    anchors.top: fileName.bottom
                    anchors.left: fileName.left
                    anchors.topMargin: 10
                    text: {
                        if (canceled &&
                                (root.transferStateReason == TelepathyTypes.FileTransferStateChangeReasonRemoteError
                                 || root.transferStateReason == TelepathyTypes.FileTransferStateChangeReasonLocalError)) {
                            if (root.incomingTransfer) {
                                qsTr("There was a problem downloading");
                            } else {
                                qsTr("There was a problem uploading");
                            }
                        } else {
                            qsTr("Canceled") // TODO: report other errors
                        }
                    }
                    color: theme_fontColorHighlight

                    visible: canceled
                }


                Item {
                    id: buttonsParent
                    width: childrenRect.width
                    height: visible ? childrenRect.height : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: fileName.bottom
                    anchors.margins: 10

                    visible: pending && root.incomingTransfer

                    Button {
                        id: saveButton
                        anchors.top: parent.top
                        anchors.left: parent.left

                        text: qsTr("Save")
                        textColor: theme_buttonFontColor
                        bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                        bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"

                        onClicked: item.acceptTransfer();
                    }

                    Button {
                        id: declineButton
                        anchors.top: parent.top
                        anchors.leftMargin: 10
                        anchors.left: saveButton.right

                        text: qsTr("Decline")
                        textColor: theme_buttonFontColor
                        bgSourceUp: "image://themedimage/widgets/common/button/button-negative"
                        bgSourceDn: "image://themedimage/widgets/common/button/button-negative-pressed"

                        onClicked: item.cancelTransfer()
                    }
                }

                Item {
                    id: progressItem
                    anchors.topMargin: 10
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: fileName.bottom
                    visible: root.active || (!root.incomingTransfer && root.pending)
                    height: visible ? childrenRect.height : 0

                    Button {
                        id: cancelButton
                        anchors.top: parent.top
                        anchors.right: parent.right
                        text: qsTr("Cancel")
                        textColor: theme_buttonFontColor
                        bgSourceUp: "image://themedimage/widgets/common/button/button-negative"
                        bgSourceDn: "image://themedimage/widgets/common/button/button-negative-pressed"
                        onClicked: item.cancelTransfer();
                    }

                    Item {
                        id: progressBar
                        anchors.left: parent.left
                        anchors.right: cancelButton.left
                        anchors.top: parent.top
                        anchors.bottom: cancelButton.bottom
                        anchors.margins: 10

                        BorderImage {
                            id: backgroundBar
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            border {
                                top: 2
                                bottom: 2
                                left: 2
                                right: 2
                            }
                            source: "image://themedimage/widgets/common/progress-bar/progress-bar-backgound"
                        }

                        BorderImage {
                            id: foregroundBar
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            border {
                                top: 2
                                bottom: 2
                                left: 2
                                right: 2
                            }
                            width: backgroundBar.width * (root.percentTransferred / 100.)
                            source: "image://themedimage/widgets/common/progress-bar/progress-bar-fill"
                            visible: root.percentTransferred > 0

                            Behavior on width {
                                NumberAnimation {
                                    duration: 500
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
