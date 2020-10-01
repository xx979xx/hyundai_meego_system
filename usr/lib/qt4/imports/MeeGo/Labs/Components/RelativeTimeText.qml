/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
 \qmlclass RelativeTimeText
 \title RelativeTimeText
 \section1 RelativeTimeText
 RelativeTimeText creates a user friendly timestamp relative to the
 current time, such as "Just now", "5 minutes ago", etc.
 It inherits all the properties of the Text component.

 \section2 API properties

 \qmlproperty date datetime
 \qmlcm sets the datetime the text refers to.

 \section2 Private properties

 \qmlproperty string text
 \qmlcm this isn't meant to be set directly. Use datetime instead.

 \section2 Example
 \qml
    RelativeTimeText {
        datetime: new Date()
        font.pixelSize: 24
    }
 \endqml
 */
import Qt 4.7
import MeeGo.Labs.Components 0.1

Text {
    property alias datetime: timestamp.datetime
    RelativeTimeStamp { id: timestamp }
    text: timestamp.text
}
