import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idDeckLoader
    x:-1; y:261-89-166+5
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
//    clip:true
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
        ListElement {   name:"Firmware" ; /*value: system; subname:"";check:"off"; gridId:0*/ }
        ListElement {   name:"Lifetime" ; /*subname:SystemInfo.GetKernelVersion(); check:"off";gridId:1*/  }
        ListElement {   name:"Temperature" ; /*subname:SystemInfo.GetBuildDate(); check:"off"; gridId:2*/ }
        ListElement {   name:"Eject Status" ; }
        ListElement {   name:"Insert Status" ;}
        ListElement {   name:"Random Status";}
        ListElement {   name:"Repeat Status";}
        ListElement {   name:"Scan Status";}
        ListElement {   name: "Mech Error";}
        ListElement {   name: "Rear Error";}
        //ListElement {   name:"Micom" ; /*subname:""+ sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2; check:"off" ; gridId:3*/ }
    }
    ListView{
        id:idHeadUnitView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: headunitData
        delegate: Engineer_HardwareRightDelegateDeck{
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
        property int  scrollWidth: 13
        property int  scrollY: 5
        x:systemInfo.lcdWidth-708 -30; y:idTotalChList.y+scrollY; z:1
        scrollArea: idHeadUnitView;
        height: idHeadUnitView.height-(scrollY*2)-8; width: scrollWidth
//        anchors.right: idHeadUnitView.right
        visible: true
    } //# End MScroll
    //    Component
    //    {

    //       id:listHeadUnit;

    //       Column
    //       {
    //           id:contentColumn; width:1280 - 520
    //           focus:true

    //        MComp.MButton{
    //            id:idSystemSW
    //            width:537
    //            height:92

    //            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    //            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
    //            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"

    //            focus:true
    //            firstText: qsTr("System SW")
    //            firstTextWidth: 150
    //            firstTextX: 20
    //            firstTextY: 43
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"
    //            secondText: qsTr(SystemInfo.GetSoftWareVersion())
    //            secondTextX: 220
    //            secondTextY: 43
    //            secondTextSize:20
    //            secondTextColor: "#447CAD"
    //            secondTextSelectedColor: colorInfo.dimmedGrey
    //            secondTextStyle: "HDB"
    //            secondTextWidth: 403

    //            KeyNavigation.down:idKernel
    //        }
    //        Image{
    ////            x:1
    ////            y:88
    //            anchors.top: idSystemSW.bottom
    //            id:lineList1
    //            source:imgFolderGeneral+"line_menu_list.png"
    //        }

    //        MComp.MButton{
    //            id:idKernel
    //            width:537
    //            height:92
    //            //y:88
    //            anchors.top: idSystemSW.bottom

    //            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    //            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
    //            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
    //            //focus:true
    //            firstText: qsTr("Kernel ")
    //            firstTextWidth: 100
    //            firstTextX: 20
    //            firstTextY: 43
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"
    //            secondText: qsTr(SystemInfo.GetKernelVersion())
    //            secondTextX: 220
    //            secondTextY: 43
    //            secondTextSize:20
    //            secondTextColor: "#447CAD"
    //            secondTextSelectedColor: colorInfo.dimmedGrey
    //            secondTextStyle: "HDB"
    //            secondTextWidth: 403

    //            KeyNavigation.up:idSystemSW
    //            KeyNavigation.down:idSystemSW1
    //        }
    //        Image{
    ////            x:1
    ////            y:88
    //            anchors.top: idKernel.bottom
    //            id:lineList
    //            source:imgFolderGeneral+"line_menu_list.png"
    //        }
    //        MComp.MButton{
    //            id:idSystemSW1
    //            width:537
    //            height:92

    //            anchors.top: idKernel.bottom
    //            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    //            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
    //            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"

    //            //focus:true
    //            firstText: qsTr("System SW")
    //            firstTextWidth: 150
    //            firstTextX: 20
    //            firstTextY: 43
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"
    //            secondText: qsTr(SystemInfo.GetSoftWareVersion())
    //            secondTextX: 220
    //            secondTextY: 43
    //            secondTextSize:20
    //            secondTextColor: "#447CAD"
    //            secondTextSelectedColor: colorInfo.dimmedGrey
    //            secondTextStyle: "HDB"
    //            secondTextWidth: 403

    //            KeyNavigation.down:idKernel1
    //            KeyNavigation.up:idKernel
    //        }
    //        Image{
    ////            x:1
    ////            y:88
    //             anchors.top: idSystemSW1.bottom
    //            id:lineList2
    //            source:imgFolderGeneral+"line_menu_list.png"
    //        }
    //        MComp.MButton{
    //            id:idKernel1
    //            width:537
    //            height:92
    //            //y:88
    //            anchors.top: idSystemSW1.bottom

    //            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    //            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
    //            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
    //            //focus:true
    //            firstText: qsTr("Kernel ")
    //            firstTextWidth: 100
    //            firstTextX: 20
    //            firstTextY: 43
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"
    //            secondText: qsTr(SystemInfo.GetKernelVersion())
    //            secondTextX: 220
    //            secondTextY: 43
    //            secondTextSize:20
    //            secondTextColor: "#447CAD"
    //            secondTextSelectedColor: colorInfo.dimmedGrey
    //            secondTextStyle: "HDB"
    //            secondTextWidth: 403

    //            KeyNavigation.up:idSystemSW1
    //            KeyNavigation.down:idKernel2
    //        }
    //        Image{
    ////            x:1
    ////            y:88
    //            anchors.top: idKernel1.bottom
    //            id:lineList3
    //            source:imgFolderGeneral+"line_menu_list.png"
    //        }

    //        MComp.MButton{
    //            id:idKernel2
    //            width:537
    //            height:92
    //            //y:88
    //            anchors.top: idKernel1.bottom

    //            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    //            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
    //            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
    //            //focus:true
    //            firstText: qsTr("Kernel ")
    //            firstTextWidth: 100
    //            firstTextX: 20
    //            firstTextY: 43
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"
    //            secondText: qsTr(SystemInfo.GetKernelVersion())
    //            secondTextX: 220
    //            secondTextY: 43
    //            secondTextSize:20
    //            secondTextColor: "#447CAD"
    //            secondTextSelectedColor: colorInfo.dimmedGrey
    //            secondTextStyle: "HDB"
    //            secondTextWidth: 403

    //            KeyNavigation.up:idKernel1
    //            KeyNavigation.down:idKernel3
    //        }
    //        Image{
    ////            x:1
    ////            y:88
    //            anchors.top: idKernel2.bottom
    //            id:lineList4
    //            source:imgFolderGeneral+"line_menu_list.png"
    //        }

    //        MComp.MButton{
    //            id:idKernel3
    //            width:537
    //            height:92
    //            //y:88
    //            anchors.top: idKernel2.bottom

    //            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
    //            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
    //            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
    //            //focus:true
    //            firstText: qsTr("Kernel ")
    //            firstTextWidth: 100
    //            firstTextX: 20
    //            firstTextY: 43
    //            firstTextColor: colorInfo.brightGrey
    //            firstTextSelectedColor: colorInfo.brightGrey
    //            firstTextSize: 25
    //            firstTextStyle: "HDB"
    //            secondText: qsTr(SystemInfo.GetKernelVersion())
    //            secondTextX: 220
    //            secondTextY: 43
    //            secondTextSize:20
    //            secondTextColor: "#447CAD"
    //            secondTextSelectedColor: colorInfo.dimmedGrey
    //            secondTextStyle: "HDB"
    //            secondTextWidth: 403

    //            KeyNavigation.up:idKernel2
    //            //KeyNavigation.down:idKernel3
    //        }
    //        Image{
    ////            x:1
    ////            y:88
    //            anchors.top: idKernel3.bottom
    //            id:lineList5
    //            source:imgFolderGeneral+"line_menu_list.png"
    //        }



}

