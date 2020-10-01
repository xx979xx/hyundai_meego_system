/**
 * FileName: MOptionMenuList.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 */
import QtQuick 1.0

//--------------------- OptionMenu ListView #
Item{
    property alias lCurrentIndex:listOptionMenu.currentIndex // JSH 120612
    MListView{//ListView { , JSH 130911 modify
        id: listOptionMenu
        width: delegateWidth
        height: systemInfo.subMainHeight
        opacity : 1
        clip: true
        focus: true
        //anchors.fill: parent; // JSH 130808 deleted
        model: linkedModels
        delegate: linkedDelegate
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.DragAndOvershootBounds//Flickable.StopAtBounds //listOptionMenu.count > 8 ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
        //currentIndex: idMOptionMenu.linkedCurrentIndex
        onCurrentIndexChanged:linkedCurrentItem = listOptionMenu.currentItem
        Component.onCompleted: {console.log(" [MOptionMenuList] listOptionMenu.count : "+listOptionMenu.count)}
        onMovementEnded: { idMOptionMenuTimer.start(); }    //# 5s Timer start() for Flickable : KEH (20130416)
        interactive : true //JSH 130813 added , Testing

        ////////////////////////////////////////////////////
        //JSH 130911 added
        onUpKeyLongPressedIsTrue: idMOptionMenuTimer.stop();
        onUpKeyLongPressedIsFalse: idMOptionMenuTimer.restart();
        onDownKeyLongPressedIsTrue: idMOptionMenuTimer.stop();
        onDownKeyLongPressedIsFalse: idMOptionMenuTimer.restart();
        ////////////////////////////////////////////////////
         onVisibleChanged: {if(visible && (contentY != 0)) contentY = 0;}
    } // End ListView

    //--------------------- ScrollBar #
    MScroll {
        x: 416
        y: 98-systemInfo.statusBarHeight+6
        height: 608
        width: 14
        visible: listOptionMenu.count > 8
        scrollArea: listOptionMenu
    } // End MScroll
} // End Item
