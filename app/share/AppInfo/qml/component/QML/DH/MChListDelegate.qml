/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-02-02
 *
 * - 2012-02-02 Initial Crated by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent {
    id: idMChListDelegate
    x: 0; y: 0
    width: 521; height: 89

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    property int selectIndex: selectedItem
    property string selectedApp: "DMB"    // Application selected ("DMB" | "Radio" .. )

    property string bgImage: ""
    property string bgImagePress: imgFolderGeneral+"bg_ch_list_p.png"
    property string bgImageActive: imgFolderGeneral+"bg_ch_list_s.png"
    property string bgImageFocusPress: imgFolderGeneral+"bg_ch_list_fp.png"
    property string bgImageFocus: imgFolderGeneral+"bg_ch_list_f.png"

    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextSelectedColor: (selectedApp == "DMB")? colorInfo.buttonGrey : colorInfo.black; //selectedApp == "Radio"

    property string secondTextColor: (selectedApp == "DMB")? colorInfo.brightGrey : colorInfo.subTextGrey; //selectedApp == "Radio"
    property string secondTextPressColor:  colorInfo.brightGrey;
    property string secondTextFocusPressColor:  colorInfo.brightGrey;
    property string secondTextSelectedColor: colorInfo.black;

    property string thirdTextColor: colorInfo.subTextGrey
    property string thirdTextPressColor: colorInfo.brightGrey;
    property string thirdTextFocusPressColor: colorInfo.brightGrey;
    property string thirdTextSelectedColor: colorInfo.black;

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""
    property string mChIconHdText: ""

    property bool menuHdRadioFlag: false

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 44-7; y: 2
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 44-7; y: 2
        source: bgImageFocus;
        visible: showFocus && idMChListDelegate.activeFocus
    }
    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText  //index+1
        x: 44+10; y: 89-42-32/2
        width: 58; height: 32
        font.pixelSize: 32
        font.family: "HDBa1"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
    }

    //****************************** # Channel (SecondText) #
    Text{
        id: secondText
        text: mChListSecondText
        x: (selectedApp == "DMB")? 44+10+58+30 : 44+10+58+8;
        y: 89-42-32/2
        width: (selectedApp == "DMB")? 300 : 91
        height: 32
        font.pixelSize: 32
        font.family: "HDBa1"
        horizontalAlignment: (selectedApp == "DMB")? Text.AlignLeft : Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: secondTextColor
    }

    //****************************** # StationName (ThirdText) #
    Text{
        id: thirdText
        text: mChListThirdText
        x: 44+10+58+8+91+27; y: 89-42-32/2
        width: 204; height: 32
        font.pixelSize: 32
        font.family: "HDBa1"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: thirdTextColor
        elide: Text.ElideRight
        visible: (selectedApp == "Radio" || "HdRadio")
    }


    //****************************** # HD Radio yellow icon image #
    Image{
        x: 44+10+58+8+91+27+168; y: 89-78
        source: imgFolderRadio_Hd+"ico_hd.png"
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text!=""
    }
    Text{
        id: iconHdText
        text: mChIconHdText
        x: 44+10+58+8+91+27+168; y: 89-78+12-20/2
        width: 44; height: 20
        font.pixelSize: 20
        font.family: "HDR"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.black
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text!=""
    }

    //****************************** # Line Image #
    Image{
        x: 44; y: 89
        source: imgFolderGeneral+"line_ch.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: idMChListDelegate.state="keyPress"
    onSelectKeyReleased: {
        if(index == selectIndex) idMChListDelegate.state="selected"
        else idMChListDelegate.state="keyRelease"
    }
    onClickOrKeySelected: {
        selectedItem = index
        idMChListDelegate.ListView.view.currentIndex = index
        idMChListDelegate.ListView.view.focus = true
        idMChListDelegate.ListView.view.forceActiveFocus()
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: firstTextPressColor;}
            PropertyChanges {target: secondText; color: secondTextPressColor;}
            PropertyChanges {target: thirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'selected'; when: index == selectIndex
            PropertyChanges {target: normalImage; source: bgImageActive;}
            PropertyChanges {target: firstText; color: firstTextSelectedColor;}
            PropertyChanges {target: secondText; color: secondTextSelectedColor;}
            PropertyChanges {target: thirdText; color: thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: secondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: thirdText; color: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: secondText; color: secondTextColor;}
            PropertyChanges {target: thirdText; color: thirdTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event)){
            if( idMChListDelegate.ListView.view.currentIndex ){
                idMChListDelegate.ListView.view.decrementCurrentIndex();
            }
            else{
                idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, idMChListDelegate.ListView.view.Visible);
                idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
            }
        }
        else if(idAppMain.isWheelRight(event)) {
            if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex ){
                idMChListDelegate.ListView.view.incrementCurrentIndex();
            }
            else{
                idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                idMChListDelegate.ListView.view.currentIndex = 0;
            }
        }
    }
}
