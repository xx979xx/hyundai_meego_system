/**
 * FileName: MBand.qml
 * Author: HYANG
 * Time: 2012-07
 *
 * - 2012-07 Initial Created by HYANG
 * - (Tab count max 5, focus added, wheel added)
 * - 2012-07-26 apply jog key, dialing principle
 * - 2012-07-27 add BT image in tab, add text visible flag
 * - 2012-07-31 focus condition modify, tabBtnBtFlag delete, tabBtn`s focus start number add
 * - 2013-01-12 add Give force focus for focus & active sync (isv issue)
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComponent {
    id: idMBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    // # Title Info #
    property string titleText: ""
    property int titleTextX: 45;
    property int titleTextY: 130-systemInfo.statusBarHeight-(titleTextSize/2)
    property int titleTextWidth: txtTitle.paintedWidth//830;
    property int titleTextHeight: 40
    property int titleTextSize: 40
    property string titleTextStyle: idAppMain.fontsB
    property string titleTextVerticalAlies: "Center" //Text.AlignVCenter
    property string titleTextHorizontalAlies: "Left" //Text.AlignLeft
    property string titleTextColor: colorInfo.brightGrey
    property bool titleTextFlag: true

    // # Title Small Info #
    property string titleTextSmall: ""
    property int titleTextSmallX: titleTextX+titleTextWidth+15
    property int titleTextSmallY: 130-systemInfo.statusBarHeight-(titleTextSmallSize/2)
    property int titleTextSmallWidth: txtTitleSmall.paintedWidth // 146
    property int titleTextSmallHeight: 30
    property int titleTextSmallSize: 30
    property string titleTextSmallStyle: titleTextStyle
    property string titleTextSmallVerticalAlies: titleTextVerticalAlies
    property string titleTextSmallHorizontalAlies: titleTextHorizontalAlies
    property string titleTextSmallColor: titleTextColor
    property bool titleTextSmallFlag: false

    // # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral


    // # Menu Info #
    property string menuBtnText: ""
    property bool menuBtnEnabledFlag: true

    property bool tabBtnFlag: false
    property bool menuBtnFlag: false



    // # Signal (when button clicked) #
    signal menuBtnClicked();
    signal backBtnClicked();

    function focusBackBtn(){
        idBackBtn.focus = true
    }

    function focusMenuBtn(){

        if(idMBand.menuBtnEnabledFlag == true){
            idMenuBtn.focus = true
        }else{
            idBackBtn.focus = true
        }
    }

    // # Band Background Image #
    Image{
        x: 0; y: 0
        source: imgFolderGeneral+"bg_title.png"
    }

    // # Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: titleTextX
        y: titleTextY
        width: titleTextWidth
        height: titleTextHeight
        font.pixelSize: titleTextSize
        font.family: titleTextStyle
        verticalAlignment: { MDmbOperation.getVerticalAlignment(titleTextVerticalAlies) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(titleTextHorizontalAlies) }
        color: titleTextColor
        visible: (titleTextFlag == true)
    }

    // # Title Text Small
    Text{
        id: txtTitleSmall
        text: titleTextSmall
        x: titleTextSmallX
        y: titleTextSmallY
        width: titleTextSmallWidth
        height: titleTextSmallHeight
        font.pixelSize: titleTextSmallSize
        font.family: titleTextSmallStyle
        verticalAlignment: { MDmbOperation.getVerticalAlignment(titleTextSmallVerticalAlies) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(titleTextSmallHorizontalAlies) }
        color: colorInfo.selectedBlue
        visible: (titleTextSmallFlag == true)
    }

    // # Menu button #
    MButton{
        id: idMenuBtn
        x: 860+138; y: 0
        width: 141; height: 72
        focus: (idMBand.menuBtnEnabledFlag == true) ? true : false /*(menuBtnFlag==true) ? true : false*/
        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocus: (idMBand.menuBtnEnabledFlag == true) ? imgFolderGeneral+"btn_title_sub_f.png" : ""
        visible: (menuBtnFlag == true)
        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                menuBtnClicked()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

        firstText: menuBtnText
        firstTextX: 9; firstTextY: 37
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: idAppMain.fontsB
        firstTextHorizontalAlies: "Center"
        firstTextColor: (idMBand.menuBtnEnabledFlag == true) ? colorInfo.brightGrey : idMenuBtn.firstTextDisableColor
        firstTextElide: "Right"
        buttonEnabled: (idMBand.menuBtnEnabledFlag == true)

        //KeyNavigation.left: idMenuBtn
        //KeyNavigation.right: idBackBtn

//        onWheelLeftKeyPressed: {
//            idBackBtn.focus = true
//            idBackBtn.forceActiveFocus()
//        }
        onWheelRightKeyPressed: {
            idBackBtn.focus = true
            idBackBtn.forceActiveFocus()
        }
    }

    // # BackKey button #
    MButton{
        id: idBackBtn
        x: 860+138+/*idMenuBtn.width*/138; y: 0
        width: 141; height: 72
        focus: (idMBand.menuBtnEnabledFlag == true) ? false : true /*(menuBtnFlag==false) ? true : false*/
        bgImage: imgFolderGeneral+"btn_title_back_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_back_p.png"
        bgImageFocus: imgFolderGeneral+"btn_title_back_f.png"

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                backBtnClicked()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

        //KeyNavigation.left: (idMenuBtn.visible && idMBand.menuBtnEnabledFlag==true) ? idMenuBtn : idBackBtn
        //KeyNavigation.right: idBackBtn

        onWheelLeftKeyPressed: {
            if(idMenuBtn.visible && idMBand.menuBtnEnabledFlag==true){
                idMenuBtn.focus = true
                idMenuBtn.forceActiveFocus()
            }
        }
//        onWheelRightKeyPressed: {
//            if(idMenuBtn.visible && idMBand.menuBtnEnabledFlag==true){
//                idMenuBtn.focus = true
//                idMenuBtn.forceActiveFocus()
//            }
//        }
    }

    function getFocusLastPosition()
    {
        if(idMBand.menuBtnEnabledFlag == true && idMenuBtn.focus == true){
            return "button1";
        }else if(idBackBtn.focus == true){
            return "button2";
        }
        return ""
    }

    function syncLastFocusPosition(lastPosion)
    {
        switch(lastPosion)
        {
            case "button1" : { idMenuBtn.focus = true; break; }
            case "button2" : { idBackBtn.focus = true; break; }
            default:
            {
                focusMenuBtn();
                break;
            }
        }
    }
}
