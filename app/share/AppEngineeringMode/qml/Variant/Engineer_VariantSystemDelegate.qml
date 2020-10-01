import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MButton {
    id: idRightVariantSystemDelegate
    width: 537
    height:89

    property int navigationValue: variant.navigation
    property int iBoxValue: variant.ibox
    property int mostAMPValue: variant.MOST
    property int rearMonitorValue: variant.RearMonitor
    property int radioRegion0Value: variant.RadioRegion0
    property int radioRegion1Value: variant.RadioRegion1
    property int radioRegion2Value: variant.RadioRegion2
    //property int mobileTvValue: variant.MobileTv
    property int rhdValue: variant.RHD
    property int limoValue: variant.Limo
    property int lexiconValue: variant.Lexicon
    property int parkingAssist0Value: variant.ParkingAssist0
    property int parkingAssist1Value: variant.ParkingAssist1
    property int advancedClusterValue: variant.AdvancedCluster
    property int hudValue: variant.hud;
    //property int ecsValue: variant.ECS
    property int rearUSBValue: variant.RearUSB
    property int cdcValue: variant.CDC
    //property int wd4Value: variant.WD4
    property int rrcValue: variant.RRC
    property int rearMICValue: variant.rearMIC



    Component.onCompleted:{

            //Navigation
           if(index == 0){
                console.log("Received Variant Navigation Value : " +navigationValue)
               if(navigationValue == 0){

                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (navigationValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//iBox
           else if(index == 1){
               console.log("Received Variant Value: iBOX : " +iBoxValue)
               if(iBoxValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (iBoxValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//MOST AMP
          else if(index == 2){
               console.log("Received Variant Value: MOST AMP : " +mostAMPValue)
               if(mostAMPValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (mostAMPValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//Rear Monitor
           else if(index == 3){
               console.log("Received Variant Value: Rear Monitor : " +rearMonitorValue)
               if(rearMonitorValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (rearMonitorValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           } //Radio Region Code 0
           else if(index == 4){
               console.log("Received Variant Value: Radio Region Code0 : " +radioRegion0Value)
               if(radioRegion0Value == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (radioRegion0Value == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//Radio Region Code 1
           else if(index == 5){
               console.log("Received Variant Value: Radio Region Code1 : " +radioRegion1Value)
               if(radioRegion1Value == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (radioRegion1Value == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }//Radio Region Code2
           else if(index == 6){
               console.log("Received Variant Value: Radio Region Code2 : " +radioRegion2Value)
               if(radioRegion2Value == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (radioRegion2Value == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }//Radio Region Value
           else if(index == 7){
               idRightVariantSystemDelegate.secondText = ""+variant.RadioRegion;


           }//Mobile TV
            /*   else if(index == 8){
               console.log("Received Variant Value: Mobile TV : " +mobileTvValue)
               if(mobileTvValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (mobileTvValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }*///RHD
           else if(index == 8){
               console.log("Received Variant Value: RHD : " +rhdValue)
               if(rhdValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (rhdValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }//Limo
           else if(index == 9){
               console.log("Received Variant Value: Limo : " +limoValue)
               if(limoValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (limoValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }
           else if(index == 10){
               console.log("Received Variant Value: Lexicon : " +lexiconValue)
               if(lexiconValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (lexiconValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }


           //Parking Assist 0
           else if(index == 11){
               console.log("Received Variant Value: Parking Assist0 : " +parkingAssist0Value)
               if(parkingAssist0Value == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (parkingAssist0Value == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }//Parking Assist 1
           else if(index == 12){
               console.log("Received Variant Value: Parking Assist1 : " +parkingAssist1Value)
               if(parkingAssist1Value == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (parkingAssist1Value == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//Parking Assist Value
           else if(index == 13){

                idRightVariantSystemDelegate.secondText = variant.parkingAssist

           }//Advanced Cluster
           else if(index == 14){
               console.log("Received Variant Value: Advanced Cluster : " +advancedClusterValue)
               if(advancedClusterValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (advancedClusterValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }


           }//HUD
           else if(index == 15){
               console.log("Received Variant Value: HUD : " +hudValue)
               if(hudValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (hudValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//Rear USB
           else if(index == 16){
               console.log("Received Variant Value: Rear USB : " +rearUSBValue)
               if(rearUSBValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (rearUSBValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           } // Rear RRC
           else if(index == 17){
               console.log("Received Variant Value: Rear RRC : " +rrcValue)
               if(rrcValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (rrcValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }
           }

           //Rear MIC
           else if(index == 18){
               console.log("Received Variant Value: Rear MIC : " +rearMICValue)
               if(rearMICValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (rearMICValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }
           //CDC
           else if(index == 19){
               console.log("Received Variant Value: CDC : " + cdcValue)
               if(cdcValue == 0){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
               }
               else if (cdcValue == 1){
                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
               }

           }//4WD
            //           else if(index == 18){
            //               console.log("Received Variant Value: 4WD : " + wd4Value)
            //               if(wd4Value == 0){
            //                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            //               }
            //               else if (wd4Value == 1){
            //                   idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            //               }

            //           }

    }


    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    firstText: name

    firstTextSize: 23
    firstTextX: 20
    firstTextY: 43
    firstTextWidth: 230

    secondText: ""
    secondTextSize: 18
    secondTextX: 370
    secondTextY:43
    secondTextWidth: 403
    secondTextHeight: secondTextSize//+10

    bgImage: ""
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    //bgImageFocusPress: imgFolerGeneral+ "bg"

    fgImage: ""
    fgImageActive: ""
    fgImageX: 370
    fgImageY: 20
    fgImageWidth:45
    fgImageHeight:45

//    property string firstText: name

//    property int firstTextSize: 0
//    property int firstTextX: 20
//    property int firstTextY: 43
//    property int firstTextWidth: 230

//    property string secondText: ""
//    property int secondTextSize: 18
//    property int secondTextX: 370
//    property int secondTextY:43
//    property int secondTextWidth: 403
//    property int secondTextHeight: secondTextSize//+10

//    property string bgImage: ""
//    property string bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
//    property string bgImageFocusPress: imgFolerGeneral+ "bg"

//    property string fgImage: ""
//    property string fgImageActive: ""
//    property int fgImageX: 370
//    property int fgImageY: 20
//    property int fgImageWidth:45
//    property int fgImageHeight:45


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
//            visible:showFocus && idRightVariantSystemDelegate.activeFocus
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

//        //****************************** # Channel (SecondText) #
//        //Second Text
//        Text{
//            id: idsecondText
//            text: secondText
//            x: secondTextX
//            y: 30
//            width: 403
//            font.pixelSize: 18
//            font.family: UIListener.getFont(false)//"HDR"
//            verticalAlignment: Text.AlignVCenter
//            horizontalAlignment: Text.AlignVCenter
//            color: colorInfo.bandBlue

//        } // End Text

//        //Image inside Button // by WSH
//        Image {
//            id: imgFgImage
//            x: fgImageX
//            y: fgImageY
//            width: fgImageWidth
//            height: fgImageHeight
//            source: fgImage
//            visible: true
//        }

//    }

//    states: [
//        State {
//            name: 'pressed'; when: isMousePressed()
//            PropertyChanges {target: backGround; source: bgImagePress;}
//            PropertyChanges {target: imgFgImage; source: fgImagePress;}
//            PropertyChanges {target: txtFirstText; textColor: firstTextPressColor;}
//            PropertyChanges {target: txtSecondText; textColor: secondTextPressColor;}
////            PropertyChanges {target: txtThirdText; textColor: thirdTextPressColor;}
////            PropertyChanges {target: txtForthText; textColor: forthTextPressColor;}
//        },
//        State {
//            name: 'active'; when: container.active
//            PropertyChanges {target: backGround; source: bgImageActive;}
//            PropertyChanges {target: imgFgImage; source: fgImageActive;}
//            PropertyChanges {target: txtFirstText; textColor: firstTextSelectedColor;}
//            PropertyChanges {target: txtSecondText; textColor: secondTextSelectedColor;}
////            PropertyChanges {target: txtThirdText; textColor: thirdTextSelectedColor;}
////            PropertyChanges {target: txtForthText; textColor: forthTextSelectedColor;}
//        },
//        State {
//            name: 'keyPress'; when: container.state=="keyPress" // problem Kang
//            PropertyChanges {target: backGround; source: bgImageFocusPress;}
//            PropertyChanges {target: bgImageFocus; source: bgImageFocusPress;}
//            PropertyChanges {target: txtFirstText; textColor: firstTextFocusPressColor;}
//            PropertyChanges {target: txtSecondText; textColor: secondTextFocusPressColor;}
////            PropertyChanges {target: txtThirdText; textColor: thirdTextFocusPressColor;}
////            PropertyChanges {target: txtForthText; textColor: forthTextFocusPressColor;}
//        },
//        State {
//            name: 'keyReless';
//            PropertyChanges {target: backGround; source: bgImage;}
//            PropertyChanges {target: bgImageFocus; source: fgImage;}
//            PropertyChanges {target: txtFirstText; textColor: focusImageVisible? firstTextFocusColor : firstTextColor;}
//            PropertyChanges {target: txtSecondText; textColor: focusImageVisible? secondTextFocusColor : secondTextPressColor;}
////            PropertyChanges {target: txtThirdText; textColor: focusImageVisible? thirdTextFocusColor : thirdTextPressColor;}
////             PropertyChanges {target: txtForthText; textColor: focusImageVisible? forthTextFocusColor : forthTextPressColor;}
//        },
//        State {
//            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
//            PropertyChanges {target: backGround; source: bgImage;}
//            PropertyChanges {target: imgFgImage; source: fgImage;}
//            PropertyChanges {target: txtFirstText; textColor: firstTextEnabled? firstTextColor : firstTextDisableColor;}
//            PropertyChanges {target: txtSecondText; textColor: secondTextEnabled? secondTextColor : secondTextDisableColor;}
////            PropertyChanges {target: txtThirdText; textColor: thirdTextEnabled? thirdTextColor : thirdTextDisableColor;}
////            PropertyChanges {target: txtForthText; textColor: thirdTextEnabled? forthTextColor : forthTextDisableColor;}
//        }
//    ]


    KeyNavigation.up:{
        if(index == 0){
            backFocus.forceActiveFocus()
            variantBand
        }
    }

    onClickOrKeySelected: {
        //selectedItem = index
        //setRightMenuScreen(index, true)
        console.log("Enter Variant System ICON")

        if(index == 0){
            //case False -> True
            if(navigationValue == 0){
                navigationValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_NAVIGATION )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (navigationValue == 1){
                navigationValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_NAVIGATION )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 1){

            //case False -> True
            if(iBoxValue == 0){
                iBoxValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_IBOX )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (navigationValue == 1){
                iBoxValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_IBOX )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }

        }
         if( index == 2){
            //case False -> True
            if(mostAMPValue == 0){
                mostAMPValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_MOST )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (mostAMPValue == 1){
                mostAMPValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_MOST )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 3){
            //case False -> True
            if(rearMonitorValue == 0){
                rearMonitorValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_REAR_MONITOR )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (rearMonitorValue == 1){
                rearMonitorValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_REAR_MONITOR )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 4){
            //case False -> True
            if(radioRegion0Value == 0){
                radioRegion0Value = 1
                console.log("Send Radio Region Value : " + radioRegion0Value + "." + radioRegion1Value + "." + radioRegion2Value)
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_RADIO_REGION0 )
                VariantSetting.changeRadioRegionVal(radioRegion0Value,  radioRegion1Value,  radioRegion2Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else/*else if (radioRegion0Value == 1)*/{
                radioRegion0Value=0
                 console.log("Send Radio Region Value : " + radioRegion0Value + "." + radioRegion1Value + "." + radioRegion2Value)
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_RADIO_REGION0 )
                 VariantSetting.changeRadioRegionVal(radioRegion0Value,  radioRegion1Value,  radioRegion2Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 5){
            //case False -> True
            if(radioRegion1Value == 0){
                radioRegion1Value = 1
                 console.log("Send Radio Region Value : " + radioRegion0Value + "." + radioRegion1Value + "." + radioRegion2Value)
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_RADIO_REGION1 )
                 VariantSetting.changeRadioRegionVal(radioRegion0Value,  radioRegion1Value,  radioRegion2Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else /*if (radioRegion1Value == 1)*/{
                radioRegion1Value=0
                 console.log("Send Radio Region Value : " + radioRegion0Value + "." + radioRegion1Value + "." + radioRegion2Value)
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_RADIO_REGION1 )
                 VariantSetting.changeRadioRegionVal(radioRegion0Value,  radioRegion1Value,  radioRegion2Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
       if(index == 6){
            //case False -> True
            if(radioRegion2Value == 0){
                radioRegion2Value = 1
                 console.log("Send Radio Region Value : " + radioRegion0Value + "." + radioRegion1Value + "." + radioRegion2Value)
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_RADIO_REGION2 )
                 VariantSetting.changeRadioRegionVal(radioRegion0Value,  radioRegion1Value,  radioRegion2Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else /*if (radioRegion2Value == 1)*/{
                radioRegion2Value=0
                 console.log("Send Radio Region Value : " + radioRegion0Value + "." + radioRegion1Value + "." + radioRegion2Value)
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_RADIO_REGION2 )
                 VariantSetting.changeRadioRegionVal(radioRegion0Value,  radioRegion1Value,  radioRegion2Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
        //         if(index == 8){
        //            //case False -> True
        //            if(mobileTvValue == 0){
        //                mobileTvValue = 1
        //                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_MOBILE_TV )
        //                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
        //            }
        //            //case True->False
        //            else if (mobileTvValue == 1){
        //                mobileTvValue=0
        //                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_MOBILE_TV )
        //                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
        //            }
        //        }
         if(index == 8){
            //case False -> True
            if(rhdValue == 0){
                rhdValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_RHD )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (rhdValue == 1){
                rhdValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_RHD )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index ==9){
            //case False -> True
            if(limoValue == 0){
                limoValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_LIMO )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (limoValue == 1){
                limoValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_LIMO )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index ==10){
            //case False -> True
            if(lexiconValue == 0){
                lexiconValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_LEXICON )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (lexiconValue == 1){
                lexiconValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_LEXICON )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 11){
            //case False -> True
            if(parkingAssist0Value == 0){
                parkingAssist0Value = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_PARKING_ASSIST0 )
                VariantSetting.changeParkingAssistVal(parkingAssist0Value,  parkingAssist1Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else /*if (parkingAssist0Value == 1)*/{
                parkingAssist0Value=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_PARKING_ASSIST0 )
                VariantSetting.changeParkingAssistVal(parkingAssist0Value,  parkingAssist1Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 12){
            //case False -> True
            if(parkingAssist1Value == 0){
                parkingAssist1Value = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_PARKING_ASSIST1 )
                VariantSetting.changeParkingAssistVal(parkingAssist0Value,  parkingAssist1Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else /*if (parkingAssist1Value == 1)*/{
                parkingAssist1Value=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_PARKING_ASSIST1 )
                VariantSetting.changeParkingAssistVal(parkingAssist0Value,  parkingAssist1Value)
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
       if(index == 14){
            //case False -> True
            if(advancedClusterValue == 0){
                advancedClusterValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_ADVANCED_CLUSTER )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (advancedClusterValue == 1){
                advancedClusterValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_ADVANCED_CLUSTER )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index ==  15){
            //case False -> True
            if(hudValue == 0){
                hudValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_HUD )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (hudValue == 1){
                hudValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_HUD )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 16){
            //case False -> True
            if(rearUSBValue == 0){
                rearUSBValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_REAR_USB )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (rearUSBValue == 1){
                rearUSBValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_REAR_USB )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }//Rear RRC
         if(index == 17){
            //case False -> True
            if(rrcValue == 0){
                rrcValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_RRC )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (rrcValue == 1){
                rrcValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_RRC )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 18){
            //case False -> True
            if(rearMICValue == 0){
                rearMICValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_REAR_MIC )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (rearMICValue == 1){
                rearMICValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_REAR_MIC )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
         if(index == 19){
            //case False -> True
            if(cdcValue == 0){
                cdcValue = 1
                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_CDC )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
            }
            //case True->False
            else if (cdcValue == 1){
                cdcValue=0
                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_CDC )
                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
            }
        }
        //         if(index == 18){
        //            //case False -> True
        //            if(wd4Value == 0){
        //                wd4Value = 1
        //                VariantSetting.SaveVariant_Data( 1, EngineerData.DB_4WD )
        //                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
        //            }
        //            //case True->False
        //            else if (wd4Value == 1){
        //                wd4Value=0
        //                VariantSetting.SaveVariant_Data( 0, EngineerData.DB_4WD )
        //                idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
        //            }
        //        }

        //        //setRightMenuScreen(2, true)
        //       // setAppMain(selectedItem+2,false)
        idRightVariantSystemDelegate.ListView.view.currentIndex=index
        idRightVariantSystemDelegate.forceActiveFocus()
        //console.log("checkBoxActive : "+index)
        ////upDate()
    }
    Connections{
            target:VariantSetting
            onRefreshVariantData:{
                //Navigation
               if(index == 0){
                    console.log("Received Variant Navigation Value : " +navigationValue)
                   if(navigationValue == 0){

                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (navigationValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//iBox
               else if(index == 1){
                   console.log("Received Variant Value: iBOX : " +iBoxValue)
                   if(iBoxValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (iBoxValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//MOST AMP
              else if(index == 2){
                   console.log("Received Variant Value: MOST AMP : " +mostAMPValue)
                   if(mostAMPValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (mostAMPValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//Rear Monitor
               else if(index == 3){
                   console.log("Received Variant Value: Rear Monitor : " +rearMonitorValue)
                   if(rearMonitorValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (rearMonitorValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               } //Radio Region Code 0
               else if(index == 4){
                   console.log("Received Variant Value: Radio Region Code0 : " +radioRegion0Value)
                   if(radioRegion0Value == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (radioRegion0Value == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//Radio Region Code 1
               else if(index == 5){
                   console.log("Received Variant Value: Radio Region Code1 : " +radioRegion1Value)
                   if(radioRegion1Value == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (radioRegion1Value == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }//Radio Region Code2
               else if(index == 6){
                   console.log("Received Variant Value: Radio Region Code2 : " +radioRegion2Value)
                   if(radioRegion2Value == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (radioRegion2Value == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }//Radio Region Value
               else if(index == 7){
                   idRightVariantSystemDelegate.secondText = ""+variant.RadioRegion;


               }//Mobile TV
    /*           else if(index == 8){
                   console.log("Received Variant Value: Mobile TV : " +mobileTvValue)
                   if(mobileTvValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (mobileTvValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }*///RHD
               else if(index == 8){
                   console.log("Received Variant Value: RHD : " +rhdValue)
                   if(rhdValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (rhdValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }//Limo
               else if(index == 9){
                   console.log("Received Variant Value: Limo : " +limoValue)
                   if(limoValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (limoValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }
               else if(index == 10){
                   console.log("Received Variant Value: Lexicon : " +lexiconValue)
                   if(lexiconValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (lexiconValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }


               //Parking Assist 0
               else if(index == 11){
                   console.log("Received Variant Value: Parking Assist0 : " +parkingAssist0Value)
                   if(parkingAssist0Value == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (parkingAssist0Value == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }//Parking Assist 1
               else if(index == 12){
                   console.log("Received Variant Value: Parking Assist1 : " +parkingAssist1Value)
                   if(parkingAssist1Value == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (parkingAssist1Value == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//Parking Assist Value
               else if(index == 13){

                    idRightVariantSystemDelegate.secondText = variant.parkingAssist

               }//Advanced Cluster
               else if(index == 14){
                   console.log("Received Variant Value: Advanced Cluster : " +advancedClusterValue)
                   if(advancedClusterValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (advancedClusterValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }


               }//HUD
               else if(index == 15){
                   console.log("Received Variant Value: HUD : " +hudValue)
                   if(hudValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (hudValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//USB
               else if(index == 16){
                   console.log("Received Variant Value: Rear USB : " +rearUSBValue)
                   if(rearUSBValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (rearUSBValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }// Rear RRC
               else if(index == 17){
                   console.log("Received Variant Value: Rear RRCB : " +rrcValue)
                   if(rrcValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (rrcValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }
               //Rear MIC
               else if(index == 18){
                   console.log("Received Variant Value: Rear MIC : " +rearMICValue)
                   if(rearMICValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (rearMICValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }
               else if(index == 19){
                   console.log("Received Variant Value: CDC : " + cdcValue)
                   if(cdcValue == 0){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                   }
                   else if (cdcValue == 1){
                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                   }

               }//4WD
                //               else if(index == 18){
                //                   console.log("Received Variant Value: 4WD : " + wd4Value)
                //                   if(wd4Value == 0){
                //                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_uncheck.png"
                //                   }
                //                   else if (wd4Value == 1){
                //                       idRightVariantSystemDelegate.fgImage = imgFolderGeneral + "checkbox_check.png"
                //                   }

                //               }

                //                VariantSetting.changeParkingAssistVal(parkingAssist0Value,  parkingAssist1Value)

            }

            onVariantSystemChanged:{
                if(systemFlag == EngineerData.RadioRegionValue){
                        if(index == 7){
                            console.log("Radio Region Value Changed : " + systemData)
                           idRightVariantSystemDelegate.secondText = variant.RadioRegion;
                    }
                 }
                if(systemFlag == EngineerData.ParkingAssistValue){
                    if(index == 13){
                        console.log("Parking Assist Value Changed : " + systemData)
                        idRightVariantSystemDelegate.secondText = variant.parkingAssist
                    }
                }
        }
    }



    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

