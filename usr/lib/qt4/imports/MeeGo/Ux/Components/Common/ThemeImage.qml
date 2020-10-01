/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass ThemeImage
   \title ThemeImage
   \section1 ThemeImage
   This is a workaround for settings also the border pixels of a BorderImage by the Theme.
      
  \section2 Example
  \qml
      ThemeImage {
         id: image

         source: "image://myProvider/image";
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Kernel 0.1
import MeeGo.Components 0.1

BorderImage {

    id: container

    border.bottom:  themeImageBorder.borderBottom;
    border.top:     themeImageBorder.borderTop;
    border.left:    themeImageBorder.borderLeft
    border.right:   themeImageBorder.borderRight;

    ThemeImageBorder { // from kernel
	id: themeImageBorder
    }

}

