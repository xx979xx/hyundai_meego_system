/*!
   \qmlclass LayoutTextItem
   \title LayoutTextItem
   \section1 LayoutTextItem
   This is a basic text item that resizes to its given text. You can control the width of the item with minWidth and maxWidth, and
   the height with minHeight and maxHeight. Note that this will only affect the text items dimensions. If you want the LayoutTextItem
   to clip or elide if the text exceeds the item, you have to set these values appropriately. Once you set width or height explicitly,
   the corresponding automatic resize is terminated.


   \section2 API properties

      \qmlproperty real maxWidth
      \qmlcm real, defines the maximum width of the text. The text item will not exceed this width. Note that elide is set to Text.ElideNone by default.

      \qmlproperty real minWidth
      \qmlcm real, defines the minimum width of the text. If the text is to narrow, the text item itself will keep the minimum width.

      \qmlproperty real maxHeight
      \qmlcm real, defines the maximum height of the text. Note that 'clip' is false by default.

      \qmlproperty real minHeight
      \qmlcm real, defines the minimum height of the text. If the text is to flat, the text item itself will keep the minimum height.

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      LayoutTextItem {
         id: textItem

         maxWidth: 150
         minWidth: 50

         text: "Hello World"
      }
  \endqml
*/

import Qt 4.7

Text {
    id: textItem

    property real minWidth: 0
    property real maxWidth: 10000

    property real minHeight: 0
    property real maxHeight: 10000

    property real dynamicWidth: 0
    property real dynamicHeight: 0


    function updateWidth(){

        dynamicWidth = widthComputingWorkaround.paintedWidth

        if( dynamicWidth > maxWidth ){
            dynamicWidth = maxWidth
        }
        if( dynamicWidth < minWidth ){
            dynamicWidth = minWidth
        }
        if( dynamicWidth < 0 ){
            dynamicWidth = 0
        }

        dynamicHeight = widthComputingWorkaround.paintedHeight

        if( dynamicHeight > maxHeight ){
            dynamicHeight = maxHeight
        }
        if( dynamicHeight < minHeight ){
            dynamicHeight = minHeight
        }
        if( dynamicHeight < 0 ){
            dynamicHeight = 0
        }
    }

    width: dynamicWidth
    height: dynamicHeight

    Text {
        id: widthComputingWorkaround
        text: textItem.text
        font: textItem.font
        opacity: 0

        // this has to be called here, because textItem sends them before the workaround notices it,
        // which leads to wrong dimensions.
        onTextChanged: updateWidth()
        onFontChanged: updateWidth()
    }

    onMinWidthChanged: updateWidth()
    onMaxWidthChanged: updateWidth()
    onMinHeightChanged: updateWidth()
    onMaxHeightChanged: updateWidth()
    Component.onCompleted: updateWidth()
}
