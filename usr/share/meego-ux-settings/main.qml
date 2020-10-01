/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Settings 0.1
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1 as Ux
import Qt.labs.gestures 2.0

Ux.Window {
	id: window
	property variant allSettingsArray: [qsTr("All Settings")];
	property variant applicationData

	bookMenuModel: allSettingsArray.concat(settingsModel.settingsApps)
	automaticBookSwitching: false
	//filterModel: allSettingsArray.concat(settingsModel.settingsApps)
	//filterPayload: settingsModel.settingsAppPaths
	Component.onCompleted: { switchBook(landingPageComponent) }

	onBookMenuTriggered: {
		console.log("book menu triggered ftw")
		if(index == 0) {
			window.switchBook(landingPageComponent)
			return;
		}

		translator.catalog = settingsModel.settingsTranslationPaths[index - 1]
		topView = settingsModel.settingsAppPaths[index - 1]

		//window.applicationPage = Qt.createComponent(payloadFile);
	}

	property string topView

	onTopViewChanged: {
		if(topView != "") {

			console.log(topView.lastIndexOf("xml"))
			if(topView.lastIndexOf("xml") == topView.length - 3) {
				console.log("loading xml setting: " + topView)
				window.applicationData = topView
				window.switchBook(declarativeComponent)
			}
			else {
				window.switchBook(Qt.createComponent(topView))
			}
		}
	}

	Labs.Translator {
		id: translator
	}

	SettingsModel {
		id: settingsModel
	}

	Connections {
		target: mainWindow
		onCall: {
			var cmd = parameters[0];
			var cdata = parameters[1];

			console.log("Remote Call: " + cmd + " - " + cdata);
			if (cmd == "showPage")	{
				var page = cdata.split(",")[0];

				if(page == "settings" || page == "") {
					window.switchBook(landingPageComponent)
				    return;
				}

				for(var i=0; i< settingsModel.settingsAppNames.length; i++) {
					if(page == settingsModel.settingsAppNames[i]) {
						var payloadFile  = settingsModel.settingsAppPaths[i]
						window.applicationData = cdata
						window.switchBook(Qt.createComponent(payloadFile))
					}
				}
			}
		}
	}

    Loader {
        id: dialogLoader
        anchors.fill: parent
    }

    Component {
        id: declarativeComponent
        DeclarativeComponent {

        }
    }

	Component {
		id: landingPageComponent
		Ux.AppPage {
			id: landingPage
			pageTitle: qsTr("Settings")

			Component.onCompleted: {
				topView=""
			}

			onSearch: {
				if(settingsHacksGconf.value)
					settingsModel.filter(needle)
			}

			Labs.GConfItem {
				id: settingsHacksGconf
				defaultValue: false
				key: "/meego/ux/settings/settingshacks"
			}

			ListView {
				id: listView
				//parent:  landingPage.content
				anchors.fill: parent
				model: settingsModel
				clip: true
				delegate: BorderImage {
					id: container
					source: "image://theme/settings/btn_settingentry_up"
					border.left: 5; border.top: 5
					border.right: 5; border.bottom: 5

					//height: 50
					width: parent.width

					BorderImage {
						id: icon
						anchors.left: parent.left
						anchors.leftMargin: 20
						anchors.verticalCenter: parent.verticalCenter
						source: model.icon != "image://systemicon/" ? model.icon: "image://meegotheme/icons/settings/everyday-settings"
						onStatusChanged: {
						    if(icon.status == Image.Ready) {
								console.log("image width: " + width + " height: " + height)
						    }
						    if(icon.status == Image.Error) {
								///fallback
								icon.source =  "image://meegotheme/icons/settings/everyday-settings"
						    }
						}

						Component.onCompleted: {
							console.log("app: " + model.title + " icon: " + model.icon + " src: " + icon.source)
						}

					}

					Text {
						anchors.left: icon.right
						anchors.leftMargin: 20
						anchors.verticalCenter: parent.verticalCenter
						width: 200
						text: model.title
						height: 30
						font.pixelSize: theme_fontPixelSizeLarge
					}

					GestureArea {
						//id: mouseArea
						anchors.fill: parent

						Tap {
							id: tapArea
							onFinished: {
								translator.catalog = model.translation
								//window.topView = model.path

								///This is added because of influential people:
								if(topView.lastIndexOf("xml") == topView.length - 3) {
									console.log("loading xml setting: " + topView)
									window.applicationData = topView
									window.addPage(declarativeComponent)
								}
								else {
									window.addPage(Qt.createComponent(model.path))
								}
							}
						}
					}

					MouseArea {
						id: mouseArea
						anchors.fill:  parent
					}

					states: [
						State {
							name: "pressed"
							PropertyChanges {
								target: container
								source: "image://theme/settings/btn_settingentry_dn"
							}
							when: mouseArea.pressed
						},
						State {
							name: "normal"
							PropertyChanges {
								target: container
								source: "image://theme/settings/btn_settingentry_up"
							}
							when: !mouseArea.pressed
						}
					]

				}
			}

		}
	}
}

