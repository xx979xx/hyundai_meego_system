/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ModalSpinner
  \title ModalSpinner
  \section1 ModalSpinner
  The ModalSpinner shows a spinning animation indicating that a currently running process
  takes some time to finish and blocks user interaction.

  \section2  API Properties
      \qmlproperty int interval
      \qmlcm sets the time in milliseconds needed for one animation step.

      \qmlproperty alias source
      \qmlcm sets the image used for the animations of the ModalSpinner.

  \section2 Signals
  \qmlnone

  \section2  Functions

  \qmlfn show
  \qmlcm starts the animation and fades the ModalSpinner in

  \qmlfn hide
  \qmlcm fades the ModalSpinner out and stops the animation

  \section2 Example
  \qmlnone

*/

import Qt 4.7
import MeeGo.Components 0.1

ModalFog {
    id: spinnerBox

    property int interval: spinner.interval
    property alias source: spinner.source

    autoCenter: true
    fogClickable: false

    modalSurface: Spinner{
        id: spinner

        spinning: true
        continuousSpinning: true
    }

    onClosed: { spinner.spinning = false }

    onShowCalled: { spinner.spinning = true }
}
