/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass Spinner
  \title Spinner
  \section1 Spinner
  The Spinner shows a spinning animation indicating that a currently running process takes some time to finish.

  \section2  API Properties
      \qmlproperty int interval
      \qmlcm sets the time in milliseconds needed for one animation step.

      \qmlproperty int maxSpinTime
      \qmlcm sets how long the spinner should run repeatedly in milliseconds.

      \qmlproperty bool continuousSpinning
      \qmlcm if set to true the spinner will always spin.

      \qmlproperty bool spinning
      \qmlcm Setting this property to true will show the Spinner and start its animation.
             Settings this property to false will stop the animation and hide the Spinner.
             Once the animations is started, this property will be set to false automatically
             after x milliseconds given by the property maxSpinTime.

      \qmlproperty alias source
      \qmlcm sets the image used for the animations of the Spinner.

  \section2 Signals
  \qmlnone

  \section2  Functions
  \qmlnone

  \section2 Example
  \qmlnone

*/

import Qt 4.7

Item {
    id: spinner

    property int interval: 80
    property int maxSpinTime: 6000
    property bool spinning: false
    property alias source: spinnerImage.source
    property bool continuousSpinning: false


    anchors.centerIn: parent

    width:  spinnerImage.height
    height:  spinnerImage.height

    clip: true

    opacity: 0.0

    onSpinningChanged: {
        if ( spinning ) {
            cancelTimer.running = !continuousSpinning;
            spinnerTimer.running = true;
            spinner.opacity = 1.0
        }
        else {
            cancelTimer.running = false;
            spinnerTimer.running = false;
            spinner.opacity = 0.0;
            spinnerImage.x = 0;
        }
    }

    Timer {
        id: cancelTimer

        interval: spinner.maxSpinTime

        onTriggered: spinner.spinning = continuousSpinning
    }

    Timer {
        id: spinnerTimer

        interval: spinner.interval
        repeat: true

        onTriggered: {
            spinnerImage.x = ( spinnerImage.x - spinnerImage.height ) % - ( spinnerImage.height * 11 )
        }
    }

    Image {
        id: spinnerImage

        source: "image://themedimage/widgets/common/spinner/spinner-small"
        width: sourceSize.width
        height: sourceSize.height
        x: 0
        y: 0
        smooth: true
    }
}
