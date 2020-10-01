import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idVersionLoader
    x:-1; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
//    clip:true
    focus: true
   //playBeepOn: false
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
     property string imgFolderGeneral: imageInfo.imgFolderGeneral

    property string system: SystemInfo.GetSoftWareVersion();
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        console.log("Software Version ::: " + system)
    }
    ListModel{
        id:headunitData
        ListElement {   name:"Head Unit" ;/*value: system; subname:"";check:"off"; gridId:0*/ }
        ListElement {   name:"Head Unit 2"; }
        ListElement {   name:"iBox" ; /*subname:SystemInfo.GetKernelVersion(); check:"off";gridId:1*/  }
        ListElement {   name:"AMP" ; /*subname:SystemInfo.GetBuildDate(); check:"off"; gridId:2*/ }
        ListElement  {   name:"RRC";}
        ListElement {   name:"CCP"; }
        ListElement { name: "Cluster";  }
//        ListElement {   name: "FCAT"; }
//        ListElement {   name:"iBoxSWVersion";   }
    }
    ListView{
        id:idHeadUnitView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: headunitData
        delegate: Engineer_HardwareRightDelegate{
            onWheelLeftKeyPressed:idHeadUnitView.decrementCurrentIndex()
            onWheelRightKeyPressed:idHeadUnitView.incrementCurrentIndex()

        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 99999
        boundsBehavior: Flickable.StopAtBounds

    }
    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 14
        property int  scrollY: 5
        x:systemInfo.lcdWidth-708 -30; y:/*idTotalChList.y+*/scrollY; z:1
        scrollArea: idHeadUnitView;
        height: idHeadUnitView.height-(scrollY*2)-8; width: scrollWidth
//        anchors.right: idHeadUnitView.right
        anchors.verticalCenter: parent.verticalCenter
        visible: true
    } //# End MScroll
}

