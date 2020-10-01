/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

MouseArea {
    id: box
    property int clickCount: 0
    property int selectionStart: 0
    property int selectionEnd: 0

    property real xOffset: 0
    property real yOffset: 0
    property int pendingCursorPosition: 0

    property int mouseX: 0
    property int mouseY: 0

    // The Item this mouse area handles
    property Item editor: null

    // Set to true when we are actually currently dragging a selection
    // to prevent the context menu activating in the middle of the
    // drag
    property bool currentlySelecting: false

    property bool copyOnly: false
    property bool pasteOnly: false
    property bool pasteEmpty: false

    // The mouse area needs to expand outside of the parent
    // so that the selection handles can be clicked when they
    // are in the gutter
    x: 0
    y: 0
    width: parent.width
    height: parent.height

    // Shows the context menu at cx,cy. cx & cy are in the root windows
    // coordinate space, not the CCPContextArea's.
    function showContextMenu (cx, cy) {

        pasteCheck.text = ""
        pasteCheck.paste()
        if( pasteCheck.text == "" ){
            pasteEmpty = true
        }
        else{
            pasteEmpty = false
        }

        if( selectionStart == selectionEnd ){
            box.pasteOnly = true

            if(  state != "selection" ){
                // this is a workaround for problems pasting contents into the middle of a TextInput
                // this ensures something is 'selected'
                var mapHelp = mapFromItem (top.topItem, cx, cy)
                selectionStart = editor.positionAt (mapHelp.x, mapHelp.y);
                selectionEnd = selectionStart;
            }
        }
        else{
            box.pasteOnly = false
        }

        if( (selectionStart == selectionEnd && copyOnly ) || ( box.pasteOnly && box.pasteEmpty ) )
            return

        clipboardContextMenu.setPosition(  cx, cy )
        clipboardContextMenu.show()

//        ccpMenu.opacity = box.pasteOnly && box.pasteEmpty ? 0.5 : 1

        var map = mapFromItem (top.topItem, cx, cy)
        box.mouseX = map.x
        box.mouseY = map.y
    }

    function ensureSelection() {
        // ensure selection is visible
        editor.select (selectionStart, selectionEnd);
    }

    // We set the position here, which in turn controls where the
    // selectionHandleSurface places the handles.
    // It looks like the user is dragging the handles and that controls the
    // selection, but it is actually the opposite way round
    function setStartPosition (px, py) {
        var s = editor.positionAt (px, py);
        if (s > selectionEnd) {
            s = selectionEnd;
        }

        editor.select (s, selectionEnd);
        selectionStart = s;

        var rect = editor.positionToRectangle (selectionStart);

        var map = mapToItem (top.topItem, rect.x, rect.y);
        selectionHandleSurface.startHandle.setPosition (map.x, map.y, rect.height);
    }

    function setEndPosition (px, py) {
        var e = editor.positionAt (px, py);
        if (e < selectionStart) {
            e = selectionStart;
        }

        editor.select (selectionStart, e);
        selectionEnd = e;

        var rect = editor.positionToRectangle (selectionEnd);
        var map = mapToItem (top.topItem, rect.x, rect.y);
        selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);
    }

    TextInput {
        id: pasteCheck
        visible: false
    }

    TopItem {
        id: top
        onGeometryChanged: {
            var rect = editor.positionToRectangle (selectionStart);

            var map = mapToItem (top.topItem, rect.x, rect.y);

            selectionHandleSurface.startHandle.setPosition (map.x, map.y, rect.height);

            rect = editor.positionToRectangle (selectionEnd);
            map = mapToItem (top.topItem, rect.x, rect.y);

            selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);

            map = mapToItem (top.topItem, box.mouseX, box.mouseY);
            clipboardContextMenu.setPosition ( map.x, map.y )
        }
    }

    Timer {
        id: doubleClickTimer
        interval: 250
        onTriggered: {
            parent.clickCount = 0;
            editor.cursorPosition = pendingCursorPosition;
            editor.forceActiveFocus ();
        }
    }

    onPressed: {
        doubleClickTimer.stop ();
        clickCount++;
        // Start double click timer
        // If the timer expires before another press event
        // then the click count will be reset
        doubleClickTimer.start ();

        if (clickCount == 2) {
            state = "selection"

            selectionHandleSurface.initiate()

            selectionStart = editor.positionAt (mouse.x, mouse.y);
            selectionEnd = selectionStart;

            var rect = editor.positionToRectangle (selectionStart);
            var map = mapToItem (top.topItem, rect.x, rect.y);
            selectionHandleSurface.startHandle.setPosition (map.x, map.y, rect.height);
            selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);

            currentlySelecting = true;
        } else {
            pendingCursorPosition = editor.positionAt (mouse.x, mouse.y);
        }
    }

    onReleased: {
        currentlySelecting = false;

        if (state == "selection") {
            ensureSelection()
        }
    }

    onPositionChanged: {
        if (state != "selection") {
            return;
        }

        selectionEnd = editor.positionAt (mouse.x, mouse.y);
        editor.select (selectionStart, selectionEnd);

        var rect = editor.positionToRectangle (selectionEnd);
        var map = mapToItem (top.topItem, rect.x, rect.y);

        selectionHandleSurface.endHandle.setPosition (map.x, map.y, rect.height);
    }

    onPressAndHold: {
        if (currentlySelecting == true) {
            return;
        }

        selectionHandleSurface.initiate()
        var map = mapToItem (top.topItem, mouse.x, mouse.y);


        showContextMenu (map.x, map.y);
    }

    ContextMenu {
        id: clipboardContextMenu

        content: ActionMenu {
            id: ccpMenu

            model: if(box.copyOnly){
                       [qsTr ("Copy")] }
                   else if( box.pasteOnly ){
                       [qsTr ("Paste")]
                   }else{
                       if(box.pasteEmpty){
                           [qsTr ("Copy"), qsTr ("Cut")]
                       }
                       else{
                           [qsTr ("Copy"), qsTr ("Cut"), qsTr ("Paste")]
                       }
                   }

            onTriggered: {
                editor.select ( box.selectionStart, box.selectionEnd);
                switch (index) {
                case 0:
                    if( box.pasteOnly ){
                        box.parent.paste();
                    }
                    else {
                        box.parent.copy();
                    }
                    break;

                case 1:
                    box.parent.cut();
                    break;

                case 2:
                    box.parent.paste();
                    break;

                default:
                    break;
                }

                box.state = "";
                editor.select (box.editor.cursorPosition, box.editor.cursorPosition);
                editor.cursorPosition = box.selectionStart;

                box.selectionStart = 0;
                box.selectionEnd = 0;

                clipboardContextMenu.hide()
            }

            MouseArea {
                anchors.fill: parent
                z: 1
                visible: box.pasteOnly && box.pasteEmpty
            }
        }
    }

    SelectionHandleSurface {
        id: selectionHandleSurface

        editor: parent
        z: 1

        onClose: {
            parent.state = "";
            parent.editor.select (editor.cursorPosition, editor.cursorPosition);
            parent.editor.cursorPosition = selectionStart;
            selectionStart = 0;
            selectionEnd = 0;
        }
    }

    states: [
        State {
            name: "selection"
            PropertyChanges {
                target: selectionHandleSurface
                visible: true
            }
        }
    ]
}
