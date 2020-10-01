/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

//BackPanelTextToggleItem  - class for standard toggle items in the
//back panel - this contains standard visual properties that are common

TileItem {
    id: backPanelTextToggleItem
    property variant defaultVal: true
    property string text
    property bool on

    signal toggled(bool isOn)

    Component.onCompleted: {
        var initialVal = panelObj.getCustomProp(custPropName, defaultVal)
        on = initialVal
        backPanelTextToggleItem.toggled(backPanelTextToggleItem.on);
    }
    contents: Item {
        height: panelSize.tileListItemContentHeight
        //width: parent.width
        Text {
            id: bpText
            text: backPanelTextToggleItem.text
            font.family: panelSize.fontFamily
            font.pixelSize: panelSize.tileFontSize
            color: panelColors.tileDescTextColor //THEME - VERIFY
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: bpToggleButton.left
            anchors.rightMargin: anchors.leftMargin
            wrapMode: Text.NoWrap
            elide: Text.ElideRight
        }

        ToggleButton{
            id: bpToggleButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            on: backPanelTextToggleItem.on
            onOnChanged: {
                backPanelTextToggleItem.on = on;
            }
            onToggled:{
                backPanelTextToggleItem.toggled(isOn);
                panelObj.setCustomProp(custPropName, isOn);
            }
        }
    }
}
