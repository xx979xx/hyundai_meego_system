/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass RadioGroup
   \title RadioGroup
   \section1 RadioGroup
   This is a group for radio buttons. It uses the RadioGroup.js to manage their states and knows the current value.
   See \l {RadioButton} documentation for details.

   \section2 API properties

      \qmlproperty variant selectedValue
      \qmlcm holds the currently selected value.

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlfn  add
  \qmlcm adds a button to the group.
        \param RadioButton item
        \qmlpcm the radio button to add \endparam

  \qmlfn  check
  \qmlcm sets a radio button checked. Only for internal use.
        \param RadioButton item
        \qmlpcm the radio button to be set checked \endparam

  \qmlfn  select
  \qmlcm sets the radio button with 'value'checked.
        \param variant value
        \qmlpcm the value to be selected \endparam

  \section2 Example
  \qml
      RadioGroup { id: radioGroup }
  \endqml
*/

import Qt 4.7
import "RadioGroup.js" as Private

QtObject {
    id: root

    property variant selectedValue

    function add(item) { Private.add(item); }
    function check(item) { Private.check(item); }
    function select(value) { Private.select(value); }

    onSelectedValueChanged: { select(selectedValue); }
}
