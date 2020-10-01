/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass Units
   \title Units
   \section1 Units
   Units provides access to the display density information allowing for 
   applications to be specified in density independent units.

   \section2 API properties

      \qmlproperty qreal density
      \qmlcm Display density in pixels per inch

      \qmlproperty qreal mm
      \qmlcm Number of pixels per millimeter

      \qmlproperty qreal inch
      \qmlcm Number of pixels per inch

      \qmlproperty qreal vp
      \qmlcm Number of pixels per "virtual pixel"  A virtual pixel represents pixel on a 330DPI display.

  \section2 Functions
      \qmlfn int mm2px(qreal mm)
      \qmlcm Returns the number of pixels that measure 'mm' millimeters on the physical display
      \qmlfn int vp2px(qreal mm)
      \qmlcm Returns the number of pixels that measure 'vp' virtual pixels on the physical display
  \qmlnone

  \section2 Example
  \qml
      import MeeGo.Components 0.1
      Rectangle {
         Units { id: units }
         Button {
            width: units.mm2px(12) // 1.2cm wide
            height: units.mm2px(8) // 8mm tall
         }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
	property alias density: provider.density
	property alias mm: provider.mm
	property alias inch: provider.inch
	property alias vp: provider.vp

	UnitsProvider { id: provider }

        function simulateDensity(width, height, diagonal) {
            return (diagonal == 0) ? 96.0 : Math.sqrt(width * width + height * height) / diagonal
        }

        function mm2px(mm) {
            return Math.round(provider.mm * mm)
        }

        function vp2px(vp) {
            return Math.round(provider.vp * vp)
        }
}
