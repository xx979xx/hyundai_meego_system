/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass PopupList
  \title PopupList
  \section1 PopupList
  The PopupList component contains a button which opens a spinnable list
  of entries when clicked. The list of entries as well as the
  number of entries displayed at a time can be set. The entries will
  adapt their size to the given height, but the width must be set big
  enough to allow the tags in your model to be displayed without being
  cut at their sides.

  \section2 API Properties
    \qmlproperty alias pathItemCount
    \qmlcm sets the number of items displayed at the same time in the spinner

    \qmlproperty int fontSize
    \qmlcm sets the size in pixels for non-highlighted entries in the spinner.
           Changes to smaller size automatically if the entry's height is
           insufficient for the chosen size.

    \qmlproperty variant popupListModel
    \qmlcm PathView.model, sets the model used for the list entries

    \qmlproperty variant value
    \qmlcm sets the value which will be used in the function reInit() to set the
           PathView's focus at

  \section2 Signals
    \qmlproperty [signal] valueSelected
    \qmlcm propagates that a value has been selected
    \param  int index
    \qmlpcm the index of the entry in the model \endparam
    \param  variant tag
    \qmlpcm the content of the selected entry \endparam

  \section2 Functions
    \qmlfn reInit
    \qmlcm sets the focus of the PathView to the entry whose tag matches the
           property value.

    \qmlfn getCurrentIndex
    \qmlcm returns the model index of the current value
    \retval index \qmlpcm the current index \endretval

  \section2 Example
  \qml
  AppPage {

       PopupList {
           id: popup

           width:  150
           height: 200
           popupListModel: myModel

           onValueSelected: {
                // do something
           }

           ListModel {
               id:myModel

               ListElement { tag: "1" }
               ListElement { tag: "2" }
               ListElement { tag: "3" }
               ListElement { tag: "4" }
               ListElement { tag: "5" }
           }
       }
  }
  \endqml
*/
import Qt 4.7
import MeeGo.Ux.Gestures 0.1

Item {
    id: outer

    property alias pathItemCount: view.pathItemCount
    property int fontSize: theme.fontPixelSizeLarge
    property variant popupListModel
    property real itemHeight: height / ( view.pathItemCount + 1 )
    property variant value
    property int count: popupListModel.count
    property variant selectedValue: view.currentIndex

    property bool allowSignal: true
    signal valueSelected ( int index, variant tag )

    function reInit() {
        allowSignal = false

        var focusIndex = 0;
        for ( var i = 0; i < view.model.count; i++ ) {
            if ( view.model.get(i).tag == outer.value ) {
                focusIndex = i;
            }
        }

        view.currentIndex = focusIndex;
        allowSignal = true
    }

    // find the current index matching the value of the button
    function getCurrentIndex() {
        var i
        for ( i = 0; i < view.model.count; i++ ) {
            if ( view.model.get(i).tag == value ) {
                return i
            }
        }
        return 0
    }

    Theme { id: theme }

    Component {
        id: tsdelegate

        Text {
           id: delegateText

           property bool isSelected: index == view.currentIndex

           font.pixelSize: if( theme.fontPixelSizeSmall < height - 4 ) {
                               return theme.fontPixelSizeSmall
                           }else{
                               return height - 4
                           }

           height: itemHeight
           text: ( tag == undefined ) ? index : tag
           color: "#A0A0A0"
           font.bold: isSelected
           verticalAlignment: "AlignVCenter"

           GestureArea {
               id: delegateArea

               height:  parent.height
               width: spinnerRect.width
               anchors.centerIn: parent

               Tap {
                 onFinished: {
                     view.currentIndex = index
                     if( outer.allowSignal ) {
                         outer.valueSelected( view.currentIndex, tag )
                     }
                 }
               }
           }

           states: [
               State {
                   name: "active"
                   when:  index == view.currentIndex

                   PropertyChanges {
                       target: delegateText;
                       font.bold: true;
                       color: theme.fontColorNormal;

                       //adapt the font size to the available space to avoid overlapping
                       font.pixelSize: if( outer.fontSize < height - 4 ) {
                                           return outer.fontSize
                                       }else {
                                           return height - 4
                                       }

                       height: itemHeight * 2
                   }
               }
           ]
        }
    }

    Item {
        id: spinnerRect

        focus: true
        clip: true
        anchors.fill: parent

        ThemeImage {
            id: spinner

            source: "image://themedimage/images/pickers/timespinbg"
            opacity: 0.5
            anchors.fill: parent
        }

        GestureArea {
            id: blocker
            anchors.fill: spinnerRect
            acceptUnhandledEvents: true
            Tap{}
            TapAndHold{}
            Pan{}
            Swipe{}
            Pinch{}
        }

        PathView {
            id: view

            //highlightMoveDuration: 150

            anchors.fill: spinnerRect
            model: popupListModel

            pathItemCount: 3
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: preferredHighlightBegin
            dragMargin: view.width/2
            delegate: tsdelegate

            onMovementEnded: {
                if( outer.allowSignal ) {
                    outer.valueSelected( currentIndex, model.get(currentIndex).tag )
                }
            }

            path: Path {
                startX: view.width/2; startY: 0

                PathLine { x: view.width / 2; y: view.height }
            }

            ThemeImage {
                id: innerBgImage

                source:"image://themedimage/images/pickers/timespinhi"
                anchors.fill: parent
                opacity: 0.25
            }

            Component.onCompleted: {
                var focusIndex = 0;
                for ( var i = 0; i < view.model.count; i++ ) {
                    if ( view.model.get(i).tag == outer.value ) {
                        focusIndex = i;
                    }
                }
            }
        }
    }//end spinnerRect

    MouseArea {
        id: flickableArea

        property int firstY: 0

        anchors.fill: parent

        onPressed: {
            firstY = mouseY;
        }

        //react on vertical mouse movement to flick the path view
        onMousePositionChanged: {
            if( flickableArea.pressed && outer.allowSignal ) {
                if( mouseY - firstY > 15 ) {
                    firstY = mouseY;
                    view.decrementCurrentIndex();
                }else if( mouseY - firstY < -15 ) {
                    firstY = mouseY;
                    view.incrementCurrentIndex();
                }
            }
        }
        onReleased:  {
            if( outer.allowSignal ) {
                outer.valueSelected( view.currentIndex, view.model.get( view.currentIndex ).tag )
            }
        }
    }
}//end Item

