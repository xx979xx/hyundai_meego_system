import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idPeripheralsLoader
    x:-1; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
     property string imgFolderGeneral: imageInfo.imgFolderGeneral
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }


    ListModel{
        id:peripheralsData
        ListElement {   name:"iBox" ; }
        ListElement {   name:"AMP" ;   }
        ListElement {   name:"CCP" ; }
        ListElement {   name:"RRC" ; }
        ListElement {   name:"Clock";   }
        ListElement {   name:"Front Monitor";}
        ListElement {   name:"Rear Monitor L";}
        ListElement {   name:"Rear Monitor R";}
        ListElement {   name:"AVM";}
        ListElement {   name:"PGS"; }
        ListElement {   name:"HUD"; }
        ListElement {   name:"Cluster"; }

    }
    ListView{
        id:idPeripheralsView
        //opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: peripheralsData
        delegate: Engineer_SoftwarePeriDelegate{
            onWheelLeftKeyPressed:idPeripheralsView.decrementCurrentIndex()
            onWheelRightKeyPressed:idPeripheralsView.incrementCurrentIndex()
        }
        orientation : ListView.Vertical
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000
        highlightMoveSpeed: 99999
        boundsBehavior: Flickable.StopAtBounds

    }
    //--------------------- ScrollBar #
    MComp.MScroll {
        property int  scrollWidth: 13
        property int  scrollY: 5
        y: 5; z:1 ;x:systemInfo.lcdWidth-708-30
        scrollArea: idPeripheralsView;
        height: idPeripheralsView.height-(scrollY*2)-8; width: scrollWidth
        //anchors.right: idHeadUnitView.right
        visible: true
    } //# End MScroll

 }

