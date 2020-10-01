/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.Notes 0.1

AppPage {
    id: notebookListPage

    property string selectedNotebook: qsTr("Everyday Notes (default)")
    property string defaultNotebook: qsTr("Everyday Notes (default)")
    property string selectedTitle
    property bool showCheckBox: dataHandler.getCheckBox()
    property variant selectedItems: [];
//    property variant filterModelList: [qsTr("All"), qsTr("Alphabetical order")]

    signal notebookClicked(string name, string title)
    signal updateView();

    enableCustomActionMenu: true

//    actionMenuModel: {
//        if((listView.count == 1) || (showCheckBox) ) {
//            return [qsTr("New Notebook"), qsTr("All"), qsTr("Alphabetical order")];
//        } else {
//            return [qsTr("New Notebook"), qsTr("Select Multiple"), qsTr("All"), qsTr("Alphabetical order")];
//        }
//    }

//    actionMenuPayload: [ 0, 1 ]

//    onActionMenuTriggered: {
//        if(selectedItem == 0) {
//            addDialogLoader.sourceComponent = addDialogComponent;
//            addDialogLoader.item.parent = notebookListPage;
//        } else if(selectedItem == 1) {
//            console.log("NotebooksView MultiSelect");
//            showCheckBox = true;
//            multiSelectRow.opacity = 1;
//        }
//    }

    onActionMenuIconClicked: {
        if (window.pageStack.currentPage == notebookListPage) {
            customMenu.setPosition(mouseX, mouseY);
            customMenu.show();
        }
    }

    Loader {
        id: blankStateScreenLoader

        sourceComponent: (dataHandler.isFirstTimeUse() && listView.model.count == 1) ? blankStateScreenComponent : undefined
    }

    Component {
        id: blankStateScreenComponent

        BlankStateScreen {
            id: blankStateScreen
            width: mainContainer.width
            height: mainContainer.height
            parent: mainContainer
            y: theme_listBackgroundPixelHeightTwo + 10

            mainTitleText: qsTr("Use the default notebook, or make a new one")
            buttonText: qsTr("Create a new notebook")
            firstHelpTitle: qsTr("What's a notebook?")
            secondHelpTitle: qsTr("How do I create notes?")
            firstHelpText: qsTr("A notebook is a collection of notes. Use the default notebook we have created for you, or make a new one.")
            secondHelpText: qsTr("Tap the 'Create the first note' button. You can also tap the icon in the top right corner of the screen, then select 'New note'.")

            onButtonClicked: {
                addDialogLoader.sourceComponent = addDialogComponent;
                addDialogLoader.item.parent = notebookListPage;
            }
        }
    }

    ContextMenu {
        id: customMenu
        content: Column {
            ActionMenu {
                id: firstActionMenu
                model: {
                    if((listView.count < 3) || (showCheckBox) ) {
                        return [qsTr("New Notebook")];
                    } else {
                        return [qsTr("New Notebook"), qsTr("Select Multiple")];
                    }
                }
                onTriggered: {
                    if(index == 0) {
                        addDialogLoader.sourceComponent = addDialogComponent;
                        addDialogLoader.item.parent = notebookListPage;
                    } else if(index == 1) {
                        showCheckBox = true;
                        multiSelectRow.opacity = 1;
                    }
                    customMenu.hide();
                }//ontriggered
            }//action menu
            Text {
                id: viewByText
                anchors.left: parent.left
                anchors.leftMargin: 5
                text: qsTr("View by:")
                font.pixelSize: theme_fontPixelSizeLarge
                color: theme_fontColorNormal
            }
            ActionMenu {
                id: secondActionMenu
                model: [qsTr("All"), qsTr("A-Z")]
                onTriggered: {
                    if(index == 0) {
                        dataHandler.setSort(false);
                        updateView();
                    } else if(index == 1) {
                        dataHandler.setSort(true);
                        notebooksModel.sort();
                        updateView();
                    }
                    customMenu.hide();
                }//ontriggered
            }

        }
    }

    Component {
        id: notebookDelegate

        NoteButton {
            id: notebook
//            x: 40
            width: listView.width
            height:theme_listBackgroundPixelHeightTwo
            title: name
            comment: {
                if(notesCount == 1){
                    qsTr("%1 Note").arg(notesCount);
                } else {
                    qsTr("%1 Notes").arg(notesCount);
                }
            }
            isNote : false
            checkBoxVisible: false;
            showGrip: false

            MouseArea {
                anchors.fill: parent

                onClicked: notebookClicked(name, title)

                onPressAndHold:{
                    selectedNotebook = name;
                    selectedTitle = title;
                    var map = mapToItem(listView, mouseX, mouseY);
                    contextMenu.setPosition(map.x, map.y+50);
                    contextMenu.show();
                }
            }
        }
    }

    Component {
        id: notebookDelegate2

        NoteButton {
            id: notebook2
//            x: 40
            width: listView.width
            height: theme_listBackgroundPixelHeightTwo
            title: name
            comment: {
                if(dataHandler.getChildNotes(name) == 1) {
                    qsTr("%1 Note").arg(dataHandler.getChildNotes(name));
                } else {
                    qsTr("%1 Notes").arg(dataHandler.getChildNotes(name));
                }
            }
            isNote : false
            checkBoxVisible: index != 0
            showGrip: false

            onNoteSelected: {
                var tmpList = selectedItems;
                tmpList.push(noteName);
                selectedItems = tmpList;
            }

            onNoteDeselected: {
                var tmpList = selectedItems;
                tmpList = dataHandler.removeFromString(tmpList, noteName);
                selectedItems = tmpList;
            }

            MouseArea {
                anchors.left:parent.left
                anchors.leftMargin: parent.checkBoxWidth;
                anchors.right:parent.right
                anchors.top:parent.top
                anchors.bottom:parent.bottom

                onClicked: notebookClicked(name, title)

                onPressAndHold:{
                    selectedNotebook = name;
                    selectedTitle = title;
                    contextMenu.menuX = notebook2.x + mouseX;
                    contextMenu.menuY = notebook2.y + 50/*header*/ + mouseY;
                    contextMenu.visible = true;
                }
            }
        }
    }

    Item {
        id: mainContainer
        anchors.fill: notebookListPage

        ListView {
            id: listView
            width: parent.width;
            height: parent.height
            model: notebooksModel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right


            delegate: showCheckBox ? notebookDelegate2 : notebookDelegate;
            //focus: true
            clip: true
            spacing: 1
            cacheBuffer: 600
            interactive: contentHeight > listView.height

//            header:
//                Item {
//                width:listView.width
//                height: 50
//            }
            footer:
                Item {
                width:listView.width
                height: 50
            }
        }

        BorderImage {
            id: multiSelectRow
            source: "image://meegotheme/widgets/common/action-bar/action-bar-background"
            anchors.bottom: listView.bottom
            width: listView.width
            height: 80
            opacity: 0

            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: deleteButton
                    text: qsTr("Delete")
                    height: 80
                    enabled: selectedItems.length > 0
                    hasBackground: true
                    bgSourceUp: "image://theme/btn_red_up"
                    bgSourceDn: "image://theme/btn_red_dn"
                    onClicked: {
                        deleteConfirmationDialog.show();
                        showCheckBox = false;
                        multiSelectRow.opacity = 0;
                    }
                }

                Button {
                    id: cancelButton
                    text: qsTr("Cancel")
                    anchors.bottom: listView.bottom
                    height: 80
                    onClicked: {
                        multiSelectRow.opacity = 0;
                        showCheckBox = false;
                    }
                }
            }

            Image {
                source: "image://meegotheme/widgets/common/action-bar/action-bar-shadow"
                anchors.bottom: multiSelectRow.top
                width: parent.width
            }
        }
    }

    // context menu system
    ContextMenu {
        id: contextMenu

        property string openChoice: qsTr("Open");
        property string emailChoice: qsTr("Email");
        property string deleteChoice: qsTr("Delete");
        property string renameChoice: qsTr("Rename")

        property variant choices: [ openChoice,  deleteChoice, renameChoice ]
        property variant defaultListChoices: [ openChoice ]


        content: ActionMenu {
            model:  {
                if(selectedNotebook == defaultNotebook) {
                    return contextMenu.defaultListChoices;
                } else {
                    return contextMenu.choices;
                }
            }

            onTriggered: {
                if (model[index] == contextMenu.openChoice) {
                    notebookClicked(selectedNotebook, selectedTitle)
                }
                else if (model[index] == contextMenu.deleteChoice) {
                    if (selectedItems.length > 1) {
                        if (selectedItems[0] != defaultNotebook){
                            deleteConfirmationDialog.show();
                        }
                    }
                    else if (selectedItems.length == 1)
                    {
                        if (selectedItems[0] != defaultNotebook)
                        {
                            deleteConfirmationDialog.show();
                        }
                    }
                    else
                    {
                        deleteConfirmationDialog.show();
                    }
                } else if (model[index] == contextMenu.renameChoice) {
                    renameWindow.oldName = notebookListPage.selectedTitle;
                    renameWindow.visible = true;
                }

                contextMenu.hide();
            }
        }
    }


    Loader {
        id: addDialogLoader
        anchors.fill: parent
    }

    Component {
        id: addDialogComponent

        TwoButtonsModalDialog {
            id: addDialog
            menuHeight: 125
            minWidth: 260
            dialogTitle: qsTr("Create a new Notebook");
            buttonText: qsTr("Create");
            button2Text: qsTr("Cancel");
            defaultText: qsTr("Notebook name");
            onButton1Clicked: {
                //workaround (max length of the folder name - 256)
                if (text.length > 256)
                    text = text.slice(0, 255);

                //first time use feature
                if (dataHandler.isFirstTimeUse()) {
                    dataHandler.unsetFirstTimeUse();
                    blankStateScreen.helpContentVisible = false;
                }

                updateView();
                //            opacity = 0;
                addDialogLoader.sourceComponent = undefined;

                if (dataHandler.noteBookExists(text)) {
                    informationDialog.info = qsTr("A NoteBook '%1' already exists.").arg(text);
                    informationDialog.visible = true;
                    return;
                }

                dataHandler.createNoteBook(text);
                //                updateView();
                //                //            opacity = 0;
                //                addDialogLoader.sourceComponent = undefined;
            }

            onButton2Clicked: {
                updateView();
                //            opacity = 0;
                addDialogLoader.sourceComponent = undefined;
            }

        }
    }

    ModalDialog {
        id: deleteConfirmationDialog
        acceptButtonText: qsTr("Delete");
        title: (selectedItems.length > 1) ?
                         qsTr("Are you sure you want to delete these %1 notebooks?").arg(selectedItems.length)
                       :  qsTr("Are you sure you want to delete \"%1\"?").arg(componentText);
        property string componentText: (selectedItems.length > 0) ? selectedItems[0] : selectedNotebook;
        acceptButtonImage: "image://theme/btn_red_up"
        acceptButtonImagePressed: "image://theme/btn_red_dn"

        onAccepted: {
            if (selectedItems.length > 0)
            {
                dataHandler.deleteNoteBooks(selectedItems);
                selectedItems = [];
            }
            else
            {
                dataHandler.deleteNoteBook(selectedNotebook);
            }

            opacity = 0;
            deleteReportWindow.opacity = 1;
        }

        onRejected: {
            opacity = 0;
            selectedItems = [];
        }
    }


    DeleteMoveNotificationDialog {
        id: deleteReportWindow
        opacity: 0;
        minWidth: 270
        buttonText: qsTr("OK");
        dialogTitle: (selectedItems.length > 1) ? qsTr("Notebooks deleted") : qsTr("Notebook deleted")
        text:  {
            if(selectedItems.length > 1) {
                return qsTr("\"%1\" notebooks have been deleted").arg(selectedItems.length);
            } else if(selectedItems.length == 1) {
                return qsTr("\"%1\" has been deleted").arg(selectedItems[0]);
            } else  {
                return qsTr("\"%1\" has been deleted").arg(selectedNotebook);
            }
        }

        onDialogClicked:
        {
            selectedItems = [];
            opacity = 0;
            updateView();
        }
    }

    InformationDialog {
        id: informationDialog
        visible: false

        onOkClicked: informationDialog.visible = false;
    }

    TwoButtonsModalDialog {
        id: renameWindow
        visible: false
        buttonText: qsTr("OK");
        button2Text: qsTr("Cancel");
        dialogTitle: qsTr("Rename NoteBook")
        property string oldName
        text: oldName
        menuHeight: 150
        minWidth: 260
        onButton1Clicked: {
            var newName = renameWindow.text;

            if (dataHandler.noteBookExists(newName)) {
                visible = false;
                updateView();

                informationDialog.info = qsTr("A NoteBook '%1' already exists.").arg(newName);
                informationDialog.visible = true;
                return;
            }

            dataHandler.renameNoteBook(oldName, newName);

            visible = false;
            updateView();
        }
        onButton2Clicked: {
            visible = false;
        }
    }
}

