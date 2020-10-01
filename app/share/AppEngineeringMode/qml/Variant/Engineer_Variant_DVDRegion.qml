import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MComponent{
    id:idDvdLoaderMain
    x:0
    y:0
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea
    Component.onCompleted:{
        dvdRegionCode.forceActiveFocus()
        UIListener.autoTest_athenaSendObject();

    }

    Connections{
        target: VariantSetting
        onRefreshVariantData:{
            dvdRegionCode.currentIndexVal = variant.DvdRegion_data
            menuLanguage.currentIndexVal = variant.DvdMenu_data
        }
    }

        Text{
            width: 180
            height: 60
            x:0
            y:20
            text: "DVD Region"
            font.pixelSize: 25
            color:colorInfo.brightGrey
            //horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"
        }
    MComp.Spinner{
        x:210; y:20
        id:dvdRegionCode
        focus: true
        aSpinControlTextModel: dvdRegionCode_textModel
        currentIndexVal:variant.DvdRegion_data
        KeyNavigation.down:menuLanguage
//        KeyNavigation.left:idVariantLeftList

        KeyNavigation.up:{

                backFocus.forceActiveFocus()
                variantBand

        }

        onSpinControlValueChanged: {
            if(curVal   == 0){
                   VariantSetting.SaveVariant_Data(0, EngineerData.DB_DVD_REGION);


            }
            else if(curVal == 1){
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_DVD_REGION );

            }
            else if(curVal == 2){
                VariantSetting.SaveVariant_Data(2, EngineerData.DB_DVD_REGION);


            }
            else if(curVal == 3){
                VariantSetting.SaveVariant_Data(3, EngineerData.DB_DVD_REGION);

            }
            else if(curVal == 4){
                VariantSetting.SaveVariant_Data(4, EngineerData.DB_DVD_REGION);
            }
            else if(curVal == 5){
                VariantSetting.SaveVariant_Data(5, EngineerData.DB_DVD_REGION);
            }
            else if(curVal == 6){
                VariantSetting.SaveVariant_Data(6, EngineerData.DB_DVD_REGION);
            }

        }

    }
    ListModel{
        id:dvdRegionCode_textModel
        property int count: 7
        ListElement{name:"0x00";}
        ListElement{name:"0x01";}
        ListElement{name:"0x02";}
        ListElement{name:"0x03";}
        ListElement{name:"0x04";}
        ListElement{name:"0x05";}
        ListElement{name:"0x06";}

    }

    Image{
        x:20
        y:100
        source: imgFolderGeneral+"line_menu_list.png"
    }

    Text{
        width: 200
        height: 60
        x:0
        y:120
        text: "Menu Language"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.Spinner{
        x:210; y:120
        id:menuLanguage
        //focus: true
        aSpinControlTextModel: menuLanguage_textModel
        currentIndexVal:variant.DvdMenu_data
        KeyNavigation.up:dvdRegionCode

        onSpinControlValueChanged: {
            if(curVal   == 0){
                   VariantSetting.SaveVariant_Data( 0, EngineerData.DB_MENU_LANGUAGE );

            }
            else if(curVal == 1){
                VariantSetting.SaveVariant_Data(1, EngineerData.DB_MENU_LANGUAGE);

            }
            else if(curVal == 2){
                VariantSetting.SaveVariant_Data(2, EngineerData.DB_MENU_LANGUAGE);

            }
            else if(curVal == 3){
                VariantSetting.SaveVariant_Data(3, EngineerData.DB_MENU_LANGUAGE);
            }


        }

    }
    ListModel{
        id:menuLanguage_textModel
        property int count: 4
        ListElement{name:"ko";}
        ListElement{name:"en";}
        ListElement{name:"ch";}
        ListElement{name:"ru";}


    }

    Image{
        x:20
        y:200
        source: imgFolderGeneral+"line_menu_list.png"
    }
}


//import "../Component" as MComp
//import "../System" as MSystem

//MComp.MComponent{
//    id:idVariantDVDLoader
//    x:-1; y:261-89-166+5
//    width:systemInfo.lcdWidth-708
//    height:systemInfo.lcdHeight-166
//    clip:true
//    focus: true

//    MSystem.ImageInfo { id: imageInfo }
//    MSystem.SystemInfo { id: systemInfo }
//     property string imgFolderGeneral: imageInfo.imgFolderGeneral

//    //property string system: SystemInfo.GetSoftWareVersion();

//    ListModel{
//        id:variantDVDData
//        ListElement {   name:"Region Code" ; gridId:0} //0
//        ListElement {   name:"Menu Language" ;   gridId:1 } //1


//    }
//    ListView{
//        id:idVariantDVDView
//        opacity : 1
//        clip: true
//        focus: true
//        anchors.fill: parent;
//        model: variantDVDData
//        delegate: Engineer_VariantDVDDelegate{
//            onWheelLeftKeyPressed:idVariantDVDView.decrementCurrentIndex()
//            onWheelRightKeyPressed:idVariantDVDView.incrementCurrentIndex()
//        }
//        orientation : ListView.Vertical
//        highlightMoveSpeed: 9999999

//    }

////    Component
////    {

////       id:listHeadUnit;

////       Column
////       {
////           id:contentColumn; width:1280 - 520
////           focus:true

////        MComp.MButton{
////            id:idSystemSW
////            width:537
////            height:92

////            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
////            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
////            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"

////            focus:true
////            firstText: qsTr("System SW")
////            firstTextWidth: 150
////            firstTextX: 20
////            firstTextY: 43
////            firstTextColor: colorInfo.brightGrey
////            firstTextSelectedColor: colorInfo.brightGrey
////            firstTextSize: 25
////            firstTextStyle: "HDB"
////            secondText: qsTr(SystemInfo.GetSoftWareVersion())
////            secondTextX: 220
////            secondTextY: 43
////            secondTextSize:20
////            secondTextColor: "#447CAD"
////            secondTextSelectedColor: colorInfo.dimmedGrey
////            secondTextStyle: "HDB"
////            secondTextWidth: 403

////            KeyNavigation.down:idKernel
////        }
////        Image{
//////            x:1
//////            y:88
////            anchors.top: idSystemSW.bottom
////            id:lineList1
////            source:imgFolderGeneral+"line_menu_list.png"
////        }

////        MComp.MButton{
////            id:idKernel
////            width:537
////            height:92
////            //y:88
////            anchors.top: idSystemSW.bottom

////            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
////            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
////            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
////            //focus:true
////            firstText: qsTr("Kernel ")
////            firstTextWidth: 100
////            firstTextX: 20
////            firstTextY: 43
////            firstTextColor: colorInfo.brightGrey
////            firstTextSelectedColor: colorInfo.brightGrey
////            firstTextSize: 25
////            firstTextStyle: "HDB"
////            secondText: qsTr(SystemInfo.GetKernelVersion())
////            secondTextX: 220
////            secondTextY: 43
////            secondTextSize:20
////            secondTextColor: "#447CAD"
////            secondTextSelectedColor: colorInfo.dimmedGrey
////            secondTextStyle: "HDB"
////            secondTextWidth: 403

////            KeyNavigation.up:idSystemSW
////            KeyNavigation.down:idSystemSW1
////        }
////        Image{
//////            x:1
//////            y:88
////            anchors.top: idKernel.bottom
////            id:lineList
////            source:imgFolderGeneral+"line_menu_list.png"
////        }
////        MComp.MButton{
////            id:idSystemSW1
////            width:537
////            height:92

////            anchors.top: idKernel.bottom
////            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
////            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
////            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"

////            //focus:true
////            firstText: qsTr("System SW")
////            firstTextWidth: 150
////            firstTextX: 20
////            firstTextY: 43
////            firstTextColor: colorInfo.brightGrey
////            firstTextSelectedColor: colorInfo.brightGrey
////            firstTextSize: 25
////            firstTextStyle: "HDB"
////            secondText: qsTr(SystemInfo.GetSoftWareVersion())
////            secondTextX: 220
////            secondTextY: 43
////            secondTextSize:20
////            secondTextColor: "#447CAD"
////            secondTextSelectedColor: colorInfo.dimmedGrey
////            secondTextStyle: "HDB"
////            secondTextWidth: 403

////            KeyNavigation.down:idKernel1
////            KeyNavigation.up:idKernel
////        }
////        Image{
//////            x:1
//////            y:88
////             anchors.top: idSystemSW1.bottom
////            id:lineList2
////            source:imgFolderGeneral+"line_menu_list.png"
////        }
////        MComp.MButton{
////            id:idKernel1
////            width:537
////            height:92
////            //y:88
////            anchors.top: idSystemSW1.bottom

////            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
////            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
////            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
////            //focus:true
////            firstText: qsTr("Kernel ")
////            firstTextWidth: 100
////            firstTextX: 20
////            firstTextY: 43
////            firstTextColor: colorInfo.brightGrey
////            firstTextSelectedColor: colorInfo.brightGrey
////            firstTextSize: 25
////            firstTextStyle: "HDB"
////            secondText: qsTr(SystemInfo.GetKernelVersion())
////            secondTextX: 220
////            secondTextY: 43
////            secondTextSize:20
////            secondTextColor: "#447CAD"
////            secondTextSelectedColor: colorInfo.dimmedGrey
////            secondTextStyle: "HDB"
////            secondTextWidth: 403

////            KeyNavigation.up:idSystemSW1
////            KeyNavigation.down:idKernel2
////        }
////        Image{
//////            x:1
//////            y:88
////            anchors.top: idKernel1.bottom
////            id:lineList3
////            source:imgFolderGeneral+"line_menu_list.png"
////        }

////        MComp.MButton{
////            id:idKernel2
////            width:537
////            height:92
////            //y:88
////            anchors.top: idKernel1.bottom

////            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
////            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
////            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
////            //focus:true
////            firstText: qsTr("Kernel ")
////            firstTextWidth: 100
////            firstTextX: 20
////            firstTextY: 43
////            firstTextColor: colorInfo.brightGrey
////            firstTextSelectedColor: colorInfo.brightGrey
////            firstTextSize: 25
////            firstTextStyle: "HDB"
////            secondText: qsTr(SystemInfo.GetKernelVersion())
////            secondTextX: 220
////            secondTextY: 43
////            secondTextSize:20
////            secondTextColor: "#447CAD"
////            secondTextSelectedColor: colorInfo.dimmedGrey
////            secondTextStyle: "HDB"
////            secondTextWidth: 403

////            KeyNavigation.up:idKernel1
////            KeyNavigation.down:idKernel3
////        }
////        Image{
//////            x:1
//////            y:88
////            anchors.top: idKernel2.bottom
////            id:lineList4
////            source:imgFolderGeneral+"line_menu_list.png"
////        }

////        MComp.MButton{
////            id:idKernel3
////            width:537
////            height:92
////            //y:88
////            anchors.top: idKernel2.bottom

////            bgImagePress: imgFolderGeneral+"line_menu_02_p.png"
////            bgImageFocusPress: imgFolderGeneral+"line_menu_02_fp.png"
////            bgImageFocus: imgFolderGeneral+"line_menu_02_f.png"
////            //focus:true
////            firstText: qsTr("Kernel ")
////            firstTextWidth: 100
////            firstTextX: 20
////            firstTextY: 43
////            firstTextColor: colorInfo.brightGrey
////            firstTextSelectedColor: colorInfo.brightGrey
////            firstTextSize: 25
////            firstTextStyle: "HDB"
////            secondText: qsTr(SystemInfo.GetKernelVersion())
////            secondTextX: 220
////            secondTextY: 43
////            secondTextSize:20
////            secondTextColor: "#447CAD"
////            secondTextSelectedColor: colorInfo.dimmedGrey
////            secondTextStyle: "HDB"
////            secondTextWidth: 403

////            KeyNavigation.up:idKernel2
////            //KeyNavigation.down:idKernel3
////        }
////        Image{
//////            x:1
//////            y:88
////            anchors.top: idKernel3.bottom
////            id:lineList5
////            source:imgFolderGeneral+"line_menu_list.png"
////        }


//       }

