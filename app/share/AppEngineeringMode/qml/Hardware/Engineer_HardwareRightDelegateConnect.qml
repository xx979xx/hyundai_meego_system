import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenDelegateConnect
    width: 537
    height:89
    Component.onCompleted:{

        if(index == 0){
            //idRightMenDelegateConnect.firstText="iBox" ;

            idRightMenDelegateConnect.secondText =resVersionInfo.iBoxConnectInfo;
        }
        else if(index == 1){
            // idRightMenDelegate.firstText="Kernel" ;
            idRightMenDelegateConnect.secondText =canDB.AMP_HWConnectInfo;
        }
        else if(index == 2){
            //idRightMenDelegate.firstText="Build Date" ;
            if(canDB.CCP_HwMajor_Ver != null){
                  idRightMenDelegateConnect.secondText =canDB.CCP_ConnectInfo;
//                idRightMenDelegateConnect.secondText =qsTr(canDB.CCP_HwMajor_Ver+"."+canDB.CCP_HwMinor_Ver);
            }else {
                idRightMenDelegateConnect.secondText ="Not.Received";
            }

        }
        else if(index == 3){

            if(canDB.RRC_HwMajor_Ver != null){
                //    idRightMenDelegateConnect.secondText =qsTr(canDB.RRC_HwMajor_Ver+"."+canDB.RRC_HwMinor_Ver);
                idRightMenDelegateConnect.secondText =canDB.RRC_ConnectInfo;
            }else {
                idRightMenDelegateConnect.secondText ="Not.Received";
            }
//                //idRightMenDelegate.firstText="Build Date" ;
//                            if(canDB.CCP_HwMajor_Ver != null){
//                idRightMenDelegateConnect.secondText =qsTr(canDB.RRC_HwMajor_Ver+"."+canDB.RRC_HwMinor_Ver);
//            }else {
//                idRightMenDelegateConnect.secondText ="Not.Received";
//            }
        }
        else if(index == 4){
            //idRightMenDelegate.firstText=""" + sw.FrontMonitorConnectInfo" ;
            idRightMenDelegateConnect.secondText ="" + sw.FrontMonitorConnectInfo;
        }
        else if(index == 5){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateConnect.secondText =sw.RearMonitorConnectInfo;
        }
        else if(index == 6){
            //** need active Antenna
            idRightMenDelegateConnect.secondText =""+resVersionInfo.Radio_Antenna;
        }
        else if(index == 7){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateConnect.secondText =""+resVersionInfo.DMB_Antenna;
        }
        else if(index == 8){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateConnect.secondText =""+resVersionInfo.GPS_Antenna;
        }
        else if(index == 9){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
             idRightMenDelegateConnect.secondText =resVersionInfo.iBoxModemConnectInfo;
        }
        else if(index == 10){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;

            if (resVersionInfo.XM_Antenna != null){
                idRightMenDelegateConnect.secondText =""+resVersionInfo.XM_Antenna;
            }else {
                idRightMenDelegateConnect.secondText ="Not.Received";
            }




        }
        else if(index == 11){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
            idRightMenDelegateConnect.secondText =Connect.USBStatus;

        }
        else if(index == 12){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
            idRightMenDelegateConnect.secondText =Connect.iPodStatus;
        }
        else if(index == 13){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
            idRightMenDelegateConnect.secondText =Connect.USB2Status;

        }
        else if(index == 14){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
            idRightMenDelegateConnect.secondText =Connect.iPod2Status;
        }
        else if(index == 15){
            //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
            idRightMenDelegateConnect.secondText =Connect.AuxStatus;
        }


        //           else if(index == 3){
        //           //idRightMenDelegate.firstText="Micom" ;
        //           idRightMenDelegate.secondText ="" + sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2;
        //           }
        //            ListElement {   name:"Kernel" ; subname:""/*SystemInfo.GetKernelVersion()*/; check:"off";gridId:1  }
        //            ListElement {   name:"Build Date" ; subname:""/*SystemInfo.GetBuildDate()*/; check:"off"; gridId:2  }
        //            ListElement {   name:"Micom" ; subname:"" /*+ sw.MICOM_0 +"." + sw.MICOM_1 + "." + sw.MICOM_2*/; check:"off" ; gridId:3 }


    }

    onClickOrKeySelected: {
        idRightMenDelegateConnect.ListView.view.currentIndex = index
        idRightMenDelegateConnect.forceActiveFocus()
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
    secondTextY:30/*43*/
    secondTextWidth: 403
    secondTextHeight: secondTextSize//+10
    secondTextColor: colorInfo.bandBlue

    bgImage: ""
    fgImage: ""
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    //bgImageFocusPress: imgFolerGeneral+ "bg"


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
    //            visible:showFocus && idRightMenDelegateConnect.activeFocus
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
    //            x: 300
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


    KeyNavigation.up:{
        if(index == 0){
            backFocus.forceActiveFocus()
            hardwareBand
        }
    }

    //    MouseArea{
    //        anchors.fill:parent
    //    }
    Connections{
        target:CanDataConnect

        onCan_connect_changed:{

            if(index == 0){
                //  console.log("Radio Region Value Changed : " + systemData)
                //  idRightMenDelegateConnect.secondText =iboxConnect;
                idRightMenDelegateConnect.secondText =resVersionInfo.iBoxConnectInfo;

            }
            else if(index == 1){
                // idRightMenDelegate.firstText="Kernel" ;

                idRightMenDelegateConnect.secondText =canDB.AMP_HWConnectInfo;
            }
            else if(index == 2){
                    //idRightMenDelegate.firstText="Build Date" ;
                  idRightMenDelegateConnect.secondText =""+canDB.CCP_ConnectInfo;
                    //idRightMenDelegateConnect.secondText =""+canDB.CCP_HwMajor_Ver+"."+canDB.CCP_HwMinor_Ver;
            }
            else if(index == 3){
                //idRightMenDelegate.firstText="Build Date" ;
                 idRightMenDelegateConnect.secondText =qsTr(canDB.RRC_ConnectInfo);
                //idRightMenDelegateConnect.secondText =qsTr(canDB.RRC_HwMajor_Ver+"."+canDB.RRC_HwMinor_Ver);
            }
        }
    }
    Connections{
        target:UIListener
        onConnect_data_eng:{
            if(index == 11){
                //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
                idRightMenDelegateConnect.secondText =Connect.USBStatus;

            }
            else if(index == 12){
                //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
                idRightMenDelegateConnect.secondText =Connect.iPodStatus;
            }
            if(index == 13){
                //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
                idRightMenDelegateConnect.secondText =Connect.USB2Status;

            }
            else if(index == 14){
                //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
                idRightMenDelegateConnect.secondText =Connect.iPod2Status;
            }
            else if(index == 15){
                //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
                idRightMenDelegateConnect.secondText =Connect.AuxStatus;
            }

        }


    }

    Connections{
        target: reqVersion
        onConnect_changed:{
            if(index == 8){
                //idRightMenDelegate.firstText="Build Date" ;
                idRightMenDelegateConnect.secondText =""+resVersionInfo.GPS_Antenna;
            }
        }
    }

    //    Connections{
    //        target: reqVersion
    //        onModemInfoChanged:{

    //    if(index == 9){
    //               //idRightMenDelegate.firstText="""+iBoxCon.iBoxInfo" ;
    //               idRightMenDelegateConnect.secondText =""+iBoxCon.iBoxInfo;
    //           }
    //        }
    //    }

    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

