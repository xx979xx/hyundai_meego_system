/**
 * FileName: MOptionMenuList.qml
 * Author: WSH
 * Time: 2012-02-08
 *
 * - 2012-02-08 Initial Crated by WSH
 * - 2012-12-27 Applied positionViewAtIndex by WSH
 */
import QtQuick 1.0

//--------------------- OptionMenu ListView #
Item{
    function getSelectedIndexFromMOptionMenuList(){
        if(listOptionMenu.count == 0) return 0;

        if(idMOptionMenu.linkedCurrentIndex == listOptionMenu.currentIndex){
            return idMOptionMenu.linkedCurrentIndex ;
        } // End If
        return 0;
    } // End Function

    MListView {
        id: listOptionMenu
        width: delegateWidth
        height: systemInfo.subMainHeight
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: linkedModels
        delegate: linkedDelegate
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        snapMode: ListView.SnapToItem
//        boundsBehavior: Flickable.StopAtBounds
        currentIndex: idMOptionMenu.linkedCurrentIndex
        onCurrentIndexChanged:linkedCurrentItem = listOptionMenu.currentItem
        interactive: true
        isOptionMenuList: true

        Component.onCompleted: {
            //console.log(" [MOptionMenuList] listOptionMenu.count : "+listOptionMenu.count)
            idMOptionMenu.linkedCurrentIndex = getSelectedIndexFromMOptionMenuList()
            listOptionMenu.positionViewAtIndex (listOptionMenu.currentIndex, ListView.Center)
        }

        onVisibleChanged: {
            if(visible){
                idMOptionMenu.linkedCurrentIndex = getSelectedIndexFromMOptionMenuList()
                listOptionMenu.positionViewAtIndex (listOptionMenu.currentIndex, ListView.Center)
            } // End If
        }

        Keys.onUpPressed: {
            return;
        }

        Keys.onDownPressed: {
            return;
        }

    } // End ListView

    //--------------------- ScrollBar #
    MScroll {
        //x:parent.x+parent.width-opScrollWidth; y:listOptionMenu.y+opScrollY; z:1
        scrollArea: listOptionMenu;
        height: listOptionMenu.height-(opScrollY*2)-8; width: opScrollWidth
        anchors.right: listOptionMenu.right
        anchors.verticalCenter: parent.verticalCenter
        visible: listOptionMenu.count > 8
    } // End MScroll

    function checkFocusOfMovementEnd()
    {
    }
} // End Item
