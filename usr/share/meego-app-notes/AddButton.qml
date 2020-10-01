/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

Rectangle
{
    id: addButton
    width: 10; height: 10;
    border.width:1
    border.color: "black"

    property bool isNote : true

    function addNote()
    {
        console.log("addButton::addNote");
    }

    function addNoteBook()
    {
        console.log("addButton::addNoteBook");
    }

    Image
    {
        anchors.fill: parent
        anchors.centerIn: parent
        source: "/usr/share/icons/default.kde4/16x16/actions/list-add.png"
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            console.log("addButton::MouseArea::onClicked");
            if (isNote)
            {
                addButton.addNote();
            }
            else
            {
                addButton.addNoteBook();
            }
        }
    }
}
