/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.Contacts 0.1

Column {
    id: detailsColumn
    spacing: 1
    anchors {left:parent.left; right: parent.right; }

    property int initialHeight: childrenRect.height
    property bool validInput: false
    property int itemMargins: 10

    property variant existingDetailsModel: null
    property variant contextModel: null

    property string headerLabel
    property string expandingBoxTitle
    property Component newDetailsComponent: null
    property Item newFieldItem: null
    property Component existingDetailsComponent: null

    property string addLabel: qsTr("Add")
    property string cancelLabel: qsTr("Cancel")

    function getNewDetails() {
        if (detailsRepeater.itemCount <= 0)
            return [""];

        for (var i = 0; i < detailsRepeater.itemCount; i++) {
            var arr = detailsRepeater.itemList[i].getDetails(false);
            for (var key in arr)
                detailsModel.setProperty(i, key, arr[key]);
        }

        //We only need to query the first one because each child
        //has red only access to the full model
        return detailsRepeater.itemList[0].getNewDetailValues();
    }

    function removeItemFromList (index) {
        var items = detailsRepeater.itemList;
        var results = items.splice(index, 1);
        detailsRepeater.itemList = items;
        detailsRepeater.itemCount -= 1;
    }

    ListModel{
        id: detailsModel 

        Component.onCompleted:{
            if (existingDetailsModel) {
                var tmpArr = newFieldItem.parseDetailsModel(existingDetailsModel, contextModel);
                for (var i = 0; i < tmpArr.length; i++) {
                    detailsModel.append({"type" : ""});
                    for (var key in tmpArr[i])
                         detailsModel.setProperty(i, key, tmpArr[i][key]);
                }
            }
        }
    }

    Item {
        id: detailsHeader
        width: parent.width
        height: 70
        opacity: 1

        Text {
            id: label_details
            text: headerLabel
            color: theme_fontColorNormal
            font.pixelSize: theme_fontPixelSizeLarge
            styleColor: theme_fontColorInactive
            smooth: true
            anchors {bottom: detailsHeader.bottom; bottomMargin: itemMargins;
                     left: detailsHeader.left; leftMargin: 30}
        }
    }

    Repeater {
        id: detailsRepeater

        model: detailsModel
        width: parent.width
        opacity: (model.count > 0 ? 1  : 0)
        clip: true

        property int itemCount 
        property variant itemList: []

        delegate: Image {
            id: imageBar
            source: "image://theme/contacts/active_row"
            parent: detailsRepeater
            width: parent.width

            property Item existingFieldItem: null
        
            Item {
                id: existingContentArea 

                anchors {top: parent.top; bottom: parent.bottom; 
                         margins: itemMargins;}
            }

            //REVISIT: Should use a loader for this?
            Component.onCompleted: {
                if (existingDetailsComponent) {
                    if (existingFieldItem) existingFieldItem.destroy();
                    existingFieldItem = existingDetailsComponent.createObject(existingContentArea)

                    //REVISIT: Pass in these values to createObject once it
                    //has support for passing in properties - QtQuick 1.1
                    existingFieldItem.newDetailsModel = detailsRepeater.model;
                    existingFieldItem.rIndex = index;
                    existingFieldItem.updateMode = true;
 
                    //REVISIT: Better way to calculate? Use a state?
                    //We need to grow the parent based on the height
                    //of the children we're stuffing in
                    imageBar.height = existingFieldItem.height + (itemMargins * 2)
                    detailsColumn.height += imageBar.height

                    //REVISIT: We can replace this with the itemAt() Repeater
                    //function once its available - QtQuick 1.1
                    detailsRepeater.itemCount += 1;
                    var items = detailsRepeater.itemList;
                    items.push(existingFieldItem);
                    detailsRepeater.itemList = items;
                }
            }

            Image {
                id: delete_button
                source: "image://theme/contacts/icn_trash"
                width: 36
                height: 36
                anchors {top: parent.top; right: parent.right; 
                         margins: itemMargins;}
                opacity: 1
                MouseArea {
                    id: mouse_delete
                    anchors.fill: parent
                    onPressed: {
                        delete_button.source = "image://theme/contacts/icn_trash_dn";
                    }
                    onClicked: {
                        if (detailsRepeater.count == 1) {
                            existingFieldItem.resetFields();
                        } 
                        else if (detailsRepeater.count != 1) {
                            removeItemFromList(index);
                            detailsRepeater.model.remove(index);
                        }
                        else
                            newFieldItem.resetFields();

                        delete_button.source = "image://theme/contacts/icn_trash";
                        //REVISIT: Should use states for this
                        detailsColumn.height -= existingFieldItem.height
                    }
                }
                Binding{target: delete_button; property: "visible"; value: false; when: !existingFieldItem.validInput}
                Binding{target: delete_button; property: "visible"; value: true; when: existingFieldItem.validInput}
            }
        }
    }
    Binding {target: detailsColumn; property: "validInput"; value: true; when: detailsRepeater.count > 0}
    Binding {target: detailsColumn; property: "validInput"; value: false; when: detailsRepeater.count <= 0}

    Item {
        id: addFooter
        width: parent.width
        height: 80

        Image {
            id: addBar
            source: "image://theme/contacts/active_row"
            anchors {fill: parent; bottomMargin: 1}

            ExpandingBox {
                id: detailsBox

                property int boxHeight

                anchors {top: addBar.top; leftMargin: itemMargins}
                width: parent.width
                titleText: expandingBoxTitle
                titleTextColor: theme_fontColorNormal

                iconRow: [
                    Image {
                        id: add_button
                        source: "image://theme/contacts/icn_add"
                        anchors { verticalCenter: parent.verticalCenter; }
                        fillMode: Image.PreserveAspectFit
                        opacity: 1
                    }
                ]

                detailsComponent: fieldDetailComponent

                onExpandingChanged: {
                    add_button.source = expanded ? "image://theme/contacts/icn_add_dn" : "image://theme/contacts/icn_add";
                    detailsColumn.height = expanded ? (initialHeight + detailsItem.height) : initialHeight;
                }
            }

            Component {
                id: fieldDetailComponent
                Item {
                    id: fieldDetailItem
                    height: childrenRect.height + itemMargins*2
                    width: parent.width
                    anchors {left:parent.left; top: parent.top; margins: itemMargins;}

                    Component.onCompleted: {
                        if (newDetailsComponent) {
                            if (newFieldItem) newFieldItem.destroy();
                            newFieldItem = newDetailsComponent.createObject(newContentArea);
                            newFieldItem.newDetailsModel = detailsModel;
                            newFieldItem.rIndex = detailsModel.count;
                        }
                    }

                    Item {
                        id: newContentArea 

                        height: childrenRect.height
                        width: parent.width
                    }

                    Button {
                        id: addButton

                        width: 100
                        height: 36
                        text: addLabel
                        font.pixelSize: theme_fontPixelSizeMediumLarge
                        bgSourceUp: "image://theme/btn_blue_up"
                        bgSourceDn: "image://theme/btn_blue_dn"
                        anchors {right: cancelButton.left; rightMargin: itemMargins;
                                 top: newContentArea.bottom; topMargin: itemMargins;}
                        enabled: newFieldItem.validInput
                        onClicked: {
                            detailsBox.expanded = false;
                            var arr = newFieldItem.getDetails(true);
                            detailsModel.append({"type" : ""});
                            for (var key in arr)
                                detailsModel.setProperty(detailsModel.count - 1, key, arr[key]);
                        }
                    }

                    Button {
                        id: cancelButton

                        width: 100
                        height: 36
                        text: cancelLabel
                        font.pixelSize: theme_fontPixelSizeMediumLarge
                        anchors {right: newContentArea.right; rightMargin: itemMargins;
                                 top: newContentArea.bottom; topMargin: itemMargins;}
                        onClicked: {
                            detailsBox.expanded = false;
                            newFieldItem.resetFields();
                        }
                    }
                }
            }
        }
    }
}
