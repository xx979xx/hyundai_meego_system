/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Panels 0.1

Item {
    id: container
    property alias model: repeater.model
    property alias delegate: repeater.delegate
    property alias modelCount: repeater.count
    property alias emptyItemsDelegate: emptyItems.delegate
    property int gridColumns: 4
    width: parent.width
    height: col.height
    Column {
        id: col
        width: parent.width
        Grid {
            id: grid
            width: parent.width
            columns: gridColumns
            children: [repeater, emptyItems]
        }
    }
    resources: [
        Repeater {
            id: repeater
        },
        Repeater {
            id: emptyItems
            model: (modelCount % gridColumns != 0 ) ? gridColumns - (modelCount % gridColumns) : 0
            delegate: SecondaryTileGridItem {
                imageBackground: "empty"
            }
        }
    ]
}
