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
    ListView {
        id: listOptionMenu
        width: delegateWidth; height: systemInfo.subMainHeight
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: linkedModels
        delegate: MOptionMenuDelegate{}
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds

        Component.onCompleted: {console.log(" [MOptionMenuList] listOptionMenu.count : "+listOptionMenu.count)}
    } // End ListView

    //--------------------- ScrollBar #
    MScroll {
        x:parent.x+parent.width-scrollWidth; y:listOptionMenu.y+scrollY; z:1
        scrollArea: listOptionMenu;
        height: listOptionMenu.height-(scrollY*2)-8; width: scrollWidth
        anchors.right: listOptionMenu.right
        visible: listOptionMenu.count > 8
    } // End MScroll
} // End Item
