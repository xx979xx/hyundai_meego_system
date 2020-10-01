import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent{
    id:idCANDBLoader
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
        id:candbData
        ListElement {   name:"HU" ; }
        ListElement {   name:"iBox" ;   }

        ListElement {   name:"AMP" ; }
        ListElement {   name:"CCP" ; }
        ListElement {   name:"RRC";}
        ListElement {   name:"Front Monitor";}
        ListElement {   name:"Rear Monitor L";}
        ListElement {   name:"Rear  Monitor R";}
        ListElement {   name:"Cluster";}
        ListElement {   name:"HUD";}
        ListElement {   name:"Clock";}
         ListElement {   name:"GW";}
         ListElement {   name: "FCAT"; }

    }
    ListView{
        id:idCANDBView
        //opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        model: candbData
        delegate: Engineer_SoftwareCANDBDelegate{
            onWheelLeftKeyPressed:idCANDBView.decrementCurrentIndex()
            onWheelRightKeyPressed:idCANDBView.incrementCurrentIndex()
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
        x:systemInfo.lcdWidth-708 -30; y:/*idTotalChList.y*/+scrollY; z:1
        scrollArea: idCANDBView;
        height: idCANDBView.height-(scrollY*2)-8; width: scrollWidth
        //anchors.right: idHeadUnitView.right
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

