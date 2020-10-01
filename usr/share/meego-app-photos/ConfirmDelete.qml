/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

ModalDialog {
    property alias text: confirmText.text
    property variant model
    property variant items

    signal confirmed()

    title: labelConfirmDelete
    acceptButtonText: labelDelete
    acceptButtonImage: "image://themedimage/widgets/common/button/button-negative"
    acceptButtonImagePressed: "image://themedimage/widgets/common/button/button-negative-pressed"

    content: Text {
        id: confirmText
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
        wrapMode: Text.WordWrap
    }

    onAccepted: {
        model.destroyItemsByID(items)
        confirmed()
    }
}
