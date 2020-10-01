/**
 * FileName: MPresetDelegate.qml
 * Author: HYANG
 * Time: 2012-07
 *
 * - 2012-07 Initial Created by HYANG
 * - 2012-07 add signal pressAndHold
 * - 2012-08-13 add Play Icon Image animation
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

//MButton {
MButtonOnlyRadio{

    id: idMPresetDelegate
    x: 0; y: 0
    width: 574; height: 86
    buttonName: index
    active: (buttonName == selectedIndex)

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderRadio_Dab : imageInfo.imgFolderRadio_Dab
    property string imgFolderDmb : imageInfo.imgFolderDmb
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //****************************** # Preperty related Control's Data (RDS) #
    property string presetItemPICOCE :  PICode;
    property string presetItemFrequency :  StringFreq;
    property string presetItemPSName: PresetName;
    property int presetItemPTYType: PtyType;

    //****************************** # Button Image #
    bgImage: imgFolderRadio_Dab+"btn_preset_n.png"
    bgImagePress: showPopup ? imgFolderRadio_Dab+"btn_preset_n.png" : imgFolderRadio_Dab+"btn_preset_p.png" //dg.jin 20140901 ITS 247202 focus issue
    bgImageFocusPress: imgFolderRadio_Dab+"btn_preset_p.png"
    bgImageFocus: showPopup ? imgFolderRadio_Dab+"btn_preset_n.png" : imgFolderRadio_Dab+"btn_preset_f.png" //dg.jin 20140901 ITS 247202 focus issue
    bgImageActive: imgFolderRadio_Dab+"btn_preset_n.png"

    //****************************** # Index (FirstText) #    
    firstText: index+1
    firstTextX: 12
    firstTextY: 9+31
    firstTextWidth: 66
    firstTextHeight: 36
    firstTextSize: 36
    firstTextStyle: (buttonName == selectedIndex)?systemInfo.hdb : systemInfo.hdr //2013.11.23 modified by qutiguy - GUI review issues.
    firstTextAlies: "Center"

    firstTextColor: colorInfo.brightGrey;
    firstTextFocusPressColor: colorInfo.brightGrey
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    firstTextPressColor: (idMPresetDelegate.GridView.view.currentIndex == selectedIndex)?colorInfo.brightGrey:((buttonName == selectedIndex) ? "#7CBDFF" : colorInfo.brightGrey)
    //dg.jin 20150304 Text color error
    firstTextSelectedColor: (idMPresetDelegate.GridView.view.currentIndex == selectedIndex)?(focusImageVisible? colorInfo.brightGrey:"#7CBDFF"):"#7CBDFF" //2013.11.23 modified by qutiguy - GUI review issues.

    //****************************** # Line Image #
    fgImage: imgFolderRadio_Dab+"preset_divder.png"
    fgImageX: 12+66+10
    fgImageY: 9
    fgImageWidth: 3
    fgImageHeight: 67

    //****************************** # Play Icon Image #
    Image{
        id: playIcon
        x: 12+66+10+19; y: 9+6
        width: 46 ; height: 46;
        source: count > 9 ? imgFolderGeneral+"/play/ico_play_"+ count +".png" : imgFolderGeneral+"/play/ico_play_0"+ count +".png"
        visible: buttonName == selectedIndex

        Timer{
            id: idPlayIconTimer
            interval: 100;
            repeat: true
            onTriggered: {
                if(count == countMax) count = 1
                count++;
            }
        }
    }
    property int count: 1
    property int countMax: 30

    onActiveChanged: {       
        if(buttonName == selectedIndex) idPlayIconTimer.restart()
        else idPlayIconTimer.stop()
    }

    //****************************** # Channel (SecondText) #
    secondText: PresetName != ""?PresetName:StringFreq
    secondTextX: (buttonName == selectedIndex)? 12+66+10+19+50 : 12+66+10+27
    secondTextY: 9+31
    secondTextWidth: 446
    secondTextHeight: 36
    secondTextSize: 36
    secondTextStyle: (buttonName == selectedIndex)?systemInfo.hdb:systemInfo.hdr //2013.11.23 modified by qutiguy - GUI review issues.
    secondTextAlies: "Left"
    secondTextColor: colorInfo.brightGrey;
    secondTextFocusPressColor: colorInfo.brightGrey
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    secondTextPressColor: (idMPresetDelegate.GridView.view.currentIndex == selectedIndex)?colorInfo.brightGrey:((buttonName == selectedIndex) ? "#7CBDFF" : colorInfo.brightGrey)
    //dg.jin 20150304 Text color error
    secondTextSelectedColor: (idMPresetDelegate.GridView.view.currentIndex == selectedIndex)?(focusImageVisible? colorInfo.brightGrey:"#7CBDFF"):"#7CBDFF" //2013.11.23 modified by qutiguy - GUI review issues.
//    onSecondTextChanged: {
//        if(secondText=="Empty"){
//            firstTextColor = colorInfo.dimmedGrey
//            firstTextFocusPressColor = colorInfo.dimmedGrey
//            firstTextPressColor = colorInfo.dimmedGrey
//            firstTextSelectedColor = colorInfo.dimmedGrey
//            secondTextColor = colorInfo.dimmedGrey
//            secondTextFocusPressColor = colorInfo.dimmedGrey
//            secondTextPressColor = colorInfo.dimmedGrey
//            secondTextSelectedColor = colorInfo.dimmedGrey
//        }
//        else{
//            firstTextColor = focusImageVisible?colorInfo.brightGrey:"#7CBDFF"
//            firstTextFocusPressColor = colorInfo.brightGrey
//            firstTextPressColor = colorInfo.brightGrey
//            firstTextSelectedColor = focusImageVisible?colorInfo.brightGrey:"#7CBDFF" //2013.11.23 modified by qutiguy - GUI review issues.
//            secondTextColor = focusImageVisible?colorInfo.brightGrey:"#7CBDFF"
//            secondTextFocusPressColor = colorInfo.brightGrey
//            secondTextPressColor = colorInfo.brightGrey
//            secondTextSelectedColor =  focusImageVisible?colorInfo.brightGrey:"#7CBDFF" //2013.11.23 modified by qutiguy - GUI review issues.
//        }
//    }

    //****************************** # Item Click or Key Selected #
    onClickOrKeySelected: {
        idMPresetDelegate.GridView.view.currentIndex = index
        idMPresetDelegate.GridView.view.focus = true
        idMPresetDelegate.GridView.view.forceActiveFocus()
//0926 remove this and then set after checking duplicate         selectedIndex = index
        presetItemClicked()
    }

    onPressAndHold: {
        isLongKey = true; // JSH 130711
        idMPresetDelegate.GridView.view.currentIndex = index
        idMPresetDelegate.GridView.view.focus = true
        idMPresetDelegate.GridView.view.forceActiveFocus()
//0926 remove this and then set after checking duplicate        selectedIndex = index
        presetItemPressAndHold(playBeepOnHold) //dg.jin 20141103 ITS 251755 presetlist longpress beep
    }

    //****************************** # Key Pressed Event #
    Keys.onPressed: {
        switch(event.key){
            //****************************** # Wheel in GridView #
        case Qt.Key_Semicolon:{ //HWS 130114
            /* // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS
            if( idMPresetDelegate.GridView.view.currentIndex == 0){
                idMPresetDelegate.GridView.view.currentIndex = 11;
            }
            else if(idMPresetDelegate.GridView.view.currentIndex == 6){
                idMPresetDelegate.GridView.view.currentIndex = 5;
            }
            else
            */
            if( idMPresetDelegate.GridView.view.currentIndex ){
                idMPresetDelegate.GridView.view.moveCurrentIndexUp();
            }
            console.log("[CHECK_11_23_CURRENTINDEX Key_Semicolon currentIndex = ]" + idMPresetDelegate.GridView.view.currentIndex );
            console.log("[CHECK_11_23_CURRENTINDEX Key_Semicolon selectedIndex =  ]" + selectedIndex );
            break;
        }

        case Qt.Key_Apostrophe:{ //HWS 130114
            /* // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS
            if( idMPresetDelegate.GridView.view.currentIndex == 5){
                idMPresetDelegate.GridView.view.currentIndex = 6;
            }
            else if(idMPresetDelegate.GridView.view.currentIndex == 11){
                idMPresetDelegate.GridView.view.currentIndex = 0;
            }
            else
            */
            if( idMPresetDelegate.GridView.view.count-1 != idMPresetDelegate.GridView.view.currentIndex ){
                idMPresetDelegate.GridView.view.moveCurrentIndexDown();
            }
            console.log("[CHECK_11_23_CURRENTINDEX Key_Apostrophe currentIndex = ]" + idMPresetDelegate.GridView.view.currentIndex );
            console.log("[CHECK_11_23_CURRENTINDEX Key_Apostrophe selectedIndex =  ]" + selectedIndex );
            break;
        }
        //****************************** # Key in GridView #
        case Qt.Key_Up:{
//            if(idMPresetDelegate.GridView.view.currentIndex == 6){
//                idMPresetDelegate.GridView.view.currentIndex = 6;
//            }
            event.accepted  = true;
            console.log("[MPresetDelegate.qml] [idMPresetDelegate] [Qt.Key_Up][Press]");
            break;
        }
        case Qt.Key_Down:{
//            if( idMPresetDelegate.GridView.view.currentIndex == 5){
//                idMPresetDelegate.GridView.view.currentIndex = 5;
//            }
            event.accepted  = true;
            console.log("[MPresetDelegate.qml] [idMPresetDelegate] [Qt.Key_Down]");
            break;
        }
        case Qt.Key_Right:{
            console.log("[MPresetDelegate.qml] [idMPresetDelegate] [Qt.Key_Right] index = " + idMPresetDelegate.GridView.view.currentIndex);
            if( idMPresetDelegate.GridView.view.currentIndex < 6){
                idMPresetDelegate.GridView.view.currentIndex += 6;
            }
            event.accepted  = true;
            break;
        }
        case Qt.Key_Left:{
            console.log("[MPresetDelegate.qml] [idMPresetDelegate] [Qt.Key_Left] index = " + idMPresetDelegate.GridView.view.currentIndex);
            if( idMPresetDelegate.GridView.view.currentIndex > 5){
                idMPresetDelegate.GridView.view.currentIndex -= 6;
            }
            event.accepted  = true;
            break;
        }
        default:
            break;
        } //# End switch
    }
    //****************************** # Key Release Event #
    Keys.onReleased: {
        switch(event.key){
        case Qt.Key_Up:{
            idMBand.focus = true
            console.log("[MPresetDelegate.qml] [idMPresetDelegate] [Qt.Key_Up][Release]");
            break;
        }
        default:
            break;
        } //# End switch
    }
}
