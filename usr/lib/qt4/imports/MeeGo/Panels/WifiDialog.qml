/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Connman 0.1
import MeeGo.Panels 0.1

Item {
    id: bubbleContainer

    function setPosition(mouseX, mouseY) {
        if(networkListModel.offlineMode == false)
            wifiCtxMenu.setPosition(mouseX, mouseY)
        else
            offlineCtxMenu.setPosition(mouseX, mouseY)
    }
    function show() {
        networkListModel.initWifi()
        if(networkListModel.offlineMode == false)
            wifiCtxMenu.show()
        else
            offlineCtxMenu.show()
    }

    Theme{ id: theme }

    NetworkListModel {
        id: networkListModel
        property bool wifiEnabled
        property bool wifiAvailable

	Component.onCompleted: {
            defaultNetRoute = defaultRoute;
            changeConnectedText();
	}

        onStateChanged: {
            changeConnectedText();
        }

        onDefaultTechnologyChanged: {
            changeConnectedText();
        }

        onDefaultRouteChanged: {
            defaultNetRoute = defaultRoute;
            changeConnectedText();
        }

        onTechnologiesChanged: {
            networkListModel.initWifi()
        }
        onEnabledTechnologiesChanged: {
            wifiToggle.on = (networkListModel.enabledTechnologies.indexOf("wifi") != -1)
        }

        function initWifi()
        {
            for(var i=0 in availableTechnologies) {
                if (availableTechnologies[i] == "wifi") {
                    wifiAvailable = true
                }
            }

            for(var i=0 in enabledTechnologies) {
                if (enabledTechnologies[i] == "wifi") {
                    wifiEnabled = true;
                }
            }
        }
    }

    property QtObject defaultNetRoute: null
    property string connectedText: "";

    onDefaultNetRouteChanged: changeConnectedText()

    Connections {
        target: defaultNetRoute
        onNameChanged: {
            console.log("defaultNetRoute.nameChanged: " + defaultNetRoute.name);
            changeConnectedText();
        }
    }

    function changeConnectedText() {
        //if we don't have a connection, we're not connected
        if (defaultNetRoute == null)
            connectedText = qsTr("No connection currently");
        else {
            if (networkListModel.defaultTechnology == "ethernet")
                connectedText = qsTr("Wired")
            else if ((networkListModel.defaultTechnology == "wifi")
                     || (networkListModel.defaultTechnology == "cellular")
                     || (networkListModel.defaultTechnology == "wimax")
                     || (networkListModel.defaultTechnology == "bluetooth"))
                connectedText = qsTr("Connected to %1").arg(defaultNetRoute.name);
            else if (networkListModel.defaultTechnology == "")
               	connectedText = qsTr("No connection currently");
            else {
                console.log("Unhandled technology type: " + networkListModel.defaultTechnology + ", dNR.name: " + defaultNetRoute.name)
                connectedText = qsTr("Connected by %1").arg(networkListModel.defaultTechnology);
            }
        }

        //defaultNetRoute.name;// qsTr("No connection currently.")
                       //"Connected to %1" (ssid)
                       //WiMax/3g: Connected to %1 (operator name)
                       //BT: Connected to %1 (bt dev name)
                       //Wired: "Wired"
                       //precedence: default route
    }

    // For getting same margins as in action menu
    ActionMenu {
        id: actionMenu
        visible: false
    }

    ContextMenu {
        id: wifiCtxMenu

        content: Item {

            width: bubbleCol.width
            height: bubbleCol.height
            Column {
                id: bubbleCol
                anchors.centerIn: parent
                Item {
                    id:wifiRectangle
                    width: bubbleCol.width

                    height: Math.max(wifiText.height,wifiToggle.height) + actionMenu.textMargin

                    Text {
                        id: wifiText
                        text: qsTr("Wi-Fi")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: actionMenu.textMargin
                        color: theme.contextMenuFontColor
                        font.pixelSize: theme.contextMenuFontPixelSize
                    }

                    ToggleButton {
                        id: wifiToggle

                        anchors.right: parent.right
                        anchors.rightMargin: actionMenu.textMargin
                        anchors.verticalCenter: wifiText.verticalCenter

                        on:  (networkListModel.enabledTechnologies.indexOf("wifi") != -1)
                        onToggled: {
                            if(wifiToggle.on)
                                networkListModel.enableTechnology("wifi");
                            else
                                networkListModel.disableTechnology("wifi");
                        }
                    }
                }

                Image {
                    source: "image://themedimage/widgets/common/menu/menu-item-separator-header"
                    width: parent.width
                }

        	    Text {
        	        id: txtCurConn
                    anchors.left: parent.left
                    anchors.leftMargin: actionMenu.textMargin
                    width: paintedWidth + actionMenu.textMargin*2
                    height: paintedHeight + actionMenu.textMargin*2
                    text: connectedText
                    verticalAlignment: Text.AlignVCenter
                    color: theme.contextMenuFontColor
                    font.pixelSize: theme.contextMenuFontPixelSize
        	    }

                Image {
                    source: "image://themedimage/widgets/common/menu/menu-item-separator-header"
                    width: parent.width
                }

                Item {
                    height: wifiSettings.height + actionMenu.textMargin
                    width: parent.width
                    Button {
                        id : wifiSettings
                        active: true
                        text: qsTr("Wi-Fi settings")
                        anchors.centerIn: parent

                        onClicked:{
                            spinnerContainer.startSpinner();
                            appsModel.launch("meego-qml-launcher --opengl  --app meego-ux-settings --cmd showPage --cdata Connections --fullscreen")
                            wifiCtxMenu.hide();
                        }
                    }
                }
            }
        }
    }
  ContextMenu  {
            id: offlineCtxMenu

            content: Item {

                width: offbubbleCol.width
                height: offbubbleCol.height
                Column {
                    id: offbubbleCol
                    anchors.centerIn: parent
                    Item {
                        id:offlineRectangle
                        width: offbubbleCol.width

                        height: Math.max(wifiText.height,wifiToggle.height) + actionMenu.textMargin

                        Text {
                            id: offlineText
                            text: qsTr("Airplane Mode is ON")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: actionMenu.textMargin
                            color: theme.contextMenuFontColor
                            font.pixelSize: theme.contextMenuFontPixelSize
                        }


                    }

                    Image {
                        source: "image://themedimage/widgets/common/menu/menu-item-separator-header"
                        width: parent.width
                    }

                    Text {
                        id: offlinetxtCurConn
                        anchors.left: parent.left
                        anchors.leftMargin: actionMenu.textMargin
                        width: paintedWidth + actionMenu.textMargin*2
                        height: paintedHeight + actionMenu.textMargin*2
                        text: qsTr("To connect WiFi turn off Airplane Mode");
                        verticalAlignment: Text.AlignVCenter
                        color: theme.contextMenuFontColor
                        font.pixelSize: theme.contextMenuFontPixelSize
                    }

                    Image {
                        source: "image://themedimage/widgets/common/menu/menu-item-separator-header"
                        width: parent.width
                    }

                    Item {
                        height: offlineSettings.height + actionMenu.textMargin
                        width: parent.width
                        Button {
                            id : offlineSettings
                            active: true
                            text: qsTr("Turn off Airplane Mode")
                            anchors.centerIn: parent

                            onClicked:{
                                networkListModel.setOfflineMode(false);
                                offlineCtxMenu.hide();
                            }
                        }
                    }
                }
            }
        }
}



