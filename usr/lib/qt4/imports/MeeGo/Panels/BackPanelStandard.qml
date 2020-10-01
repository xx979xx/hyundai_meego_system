/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Panels 0.1

BackPanelGeneric {
    id: container
    property ListModel settingsListModel
    property Component settingsListDelegate: standardSettingsDelegate
    property bool clearButtonVisible :true

    signal clearHistClicked()

    bpContent: Item {
        width: parent.width
        height: childrenRect.height
        Column {
            width: parent.width
            BackPanelMessageTextItem {
                visible: settingsRepeater.count > 0
            }
            Repeater {
                id: settingsRepeater
                model: settingsListModel
                delegate: settingsListDelegate
            }
            BackPanelClearButton {
                separatorVisible: settingsRepeater.count > 0
                visible: clearButtonVisible
                onClearHistClicked: {
                    container.clearHistClicked();
                }
            }
        }
    }

    Component {
        id: standardSettingsDelegate
        BackPanelTextToggleItem {
            text: settingsTitle
            separatorVisible: true
            onToggled: {
                settingsListModel.setProperty(index, "isVisible", isOn);
            }
        }
    }
}
