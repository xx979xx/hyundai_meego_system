/**
 * FileName: RadioHdmenuInfoOn.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import QtQuick 1.0

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioFmFrequencyDialInfo
    x: 0; y: 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioHdStringInfo{ id: stringInfo }

    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property int    sY                : 239         // 261
    property int    sX                : 22

    //****************************** # Info On #
    Item{
        x: 0; y: 0 //x: 0; y: idAppMain.hdRadioOnOff? 395-sY : 0  => JSH 130402 delete [AM , HD Info Delete]
        Image{
            x: sX - 22 //625-447
            y: sY-systemInfo.upperAreaHeight
            width: 22+558
            source: imgFolderRadio_Hd+"bg_info.png"
            //////////////////////////////////////
            // 121218 Cover Animation
            //MouseArea{
            //    anchors.fill: parent
            //    onClicked: {idAppMain.menuInfoFlag = !idAppMain.menuInfoFlag;}
            //}
            //////////////////////////////////////
            Text{
                id:idNoInformation
                text: stringInfo.strHDMsgNoInformation
                //x: sX  ; y: idText2.y
                //width: 558; height: 30
                anchors.fill: parent
                color: colorInfo.brightGrey
                //font { family: "HDR"; pixelSize: 30}
                font { family: systemInfo.hdr; pixelSize: 30}
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible:{
                    //////////////////////////////////////////////////
                    // JSH 130402 added
                    if(idText.text == "") {return true; }
                    else                  {return false;}
                    //////////////////////////////////////////////////
                    // JSH 130402 delete [AM , HD Info Delete]
                    //if(idRadioHdMain.noSignal)
                    //    return true;
                    //else if(idAppMain.hdRadioOnOff && idText1.text == "" && idText2.text == "" && idText3.text == "")
                    //    return true;
                    //else if((!idAppMain.hdRadioOnOff) && idText.text == "")
                    //    return true;
                    //else
                    //    return false;
                }
            }
        }
        Text{
            id:idText
            text: idAppMain.rtText
            x: sX ; y: sY-systemInfo.upperAreaHeight+40-30/2
            width: 508; height: 30
            wrapMode: Text.Wrap
            color: colorInfo.brightGrey
            //font { family: "HDR"; pixelSize: 30}
            font { family: systemInfo.hdr; pixelSize: 30}
            horizontalAlignment: Text.AlignLeft
            visible: true //visible: idAppMain.hdRadioOnOff ? false : true => JSH 130402 delete [AM , HD Info Delete]
        }
//////////////////////////////////////////////
//  JSH 130402 delete [AM , HD Info Delete]
//        Item{
//            id:idHdInfoArea
//            visible: (!idRadioHdMain.noSignal)
//            Image{
//                id:idText1Image
//                x: sX; y: idText1.y//sY-systemInfo.upperAreaHeight+40-30/2
//                //width: 34 ; height: 34
//                source: imgFolderRadio_Hd+"ico_artist_n.png" //"ico_info_01.png"
//                visible: idAppMain.hdRadioOnOff ? true :false //idText1.visible && idText1.text != ""
//            }
//            Text{
//                id:idText1
//                x: sX + 50; y: sY-systemInfo.upperAreaHeight+40-30/2
//                width: 508; height: idText1Image.height
//                text: idAppMain.psdArtist//""//"Text 1 line Text 1 line Text 1 line" //
//                font.family: systemInfo.hdr//"HDR"
//                font.pixelSize: 30
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//                color: colorInfo.brightGrey
//                elide:Text.ElideRight
//                visible:idAppMain.hdRadioOnOff ? true :false
//            }

//            Image{
//                id:idText2Image
//                x: sX; y: idText2.y
//                //width: 34 ; height: 34
//                source: imgFolderRadio_Hd+"ico_song_n.png"//"ico_info_02.png"
//                visible: idAppMain.hdRadioOnOff ? true :false //idText2.visible && idText2.text != ""
//            }
//            Text{
//                id:idText2
//                x: sX + 50; y: sY-systemInfo.upperAreaHeight+40+48-30/2
//                width: 508; height: idText2Image.height
//                text: idAppMain.psdTitle //""//"Text 2 line Text 2 line Text 2 line"//
//                font.family: systemInfo.hdr//"HDR"
//                font.pixelSize: 30
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//                color: colorInfo.brightGrey
//                elide:Text.ElideRight
//                visible: idAppMain.hdRadioOnOff ? true :false
//            }

//            Image{
//                id:idText3Image
//                x: sX; y: idText3.y
//                //width: 34 ; height: 34
//                source: imgFolderRadio_Hd+"ico_album_n.png"//"ico_info_03.png"
//                visible: idAppMain.hdRadioOnOff ? true :false //idText3.visible && idText3.text != ""
//            }
//            Text{
//                id:idText3
//                x: sX+ 50; y: sY-systemInfo.upperAreaHeight+40+48+48-30/2
//                width: 508; height: idText3Image.height//30
//                text: idAppMain.psdAlbum //""//"Text 3 line Text 3 line Text 3 line"//
//                font.family: systemInfo.hdr//"HDR"
//                font.pixelSize: 30
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//                color: colorInfo.brightGrey
//                elide:Text.ElideRight
//                visible: idAppMain.hdRadioOnOff ? true :false
//            }

//            //        Image{
//            //            id:idText4Image
//            //            x: sX; y: idText4.y
//            //            width: 34 ; height: 34
//            //            source: imgFolderRadio_Hd+"ico_info_04.png"
//            //            visible: idText4.visible && idText4.text != ""
//            //        }
//            //        Text{
//            //            id:idText4
//            //            x: sX+ 50; y: sY-systemInfo.upperAreaHeight+40+48+48+48-30/2
//            //            width: 508; height: idText4Image.height//30
//            //            text:  ""//"Text 4 line Text 4 line Text 4 line" //
//            //            font.family: systemInfo.hdr//"HDR"
//            //            font.pixelSize: 30
//            //            horizontalAlignment: Text.AlignLeft
//            //            verticalAlignment: Text.AlignVCenter
//            //            color: colorInfo.brightGrey
//            //            visible: idAppMain.hdRadioOnOff ? true :false
//            //        }
//        }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
    }
//    Connections{ // JSH 120726
//        target:QmlController
//        onCommercial_Price      : idText1.text = str
//        onCommercial_Date       : idText2.text = str
//        onCommercial_Contact    : idText3.text = str
//        onCommercial_SellerName : idText4.text = str
//    }
}
