import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idSystemConfigLeftMenu
    x:0; y: systemInfo.bandHeight
    clip:true
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property alias menuList: idMenuListView

    Engineer_SystemConfigLeftModel{
        id:systemConfigList
    }
    ListView{
        id:idMenuListView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: systemConfigList
        delegate: Engineer_SystemLeftDelegate{
            onWheelLeftKeyPressed:idMenuListView.decrementCurrentIndex()
            onWheelRightKeyPressed:idMenuListView.incrementCurrentIndex()

        }
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999
        interactive: false

    }



}
