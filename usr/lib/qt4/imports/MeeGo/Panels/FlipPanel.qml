/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
// FlipPanel.qml
//
// Implements a flippable panel, with a separate panel
// on each side. Connects to titlePressAndHold of its
// front and back.
//
// Use two Panel or DynamicPanel instances for the front
// and back.

import "./panelsMove.js" as Code

Flipable {
    id: flipablePanel
    width: front.width
    height: front.height
    signal dragIntented

    //property bool moveDirection

    property QtObject panelObj: parent.aPanelObj


    //signal startDrag
    signal draggingFinished(int oldIndex, int newIndex)
    //signal widthDistanceDragged

    signal visibleOptionClicked()
    signal flipToFront()
    signal flipToBack()
    signal flipped()
    signal programClicked(string programId, int coordinate_x, int coordinate_y)


    // bind your panels to
    //  front:
    // and
    //  back:
    Connections {
        target: front
        onTitleClicked: {state = 'back'; flipablePanel.flipped();}
        onRightIconClicked: {state = 'back'; flipablePanel.flipped();}
    }
    Connections {
        target: back
        onTitleClicked: { state = ''; flipablePanel.flipToFront(); flipablePanel.flipped();}
        onRightIconClicked: { state = ''; flipablePanel.flipToFront(); flipablePanel.flipped();}
    }

    anchors { bottom: parent.bottom; top: parent.top }

    property real angle: 0

    transform: Rotation {
        id: scale
        origin.x: flipablePanel.width/2; origin.y: flipablePanel.height/2
        axis.x: 0; axis.y: 1; axis.z: 0 // rotate around y-axis
        angle: flipablePanel.angle
    }

    states: [
        State {
            name: "back"
            PropertyChanges { target: flipablePanel; angle: 180 }
        },
        State {
            name: "draggingMode"; when: cornerMouseArea.pressed == true
            /*because the flip-panel is inside of a loader,
            we need to change the z value of it's parent*/
            PropertyChanges { target: flipablePanel.parent; z:1000}
            PropertyChanges { target: flipablePanel; anchors.topMargin:20}
            PropertyChanges { target: allPanels; interactive:false }
        }
    ]
    transitions: Transition {
        ColorAnimation { duration: 300 }
        NumberAnimation { properties: "angle"; duration: 300; }
    }


}
