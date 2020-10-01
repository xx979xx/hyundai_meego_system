/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0

Item {
    id: spinner
    anchors.centerIn: parent
    width: 32
    height: 32
    clip: true
    opacity: 0.0

    property int interval: 100
    property int maxSpinTime: 6000
    property bool spinning: false
    onSpinningChanged: {
        if (spinning)
        {
            cancelTimer.running = true;
            spinnerTimer.running = true;
            spinner.opacity = 1.0
        }
        else
        {
            cancelTimer.running = false;
            spinnerTimer.running = false;
            spinner.opacity = 0.0;
            spinnerImage.x = 0;
        }
    }

    Timer {
        id: cancelTimer
        interval: spinner.maxSpinTime
        onTriggered: spinner.spinning = false
    }

    Timer {
        id: spinnerTimer
        interval: parent.interval
        repeat: true
        onTriggered: {
            spinnerImage.x = (spinnerImage.x - spinner.width) % -(spinner.width * 11)
        }
    }

    Image {
        id: spinnerImage
        source: "image://theme/spinner"
        width: spinner.width * 11
        height: spinner.height
        x: 0
        y: 0
        smooth: true
    }

}
