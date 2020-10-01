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
    id: mainArea

    width: parent.width
    height: childrenRect.height

    anchors.leftMargin: 10
    anchors.rightMargin: 10
    anchors.topMargin: 1

    property bool eventItem: model.eventType == "Tpy::CustomEventItem"
    property bool fileTransferItem: model.eventType == "FileTransferItem"
    property bool messageItem: model.eventType == "Tpy::TextEventItem"
    property bool callItem: model.eventType == "Tpy::CallEventItem"
    property bool messageSent: !model.incomingEvent
    property string color: model.bubbleColor

    /*
    Component.onCompleted: {
        console.log("-------------------------------------------------------")
        console.log("model.eventType=" + model.eventType);
        console.log("model.incomingEvent=" + model.incomingEvent);
        console.log("model.sender=" + model.sender);
        console.log("model.senderAvatar=" + model.senderAvatar);
        console.log("model.receiver=" + model.receiver);
        console.log("model.receiverAvatar=" + model.receiverAvatar);
        console.log("model.dateTime=" + model.dateTime);
        console.log("model.item=" + model.item);
        console.log("model.dateTime=" + model.dateTime);
        console.log("model.messageText=" + model.messageText);
        console.log("model.messageType=" + model.messageType);
        console.log("model.callDuration=" + model.callDuration);
        console.log("model.callEndActor=" + model.callEndActor);
        console.log("model.callEndActorAvatar=" + model.callEndActorAvatar);
        console.log("model.callEndReason=" + model.callEndReason);
        console.log("model.callDetailedEndReason=" + model.callDetailedEndReason);
        console.log("model.missedCall=" + model.missedCall);
        console.log("model.rejectedCall=" + model.rejectedCall);
        console.log("model.customEventText=" + model.customEventText);
        console.log("model.customEventType=" + model.customEventType);
        console.log("callItem=" + callItem);
    }*/

    function messageAvatar() {
        var avatar = "";
        if (messageSent) {
            avatar = "image://avatars/" + window.currentAccountId + // i18n ok
                        "?" + accountFactory.avatarSerial;
        } else {
            avatar = model.senderAvatar;
        }

        return avatar;
    }

    Loader {
        width: parent.width
        sourceComponent: messageItem ? textMessageComponent :
                         fileTransferItem ? fileTransferComponent :
                         eventItem ? eventMessageComponent :
                         callItem ? callMessageComponent : null
    }

    Component {
        id: textMessageComponent
        TextMessageDelegate {
            id: textMessage
            bubbleColor: model.bubbleColor
            avatarSource: messageAvatar()
            presence: model.status
            sender: model.sender
            time: fuzzyDateTime.getFuzzy(model.dateTime)
            message: parseChatText(model.messageText)
            messageColor: model.fromLogger ? theme_fontColorInactive : theme_fontColorNormal

            Connections {
                target: fuzzyDateTimeUpdater
                onTriggered: {
                    textMessage.time = fuzzyDateTime.getFuzzy(model.dateTime);
                }
            }
        }
    }

    Component {
        id: fileTransferComponent
        FileTransferDelegate {
            id: fileTransferMessage
            bubbleColor: model.bubbleColor
            avatarSource: messageAvatar()
            presence: model.status
            sender: senderMessage()
            time: fuzzyDateTime.getFuzzy(model.dateTime)
            transferState: model.transferState
            item: model.item
            fileName: model.fileName
            fileSize: qsTr("(%1)").arg(model.fileSize)
            filePath: model.filePath
            incomingTransfer: model.incomingTransfer
            transferStateReason: model.transferStateReason
            percentTransferred: model.percentTransferred

            Connections {
                target: fuzzyDateTimeUpdater
                onTriggered: {
                    fileTransferMessage.time = fuzzyDateTime.getFuzzy(model.dateTime);
                }
            }

            function senderMessage() {
                if (messageSent) {
                    if (canceled) {
                        return qsTr("Upload canceled:");
                    } else if (finished) {
                        return qsTr("Sent:");
                    } else {
                        return qsTr("Uploading:");
                    }
                } else {
                    if (finished) {
                        return qsTr("%1 has sent you:").arg(model.sender);
                    } else {
                        return qsTr("%1 is sending you:").arg(model.sender);
                    }
                }
                return "";
            }
        }
    }

    Component {
        id: eventMessageComponent
        InlineMessageDelegate {
            id: eventMessage
            text: qsTr("%1 - %2").arg(model.customEventText).arg(fuzzyDateTime.getFuzzy(model.dateTime))
            Connections {
                target: fuzzyDateTimeUpdater
                onTriggered: {
                    eventMessage.text = qsTr("%1 - %2").arg(model.customEventText).arg(fuzzyDateTime.getFuzzy(model.dateTime));
                }
            }
        }
    }

    Component {
        id: callMessageComponent
        InlineMessageDelegate {
            id: callMessage
            //source: "image://themedimage/widgets/apps/chat/call-video-missed
            source: model.missedCall || model.rejectedCall ? "image://themedimage/widgets/apps/chat/call-audio-missed" : ""
            text: getCallMessageText()

            Connections {
                target: fuzzyDateTimeUpdater
                onTriggered: {
                    callMessage.text = getCallMessageText();
                }
            }

            function getCallMessageText() {
                if (model.missedCall) {
                    return qsTr("%1 tried to call - %2").arg(model.sender).arg(fuzzyDateTime.getFuzzy(model.dateTime));
                } else if (model.rejectedCall) {
                    return qsTr("%1 rejected call - %2").arg(model.sender).arg(fuzzyDateTime.getFuzzy(model.dateTime));
                } else {
                    return qsTr("%1 called - duration %2 - %3").arg(model.sender).arg("" + model.callDuration).arg(fuzzyDateTime.getFuzzy(model.dateTime));
                }
            }
        }
    }

    function parseChatText(message) {
        var parsedMessage = message;
        var smileyMap = {
            ":-{"   : "emote-angry",        ":-&amp;"   : "emote-angry",
            ":S"    : "emote-confused",     ":-S"       : "emote-confused",
            ":-["   : "emote-embarressed",
            ":)"    : "emote-happy",        ":-)"       : "emote-happy",
            "&lt;3" : "emote-love",
            ":("    : "emote-sad",          ":'("       : "emote-sad",
            "(*)"   : "emote-star",
            "|-("   : "emote-tired",
            ";)"    : "emote-wink",         ";-)"       : "emote-wink"
        };

        for(var face in smileyMap) {
            var index;
            while((index = parsedMessage.indexOf(face)) > -1) {
                var endIndex = index + face.length;
                var emoticonSource = "/usr/share/themes/" + theme_name + "/icons/emotes/" +  smileyMap[face] + ".png"
                var imageTag = imageTagging(emoticonSource);
                parsedMessage = parsedMessage.substr(0, index) + imageTag + parsedMessage.substr(endIndex);
            }
        }

        return parsedMessage;
    }

    function imageTagging(sourceName) {
        return "<img src=\"" + sourceName + "\" >"
    }
}
