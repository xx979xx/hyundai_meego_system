import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idHardwareLeftMenu
    x:0; y: systemInfo.bandHeight
    clip:true
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property alias menuList: idMenuListView

    onVisibleChanged:
    {
        //idMenuListView.currentIndex = 0;

    }

    Engineer_HardwareLeftModel{
        id:hardwareList
    }
    ListView{
        id:idMenuListView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: hardwareList
        delegate: Engineer_HardwareLeftDelegate{
            id:idHarddelegate
            onWheelLeftKeyPressed:idMenuListView.decrementCurrentIndex()
            onWheelRightKeyPressed:idMenuListView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        interactive: false

    }



}
