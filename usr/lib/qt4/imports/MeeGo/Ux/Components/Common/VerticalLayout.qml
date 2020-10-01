 
import Qt 4.7

Column {
    id: container

    property real minWidth: 0
    property real maxWidth: -1

    property real minHeight: 0
    property real maxHeight: -1

    clip: true

    function recalcSize(){
        var tempWidth = childrenRect.width
        var tempHeight = childrenRect.height

        if( tempWidth < minWidth )
            tempWidth = minWidth
        if( tempWidth > maxWidth && maxWidth >= 0 )
            tempWidth = maxWidth

        if( tempHeight < minHeight )
            tempHeight = minHeight
        if( tempHeight > maxHeight && maxHeight >= 0 )
            tempHeight = maxHeight

        data.currentWidth = tempWidth
        data.currentHeight = tempHeight
    }

    width: data.currentWidth
    height:  data.currentHeight

    QtObject{
        id: data
        property real currentWidth
        property real currentHeight
    }

    onMaxHeightChanged: recalcSize()
    onMinHeightChanged: recalcSize()
    onMaxWidthChanged: recalcSize()
    onMinWidthChanged: recalcSize()

    onChildrenRectChanged: recalcSize()
    Component.onCompleted: recalcSize()
}
