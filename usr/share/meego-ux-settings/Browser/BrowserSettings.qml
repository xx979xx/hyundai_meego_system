/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1 as MeeGo
import MeeGo.Settings 0.1

MeeGo.AppPage {
    id: bsContainer
    pageTitle: qsTr("Browser")
    anchors.fill: parent
    property int vkbheight: 0
    property variant current: bsContainer

    BrowserSettingModel {
        id:settings
    }

    Flickable
    {
        id: flickableContent
        anchors.fill: parent
        contentHeight: settingGroups.height
        clip: true

        MeeGo.ModalDialog {
           id: dlg

           title : qsTr("Are you sure?")
           buttonWidth: 200
           buttonHeight: 35
           showCancelButton: true
           showAcceptButton: true
           cancelButtonText: qsTr( "No" )
           acceptButtonText: qsTr( "Yes" )
	   width: parent.width/2
           height: decorationHeight + dlgContent.paintedHeight + 20
      	   property alias message: dlgContent.text
           property string data: ""

           content: Text {
               id: dlgContent
               width: parent.width
               anchors.top: parent.top
               anchors.topMargin:10
               anchors.left: parent.left
               anchors.leftMargin:20
               wrapMode: Text.WordWrap

           }

           // handle signals:
           onAccepted: {
              if(data=="restore") {
                 settings.RestoreDefaultValues();
                 return;
              }
              if(settings.needClear) {
                  settings.AddDataItem(data)
              } else {
                  settings.ResetDataItemsToBeRemoved();
                  settings.AddDataItem(data)
                  settings.needClear = true;
              }
           }
           onRejected: {
           }
       }

        Column
        {
            id: settingGroups
            width: parent.width
            Image {
                id: startupSetting
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("On start up")
                    width: Math.min(paintedWidth, parent.width - startUpDropDown.width -10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.DropDown {
                    id: startUpDropDown
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    width: 400
                    titleColor: "black"
                    model: [qsTr("Open New Tab age"), qsTr("Reopen last visited pages")] //settings.searchEngineList
                    onTriggered: {
                        settings.pageOpenedOnStartup = index ? BrowserSettingModel.OpenLastSessionPages : BrowserSettingModel.OpenDefaultPages
                    }
                    Component.onCompleted: {
                        selectedIndex = settings.pageOpenedOnStartup == BrowserSettingModel.OpenDefaultPages ? 0 : 1;
                        selectedTitle = model[selectedIndex]
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Default search engine")
                    width: Math.min(paintedWidth, parent.width - searchEngineDropDown.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.DropDown {
                    id: searchEngineDropDown
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    width: 400
                    titleColor: "black"
                    model: settings.searchEngineList
                    onTriggered: {
                        settings.defaultSearchEngine = settings.searchEngineList[index];
                    }
                    Component.onCompleted: {
                        selectedTitle = settings.defaultSearchEngine;
                        var conut = settings.searchEngineList.length;
                        for (var j = 0; j < conut; j++){
                            if (settings.defaultSearchEngine == settings.searchEngineList[j]) {
                                selectedIndex = j;
                                break;
                            }
                        }
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Show bookmarks bar")
                    width: Math.min(paintedWidth, parent.width - bookmarkToggleButton.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: bookmarkToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: settings.showBookmarkBar
                    onToggled: {
                        settings.showBookmarkBar = on;
                    }
                }
            }

            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Offer to save passwords")
                    width: Math.min(paintedWidth, parent.width - passwordToggleButton.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: passwordToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: settings.savePassword
                    onToggled: {
                        settings.savePassword = on;
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Allow JavaScript")
                    width: Math.min(paintedWidth, parent.width - javascriptToggleButton.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: javascriptToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: settings.allowJavascript
                    onToggled: {
                        settings.allowJavascript = on;
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Allow Images")
                    width: Math.min(paintedWidth, parent.width-imageToggleButton.width)
                    elide: Text.ElideNone
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: imageToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: settings.allowImages
                    onToggled: {
                        settings.allowImages = on;
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Allow Cookies")
                    width: Math.min(paintedWidth, parent.width-cookiesToggleButton.width)
                    elide: Text.ElideNone
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: cookiesToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: settings.allowCookies
                    onToggled: {
                        settings.allowCookies = on;
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Block popups")
                    width: Math.min(paintedWidth, parent.width - popupsToggleButton.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: popupsToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: !settings.allowPopup
                    onToggled: {
                        settings.allowPopup = !on;
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Use HTTP proxy")
                    width: Math.min(paintedWidth, parent.width - proxyToggleButton.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.ToggleButton {
                    id: proxyToggleButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: settings.useHttpProxy
                    onToggled: {
                        settings.useHttpProxy = on;
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                visible: proxyToggleButton.on
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("HTTP Proxy details")
                    width: Math.min(paintedWidth, parent.width - proxyBox.width - dotChar.width - portBox.width - 10)
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                MeeGo.TextEntry {
                    id: proxyBox
                    text: settings.proxyHost
                    width: 300
                    anchors.right: dotChar.left
                    anchors.verticalCenter: parent.verticalCenter
                    onTextChanged: {
                        if(textInput.focus) {
                            settings.proxyHost = proxyBox.text
                            if(portBox.text != "")
                                settings.proxyPort = portBox.text
                            else settings.proxyPort = 0
                        }
                    }
                }
                Text {
                    id: dotChar
		    anchors.left: proxyBox.left+4
                    anchors.right: portBox.left
                    anchors.rightMargin:4
                    text: ":"
                    anchors.verticalCenter: parent.verticalCenter
                }
                MeeGo.TextEntry {
                    id: portBox
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: settings.proxyPort
                    width: 70
                    defaultText: "0"
                    anchors.verticalCenter: parent.verticalCenter
                    validator: IntValidator { bottom: 0; top: 65535 }
                    onTextChanged: {
                        if(textFocus) {
                            if(portBox.text != "")
                                settings.proxyPort = portBox.text
                            else settings.proxyPort = 0
                            settings.proxyHost = proxyBox.text
                        }
                    }
                }
            }
            Image {
                source: "image://theme/pulldown_box"
                width: parent.width
                height:  privacyColumn.height + 20
                Image {
                    source: "image://theme/pulldown_box"
                    width: parent.width
                    anchors.bottom: parent.bottom
                }
                Column {
                    id: privacyColumn
                    width: parent.width-5
                    spacing: 0
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    MeeGo.Button {
                        id: clearHisotryBtn
                        width: parent.width
                        height: 50
                        text: qsTr("Clear Browsing History")
			font.pixelSize: theme_fontPixelSizeNormal
                        onClicked: {                           
                            dlg.message = qsTr("Are you sure about clearing the browsing history?")
                            dlg.data = "History"
			    dlg.show()
                        }
                    }
                    MeeGo.Button {
                        id: clearDownloadBtn
                        width: parent.width
                        height: 50
                        text: qsTr("Clear Download History")
			font.pixelSize: theme_fontPixelSizeNormal
                        onClicked: {                            
                            dlg.message = qsTr("Are you sure about clearing the download history?")
                            dlg.data = "Downloads"
                            dlg.show()
                        }
                    }
                    MeeGo.Button {
                        id: clearCookieBtn
                        width: parent.width
                        height: 50
                        text: qsTr("Clear Cookies")
			font.pixelSize: theme_fontPixelSizeNormal
                        onClicked: {
                            dlg.message = qsTr("Are you sure about clearing your cookies?")
                            dlg.data = "Cookies"
                            dlg.show()
                        }
                    }
                    MeeGo.Button {
                        id: clearPasswordBtn
                        width: parent.width
                        height: 50
                        text: qsTr("Clear Saved Passwords")
                        font.pixelSize: theme_fontPixelSizeNormal
                        onClicked: {
                            dlg.message = qsTr("Are you sure about clearing your saved passwords?")
                            dlg.data = "Passwords"
                            dlg.show()
                        }
                    }
                    MeeGo.Button {
                        id: restoreButton
                        width: parent.width
                        height: 50
                        text: qsTr("Restore default settings")
                        font.pixelSize: theme_fontPixelSizeNormal
                        onClicked: {
                            dlg.message = qsTr("All browser settings will be reset to factory setting")
			    dlg.data = "restore"
                            dlg.show()
                        }
                    }
                }
            }

            // Button to launcher browser
            Image {
                id: launchBtn
                source: "image://theme/pulldown_box"
                width: parent.width
                height: startupSetting.height
                Image {
                    id: browserIcon
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://themedimage/icons/launchers/meego-app-browser"
                }
                Text {
                    anchors.top: parent.top
                    anchors.left: browserIcon.right
                    anchors.leftMargin: 10
                    text: qsTr("Go to Browser")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }
                Image {
                    id: btnIcon
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://themedimage/images/breadcrumb_arrow"
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        settings.LaunchBrowser();
                    }
                }
                states: [
                    State {
                        name: "pressed"
                        PropertyChanges {
                            target: launchBtn
                            source: "image://theme/settings/btn_settingentry_dn"
                        }
                        when: mouseArea.pressed
                    },
                    State {
                        name: "normal"
                        PropertyChanges {
                            target: launchBtn
                            source: "image://theme/pulldown_box"
                        }
                        when: !mouseArea.pressed
                    }
                ]
            }
        } // Column
    } // Flickr

    Connections {
        target: mainWindow
        onVkbHeight: {
            var map = current.mapToItem(bsContainer, 0, 0);
            vkbheight = height;
            if ((bsContainer.height - map.y - current.height) < vkbheight)l
                flickableContent.contentY += vkbheight - (bsContainer.height - map.y - current.height) + 5
        }
    }
    Connections {
        target: settings
        onPageOpenedOnStartupChanged: {
            startUpDropDown.selectedIndex = settings.pageOpenedOnStartup == BrowserSettingModel.OpenDefaultPages ? 0 : 1;
            startUpDropDown.selectedTitle = startUpDropDown.model[startUpDropDown.selectedIndex]
        }
        onDefaultSearchEngineChanged: {
            var conut = settings.searchEngineList.length;
            searchEngineDropDown.selectedTitle = settings.defaultSearchEngine;
            for (var j = 0; j < conut; j++){
                if (settings.defaultSearchEngine == settings.searchEngineList[j]) {
                    searchEngineDropDown.selectedIndex = j;
                    break;
                }
            }
        }
        onShowBookmarkBarChanged: {
            bookmarkToggleButton.on = settings.showBookmarkBar
        }
        onSavePasswordChanged: {
            passwordToggleButton.on = settings.savePassword
        }
        onAllowJavascriptChanged: {
            javascriptToggleButton.on = settings.allowJavascript
        }
        onAllowCookiesChanged: {
            cookiesToggleButton.on = settings.allowCookies
        }
        onAllowImagesChanged: {
            imageToggleButton.on = settings.allowImages
        }
        onAllowPopupChanged: {
            popupsToggleButton.on = !settings.allowPopup
        }
        onUseHttpProxyChanged: {
            proxyToggleButton.on = settings.useHttpProxy
        }
    }
}
