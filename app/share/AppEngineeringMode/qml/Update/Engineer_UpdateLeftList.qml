import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idUpdateLeftMenu
    x:0; y: systemInfo.bandHeight
    clip:true
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property alias menuList: idMenuListView

    ListModel{
        id:updateList
        ListElement {   name:"Update From USB" ; subname:""; check:"off"; gridId:0  }
        ListElement {   name:"Update From iBox" ; subname:""; check:"off";gridId:1  }

    }
    ListView{
        id:idMenuListView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: updateList
        delegate: Engineer_UpdateLeftDelegate{
            onWheelLeftKeyPressed:idMenuListView.decrementCurrentIndex()
            onWheelRightKeyPressed:idMenuListView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        interactive: false

    }



}
