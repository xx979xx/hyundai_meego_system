/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import MeeGo.App.Email 0.1


Item {
    id: composer

    property string quotedBody: "";

    property alias textBody: textEditPane.text;
    property alias htmlBody: htmlEditPane.html;
    property alias toModel: header.toModel
    property alias ccModel: header.ccModel
    property alias bccModel: header.bccModel
    property alias attachmentsModel: header.attachmentsModel
    property alias accountsModel: header.accountsModel
    property alias priority: header.priority
    property alias subject: header.subject
    property alias fromEmail: header.fromEmail
    property alias header: header


    function completeEmailAddresses () {
        header.completeEmailAddresses ();
    }

    EmailHeader {
        id: header
        anchors.top: parent.top
        anchors.topMargin:  10
        width: parent.width
        x: 10
        z: 1000
    }

    Image {
        width: parent.width
        anchors.top:  header.bottom
        anchors.topMargin:  5
        anchors.bottom:parent.bottom

        source: "image://theme/email/bg_reademail_l"

        HtmlField {
            id: htmlEditPane
            visible: window.composeInTextMode ? false : true
            html : {
                var sig = emailAgent.getSignatureForAccount(window.currentMailAccountId);
                if (sig == "")
                    return composer.quotedBody;
                else
                    return (composer.quotedBody + "\n-- \n" + sig + "\n");
            }

            anchors.fill: parent

            onFocusChanged: {
                console.log ("Focus changed " + focus);
            }
        }

        TextField {
            id: textEditPane
            visible: window.composeInTextMode
            font.pixelSize: theme.fontPixelSizeLarge
            text : {
                var sig = emailAgent.getSignatureForAccount(window.currentMailAccountId);
                if (sig == "")
                    return composer.quotedBody;
                else
                    return (composer.quotedBody + "\n-- \n" + sig + "\n");
            }

            anchors.fill: parent

            onFocusChanged: {
                console.log ("Focus changed " + focus);
            }
        }
    }
}
