/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Sharing 0.1
import MeeGo.Components 0.1

Item {

    id: shareContainer
    //anchors.fill: parent
    height: childrenRect.height
    width: childrenRect.width

    property alias shareCount: sharingObj.fileCount
    property alias shareType: sharingObj.shareType
    property alias itemsToShare: sharingObj.filesToShare
    property alias serviceTypes: sharingObj.serviceTypes
    property QtObject sharingObj: MeeGoUXSharingClientQmlObj {
        id: sharingObj
        shareType: MeeGoUXSharingClientQmlObj.ShareTypeImage;
    }

    property variant localStorage: null

    property string loaderSource: ""

    signal sharingComplete()

    function addItem(name) {
        sharingObj.addFile(name);
    }

    function delItem(name) {
        sharingObj.removeFile(name);
    }

    function clearItems() {
        sharingObj.clearFiles();
    }

    function addItems(itemList) {
        sharingObj.addFiles(itemList);
    }

    function setParam(fileName, paramName, paramVal) {
        sharingObj.addHashEntryToFile(fileName, paramName, paramVal);
    }

    function getParam(fileName, paramName) {
        return sharingObj.getHashEntryForFile(fileName, paramName);
    }

    function getParamDefVal(fileName, paramName, defaultVal) {
        return sharingObj.getHashEntryForFile(fileName, paramName, defaultVal);
    }

    function showContextTypes(x, y) {
        if (sharingObj.fileCount == 0)
            return;
        ctxServiceTypesAction.model = sharingObj.serviceTypes;
        ctxServiceTypes.myX = x;
        ctxServiceTypes.myY = y;
        ctxServiceTypes.setPosition(x, y);
        ctxServiceTypes.show();
    }

    function showContext(svcType, x, y) {
        if (sharingObj.fileCount == 0)
            return;
        sharingObj.serviceType = svcType;
        ctxServicesAction.payload = sharingObj.serviceModel;
        var services = sharingObj.serviceModel.getServiceTypesList();
        ctxServicesAction.model = services;

        ctxServices.setPosition(x, y);
        if ((svcType == qsTr("Email")) && (services.length == 1))
            selectService(services[0], sharingObj.serviceModel);
        else
            ctxServices.show();
    }

    function selectService(svcDispName, svcModel) {
        var svcName = svcModel.getServiceNameFromDisplayName(svcDispName);
        sharingObj.serviceName = svcName;
        loaderSource = sharingObj.getCustomUIName("ux", "blah")
        mdlSurface.show();
    }


    Translator {
        catalog: "meego-ux-sharing-qml-ui"
    }

    ContextMenu {
        id: ctxServiceTypes
        property int myX
        property int myY
        onRejected: ctxServiceTypes.hide()

        content: ActionMenu {
            id: ctxServiceTypesAction
            onTriggered: {
                sharingObj.serviceType = model[index];
                var services = sharingObj.serviceModel.getServiceTypesList();
                if ((model[index] == qsTr("Email")) && ( services.length == 1))
                    selectService(services[0], sharingObj.serviceModel);
                else
                    showContext(model[index], ctxServiceTypes.myX, ctxServiceTypes.myY);
                ctxServiceTypes.hide();
            }
        }
    }

    ContextMenu {
        id: ctxServices
        onRejected: ctxServices.hide()

        content: ActionMenu {
            id: ctxServicesAction

            onTriggered: {
                var svcDispName = model[index];
                selectService(model[index], payload);
//                var svcName = payload.getServiceNameFromDisplayName(svcDispName);
//                sharingObj.serviceName = svcName;
//                loaderSource = sharingObj.getCustomUIName("ux", "blah")
                ctxServices.hide();
//                mdlSurface.show();
            }
        }
    }

    ModalFog {
        id: mdlSurface
        autoCenter: true
        modalSurface: BorderImage {
            id: dlgItem
            anchors.centerIn: parent
            border.top: 14
            border.left: 20
            border.right: 20
            border.bottom: 20

            source: "image://themedimage/images/notificationBox_bg"
            width: flickable.width
            height: flickable.height


            property QtObject sharingObj: shareContainer.sharingObj
            property string qmlSource: shareContainer.loaderSource
            property int shareID: -1;
            property int shareProgressL: 0;
            property string shareError: "";

            Connections {
                target: sharingObj
                onShareProgress: {
                    //For now, only worry about our most recent share op
                    console.log("Got share progress, service: " + serviceName + ", opid: " + opid + ", progress: " + progress + ", msg: " + message + ", curShareID: " + dlgItem.shareID);
                    if (opid == dlgItem.shareID) {
                        if (progress == -1) {
                            //Error dlg!
                            shareError = message;
                            customLoader.sourceComponent = errorDlg;
                        } else {
                            shareProgressL = progress;
                        }
                    }
                }
            }

            Connections {
                target: mdlSurface
                onClosed: {
                    dlgItem.shareID = -1;
                    dlgItem.shareProgressL = 0;
                    dlgItem.shareError = "";
                    shareContainer.sharingComplete();
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("BI filler MouseArea clicked!");
                }
            }

            Flickable {
                id: flickable
                width: Math.min(contentWidth, screenItem.topItem.width * 0.90)
                height: Math.min(contentHeight, screenItem.topItem.height * 0.90)
                anchors.centerIn: parent
                contentWidth: customLoader.item.width
                contentHeight: customLoader.item.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Loader {
                    id: customLoader
                    source: dlgItem.qmlSource
                    anchors.centerIn: parent
                    onStatusChanged: {
                        if (customLoader.status == Loader.Ready)
                            console.log('Loaded ' + source);
                    }
                }

                Connections {
                    target: customLoader.item
                    onCancel: {
                        customLoader.source = "";
                        mdlSurface.hide();
			shareContainer.sharingComplete();
                    }
                    onShared: {
                        console.log("Shared, with share ID " + shareid);
                        customLoader.source = "";
                        dlgItem.shareID = shareid;
                        if (dlgItem.shareID != -1) {
                            console.log("Progress dialog goes here..."); //customLoader.sourceComponent = progressDlg;
                            mdlSurface.hide();
                        } else {
                            mdlSurface.hide();
                            sharingObj.clearFiles();
                        }
			shareContainer.sharingComplete();
                    }
                    onShareError: {
                        console.log("Share error occured: " + errMsg);
                        customLoader.source = "";
                        shareError = errMsg;
//                        customLoader.sourceComponent = errorDlg;
                        sharingObj.clearFiles();
                        mdlSurface.hide();
			shareContainer.sharingComplete();
                    }
                }
            }

        }
    }

    TopItem {
        id: screenItem
    }

    Component {
        id: errorDlg
        Item {
            id: errorItem
            height: childrenRect.height + 20
            width: childrenRect.width + 20
            Text {
                id: txtError
                anchors.top: parent.top
                anchors.topMargin: 10
                text: qsTr("An error occurred while sharing: %1").arg(dlgItem.shareError);
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Button {
                text: qsTr("Ok")
                anchors.top: txtError.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    mdlSurface.hide();
                }
            }
            onHeightChanged: {
                customLoader.width = errorItem.width;
                customLoader.height = errorItem.height;
            }
        }
    }

    Component {
        id: progressDlg
        Item {
            id: progressItem
            height: childrenRect.height + 20
            width: childrenRect.width + 20

            Text {
                id: txtProgress
                anchors.top: parent.top
                anchors.topMargin: 10
                text: qsTr("Upload progress: %1%%").arg(shareProgressL);
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Button {
                text: qsTr("Ok")
                anchors.top: txtProgress.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    mdlSurface.hide();
                }
            }
            onHeightChanged: {
                customLoader.width = progressItem.width;
                customLoader.height = progressItem.height;
            }
        }
    }
}

