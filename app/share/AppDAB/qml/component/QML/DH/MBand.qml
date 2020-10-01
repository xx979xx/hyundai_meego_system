/**
 * FileName: MBand.qml
 * Author: HYANG
 * Time: 2012-07
 *
 * - 2012-07 Initial Created by HYANG
 * - (Tab count max 5, focus added, wheel added)
 * - 2012-07-26 apply jog key, dialing principle
 * - 2012-07-27 add BT image in tab, add text visible flag
 * - 2012-07-30 add reserve button
 * - 2012-07-31 focus condition modify, tabBtnBtFlag delete, tabBtn`s focus start number add
 * - 2012-08-24 add list Icon Image
 * - 2012-10-24 add signalText`s property
 * - 2013-01-12 add Give force focus for focus & active sync (isv issue)
 * - 2013-02-23 change band gui (document 130222)
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent {
    id: idMBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: 72

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    property string tabBtnText: ""    //[user control] Text in band button
    property string tabBtnText2: ""
    property string tabBtnText3: ""

    property string selectedBand: ""
    property string titleText: "" //[user control] Title`s Label Text  
    property string subBtnText: ""   //[user control] subBtn`s Text
  
    property string menuBtnText: ""  //[user contral] menuKey`s Text
    property string signalText: ""  //[user control]
    property int signalTextSize: 30
    property int signalTextX: 672
    property int signalTextY: 129-systemInfo.statusBarHeight-(signalTextSize/2)
    property int signalTextWidth: 350
    property string signalTextColor: "#7CBDFF"
    property string signalTextAlies: "Right"
    property string signalTextStyle: idAppMain.fonts_HDB
    property string signalImg: ""
    property int signalImgX
    property int signalImgY
    property bool signalTextVariant: false
    property string signalTextVariantTickerEnable: ""
    property string reserveBtnText: ""

    property int tabBtnCount: 0
    property int listNumberCurrent: 0  //[user control] current item number of list
    property int listNumberTotal: 0  //[user control] total item number of list

    property bool tabBtnFlag: false  //[user control] BandTab button On/Off     
    property bool signalTextFlag: false   //[user control] signal Text On/Off
    property bool signalImgFlag: false
    property bool listNumberFlag: false   //[user control] list number On/Off
    property bool menuBtnFlag: false   //[user contral] menu button On/Off
    property bool subBtnFlag: false //[user control] Left button of backkey is On/Off (List button)   
    property bool reserveBtnFlag: false    

    property string subBtnFgImage: ""
    property string subBtnFgImageActive: ""
    property string subBtnFgImageFocus: ""
    property string subBtnFgImageFocusPress: ""
    property string subBtnFgImagePress: ""   
    property int subBtnFgImageX: 41
    property int subBtnFgImageY: 6
    property int subBtnFgImageWidth: 60
    property int subBtnFgImageHeight: 60
    property int subBtnWidth: 138
    property string subBtnBgImage: imgFolderGeneral+"btn_title_sub_n.png"
    property string subBtnBgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
    property string subBtnBgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"

    property int reserveBtnFgImageX: 41
    property int reserveBtnFgImageY: 6
    property int reserveBtnFgImageWidth: 60
    property int reserveBtnFgImageHeight: 60
    property int reserveBtnWidth: 138
    property string reserveBtnFgImage: ""    //imgFolderRadio_SXM+"ico_sxm_info.png"
    property string reserveBtnFgImageActive: ""
    property string reserveBtnFgImageFocus: ""
    property string reserveBtnFgImageFocusPress: ""
    property string reserveBtnFgImagePress: ""   //imgFolderRadio_SXM+"ico_sxm_info.png"

    //****************************** # Text Visible in Tab(120727) #
    property bool tabBtnTextVisible1: true
    property bool tabBtnTextVisible2: true
    property bool tabBtnTextVisible3: true

    //****************************** # Button Enabled/Disable On/Off (130128) #
    property bool tabBtnEnabledFlag1: true
    property bool tabBtnEnabledFlag2: true
    property bool tabBtnEnabledFlag3: true
    property bool reserveBtnEnabledFlag: true
    property bool subBtnEnabledFlag: true
    property bool menuBtnEnabledFlag: true  

    //****************************** # Tab button selected Image (120712) # 
    property string tabLine1: tabBtnEnabledFlag1==true ? imgFolderGeneral+"line_tab_01_s.png" : imgFolderGeneral+"line_tab_01_d.png"
    property string tabLine2: tabBtnEnabledFlag2==true ? imgFolderGeneral+"line_tab_02_s.png" : imgFolderGeneral+"line_tab_02_d.png"
    property string tabLine3: tabBtnEnabledFlag3==true ? imgFolderGeneral+"line_tab_03_s.png" : imgFolderGeneral+"line_tab_03_d.png"

    //****************************** # Tab button n/p/fp/f Image (120712) #
    property string tabBtnPress: imgFolderGeneral+"btn_title_normal_p.png"
    property string tabBtnFocus: imgFolderGeneral+"btn_title_normal_f.png"

    //****************************** # fgImage in Tab(120727) #
    property string tabFgImage1
    property string tabFgImage2
    property string tabFgImage3

    property QtObject idTab1Focus: idTabBtn1
    property QtObject idTab2Focus: idTabBtn2

    //****************************** # Signal (when button clicked) #
    signal reserveBtnClicked()
    signal subBtnClicked();
    signal menuBtnPressAndHold();
    signal menuBtnClicked();
    signal backBtnPressAndHold();
    signal backBtnClicked();
    signal tabBtn1Clicked();
    signal tabBtn2Clicked();
    signal tabBtn3Clicked();
    signal tabBtn1SelectkeyReleased();
    signal tabBtn2SelectkeyReleased();

    //****************************** # at first, tap not click #
    Component.onCompleted: {
        if(idTabBtn1.activeFocus)
            idTabBtn1.bgImagePress = ""
        else if(idTabBtn2.activeFocus)
            idTabBtn2.bgImagePress = ""
        else if(idTabBtn3.activeFocus)
            idTabBtn3.bgImagePress = ""   
    }       

    //****************************** # Give force focus for focus & active sync (130112) #
    function giveForceFocus(focusPosition){
        if(focusPosition == 1) idTabBtn1.focus = true
        else if(focusPosition == 2) idTabBtn2.focus = true
        else if(focusPosition == 3) idTabBtn3.focus = true
        else if(focusPosition == "reserveBtn") idReserveBtn.focus = true;
        else if(focusPosition == "subBtn") idSubBtn.focus = true;
        else if(focusPosition == "menuBtn") idMenuBtn.focus = true;
        else if(focusPosition == "backBtn") idBackBtn.focus = true;
    }

    //****************************** # Band Background Image #
    Image{
        x: 0; y: 0
        source: imgFolderGeneral+"bg_title.png"
    }

    //****************************** # Tab Button default background Image (120712)#
    //    Image {
    //        x: 5; y: 0
    //        source: tabBtnNormal
    //        visible: (tabBtnFlag==true) && (tabBtnCount==1 || tabBtnCount==2 || tabBtnCount==3)
    //    }
    //    Image {
    //        x: 5+170; y: 0
    //        source: tabBtnNormal
    //        visible: (tabBtnFlag==true) && (tabBtnCount==2 || tabBtnCount==3)
    //    }
    //    Image {
    //        x: 5+170+170; y: 0
    //        source: tabBtnNormal
    //        visible: (tabBtnFlag==true) && (tabBtnCount==3)
    //    }

    //****************************** # Tab Button1~5 (2~4 120712)#
    MButton{      
        id: idTabBtn1
        x: 5; y: 0
        buttonName: tabBtnText      
        width: 170;
        height: 72
        bgImagePress: tabBtnPress    
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag1==true ? imgFolderGeneral+"btn_title_normal_s.png" : imgFolderGeneral+"btn_title_normal_d.png"
        visible: (tabBtnFlag==true) && (tabBtnCount==1 || tabBtnCount==2 || tabBtnCount==3)
        active: buttonName == selectedBand        

        firstText: tabBtnText
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: idTabBtn1.activeFocus ? colorInfo.brightGrey : colorInfo.dimmedGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible1

        buttonEnabled: tabBtnEnabledFlag1

        fgImage: tabFgImage1
        fgImageActive: tabFgImage1
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50      

        Image{
            x: 167;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            // visible: idTabBtn3.active
        }     
        onSelectKeyReleased: {
            tabBtn1SelectkeyReleased();
        }
        onClickOrKeySelected: {
            tabBtn1Clicked()
        }

        //KeyNavigation.right: tabBtnCount>1 ? idTabBtn2 : idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn


        onWheelRightKeyPressed: {
            if(tabBtnCount>1){
                idTabBtn2.focus = true
                idTabBtn2.forceActiveFocus()
            }
            else{
                if(idReserveBtn.visible){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else if(idSubBtn.visible){
                    idSubBtn.focus = true
                    idSubBtn.forceActiveFocus()
                }
                else if(idMenuBtn.visible){
                    idMenuBtn.focus = true
                    idMenuBtn.forceActiveFocus()
                }
                else{
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab1)

    MButton{
        id: idTabBtn2
        x: 5+170;
        y: 0
        buttonName: tabBtnText2
        width: 170;
        height: 72
        bgImagePress: tabBtnPress      
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag2==true ? imgFolderGeneral+"btn_title_normal_s.png" : imgFolderGeneral+"btn_title_normal_d.png"
        visible: (tabBtnFlag==true) && (tabBtnCount==2 || tabBtnCount==3)
        active: buttonName == selectedBand        

        firstText: tabBtnText2
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: idTabBtn2.activeFocus ? colorInfo.brightGrey : colorInfo.dimmedGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible2

        buttonEnabled: tabBtnEnabledFlag2

        fgImage: tabFgImage2
        fgImageActive: tabFgImage2
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        Image{
            x: 167;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            //  visible: idTabBtn1.active
        }
        onSelectKeyReleased: {
            tabBtn2SelectkeyReleased();
        }

        onClickOrKeySelected: {
            tabBtn2Clicked()
        }

        //KeyNavigation.left: idTabBtn1
        //KeyNavigation.right: tabBtnCount>2 ? idTabBtn3 : idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: { idTabBtn1.focus = true }
        onWheelRightKeyPressed: {
            if(tabBtnCount>2){idTabBtn3.focus = true }
            else{
                if(idReserveBtn.visible){ idReserveBtn.focus = true }
                else if(idSubBtn.visible){ idSubBtn.focus = true }
                else if(idMenuBtn.visible){ idMenuBtn.focus = true }
                else{ idBackBtn.focus = true }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab2)

    MButton{
        id: idTabBtn3
        x: 5+170+170;
        y: 0
        buttonName: tabBtnText3
        width: 170;
        height: 72
        bgImagePress: tabBtnPress    
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag3==true ? imgFolderGeneral+"btn_title_normal_s.png" : imgFolderGeneral+"btn_title_normal_d.png"
        visible: (tabBtnFlag==true) && (tabBtnCount==3)
        active: buttonName == selectedBand
        focus: true

        firstText: tabBtnText3
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: idTabBtn3.activeFocus ? colorInfo.brightGrey : colorInfo.dimmedGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible3

        buttonEnabled: tabBtnEnabledFlag3

        fgImage: tabFgImage3
        fgImageActive: tabFgImage3
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50        

        Image{
            x: 167;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            //  visible: idTabBtn1.active || idTabBtn2.active
        }
        onClickOrKeySelected: {
            tabBtn3Clicked()
        }

        //KeyNavigation.left: idTabBtn2
        //KeyNavigation.right: idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: { idTabBtn2.focus = true }
        onWheelRightKeyPressed: {
            if(idReserveBtn.visible){ idReserveBtn.focus = true }
            else if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab3)

    //****************************** # Tab Button selected One tab (120712) #
    Image{
        id: idTabCover
        x: 0; y: 0;
        width: systemInfo.lcdWidth; height: 72
        source: idTabBtn1.active? tabLine1 : idTabBtn2.active? tabLine2 : tabLine3
        visible: (tabBtnFlag==true)
    }

    //****************************** # Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: 46;
        y: 129-systemInfo.statusBarHeight-40/2
        width: txtTitle.paintedWidth//770;
        height: 40
        font.pixelSize: 40
        font.family: idAppMain.fonts_HDB
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: (tabBtnFlag==false)
    }

    //****************************** # List Number Text #
    Text{
        id: txtListNumber
        text: listNumberCurrent+"/" + listNumberTotal
        x: (menuBtnFlag==true)? (subBtnFlag==true)? (reserveBtnFlag==true)? 998-(subBtnWidth)-138-146 : 998-(subBtnWidth)-146 : 998-146 : (subBtnFlag==true)? (reserveBtnFlag==true)? 1136-(subBtnWidth)-138-146 : 1136-(subBtnWidth)-146 : 1136-146
        y: 129-systemInfo.statusBarHeight-30/2
        width: 146; height: 30
        font.pixelSize: 30
        font.family: idAppMain.fonts_HDB
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:  "#7CBDFF" //RGB(124,189,255)
        visible: (listNumberFlag==true)
    }

    //****************************** # anything image #
    Image{
        id: imgSignal
        source: signalImg
        x: signalImgX; y: signalImgY
        visible: (signalImgFlag==true)
//        SequentialAnimation{
//            id: sigAnimation
//            running: m_bIsServiceNotAvailable
//            loops: Animation.Infinite
//            alwaysRunToEnd: true
//            NumberAnimation { target: imgSignal; property: "opacity"; to: 0.0; duration: 500 }
//            NumberAnimation { target: imgSignal; property: "opacity"; to: 1.0; duration: 500 }
//        }
    }

    MComp.MTickerText{
        id: txtSignal
        x: signalTextX     ; y: signalTextY
        width: signalTextWidth; height: signalTextSize
        tickerTextSpacing   : 120
        tickerText          : signalText
        tickerTextSize      : signalTextSize
        tickerTextColor     : signalTextColor   //"#7CBDFF" //RGB(124,189,255)
        tickerTextStyle     : signalTextStyle
        tickerTextAlies     : signalTextAlies
        variantText         : signalTextVariant
        variantTextTickerEnable : (m_bIsDrivingRegulation == false) && (txtSignal.overTextPaintedWidth == true) && (signalTextVariantTickerEnable)
        visible: (signalTextFlag==true)
    }

    //****************************** # ReseveBtn button #   
    MButton{
        id: idReserveBtn
        //x: (menuBtnFlag==true)? (subBtnFlag==true)? 998-(subBtnWidth)-138 : 998-138 : (subBtnFlag==true)? 1136-(subBtnWidth)-138 : 1136-138
        x: (menuBtnFlag==true)? (subBtnFlag==true)? 998-(subBtnWidth)-138: 998-138 : (subBtnFlag==true)? 1136-(subBtnWidth)-138 : 1136-138
        width: 141; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==true) ? true : false
        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
        visible: (reserveBtnFlag==true)

        onClickOrKeySelected: {
            idReserveBtn.focus = true
            reserveBtnClicked()
        }

        firstText: reserveBtnText
        firstTextX: 9; firstTextY: 37
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        buttonEnabled: reserveBtnEnabledFlag

        fgImageX: reserveBtnFgImageX    //16
        fgImageY: reserveBtnFgImageY    //11
        fgImageWidth: reserveBtnFgImageWidth    //88
        fgImageHeight: reserveBtnFgImageHeight  //48
        fgImage: reserveBtnFgImage
        fgImageActive: reserveBtnFgImageActive
        fgImageFocus: reserveBtnFgImageFocus
        fgImageFocusPress: reserveBtnFgImageFocusPress
        fgImagePress: reserveBtnFgImagePress

        //KeyNavigation.left: tabBtnCount==0 ? idReserveBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : idTabBtn3
        //KeyNavigation.right: idSubBtn.visible ? idSubBtn : idMenuBtn.visible? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(tabBtnCount==0){ idBackBtn.focus = true }
            else if(tabBtnCount==1){ idTabBtn1.focus = true }
            else if(tabBtnCount==2){ idTabBtn2.focus = true }
            else if(tabBtnCount==3){ idTabBtn3.focus = true }
        }
        onWheelRightKeyPressed: {
            if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    }

    //****************************** # subBtn button #
    MButton{
        id: idSubBtn
        x: (menuBtnFlag==true)? 998 - (subBtnWidth) : 1136 - (subBtnWidth)
        y: 0
        width: (menuBtnFlag==true)? 141 : 273; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag) ? true : false
        bgImage: subBtnBgImage
        bgImagePress: subBtnBgImagePress    
        bgImageFocus: subBtnBgImageFocus
        visible: (subBtnFlag==true)
        onClickOrKeySelected: {
            idSubBtn.focus = true
            subBtnClicked()
        }

        firstText: subBtnText
        firstTextX: 9; firstTextY: 37      
        firstTextWidth: subBtnWidth - 15
        firstTextSize: 30
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        buttonEnabled: subBtnEnabledFlag

        fgImageX: subBtnFgImageX
        fgImageY: subBtnFgImageY
        fgImageWidth: subBtnFgImageWidth
        fgImageHeight: subBtnFgImageHeight
        fgImage: subBtnFgImage
        fgImageActive: subBtnFgImageActive
        fgImageFocus: subBtnFgImageFocus
        fgImageFocusPress: subBtnFgImageFocusPress
        fgImagePress: subBtnFgImagePress

        //KeyNavigation.left: idReserveBtn.visible ? idReserveBtn : tabBtnCount==0 ? idSubBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : idTabBtn3
        //KeyNavigation.right: idMenuBtn.visible? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(idReserveBtn.visible){ idReserveBtn.focus = true }
            else if(tabBtnCount==0){ idBackBtn.focus = true }
            else if(tabBtnCount==1){ idTabBtn1.focus = true }
            else if(tabBtnCount==2){ idTabBtn2.focus = true }
            else if(tabBtnCount==3){ idTabBtn3.focus = true }
        }
        onWheelRightKeyPressed: {
            if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    } //# End MButton(idSubBtn)

    //****************************** # Menu button #
    MButton{
        id: idMenuBtn
        x: 998; y: 0
        width: 141; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==false) && (menuBtnFlag==true) ? true : false
        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"      
        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
        visible: (menuBtnFlag==true)

        onPressAndHold: { menuBtnPressAndHold(); }
        onClickOrKeySelected: {
            idMenuBtn.focus = true
            menuBtnClicked()
        }

        firstText: menuBtnText
        firstTextX: 9; firstTextY: 37
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        buttonEnabled: menuBtnEnabledFlag

        //KeyNavigation.left: idSubBtn.visible ? idSubBtn : idReserveBtn.visible? idReserveBtn : tabBtnCount==0 ? idMenuBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : idTabBtn3
        //KeyNavigation.right: idBackBtn

        onWheelLeftKeyPressed: {
            if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idReserveBtn.visible){ idReserveBtn.focus = true }
            else{
                if(tabBtnCount==0){ idMenuBtn.focus = true }
                else if(tabBtnCount==1){ idTabBtn1.focus = true }
                else if(tabBtnCount==2){ idTabBtn2.focus = true }
                else if(tabBtnCount==3){ idTabBtn3.focus = true }
            }
        } //# End onWheelLeftkeyPressed
        onWheelRightKeyPressed: {
            idBackBtn.focus = true            
        } //# End onWheelRightKeyPressed
    } //# End MButton(idMenuBtn)

    //****************************** # BackKey button #
    MButton{
        id: idBackBtn
        x: 1136; y: 0
        width: 141; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==false) && (menuBtnFlag==false) ? true : false
        bgImage: imgFolderGeneral+"btn_title_back_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_back_p.png"        
        bgImageFocus: imgFolderGeneral+"btn_title_back_f.png"

        onPressAndHold: { backBtnPressAndHold(); }
        onClickOrKeySelected: {
            idBackBtn.focus = true
            backBtnClicked()
        }
        //KeyNavigation.left:  idMenuBtn.visible ? idMenuBtn : idSubBtn.visible? idSubBtn : idReserveBtn.visible? idReserveBtn : tabBtnCount==0 ? idBackBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : idTabBtn3
        //KeyNavigation.right: idBackBtn

        onWheelLeftKeyPressed: {
            if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idReserveBtn.visible){ idReserveBtn.focus = true }
            else{
                if(tabBtnCount==1){ idTabBtn1.focus = true }
                else if(tabBtnCount==2){ idTabBtn2.focus = true }
                else if(tabBtnCount==3){ idTabBtn3.focus = true }
            }
        } //# End onWheelLeftkeyPressed
    } //# End MButton(idBackBtn)
}
