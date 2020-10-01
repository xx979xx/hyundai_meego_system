import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idSystemLoader
    x:-1; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    property string system: SystemInfo.GetSoftWareVersion();
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }
    ListModel{
        id:headunitData
        ListElement {   name:"Memory window" ; /*value: system; subname:"";check:"off"; gridId:0*/ }
        //ListElement {   name:"Driving Restriction" ; /*subname:SystemInfo.GetKernelVersion(); check:"off";gridId:1*/  }
        //ListElement{ name: "AMOS";}
        ListElement {   name:"Rear Camera Signal" ; /*subname:SystemInfo.GetBuildDate(); check:"off"; gridId:2*/ }
        ListElement{ name: "Parking Guideline";}
        ListElement{ name: "Battery Warning";}


    }
    ListView{
        id:idHeadUnitView
        opacity : 1
        clip: true
        focus: true

        anchors.fill: parent;
        model: headunitData
        delegate: Engineer_SystemConfigRightDelegateSystem{
            onWheelLeftKeyPressed:idHeadUnitView.decrementCurrentIndex()
            onWheelRightKeyPressed:idHeadUnitView.incrementCurrentIndex()

        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 99999
        boundsBehavior: Flickable.StopAtBounds

    }




}

