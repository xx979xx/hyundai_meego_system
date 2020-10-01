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

Window {
    id: window
    toolBarTitle: qsTr("Notes")


    property string notebookName
    property string noteName
    property string noteData

    Component.onCompleted: {
        console.log("load MainPage")
        switchBook( notebookList )
    }

    onNotebookNameChanged: {
        noteModel.notebookName = notebookName;
    }

    DataHandler {
        id: dataHandler
    }

    NotebooksModel {
        id: notebooksModel
        dataHandler: dataHandler
    }

    NoteModel {
        id: noteModel
        dataHandler: dataHandler
    }

    Component {
        id: notebookList

        NotebooksView {
            id: notebooksView
            anchors.fill: parent
            pageTitle: qsTr("Notes")

            onNotebookClicked: {
                window.addPage(noteList);
                notebookName = name;
            }

        }
    }

    Component {
        id: noteList

        NotesView {
            id: notesView
            anchors.fill: parent
            pageTitle: qsTr("Notes")
            caption: notebookName
            model: noteModel

            onNoteClicked: {
                window.addPage(noteDetailPage);
                noteName = name;
                filterModel = [];
            }

            onCloseWindow: {
                window.switchBook(notebookList);
            }
        }
    }

    Component {
        id: noteDetailPage

        NoteDetail {
            id: noteDetail
            anchors.fill: parent
            notebookID: window.notebookName
            noteName: window.noteName
            caption: noteName

            onCloseWindow:
            {
                window.switchBook(notebookList);
                window.addPage(noteList);
                filterModel = filterModelList;
            }

//            onClose: {
//                filterModel = filterModelList;
//            }
        }
    }
}
