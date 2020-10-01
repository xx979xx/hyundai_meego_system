/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ModalContextMenu
  \title ModalContextMenu
  \section1 ModalContextMenu
  \qmlcm  This qml provides an empty context menu. You can setPosition() where the
         menu should show up. On show() it will appear pointing to the given
         position and display the content set via the content property.

  \section2 API Properties

  \qmlproperty variant content
  \qmlcm the content the contextMenu will show e.g. an ActionMenu.

  \qmlproperty variant title
  \qmlcm the title of the context menu.

  \qmlproperty string[] subMenuModel
  \qmlcm the entries the sub menu will show.

  \qmlproperty string[] subMenuPayload
  \qmlcm the sub menus payload.

  \qmlproperty int forceFingerMode
  \qmlcm the context menu will apear in the set finger mode. If set to -1, the default, the context menu will choose the most
         appropriate mode.
         \qml
         -1: arrow tip and menu position will be chosen automatically
          0: arrow tip will point to the left
          1: arrow tip will point to the right
          2: arrow tip will point to up     // this should be set for tool bar menus
          3: arrow tip will point to down
         \endqml

  \section2 Signals
  \qmlproperty [signal] subMenuTriggered
  \qmlcm emitted when one of the sub menu entries was clicked
        \param int index
        \qmlpcm The index of the clicked entry \endparam

  \section2 Functions

  \qmlfn show
  \qmlcm fades the ModalContextMenu in

  \qmlfn hide
  \qmlcm fades the ModalContextMenu out

  \qmlfn setPosition
  \qmlcm sets the position the menu will point to. IMPORTANT: you have to
         map the mouse position to the topItem in the widget that got the event.
       \param int x
       \qmlpcm the x menu position \endparam
       \param int y
       \qmlpcm the y menu position \endparam

  \section2  Example
  \qml
       ModalContextMenu {
           id: contextmenu

           content:  ActionMenu {
               id: actionMenu

               model: [ "First choice", "Second choice" ]
               payload: [ 1, 2 ]

               onTriggered: {
                   // data can be acessed via payload[index]
                   contextmenu.hide()  // hide if desired
               }
            }
       }

       TopItem { id: topItem } // this item is needed to compute the correct position of the context menu on screen

       function someFunction() {
           contextmenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, mapToItem( window, window.width / 2, windowMenuButton.y + windowMenuButton.height ).y )
           contextmenu.show()
       }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Ux.Gestures 0.1

ModalFog {
    id: container

    property alias content: contentArea.children
    property int forceFingerMode: -1

    property real baseX: 0
    property real baseY: 0

    property alias subMenuModel : subContextMenu.model
    property alias subMenuPayload : subContextMenu.payload
    property alias title: headerText.text

    property bool subMenuVisible: false

    signal subMenuTriggered( int index )

    function setPosition( x, y ) {
        top.calcTopParent()
        baseX =  x / top.topWidth
        baseY = (y - top.topDecorationHeight) / (top.topHeight - top.topDecorationHeight)
        menuContainer.mouseX = x
        menuContainer.mouseY = y
        menuContainer.rescale()
    }

    onVisibleChanged: {
        fogMaskVisible = false  // reset and ensure the ContextMenu is not modal
        fogClickable = true
        container.subMenuVisible = false
    }

    fogMaskVisible: false
    fogClickable: true

    modalSurface: Item {
        id: menuContainer

        /* Menu Container
         * This is the actual contextmenu.
         *
         * Properties:
         *   mouseX, mouseY - position the menu should point to
         *   fingerMode - direction in which the finger is pointing:
         *                0 - left
         *                1 - right
         *                2 - top
         *                3 - bottom
         *   fingerSize - size of the finger image. Has to be quadric
         *   fingerX, fingerY - relativ position of the finger inside the menu
         */
        property int mouseX: 0
        property int mouseY: 0

        property int fingerMode: 0
        property int fingerSize: 30
        property int fingerX: 0
        property int fingerY: 0

        // space defines the distance the menu will keep from the edges
        property int space: (top.topHeight > top.topWidth) ? top.topWidth * 0.02 : top.topHeight * 0.02 // 10

        // Clamp val between min and max
        function clamp (val, min, max) {
            return Math.max (min, Math.min (max, val));
        }

        function rescale() {

            // Ensure that the context menu will completely fit
            // on the screen, and that the menu finger is attatched
            // to the correct corner so its obvious what element
            // the context menu is associated with.
            //
            // menuContainer.fingerMode:
            // 0 - left
            // 1 - right
            // 2 - top
            // 3 - bottom

            top.calcTopParent()
            var pw = top.topWidth;
            var ph = top.topHeight;
            var mw = menu.width;
            var mh = menu.height;
            var fmode = 0;

            menuContainer.fingerMode = 0;
            // Step one
            // find the appropriate direction for the finger to point
            // Horizontal placement takes precedence over vertical.

            if( container.forceFingerMode < 0 ){
                if (mouseX + mw + fingerSize > pw) {    // if the menu would touch the right edge
                    fmode = 1;
                }

                // Check vertically
                  // if the menu would touch the lower edge and doesn't touch the top
                if (mouseY + (mh / 2) > ph && mouseY - mh - fingerSize > 0 + top.topDecorationHeight ) {
                    // Switch to bottom
                    fmode = 3;
                }

                   // if the menu would touch the top edge and doesn't touch the lower. If it's too big,
                if (mouseY - (mh / 2) < 0  && (mouseY + mh + fingerSize < ph )){ // || mh + menuContainer.fingerSize > ph ) ) {
                    // Switch to top
                    fmode = 2;
                }
            }
            else{
                fmode = container.forceFingerMode
            }

            menuContainer.fingerMode = fmode;

            // Step two
            // Given the finger direction, find the correct location
            // for the menu, keeping it onscreen.
            switch (menuContainer.fingerMode) {
                case 0:container.subMenuVisible
                    mouseX += menuContainer.fingerSize / 2;

                case 1:

                    mouseX -= menuContainer.fingerSize / 2;
                    if( mouseY - (mh / 2) < 0 + space + top.topDecorationHeight ){    // if the menu exceeds at top
                        menuContainer.y = 0 + space + top.topDecorationHeight;        // + top.topDecorationHeight to keep the toolbar clear
                    }
                    else if( mouseY + (mh / 2) > ph - space ){    // if the menu exceeds at bottom
                        menuContainer.y = ph - mh - space;
                    }
                    else{
                        menuContainer.y = mouseY - (mh / 2);    // if no exceeding vertically
                    }

                    if (menuContainer.fingerMode == 0) {    // position box right of arrow
                        menuContainer.x = mouseX;
                    }
                    else {
                        menuContainer.x = mouseX - mw;    // position box left of arrow
                    }

                    menuContainer.fingerY = mouseY - menuContainer.y;
                    break;

                case 2:
                    mouseY -= menuContainer.fingerSize

                case 3:
                    mouseY += menuContainer.fingerSize

                    // Clamp mouseX so that at the edges of the screen we don't
                    // try putting the finger at a location where the
                    // menu can't be placed.
                    // We don't need to do something similar to mouseY because
                    // when it would happen to mouseY, we have switched to
                    // top or bottom menuContainer.fingerMode, and so it becomes a
                    // mouseX issue

                    menuContainer.x = clamp (mouseX - mw / 2, 0 + space, (pw - mw - space));

                    if (menuContainer.fingerMode == 2) {
                        menuContainer.y = mouseY;
                        menuContainer.fingerY = mouseY - menuContainer.y;
                    }
                    else {
                        menuContainer.y = mouseY - mh + 2 - (menuContainer.fingerSize * 1.5);
                        menuContainer.fingerY = mouseY - menuContainer.y - menuContainer.fingerSize;
                    }
                    break;
            }

            menuContainer.fingerX = mouseX - menuContainer.x;
//            menuContainer.fingerY = mouseY - menuContainer.y;
        }

        height: childrenRect.height
        width: childrenRect.width

        Component.onCompleted: rescale()

        Theme { id: theme }

        Item {
            id: menu

            property alias contentWidth: realMenu.width

            x: 0
            y: 0
            width: realMenu.width
            height: realMenu.height

            Connections {
                target: realMenu
                onWidthChanged: {
                    menu.width = realMenu.width;
                }

                onHeightChanged: {
                    menu.height = realMenu.height;
                }
            }

            GestureArea {
                anchors.fill: realMenu
                acceptUnhandledEvents: true
                Tap {}
                TapAndHold{}
                Pan{}
                Pinch{}
                Swipe{}
                z:-1
            }

            ThemeImage {
                id: realMenu

                source: "image://themedimage/widgets/common/menu/menu-background"

                x: if (menuContainer.fingerMode == 0) {
                    return finger.width
                } else {
                    return 0;
                }

                y: if (menuContainer.fingerMode == 2) {
                    return finger.height
                } else {
                    return 0;
                }

                width: backgroundImage.width
                height: backgroundImage.height

                BorderImage {
                    id: shadow
                    source: "image://themedimage/widgets/common/menu/menu-background-shadow"

                    smooth: true

                    anchors.fill: realMenu

                    border.left: 11;
                    border.top: 11
                    border.right: 11;
                    border.bottom: 11

                    anchors.margins: -4
                }

                Column{
                    id: backgroundImage

                    width: contentArea.width

                    height: contentArea.height + headerText.height + spacerItem.height

                    onHeightChanged: {
                        menuContainer.rescale()
                    }

                    Text {
                        id: headerText

                        property int margin: 20

                        text: ""
                        height: ( text.length > 0 ) ? 50 : realMenu.border.top
                        width: parent.width - 2 * margin

                        elide: Text.ElideRight

                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: theme.toolbarFontPixelSize

                        anchors.left: parent.left

                        anchors.leftMargin: margin
                    }

                    Image {
                        source: "image://themedimage/widgets/common/menu/menu-item-separator-header"
                        width: parent.width

                        visible: headerText.text.length > 0
                    }

                    Item {
                        id: contentArea

                        opacity: (container.subMenuVisible) ? 0: 1

                        width: childrenRect.width
                        height: childrenRect.height > 50 ? childrenRect.height : 50
                    }

                    Item {
                        id: spacerItem

                        height: realMenu.border.bottom
                        width:  parent.width
                    }

                }

                ActionMenu {
                    id: subContextMenu

                    minWidth: contentArea.width
                    maxWidth: contentArea.width
                    width: contentArea.width
                    height: contentArea.height

                    x: contentArea.x
                    y: contentArea.y

                    visible: container.subMenuVisible
                    opacity: container.subMenuVisible ? 1: 0    // this forces a repaint when the sub menu hides.

                    onTriggered: {
                        container.subMenuTriggered( index )
                    }
                }
            }

            Image {
                id: finger

                // ensures that the arrows are always attached correctly to the menu
                property int borderSize: 5

                x: if (menuContainer.fingerMode == 0) {
                    return menuContainer.fingerX
                } else if (menuContainer.fingerMode == 1) {
                    return menuContainer.fingerX
                } else {
                    if( menuContainer.fingerX - (width / 2) > borderSize )
                        if( menuContainer.fingerX - (width / 2) > realMenu.width - menuContainer.fingerSize - borderSize )
                            return realMenu.width - menuContainer.fingerSize - borderSize
                        else
                            return menuContainer.fingerX - (width / 2)
                    else
                        return borderSize
                }

                y: if (menuContainer.fingerMode == 0 || menuContainer.fingerMode == 1) {
                       if( menuContainer.fingerY - (height / 2) > borderSize )
                           if( menuContainer.fingerY - (height / 2) > realMenu.height - menuContainer.fingerSize - borderSize )
                               realMenu.height - menuContainer.fingerSize - borderSize
                           else
                               return menuContainer.fingerY - (height / 2)
                       else
                           return borderSize

                } else if (menuContainer.fingerMode == 2) {
                    return menuContainer.fingerY;
                } else {
                    return menuContainer.fingerY - height;
                }

                smooth: true
            }

            states: [
                State {
                    name: "left"
                    when: menuContainer.fingerMode == 0
                    PropertyChanges {
                        target: finger
                        source: "image://themedimage/widgets/common/menu/menu-arrow-west"
                    }
                },
                State {
                    name: "right"
                    when: menuContainer.fingerMode == 1
                    PropertyChanges {
                        target: finger
                        source: "image://themedimage/widgets/common/menu/menu-arrow-east"
                    }
                },
                State {
                    name: "top"
                    when: menuContainer.fingerMode == 2
                    PropertyChanges {
                        target: finger
                        source: "image://themedimage/widgets/common/menu/menu-arrow-north"
                    }
                },
                State {
                    name: "bottom"
                    when: menuContainer.fingerMode == 3
                    PropertyChanges {
                        target: finger
                        source: "image://themedimage/widgets/common/menu/menu-arrow-south"
                    }
                }
            ]
        }
    }

    TopItem{
        id: top

        onGeometryChanged: {
            menuContainer.mouseX = baseX * top.topWidth
            menuContainer.mouseY = baseY * (top.topHeight - top.topDecorationHeight) + top.topDecorationHeight

            menuContainer.rescale()
        }
    }
}
