import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idSoundLoader
    x:0; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }

    ListModel{
        id:headunitData1
        ListElement {   name:"SDVC" ;  }
        ListElement {   name:"Power Bass" ; }

        //ListElement {   name:"Micom" ; /*subname:""+ sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2; check:"off" ; gridId:3*/ }
    }
    ListView{
        id:idHeadUnitView
//        opacity : 1
        clip: true
        focus: true

        anchors.fill: parent;
        model: headunitData1
        delegate: Engineer_SystemConfigRightDelegateSound{
            onWheelLeftKeyPressed:idHeadUnitView.decrementCurrentIndex()
            onWheelRightKeyPressed:idHeadUnitView.incrementCurrentIndex()

        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 9999999
        boundsBehavior: Flickable.StopAtBounds

    }




}

