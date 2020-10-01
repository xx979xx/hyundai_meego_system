import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButton {
    id: idRightMenDelegateDeck
    width: 537
    height:89
    Component.onCompleted:{

           if(index == 0){
           //idRightMenDelegate.firstText="System SW" ;
           idRightMenDelegateDeck.secondText =""+deckInfo.FwVersion;
           }
           else if(index == 1){
          // idRightMenDelegate.firstText="Kernel" ;
           idRightMenDelegateDeck.secondText =""+deckInfo.LifeTime;
           }
          else if(index == 2){
           //idRightMenDelegate.firstText="Build Date" ;
           idRightMenDelegateDeck.secondText =""+deckInfo.Temperature;
           }
           else if(index == 3){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.EjectStatus;
            }
           else if(index == 4){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.InsertStatus;
            }
           else if(index == 5){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.RandomStatus;
            }
           else if(index == 6){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.RepeatStatus;
            }
           else if(index == 7){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.ScanStatus;
            }
           else if(index == 8){
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.MechError;
            }
           else if(index == 9){//Rear Error
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.ReadError;
            }

    }
    onClickOrKeySelected: {
        idRightMenDelegateDeck.ListView.view.currentIndex = index
        idRightMenDelegateDeck.forceActiveFocus()
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
    //            visible:showFocus && idRightMenDelegateDeck.activeFocus
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
        target:SendDeckSignal
        onChangedDeckInfo:{
            //qDebug()<<"Received changedDeckInfo SIGNAL";
            if(index == 0){//Fw Version

            idRightMenDelegateDeck.secondText =""+deckInfo.FwVersion;
            }
            else if(index == 1){//Life Time

            idRightMenDelegateDeck.secondText =""+deckInfo.LifeTime;
            }
            else if(index == 2){//Temperature
            //idRightMenDelegate.firstText="Build Date" ;
            idRightMenDelegateDeck.secondText =""+deckInfo.Temperature;
            }
            else if(index == 3){//Eject Status
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.EjectStatus;
            }
            else if(index == 4){//Insert Status
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.InsertStatus;
            }
            else if(index == 5){//Random Status
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.RandomStatus;
            }
            else if(index == 6){//Repeat Status
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.RepeatStatus;
            }
            else if(index == 7){//Scan Status
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.ScanStatus;
            }
            else if(index == 8){//Mech Error
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.MechError;
            }
            else if(index == 9){//Rear Error
             //idRightMenDelegate.firstText="Build Date" ;
             idRightMenDelegateDeck.secondText =""+deckInfo.ReadError;
            }
        }
    }



    Image{
        x:43-23
        y:89
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope

