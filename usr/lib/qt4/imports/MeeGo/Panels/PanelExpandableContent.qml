/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Item {
    id: fpec

    width: parent ? parent.width : 0
    height: visible? (showHeader ? fpsubheader.height : 0 ) + fpContents.height + topMargin.height + bottomMargin.height : 0

    property alias text: fpSubHeaderText.text
    property alias contents: fpContents.sourceComponent
    property alias showHeader: fpsubheader.visible

    BorderImage {
        anchors.fill: parent
        // TODO: use .sci once there is support in image provider
        source: showHeader ? "image://themedimage/widgets/apps/panels/panel-content-background" :
                             "image://themedimage/widgets/apps/panels/panel-content-background-no-header"
        border.top: 55
        border.bottom: 8
        border.left: 8
        border.right: 8
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 2*panelSize.contentAreaSideMargin

        Item {
            id:fpsubheader
            width: parent.width
            height: panelSize.contentTitleHeight
            z:1

            Text {
                id: fpSubHeaderText
                font.family: panelSize.fontFamily
                font.pixelSize: panelSize.tileFontSize
                color: panelColors.contentHeaderColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                smooth: true
            }
        }
        Item {
            id: topMargin
            width: parent.width
            height: panelSize.contentAreaTopMargin
        }
        Loader{

            id:fpContents
            height: item ? item.height : 0
            z:fpsubheader.z-1

            anchors.left: parent.left
            anchors.right: parent.right
            //clip: true

        }
        Item {
            id: bottomMargin
            width: parent.width
            height: panelSize.contentAreaBottomMargin
        }
    }
}
