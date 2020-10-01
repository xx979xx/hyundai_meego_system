/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Settings 0.1
import MeeGo.App.Email 0.1

AppPage {
    id: settingsPage
    property alias accountSettingsModel: accountSettingsModel
    pageTitle: qsTr("Email Settings")
    disableSearch: true
    Translator { catalog: "meego-app-email" }
    EmailAccount { id: emailAccount }
    EmailAccountSettingsModel { id: accountSettingsModel }
    Labs.ApplicationsModel { id: appModel }
    function returnToEmail() {
        var cmd = "/usr/bin/meego-qml-launcher --app meego-app-email --opengl --fullscreen"; //i18n ok
        appModel.launch(cmd);
    }
    Loader {
        id: loader
//        parent: settingsPage.content
        anchors.fill: parent
    }
    function getHomescreen() {
        if (accountSettingsModel.rowCount() > 0) {
            return "SettingsScreen";
        } else {
            return "WelcomeScreen";
        }
    }
    state: getHomescreen()
    states: [
        State {
            name: "WelcomeScreen"
            PropertyChanges { target: loader; source: "WelcomeScreen.qml" }
        },
        State {
            name: "SettingsScreen"
            PropertyChanges { target: loader; source: "AccountSettings.qml" }
        },
        State {
            name: "RegisterScreen"
            PropertyChanges { target: loader; source: "RegisterScreen.qml" }
        },
        State {
            name: "DetailsScreen"
            PropertyChanges { target: loader; source: "DetailsScreen.qml" }
        },
        State {
            name: "ConfirmScreen"
            PropertyChanges { target: loader; source: "ConfirmScreen.qml" }
        },
        State {
            name: "ManualScreen"
            PropertyChanges { target: loader; source: "ManualScreen.qml" }
        }
    ]
}
