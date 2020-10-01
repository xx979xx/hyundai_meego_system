import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idVariantSystemLoader
    x:0; y:261-89-166+5
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
    //property string system: SystemInfo.GetSoftWareVersion();

    ListModel{
        id:variantSystemData
        ListElement {   name:"Navigation" ; gridId:0} //0
        ListElement {   name:"iBox" ;   gridId:1 } //1
        ListElement {   name:"MOST AMP" ;  gridId:2} //2
        ListElement {   name:"Rear Monitor" ;  gridId:3} //3
        ListElement {   name:"Radio Region Code 0"; gridId:4}//4
        ListElement {   name:"Radio Region Code 1"; gridId:5}//5
        ListElement {   name:"Radio Region Code 2"; gridId:6}//6
        ListElement {   name:"Radio Region Value"; gridId:7}
        //ListElement {   name:"Mobile TV"; gridId:8}
        ListElement {   name:"RHD";   gridId:8}
        ListElement {   name:"Limo"; gridId:9}
        ListElement { name: "Lexicon"; gridId: 10}
        ListElement {   name:"Parking Assist 0";  gridId:11}
        ListElement {   name:"Parking Assist 1"; gridId:12}
        ListElement {   name:"Parking Assist Value"; gridId:13}
        ListElement {   name:"AdvancedCluster"; gridId:14}
        ListElement {   name:"HUD"; gridId:15}
        ListElement {   name:"Rear USB"; gridId:16}
        ListElement { name:"RRC"; gridId:17}
        ListElement {   name:"Rear MIC"; gridId:18}
        ListElement {   name:"CDC"; gridId:19   }
        //ListElement {   name:"4WD"; gridId:18  }

    }
    ListView{
        id:idVariantSystemView
        //opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: variantSystemData
        delegate: Engineer_VariantSystemDelegate{
            onWheelLeftKeyPressed:idVariantSystemView.decrementCurrentIndex()
            onWheelRightKeyPressed:idVariantSystemView.incrementCurrentIndex()
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
        x:systemInfo.lcdWidth-708 -30; y:idTotalChList.y+scrollY; z:1
        scrollArea: idVariantSystemView;
        height: idVariantSystemView.height-(scrollY*2)-8; width: scrollWidth
        //anchors.right: idHeadUnitView.right
        visible: true
    } //# End MScroll



}

