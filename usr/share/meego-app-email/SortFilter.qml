/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

Item {
    id: container
    property int topicHeight: 50
    property alias model: listView.model
    property variant topics: []
    onTopicsChanged: {
        listModel.clear()
        for (var i=0; i < topics.length; i++)
            listModel.append({"mitem": topics[i], "mindex": i})
    }
    signal topicTriggered(int index)
    property alias currentTopic: listView.currentIndex
    property alias interactive: listView.interactive

    ListView {
        id: listView
        height: parent.height
        anchors.fill: parent
        interactive: false

        //onCurrentIndexChanged: container.topicTriggered(currentIndex)

        spacing: 1
        model: ListModel { id: listModel }
        delegate: Item {
            id: contentItem
            width: container.width
            height: container.topicHeight

            property int index: mindex

            Image {
                width: parent.width
                source: "image://theme/email/divider_l"
            }
            
            Text {
                id: contentLabel
                height: container.topicHeight
                width: container.width
                text: mitem
                font.pixelSize: theme.fontPixelSizeLarge
                color: theme.fontColorNormal
                anchors.left: parent.left
                anchors.leftMargin: 15
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.bold: {
                    if (mindex == 0)
                    {
                        if (folderListView.dateSortKey == 1)
                            return "false";
                        else
                            return "true";
                    }
                    else if (mindex == 1)
                    {
                        if (folderListView.senderSortKey == 1)
                            return "false";
                        else
                            return "true";
                    }
                    else if (mindex == 2)
                    {
                        if (folderListView.subjectSortKey == 1)
                            return "false";
                        else
                            return "true";
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index
                    container.topicTriggered(index)
                }
            }
        }
    }
}
