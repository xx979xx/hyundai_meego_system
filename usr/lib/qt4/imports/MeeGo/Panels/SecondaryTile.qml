/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

//SecondaryTile - base class for standard content items in the

SecondaryTileBase {
    id: fpITI
    property string description
    descriptionComponent: Column {
            width: parent.width
            Item {
                width: 1
                height: panelSize.tileTextLineSpacing
            }
            Text {
                id: fpDesc
                text: fpITI.description
                width: parent.width
                font.family: panelSize.fontFamily
                font.pixelSize: panelSize.tileFontSize //THEME - VERIFY
                color: panelColors.tileDescTextColor //THEME - VERIFY
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }
        }
}
