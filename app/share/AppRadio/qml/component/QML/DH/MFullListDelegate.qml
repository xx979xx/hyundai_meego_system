/**
 * FileName: MFullListDelegate.qml
 * Author: HYANG
 * Time: 2012-02
 *
 * - 2012-02 Initial Crated by HYANG
 * - 2012-05 Added Selected bgImage
 * - 2012-06 Added Selected fgImage
 * - 2012-07 Added right/left wheel
 * - 2012-07-25 selected text color change
 * - 2012-08-13 add Play Icon Image animation
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp
//20130312 modified by qutiguy - Do not use MButton but use MButtonOlnyRadio.
//MButton {
MButtonOnlyRadio {
    id: idMFullListDelegate
    x: 15; y: 0
//20121205 modified by qutiguy - fixed Stationlist position defect
//    width: 1246; height: 90
//    buttonWidth: 1246; buttonHeight: 90
    width: 1238; height: 90
    buttonWidth: 1238; buttonHeight: 90
    buttonName: index
    active: (buttonName == selectedIndex)

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
//    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderGeneral : imageInfo.imgFolderGeneralForPremium //KSW 130731 for premium UX
    property string imgFolderDmb : imageInfo.imgFolderDmb  

    property int textCount: 1                 //# text`s count (1 or 2)
    property bool selectedFgImageFlag: true   //# image in item On/Off when selected
    property bool selectedBgImageFlag: false  //# background`s On/Off when selected
    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property int maxListCount : 6 // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS

    //****************************** # background Image #
    bgImagePress: showPopup ? "" : imgFolderGeneral+"list_p.png" //dg.jin 20140901 ITS 247202 focus issue
    bgImageFocusPress: imgFolderGeneral+"list_fp.png"
    bgImageFocus: showPopup ? "" : imgFolderGeneral+"list_f.png" //dg.jin 20140901 ITS 247202 focus issue
    bgImageActive: selectedBgImageFlag ? imgFolderGeneral+"list_s.png" : ""
    //// 2013.10.30 qutiguy : ITS0198902
    bgImageFocusY: -4

    //****************************** # Image in Item #
    Image{
        id: playIcon
        x: 37-15; y: 22
        width: 46 ; height: 46;
        source: selectedFgImageFlag ? count > 9 ? imgFolderGeneral+"/play/ico_play_"+ count +".png" : imgFolderGeneral+"/play/ico_play_0"+ count +".png" : ""
        visible: idMFullListDelegate.active //buttonName == selectedIndex

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
        console.log(">>>>>>>>>>>>>>>>>>>>",  visible)
//        if(buttonName == selectedIndex) idPlayIconTimer.restart()
        if(idMFullListDelegate.active ) idPlayIconTimer.restart()
        else idPlayIconTimer.stop()
    }

    //****************************** # First Text #
    firstText: mChListFirstText
    firstTextX: 37 + 65 - 15 ; firstTextY: 46
    firstTextWidth: textWidthByTextCount()//1146
    firstTextSize: 40
    firstTextStyle: idMFullListDelegate.active? systemInfo.hdb:systemInfo.hdr //2013.11.23 modified by qutiguy - GUI review
    firstTextAlies: "Left"
    //firstTextColor: colorInfo.commonGrey//colorInfo.brightGrey //KSW 131212 for KH
    firstTextColor: colorInfo.brightGrey
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    firstTextPressColor: (idMFullListDelegate.ListView.view.currentIndex == selectedIndex) ? colorInfo.brightGrey : (idMFullListDelegate.active? "#7CBDFF" : colorInfo.brightGrey)
    //2013.11.23 modified by qutiguy - GUI review issues.
    //dg.jin 20150304 Text color error
    firstTextSelectedColor:  (idMFullListDelegate.ListView.view.currentIndex == selectedIndex)? (focusImageVisible? colorInfo.brightGrey:"#7CBDFF"):"#7CBDFF"
    firstTextFocusPressColor: colorInfo.brightGrey   

    //****************************** # Second Text #
// 20130312 modified by qutiguy
    secondText: mChListSecondText //"ABCDEFGHIJ KLMNOPQRST UV"
    secondTextX: 37 + 65 + 651 + 74 - 15 ; secondTextY: 46
    secondTextWidth: 366
    secondTextSize: 32
    secondTextStyle: idMFullListDelegate.active? systemInfo.hdb:systemInfo.hdr //2013.11.23 modified by qutiguy - GUI review
    secondTextAlies: "Left"
    //secondTextColor: colorInfo.commonGrey//colorInfo.brightGrey //KSW 131212 for KH
    secondTextColor: colorInfo.brightGrey
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    secondTextPressColor: (idMFullListDelegate.ListView.view.currentIndex == selectedIndex) ? colorInfo.brightGrey : (idMFullListDelegate.active? "#7CBDFF" : colorInfo.brightGrey)
    //2013.11.23 modified by qutiguy - GUI review issues.
    //dg.jin 20150304 Text color error
    secondTextSelectedColor:  (idMFullListDelegate.ListView.view.currentIndex == selectedIndex)?(focusImageVisible? colorInfo.brightGrey:"#7CBDFF"):"#7CBDFF"
    secondTextVisible: textCount != 1

    //****************************** # Line Image #
    Image{
        x: 0-15; y: 254-systemInfo.headlineHeight
        width: parent.width
        source: imgFolderGeneral+"list_line.png"
    }

    //****************************** # when Click or Key selected #
    onClickOrKeySelected: {
        idMFullListDelegate.ListView.view.currentIndex = index
        idMFullListDelegate.ListView.view.focus = true
        idMFullListDelegate.ListView.view.forceActiveFocus()
//        selectedIndex = index
    }

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        switch(event.key){
        case Qt.Key_Semicolon: {
            //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>left")
//// 2013.11.12 added by qutiguy - move to ListView with signalWeelUp/Down
//            if( idMFullListDelegate.ListView.view.currentIndex ){
//                idMFullListDelegate.ListView.view.decrementCurrentIndex();
//            }
//            else if( maxListCount < idMFullListDelegate.ListView.view.count ){ // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS
//                idMFullListDelegate.ListView.view.positionViewAtIndex(idMFullListDelegate.ListView.view.count-1, idMFullListDelegate.ListView.view.Visible);
//                idMFullListDelegate.ListView.view.currentIndex = idMFullListDelegate.ListView.view.count-1;
//            }
            break;
        }
        case Qt.Key_Apostrophe:{
            //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>right")
//// 2013.11.12 added by qutiguy - move to ListView with signalWeelUp/Down
//            if( idMFullListDelegate.ListView.view.count-1 != idMFullListDelegate.ListView.view.currentIndex ){
//                idMFullListDelegate.ListView.view.incrementCurrentIndex();
//            }
//            else if( maxListCount < idMFullListDelegate.ListView.view.count ){ // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS
//                idMFullListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
//                idMFullListDelegate.ListView.view.currentIndex = 0;
//            }
            break;
        }
        case Qt.Key_Down:
        case Qt.Key_Up:
        {
            event.accepted  = true;
            break;
        }
        default :
            break;
        } //End of switch(event.key)
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
    //****************************** # function(Text width size) #
    function textWidthByTextCount(){
        if(textCount != 1) return 850
        else return 1145
    }
}
