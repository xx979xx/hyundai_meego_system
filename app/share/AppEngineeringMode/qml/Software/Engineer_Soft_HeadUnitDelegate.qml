import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MButton{
    id:idHeadUnitDelegate
    width: 537
    height:88

    property int countryInfo: VariantSetting.GetCountryInfo();
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }

    Component.onCompleted:{
        if(countryInfo == 1)
        {
            if(index == 9 )
            {
                idHeadUnitDelegate.secondTextSize = 16
            }
        }

    }


    onClickOrKeySelected: {
        idHeadUnitDelegate.ListView.view.currentIndex=index
        idHeadUnitDelegate.forceActiveFocus()
    }
    Connections{
        target: reqVersion
        onResDmbVersionInfo:{
                //            if(index == 8){
                //                idHeadUnitDelegate.secondText = ""+resVersionInfo.dmbVer;
                //            }
        }
    }
    Connections{
        target: SendDeckSignal
        onChangedDeckInfo:{
                //            if(index == 5){
                //                idHeadUnitDelegate.secondText = ""+deckInfo.FwVersion;
                //            }
        }
    }

    Connections{
        target: VariantSetting
        onGpsVerReceived:{
                //            if(index == 12){
                //                     idHeadUnitDelegate.secondText = VariantSetting.GetGpsVersion();
                //            }
        }

    }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    firstText: moduleName

    firstTextSize: 25
    firstTextX: 20
    firstTextY: 30/*43*/
    firstTextWidth: 230

    secondText: VersionInfo
    secondTextSize: 20
    secondTextX: 250
    secondTextY:30//43
    secondTextWidth: 403
    secondTextHeight: secondTextSize//+10
    secondTextColor: colorInfo.bandBlue

    bgImage: ""
    fgImage: ""
    bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"
    //bgImageFocusPress: imgFolderGeneral+ "bg"

    //    property string imgFolderGeneral: imageInfo.imgFolderGeneral
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
    //    property string bgImageFocusPress: imgFolderGeneral+ "bg"


    //****************************** # Line Image #
    Image{
        x: 20; y: 89
        source: imgFolderGeneral+"line_menu_list.png"
    }



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
    ////            x: 30//44-7
    //            x:0
    //            y: -1
    //            source: bgImageFocus;
    //            visible:showFocus && idHeadUnitDelegate.activeFocus
    //        } // End BorderImage

    //        //****************************** # Index (FirstText) #
    //        Text{
    //            id: idfirstText
    //            text: moduleName/*firstText*/
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
    //            text: VersionInfo/*secondText*/
    //            x: 250
    //            y: 30
    //            width: 403
    //            font.pixelSize: secondTextSize/*20*/
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

}