import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idUpdateUSBLoader
    x:-1; y:261-89-166+5
    z:300
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
        id:updateusbDate
        ListElement {   name:"Kernel" ; }
        ListElement {   name:"      Current Ver" ;   }
        ListElement {   name:"      Update Ver" ; }
        ListElement {   name:"Platform" ; }
        ListElement {   name:"      Current Ver";}
        ListElement {   name:"      Update Ver";}
        ListElement {   name:"Software";}
        ListElement {   name:"      Current Ver";}
        ListElement {   name:"      Update Ver";}
        ListElement {   name:"MICOM";}
        ListElement {   name:"      Current Ver";}
        ListElement {   name:"      Update Ver";}

    }
    ListView{
        id:idUpdateView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: updateusbDate
        delegate: Engineer_UpdateUSBDelegate{
            onWheelLeftKeyPressed:idUpdateView.decrementCurrentIndex()
            onWheelRightKeyPressed:idUpdateView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 9999999
        boundsBehavior: Flickable.StopAtBounds

    }
    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 13
        property int  scrollY: 5
        x:systemInfo.lcdWidth-708 -30; y:idTotalChList.y+scrollY; z:1
        scrollArea: idUpdateView;
        height: idUpdateView.height-(scrollY*2)-8; width: scrollWidth
//        anchors.right: idHeadUnitView.right
        visible: true
    } //# End MScroll

 }

