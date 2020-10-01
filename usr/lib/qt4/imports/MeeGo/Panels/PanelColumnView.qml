/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: container
    height: fpColumn.height
    property alias model: fpContent.model
    property alias delegate: fpContent.delegate
    property alias count: fpContent.count
    Column {
        id: fpColumn
        width: parent.width
        Repeater {
            id: fpContent
        }
    }
}

