/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-05
 *
 * - 2012-05 Initial Created by HYANG
 * - 2012-07-25 added presetList bigSize
 * - 2012-08-22 added TextScroll
 * - 2012-09-19 change text color
 * - 2012-11-20 GUI modify(selected image delete) Save, edit icon add
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent { //MButtonOnlyRadio
    id: idMChListDelegate
    x: selectedApp=="HdRadio"? 43-29 : 43-33;
    y: 2
    width: selectedApp=="HdRadio"? 462 : 557
    height: 89


    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb : imageInfo.imgFolderDmb

    property string selectedApp: "DMB"    // Application selected ("DMB" | "HdRadio" .. )

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""
    property string mChIconHdText: ""
    property bool menuHdRadioFlag: false
    property bool onlyPresetName: false
    property bool presetSave: false
    property bool presetOrderHandler: false
    property bool presetOrderArrow: false
    property string presetSaveText: ""
    signal presetSaveClickOrKeySelected();
    signal presetOrderHandlerClickOrKeySelected();

    property bool isDragItem: false
    property bool isJogItem: false
    property bool isMoveUpScroll: true
    property int  lastMousePositionY: 0
    signal changeRow(int fromIndex, int toIndex);


    ////////////////////////////////////////////////////////////////////////////////////

    property bool active: (buttonName == selectedItem)
    property string buttonName: index
    property bool buttonEnabled: true  //# button enabled/disabled on/off - by HYANG (130128)
    mEnabled: buttonEnabled

    property int buttonWidth
    property int buttonHeight
    property string bgImage: ""
    property string bgImagePress     : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_p.png" : imgFolderRadio+"preset_p.png"
    property string bgImageActive       : ""
    property string bgImageFocus        : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_f.png" : imgFolderRadio+"preset_f.png"
    property string bgImageFocusPress   : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_p.png" : imgFolderRadio+"preset_p.png" // JSH 130425 Modify

    //****************************** # Line Image #
    property int fgImageX: 43-10
    property int fgImageY: 91 //87 // JSH 130426  87 -> 91 Modify
    property int fgImageWidth: 493
    property int fgImageHeight: 3
    property bool fgImageVisible: true

    property string fgImage: imgFolderGeneral+"line_menu_list.png"
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    //****************************** # End #

    //first Text Info
    property string firstText: mChListFirstText
    property int firstTextX: 43-13-10
    property int firstTextY: 89-44
    property int firstTextWidth: 13+49
    property int firstTextSize: 40
    property int firstTextHeight: 40
    property string firstTextStyle: systemInfo.hdb
    property string firstTextAlies: "Center"
    property string firstTextVerticalAlies: "Center"
    //****************************** # End #
    property bool firstTextEnabled: true // true(enabled), false(disabled) <<-- Modified by WSH (130103)
    property string firstTextColor:  focusImageVisible ? colorInfo.brightGrey : colorInfo.dimmedGrey         // colorInfo.dimmedGrey => JSH 130404 [Edit firstText Color Bug Fixed]
    property string firstTextPressColor : focusImageVisible ? colorInfo.brightGrey : colorInfo.dimmedGrey    // colorInfo.dimmedGrey => JSH 130404 [Edit firstText Color Bug Fixed]
    property string firstTextFocusPressColor :  colorInfo.brightGrey
    property string firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"//idMChListDelegate.active? "#7CBDFF" : colorInfo.brightGrey  //RGB(124, 189, 255)
    property string firstTextDisabledColor: colorInfo.disableGrey // <<--------- Modified by WSH (121228)
    property string firstTextFocusColor : colorInfo.brightGrey  //# HYANG (121122)
    //****************************** # For text (elide, visible) by HYANG #

    property string firstTextElide: "None"          //# Elide ("Left","Right","Center","None")  ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true            //# Visible (true, false)
    property bool firstTextScrollEnable: false      //# Scroll Enable (true, false)
    property int firstTextScrollInterval: 0         //# Scroll Move Interval (number high-slow, number low-fast)
    property bool firstTextScrollOnewayMode: true   //# Scroll OndewayModeFlag (true-one side, false-both side)
    //****************************** # End #


    //****************************** # Channel (SecondText) #
    property string secondText: ""
    property int secondTextSize: 40
    property int secondTextX: 43-13-10+13+49+8;
    property int secondTextY: 89-44
    property int secondTextWidth: (!onlyPresetName) ? 116 : (presetSave) ? 248 : (presetOrderHandler) ? 269 : 304 //secondTextWidth: onlyPresetName ? 442 : 116
    property int secondTextHeight: 40
    property string secondTextStyle: selectedApp=="HdRadio" ? systemInfo.hdr : systemInfo.hdb // JSH 130425 added
    property string secondTextAlies: onlyPresetName ? "Left" : "Right"
    property string secondTextVerticalAlies: "Center"

    //****************************** # For text (elide, visible) by HYANG #
    property string secondTextElide: "Right"
    property bool secondTextVisible: true
    property bool secondTextScrollEnable: selectedApp !="HdRadio" ?  false : focusImageVisible ? true : false
    property int secondTextScrollInterval: 150
    property bool secondTextScrollOnewayMode: false
    //****************************** # End #
    property bool secondTextEnabled: true // true(enabled), false(disabled) <<--- Wrote Comment by WSH (130103)
    property string secondTextColor: colorInfo.brightGrey;
    property string secondTextPressColor : colorInfo.brightGrey;
    property string secondTextFocusPressColor : colorInfo.brightGrey;
    property string secondTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF" //idMChListDelegate.active ? "#7CBDFF" : colorInfo.brightGrey    //RGB(124, 189, 255)
    property string secondTextDisabledColor: colorInfo.disableGrey // <<--------- Modified by WSH (121228)
    property string secondTextFocusColor : colorInfo.brightGrey

    //****************************** # StationName (ThirdText) #
    //third Text Info
    property string thirdText: ""
    property int thirdTextSize: 40
    property int thirdTextX: 43-13-10+13+49+8+116+28
    property int thirdTextY: 89-44
    property int thirdTextWidth: (presetSave == true)? 201 : ((presetOrderHandler == true) || (presetOrderHandler == true)) ? 222 : 304
    property int thirdTextHeight: 40
    property string thirdTextStyle: systemInfo.hdr//"HDR"
    property string thirdTextAlies: "Left"
    property string thirdTextVerticalAlies: "Center"
    //****************************** # For text by HYANG #
    property string thirdTextElide: "Right"
    property bool thirdTextVisible: onlyPresetName? false : true
    property bool thirdTextScrollEnable: selectedApp =="HdRadio" ?  false : focusImageVisible ? true : false
    property int thirdTextScrollInterval: 150
    property bool thirdTextScrollOnewayMode: false
    //****************************** # End #
    property bool thirdTextEnabled: true
    property string thirdTextColor: colorInfo.brightGrey
    property string thirdTextPressColor : colorInfo.brightGrey;
    property string thirdTextFocusPressColor :colorInfo.brightGrey;
    property string thirdTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"//idMChListDelegate.active? "#7CBDFF" : colorInfo.brightGrey  //RGB(124, 189, 255)
    property string thirdTextDisabledColor: colorInfo.disableGrey
    property string thirdTextFocusColor :  colorInfo.brightGrey

    property bool focusImageVisible: idFocusImage.visible  //# for FocusText - HYANG (121122)
    property bool presetScan        : active && idAppMain.menuPresetScanFlag
    opacity: enabled ? 1.0 : 0.5

    //Button Image // by WSH
    Image{
        id:backGround
        source: bgImage
        //anchors.fill: parent // JSH 130426 Delete
    }

    //*****# Focus Image - position move by HYANG (121029)
    Image {
        //anchors.fill: backGround // JSH 130426 Delete
        id: idFocusImage
        source: bgImageFocus
        visible: showFocus && idMChListDelegate.activeFocus
    }

    //Image inside Button // by WSH
    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
    }


    //****************************** # Preset Scan Animation # JSH 130121
    SequentialAnimation{
        id: aniPresetScan
        running:presetScan
        onRunningChanged: {
            if(!running)
                idTextArea.opacity = 1;
        }
        loops: Animation.Infinite
        NumberAnimation { target: idTextArea; property: "opacity"; to: 0.0; duration: 500 }
        NumberAnimation { target: idTextArea; property: "opacity"; to: 1.0; duration: 500 }
    }

    Item {
        //First Text
        id:idTextArea
        Text{//MScrollText {   //# change from "Text" to "MScrollText" by HYANG
            id: txtFirstText
            text: firstText
            x:firstTextX
            y:firstTextY  -(firstTextSize/2) - (firstTextSize/3) //# - (firstTextSize/8) Text(Alphabet "g") truncation problem by HYANG (0620)
            width: firstTextWidth
            //height: firstTextHeight + (firstTextSize/8)  //# + (firstTextSize/4) - Text(Alphabet "g") truncation problem by HYANG (0620)
            color:firstTextColor //textColor:firstTextColor
            font.family: firstTextStyle
            font.pixelSize: firstTextSize
            horizontalAlignment: {
                if(firstTextAlies=="Right"){Text.AlignRight}
                else if(firstTextAlies=="Left"){Text.AlignLeft}
                else if(firstTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            }
            //****************************** # For text (scroll Enable, scroll move interval, scroll way mode, elide, visible) by HYANG #
            //        scrollEnable: firstTextScrollEnable
            //        interval: firstTextScrollInterval
            //        onewayMode: firstTextScrollOnewayMode
            elide: {
                if(firstTextElide=="Right"){Text.ElideRight}
                else if(firstTextElide=="Left"){Text.ElideLeft}
                else if(firstTextElide=="Center"){Text.ElideMiddle}
                else /*if(firstTextElide=="None")*/{Text.ElideNone}
            }
            visible: firstTextVisible
            clip: true //jyjeon_20120221
            //****************************** # End #
            enabled: firstTextEnabled // <<---------- Added by WSH (Enabled)
        }


        //Second Text
        MScrollText { // Text{
            id: txtSecondText
            text: secondText
            x:secondTextX
            y:secondTextStyle == systemInfo.hdr ? secondTextY - (secondTextSize/2) - (secondTextSize/3) + 2 : secondTextY - (secondTextSize/2) - (secondTextSize/3) // JSH 130425 added
            width: secondTextWidth
            height: secondTextHeight + (secondTextSize/8)
            textColor: secondTextColor    // color:
            fontfamily: secondTextStyle   // font.family:
            fontpixelSize: secondTextSize // font.pixelSize:
            horizontalAlignment: {
                if(secondTextAlies=="Right"){Text.AlignRight}
                else if(secondTextAlies=="Left"){Text.AlignLeft}
                else if(secondTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            } //jyjon_20120302

            //****************************** # For text (scroll Enable, scroll move interval, scroll way mode, elide, visible) by HYANG #
            scrollEnable: secondTextScrollEnable && (!idMChListDelegate.ListView.view.moving)
            interval: secondTextScrollEnable ? secondTextScrollInterval : 0
            onewayMode: secondTextScrollOnewayMode
            elide: {
                if(secondTextElide=="Right"){Text.ElideRight}
                else if(secondTextElide=="Left"){Text.ElideLeft}
                else if(secondTextElide=="Center"){Text.ElideMiddle}
                else /*if(secondTextElide=="None")*/{Text.ElideNone}
            } //jyjon_20120302
            visible: secondTextVisible
            clip: true //jyjeon_20120221
            //****************************** # End #
            enabled: secondTextEnabled // <<---------- Added by WSH (Enabled)
        }

        //Third Text
         MScrollText {
            id: txtThirdText
            text: thirdText
            x:thirdTextX
            y: thirdTextStyle == systemInfo.hdr ? thirdTextY -(thirdTextSize/2) - (thirdTextSize/3) + 2 : thirdTextY -(thirdTextSize/2) - (thirdTextSize/3) // JSH 130425 added
            width: thirdTextWidth
            height: thirdTextHeight + (thirdTextSize/8)
            textColor: thirdTextColor    // color:
            fontfamily: thirdTextStyle   // font.family:
            fontpixelSize: thirdTextSize // font.pixelSize:

            horizontalAlignment: {
                if(thirdTextAlies=="Right"){Text.AlignRight}
                else if(thirdTextAlies=="Left"){Text.AlignLeft}
                else if(thirdTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            } //jyjon_20120302
            //****************************** # For text (scroll Enable, scroll move interval, scroll way mode, elide, visible) by HYANG #
            scrollEnable: thirdTextScrollEnable && (!idMChListDelegate.ListView.view.moving)
            interval: thirdTextScrollEnable ? thirdTextScrollInterval : 0
            onewayMode: thirdTextScrollOnewayMode
            elide: {
                if(thirdTextElide=="Right"){Text.ElideRight}
                else if(thirdTextElide=="Left"){Text.ElideLeft}
                else if(thirdTextElide=="Center"){Text.ElideMiddle}
                else /*if(thirdTextElide=="None")*/{Text.ElideNone}
            } //jyjon_20120302
            visible: thirdTextVisible
            clip: true //jyjeon_20120221
            //****************************** # End #
            enabled: thirdTextEnabled // <<---------- Added by WSH (Enabled)
        }
    }
    onSelectKeyPressed: {
        if(idMChListDelegate.mEnabled) {
            console.log("[QML] MButton onSelectKeyPressed. state:"+ idMChListDelegate.state);
            idMChListDelegate.state = "pressed"; //idMChListDelegate.state="keyPress";
        } else {
            idMChListDelegate.state = "disabled"
        }
    }
    onSelectKeyReleased: {
        if(idMChListDelegate.mEnabled){
            if(active==true){
                idMChListDelegate.state="active"
            }else{
                idMChListDelegate.state="keyReless";
            }
        }else{
            idMChListDelegate.state = "disabled"
        }
    }

    onActiveFocusChanged: {
        if(idMChListDelegate.activeFocus == false && idMChListDelegate.state == "pressed")
            idMChListDelegate.state = "normal"
    }
    states: [
        State {
            name: 'normal';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: firstTextColor;}
            PropertyChanges {target: txtSecondText; textColor: secondTextColor;}
            PropertyChanges {target: txtThirdText; textColor: thirdTextColor;}
        },
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround;    source  : bgImagePress;}
            PropertyChanges {target: imgFgImage;    source  : fgImagePress;}
            PropertyChanges {target: txtFirstText;  color   : firstTextPressColor;}
            PropertyChanges {target: txtSecondText; textColor   : secondTextPressColor;}
            PropertyChanges {target: txtThirdText;  textColor   : thirdTextPressColor;}
            PropertyChanges { target: idFocusImage;     visible: false; }
        },
        State {
            name: 'active'; when: idMChListDelegate.active
            PropertyChanges {target: backGround;    source  : bgImageActive;}
            PropertyChanges {target: imgFgImage;    source  : fgImageActive;}
            PropertyChanges {target: txtFirstText;  color   : firstTextSelectedColor;}
            PropertyChanges {target: txtSecondText; textColor   : secondTextSelectedColor;}
            PropertyChanges {target: txtThirdText;  textColor   : thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress'; when: idMChListDelegate.state=="keyPress" // problem Kang
            PropertyChanges {target: backGround;    source  : bgImageFocusPress;}
            PropertyChanges {target: imgFgImage;    source  : fgImageFocusPress;}
            PropertyChanges {target: txtFirstText;  color   : firstTextFocusPressColor;}
            PropertyChanges {target: txtSecondText; textColor   : secondTextFocusPressColor;}
            PropertyChanges {target: txtThirdText;  textColor   : thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround;    source  : bgImage;}
            PropertyChanges {target: imgFgImage;    source  : fgImage;}
            PropertyChanges {target: txtFirstText;  color   : focusImageVisible? firstTextFocusColor : firstTextColor;}
            PropertyChanges {target: txtSecondText; textColor   : focusImageVisible? secondTextFocusColor : secondTextPressColor;}
            PropertyChanges {target: txtThirdText;  textColor   : focusImageVisible? thirdTextFocusColor : thirdTextPressColor;}
        },
        State {
            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
            PropertyChanges {target: backGround;    source  : bgImage;}
            PropertyChanges {target: imgFgImage;    source  : fgImage;}
            PropertyChanges {target: txtFirstText;  color   : mEnabled? firstTextColor : firstTextDisabledColor;}
            PropertyChanges {target: txtSecondText; textColor   : mEnabled? secondTextColor : secondTextDisabledColor;}
            PropertyChanges {target: txtThirdText;  textColor   : mEnabled? thirdTextColor : thirdTextDisabledColor;}
        }
    ]

    onMChListSecondTextChanged:secondText = mChListSecondText; // secondText: mChListSecondText JSH 130329 Text Update
    onMChListThirdTextChanged:thirdText = mChListThirdText; //thirdText: mChListThirdText

    //****************************** # HD Radio yellow icon image #
    Image{
        x: 411-13;
        y: 89-55-2; z: 1
        width: 44; height: 24
        source: imgFolderRadio_Hd+"ico_hd.png"
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text != "" && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
    }
    Text{
        id: iconHdText
        text: mChIconHdText
        x: 411-13;
        y: 89-55-2+12-20/2; z: 1
        width: 44; height: 20
        font.pixelSize: 20
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.black
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text!="" && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
    }



    //****************************** # Preset Save Button (121120)
    MButtonOnlyRadio{
        x: selectedApp  == "HdRadio" ? 43-10+63+248+4 : 43-10+201+201+4
        y: 10
        width: 105; height: 68
        bgImage: imgFolderRadio+"btn_save_n.png"
        bgImagePress: imgFolderRadio+"btn_save_p.png"
        visible: presetSave
        firstText: presetSaveText
        firstTextX: 0
        firstTextY: 34//-19
        firstTextWidth: 105
        firstTextHeight: 68
        firstTextSize: 28
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextPressColor: colorInfo.brightGrey
        onClickOrKeySelected: presetSaveClickOrKeySelected();
        onVisibleChanged: { // JSH 121121 , Text Update
            if(selectedApp  == "HdRadio"){ // JSH 130329 Add
                secondText = "";
                secondText = mChListSecondText;
            }else{
                thirdText = "";
                thirdText = mChListThirdText;
            }
        }
    }

    //****************************** # Edit Preset Order (121120)
    Image {
        id:idDragIcon
        visible: presetOrderHandler && (isDragItem == false)
        x: selectedApp  == "HdRadio" ? 43-10+63+269+10 : 43-10+201+222+10 ;y: 31
        source: imageInfo.imgFolderRadio+"ico_handler.png"
    } // End Image

    Item{
        id: idArrowImage
        visible: presetOrderHandler && isDragItem
        Image{
            x: selectedApp  == "HdRadio" ? 43-10+63+269+10+7 : 43-10+201+222+10+7
            y: 15
            source: idMChListDelegate.ListView.view.curIndex == 0 ? imgFolderRadio+"ico_arrow_u_d.png" : imgFolderRadio+"ico_arrow_u_n.png"
        }
        Image{
            x: selectedApp  == "HdRadio" ? 43-10+63+269+10+7 : 43-10+201+222+10+7
            y: 15+30+4
            source: idMChListDelegate.ListView.view.curIndex == (idMChListDelegate.ListView.view.count-1)? imgFolderRadio+"ico_arrow_d_d.png" : imgFolderRadio+"ico_arrow_d_n.png"
        }
    } // End Item

    //****************************** # Item Click or Key Selected #
    onClickOrKeySelected: {
        //console.log("----------------------------------->> MChListDelegateOnlyRadio.qml onClickOrKeySelected",idMChListDelegate.ListView.view.currentIndex,index)
        if(playBeepOn && idMChListDelegate.state!="disabled") idAppMain.playBeep();
        selectedItem = index
        idMChListDelegate.ListView.view.currentIndex = index
        idMChListDelegate.ListView.view.focus = true
        idMChListDelegate.ListView.view.forceActiveFocus()
    }
    //****************************** # Wheel in ListView #
    Keys.onReleased:{
        if(Qt.Key_Up == event.key){
            if(!idMChListDelegate.ListView.view.ccpAccelerate){
                jogFocusState  = "Band";
                event.accepted = true;
            }
        }
        idMChListDelegate.ListView.view.ccpAccelerate = false;
    }
    Keys.onPressed: {
        //var local_HdMenuInfo  = 0;  // HD // HD // JSH 130621 Info Window Delete
        var local_HdOnOff     = 0;  // HD

        if(QmlController.getRadioType() == 1){            // HD Radio
            //local_HdMenuInfo    = idAppMain.menuInfoFlag // HD // JSH 130621 Info Window Delete
            local_HdOnOff       = idAppMain.hdRadioOnOff
        }

        if (Qt.Key_Right == event.key){
            console.log("======================> Qt.Key_Right UP Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)
            if((!idAppMain.presetSaveEnabled) && (!idAppMain.presetEditEnabled)){
                if (!local_HdOnOff)
                    jogFocusState = "FrequencyDial"
                else if (local_HdOnOff)
                    jogFocusState = "HDDisplay"

                //if (local_HdMenuInfo) // HD // JSH 130621 Info Window Delete
                //    idRadioHdMain.changeInfoState(2,false);//jogFocusState = "PresetList" => JSH 130402 Modify
            }
            event.accepted = true;
            return;
        }
        else if(idAppMain.isWheelLeft(event) || (Qt.Key_Up == event.key)){
            console.log("======================> isWheelLeft or Qt.Key_Up Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)

            if(Qt.Key_Up == event.key){
                //jogFocusState   = "Band"
                event.accepted  = true;
                return;
            }
            else{
                if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled){
//                    if( idMChListDelegate.ListView.view.currentIndex){
//                        idMChListDelegate.ListView.view.decrementCurrentIndex();
//                    }
//                    else{
//                        idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, ListView.Visible);
//                        idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
//                    }

                    if(isDragItem) //Drag Mode
                    {
                        if(idChListView.curIndex > 0)
                        {
                            idMChListDelegate.ListView.view.curIndex--;
                            if(idMChListDelegate.ListView.view.curIndex*height+2 < idMChListDelegate.ListView.view.contentY+height)
                                idMChListDelegate.ListView.view.contentY = idMChListDelegate.ListView.view.curIndex*height

                            idMChListDelegate.ListView.view.itemMoved(0,0);
                        } // End if
                    }
                    else //Jog Mode
                    {
                        if( idMChListDelegate.ListView.view.currentIndex )
                        {
                            idMChListDelegate.ListView.view.decrementCurrentIndex();
                        }
                        else
                        {
                            idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, idMChListDelegate.ListView.view.Visible);
                            idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
                        } // End if
                    } // End if
                    return;
                }
                else{
                    var selectedIndex = 0;
                    if(globalSelectedBand=="FM1")
                        selectedIndex = QmlController.getPresetIndexFM1()-1
                    if(globalSelectedBand=="FM2")
                        selectedIndex = QmlController.getPresetIndexFM2()-1
                    else if(globalSelectedBand=="AM")
                        selectedIndex = QmlController.getPresetIndexAM()-1

                    if(selectedIndex != (index+1)){
                        QmlController.setPresetIndex(QmlController.radioBand,index+1);
                        QmlController.changeChannel(0x00);
                    }
                    else
                        idMChListDelegate.ListView.view.decrementCurrentIndex();  // focus Image Moved
                }
            }
        }
        else if(idAppMain.isWheelRight(event) || (Qt.Key_Down == event.key)) {
            console.log("======================> isWheelRight or Qt.Key_Down Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)

            if(Qt.Key_Down == event.key){
                event.accepted = true;
                return;
            }
            else{
                if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled){
//                    if((idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex)){
//                        idMChListDelegate.ListView.view.incrementCurrentIndex();
//                    }
//                    else{
//                        idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
//                        idMChListDelegate.ListView.view.currentIndex = 0;
//                    }

                    if(isDragItem) //Drag Mode
                    {
                        if(idMChListDelegate.ListView.view.curIndex < (idMChListDelegate.ListView.view.count-1))
                        {
                            idMChListDelegate.ListView.view.curIndex++;
                            if(idMChListDelegate.ListView.view.curIndex*height+height > idMChListDelegate.ListView.view.contentY+idMChListDelegate.ListView.view.height)
                                idMChListDelegate.ListView.view.contentY = (idMChListDelegate.ListView.view.curIndex*height+height)-idMChListDelegate.ListView.view.height;
                            idMChListDelegate.ListView.view.itemMoved(0,0);
                        } // End if
                    }
                    else //Jog Mode
                    {
                        if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex )
                        {
                            idMChListDelegate.ListView.view.incrementCurrentIndex();
                        }
                        else
                        {
                            idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                            idMChListDelegate.ListView.view.currentIndex = 0;
                        } // End if
                    } // End if
                    return;
                }else{
                    var selectedIndex = 0;
                    if(globalSelectedBand=="FM1")
                        selectedIndex = QmlController.getPresetIndexFM1()-1
                    if(globalSelectedBand=="FM2")
                        selectedIndex = QmlController.getPresetIndexFM2()-1
                    else if(globalSelectedBand=="AM")
                        selectedIndex = QmlController.getPresetIndexAM()-1

                    if(selectedIndex != (index+1)){
                        QmlController.setPresetIndex(QmlController.radioBand,index+1);
                        QmlController.changeChannel(0x01);                         // JSH 121030
                    }
                    else
                        idMChListDelegate.ListView.view.incrementCurrentIndex();
                }
            }
        }
    }

    function move()
    {
        var contentHeight = idMChListDelegate.ListView.view.count * height;
        if(isMoveUpScroll)
        {
            if(idMChListDelegate.ListView.view.contentY <= (89/2))
            {
                idMChListDelegate.ListView.view.contentY = 0;
                moveTimer.running =false;
            }
            else
                idMChListDelegate.ListView.view.contentY -= (89/2);
            checkOnScrollMoved();
        }else
        {
            if(idMChListDelegate.ListView.view.contentY >= contentHeight - idMChListDelegate.ListView.view.height - (89/2))
            {
                idMChListDelegate.ListView.view.contentY = contentHeight - idMChListDelegate.ListView.view.height;
                moveTimer.running = false;
            }
            else
                idMChListDelegate.ListView.view.contentY += (89/2);
            checkOnScrollMoved();
        }
    } // End function

    function lockListView(){
        idMChListDelegate.ListView.view.currentIndex = index
        idMChListDelegate.ListView.view.interactive = false;   // Cant't move list
        idMChListDelegate.ListView.view.insertedIndex = index; // Save slected index
        idMChListDelegate.ListView.view.curIndex = index;
        idMChListDelegate.ListView.view.isDragStarted = true;
        z = z+1;
    } // End function

    function unlockListView(){
        idMChListDelegate.ListView.view.isDragStarted = false;
        idMChListDelegate.ListView.view.interactive = true;
        idMChListDelegate.ListView.view.itemInitWidth();
        idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.curIndex;
        idMChListDelegate.ListView.view.curIndex = -1;
        idMChListDelegate.ListView.view.insertedIndex = -1;
        idMChListDelegate.ListView.view.forceActiveFocus();
        z = z-1;
    } // End function
    function checkOnScrollMoved(){
        if((idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height != idMChListDelegate.ListView.view.curIndex)
        {
            if((idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height >= 0 && (idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height < (idMChListDelegate.ListView.view.count-1))
            {
                idMChListDelegate.ListView.view.curIndex = (idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height;
                idMChListDelegate.ListView.view.itemMoved(0,0);
            }
        }
    } // End function
    function setPresetListIndex()
    {
        //console.log("blacktip::===============1 "+idChListView.backupIndex+":"+idMChListDelegate.ListView.view.insertedIndex+":"+idMChListDelegate.ListView.view.curIndex+":"+index)
        if( idChListView.backupIndex < idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex < idMChListDelegate.ListView.view.curIndex)
        {
        }else if(idChListView.backupIndex > idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex > idMChListDelegate.ListView.view.curIndex)
        {
        }else if(idChListView.backupIndex > idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex <= idMChListDelegate.ListView.view.curIndex)
        {
            idChListView.backupIndex = idChListView.backupIndex - 1;
        }else if(idChListView.backupIndex < idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex >= idMChListDelegate.ListView.view.curIndex)
        {
            idChListView.backupIndex = idChListView.backupIndex + 1;
        }else if(index == idMChListDelegate.ListView.view.insertedIndex)
        {
            idChListView.backupIndex = idMChListDelegate.ListView.view.curIndex;
        }
        //console.log("blacktip::=============== 2 "+idChListView.backupIndex+":"+idMChListDelegate.ListView.view.insertedIndex+":"+idMChListDelegate.ListView.view.curIndex+":"+index)
    } // End function

    Connections {
        target: idChListView
        onItemInitWidth: {
            isDragItem = false;
            if(height*index > 0)
                y = height*index;
            else y = 0;
       }
        onItemMoved: {
            if(index < idMChListDelegate.ListView.view.insertedIndex && index < idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index;
            }else if(index > idMChListDelegate.ListView.view.insertedIndex && index > idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index;
            }else if(index > idMChListDelegate.ListView.view.insertedIndex && index <= idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index - height;
            }else if(index < idMChListDelegate.ListView.view.insertedIndex && index >= idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index + height;
            }else if(index == idMChListDelegate.ListView.view.insertedIndex)
            {
                y = height*idMChListDelegate.ListView.view.curIndex
            }
        }
    }
    onChangeRow: {
        console.log("########################### onChangeRow : ListView ###########################",fromIndex, toIndex)
        QmlController.changePresetOrder(fromIndex, toIndex); // MODEL UPDATE
        QmlController.presetModelReplace(fromIndex, toIndex);// MODEL NUM UPDATE AND MICOM SEND
    } // End onChangeRow
}
