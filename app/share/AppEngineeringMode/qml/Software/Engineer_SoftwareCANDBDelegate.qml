import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenuCANDelegate
    width: 537
    height:89
    Component.onCompleted:{
            //HU
           if(index == 0){
                      idRightMenuCANDelegate.secondText =""/*+sw.HU_Default */+ sw.HU_MM_HIGH +"."+ sw.HU_MM_LOW + " / " + /*sw.HU_Default +*/ sw.HU_SUB_HIGH + "." + sw.HU_SUB_LOW;
           }//iBox
           else if(index == 1){
                      idRightMenuCANDelegate.secondText ="" +canDB.IBOX_CanMajor_Ver + "." + canDB.IBOX_CanMinor_Ver;
           }//AMP
          else if(index == 2){

                     idRightMenuCANDelegate.secondText ="" + canDB.AMP_CanMajor_Ver + "." + canDB.AMP_CanMinor_Ver;
           }//CCP
           else if(index == 3){

                      idRightMenuCANDelegate.secondText = "" + canDB.CCP_CanMajor_Ver + "." + canDB.CCP_CanMinor_Ver;
           } //RRC
           else if(index == 4){
               idRightMenuCANDelegate.secondText = "" + canDB.RRC_CanMajor_Ver + "." + canDB.RRC_CanMinor_Ver;
           }//Front Monitor
           else if(index == 5){
               idRightMenuCANDelegate.secondText = ""+canDB.FM_CAN_Major_Ver +"." + canDB.FM_CAN_Minor_Ver;
           }//Rear Monitor L
           else if(index == 6){
               idRightMenuCANDelegate.secondText ="" + canDB.RML_CAN_Major_Ver + "." + canDB.RML_CAN_Minor_Ver;
           }//Rear Monitor R
           else if(index == 7){
               idRightMenuCANDelegate.secondText = "" + canDB.RMR_CAN_Major_Ver + "." + canDB.RMR_CAN_Minor_Ver;
           }
           //Cluster
           else if(index == 8){
               idRightMenuCANDelegate.secondText ="" + canDB.CLU_CanMajor_Ver + "." + canDB.CLU_CanMinor_Ver;
           }//HUD
           else if(index == 9){
               idRightMenuCANDelegate.secondText ="" + canDB.HUD_CanMajor_Ver + "." + canDB.HUD_CanMinor_Ver;
           }//Clock
           else if(index == 10){
               idRightMenuCANDelegate.secondText ="" + canDB.CLOCK_CanMajor_Ver + "." + canDB.CLOCK_CanMinor_Ver;
           }//GW
           else if(index == 11){
               idRightMenuCANDelegate.secondText ="" + canDB.GW_CanMajor_Ver + "." + canDB.GW_CanMinor_Ver ;
           }//FCAT Version
           else if(index == 12){
                idRightMenuCANDelegate.secondText = resVersionInfo.FCATVer;
           }

    }

    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

     firstText: name

     firstTextSize: 25
     firstTextX: 20
     firstTextY: 30//43
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
     bgImageFocusPress: imgFolderGeneral+ "bg"


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
    //            visible:showFocus && idRightMenuCANDelegate.activeFocus
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
    //            font.family:UIListener.getFont(false)// "HDR"
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

        idRightMenuCANDelegate.ListView.view.currentIndex=index
        idRightMenuCANDelegate.forceActiveFocus()

    }
    Connections{
        target: CanDataConnect
        onCan_connect_changed:{
            //HU
           if(index == 0){
                       idRightMenuCANDelegate.secondText =""/*+sw.HU_Default */+ sw.HU_MM_HIGH +"."+ sw.HU_MM_LOW + " / " + /*sw.HU_Default +*/ sw.HU_SUB_HIGH + "." + sw.HU_SUB_LOW;
           }//iBox
           else if(index == 1){
                      idRightMenuCANDelegate.secondText ="" +canDB.IBOX_CanMajor_Ver + "." + canDB.IBOX_CanMinor_Ver;
           }//AMP
          else if(index == 2){

                     idRightMenuCANDelegate.secondText ="" + canDB.AMP_CanMajor_Ver + "." + canDB.AMP_CanMinor_Ver;
           }//CCP
           else if(index == 3){

                      idRightMenuCANDelegate.secondText = "" + canDB.CCP_CanMajor_Ver + "." + canDB.CCP_CanMinor_Ver;
           } //RRC
           else if(index == 4){
               idRightMenuCANDelegate.secondText = "" + canDB.RRC_CanMajor_Ver + "." + canDB.RRC_CanMinor_Ver;
           }//Front Monitor
           else if(index == 5){
               idRightMenuCANDelegate.secondText = ""+canDB.FM_CAN_Major_Ver +"." + canDB.FM_CAN_Minor_Ver;
           }//Rear Monitor L
           else if(index == 6){
               idRightMenuCANDelegate.secondText ="" + canDB.RML_CAN_Major_Ver + "." + canDB.RML_CAN_Minor_Ver;
           }//Rear Monitor R
           else if(index == 7){
               idRightMenuCANDelegate.secondText = "" + canDB.RMR_CAN_Major_Ver + "." + canDB.RMR_CAN_Minor_Ver;
           }
           //Cluster
           else if(index == 8){
               idRightMenuCANDelegate.secondText ="" + canDB.CLU_CanMajor_Ver + "." + canDB.CLU_CanMinor_Ver;
           }//HUD
           else if(index == 9){
               idRightMenuCANDelegate.secondText ="" + canDB.HUD_CanMajor_Ver + "." + canDB.HUD_CanMinor_Ver;
           }//Clock
           else if(index == 10){
               idRightMenuCANDelegate.secondText ="" + canDB.CLOCK_CanMajor_Ver + "." + canDB.CLOCK_CanMinor_Ver;
           }//GW
           else if(index == 11){
               idRightMenuCANDelegate.secondText ="" + canDB.GW_CanMajor_Ver + "." + canDB.GW_CanMinor_Ver ;
           }
        }
    }


    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

