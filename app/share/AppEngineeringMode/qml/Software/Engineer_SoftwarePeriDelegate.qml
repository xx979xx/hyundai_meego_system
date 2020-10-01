import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenuPeriDelegate
    width: 537
    height:89
    Component.onCompleted:{
            //iBox
           if(index == 0){
                      idRightMenuPeriDelegate.secondText = canDB.IBOX_SwMajor_Ver + "." + canDB.IBOX_SwMinor_Ver;
           }//AMP
           else if(index == 1){
               // for KH/VI CAN AMP Version 01/15
               if(VariantSetting.GetCanAMPState())
               {

                   if(sw.CAN_AMP_OEM == "TC" || sw.CAN_AMP_SW_MAJOR == "x")
                   {
                       idRightMenuPeriDelegate.secondText = "Not.Received";
                   }
                    else
                        idRightMenuPeriDelegate.secondText = sw.CAN_AMP_OEM + "." + sw.CAN_AMP_SW_MAJOR + "." + sw.CAN_AMP_SW_MINOR + "." + sw.CAN_AMP_TUNNING_MAJOR + "."+ sw.CAN_AMP_TUNNING_MINOR ;
               }
               else
               {
                   idRightMenuPeriDelegate.secondText =canDB.AMP_SwMajor_Ver + "." + canDB.AMP_SwMinor_Ver;
               }
               // for KH/VI CAN AMP Version 01/15

           }//CCP
           else if(index == 2){

                     idRightMenuPeriDelegate.secondText =canDB.CCP_SwMajor_Ver + "." + canDB.CCP_SwMinor_Ver +"." + canDB.CCP_SwInter_Ver;
           }//RRC
           else if(index == 3){

                      idRightMenuPeriDelegate.secondText = canDB.RRC_SwMajor_Ver + "." + canDB.RRC_SwMinor_Ver + "." + canDB.RRC_SwInter_Ver;
           } //Clock
           else if(index == 4){
               idRightMenuPeriDelegate.secondText = canDB.CLOCK_SwMajor_Ver + "." + canDB.CLOCK_SwMinor_Ver;
           }//Front Monitor
           else if(index == 5){
               idRightMenuPeriDelegate.secondText = "" +sw.Front_LCD_0 +"." + sw.Front_LCD_1 + sw.ZeroF;
           }//Rear Monitor L
           else if(index == 6){
               idRightMenuPeriDelegate.secondText = "" +canDB.RML_CAN_Sw_Major_Ver+ "."  + canDB.RML_CAN_Sw_Minor_Ver + canDB.ZeroL;
           }
           //Rear Monitor R
           else if(index == 7){
                idRightMenuPeriDelegate.secondText = "" +canDB.RMR_CAN_Sw_Major_Ver+ "."  + canDB.RMR_CAN_Sw_Minor_Ver+ canDB.ZeroR;
           }//AVM
           else if(index == 8){
               idRightMenuPeriDelegate.secondText = "" + resVersionInfo.CameraAVMVer
           }//PGS
           else if(index == 9){
               idRightMenuPeriDelegate.secondText = "" + resVersionInfo.CameraPGSVer
           }
           //HUD
           else if(index == 10){
              idRightMenuPeriDelegate.secondText = canDB.HUD_SwMajor_Ver + "." + canDB.HUD_SwMinor_Ver
           }//Cluster
           else if(index == 11){
               idRightMenuPeriDelegate.secondText = canDB.CLU_SwMajor_Ver + "." + canDB.CLU_SwMinor_Ver
           }

    }

    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    firstText: name

    firstTextSize: 25
    firstTextX: 20
    firstTextY: 30/*43*/
    firstTextWidth: 230

    secondText: ""
    secondTextSize: 20
    secondTextX: 250
    secondTextY:30//43
    secondTextWidth: 403
    secondTextHeight: secondTextSize//+10
    secondTextColor: colorInfo.bandBlue

    bgImage: ""
    fgImage: ""
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    //bgImageFocusPress: imgFolerGeneral+ "bg"



    //    property string firstText: name

    //    property int firstTextSize: 0
    //    property int firstTextX: 20
    //    property int firstTextY: 43
    //    property int firstTextWidth: 230

    //    property string secondText: ""
    //    property int secondTextSize: 20
    //    property int secondTextX: 250
    //    property int secondTextY:43
    //    property int secondTextWidth: 403
    //    property int secondTextHeight: secondTextSize//+10

    //    property string bgImage: ""
    //    property string fgImage: ""
    //    property string bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    //    property string bgImageFocusPress: imgFolerGeneral+ "bg"


    //    Item{
    //        id: idLayoutItem
    //        x: 0
    //        y: 0
    //        width:parent.width
    //        height:parent.height

    //        //****************************** # Default/Selected/Press Image #
    //        Image{
    //            id: normalImage
    //            x: 30//44-7
    //            y: -1
    //            source: bgImage
    //        } // End Image

    //        //****************************** # Focus Image #
    //        BorderImage {
    //            id: focusImage
    //            x:0
    //            y: -1
    //            source: bgImageFocus;
    //            visible:showFocus && idRightMenuPeriDelegate.activeFocus
    //        } // End BorderImage

    //        //****************************** # Index (FirstText) #
    //        Text{
    //            id: idfirstText
    //            text: firstText
    //            x: 20; y: 20
    //            width: 230; /*height: 40*/
    //            font.pixelSize: 25
    //            font.family: UIListener.getFont(true)//"HDB"
    //            verticalAlignment: Text.AlignVCenter
    //            horizontalAlignment:Text.AlignLeft
    //            color: colorInfo.brightGrey
    //        } // End Text

    //        //Second Text
    //        Text{
    //            id: idsecondText
    //            text: secondText
    //            x: 250
    //            y: 30
    //            width: 403
    //            font.pixelSize: 20
    //            font.family: UIListener.getFont(false)//"HDR"
    //            verticalAlignment: Text.AlignVCenter
    //            horizontalAlignment: Text.AlignVCenter
    //            color: colorInfo.bandBlue

    //        } // End Text
    //    } // End Item

    //    states: [
    //        State {
    //            name: 'pressed'; when: isMousePressed()
    //            PropertyChanges {target: backGround; source: bgImagePress;}
    //            PropertyChanges {target: imgFgImage; source: fgImagePress;}
    //            PropertyChanges {target: txtFirstText; textColor: firstTextPressColor;}
    //            PropertyChanges {target: txtSecondText; textColor: secondTextPressColor;}

    //        },
    //        State {
    //            name: 'active'; when: container.active
    //            PropertyChanges {target: backGround; source: bgImageActive;}
    //            PropertyChanges {target: imgFgImage; source: fgImageActive;}
    //            PropertyChanges {target: txtFirstText; textColor: firstTextSelectedColor;}
    //            PropertyChanges {target: txtSecondText; textColor: secondTextSelectedColor;}

    //        },
    //        State {
    //            name: 'keyPress'; when: container.state=="keyPress" // problem Kang
    //            PropertyChanges {target: backGround; source: bgImageFocusPress;}
    //            PropertyChanges {target: bgImageFocus; source: bgImageFocusPress;}
    //            PropertyChanges {target: txtFirstText; textColor: firstTextFocusPressColor;}
    //            PropertyChanges {target: txtSecondText; textColor: secondTextFocusPressColor;}

    //        },
    //        State {
    //            name: 'keyReless';
    //            PropertyChanges {target: backGround; source: bgImage;}
    //            PropertyChanges {target: bgImageFocus; source: fgImage;}
    //            PropertyChanges {target: txtFirstText; textColor: focusImageVisible? firstTextFocusColor : firstTextColor;}
    //            PropertyChanges {target: txtSecondText; textColor: focusImageVisible? secondTextFocusColor : secondTextPressColor;}

    //        },
    //        State {
    //            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
    //            PropertyChanges {target: backGround; source: bgImage;}
    //            PropertyChanges {target: imgFgImage; source: fgImage;}
    //            PropertyChanges {target: txtFirstText; textColor: firstTextEnabled? firstTextColor : firstTextDisableColor;}
    //            PropertyChanges {target: txtSecondText; textColor: secondTextEnabled? secondTextColor : secondTextDisableColor;}

    //        }
    //    ]



    //    KeyNavigation.up:{
    //        if(index == 0){
    //            backFocus.forceActiveFocus()
    //            softwareBand
    //        }
    //    }

    onClickOrKeySelected: {

        idRightMenuPeriDelegate.ListView.view.currentIndex=index
        idRightMenuPeriDelegate.forceActiveFocus()

    }

    Connections{
        target: CanDataConnect
        onCan_connect_changed:{
            //iBox
           if(index == 0){
                      idRightMenuPeriDelegate.secondText = canDB.IBOX_SwMajor_Ver + "." + canDB.IBOX_SwMinor_Ver;
           }//AMP
           else if(index == 1){
                      idRightMenuPeriDelegate.secondText =canDB.AMP_SwMajor_Ver + "." + canDB.AMP_SwMinor_Ver;
           }//CCP
          else if(index == 2){

                     idRightMenuPeriDelegate.secondText =canDB.CCP_SwMajor_Ver + "." + canDB.CCP_SwMinor_Ver +"." + canDB.CCP_SwInter_Ver;
           }//RRC
           else if(index == 3){

                     idRightMenuPeriDelegate.secondText = canDB.RRC_SwMajor_Ver + "." + canDB.RRC_SwMinor_Ver + "." + canDB.RRC_SwInter_Ver;
           } //Clock
           else if(index == 4){
               idRightMenuPeriDelegate.secondText = canDB.CLOCK_SwMajor_Ver + "." + canDB.CLOCK_SwMinor_Ver;
           }
           else if(index == 5){
               idRightMenuPeriDelegate.secondText = "" +sw.Front_LCD_0 +"." + sw.Front_LCD_1 + sw.ZeroF;
           }//Rear Monitor L
           else if(index == 6){
               idRightMenuPeriDelegate.secondText = "" +canDB.RML_CAN_Sw_Major_Ver+ "."  + canDB.RML_CAN_Sw_Minor_Ver+ canDB.ZeroL;
           }
           //Rear Monitor R
           else if(index == 7){
               idRightMenuPeriDelegate.secondText = "" +canDB.RMR_CAN_Sw_Major_Ver+ "."  + canDB.RMR_CAN_Sw_Minor_Ver+ canDB.ZeroR;
           }//AVM
          else if(index == 8){
              idRightMenuPeriDelegate.secondText = "" + resVersionInfo.CameraAVMVer
          }//PGS
          else if(index == 9){
              idRightMenuPeriDelegate.secondText = "" + resVersionInfo.CameraPGSVer
          }
          //HUD
         else if(index == 10){
             idRightMenuPeriDelegate.secondText = canDB.HUD_SwMajor_Ver + "." + canDB.HUD_SwMinor_Ver
         }//Cluster
          else if(index == 11){
              idRightMenuPeriDelegate.secondText = canDB.CLU_SwMajor_Ver + "." + canDB.CLU_SwMinor_Ver
          }

        }

    }

    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

