/**
 * FileName: RadioHdMain.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idRadioHdMain
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioHdStringInfo{ id: stringInfo }

    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property bool seekCueFlag: true //for SeekButton On/Off
    //////////////////////////////////////////////////////////
    // JSH 120306
    property string     stopSentMenu    : ""
    property string     hdSIS           : ""
    property string     test            : ""
    property bool       textType        : false
    property string     ptyImage        : ""
    property string     ptyText         : ""
    property string     hdPtyText       : ""
    property string     psText          : ""
    property string     jogFocusState   : ""        //# // JSH jog focus
    property string     prevJogFocusState: ""       //# // JSH Previous jog focus // JSH 130328
    property string     prevBandJogFocusState: ""   //dg.jin 20150227 bnad down jog focus
    property bool       touchflick      : false
    property string     selectedStationBtn : "1"
    property int        noSignal        : 0         // 0 : hd on or analog , 1 : mps no signal , 2 : sps no signal
    property string     presetAndDialBackground : "PresetList"
    property string     tempString1     : ""
    property string     tempString2     : ""
    //property int        prevBand                : 0               // JSH 130114 Test
    property int        langID           : UIListener.GetLanguageFromQML() // JSH 131203
    //////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////
    onActiveFocusChanged: {
        console.log("========================> idRadioHdMain onActiveFocusChanged :: ",activeFocus,jogFocusState)
        if(!idRadioHdMain.activeFocus){
            QmlController.setQmlFocusState(-1); // JSH 121228
            if(idAppMain.state == "AppRadioHdOptionMenu"){// JSH 130627
                arrowUp     = false
                arrowDown   = false
                arrowLeft   = false
                arrowRight  = false
            }
            ///////////////////////////////////////////////////////////////////////
            // JSH 130903 => 130913 modify , focus default position moved
            if(idRadioHdMain.jogFocusState == "Band"){ //  130924 added
                if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0 && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                    //dg.jin 20140721 ITS 0243422 Tagging focus Issues
                    if(!idAppMain.menuTaggingButton && (!QmlController.searchState) && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) && (idRadioHdMain.jogFocusState == "Band") && (idMBand.getFocus(1) || idMBand.getFocus(2))){
                        console.log(">>>>>>>>>>>>> No changed");
                    } else if(QmlController.getRadioDisPlayType() < 2)
                        idRadioHdMain.jogFocusState = "FrequencyDial";
                    else
                        idRadioHdMain.jogFocusState = "HDDisplay";
                }
                else{
                    //dg.jin 20140721 ITS 0243422 Tagging focus Issues
                    if(!idAppMain.menuTaggingButton && (!QmlController.searchState) && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) && (idRadioHdMain.jogFocusState == "Band") && (idMBand.getFocus(1) || idMBand.getFocus(2))){
                        console.log(">>>>>>>>>>>>> No changed");
                    } else if(idRadioHdMain.jogFocusState != "PresetList")
                        idRadioHdMain.jogFocusState = "PresetList";
                }
            }
            // end
            ///////////////////////////////////////////////////////////////////////
            // JSH 130906
            idAppMain.pressCancelSignal();
            //idRadioHdPresetList.changeListViewPosition(QmlController.getPresetIndex(QmlController.radioBand)-1);
            //idRadioHdPresetList.children[3].interactive = false;
            //end
            ///////////////////////////////////////////////////////////////////////
        }
        else{
            jogFocus(jogFocusState);
            //idRadioHdPresetList.children[3].interactive = true; // JSH 130906
        }
    }
    //////////////////////////////////////////////////////////////////
    MComp.MBand{
        id: idMBand
        x: 0; y: 0
        //****************************** # Tab button ON #
        selectedBand: (QmlController.radioBand==0x01)?stringInfo.strHDBandFm :(QmlController.radioBand==0x03)?stringInfo.strHDBandAm:""//globalSelectedBand    //first selected tab setting
        tabBtnFlag: true
        tabBtnCount: 3
        tabBtnText:  stringInfo.strHDBandFm
        tabBtnText2: stringInfo.strHDBandAm
        tabBtnText3: stringInfo.strHDBandSXm
        /////////////////////////////////////////////////////////////////
        // JSH 131203
        signalTextSize : (langID == 2) ? 28 : 24
        signalTextX    : 693
        signalTextY    : (langID == 2) ? 124-systemInfo.statusBarHeight-(signalTextSize/2)-2 : 114-systemInfo.statusBarHeight-(signalTextSize/2)-2
        /////////////////////////////////////////////////////////////////
        signalTextFlag: UIListener.GetCountryVariantFromQML()  != 6 ? signalText != "" : false // JSH 131002 modify
        onSignalTextFlagChanged: {
            if(signalTextFlag)
                UIListener.sendDataToCluster(); // JSH added 130502 , Acquiring Signal  [Opstate D-Radio Receiving]
        }
        signalText: ""//"Acquiring Signal"
        menuBtnFlag: true
        menuBtnText: stringInfo.strHDBandMenu
        focus: true
        subBtnFlag : UIListener.GetCountryVariantFromQML()  != 6 ? true : false // JSH 131002 modify
        subBtnText : stringInfo.strHDMenuTagSong
        subBtnEnabledFlag : idAppMain.menuTaggingButton && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
        onSubBtnClicked:{
            console.log(">>>>>>>>>>>>> MBand Tagging")
            if(!idAppMain.menuTaggingButton)
                return;

            QmlController.tagging();
        }
        onTabBtn1Clicked: {
            //Request to change for FM1
            //selectedBand = (QmlController.radioBand==0x01)?stringInfo.strHDBandFm :(QmlController.radioBand==0x03)?stringInfo.strHDBandAm:"" // JSH 131002 ITS [0192651]
            if(QmlController.radioBand != 0x01){// JSH 121025
                if(QmlController.getLastSpsFM1() != 0xFF)
                    UIListener.changeBandViaExternalMenu(0x26); // MODE_STATE_HDR_FM1
                else
                    UIListener.changeBandViaExternalMenu(0x01);
            }
        }
        onTabBtn2Clicked: {
            //Request to change for AM
            //selectedBand = (QmlController.radioBand==0x01)?stringInfo.strHDBandFm :(QmlController.radioBand==0x03)?stringInfo.strHDBandAm:"" // JSH 131002 ITS [0192651]

            if(QmlController.radioBand != 0x03){// JSH 121025
                if(QmlController.getLastSpsAM() != 0xFF)
                    UIListener.changeBandViaExternalMenu(0x28); // MODE_STATE_HDR_AM
                else
                    UIListener.changeBandViaExternalMenu(0x03);
            }
        }
        onTabBtn3Clicked: {
            //Request to change for SXM
            //selectedBand = (QmlController.radioBand==0x01)?stringInfo.strHDBandFm :(QmlController.radioBand==0x03)?stringInfo.strHDBandAm:"" // JSH 131002 ITS [0192651]
            UIListener.xmChange(); //JSH 111124 , XM CHANGE
        }
        //****************************** # button clicked or key selected #
        onMenuBtnClicked: {
            ////////////////////////////////////////////
            //// JSH 130610 Focus
            //if(idRadioHdMain.jogFocusState != "Band")
                //idRadioHdMain.jogFocusState = "Band"
            //giveForceFocus("menuBtn");
            ////////////////////////////////////////////
            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
                return;

            if(idAppMain.state == "AppRadioHdOptionMenu"){
                gotoBackScreen();
                return;
            }else if(idAppMain.state == "PopupRadioHdDimAcquiring"){ // JSH 130828
                gotoBackScreen();
            }

            setAppMainScreen( "AppRadioHdOptionMenu" , true);
        }
        onBackBtnClicked: {
            console.log("### BackKey Clicked ###")
            gotoBackScreen()
            //idRadioHdMain.jogFocusState = "Band"; // JSH Jog focus
        }
        Keys.onPressed: {
            if (event.key == Qt.Key_Down) {
                // JSH 130328 Add
                if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){ // JSH 130405 added
                    for(var i = 0; i < idMBand.children.length; i++){
                        if(idMBand.children[i].activeFocus){
                           // if(idMBand.children[i].x + idMBand.children[i].width < (idMBand.width/2)) //dg.jin 20150227 bnad down jog focus
                           if(prevBandJogFocusState == "PresetList") {   //dg.jin 20150227 bnad down jog focus
                                //dg.jin 20150227 ccp move while autostore focus issue
                                if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                                        && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                                    QmlController.changeChannel(0x01);
                                }
                                else {
                                    jogFocusState = "PresetList";
                                }
                            }
                            else{
                                if(QmlController.getRadioDisPlayType() > 1)
                                    jogFocusState = "HDDisplay";
                                else{
                                    jogFocusState = "FrequencyDial";
                                    //if (idAppMain.menuInfoFlag) // HD // JSH 130621 Info Window Delete
                                    //    idRadioHdMain.changeInfoState(2,false);// JSH 130604 added [Info on , band -> dial focus bug Fixed]
                                }
                            }
                            break;
                        }
                    }
                }else{
                    jogFocusState = "PresetList";
                }
            }
        }
        /////////////////////////////////////////////////////////////////
        //# focus change #JSH
        onActiveFocusChanged: { // JSH jog focus
            console.log("========================> Band onActiveFocusChanged :: ",idMBand.activeFocus,idRadioHdMain.jogFocusState)
            if(idRadioHdMain.jogFocusState == "Band" && idAppMain.state == "AppRadioHdMain" && (!idMBand.activeFocus))
                focus = true;

            //****************************** # Arrow On/Off of MVisualCue #
            if(idMBand.activeFocus){
                arrowUp = false
                arrowDown = true
                arrowLeft = false
                arrowRight = false
                QmlController.setQmlFocusState(2); // JSH 121228
                //if((idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) , JSH 130801 NA ITS[0182046,0182037] delete
                //    giveForceFocus("backBtn");
            }
        }
    }
    //****************************** # Content`s background Image (120725) #
//    Image{
//        x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
//        source: imageInfo.imgFolderRadio_Hd+"bg_menu.png"
//    }

    //****************************** # Frequency Dial View(FM) #
    RadioHdFmFrequencyDial{
        id: idRadioHdFmFrequencyDial
        //x: 691-60; y: systemInfo.headlineHeight-systemInfo.statusBarHeight-1

        // HD // JSH 130621 Info Window Delete
        //x: 691 - 60; y: menuInfoFlag || idAppMain.hdRadioOnOff ? systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391 : systemInfo.headlineHeight-1-systemInfo.statusBarHeight
        x: 691 - 60; y: idAppMain.hdRadioOnOff ? systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391 : systemInfo.headlineHeight-1-systemInfo.statusBarHeight
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        visible: globalSelectedBand != stringInfo.strHDBandAm

        Keys.onPressed: {
            if (event.key == Qt.Key_Left){
                if(QmlController.getPresetIndex(QmlController.radioBand) != 0xFF) //dg.jin 20150406 sometime show title icon
                {
                   if(QmlController.getRadioDisPlayType() == 1 && (!idRadioHdMain.noSignal)) // HD View JSH 130401[dial -> hd view] => 130403 Modify
                       QmlController.hdRadioChange(3,true);
                   else if(idRadioHdMain.noSignal == 2) //else if(idRadioHdMain.noSignal) , JSH 131009 modify
                       QmlController.hdRadioChange(2,true);
                }
                ///////////////////////////////////////////////////////////////////////////
                // JSH 130621 Info Window Delete
                //else if(idAppMain.fmInfoFlag)
                //   idRadioHdMain.changeInfoState(1,true); // Info display , Dial Down

                //dg.jin 20150227 ccp move while autostore focus issue
                if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                        && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                    QmlController.changeChannel(0x01);
                }
                else {
                    jogFocusState = "PresetList" // JSH jog focus
                }
            }
            else if (event.key == Qt.Key_Up){
                if((QmlController.getRadioDisPlayType() == 1)){// && (!idRadioHdFmFrequencyDial.isFocused)){ //130315 Focus Bug fixed
                    if(idRadioHdMain.noSignal == 2) //if(idRadioHdMain.noSignal) , JSH 131009 modify
                        QmlController.hdRadioChange(2); // No Signal View
                    else
                        QmlController.hdRadioChange(3); // HD Radio View //idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff
                }else{
                    jogFocusState = ((QmlController.getRadioDisPlayType())&&(QmlController.getHDRadioCurrentSPS()!=0xFF)) ? "HDDisplay" : "Band" //jogFocusState = "Band" // JSH jog focus
                }
            }
        }
        Behavior on y {enabled: idAppMain.state == "AppRadioHdMain";PropertyAnimation {id:idFreqFMYani; duration: 200;}}
        //Behavior on y {PropertyAnimation {id:idFreqFMYani; duration: 200;}}
        //////////////////////////////////////
        //KeyNavigation.up:((QmlController.getRadioDisPlayType())&&(QmlController.getHDRadioCurrentSPS()!=0xFF))?idRadioHdMenuHdRadioOn : idMBand //KeyNavigation.up: idMBand
        //KeyNavigation.left: idRadioHdPresetList
    }

    //****************************** # Frequency Dial View(AM) #
    RadioHdAmFrequencyDial{
        id: idRadioHdAmFrequencyDial
        //x: 691-60; y: systemInfo.headlineHeight-1-systemInfo.statusBarHeight

        // HD // JSH 130621 Info Window Delete
        //x: 691 - 60; y: menuInfoFlag || idAppMain.hdRadioOnOff ? systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391 : systemInfo.headlineHeight-1-systemInfo.statusBarHeight
        x: 691 - 60; y: idAppMain.hdRadioOnOff ? systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391 : systemInfo.headlineHeight-1-systemInfo.statusBarHeight
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        visible: globalSelectedBand == stringInfo.strHDBandAm

        Keys.onPressed: {
            if (event.key == Qt.Key_Left){
                if(QmlController.getPresetIndex(QmlController.radioBand) != 0xFF) //dg.jin 20150406 sometime show title icon
                {
                    if(QmlController.getRadioDisPlayType() == 1 && (!idRadioHdMain.noSignal)) // HD View JSH 130401[dial -> hd view] => 130403 Modify
                        QmlController.hdRadioChange(3,true);
                    else if(idRadioHdMain.noSignal == 2) //else if(idRadioHdMain.noSignal) , JSH 131009 modify
                        QmlController.hdRadioChange(2,true);
                }

                //dg.jin 20150227 ccp move while autostore focus issue
                if(QmlController.getPresetIndex(QmlController.radioBand) == 0xFF
                        && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                    QmlController.changeChannel(0x01);
                }
                else {
                    jogFocusState = "PresetList" // JSH jog focus
                }
            }
            else if (event.key == Qt.Key_Up){
                if((QmlController.getRadioDisPlayType() == 1)){//&& (!idRadioHdAmFrequencyDial.isFocused)){ //130315 Focus Bug fixed
                    if(idRadioHdMain.noSignal == 2) //if(idRadioHdMain.noSignal) , JSH 131009 modify
                        QmlController.hdRadioChange(2);
                    else
                        QmlController.hdRadioChange(3); // HD Radio View //idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff
                }else{
                    jogFocusState = ((QmlController.getRadioDisPlayType())&&(QmlController.getHDRadioCurrentSPS()!=0xFF))?"HDDisplay" : "Band" //jogFocusState = "Band"      // JSH jog focus
                }
            }
        }
        Behavior on y {enabled: idAppMain.state == "AppRadioHdMain" ; PropertyAnimation {id:idFreqAMYani;duration: 200;}}
        //Behavior on y {PropertyAnimation {id:idFreqAMYani;duration: 200;}}
        //KeyNavigation.up: ((QmlController.getRadioDisPlayType())&&(QmlController.getHDRadioCurrentSPS()!=0xFF))?idRadioHdMenuHdRadioOn : idMBand // KeyNavigation.up: idMBand
        //KeyNavigation.left: idRadioHdPresetList
    }
    //****************************** # Dial mask image when OptionMenu [Info On] or [HDRadio On] #
    Image{
        id:idDialMask
        x: 632+22; y: 487-systemInfo.statusBarHeight
        //z: (!(idAppMain.menuInfoFlag || idAppMain.hdRadioOnOff)) || (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        z: (idAppMain.hdRadioOnOff) && (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        source: imgFolderRadio_Hd+"bg_info_mask.png"
        //visible: (!idHdYani.running) //((idAppMain.menuInfoFlag || idAppMain.hdRadioOnOff)) // && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)))
        visible: ((idRadioHdAmFrequencyDial.y == systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391)
                 || (idRadioHdFmFrequencyDial.y == systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391))
                 && ((presetAndDialBackground != "FrequencyDial") || ((presetAndDialBackground == "FrequencyDial") && idAppMain.hdRadioOnOff))
    }

    //****************************** # Dial or HD Background #
    //****************************** # Background #
    Image{ // JSH 130706
        y:50
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ?  -1 : (((idRadioHdAmFrequencyDial.y == systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391)
                 || (idRadioHdFmFrequencyDial.y == systemInfo.headlineHeight-1-systemInfo.statusBarHeight + 391))
                 && ((presetAndDialBackground == "HDDisplay") || ((presetAndDialBackground == "FrequencyDial") && idAppMain.hdRadioOnOff))) ? 0 : -1
        //source: (presetAndDialBackground == "FrequencyDial") && (idAppMain.state == "AppRadioHdMain")? imgFolderRadio_Hd+"bg_menu_r.png" : "" //JSH 131108 ITS[0207844]
        source: (presetAndDialBackground == "FrequencyDial") || (presetAndDialBackground == "HDDisplay") ? imgFolderRadio_Hd+"bg_menu_r.png" : ""
        //visible: (QmlController.radioDisPlayType < 2) // JSH 131214
    }
    Image{
        id:idBackgroundImage
        //x: 484-(691-60) ;  z:1
        x: 484 - 6; y: systemInfo.headlineHeight-1-systemInfo.statusBarHeight ;  //z:1
        width: 803
        source: (presetAndDialBackground == "FrequencyDial") ||(presetAndDialBackground == "HDDisplay") ? imgFolderRadio_Hd+"bg_menu_r_s.png" : ""
    }
    //****************************** # Option Menu [Info On] #
    ///////////////////////////////////////////////////////////////////////////
    // JSH 130621 Info Window Delete
    //    RadioHdMenuInfoOn{
    //        id: idRadioHdMenuInfoOn
    //        x: 691-60;
    //        y: (idAppMain.menuInfoFlag) ? systemInfo.headlineHeight-1-systemInfo.statusBarHeight : -300 //y: systemInfo.headlineHeight-1-systemInfo.statusBarHeight JSH 130402 Y Animation Added
    //        z: -1                                                   // z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0   => JSH 130402  z -1 Changed
    //        visible: (idAppMain.menuInfoFlag || idInfoYani.running) // visible: idAppMain.menuInfoFlag  => JSH 130402 Y Animation Added
    //        /////////////////////////////////////////////////////////
    //        // JSH 130402 X -> Y Animation Changed
    //        Behavior on y { enabled: idAppMain.state == "AppRadioHdMain";PropertyAnimation {id:idInfoYani;duration: 200;}}
    //        /////////////////////////////////////////////////////////
    //        // JSH 130402 delete [AM ,HD Info Delete]
    //        //        property bool xAni : false
    //        //       onXAniChanged: {
    //        //           if(xAni)
    //        //               idXani.running = true
    //        //           else
    //        //               idXani.running = false
    //        //       }
    //        //        //////////////////////////////////////
    //        //        // 121218 Cover Animation
    //        //        Behavior on x {
    //        //            PropertyAnimation {id:idXani; from: 1280; duration: 100;}
    //        //        }
    //        //        //////////////////////////////////////
    //        /////////////////////////////////////////////////////////
    //        //JSH 130402 5sec Temr added
    //        Timer{
    //            id:idInfoTimer
    //            interval: 5000; running: true; repeat: false
    //            onTriggered: changeInfoState(1,idAppMain.fmInfoFlag);
    //        }
    //    }
    ///////////////////////////////////////////////////////////////////////////
    //****************************** # Option Menu [HD Radio On] #
    RadioHdMenuHdRadioOn{
        id: idRadioHdMenuHdRadioOn
        x: 493; //y: systemInfo.headlineHeight-systemInfo.statusBarHeight-1
        y: idAppMain.hdRadioOnOff ? 173 - systemInfo.statusBarHeight-1 : -300 //-600
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled || idHdYani.running) ? -1 : 0
        visible: (idAppMain.hdRadioOnOff || idHdYani.running)
        onActiveFocusChanged:{
            console.log("========================> HDDisplay onActiveFocusChanged :: ",idRadioHdMenuHdRadioOn.activeFocus,idRadioHdMain.jogFocusState)
            if((idRadioHdMain.jogFocusState == "HDDisplay") && (idAppMain.state == "AppRadioHdMain") && (!idRadioHdMenuHdRadioOn.activeFocus))
                focus = true;

            if(idRadioHdMenuHdRadioOn.activeFocus){
                arrowUp = true
                arrowDown = true // false
                arrowLeft = true
                arrowRight = false
                QmlController.setQmlFocusState(3);
            }
        }
        Behavior on y { enabled: idAppMain.state == "AppRadioHdMain";PropertyAnimation {id:idHdYani; duration: 200;}}
        //Behavior on y {PropertyAnimation {id:idHdYani; duration: 200;}} // JSH 130527 Modify [ITS 0168283 bug Fixed]
    }

    //****************************** # Preset ChannelList #
    //RadioHdPresetList{
    //    id: idRadioHdPresetList
        //objectName: "RadioHdPresetList"
    //    x: 0; y: 174-systemInfo.statusBarHeight
    //    visible: false
        //focus: true
        /////////////////////////////////////////////////////////////////
        //******* JSH 130130 delete *********
        //        Keys.onPressed: {
        //            if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
        //                return;

        //            if (event.key == Qt.Key_Right && menuInfoFlag)
        //                jogFocusState = "PresetList"
        //            else if (event.key == Qt.Key_Right && (!idAppMain.hdRadioOnOff))
        //                jogFocusState = "FrequencyDial"
        //            else if (event.key == Qt.Key_Right && idAppMain.hdRadioOnOff)
        //                jogFocusState = "HDDisplay"
        //            else if (event.key == Qt.Key_Up)
        //                jogFocusState = "Band"
        //        }
        //        KeyNavigation.up: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? idRadioHdPresetList : idMBand
        //        KeyNavigation.right: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled || menuInfoFlag) ? idRadioHdPresetList : idAppMain.hdRadioOnOff ? idRadioHdMenuHdRadioOn : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial //JSH 120511
        /////////////////////////////////////////////////////////////////
        //# focus change #JSH
   //     onActiveFocusChanged: { // JSH jog focus
    //        console.log("========================> PresetList onActiveFocusChanged :: ",idRadioHdPresetList.activeFocus,idRadioHdMain.jogFocusState)
   //         if((idRadioHdMain.jogFocusState == "PresetList") && (idAppMain.state == "AppRadioHdMain") && (!idRadioHdPresetList.activeFocus))
   //             focus = true;

            //****************************** # Arrow On/Off of MVisualCue #
   //         if(idRadioHdPresetList.activeFocus){
   //             if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
   //                 idAppMain.arrowUp   = true
   //                 idAppMain.arrowDown = false
   //                 idAppMain.arrowLeft = false
   //                 idAppMain.arrowRight= true
//                    // Preset Focus or Tune No.1
//                    if((QmlController.getPresetIndex(QmlController.radioBand) == 0xFF)
//                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){

//                        QmlController.changeChannel(0x01);
//                    }
   //             }
   //             else{
   //                 idAppMain.arrowUp   = true
   //                 idAppMain.arrowDown = false
   //                 idAppMain.arrowLeft = false
   //                 idAppMain.arrowRight= false
   //             }
   //             QmlController.setQmlFocusState(0); // JSH 121228
   //         }
   //     }
   // }

    RadioHdPresetListFM{
        id: idRadioHdPresetListFM
        //objectName: "RadioHdPresetList"
        x: 0; y: 174-systemInfo.statusBarHeight
        //visible: globalSelectedBand != stringInfo.strHDBandAm
        //# focus change #JSH
        onActiveFocusChanged: { // JSH jog focus
            if(globalSelectedBand == stringInfo.strHDBandAm)
                return;

            console.log("========================> PresetList onActiveFocusChanged :: ",idRadioHdPresetListFM.activeFocus,idRadioHdMain.jogFocusState)
            if((idRadioHdMain.jogFocusState == "PresetList") && (idAppMain.state == "AppRadioHdMain") && (!idRadioHdPresetListFM.activeFocus))
                focus = true;

            //****************************** # Arrow On/Off of MVisualCue #
            if(idRadioHdPresetListFM.activeFocus){
                if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
                    idAppMain.arrowUp   = true
                    idAppMain.arrowDown = false
                    idAppMain.arrowLeft = false
                    idAppMain.arrowRight= true
//                    // Preset Focus or Tune No.1
//                    if((QmlController.getPresetIndex(QmlController.radioBand) == 0xFF)
//                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){

//                        QmlController.changeChannel(0x01);
//                    }
                }
                else{
                    idAppMain.arrowUp   = true
                    idAppMain.arrowDown = false
                    idAppMain.arrowLeft = false
                    idAppMain.arrowRight= false
                }
                QmlController.setQmlFocusState(0); // JSH 121228
            }
        }
    }

    RadioHdPresetListAM{
        id: idRadioHdPresetListAM
        //objectName: "RadioHdPresetList"
        x: 0; y: 174-systemInfo.statusBarHeight
        //visible: globalSelectedBand == stringInfo.strHDBandAm
        
        onActiveFocusChanged: { // JSH jog focus
            if(globalSelectedBand != stringInfo.strHDBandAm)
                return;

            console.log("========================> PresetList onActiveFocusChanged :: ",idRadioHdPresetListAM.activeFocus,idRadioHdMain.jogFocusState)
            if((idRadioHdMain.jogFocusState == "PresetList") && (idAppMain.state == "AppRadioHdMain") && (!idRadioHdPresetListAM.activeFocus))
                focus = true;

            //****************************** # Arrow On/Off of MVisualCue #
            if(idRadioHdPresetListAM.activeFocus){
                if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
                    idAppMain.arrowUp   = true
                    idAppMain.arrowDown = false
                    idAppMain.arrowLeft = false
                    idAppMain.arrowRight= true
//                    // Preset Focus or Tune No.1
//                    if((QmlController.getPresetIndex(QmlController.radioBand) == 0xFF)
//                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){

//                        QmlController.changeChannel(0x01);
//                    }
                }
                else{
                    idAppMain.arrowUp   = true
                    idAppMain.arrowDown = false
                    idAppMain.arrowLeft = false
                    idAppMain.arrowRight= false
                }
                QmlController.setQmlFocusState(0); // JSH 121228
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////
    // JSH 130321
    //****************************** # HD LOGO Image #
    Image{
        id:idHdLogo
        x: 493+78; y: 173-systemInfo.statusBarHeight+15
        z: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? -1 : 0
        source: imgFolderRadio_Hd+"ico_hd_radio_d.png"
        visible: (idAppMain.hdSignalPerceive && (!QmlController.getRadioDisPlayType()))
    }
    //****************************** # Scan Image #
    Image{
        id: scanIcon
        property bool bShowIcon : true ;
        x: 1208; y: 179-systemInfo.statusBarHeight-1
        width: 57; height: 57
        source: imgFolderRadio+"ico_radio_scan.png"
        visible: ((menuScanFlag || menuPresetScanFlag) && bShowIcon)
        opacity: 1
        /////////////////////////////////////////////////////////////////
        Timer{
            id : scanIconTimer
            interval : 500
            running : (menuScanFlag || menuPresetScanFlag)
            repeat : true
            onTriggered : {scanIcon.bShowIcon = !scanIcon.bShowIcon;}
        }
        /////////////////////////////////////////////////////////////////
    }
    //****************************** # Auto Tune Image #
    Image{
        x: 1208; y: 179-systemInfo.statusBarHeight-1
        width: 57; height: 57
        source: imgFolderRadio+"ico_radio_autotune.png"
        visible: menuAutoTuneFlag
    }
    ////////////////////////////////////////////////////////////////////////
    //****************************** # Preset Save & EDIT , Dim Background Image #
    Image {
        id: imgSaveBgDim
        //x: idRadioHdPresetList.x-20; y: systemInfo.titleAreaHeight ;z:-1
        x: idRadioHdPresetListFM.x-2; y: systemInfo.titleAreaHeight-50 ;z:-1
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        source: imgFolderRadio_Hd + "bg_dim.png"
        //opacity: 0.6
        visible: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
        MouseArea{
            anchors.fill: parent;
            onPressed: {return;}
        }
    }

    //****************************** # Menu Open when clicked I, L, Slash key #
    onClickMenuKey:{
        if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
            return;

        if(idAppMain.state == "AppRadioHdOptionMenu"){
            gotoBackScreen()
            return;
        }else if(idAppMain.state == "PopupRadioHdDimAcquiring"){ // JSH 130828
            gotoBackScreen();
        }

        setAppMainScreen( "AppRadioHdOptionMenu" , true);
    }

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed: gotoBackScreen()

    ////////////////////////////////////////////////////////////////////////////////////
    // JSH Connections Elements
    Connections{
        target : QmlController
        onChangeQmlFocusState:{ // JSH 140106
            switch(st){
            case -1: break;
            case 0 : // preset
                if(globalSelectedBand == stringInfo.strHDBandAm)
                {
                    if(!idRadioHdPresetListAM.activeFocus){
                        if(jogFocusState == "PresetList")
                            jogFocus(jogFocusState);
                        else
                            jogFocusState = "PresetList";
                    }
                }
                else
                {
                    if(!idRadioHdPresetListFM.activeFocus){
                        if(jogFocusState == "PresetList")
                            jogFocus(jogFocusState);
                        else
                            jogFocusState = "PresetList";
                    }
                }
                break;
            case 1 : // Dial
                if(globalSelectedBand == stringInfo.strHDBandAm){
                    if(!idRadioHdAmFrequencyDial.activeFocus){
                        if(jogFocusState == "FrequencyDial")
                            jogFocus(jogFocusState);
                        else
                            jogFocusState = "FrequencyDial";
                    }
                }
                else{
                    if(!idRadioHdFmFrequencyDial.activeFocus){
                        if(jogFocusState == "FrequencyDial")
                            jogFocus(jogFocusState);
                        else
                            jogFocusState = "FrequencyDial";
                    }
                }
                break;
//            case 2 : // Band
                if(!idMBand.activeFocus){
                    if(jogFocusState == "Band")
                        jogFocus(jogFocusState);
                    else
                        jogFocusState = "Band";
                }
                break;
            case 3 : // HD
                if(!idRadioHdMenuHdRadioOn.activeFocus){
                    if(jogFocusState == "HDDisplay")
                        jogFocus(jogFocusState);
                    else
                        jogFocusState = "HDDisplay";
                }
                break;
            default: break;
            }
        }
        onHdSignalPerceive:{
            idAppMain.hdSignalPerceive = onoff;

            ///////////////////////////////////////////////////////////////////////////
            // JSH 130621 Info Window Delete
            //if(idAppMain.fmInfoFlag && idAppMain.hdSignalPerceive) // JSH 130402 added
            //    idRadioHdMain.changeInfoState(1,false)

            console.log("======================>onHdSignalPerceive",idAppMain.hdSignalPerceive)
        }
        onChangeScanFreq:{
            console.log(" HJIGKS: [RadioHDMain] onChangeScanFreq Occured!!!!");
            if (band != QmlController.radioBand) // band , radio band intger
                return;

            if (band < 0x03 && ("FM1" == idAppMain.globalSelectedBand || "FM2" == idAppMain.globalSelectedBand )){// FM1, FM2 Band String
                var frequency = freq;

                //////////////////////////////////////////////////
                // JSH 130710 Modify
                //idAppMain.globalSelectedFmFrequency = frequency
                if(QmlController.searchState)
                    idAppMain.globalSelectedFmFrequency = frequency
                else{
                    if(QmlController.radioFreq != frequency)
                        idAppMain.globalSelectedFmFrequency = QmlController.radioFreq
                    else
                        idAppMain.globalSelectedFmFrequency = frequency
                }
                //////////////////////////////////////////////////

            }else{                                             // AM Band
                var frequency = freq ;
                //////////////////////////////////////////////////
                // JSH 130710 Modify
                //idAppMain.globalSelectedAmFrequency = frequency //AM Freq
                if(QmlController.searchState)
                    idAppMain.globalSelectedAmFrequency = frequency
                else{
                    if(QmlController.radioFreq != frequency)
                        idAppMain.globalSelectedAmFrequency = QmlController.radioFreq
                    else
                        idAppMain.globalSelectedAmFrequency = frequency
                }
                //////////////////////////////////////////////////

            }

            if(QmlController.searchState != 0x00) // JSH 121012 (alreadySaved) not used
                idAppMain.alreadySaved = true;
        }
        onChangeSearchState: {
            // 20130227 added by qutiguy - to check search start point
            console.log(" [Notice] onChangeSearchState mode : " + value);
            if(value == 0xFF) // JSH 131111
                UIListener.sendDataToOSD(2); //STAY_TIMEOUT
            else if (value != 0)
                UIListener.sendDataToOSD(1); //STAY
            else if (value == 0)
                UIListener.sendDataToOSD(2); //STAY_TIMEOUT
            //
            if( value == 0 && stopSentMenu.length > 0 )
            {
                console.log(" HJIGKS : [RadioFMBand] onChangeSearchState value: " + value);
                changeBand();
            }

            if(QmlController.searchState == 0x00) // JSH 121012 (alreadySaved) not used
                idAppMain.alreadySaved = false;
        }
        onChangeVariant:{
            idAppMain.startFmFrequency = fmFirst        //# Variant frequency FM start value
            idAppMain.startAmFrequency = amFirst        //# Variant frequency AM start value
            idAppMain.endFmFrequency   = fmEnd          //# Variant frequency FM end value
            idAppMain.endAmFrequency   = amEnd          //# Variant frequency AM end value
            idAppMain.stepFmFrequency  = fmStep         //# Variant frequency FM step value
            idAppMain.stepAmFrequency  = amStep         //# Variant frequency AM step value
            idAppMain.preset_Num       = preset_Num
        }
        //onChangePtyImage:{ptyImage = ptyImg;} // JSH 130528 deleted
        onChangePty:{
            if(QmlController.getRadioDisPlayType() == 0){//if(!idAppMain.hdRadioOnOff){
                idRadioHdMain.ptyText   = ptyString;
                //idRadioHdMain.hdPtyText = ""; // JSH 131211 deleted , when RBDS Display -> HD receive -> Menu HD Radio off -> PTY delete issue
            } else if(QmlController.getRadioDisPlayType() == 3){
                //idRadioHdMain.ptyText   = ""; // JSH 131211 deleted , when RBDS Display -> HD receive -> Menu HD Radio off -> PTY delete issue
                idRadioHdMain.hdPtyText = ptyString
            }
        }
        onChangePs:idRadioHdMain.psText = psName;
        onChangeRT:idAppMain.rtText = rtName;
        onHdRadioChangeSignal:{
            // HD Radio DISPLAY CHANGE 120329 JSH type
            // 130109
            switch(type){
            case 0 : {// type 0 : HD OFF
                console.log("======================>onHdRadioChangeSignal HD OFF")

                idAppMain.menuHdRadioFlag   = idAppMain.hdRadioOnOff = false
                ////////////////////////////////////////////////////////////////////////
                // JSH 131009 deleted [hdreset() Moved] => 131212 init error added
                //idRadioHdMain.noSignal      = 0;
                //QmlController.setNoSignal(idRadioHdMain.noSignal); // JSH 130503 added
                if(QmlController.getNoSignal() == 0)
                    idRadioHdMain.noSignal      = 0;
                ////////////////////////////////////////////////////////////////////////
                idRadioHdMain.selectedStationBtn = "1";

                ////////////////////////////////////////////////////
                // JSH 130402 delete [HD Info Delete]
                // if(idAppMain.infoFlag){
                //     idAppMain.menuInfoFlag  = idAppMain.infoFlag;
                //     idAppMain.infoFlag      = false;
                // }
                ////////////////////////////////////////////////////

                //if((idAppMain.state == "AppRadioHdMain") && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                //if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
                if((!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) && (!noFocus)){
                    if(jogFocusState == "HDDisplay")//if(QmlController.getPresetIndex(QmlController.radioBand)-1 < 12) , JSH 130820 Modify
                        jogFocusState = "FrequencyDial"
                }
                /////////////////////////////////////////////////////////////////////////////////////////////////////////
                //// JSH 131211 Info On/OFF Check added
                if(QmlController.radioBand == 1)
                    idAppMain.menuInfoFlag = idAppMain.fmInfoFlag
                /////////////////////////////////////////////////////////////////////////////////////////////////////////
                break;
            }
            case 1 :{// type 1 : HD Acqire
                console.log("======================>onHdRadioChangeSignal HD Acqire")

                ////////////////////////////////////////////////////
                // JSH 130402 delete [HD Info Delete]
                // if(idAppMain.menuInfoFlag){
                //     idAppMain.infoFlag      = idAppMain.menuInfoFlag;
                //     idAppMain.menuInfoFlag  = false;
                // }
                ////////////////////////////////////////////////////

                idAppMain.menuHdRadioFlag   = idAppMain.hdRadioOnOff =  false

                //if((idAppMain.state == "AppRadioHdMain") && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                //if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
                if((!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) && (!noFocus)){
                    jogFocusState = "FrequencyDial"
                }
                //else if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled){ // JSH 131007 TEST
                //    if(jogFocusState != "PresetList")
                //       jogFocusState = "PresetList"
                //}
                break;
            }
            case 2:{ // type 2 : HD[sps] No Signal
                // idRadioHdMain.noSignal -> 0 : hd on or analog , 1 : mps no signal , 2 : sps no signal
                idAppMain.menuHdRadioFlag   = idAppMain.hdRadioOnOff = true;
                idRadioHdMain.noSignal      = 2;
                QmlController.setNoSignal(idRadioHdMain.noSignal); // JSH 130503 added
                console.log("====================onNoSignal ==>",idRadioHdMain.noSignal)

                UIListener.sendDataToCluster(); // JSH added 130502 ,Cluster No Signal[ Opstate D-Radio Signal Weak ]
                //if((idAppMain.state == "AppRadioHdMain") && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)))
                //if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
                if((!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) && (!noFocus)){ // JSH 130402 Modify
                    if(jogFocusState == "FrequencyDial")
                        jogFocusState = "HDDisplay";
                }
                //else if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled){
                //    if(jogFocusState != "PresetList")
                //       jogFocusState = "PresetList"
                //}

                if(QmlController.radioBand == 1) //changeInfoState(1,false); // JSH 130621 Info Window Delete
                    idAppMain.menuInfoFlag = false
                break;
            }
            case 3 :{// type 3 : HD ON
                console.log("======================>onHdRadioChangeSignal HD ON")
                //////////////////////////////////////////////////////////////////
                // JSH 131226 , weak signal -> on signal
                if(QmlController.getNoSignal()){
                    if(idAppMain.psdTitle != "" && idAppMain.psdArtist  != "")
                        idAppMain.menuTaggingButton = true
                    else
                        idAppMain.menuTaggingButton = false
                }
                //////////////////////////////////////////////////////////////////
                idRadioHdMain.noSignal      = 0;
                QmlController.setNoSignal(idRadioHdMain.noSignal); // JSH 130503 added
                idAppMain.menuHdRadioFlag   = idAppMain.hdRadioOnOff = true

                //////////////////////////////////////////////////////
                // JSH 131025 dial press cancel => 131210 Modify
                if(idRadioHdFmFrequencyDial.bManualTouch){
                    //idRadioHdFmFrequencyDial.bManualTouch   = false
                    console.log("[CHECK_11_14_DRAG] : RadioHdMain.qml -> FM  bManualTouch = " + idRadioHdFmFrequencyDial.bManualTouch );
                    idAppMain.globalSelectedFmFrequency = idRadioHdFmFrequencyDial.rollBackFrequency;
                    idRadioHdFmFrequencyDial.bManualTouch = false;
                }else if(idRadioHdAmFrequencyDial.bManualTouch){
                    //idRadioHdAmFrequencyDial.bManualTouch   = false
                    console.log("[CHECK_11_14_DRAG] : RadioHdMain.qml -> AM  bManualTouch = " + idRadioHdAmFrequencyDial.bManualTouch );
                    idAppMain.globalSelectedAmFrequency = idRadioHdAmFrequencyDial.rollBackFrequency;
                    idRadioHdAmFrequencyDial.bManualTouch = false;
                }
                idAppMain.touchAni                      = false
                ////////////////////////////////////////////////////
                // JSH 130402 delete [HD Info Delete]
                // if(idAppMain.infoFlag){
                //     idAppMain.menuInfoFlag  = idAppMain.infoFlag;
                //     idAppMain.infoFlag      = false;
                // }
                ////////////////////////////////////////////////////

                //if((idAppMain.state == "AppRadioHdMain") && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)))
                //if((!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                if((!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)) && (!noFocus)){
                    //////////////////////////////////////////////////////
                    // JSH 130418  => JSH 130820 Modify [focus Move [dial -> hd , preset -> preset , (preset == 0xFF) -> hd]] , -> 131214 modify
                    //if((QmlController.getPresetIndex(QmlController.radioBand) >= 0xF0 || jogFocusState == "FrequencyDial") && (!QmlController.searchState))
                    if((QmlController.getPresetIndex(QmlController.radioBand) >= 0xF0 || jogFocusState == "FrequencyDial")
                            && (!QmlController.searchState) && (jogFocusState != "Band")){
                        jogFocusState = "HDDisplay";
                    }else if(QmlController.searchState && (jogFocusState == "FrequencyDial")){
                        jogFocusState = "HDDisplay";
                    }
                }
                //else if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled){
                //    if(jogFocusState != "PresetList")
                //       jogFocusState = "PresetList"
                //}

                if(QmlController.radioBand == 1) //changeInfoState(1,false); // JSH 130621 Info Window Delete
                    idAppMain.menuInfoFlag = false
                break;
            }
            default: break;
            }
        }
        onHdDetecingSignal:{
            textType = type
            if(onoff){  // popup display ON / OFF
                if(type == 4)
                    idMBand.signalText = stringInfo.strHDMsgWeakSignal
                else{
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // If additional space is Korean , JSH 131009 modify =>JSH 131113 modify
                    idMBand.signalText = stringInfo.strHDPopupAcquiring;
                    //idMBand.signalText = (UIListener.GetLanguageFromQML() == 2) ? "      " + stringInfo.strHDPopupAcquiring : stringInfo.strHDPopupAcquiring ;
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                }
                ///////////////////////////////////////////////////////////////////////////
                // JSH 130621 Info Window Delete
                //if(idAppMain.fmInfoFlag && (!idAppMain.hdSignalPerceive)) // JSH 130402 added
                //    idRadioHdMain.changeInfoState(1,false)
            }
            else
                idMBand.signalText = "";
        }

        onMessageDisplay:{
            // Tag Message , TBD.....
            var str = msg;
            if(str.substr(0,11) == "Song Alread"){
                /////////////////////////////////////////////////////////////////////////////////////////
                // JSH 130826 Modify => JSH 130826 restore
                if(idAppMain.state != "AppRadioHdMain")
                    gotoBackScreen();

                idAppMain.strPopupText1 = stringInfo.strHDPopupIpodTagAlreadyTaggingged;  // idAppMain.toastMessage =  "Song Already Taggingged"//container.str_MSG_IPOD_TAG_ALREADYTAGGINGGED
                idAppMain.strPopupText3 = idAppMain.strPopupText2 = "";
                //idAppMain.toastMessage              = stringInfo.strHDPopupIpodTagAlreadyTaggingged;
                //idAppMain.toastMessageSecondText    = "";
                //setAppMainScreen( "PopupRadioHdDimAcquiring" , true);
                /////////////////////////////////////////////////////////////////////////////////////////
            }
            else if(str.substr(0,11) == "Song Taggin"){
                idAppMain.strPopupText1 = stringInfo.strHDPopupTaggingFailed;              // idAppMain.toastMessage = "Song Tagging Failed"//container.str_MSG_IPOD_TAG_FAIL
                idAppMain.strPopupText3 = idAppMain.strPopupText2 = "";
            }
            else if(str.substr(0,11) == "TagCaptured"){ // TagCaptured
                idAppMain.toastMessage              = stringInfo.strHDPopupTagCaptured;
                idAppMain.toastMessageSecondText    = str.substr(12,str.length)
                if(idAppMain.state != "AppRadioHdMain") // JSH 130817
                    gotoBackScreen();

                setAppMainScreen( "PopupRadioHdDimAcquiring" , true);                    // idDimPopup.visible = true
            }
            //            else if(msg == "Song tags transferred to iPod")
            //                idAppMain.toastMessage = "Song tags transferred to iPod"
            else if(str.substr(0,11) == "Memory Full"){//!! Please connect iPod to transfer song tags"){
                ///////////////////////////////////////////////////////////////////////////////
                // JSH 130909 modify
                //idAppMain.strPopupText1 = stringInfo.strHDPopupIpodMemoryFull1;          // idAppMain.toastMessage = "Memory Full!! Please connect iPod to transfer song tags"
                //idAppMain.strPopupText2 = stringInfo.strHDPopupIpodMemoryFull2;
                //idAppMain.strPopupText3 = stringInfo.strHDPopupIpodMemoryFull3;
                var message     = stringInfo.strHDPopupIpodMemoryFull3;
                var message1    = "";
                var message2    = "";

                if(message.indexOf(".") < (message.length-1))
                    message1 = message.substr(0,message.indexOf(".")+2);
                else if(message.indexOf("!") < (message.length-1))
                    message1 = message.substr(0,message.indexOf("!")+2);

                idAppMain.strPopupText1 = message1;
                message2 = message.substr(idAppMain.strPopupText1.length ,message.length-idAppMain.strPopupText1.length);
                idAppMain.strPopupText2 = message2;
                ///////////////////////////////////////////////////////////////////////////////
            }
            else if(str.substr(0,11) == "Tag is ambi"){ // TAG is ambiguous
                //TAG is ambiguous TagCaptured_%1/%2"

                //                if(tempString1 == "TAG is ambiguous"){
                //                    tempString1 = "";
                //                    tempString2 = "";
                //                    return;
                //                }

                //idAppMain.toastMessage              =  tempString1 = "TAG is ambiguous";
                //idAppMain.toastMessageSecondText    =  tempString2 = stringInfo.strHDPopupTagCaptured + " " + str.substr(15,str.length)
                idAppMain.toastMessage              = stringInfo.strHDPopupTagAmbiguous; //"Tag is ambiguous";
                idAppMain.toastMessageSecondText    = stringInfo.strHDPopupTagCaptured + " " + str.substr(16,str.length)

                ///////////////////////////////////////////////////////////////
                // JSH 130817 Modify
                if(idAppMain.state != "AppRadioHdMain")
                    gotoBackScreen();

                setAppMainScreen( "PopupRadioHdDimAcquiring" , true);
                //                if(idAppMain.state != "PopupRadioHdDimAcquiring")
                //                    setAppMainScreen( "PopupRadioHdDimAcquiring" , true);                    // idDimPopup.visible = true
                //                else{
                //                    idAppMain.gotoBackScreen();
                //                    setAppMainScreen( "PopupRadioHdDimAcquiring" , true);
                //                    //ambigousTimer.restart();
                //                }
                ///////////////////////////////////////////////////////////////
            }
            else if(str.substr(0,11) == "Storing Tag"){
                if(idAppMain.state != "AppRadioHdMain")  // JSH 130826 added
                    gotoBackScreen();

                idAppMain.toastMessage              = stringInfo.strHDPopupTagStoring;      //"Storing Tag..."
                idAppMain.toastMessageSecondText    = stringInfo.strHDPopupTagPleaseWait;   //"Please  Wait..."
                setAppMainScreen( "PopupRadioHdDimAcquiring" , true);
            }
        }
        onChangeTagButtonEnable : { // JSH 140211
            if(idAppMain.menuTaggingButton && (!enable) && (!QmlController.searchState) && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
                if((jogFocusState == "Band")&&(idMBand.getFocus("subBtn"))){
                   //dg.jin 20140721 ITS 0243422 Tagging focus Issues
                   jogFocusState = "Band"
                   //dg.jin 20150227 when tag button disable focus band -> menu
                   //idMBand.giveForceFocus(QmlController.radioBand==0x01 ? 1 : 2);
                   idMBand.giveForceFocus("menuBtn");
                   // if(QmlController.getRadioDisPlayType() < 2)
                   //     jogFocusState = "FrequencyDial"
                   // else
                   //     jogFocusState = "HDDisplay"
                }
            }
            idAppMain.menuTaggingButton = enable;
        }
    } // End Connections
    Connections{
        target : UIListener
        //        onPressCancelSignal:{ // JSH 131030
        //            idAppMain.pressCancelSignal(); // JSH 131030 preset press cancel
        //        }
        onRetranslateUi: { // JSH 130724 , ITS [0181510] Issue
            langID = languageId // JSH 131204
            if(idMBand.signalText != ""){
                //idMBand.signalText = (UIListener.GetLanguageFromQML() == 2) ? "      " + stringInfo.strHDPopupAcquiring : stringInfo.strHDPopupAcquiring ; // korea space add
                idMBand.signalText = stringInfo.strHDPopupAcquiring; // JSH 131113 Modify
            }
        }
        onSigTuneDial:{
            //////////////////////////////////////////////////////////////////////
            // JSH 130514 added
            //idAppMain.popupClose();
            //tuneKey(direction,1);
            console.log("------------------RadioHdMain_onSigTuneDial Start")
            idAppMain.initMode() // JSH 130625
            idAppMain.doNotUpdate = true;
            idAppMain.popupClose(true);
            tuneKey(direction,1);
            idAppMain.pressCancelSignal(); // JSH 131030 preset press cancel
            if(QmlController.getRadioDisPlayType() < 2){
                jogFocusState =  "FrequencyDial"
                console.log("------------------RadioHdMain_onSigTuneDial jogFocusState = FrequencyDial")
            }else if((QmlController.getRadioDisPlayType() > 1) && (QmlController.getPresetIndex(QmlController.radioBand) > 12)){
                jogFocusState =  "HDDisplay"
                console.log("------------------RadioHdMain_onSigTuneDial jogFocusState = HDDisplay")

            }
            idAppMain.doNotUpdate = false;
            console.log("------------------RadioHdMain_onSigTuneDial END")
        }
        onSigJogDial:{
            console.log("------------------onSigJogDial Start")
            idAppMain.initMode() // JSH 130625
            idAppMain.doNotUpdate = true;
            tuneKey(direction,2);
            if(QmlController.getRadioDisPlayType() < 2){
                jogFocusState =  "FrequencyDial"
                console.log("------------------onSigJogDial jogFocusState = FrequencyDial")
            }
            idAppMain.doNotUpdate = false;
             console.log("------------------onSigJogDial END")
        }
        onSigChangeBand:{
            console.log(" onSigChangeBand  " + band);
            ///////////////////////////////////////////////////////////////////////////////////////////////
            //JSH 131024 RadioHdMain.qml[onSigChangeBand] => RadioHdPresetList.qml[onSignalUpdateModelData] moved
            //            var prevFocus         = idRadioHdMain.jogFocusState;
            //            var prevPresetIndex   = idRadioHdPresetList.currentIndex;
            //            var prevGlobalBand    = idAppMain.globalSelectedBand;
            //if(globalSelectedBand == "AM")
            //{
                idRadioHdPresetListAM.prevFocus           = idRadioHdMain.jogFocusState;
                idRadioHdPresetListAM.prevPresetIndex     = idRadioHdPresetListAM.currentIndex;
                idRadioHdPresetListAM.prevGlobalBand      = idAppMain.globalSelectedBand;
            //}
            //else
            //{
                idRadioHdPresetListFM.prevFocus           = idRadioHdMain.jogFocusState;
                idRadioHdPresetListFM.prevPresetIndex     = idRadioHdPresetListFM.currentIndex;
                idRadioHdPresetListFM.prevGlobalBand      = idAppMain.globalSelectedBand;
            //}
            ///////////////////////////////////////////////////////////////////////////////////////////////

            ///////////////////////////////////////////////////////////////////////////////////////////////
            //// Edit Preset Order Bug Modify ## JSH 130129 => 130422[Menu On Focus Error Modify]
            //if((band != QmlController.radioBand && idAppMain.state == "AppRadioHdMain") // JSH 130706 deleted [focus bug]
            if((band != QmlController.radioBand && (idAppMain.state == "AppRadioHdMain" || (!idAppMain.globalMenuAnimation)))){
                    //&& (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){ // JSH 131007 deleted [ Focus does not disappear bug]
                if(((QmlController.radioBand == 0x01) && (band != 0x26)) || ((QmlController.radioBand == 0x02) && (band != 0x27)) // JSH 131007 added
                        || ((QmlController.radioBand == 0x03) && (band != 0x28))){

                    if(globalSelectedBand == stringInfo.strHDBandAm)
                    {
                        idRadioHdPresetListAM.currentIndex = idAppMain.preset_Num - 1;
                    }
                    else
                    {
                        idRadioHdPresetListFM.currentIndex = idAppMain.preset_Num - 1;
                    }
                }

                idRadioHdMain.jogFocusState =  ""
                idAppMain.initMode() // JSH 130625
            }
            /////////////////////////////////////////////////////////////

            switch(band){
            case 0x01 : {console.log("------------------FM1 ");setBand("FM1");break;}
            case 0x02 : {console.log("------------------FM2 ");setBand("FM2");break;}
            case 0x03 : {console.log("------------------AM  ");setBand("AM") ;break;}
            case 0x26 : {console.log("------------------HD_FM1");setBand("FM1");break;}
            case 0x27 : {console.log("------------------HD_FM2");setBand("FM2");break;}
            case 0x28 : {console.log("------------------HD_AM");setBand("AM") ;break;}
            default: {
                if(idAppMain.globalSelectedBand == "FM1" || idAppMain.globalSelectedBand == "FM2")
                    idMBand.selectedBand = stringInfo.strHDBandFm
                else
                    idMBand.selectedBand = stringInfo.strHDBandAm
                break;
            }
            }

            ///////////////////////////////////////////////////////////////////////////////////////////////
            //JSH 131024 RadioHdMain.qml[onSigChangeBand] => RadioHdPresetList.qml[onSignalUpdateModelData] moved
            //            //if(idAppMain.state == "AppRadioHdMain" && (!(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled))){ // JSH 130706 deleted [focus bug]
            //            if((idAppMain.state == "AppRadioHdMain" || (!idAppMain.globalMenuAnimation)) && (!(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled))){
            //                if((prevGlobalBand  == idAppMain.globalSelectedBand) && (band  > 0x03)){ // when FG [or HD Display]
            //                    idRadioHdPresetList.currentIndex = prevPresetIndex;
            //                    idRadioHdMain.jogFocusState = prevFocus;
            //                }
            //                else{               // when AV MODE
            //                    /////////////////////////////////////////////////////////////
            //                    // JSH 130819 Modify
            //                    //if(prevGlobalBand != idAppMain.globalSelectedBand)//if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0) // JSH 130429 added [do not update the preset]
            //                    //    idRadioHdPresetList.currentIndex    = 0; // Model Changed [Index No.1 Select]
            //                    //idRadioHdPresetList.changeState();
            //                    if(prevGlobalBand != idAppMain.globalSelectedBand){ // JSH 130429 added [do not update the preset]
            //                        idRadioHdPresetList.currentIndex    = 0;        // Model Changed [Index No.1 Select]
            //                        idRadioHdPresetList.changeState();
            //                    }else{
            //                        idAppMain.doNotUpdate = true;
            //                        idRadioHdPresetList.changeState();
            //                        idAppMain.doNotUpdate = false;
            //                    }
            //                    ///////////////////////////////////////////////////////////////////
            //                    // JSH 130402 added Info restore
            //                    if(QmlController.radioBand == 0x01 && (prevGlobalBand  != idAppMain.globalSelectedBand))
            //                        idAppMain.menuInfoFlag = QmlController.getRadioDisPlayType() ? false : idAppMain.fmInfoFlag
            //                    else if(QmlController.radioBand == 0x03 && (prevGlobalBand  != idAppMain.globalSelectedBand))
            //                        idAppMain.menuInfoFlag = idAppMain.amInfoFlag
            //                    ///////////////////////////////////////////////////////////////////
            //                }
            //            }
            //            //prevBand = band;
            ///////////////////////////////////////////////////////////////////////////////////////////////
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    // idRadioHdMain Functions
    /////////////////////////////////////////////////////////////////
    //****************************** # HD Dial Wheel function#
    // 1. Jog dial Tune(seek) sps change
    // 2. HU Key Seek Analog Freq change
    // 3. Tune Analog Freq change

    function tuneKey(key , type){ // type ( 1 : tune , 2: jog)      
        //if(idAppMain.state == "PopupRadioHdDimAcquiring" || idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled) //JSH 121029
        if(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled) //JSH 121029 => 130817 Modify [Dial tune]
            return; //HWS

        if(type == 1){
            if(key > 0){
                if(QmlController.getRadioDisPlayType() > 1)//== 3) , JSH 131111
                    QmlController.hdUp(0); //HWS
                else if((QmlController.getRadioDisPlayType() == 1) && (idRadioHdAmFrequencyDial.isFocused
                                                   || idRadioHdFmFrequencyDial.isFocused)){
                    QmlController.hdReset();
                    QmlController.hdUp(0);
                }else
                    idRadioHdMain.increasetune(key);
            }
            else{
                if(QmlController.getRadioDisPlayType()  > 1)// == 3) , JSH 131111
                    QmlController.hdDown(0);
                else if((QmlController.getRadioDisPlayType() == 1) && (idRadioHdAmFrequencyDial.isFocused
                                                  || idRadioHdFmFrequencyDial.isFocused)){
                    QmlController.hdReset();
                    QmlController.hdDown(0);

                }else
                    idRadioHdMain.decreasetune(key);
            }
        }
        else if(type == 2){
            if(key > 0){
                if((QmlController.getRadioDisPlayType() >= 2) && (jogFocusState == "HDDisplay")){
                    QmlController.hdUp(2); //QmlController.setsearchState(0x02,false); //JSH 120614 => JSH 130401 Modify[hd looping]
                    console.log("========================================>function tuneKey(key , type){ hd seekup")
                }
                ///////////////////////////////
                // JSH 140106 deleted , does not seek
                //else if((QmlController.getRadioDisPlayType() == 1) && (idRadioHdAmFrequencyDial.isFocused
                //                                   || idRadioHdFmFrequencyDial.isFocused)){ // hd radio on ,show focus on , dial focus on
                //    QmlController.hdReset();                    // hd data clear
                //    QmlController.setsearchState(0x02,false);   // seekup(); //JSH 120614
                //}
                else
                    idRadioHdMain.increasetune(key);
            }
            else{
                if((QmlController.getRadioDisPlayType() >= 2) && (jogFocusState == "HDDisplay")){
                    QmlController.hdDown(2);     // QmlController.setsearchState(0x01,false); //JSH 120614 => JSH 130401 Modify[hd looping]
                }
                ///////////////////////////////
                // JSH 140106 deleted , does not seek
                //else if((QmlController.getRadioDisPlayType() == 1) && (idRadioHdAmFrequencyDial.isFocused
                //                                   || idRadioHdFmFrequencyDial.isFocused)){
                //    QmlController.hdReset();     // hd data clear
                //    QmlController.setsearchState(0x01,false);//seekdown(); //JSH 120614
                //}
                else
                    idRadioHdMain.decreasetune(key);
            }
        }

        ///////////////////////////////////////////////////////////////////////////
        // JSH 130621 Info Window Delete
        //if((QmlController.getRadioDisPlayType() <= 1) && idAppMain.fmInfoFlag) // JSH 130402 added
        //    changeInfoState(2,false)
    }
    //****************************** # Function of Wheel #
    function decreasetune(value){
        var frequency = 0;
        if((value > -5) && (value < -2))
            value = value*2;
        else if( value <= -5)
            value = value*3;

        console.log(">>>>>>decreasetune>>>>> value : ",value );
        for (var i = value; i < 0; i++)
        {
            if(idAppMain.globalSelectedBand =="AM"){
                if(globalSelectedAmFrequency <= startAmFrequency)
                    globalSelectedAmFrequency = endAmFrequency//startAmFrequency
                else if(globalSelectedAmFrequency >= startAmFrequency && globalSelectedAmFrequency <= endAmFrequency)
                    globalSelectedAmFrequency = globalSelectedAmFrequency-stepAmFrequency
                else
                    frequency = -1

                if(frequency >=0)
                    frequency = globalSelectedAmFrequency
            }
            else{   //FM
                if(globalSelectedFmFrequency <= startFmFrequency)
                    globalSelectedFmFrequency = endFmFrequency//startFmFrequency
                else  if(globalSelectedFmFrequency >= startFmFrequency && globalSelectedFmFrequency <= endFmFrequency)
                    globalSelectedFmFrequency = globalSelectedFmFrequency-stepFmFrequency//0.1
                else
                    frequency = -1

                if(frequency >=0){
                    frequency = globalSelectedFmFrequency.toFixed(1)
                    globalSelectedFmFrequency = frequency;
                }
            }
        }

        if(frequency >=0)
            QmlController.setRadioFreq(frequency);

        console.log(">>>>>>decreasetune>>>>>",frequency )
        frequency = 0;
    }

    function increasetune(value){
        var frequency = 0;
        if((value > 2) && (value < 5))
            value = value*2;
        else if(value >= 5)
            value = value*3;

        console.log(">>>>>>increasetune>>>>> value : ",value );
        for (var i = 0; i < value; i++)
        {
            if(idAppMain.globalSelectedBand =="AM"){
                if(globalSelectedAmFrequency >= endAmFrequency)
                    globalSelectedAmFrequency = startAmFrequency//endAmFrequency
                else if(globalSelectedAmFrequency >= startAmFrequency && globalSelectedAmFrequency <= endAmFrequency)
                    globalSelectedAmFrequency = globalSelectedAmFrequency+stepAmFrequency
                else
                    frequency = -1

                if(frequency >=0)
                    frequency = globalSelectedAmFrequency
            }
            else{   //FM
                if(globalSelectedFmFrequency >= endFmFrequency)
                    globalSelectedFmFrequency = startFmFrequency//endFmFrequency
                else  if(globalSelectedFmFrequency >= startFmFrequency && globalSelectedFmFrequency <= endFmFrequency)
                    globalSelectedFmFrequency = globalSelectedFmFrequency+stepFmFrequency//0.1
                else
                    frequency = -1

                if(frequency >=0){
                    frequency = globalSelectedFmFrequency.toFixed(1)
                    globalSelectedFmFrequency = frequency;
                }
            }
        }
        if(frequency >=0)
             QmlController.setRadioFreq(frequency);

        console.log(">>>>>>increasetune>>>>>",frequency ,QmlController.radioBand )
        frequency = 0;
    }

    function requestChangeBand(bandNumber) { // not used
        if( stopSentMenu.length > 0 )
        {
            switch( bandNumber )
            {
//            case 1: stopSentMenu = "FM"; break;
//            case 3: stopSentMenu = "AM"; break;
            case 1: stopSentMenu = "FM1"; break;
            case 2: stopSentMenu = "FM2"; break;
            case 3: stopSentMenu = "AM"; break;
            }
            return true;
        }

        if(QmlController.searchState)
        {
            switch( bandNumber )
            {
            case 1: stopSentMenu = "FM1"; break;
            case 2: stopSentMenu = "FM2"; break;
            case 3: stopSentMenu = "AM"; break;
            }

            QmlController.seekstop(1);
            return true;
        }
        if(QmlController.radioBand == bandNumber )
        {
            stopSentMenu = '';
            return true;
        }
        return false;
    }

    function setBand(bandNumber){
        switch(bandNumber)
        {
        case "FM1":
            idMBand.selectedBand = stringInfo.strHDBandFm
            UIListener.setSignalSetModelData(0x01);
            idAppMain.globalSelectedBand = "FM1" //select BGImage Change
            QmlController.setRadioBand(0x01);
            var freq ;
            if(QmlController.radioFreq == "")
                freq = idAppMain.startFmFrequency;
            else
                freq = parseFloat(QmlController.radioFreq);

            //idAppMain.globalSelectedBand = "FM1"
            idAppMain.globalSelectedFmFrequency = freq;
            console.log("#########RADIO BAND FM1 QmlController.radioFreq #########",QmlController.radioFreq)
            console.log("#########RADIO BAND FM1 idAppMain.globalSelectedFmFrequency #########",idAppMain.globalSelectedFmFrequency)
            break;
        case "FM2":
            var freq ;
            idMBand.selectedBand = stringInfo.strHDBandFm
            UIListener.setSignalSetModelData(0x02);
            idAppMain.globalSelectedBand = "FM2"
            QmlController.setRadioBand(0x02);
            if(QmlController.radioFreq == "")
                freq = idAppMain.startFmFrequency;
            else
                freq = parseFloat(QmlController.radioFreq);

            //idAppMain.globalSelectedBand = "FM2"
            idAppMain.globalSelectedFmFrequency = freq
            console.log("#########RADIO BAND FM2 #########",QmlController.radioFreq,idAppMain.globalSelectedFmFrequency)
            break;
        case "AM":
            var freq ;
            idMBand.selectedBand = stringInfo.strHDBandAm
            UIListener.setSignalSetModelData(0x03);
            idAppMain.globalSelectedBand = "AM"
            QmlController.setRadioBand(0x03);
            if(QmlController.radioFreq == "")
                freq = idAppMain.startAmFrequency;
            else
                freq = parseInt(QmlController.radioFreq);

            //idAppMain.globalSelectedBand = "AM"
            idAppMain.globalSelectedAmFrequency = freq
            console.log("#########RADIO BAND AM #########",QmlController.radioFreq,idAppMain.globalSelectedAmFrequency)
            break;
        }
    }

    function changeBand() {
        console.log(" HJIGKS : stopSentMenu = " + stopSentMenu );
        if( stopSentMenu.length > 0 )
        {
            console.log("1. HJIGKS : stopSentMenu.length = " + stopSentMenu.length );
            setBand(stopSentMenu);
            stopSentMenu = '';
        }
    }
    //////////////////////////////////////////////////////////////////////////////////
    // HD // JSH 130621 Info Window Delete
    //    function changeInfoState(st,onoff){ //JSH 130402 added [Info state]
    //        if(QmlController.radioBand > 0x02)
    //            return;

    //        switch(st){
    //        case 1 : idAppMain.menuInfoFlag = onoff; idInfoTimer.stop();    break;   // default Info On/Off
    //        case 2 : idAppMain.menuInfoFlag = onoff; idInfoTimer.restart(); break;  // Timer Start [when Dial Freq or HD -> Analog Chganged]
    //        default : break;
    //        }
    //    }
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    onJogFocusStateChanged: { // JSH Jog state
        console.log("onJogFocusStateChanged :: ",jogFocusState)
        jogFocus(jogFocusState);
    }

    function jogFocus(jog){
        console.log("function jogFocus(jog){ :: ",jog)
        //if(idAppMain.state != "AppRadioHdMain"){                                                    , JSH 140129 ITS [0223314]
        if((idAppMain.state != "AppRadioHdMain") && (idAppMain.state != "PopupRadioHdDimAcquiring")){ // JSH 140129 ITS [0223314]
            console.log("function jogFocus(jog) Return :: ",jog)
            return;
        }

        if(jog != "Band") {
            prevBandJogFocusState = "";   //dg.jin 20150227 bnad down jog focus
        }

        switch(jog){
        case "PresetList"    :{
            if(globalSelectedBand == stringInfo.strHDBandAm)
            {
                if(!idRadioHdPresetListAM.activeFocus){
                    idRadioHdPresetListAM.focus = true;
                    idRadioHdPresetListAM.forceActiveFocus();
                    // Preset Focus or Tune No.1
                    if((QmlController.getPresetIndex(QmlController.radioBand) == 0xFF)
                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
    
                        QmlController.changeChannel(0x01);
                    }
    
                    //////////////////////////////////////////////////////
                    // JSH 140123
                    if(!((idRadioHdPresetListAM.currentIndex >= idRadioHdPresetListAM.overContentCount)
                            && (idRadioHdPresetListAM.currentIndex < idRadioHdPresetListAM.overContentCount+6)))
                    {
                        if(idRadioHdPresetListAM.currentIndex < idRadioHdPresetListAM.overContentCount)
                            idRadioHdPresetListAM.children[3].positionViewAtIndex((idRadioHdPresetListAM.currentIndex - (idRadioHdPresetListAM.currentIndex%6)), ListView.Beginning);
                        else
                        {
                            idRadioHdPresetListAM.children[3].positionViewAtIndex((idRadioHdPresetListAM.currentIndex - (idRadioHdPresetListAM.currentIndex-idRadioHdPresetListAM.overContentCount)%6), ListView.Beginning);
                        }
                    }
                    //////////////////////////////////////////////////////
                }
            }
            else
            {
                if(!idRadioHdPresetListFM.activeFocus){
                    idRadioHdPresetListFM.focus = true;
                    idRadioHdPresetListFM.forceActiveFocus();
                    // Preset Focus or Tune No.1
                    if((QmlController.getPresetIndex(QmlController.radioBand) == 0xFF)
                            && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))){
    
                        QmlController.changeChannel(0x01);
                    }
    
                    //////////////////////////////////////////////////////
                    // JSH 140123
                    if(!((idRadioHdPresetListFM.currentIndex >= idRadioHdPresetListFM.overContentCount)
                            && (idRadioHdPresetListFM.currentIndex < idRadioHdPresetListFM.overContentCount+6)))
                    {
                        if(idRadioHdPresetListFM.currentIndex < idRadioHdPresetListFM.overContentCount)
                            idRadioHdPresetListFM.children[3].positionViewAtIndex((idRadioHdPresetListFM.currentIndex - (idRadioHdPresetListFM.currentIndex%6)), ListView.Beginning);
                        else
                        {
                            idRadioHdPresetListFM.children[3].positionViewAtIndex((idRadioHdPresetListFM.currentIndex - (idRadioHdPresetListFM.currentIndex-idRadioHdPresetListFM.overContentCount)%6), ListView.Beginning);
                        }
                    }
                    //////////////////////////////////////////////////////
                }
            }

            presetAndDialBackground = jogFocusState;
            break;
        }
        case "FrequencyDial" :{
            if(globalSelectedBand == stringInfo.strHDBandAm){
                if(!idRadioHdAmFrequencyDial.activeFocus){
                    idRadioHdAmFrequencyDial.focus = true;
                    idRadioHdAmFrequencyDial.forceActiveFocus();
                }
            }
            else{
                if(!idRadioHdFmFrequencyDial.activeFocus){
                    idRadioHdFmFrequencyDial.focus = true;
                    idRadioHdFmFrequencyDial.forceActiveFocus();
                }
            }
            presetAndDialBackground = jogFocusState;
            break;
        }
        case "Band"    :{
            if(!idMBand.activeFocus){
                /////////////////////////////////////////////////////////////
                // JSH 130328 => JSH 130403 Modify
                //idMBand.focus = true;
                //if(prevJogFocusState == "PresetList"){idMBand.giveForceFocus(QmlController.radioBand==0x01 ? 1 : 2);}

                if(prevJogFocusState == "PresetList"){ // JSH 130801 NA ITS[0182046,0182037]
                    if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
                        idMBand.giveForceFocus("backBtn");
                    else
                        idMBand.giveForceFocus(QmlController.radioBand==0x01 ? 1 : 2);

                    prevBandJogFocusState = "PresetList";   //dg.jin 20150227 bnad down jog focus
                }
                else if(prevJogFocusState != "Band") {
                    //ITS 0258832 dg.jin 20150226 CCP up focus change
                    //idMBand.giveForceFocus("menuBtn");
                    idMBand.giveForceFocus("leftend");
                    prevBandJogFocusState = "";   //dg.jin 20150227 bnad down jog focus
                }
                /////////////////////////////////////////////////////////////
                idMBand.forceActiveFocus();
            }
            break;
        }
        case "HDDisplay" :{
            if(idRadioHdMenuHdRadioOn.visible){
                if(!idRadioHdMenuHdRadioOn.activeFocus){
                    idRadioHdMenuHdRadioOn.focus = true;
                    idRadioHdMenuHdRadioOn.forceActiveFocus();
                }
                presetAndDialBackground = jogFocusState;
            }
            else{
                QmlController.presetListHighlightUpdate();
            }
            break;
        }
        }
        prevJogFocusState = jog; // JSH 130328
    } // function End
}
