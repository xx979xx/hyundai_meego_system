/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

function getCallStatusText (agent) {
    if (agent == undefined) {
        return "";
    }

    switch(agent.callStatus) {
    case CallAgent.CallStatusNoCall:
        if (agent.error) {
            return qsTr("Error");
        } else {
            return qsTr("No Call");
        }
        break;
    case CallAgent.CallStatusIncomingCall:
        return qsTr("Incoming");
        break;
    case CallAgent.CallStatusConnecting:
        return qsTr("Connecting");
        break;
    case CallAgent.CallStatusRinging:
        return qsTr("Ringing");
        break;
    case CallAgent.CallStatusTalking:
        // Qt has no way to get the time separator
        return Qt.formatTime(window.callAgent.elapsedTime(), "h:mm:ss");
        break;
    case CallAgent.CallStatusHeld:
        return qsTr("On Hold");
        break;
    case CallAgent.CallStatusHangingUp:
        return qsTr("Hanging up");
        break;
    default:
        return qsTr("Unknown");
    }
}
