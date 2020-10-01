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

AppPage {
    id: accountEditPage
    anchors.fill: parent

    // The label is used as the user visible string in the crumb trail
    pageTitle: accountFactory.accountServiceName(accountContent.icon)

    property variant accountContent

    Component.onCompleted: {
        accountContent.parent = accountContentPlaceholder;
        accountContent.anchors.top = accountContent.parent.top;
        accountContent.anchors.topMargin = 10;
        pageTitle = accountFactory.accountServiceName(accountContent.icon)
    }

    Connections {
        target: accountContent
        onFinished: {
            spinner.hide();
            window.popPage();
            // this second call is for the settings module
            window.popPage();
        }

        onAccountCreationAborted: {
            spinner.hide();
        }
    }

    Item {
        id: pageContent
        parent: accountEditPage.content
        anchors.fill: parent

        AccountContentFactory {
            id: accountFactory
        }

        Title {
            id: title
            text:  accountFactory.accountServiceName(accountContent.icon)
            subtext: " " // i18n ok

            Image {
                id: accountIcon
                source: accountFactory.accountIcon(accountContent.icon)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 5
            }


            label.anchors.left: accountIcon.right
            label.anchors.top: undefined
            label.anchors.verticalCenter: title.verticalCenter
            label.font.pixelSize: theme_fontPixelSizeLargest
        }

        Flickable {
            id: flickable
            flickableDirection: Flickable.VerticalFlick
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            contentHeight: mainArea.height

            Column {
                id: mainArea
                anchors.left:  parent.left
                anchors.right: parent.right
                height: childrenRect.height

                ContentRow {
                    id: accountContentPlaceholder
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: childrenRect.height + 20
                }

                ContentRow {
                    Item {
                        id: centerItem
                        width: childrenRect.width
                        height: parent.height
                        anchors.centerIn: parent

                        Button {
                            id: doneButton
                            anchors {
                                margins: 10
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }

                            text: qsTr("Done")
                            textColor: theme_buttonFontColor
                            bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                            bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"

                            onClicked: {
                                spinner.show();
                                accountContent.createAccount();
                            }
                        }

                        Button {
                            id: cancelButton
                            anchors {
                                margins: 10
                                left: doneButton.right
                                verticalCenter: parent.verticalCenter
                            }

                            text: qsTr("Cancel")
                            textColor: theme_buttonFontColor
                            bgSourceUp: "image://themedimage/widgets/common/button/button-negative"
                            bgSourceDn: "image://themedimage/widgets/common/button/button-negative-pressed"

                            onClicked: window.popPage();
                        }
                    }
                }
            }
        }

        ModalSpinner {
            id: spinner
        }
    }
}
