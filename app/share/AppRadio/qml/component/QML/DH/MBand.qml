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
 * - 2014-01-06 button position 141 -> 138
 */

import QtQuick 1.1
//import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent {
    id: idMBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderXMData : imageInfo.imgFolderXMData

    property string tabBtnText  : ""    //[user control] Text in band button
    property string tabBtnText2 : ""
    property string tabBtnText3 : ""
    property string tabBtnText4 : ""
    property string tabBtnText5 : ""

    property string selectedBand: ""
    property string titleText   : "" //[user control] Title`s Label Text
    property string subTitleText: "" //[user control] Sub Title`s Label Text
    property string subBtnText  : ""   //[user control] subBtn`s Text
    property string subWeekBtnText  : ""   //[user control] sub Week Key`s Text
    property string menuBtnText : ""  //[user contral] menuKey`s Text
    property string signalText  : ""  //[user control]
    property int signalTextSize : 24//30
    property int signalTextX    : 693//705//831 //710//672
    property int signalTextY    : 114-systemInfo.statusBarHeight-(signalTextSize/2)-2//129-systemInfo.statusBarHeight-(signalTextSize/2)
    property int signalTextWidth    : 150 //271//350
    property string signalTextColor : "#7CBDFF"
    property string signalTextAlies : "Right"
    property string signalImg   : ""
    property int signalImgX     : 0
    property int signalImgY     : 0
    property string reserveBtnText  : ""
    property string listIconImg : ""  //list Icon Image

    property int tabBtnCount    : 0
    property int listNumberCurrent  : 0  //[user control] current item number of list
    property int listNumberTotal    : 0  //[user control] total item number of list

    property bool tabBtnFlag    : false  //[user control] BandTab button On/Off
    property bool titleFavoriteImg  : false   //[user control] star image
    property bool signalTextFlag    : false   //[user control] signal Text On/Off
    property bool signalImgFlag : false
    property bool listNumberFlag: false   //[user control] list number On/Off
    property bool menuBtnFlag   : false   //[user contral] menu button On/Off
    property bool subBtnFlag    : false //[user control] Left button of backkey is On/Off (List button)
    property bool reserveBtnFlag: false
    property bool tunePress     : false //dg.jin 20141007 band tune press issue

    property string subBtnFgImage   : ""
    property string subBtnFgImageActive : ""
    property string subBtnFgImageFocus  : ""
    property string subBtnFgImageFocusPress : ""
    property string subBtnFgImagePress  : ""
    property int subBtnFgImageX : 41
    property int subBtnFgImageY : 6
    property int subBtnFgImageWidth : 60
    property int subBtnFgImageHeight: 60
    property int subBtnWidth    : 138
    property string subBtnBgImage   : imgFolderGeneral+"btn_title_sub_n.png"
    property string subBtnBgImagePress  : imgFolderGeneral+"btn_title_sub_p.png"
    //property string subBtnBgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"
    property string subBtnBgImageFocus  : imgFolderGeneral+"btn_title_sub_f.png"

    property string reserveBtnFgImage   : ""    //imgFolderRadio_SXM+"ico_sxm_info.png"
    property string reserveBtnFgImageActive : ""
    property string reserveBtnFgImageFocus  : ""
    property string reserveBtnFgImageFocusPress : ""
    property string reserveBtnFgImagePress  : ""   //imgFolderRadio_SXM+"ico_sxm_info.png"

    //KSW 130731 for premium UX
    property int reserveBtnFgImageX : 41
    property int reserveBtnFgImageY : 6
    property int reserveBtnFgImageWidth : 60
    property int reserveBtnFgImageHeight: 60

    //****************************** # Text Visible in Tab(120727) #
    property bool tabBtnTextVisible1    : true
    property bool tabBtnTextVisible2    : true
    property bool tabBtnTextVisible3    : true
    property bool tabBtnTextVisible4    : true
    property bool tabBtnTextVisible5    : true

    //****************************** # Button Enabled/Disable On/Off (130128) #    
    property bool tabBtnEnabledFlag1    : QmlController.radioBand==0x01 ? true : (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
    property bool tabBtnEnabledFlag2    : QmlController.radioBand==(tabBtnText2 == stringInfo.strHDBandAm ? 0x03 : 0x02) ? true : (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
    property bool tabBtnEnabledFlag3    : QmlController.radioBand==0x03 && (tabBtnText2 != stringInfo.strHDBandAm)? true : (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
    property bool tabBtnEnabledFlag4    : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)//true
    property bool tabBtnEnabledFlag5    : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)//true
    property bool reserveBtnEnabledFlag : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)////true
    property bool subBtnEnabledFlag     : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)////true
    property bool menuBtnEnabledFlag    : !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)////true

    //****************************** # Tab button selected Image (120712) #
    property string tabLine1: tabBtnEnabledFlag1==true ? imgFolderGeneral+"line_tab_01_s.png" : imgFolderGeneral+"line_tab_01_d.png"
    property string tabLine2: tabBtnEnabledFlag2==true ? imgFolderGeneral+"line_tab_02_s.png" : imgFolderGeneral+"line_tab_02_d.png"
    property string tabLine3: tabBtnEnabledFlag3==true ? imgFolderGeneral+"line_tab_03_s.png" : imgFolderGeneral+"line_tab_03_d.png"
    property string tabLine4: tabBtnEnabledFlag4==true ? imgFolderGeneral+"line_tab_04_s.png" : imgFolderGeneral+"line_tab_04_d.png"
    //property string tabLine5: tabBtnEnabledFlag5==true ? imgFolderGeneral+"line_tab_05_s.png" : imgFolderGeneral+"line_tab_05_d.png"


    //****************************** # Tab button n/p/fp/f Image (120712) #
    property string tabBtnDisable: imgFolderGeneral+"btn_title_normal_d.png"
    property string tabBtnNormal : imgFolderGeneral+"btn_title_normal_s.png"
    property string tabBtnPress  : imgFolderGeneral+"btn_title_normal_p.png"
    //property string tabBtnFocusPress: imgFolderGeneral+"btn_title_normal_fp.png"
    property string tabBtnFocus  : imgFolderGeneral+"btn_title_normal_f.png"

    //****************************** # fgImage in Tab(120727) #
    property string tabFgImage1:""//: imgFolderGeneral+"ico_title_bt_dial.png"
    property string tabFgImage2:""//: imgFolderGeneral+"ico_title_bt_recent.png"
    property string tabFgImage3:""//: imgFolderGeneral+"ico_title_bt_contact.png"
    property string tabFgImage4:""//: imgFolderGeneral+"ico_title_bt_fav.png"
    property string tabFgImage5:""//: imgFolderGeneral+"ico_title_bt_device.png"


    property bool isRDSMode : false

    //****************************** # Signal (when button clicked) #
    signal reserveBtnClicked()
    signal reserveBtnPressAndHold()
    signal subBtnClicked();
    signal menuBtnClicked();
    signal backBtnClicked(int mode);

    signal tabBtn1Clicked();
    signal tabBtn2Clicked();
    signal tabBtn3Clicked();
    signal tabBtn4Clicked();
    signal tabBtn5Clicked();

    property bool bandMirrorMode : false
//20130108 added by qutiguy - init tab menu focus when changing from DAB.
    function changeFocus(band)
    {
//        switch(band){
//        case "RDS_FM":
//        case "FM1":
//            idReserveBtn.forceActiveFocus()
//            break;
//        case "RDS_AM":
//        case "FM2":
//            idReserveBtn.forceActiveFocus()
//            break;
//        case "AM":
//            idReserveBtn.forceActiveFocus()
//            break;
//        }
        idReserveBtn.forceActiveFocus()
    }

    //****************************** # at first, tap not click #
    Component.onCompleted: {
        if(idTabBtn1.activeFocus)
            idTabBtn1.bgImagePress = ""
        else if(idTabBtn2.activeFocus)
            idTabBtn2.bgImagePress = ""
        else if(idTabBtn3.activeFocus)
            idTabBtn3.bgImagePress = ""
        else if(idTabBtn4.activeFocus)
            idTabBtn4.bgImagePress = ""
        else if(idTabBtn5.activeFocus)
            idTabBtn5.bgImagePress = ""
// 2013.09.10  added by qutiguy - focus spec.
        if((UIListener.GetCountryVariantFromQML() == 5) || (UIListener.GetCountryVariantFromQML() == 7))
            isRDSMode = true;
    }       

    //****************************** # Give force focus for focus & active sync (130112) #
    function giveForceFocus(focusPosition){
        if(focusPosition == 1) idTabBtn1.focus = true
        else if(focusPosition == 2) idTabBtn2.focus = true
        else if(focusPosition == 3) idTabBtn3.focus = true
        else if(focusPosition == 4) idTabBtn4.focus = true
        else if(focusPosition == 5) idTabBtn5.focus = true
        else if(focusPosition == "reserveBtm") idReserveBtn.focus = true;
        else if(focusPosition == "subBtn") idSubBtn.focus = true;
        else if(focusPosition == "menuBtn") idMenuBtn.focus = true;
        else if(focusPosition == "backBtn") idBackBtn.focus = true;
        else if(focusPosition == "leftend") { //ITS 0258832 dg.jin 20150226 CCP up focus change
            if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                idReserveBtn.focus = true;
            }
            else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
                idSubBtn.focus = true;
            }
            else if(idMenuBtn.visible){
                idMenuBtn.focus = true;
            }
            else{
                idBackBtn.focus = true;
            }
        }
    }

    //****************************** # Band Background Image #
    Image{
        x: 0; y: 0
        source: imgFolderGeneral+"bg_title.png"
        ///////////////////////////////////////
        //Added by qutiguy 0612 for debugging
        //trigger debug
        Item {
            anchors.centerIn: parent
            width: 50; height: 50
            MouseArea{
                anchors.fill: parent
                onPressAndHold: idAppMain.debugMode = false //KSW 131231-2 true -> false
            }
        }
    }

    //****************************** # Tab Button default background Image (120712)#
// 20130315 removed by qutiguy - cannot find variable tabBtnNormal. no need.
//    Image {
//        x: 5; y: 0
//        source: tabBtnNormal
//        visible: (tabBtnFlag==true) && (tabBtnCount==1 || tabBtnCount==2 || tabBtnCount==3 || tabBtnCount==4 || tabBtnCount==5)
//    }
//    Image {
//        x: 5+170; y: 0
//        source: tabBtnNormal
//        visible: (tabBtnFlag==true) && (tabBtnCount==2 || tabBtnCount==3 || tabBtnCount==4 || tabBtnCount==5)
//    }
//    Image {
//        x: 5+170+170; y: 0
//        source: tabBtnNormal
//        visible: (tabBtnFlag==true) && (tabBtnCount==3 || tabBtnCount==4 || tabBtnCount==5)
//    }
//    Image {
//        x:5+170+170+170; y: 0
//        source: tabBtnNormal
//        visible: (tabBtnFlag==true) && (tabBtnCount==4 || tabBtnCount==5)
//    }
//    Image {
//        x: 5+170+170+170+170; y: 0
//        source: tabBtnNormal
//        visible: (tabBtnFlag==true) && (tabBtnCount==5)
//    }

    //****************************** # Tab Button1~5 (2~4 120712)#
    MButtonOnlyRadio{
        id: idTabBtn1
        x: !bandMirrorMode ? 5 : 595+170+170+170; y: 0
        buttonName: tabBtnText      
        width: 170;
        height: systemInfo.titleAreaHeight
        //bgImageY : ((idTabBtn1.state == "normal" || idTabBtn1.state == "active" || idTabBtn1.state == "keyReless") && (!focusImageVisible))|| (!idTabBtn1.active) ? 0 : 2 // JSH 130802 TEST
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag1==true ? tabBtnNormal : tabBtnDisable

        visible: (tabBtnFlag==true) && (tabBtnCount==1 || tabBtnCount==2 || tabBtnCount==3 || tabBtnCount==4 || tabBtnCount==5)
        active: buttonName == selectedBand
        focus: true

        firstText: tabBtnText
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: idTabBtn1.activeFocus ? colorInfo.brightGrey : colorInfo.bandNormal //colorInfo.dimmedGrey //DH_PE
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible1
        firstTextElide: "Right"
        buttonEnabled: tabBtnEnabledFlag1

        fgImage: tabFgImage1
        fgImageActive: tabFgImage1
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50      

        Image{
            x: !bandMirrorMode ? 167 : 0;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn3.active || idTabBtn4.active || idTabBtn5.active
        }

        onClickOrKeySelected: {
            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) // JSH 130927
                return;

            if(isRDSMode){
                if(idTabBtn1.focus)
                    idTabBtn1.forceActiveFocus()
                else
                    idReserveBtn.forceActiveFocus()
            }
            else
                idTabBtn1.forceActiveFocus()
            selectedBand = buttonName
            tabBtn1Clicked()
        }

        //        onActiveFocusChanged: {
        //            if(idTabBtn1.activeFocus){
        //                idTabBtn1.bgImagePress = idMBand.tabBtnPress //""
        //                //idTabBtn1.firstTextPressColor = colorInfo.brightGrey
        //            }
        //            else{
        //                idTabBtn1.bgImagePress = idMBand.tabBtnPress
        //            }
        //        }

        //KeyNavigation.left: idBackBtn
        //KeyNavigation.right: tabBtnCount>1 ? idTabBtn2 : idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                // JSH 130916 looping deleted
                //idBackBtn.focus = true
                //idBackBtn.forceActiveFocus()
            }
            else{
                if(tabBtnCount>1){
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible && idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible&& idSubBtn.buttonEnabled){
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
            }
        } //# End onWheelLeftKeyPressed

        onWheelRightKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                if(tabBtnCount>1){
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible && idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible&& idSubBtn.buttonEnabled){
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
            }
            else{
                // JSH 130916 looping deleted
                //idBackBtn.focus = true
                //idBackBtn.forceActiveFocus()
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab1)


    MButtonOnlyRadio{
        id: idTabBtn2
        x: !bandMirrorMode ? 5+170 : 595+170+170
        y: 0
        buttonName: tabBtnText2
        width: 170;
        height: systemInfo.titleAreaHeight
        //bgImageY : ((idTabBtn2.state == "normal" || idTabBtn2.state == "active" || idTabBtn2.state == "keyReless") && (!idTabBtn2.focusImageVisible)) || (!idTabBtn2.active)? 0 : 2 // JSH 130802 TEST
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag2==true ? tabBtnNormal : tabBtnDisable
        visible: (tabBtnFlag==true) && (tabBtnCount==2 || tabBtnCount==3 || tabBtnCount==4 || tabBtnCount==5)
        active: buttonName == selectedBand
        focus: false

        firstText: tabBtnText2
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.bandNormal  //DH_PE
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible2
        firstTextElide: "Right"
        buttonEnabled: tabBtnEnabledFlag2

        fgImage: tabFgImage2
        fgImageActive: tabFgImage2
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        Image{
            x: !bandMirrorMode ? 167 : 0;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn1.active || idTabBtn4.active || idTabBtn5.active
        }

        onClickOrKeySelected: {
            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) // JSH 130927
                return;

            if(isRDSMode){
                if(idTabBtn2.focus)
                    idTabBtn2.forceActiveFocus()
                else
                   idReserveBtn.forceActiveFocus()
            }
            else
              idTabBtn2.forceActiveFocus()
            selectedBand = buttonName
            tabBtn2Clicked()
        }
        //        onActiveFocusChanged: {
        //            if(idTabBtn2.activeFocus){
        //                idTabBtn2.bgImagePress = idMBand.tabBtnPress //""
        //                idTabBtn2.firstTextPressColor = colorInfo.brightGrey
        //            }
        //            else{
        //                idTabBtn2.bgImagePress = idMBand.tabBtnPress
        //            }
        //        }
        //KeyNavigation.left: idTabBtn1
        //KeyNavigation.right: tabBtnCount>2 ? idTabBtn3 : idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                idTabBtn1.focus = true
                idTabBtn1.forceActiveFocus()
            }
            else{
                if(tabBtnCount>2){
                    idTabBtn3.focus = true
                    idTabBtn3.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            }
        }

        onWheelRightKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                if(tabBtnCount>2){
                    idTabBtn3.focus = true
                    idTabBtn3.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            }
            else{
                idTabBtn1.focus = true
                idTabBtn1.forceActiveFocus()
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab2)

    MButtonOnlyRadio{
        id: idTabBtn3
        x: !bandMirrorMode ?  5+170+170 : 595+170;
        y: 0
        buttonName: tabBtnText3
        width: 170;
        height: systemInfo.titleAreaHeight
        //bgImageY : ((idTabBtn3.state == "normal" || idTabBtn3.state == "active" || idTabBtn3.state == "keyReless") && (!focusImageVisible)) || (!idTabBtn3.active)? 0 : 2 // JSH 130802 TEST
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag3==true ? tabBtnNormal : tabBtnDisable
        visible: (tabBtnFlag==true) && (tabBtnCount==3 || tabBtnCount==4 || tabBtnCount==5)
        active: buttonName == selectedBand
        focus: false

        firstText: tabBtnText3
        firstTextX: firstText.length < 5 ? 18-5 : 8-4 // 18-5; , JSH131125 modify
        firstTextY: 128-systemInfo.statusBarHeight    //129-systemInfo.statusBarHeight
        firstTextWidth: firstText.length < 5 ? 143 : 160 //143 , JSH131125 modify
        firstTextSize : firstText.length < 5 ? 36  : 32  // JSH 130424 [SiriusXM]
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.bandNormal //DH_PE
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible3
        firstTextElide: "Right"
        buttonEnabled: tabBtnEnabledFlag3

        fgImage: tabFgImage3
        fgImageActive: tabFgImage3
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        onClickOrKeySelected: {
            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) // JSH 130927
                return;
//// 2013.11.08 modified by qutiguy : ITS 0194540 - Prevent chaning DAB if not ready
//            if(isRDSMode){
//                if(idTabBtn3.focus)
//                    idTabBtn3.forceActiveFocus()
//                else
//                    idReserveBtn.forceActiveFocus()
//            }
//            else
//              idTabBtn3.forceActiveFocus()
            if(isRDSMode)
                ;
            else
                idTabBtn3.forceActiveFocus();
////

            if(UIListener.GetCountryVariantFromQML() !=1 && UIListener.GetCountryVariantFromQML() !=6) // JSH 131025 , NA , Canada Exclusion
                if(!isRDSMode) // 2013.11.08 modified by qutiguy : ITS 0194540 - Prevent chaning DAB if not ready
                    selectedBand = buttonName

            tabBtn3Clicked()
        }

        Image{
            x: !bandMirrorMode ? 167 : 0;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn1.active || idTabBtn2.active || idTabBtn5.active
        }

        //        onActiveFocusChanged: {
        //            if(idTabBtn3.activeFocus){
        //                idTabBtn3.bgImagePress = idMBand.tabBtnPress //""
        //                idTabBtn3.firstTextPressColor = colorInfo.brightGrey
        //            }
        //            else{
        //                idTabBtn3.bgImagePress = idMBand.tabBtnPress
        //            }
        //        }
        //KeyNavigation.left: idTabBtn2
        //KeyNavigation.right: tabBtnCount>3 ? idTabBtn4 : idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                idTabBtn2.focus = true
                idTabBtn2.forceActiveFocus()
            }
            else{
                if(tabBtnCount>3){
                    idTabBtn4.focus = true
                    idTabBtn4.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            }
        }
        onWheelRightKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                if(tabBtnCount>3){
                    idTabBtn4.focus = true
                    idTabBtn4.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            }
            else{
                idTabBtn2.focus = true
                idTabBtn2.forceActiveFocus()
            }

        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab3)

    MButtonOnlyRadio{
        id: idTabBtn4
        x: !bandMirrorMode ? 5+170+170+170 : 595
        y: 0
        buttonName: tabBtnText4
        width: 170;
        height: systemInfo.titleAreaHeight
        //bgImageY : ((idTabBtn4.state == "normal" || idTabBtn4.state == "active" || idTabBtn4.state == "keyReless") && (!focusImageVisible)) || (!idTabBtn4.active) ? 0 : 2 // JSH 130802 TEST
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag4==true ? tabBtnNormal : tabBtnDisable
        visible: (tabBtnFlag==true) && (tabBtnCount==4 || tabBtnCount==5)
        active: buttonName == selectedBand
        focus: false

        firstText: tabBtnText4
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.bandNormal //DH_PE
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible4
        firstTextElide: "Right"
        buttonEnabled: tabBtnEnabledFlag4

        fgImage: tabFgImage4
        fgImageActive: tabFgImage4
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        Image{
            x: !bandMirrorMode ? 167 : 0;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn1.active || idTabBtn2.active || idTabBtn3.active
        }

        onClickOrKeySelected: {
            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) // JSH 130927
                return;

            idTabBtn4.forceActiveFocus()
            selectedBand = buttonName
            tabBtn4Clicked()
        }
        //        onActiveFocusChanged: {
        //            if(idTabBtn4.activeFocus){
        //                idTabBtn4.bgImagePress = idMBand.tabBtnPress //""
        //                idTabBtn4.firstTextPressColor = colorInfo.brightGrey
        //            }
        //            else{
        //                idTabBtn4.bgImagePress = idMBand.tabBtnPress
        //            }
        //        }
        //KeyNavigation.left: idTabBtn3
        //KeyNavigation.right: tabBtnCount>4 ? idTabBtn5 : idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                idTabBtn3.focus = true
                idTabBtn3.forceActiveFocus()
            }
            else{
                if(tabBtnCount>4){
                    idTabBtn5.focus = true
                    idTabBtn5.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            }
        }
        onWheelRightKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                if(tabBtnCount>4){
                    idTabBtn5.focus = true
                    idTabBtn5.forceActiveFocus()
                }
                else{
                    if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                        idReserveBtn.focus = true
                        idReserveBtn.forceActiveFocus()
                    }
                    else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            }
            else{
                idTabBtn3.focus = true
                idTabBtn3.forceActiveFocus()
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab4)

    MButtonOnlyRadio{
        id: idTabBtn5
        x: !bandMirrorMode ? 5+170+170+170+170 : 595 - 170
        y: 0
        buttonName: tabBtnText5
        width: 170;
        height: systemInfo.titleAreaHeight
        //bgImageY : ((idTabBtn5.state == "normal" || idTabBtn5.state == "active" || idTabBtn5.state == "keyReless") && (!focusImageVisible)) || (!idTabBtn5.active)? 0 : 2 // JSH 130802 TEST
        bgImagePress: tabBtnPress       
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnEnabledFlag5==true ? tabBtnNormal : tabBtnDisable
        visible: (tabBtnFlag==true) && tabBtnCount==5
        active: buttonName == selectedBand
        focus: false

        firstText: tabBtnText5
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.bandNormal //DH_PE
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible5
        firstTextElide: "Right"
        buttonEnabled: tabBtnEnabledFlag5

        fgImage: tabFgImage5
        fgImageActive: tabFgImage5
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        Image{
            x: !bandMirrorMode ? 167 : 0;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn1.active || idTabBtn2.active || idTabBtn3.active || idTabBtn5.active
        }

        onClickOrKeySelected: {
            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) // JSH 130927
                return;

            idTabBtn5.forceActiveFocus()
            selectedBand = buttonName
            tabBtn5Clicked()
        }
        //        onActiveFocusChanged: {
        //            if(idTabBtn5.activeFocus){
        //                idTabBtn5.bgImagePress = idMBand.tabBtnPress //""
        //                idTabBtn5.firstTextPressColor = colorInfo.brightGrey
        //            }
        //            else{
        //                idTabBtn5.bgImagePress = idMBand.tabBtnPress
        //            }
        //        }
       // KeyNavigation.left: idTabBtn4
        //KeyNavigation.right: idReserveBtn.visible ? idReserveBtn : idSubBtn.visible ? idSubBtn : idMenuBtn.visible ? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                idTabBtn4.focus = true
                idTabBtn4.forceActiveFocus()
            }
            else{
                if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
        }
        onWheelRightKeyPressed: {
            if(!buttonEnabled)
                return

            if(!bandMirrorMode){
                if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else if(idSubBtn.visible &&  idSubBtn.buttonEnabled){
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
            else{
                idTabBtn4.focus = true
                idTabBtn4.forceActiveFocus()
            }

        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab5)

    //****************************** # star image of Title front #
    Image{
        source: (titleFavoriteImg==true)? imgFolderXMData+"ico_title_fav.png" : ""
        x: 25; y: 104-systemInfo.statusBarHeight
        width: 48; height: 48
        visible: (titleFavoriteImg==true)
    }

    //****************************** # Tab Button selected One tab (120712) #
    Image{
        id: idTabCover
        x: !bandMirrorMode ? 0 : -1; y: 0; // JSH 130910 ITS [0188918]
        //width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight , JSH 130805 deleted
        //source: idTabBtn1.active? tabBtnSelected1 : idTabBtn2.active? tabBtnSelected2 : idTabBtn3.active? tabBtnSelected3 : idTabBtn4.active? tabBtnSelected4 : tabBtnSelected5
        source: idTabBtn1.active? tabLine1 : idTabBtn2.active? tabLine2 : idTabBtn3.active? tabLine3 : tabLine4
        visible: (tabBtnFlag==true)
    }

    //****************************** # Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: (titleFavoriteImg==true)? 25+58 : 46;
        y: 129-systemInfo.statusBarHeight-40/2
        width: txtTitle.paintedWidth//770;
        height: 40
        font.pixelSize: 40
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: (tabBtnFlag==false)
    }

    //****************************** # Sub Title Text #
    Text{
        id: txtSubTitle
        text: subTitleText
        x: (titleFavoriteImg==true)? 25+58+txtTitle.paintedWidth+23 : 45+txtTitle.paintedWidth+23;
        y: 129-systemInfo.statusBarHeight-40/2
        width: 830-txtTitle.paintedWidth-23; height: 40
        font.pixelSize: 40
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.dimmedGrey
        elide: Text.ElideRight
        visible: (tabBtnFlag==false)
    }

    //****************************** # List Icon #
    Image{
        id: iconList
        x: (listNumberFlag==true)? txtListNumber.x+146-txtListNumber.paintedWidth-45 : txtSignal.x+350-txtSignal.paintedWidth-45
        y: 106-systemInfo.statusBarHeight
        width: 44; height: 42
        source: listIconImg
    }

    //****************************** # List Number Text #
    Text{
        id: txtListNumber
        text: listNumberCurrent+"/" + listNumberTotal
        x: (menuBtnFlag==true)? (subBtnFlag==true)? (reserveBtnFlag==true)? 998-subBtnWidth-138-146 : 998-subBtnWidth-146 : 998-146 : (subBtnFlag==true)? (reserveBtnFlag==true)? 1136-subBtnWidth-138-146 : 1136-subBtnWidth-146 : 1136-146
        y: 129-systemInfo.statusBarHeight-30/2
        width: 146; height: 30
        font.pixelSize: 30
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:  "#7CBDFF" //RGB(124,189,255)
        visible: (listNumberFlag==true)
    }

    //****************************** # anything image #
    Image{
        source: signalImg
        x: signalImgX; y: signalImgY
        visible: (signalImgFlag==true)
    }

    //****************************** # Signal Text #
        Text{
            id: txtSignal
            x: signalTextX
            y: signalTextY
            clip: true
            text: signalText
            width: signalTextWidth ; height: idMBand.height//signalTextSize
            font.pixelSize: signalTextSize
            wrapMode : Text.Wrap // JSH 130523
            font.family: systemInfo.hdr//"HDR" //HDB
            horizontalAlignment: {
                if(signalTextAlies=="Right"){Text.AlignRight}
                else if(signalTextAlies=="Left"){Text.AlignLeft}
                else if(signalTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignRight}
            }
            //verticalAlignment: Text.AlignVCenter
            color: signalTextColor   //"#7CBDFF" //RGB(124,189,255)
            lineHeight: 0.8 // QtQuick 1.0 -> 1.1
            visible: (signalTextFlag==true)
            SequentialAnimation{
                id: sigAnimation
                running: txtSignal.visible //true
                loops: Animation.Infinite
                alwaysRunToEnd: true // JSH 130419 added
                NumberAnimation { target: txtSignal; property: "opacity"; to: 0.0; duration: 500 }
                NumberAnimation { target: txtSignal; property: "opacity"; to: 1.0; duration: 500 }
            }
        }

    //****************************** # ReseveBtn button #
    MButtonOnlyRadio{
        id: idReserveBtn
        x: (menuBtnFlag==true)? (subBtnFlag==true)? 998-subBtnWidth-138 : 998-138 : (subBtnFlag==true)? 1136-subBtnWidth-138 : 1136-138 //KSW 140106 998-subBtnWidth-138 - 6 -> 998-subBtnWidth-138
        width: 141; height: 72 //KSW 140106 138 -> 141
        focus: (tabBtnFlag==false) && (reserveBtnFlag==true) ? true : false
        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"
        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
        visible: (reserveBtnFlag==true)

        onClickOrKeySelected: {
            reserveBtnClicked()
        }
        onPressAndHold: {
            reserveBtnPressAndHold()
        }

        firstText: reserveBtnText
        firstTextX: 9; firstTextY: 37
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled: reserveBtnEnabledFlag

        //KSW 130731 for premium UX
        fgImageX: reserveBtnFgImageX//16
        fgImageY: reserveBtnFgImageY//11
        fgImageWidth: reserveBtnFgImageWidth//56
        fgImageHeight: reserveBtnFgImageHeight// 48
        fgImage: reserveBtnFgImage
        fgImageActive: reserveBtnFgImageActive
        fgImageFocus: reserveBtnFgImageFocus
        fgImageFocusPress: reserveBtnFgImageFocusPress
        fgImagePress: reserveBtnFgImagePress
//// 20130618 added by qutiguy - RDS
        clip: true

        //KeyNavigation.left: tabBtnCount==0 ? idReserveBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : tabBtnCount==3 ? idTabBtn3 : tabBtnCount==4 ? idTabBtn4 : idTabBtn5
        //KeyNavigation.right: idSubBtn.visible ? idSubBtn : idMenuBtn.visible? idMenuBtn : idBackBtn

        onWheelLeftKeyPressed: {

            if(!bandMirrorMode){
                if(!buttonEnabled)
                    return
                if(tabBtnCount==0){
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
                else if(tabBtnCount==1){
                    idTabBtn1.focus = true
                    idTabBtn1.forceActiveFocus()
                }
                else if(tabBtnCount==2){
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus()
                }
                else if(tabBtnCount==3){
                    idTabBtn3.focus = true
                    idTabBtn3.forceActiveFocus()
                }
                else if(tabBtnCount==4){
                    idTabBtn4.focus = true
                    idTabBtn4.forceActiveFocus()
                }
                else if(tabBtnCount==5){
                    idTabBtn5.focus = true
                    idTabBtn5.forceActiveFocus()
                }
            }
            else{
                if(!buttonEnabled)
                    return
                if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
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
        }
        onWheelRightKeyPressed: {
            if(!bandMirrorMode){
                if(!buttonEnabled)
                    return
                if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
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
            else{
                if(!buttonEnabled)
                    return
                if(tabBtnCount==0){
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
                else if(tabBtnCount==1){
                    idTabBtn1.focus = true
                    idTabBtn1.forceActiveFocus()
                }
                else if(tabBtnCount==2){
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus()
                }
                else if(tabBtnCount==3){
                    idTabBtn3.focus = true
                    idTabBtn3.forceActiveFocus()
                }
                else if(tabBtnCount==4){
                    idTabBtn4.focus = true
                    idTabBtn4.forceActiveFocus()
                }
                else if(tabBtnCount==5){
                    idTabBtn5.focus = true
                    idTabBtn5.forceActiveFocus()
                }
            }
        } //# End onWheelRightKeyPressed
    }
    //****************************** # subBtn button #
    MButtonOnlyRadio{
        id: idSubBtn
        x: (menuBtnFlag==true)? 998 - subBtnWidth : 1136 - subBtnWidth //KSW 140106 subBtnWidth-3 -> subBtnWidth
        y: 0
        width: 141; height: 72 //KSW 140106 subBtnWidth -> 141
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag) ? true : false
        bgImage: subBtnBgImage
        bgImagePress: subBtnBgImagePress
        //bgImageFocusPress: subBtnBgImageFocusPress
        bgImageFocus: subBtnBgImageFocus
        visible: (subBtnFlag==true)
        onClickOrKeySelected: {
            if(isRDSMode)
                idReserveBtn.forceActiveFocus()
            subBtnClicked()
        }

        firstText: subBtnText
        firstTextX: 9; firstTextY: 37      
        firstTextWidth: subBtnWidth - 15
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"    
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

        //KeyNavigation.left: idReserveBtn.visible ? idReserveBtn : tabBtnCount==0 ? idSubBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : tabBtnCount==3 ? idTabBtn3 : tabBtnCount==4 ? idTabBtn4 : idTabBtn5
        //KeyNavigation.right: idMenuBtn.visible? idMenuBtn : idBackBtn

        //# VisualCue Arrow (20130122)
//        onActiveFocusChanged: {
//            epgArrowUp = false
//            epgArrowDown = true
//            epgArrowLeft = false
//            epgArrowRight = true
//        }

        onWheelLeftKeyPressed: {

            if(!bandMirrorMode){
                if(!buttonEnabled)
                    return
                if(idReserveBtn.visible  &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else if(tabBtnCount==0){
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
                else if(tabBtnCount==1){
                    idTabBtn1.focus = true
                    idTabBtn1.forceActiveFocus()
                }
                else if(tabBtnCount==2){
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus()
                }
                else if(tabBtnCount==3){
                    idTabBtn3.focus = true
                    idTabBtn3.forceActiveFocus()
                }
                else if(tabBtnCount==4){
                    idTabBtn4.focus = true
                    idTabBtn4.forceActiveFocus()
                }
                else if(tabBtnCount==5){
                    idTabBtn5.focus = true
                    idTabBtn5.forceActiveFocus()
                }
            }
            else{
                if(!buttonEnabled)
                    return
                if(idMenuBtn.visible){
                    idMenuBtn.focus = true
                    idMenuBtn.forceActiveFocus()
                }
                else{
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
            }
        }
        onWheelRightKeyPressed: {

            if(!bandMirrorMode){
                if(!buttonEnabled)
                    return
                if(idMenuBtn.visible){
                    idMenuBtn.focus = true
                    idMenuBtn.forceActiveFocus()
                }
                else{
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
            }
            else{
                if(!buttonEnabled)
                    return
                if(idReserveBtn.visible  &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else if(tabBtnCount==0){
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
                else if(tabBtnCount==1){
                    idTabBtn1.focus = true
                    idTabBtn1.forceActiveFocus()
                }
                else if(tabBtnCount==2){
                    idTabBtn2.focus = true
                    idTabBtn2.forceActiveFocus()
                }
                else if(tabBtnCount==3){
                    idTabBtn3.focus = true
                    idTabBtn3.forceActiveFocus()
                }
                else if(tabBtnCount==4){
                    idTabBtn4.focus = true
                    idTabBtn4.forceActiveFocus()
                }
                else if(tabBtnCount==5){
                    idTabBtn5.focus = true
                    idTabBtn5.forceActiveFocus()
                }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(idSubBtn)

    //****************************** # Menu button #
    MButtonOnlyRadio{
        id: idMenuBtn
        x: !bandMirrorMode ? 998 : 3+138 ; y: 0
        width: 141; height: 72 //modify Menu button size HWS
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==false) && (menuBtnFlag==true) ? true : false
        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocusPress: imgFolderGeneral+"btn_title_sub_fp.png"
        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
        tunePressButton: tunePress  //dg.jin 20141007 band tune press issue
        visible: (menuBtnFlag==true)
        onClickOrKeySelected: {
            if(isRDSMode)
                idReserveBtn.forceActiveFocus()
            menuBtnClicked()
        }

        firstText: menuBtnText
        firstTextX: 9; firstTextY: 37 // 36 ,JSH 130716
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled: menuBtnEnabledFlag

        //KeyNavigation.left: idSubBtn.visible ? idSubBtn : idReserveBtn.visible? idReserveBtn : tabBtnCount==0 ? idMenuBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : tabBtnCount==3 ? idTabBtn3 : tabBtnCount==4? idTabBtn4 : idTabBtn5
        //KeyNavigation.right: idBackBtn

        //# VisualCue Arrow (20130122)
//        onActiveFocusChanged: {
//            epgArrowUp = false
//            epgArrowDown = true
//            epgArrowLeft = true
//            epgArrowRight = true
//        }

        onWheelLeftKeyPressed: {

            if(!bandMirrorMode){
                if(!buttonEnabled)
                    return
                if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
                    idSubBtn.focus = true
                    idSubBtn.forceActiveFocus()
                }
                else if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else{
                    if(tabBtnCount==0){
                        //KSW 140113 ITS/0219248 fixed bug
                        if(idMenuBtn.visible &&  idMenuBtn.buttonEnabled){
                            idMenuBtn.focus = true
                            idMenuBtn.forceActiveFocus()
                        }
                        else
                        {
                            idBackBtn.focus = true
                            idBackBtn.forceActiveFocus()
                        }
                    }
                    else if(tabBtnCount==1){
                        idTabBtn1.focus = true
                        idTabBtn1.forceActiveFocus()
                    }
                    else if(tabBtnCount==2){
                        idTabBtn2.focus = true
                        idTabBtn2.forceActiveFocus()
                    }
                    else if(tabBtnCount==3){
                        idTabBtn3.focus = true
                        idTabBtn3.forceActiveFocus()
                    }
                    else if(tabBtnCount==4){
                        idTabBtn4.focus = true
                        idTabBtn4.forceActiveFocus()
                    }
                    else if(tabBtnCount==5){
                        idTabBtn5.focus = true
                        idTabBtn5.forceActiveFocus()
                    }
                }
            }
            else{
                if(!buttonEnabled)
                    return
                idBackBtn.focus = true
                idBackBtn.forceActiveFocus()
            }
        } //# End onWheelLeftkeyPressed
        onWheelRightKeyPressed: {


            if(!bandMirrorMode){
                if(!buttonEnabled)
                    return
                idBackBtn.focus = true
                idBackBtn.forceActiveFocus()
            }
            else{
                if(!buttonEnabled)
                    return
                if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
                    idSubBtn.focus = true
                    idSubBtn.forceActiveFocus()
                }
                else if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else{
                    if(tabBtnCount==0){
                        idBackBtn.focus = true
                        idBackBtn.forceActiveFocus()
                    }
                    else if(tabBtnCount==1){
                        idTabBtn1.focus = true
                        idTabBtn1.forceActiveFocus()
                    }
                    else if(tabBtnCount==2){
                        idTabBtn2.focus = true
                        idTabBtn2.forceActiveFocus()
                    }
                    else if(tabBtnCount==3){
                        idTabBtn3.focus = true
                        idTabBtn3.forceActiveFocus()
                    }
                    else if(tabBtnCount==4){
                        idTabBtn4.focus = true
                        idTabBtn4.forceActiveFocus()
                    }
                    else if(tabBtnCount==5){
                        idTabBtn5.focus = true
                        idTabBtn5.forceActiveFocus()
                    }
                }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(idMenuBtn)
    function test(){
        return idMenuBtn;
    }
    //****************************** # BackKey button #
    MButtonOnlyRadio{
        id: idBackBtn
        //  x: !bandMirrorMode ? 1139: 3; y: 0 // x: 998+138; y: 0
        x: !bandMirrorMode ? 1136: 3 ; y: 0 // JSH 130825 Modify // KSW 140106 1139 -> 1136 (1136 = 860+138+138)
        width: 141; height: 72 //modify back button size HWS
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==false) && (menuBtnFlag==false) ? true : false
        bgImage: imgFolderGeneral+"btn_title_back_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_back_p.png"
        bgImageFocusPress: imgFolderGeneral+"btn_title_back_fp.png"
        bgImageFocus: imgFolderGeneral+"btn_title_back_f.png"
        tunePressButton: tunePress  //dg.jin 20141007 band tune press issue


        onClickOrKeySelected: {
            backBtnClicked(mode)
        }
        //KeyNavigation.left:  idMenuBtn.visible ? idMenuBtn : idSubBtn.visible? idSubBtn : idReserveBtn.visible? idReserveBtn : tabBtnCount==0 ? idBackBtn : tabBtnCount==1 ? idTabBtn1 : tabBtnCount==2 ? idTabBtn2 : tabBtnCount==3 ? idTabBtn3 : tabBtnCount==4 ? idTabBtn4 : idTabBtn5
        //KeyNavigation.right: idBackBtn

        //# VisualCue Arrow (20130122)
//        onActiveFocusChanged: {
//            epgArrowUp = false
//            epgArrowDown = true
//            epgArrowLeft = true
//            epgArrowRight = false
//        }

        onWheelLeftKeyPressed: {
            if(!bandMirrorMode){
                if((idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
                    return
                if(idMenuBtn.visible){
                    idMenuBtn.focus = true
                    idMenuBtn.forceActiveFocus()
                }
                else if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
                    idSubBtn.focus = true
                    idSubBtn.forceActiveFocus()
                }
                else if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else{
                    if(tabBtnCount==1){
                        idTabBtn1.focus = true
                        idTabBtn1.forceActiveFocus()
                    }
                    else if(tabBtnCount==2){
                        idTabBtn2.focus = true
                        idTabBtn2.forceActiveFocus()
                    }
                    else if(tabBtnCount==3){
                        idTabBtn3.focus = true
                        idTabBtn3.forceActiveFocus()
                    }
                    else if(tabBtnCount==4){
                        idTabBtn4.focus = true
                        idTabBtn4.forceActiveFocus()
                    }
                    else if(tabBtnCount==5){
                        idTabBtn5.focus = true
                        idTabBtn5.forceActiveFocus()
                    }
                }
            }
// JSH 130916 looping deleted
//            else{
//                if((idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
//                    return
//                if(tabBtnFlag==true){
//                    idTabBtn1.focus = true
//                    idTabBtn1.forceActiveFocus()
//                }
//                else{
//                    if(idReserveBtn.visible  &&  idReserveBtn.buttonEnabled){
//                        idReserveBtn.focus = true
//                        idReserveBtn.forceActiveFocus()
//                    }
//                    else if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
//                        idSubBtn.focus = true
//                        idSubBtn.forceActiveFocus()
//                    }
//                    else if(idMenuBtn.visible){
//                        idMenuBtn.focus = true
//                        idMenuBtn.forceActiveFocus()
//                    }
//                }
//            }
        } //# End onWheelLeftkeyPressed
        onWheelRightKeyPressed: {
            if(!bandMirrorMode){
// JSH 130916 looping deleted
//                if((idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
//                    return
//                if(tabBtnFlag==true){
//                    idTabBtn1.focus = true
//                    idTabBtn1.forceActiveFocus()
//                }
//                else{
//                    if(idReserveBtn.visible  &&  idReserveBtn.buttonEnabled){
//                        idReserveBtn.focus = true
//                        idReserveBtn.forceActiveFocus()
//                    }
//                    else if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
//                        idSubBtn.focus = true
//                        idSubBtn.forceActiveFocus()
//                    }
//                    else if(idMenuBtn.visible){
//                        idMenuBtn.focus = true
//                        idMenuBtn.forceActiveFocus()
//                    }
//                }
            }
            else{
                if((idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
                    return
                if(idMenuBtn.visible){
                    idMenuBtn.focus = true
                    idMenuBtn.forceActiveFocus()
                }
                else if(idSubBtn.visible  &&  idSubBtn.buttonEnabled){
                    idSubBtn.focus = true
                    idSubBtn.forceActiveFocus()
                }
                else if(idReserveBtn.visible &&  idReserveBtn.buttonEnabled){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else{
                    if(tabBtnCount==1){
                        idTabBtn1.focus = true
                        idTabBtn1.forceActiveFocus()
                    }
                    else if(tabBtnCount==2){
                        idTabBtn2.focus = true
                        idTabBtn2.forceActiveFocus()
                    }
                    else if(tabBtnCount==3){
                        idTabBtn3.focus = true
                        idTabBtn3.forceActiveFocus()
                    }
                    else if(tabBtnCount==4){
                        idTabBtn4.focus = true
                        idTabBtn4.forceActiveFocus()
                    }
                    else if(tabBtnCount==5){
                        idTabBtn5.focus = true
                        idTabBtn5.forceActiveFocus()
                    }
                }
            }
        } //# End onWheelRightkeyPressed
    } //# End MButton(idBackBtn)

    //****************************** # return currnet Focus , JSH 140211
    function getFocus(focusPosition){
        if(focusPosition == 1)                  { return idTabBtn1.focus;}
        else if(focusPosition == 2)             { return idTabBtn2.focus;}
        else if(focusPosition == 3)             { return idTabBtn3.focus;}
        else if(focusPosition == 4)             { return idTabBtn4.focus;}
        else if(focusPosition == 5)             { return idTabBtn5.focus;}
        else if(focusPosition == "reserveBtm")  { return idReserveBtn.focus;}
        else if(focusPosition == "subBtn")      { return idSubBtn.focus;}
        else if(focusPosition == "menuBtn")     { return idMenuBtn.focus;}
        else if(focusPosition == "backBtn")     { return idBackBtn.focus;}
    }
}
