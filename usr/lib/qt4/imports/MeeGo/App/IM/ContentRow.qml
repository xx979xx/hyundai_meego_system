/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

// this is in a separate file just to avoid duplicating it tons of time
Rectangle {
    property bool active: true
    smooth: true
    width: parent.width
    height: theme_commonBoxHeight
    color: theme_commonBoxColor
    // TODO: check if there is a theme value for that
    border.color: "lightGray"
}
