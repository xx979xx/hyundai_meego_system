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

ModalDialog {
    id: container
    title: qsTr("Incoming Call")
    acceptButtonEnabled: true
    acceptButtonText: qsTr("Accept")
    acceptButtonImage: "image://themedimage/images/btn_blue_up"
    acceptButtonImagePressed:  "image://themedimage/images/btn_blue_dn"
    cancelButtonText: qsTr("Decline")
    cancelButtonImage: "image://themedimage/images/btn_red_up"
    cancelButtonImagePressed: "image://themedimage/images/btn_red_dn"
    fogMaskVisible: false
    height: 300
    width: 400

    property alias statusMessage: message.text
    property alias connectionTarget: callStatusConnection.target

    content:
        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Item {
                width: 10
            }

            Avatar {
                id: avatarItem

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 10

                source: (window.incomingContactItem != undefined ?
                             window.incomingContactItem.data(AccountsModel.AvatarRole) :
                             noAvatarImage)
                noAvatarImage: "image://themedimage/widgets/common/avatar/avatar-default"
            }

            Column {
                id: nameColumn
                width: parent.width - avatarItem.width - 20

                anchors {
                    verticalCenter: avatarItem.verticalCenter
                    margins: 10
                }
                height: childrenRect.height

                Text {
                    id: dialogText
                    width: parent.width
                    anchors.left: parent.left

                    text: (window.incomingContactItem != undefined ?
                               window.incomingContactItem.data(AccountsModel.AliasRole) :
                               "")

                    color: theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeLarge
                    elide: Text.ElideRight
                }

                Row {
                    spacing: 5
                    height: message.height
                    width: parent.width

                    PresenceIcon {
                        id: presence
                        status: (window.incomingContactItem != undefined ?
                                     window.incomingContactItem.data(AccountsModel.PresenceTypeRole) :
                                     0)
                        anchors.verticalCenter: message.verticalCenter
                        anchors.topMargin: 5
                    }

                    Text {
                        id: message
                        text: ""
                        width: parent.width - presence.width - 10
                        color: theme_fontColorInactive
                        font.pixelSize: theme_fontPixelSizeNormal
                        elide: Text.ElideRight
                    }
                }
            }
        }

    property string accountId: ""
    property string contactId: ""

    Connections {
        id: callStatusConnection
        target: null
        onCallStatusChanged: {
            if (window.incomingCallAgent.callStatus == CallAgent.CallStatusNoCall
             || window.incomingCallAgent.callStatus == CallAgent.CallStatusHangingUp) {
                window.stopLoopedSound();
                container.hide();
            }
        }
    }

    function start() {
        show();
        window.playIncomingCallSound();
    }

    onAccepted: {
        window.stopLoopedSound();
        container.hide();
        window.acceptCall(accountId, window.incomingContactItem.data(AccountsModel.IdRole));
    }

    onRejected: {
        window.incomingCallAgent.endCall();
        window.stopLoopedSound();
        container.hide();
    }
}

