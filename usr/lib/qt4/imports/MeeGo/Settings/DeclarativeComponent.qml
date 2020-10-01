/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1 as MeeGo
import MeeGo.Settings 0.1

MeeGo.AppPage {
	id: container

	property string source: window.applicationData


	DeclarativeSettingsModel {
		id: declarativeSettings
		document: source

		Component.onCompleted: {

		}

		onStateChanged: {
			if(newState == DeclarativeSettingsModel.Ready) {
				for(var g=0; g< declarativeSettings.groups.length; g++){
					var group = declarativeSettings.groups[g];
					for(var i = 0;i<group.settings.length; i++){
						if(group.settings[i].type == TabletSettingsSetting.TextType){
							var text = textEdits.createObject(column);
							text.key = group.settings[i].key
							text.title = group.settings[i].title
							if(group.settings[i].value != undefined)
								text.value = group.settings[i].value
							else console.log("error: text value is undefined!")
						}
						else if(group.settings[i].type == TabletSettingsSetting.SelectionType) {
							///selection type
						}
						else if(group.settings[i].type == TabletSettingsSetting.BooleanType) {
							var boholean = booleans.createObject(column);
							boholean.key = group.settings[i].key
							boholean.title = group.settings[i].title
							if(group.settings[i].value != undefined)
								boholean.value = group.settings[i].value
							else console.log("error: boolean value is undefined!")
						}
						else if(group.settings[i].type == TabletSettingsSetting.IntegerType) {

							var integer = integers.createObject(column);
							integer.title = group.settings[i].title
							integer.key = group.settings[i].key
							integer.max = group.settings[i].max
							integer.min = group.settings[i].min

							if(group.settings[i].value != undefined){
								console.log("trying to set integer value to: " + group.settings[i].value)
								integer.value = group.settings[i].value
							}
							else console.log("error: integer value is undefined!")
						}
						else {
							console.log("unknown widget type!!!!")
						}
					}
				}
			}
		}
	}

	Flickable {
		contentHeight: column.height
		anchors.fill: parent
		interactive: true
		Column {
			id: column
			anchors.fill: parent
			spacing: 20
		}
	}



	Component {
		id: booleans

        Image {
            source: "image://theme/settings/pulldown_box_2"
			property string key: ""
			property string title: ""
			property bool value

			width: parent.width
			height: 50

			Text {
				id: textTitle
				text: title
				anchors.left: parent.left
				anchors.verticalCenter: togglebutton.verticalCenter
			}

			MeeGo.ToggleButton {
				id: togglebutton
				on: value
				anchors.right: parent.right
				anchors.rightMargin: 20
				anchors.verticalCenter: parent.verticalCenter
				onToggled: {
					declarativeSettings.setValue(parent.key, togglebutton.on);
				}
			}
		}
	}

	Component {
		id: integers

        Image {
            source: "image://theme/settings/pulldown_box_2"
            id: integersContainer
			property string key: ""
			property string title: ""
			property bool value
			property int max: 100
			property int min: 0

			width:parent.width
			height: 50

			Text {
				id: textTitle
				text: title
				anchors.left: parent.left
				anchors.verticalCenter: slider.verticalCenter
			}

			MeeGo.Slider {
				id: slider
				min: parent.min
				max: parent.max
				anchors.right: parent.right
				anchors.rightMargin: 20
				anchors.verticalCenter: parent.verticalCenter
				width: parent.width - textTitle.width - 40
				value: parent.value
				onSliderChanged: {
					declarativeSettings.setValue(integersContainer.key, slider.value);
				}
			}
		}
	}

	Component {
		id: textEdits
		Image {
			width: parent.width
			source: "image://theme/settings/pulldown_box_2"

			id: textEditsContainer
			property string key: ""
			property string title: ""
			property string value: ""

			height: 50

			Text {
				id: textTitle
				text: title
				anchors.verticalCenter: textEdit.verticalCenter
			}

			MeeGo.TextEntry {
				id: textEdit
				text: value
				anchors.right: parent.right
				anchors.rightMargin: 20

				onTextChanged: {
					declarativeSettings.setValue(parent.key,text);
				}
			}
		}
	}
}
