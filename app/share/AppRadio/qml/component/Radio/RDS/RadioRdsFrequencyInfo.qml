/**
 * FileName: RadioRdsFrequencyInfo.qml
 * Author: HYANG
 * Time: 2012-06
 *
 * - 2012-06 Initial Created by HYANG
 */

import QtQuick 1.0

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

Item {
    id: idRadioRdsFrequencyInfo
    x: 0 + x_offset; y: 0 + y_offset;
    width:text_width_offset;

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    property string imgFolderRadio : imageInfo.imgFolderRadio
//    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_Rds
    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_RdsForPremium //KSW 130731 for premium UX
    property string imgFolderRadio_Dab : imageInfo.imgFolderRadio_Dab

    property int band ;
    property int x_offset : (band == 0x01)?146:146/*304:329*/; //modified by Michael Kim 2013.04.03 for New UX
    property int y_offset : ((band == 0x01)?326:326/*396*/) - systemInfo.statusBarHeight; //modified by Michael Kim 2013.04.03 for New UX
    property int text_width_offset : (band == 0x01)?553:522 ;

    property string strFmFrequency;
    property string strAmFrequency;
    property string strPsname;
    property int nPresetIndex;
    property int nPtytype;

    property bool bPresetNumberVisiable : false // KSW 130907 [EU][ISV][C] Missing deletion of the preset number

// 20130406 added by qutiguy - set height offset
    property bool rtShowOnOff
//    property int y_offsetRTDisplay : rtShowOnOff? - 34 : 0;  //KSW 130806 Fixed it, problem do not update rt text.
    property int  firestLinePaintHeight : 54 - (idFmFirstLine.paintedHeight / 2)


    //****************************** # PtyLog Image #
    Item {
        id: idPtyImage
        width: 262 /*198*/; height: 262/*198*/; //modified by Michael Kim 2013.04.03 for New UX
        Image {
            source: imgFolderRadio_Rds + "bg_pty.png";
        }
        Image {
            id: idPtyImageFM
            x : 3; y:3 //ITS 0194688
            width: 256 /*198*/; height: 256/*198*/; //modified by Michael Kim 2013.04.03 for New UX
            source: imgFolderRadio_Rds + getptyimage(nPtytype)
            visible: band == 0x01
        }
        Image {
            id: idPtyImageAM
            x : 3; y:3 //ITS 0194688
            width: 256 /*198*/; height: 256/*198*/; //modified by Michael Kim 2013.04.03 for New UX
            source: imgFolderRadio_Rds + getptyimage(32) //modified by Michael Kim 2013.04.03 for New UX
            visible: band == 0x03
        }
    }

//// 2013.09.10 removed by qutiguy - according to GUI guide DH Genesis_Guideline_RDS_Radio_v2.0.3.pdf
    //****************************** # PtyMask Image #
//    Item {
//        id: idPtyMask
//        x: 0; y: 272;
//        width: 262; height: 262
//        Image {
//            source: imgFolderRadio_Rds + "bg_pty.png";
//            anchors.horizontalCenter: idPtyMask.horizontalCenter
//            transform : [
//                Rotation {
//                angle: 180; origin.y: 0//idptyMask.height
//                axis.x: 131; axis.y: 131; axis.z: 0
//                }
//            ]
//            transformOrigin: Item.Center
//            rotation: 90
//            Image {
//                id: idPtyImageFMReflect
//                //width: 262 /*198*/; height: 262/*198*/; //modified by Michael Kim 2013.04.03 for New UX
//                width: idPtyMask.width; height: idPtyMask.height
//                source: imgFolderRadio_Rds + getptyimage(nPtytype)
//                visible: band == 0x01
//            }
//            Image {
//                id: idPtyImageAMReflect
//                //width: 262 /*198*/; height: 262/*198*/; //modified by Michael Kim 2013.04.03 for New UX
//                width: idPtyMask.width; height: idPtyMask.height
//                source: imgFolderRadio_Rds + getptyimage(32) //modified by Michael Kim 2013.04.04 for New UX
//                visible: band == 0x03
//            }
//            Rectangle {
//                //width: 262; height: 262
//                width: idPtyMask.width; height: idPtyMask.height
//                gradient: Gradient {
////                    GradientStop { position: 0.7; color: "#00000A" }
////                    GradientStop { position: 1.0; color: "transparent" }
//                    GradientStop { position: 0.4; color: "#FF000011" }
//                    GradientStop { position: 1.0; color: "#AA000011" }
//                }
//            }
//        }
//    } //added Michael Kim 2013.04.03 for New UX

    //****************************** # Frequency Info #
    Item {
        id : idFrequencyFmInformation
        x : idPtyImage.width + 51; //40;
        y : 0; //y_offsetRTDisplay; //KSW 130806 Fixed it, problem do not update rt text.
        width: text_width_offset; height: idPtyImage.width
        visible: band == 0x01

        Text {
            id: idFmFirstLine
            x : 0 ; y: firestLinePaintHeight;
            text: strFmFrequency
            font.pixelSize: 36
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
//            anchors.top: idFrequencyFmInformation.top
            color: colorInfo.brightGrey
            visible: enablePSNameDisplay();
        }

        Text {
            id: idFirstLineMhz
            x : 130 ; y: firestLinePaintHeight ;
            text: "MHz"
            font.pixelSize: 36
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            visible: enablePSNameDisplay();
        }

        Text {
            id: idFmSecondLine
            x : 0 ; //y : 0//68
            text: enablePSNameDisplay()?strPsname:idFmFirstLine.text
            font.pixelSize: 75
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: idFrequencyFmInformation.verticalCenter
            color: colorInfo.brightGrey
            visible: true
        }

        Text {
            id: idSecondLineMhz
            x : 260 ; //y : 0//68 //[ISV][88864] KSW fixed x position //KSW 130724 for premium UX
            //[ISV][88864] KSW fixed x position anchors.left: idFmSecondLine.right //KSW 130724 for premium UX
            text: "MHz"
            font.pixelSize: 75
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: idFrequencyFmInformation.verticalCenter
            color: colorInfo.brightGrey
            visible: !enablePSNameDisplay()
        }

        Text {
            id: idPtyname
            x: 0 ; y : 193;
            text: getptyname(nPtytype)
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
//            anchors.bottom: idFrequencyFmInformation.bottom
            color: colorInfo.rdsGrey
        }
        Image {
            id: idSeperation
            x : (nPtytype == 0)?0:idPtyname.paintedWidth + 11; y: 195 + 5
            source: imgFolderRadio_Rds + "ch_info_divider.png"
//            anchors.bottom: idFrequencyFmInformation.bottom
            anchors.bottomMargin: 10
            visible: ((nPtytype != 0) && (idFmPresetNo.visible))
        }
        Text {
            id: idFmPresetNo
            x : idSeperation.visible?idPtyname.paintedWidth + 24 : 0 ; y: 193
            text: "P" + nPresetIndex
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
//            anchors.bottom: idFrequencyFmInformation.bottom
            color: colorInfo.rdsGrey
            visible: ((nPresetIndex <= 12) && (nPresetIndex > 0)) ? ((bPresetNumberVisiable == true) ? true : false) :false //KSW 130907 [EU][ISV][C] Missing deletion of the preset number
        }
    }

    Item{
        id : idFrequencyAmInformation
        x : idPtyImage.width + 51; //57;//40; //KSW 130724 for premium UX
        width: text_width_offset;  height: idPtyImage.width
        visible: band == 0x03
        Text {
            id: idSecondLine
            x: 0 ; y : 0
            text: strAmFrequency
            font.pixelSize: 75 //100 //KSW 130724 for premium UX
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            anchors.verticalCenter: idFrequencyAmInformation.verticalCenter
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }
        Text {
            id: idSecondLineKhz
            x: 190; // [ISV][88864] KSW fixed x postion//anchors.left: idSecondLine.right //KSW 130724 for premium UX
            text: "kHz"
            font.pixelSize: 75 //100 //KSW 130724 for premium UX
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            anchors.verticalCenter: idFrequencyAmInformation.verticalCenter
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }
        Text {
            id: idAmPresetNo
            x : 0 ; //y: 150
            y : 193 ; //KSW 130724 for premium UX
            text: "P" + nPresetIndex
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"/*systemInfo.hdb*/ //modified by Michael Kim 2013.04.03 for New UX
            horizontalAlignment: Text.AlignLeft
            //            verticalAlignment: Text.AlignVCenter
//            anchors.bottom: idFrequencyAmInformation.bottom //KSW 130724 for premium UX
            color: colorInfo.rdsGrey
            visible: ((nPresetIndex <= 12) && (nPresetIndex > 0))?true:false
        }
    }
}
