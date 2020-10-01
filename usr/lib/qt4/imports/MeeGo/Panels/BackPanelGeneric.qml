/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Panels 0.1


SimplePanel {
    id: backPanelGeneric

    property Component bpContent
    property string subheaderText

    isBackPanel: true

    panelComponent: backPanel

    Component {
        id: backPanel
        Flickable {
            id: bpComp
            interactive: (height < contentHeight)
            anchors.fill: parent
            contentHeight: myContent.height
            Column {
                id: myContent
                width: parent.width
                PanelExpandableContent {
                    id: backPanelCol
                    width: parent.width
                    text: subheaderText
                    contents: bpContent
                }
                PanelExpandableContent {
                    id: panelSettings
                    width: parent.width
                    text: qsTr("Panels")
                    contents: TileListItem {
                        imageSource: "image://themedimage/icons/settings/everyday-settings"
                        text: qsTr("Manage panels")
                        onClicked: {
                            spinnerContainer.startSpinner();
                            appsModel.launch("meego-qml-launcher --opengl --app meego-ux-settings --cmd showPage --cdata Personalize --fullscreen")
                        }
                    }
                }
            }
        }
    }
}

