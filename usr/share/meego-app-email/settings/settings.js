/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

// internationalized strings for update intervals

function textForInterval(minutes) {
    if (minutes === 0) {
        return qsTr("Manual update only");
    } else if (minutes === 60) {
        return qsTr("Update every hour");
    } else {
        return qsTr("Update every %1 minutes").arg(minutes);
    }
}

// internationalized strings for dropdowns

var serviceModel = [qsTr("POP"),
                    qsTr("IMAP")];

function serviceName(code) {
    if (code === "0")
        return serviceModel[0];
    else if (code === "1")
        return serviceModel[1];
    else
        return "";
}

function serviceCode(name) {
    if (name === serviceModel[0])
        return "0";
    else if (name === serviceModel[1])
        return "1";
    else
        return "";
}

var encryptionModel = [qsTr("None"),
                       qsTr("SSL"),
                       qsTr("TLS")];

function encryptionName(code) {
    if (code === "0")
        return encryptionModel[0];
    else if (code === "1")
        return encryptionModel[1];
    else if (code === "2")
        return encryptionModel[2];
    else
        return "";
}

function encryptionCode(name) { 
    if (name === encryptionModel[0])
        return "0";
    else if (name === encryptionModel[1])
        return "1";
    else if (name === encryptionModel[2])
        return  "2";
    else
        return "";
}

var authenticationModel = [qsTr("None"),
                           qsTr("Login"),
                           qsTr("Plain"),
                           qsTr("Cram MD5")];

function authenticationName(code) {
    if (code === "0")
        return authenticationModel[0];
    else if (code === "1")
        return authenticationModel[1];
    else if (code === "2")
        return authenticationModel[2];
    else if (code === "3")
        return authenticationModel[3];
    else
        return "";
}

function authenticationCode(name) {
    if (name === authenticationModel[0])
        return "0";
    else if (name === authenticationModel[1])
        return "1";
    else if (name === authenticationModel[2])
        return "2";
    else if (name === authenticationModel[3])
        return "3";
    else
        return "";
}
