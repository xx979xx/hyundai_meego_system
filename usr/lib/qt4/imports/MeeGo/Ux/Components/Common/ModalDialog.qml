/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ModalDialog
  \title ModalDialog
  \section1 ModalDialog
  The ModalDialog component is the base component for message boxes and pickers.

  \section2 API Properties
    \qmlproperty item content
    \qmlcm the content can be added here

    \qmlproperty string title
    \qmlcm title of the message box

    \qmlproperty int buttonMinWidth
    \qmlcm minimum width of buttons

    \qmlproperty int buttonMinHeight
    \qmlcm minimum height of buttons

    \qmlproperty int buttonMaxWidth
    \qmlcm maximum width of buttons

    \qmlproperty int buttonMaxHeight
    \qmlcm maximum height of buttons

    \qmlproperty real sizeHintWidth
    \qmlcm the width the dialog should have. It will keep a minimum width of 20% the windows width and will never exceed the window.

    \qmlproperty real sizeHintHeight
    \qmlcm the height the dialog should have. It will keep a minimum height to show header and buttons and will never exceed the window.

    \qmlproperty bool showCancelButton
    \qmlcm boolean to show/hide cancel button

    \qmlproperty bool showAcceptButton
    \qmlcm boolean to show/hide accept button

    \qmlproperty string cancelButtonText
    \qmlcm displayed button text for cancel button

    \qmlproperty string acceptButtonText
    \qmlcm displayed button text for accept button

    \qmlproperty string cancelButtonImage
    \qmlcm background image for cancel button

    \qmlproperty string cancelButtonImagePressed
    \qmlcm background image for pressed cancel button

    \qmlproperty string acceptButtonImage
    \qmlcm background image for accept button

    \qmlproperty string acceptButtonImagePressed
    \qmlcm background image for pressed accept button

    \qmlproperty int leftMargin
    \qmlcm left margin for the content

    \qmlproperty int rightMargin
    \qmlcm right margin for the content

    \qmlproperty int topMargin
    \qmlcm top margin for the content

    \qmlproperty int bottomMargin
    \qmlcm bottom margin for the content

    \qmlproperty int verticalOffset
    \qmlcm the vertical offset for centering the dialog. By default it centers in the content area, keeping the toolbar unobscured.

    \qmlproperty row buttonRow
    \qmlcm this property exposes the button row which holds the dialogs buttons.
           By setting both standard buttons invisible via showAcceptButton and
           showCancelButton you can add a custom row of buttons. Note that you have to
           call hide() and show() on your own then.

  \section2 Signals
    \qmlnone

  \section2 Functions
    \qmlnone

  \section2 Example
  \qml
    AppPage {
       id: myPage

       // create ModalDialog:
       ModalDialog {
           id: myDialog

           title : qsTr("Are you sure?")
           buttonWidth: 200
           buttonHeight: 35
           showCancelButton: true
           showAcceptButton: true
           cancelButtonText: qsTr( "Yes" )
           acceptButtonText: qsTr( "No" )

           content: Rectangle {
               id: myContent
               width: 400
               height: 400
               color: "red"
           }

           // handle signals:
           onAccepted: {
               // do something
           }
           onRejected: {
               // do something
           }
       }
       // show on signal:
       Component.onCompleted: {
           myDialog.show()
       }
    }
   \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Ux.Gestures 0.1

ModalFog {
    id: modalDialogBox

    property alias showCancelButton: buttonCancel.visible
    property alias showAcceptButton: buttonAccept.visible

    property alias cancelButtonEnabled: buttonCancel.enabled
    property alias acceptButtonEnabled: buttonAccept.enabled

    property alias content: innerContentArea.children
    property alias buttonRow: footer.children

    property string cancelButtonText: qsTr( "Cancel" )
    property string acceptButtonText: qsTr( "OK" )

    property string title: ""
    property bool alignTitleCenter: false

    property string cancelButtonImage: "image://themedimage/widgets/common/button/button"
    property string cancelButtonImagePressed: "image://themedimage/widgets/common/button/button-pressed"

    property string acceptButtonImage: "image://themedimage/widgets/common/button/button-default"
    property string acceptButtonImagePressed: "image://themedimage/widgets/common/button/button-default-pressed"

    property int leftMargin: 0
    property int rightMargin: 0
    property int topMargin: 0
    property int bottomMargin: 0

    property int buttonWidth: width / 2.5     // deprecated
    property int buttonHeight: width * 0.2     // deprecated

    property real buttonMaxWidth: width / 2.1
    property real buttonMinWidth: width * 0.25

    property real buttonMaxHeight: 50   // ToDo replace magic numbers with theme values
    property real buttonMinHeight: 50
    property real sizeHintWidth: 600
    property real sizeHintHeight: 300

    property int decorationHeight: header.height + footer.height + topMargin + bottomMargin

    property int verticalOffset: topItem.topDecorationHeight

    width: if( sizeHintWidth < topItem.topWidth * 0.95 ){
               if( sizeHintWidth < topItem.topWidth * 0.2 ){
                   topItem.topWidth * 0.2
               }
               else{
                   sizeHintWidth
               }
           }
           else{
               topItem.topWidth * 0.95
           }

    height: if( sizeHintHeight < (topItem.topHeight - topItem.topDecorationHeight) * 0.95 ){
                if( sizeHintHeight < decorationHeight){
                    decorationHeight
                }
                else{
                    sizeHintHeight
                }
            }
            else{
                (topItem.topHeight - topItem.topDecorationHeight) * 0.95
            }

    fogClickable: false

    modalSurface: ThemeImage {
        id: inner

        width: modalDialogBox.width
        height: modalDialogBox.height

        x: ( topItem.topWidth - modalDialogBox.width ) / 2
        y: ( topItem.topHeight - modalDialogBox.height + verticalOffset ) / 2

        source: "image://themedimage/widgets/common/modal-dialog/modal-dialog-background"

        clip: true

        GestureArea {
            id: blocker
            acceptUnhandledEvents: true
            anchors.fill: parent
            Tap {}
            TapAndHold{}
            Pan{}
            Pinch{}
            Swipe{}
        }

        Text {
            id: header

            anchors.top: parent.top

            anchors.horizontalCenter: alignTitleCenter ? parent.horizontalCenter : undefined
            anchors.left: alignTitleCenter ? undefined : parent.left
            anchors.leftMargin: 20

            height: inner.border.top
            width:  parent.width - 40
            verticalAlignment: Text.AlignVCenter

            text: modalDialogBox.title
            font.weight: Font.Bold
            font.pixelSize: theme.dialogTitleFontPixelSize
            color: theme.dialogTitleFontColor
            elide: Text.ElideRight
        }

        Item {
            id: innerContentArea

            clip: true

            anchors{
                left: parent.left;
                top: header.bottom;
                right: parent.right;
                bottom: footer.top;
                leftMargin: modalDialogBox.leftMargin
                rightMargin: modalDialogBox.rightMargin
                topMargin: modalDialogBox.topMargin
                bottomMargin: modalDialogBox.bottomMargin
            }
        }

        Button {
            id: defaultButtonCancel

            maxWidth: modalDialogBox.buttonMaxWidth
            maxHeight: modalDialogBox.buttonMaxHeight
            minWidth: modalDialogBox.buttonMinWidth
            minHeight: modalDialogBox.buttonMinHeight

            anchors.verticalCenter: footer.verticalCenter

            anchors.horizontalCenter: parent.horizontalCenter
            text:cancelButtonText

            visible: footer.width <=  footer.spacing + 2    // row size if all buttons are invisible and no custom ones set

            bgSourceUp: cancelButtonImage
            bgSourceDn: cancelButtonImagePressed

            onClicked: {
                modalDialogBox.rejected()
                modalDialogBox.hide()
            }
        }

        Row {
            id: footer

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            height: inner.border.bottom
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true

            Item {
                id: defaultButtons

                /*: Handles layout of OK/Cancel buttons in ModalDialogs according to reading direction
                    for specific languages. Expects "left-to-right" or "right-to-left".
                    "left-to-right" would mean the OK button is on the left side and the Cancel button is
                    on the right side. "right-to-left" is vice versa. Default is "left-to-right. */
                property string readingDirection: qsTr("left-to-right")

                property int acceptWidth: buttonAccept.visible ? buttonAccept.width : 0
                property int cancelWidth: buttonCancel.visible ? buttonCancel.width : 0
                property int spacing: ( acceptWidth > 0 && cancelWidth > 0 ) ? parent.spacing : 0

                property int acceptHeight: buttonAccept.visible ? buttonAccept.height : 0
                property int cancelHeight: buttonCancel.visible ? buttonCancel.height : 0

                anchors.verticalCenter: parent.verticalCenter
                width: acceptWidth + cancelWidth + spacing
                height: ( acceptHeight > cancelHeight ) ? acceptHeight : cancelHeight

                states: [
                    State {
                        name: "leftToRight"
                        when: defaultButtons.readingDirection != "right-to-left"
                        AnchorChanges {
                            target: buttonAccept
                            anchors.left: defaultButtons.left
                            anchors.right: undefined
                        }
                        AnchorChanges {
                            target: buttonCancel
                            anchors.left: undefined
                            anchors.right: defaultButtons.right
                        }
                    },
                    State {
                        name: "rightToLeft"
                        when: defaultButtons.readingDirection == "right-to-left"
                        AnchorChanges {
                            target: buttonAccept
                            anchors.left: undefined
                            anchors.right: defaultButtons.right
                        }
                        AnchorChanges {
                            target: buttonCancel
                            anchors.left: defaultButtons.left
                            anchors.right: undefined
                        }
                    }
                ]


                Button {
                    id: buttonAccept

                    maxWidth: visible ? modalDialogBox.buttonMaxWidth : 0
                    maxHeight: modalDialogBox.buttonMaxHeight

                    minWidth: visible ? modalDialogBox.buttonMinWidth : 0
                    minHeight: modalDialogBox.buttonMinHeight

                    anchors.verticalCenter: parent.verticalCenter
                    text: acceptButtonText

                    bgSourceUp: acceptButtonImage
                    bgSourceDn: acceptButtonImagePressed

                    onClicked: {
                        modalDialogBox.accepted()
                        modalDialogBox.hide()
                    }
                }

                Button {
                    id: buttonCancel

                    maxWidth: visible ? modalDialogBox.buttonMaxWidth : 0
                    maxHeight: modalDialogBox.buttonHeight

                    minWidth: visible ? modalDialogBox.buttonMinWidth : 0
                    minHeight: modalDialogBox.buttonMinHeight

                    anchors.verticalCenter: parent.verticalCenter
                    text: cancelButtonText

                    bgSourceUp: cancelButtonImage
                    bgSourceDn: cancelButtonImagePressed

                    onClicked: {
                        modalDialogBox.rejected()
                        modalDialogBox.hide()
                    }
                }
            }
        }
    }

    Theme { id: theme }
    TopItem { id: topItem }
}
