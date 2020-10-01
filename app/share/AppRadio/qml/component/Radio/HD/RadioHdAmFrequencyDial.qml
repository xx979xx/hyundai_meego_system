/**
 * FileName: RadioHdAmFrequencyDial.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 * - 2012-07 change x position, image
 */

import QtQuick 1.0

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioHdAmFrequencyDial
    x: 0; y: 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioHdStringInfo{ id: stringInfo }

    property string imgFolderRadio      : imageInfo.imgFolderRadio
    property string imgFolderGeneral    : imageInfo.imgFolderGeneral

    property real   selectedAngle       : 0
    property real   calculationTemp     : 0
    property bool   bManualTouch
    property bool   isFocused           : (showFocus  && idFreq.activeFocus)&&(idRadioHdMain.jogFocusState == "FrequencyDial")
    //    property bool isFocused : (idRadioHdAmFrequencyDial.activeFocus && showFocus)
    property bool   requestStopSearch   : false
    property int    touchX              : 0
    property int    touchY              : 0
    //****************************** # Dial Save Button`s Background Image #
    //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
    property  real  rollBackFrequency   : 0
    MComp.MButtonOnlyRadio{
        id:idFreq
        //x: 99; y:  menuInfoFlag || idAppMain.hdRadioOnOff ? 210-systemInfo.headlineHeight-1+20+391 : 210-systemInfo.headlineHeight-1+20
        x: 99; y: 210-systemInfo.headlineHeight-1+20
        width: 375; height: 381
        focus: true
        Image{ source: imgFolderRadio+"bg_frequency_11_n.png" }
        //Image{source: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"bg_frequency_11_d.png" : imgFolderRadio+"bg_frequency_11_n.png"}
        bgImageFocus: imgFolderRadio+"bg_frequency_f.png"
        bgImagePress: imgFolderRadio+"bg_frequency_f.png" // JSH 130426 added
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)

        property  real  touchAngle: 0
        property  real localSelectedAmFrequency : 0
        property  int  dialMouseX : 0
        property  int  dialMouseY : 0

        function functionReleased(){
            var frequency = idFreq.localSelectedAmFrequency //globalSelectedAmFrequency
            if((startAmFrequency <= idFreq.localSelectedAmFrequency) && (endAmFrequency >=idFreq.localSelectedAmFrequency))
            {
                idAppMain.doNotUpdate = true;
                QmlController.setRadioFreq(idFreq.localSelectedAmFrequency);//(globalSelectedAmFrequency);
                idAppMain.doNotUpdate = false;
                globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
            }
            else{// JSH 130621 [ITS 0174881 bug Fixed
                if((QmlController.getRadioFreq() != globalSelectedAmFrequency))
                {
                    idAppMain.doNotUpdate = true;
                    QmlController.setRadioFreq(globalSelectedAmFrequency);
                    idAppMain.doNotUpdate = false;
                }
            }
        }
        function functionMousePositionChanged(mouseX , mouseY){
            // # 877-690, 431-420
            idFreq.touchAngle  = Math.atan2( mouseX-187, mouseY-191) * 180 / Math.PI //+30//3.14159265//+=1

            if(idFreq.touchAngle > 0){
                idFreq.touchAngle = 360- idFreq.touchAngle
            }
            else{
                idFreq.touchAngle =-idFreq.touchAngle
            }
            //dg.jin 20150707 add guam 1 point 30/11 2.73 startfreq 460 1freqang 110/30 3.67
            if(idFreq.touchAngle >=(((startAmFrequency-460)/3.67) - 5) && idFreq.touchAngle <= (((endAmFrequency-460)/3.67) + 5)){
                selectedAngle  = idFreq.touchAngle
                selectedAngle = selectedAngle.toFixed(0)
                 //dg.jin 20150707 add guam
                if(UIListener.getRadioRegionCode() == 4)
                {
                     calculationTemp = ((selectedAngle-((startAmFrequency -460)/3.67))/2.46) ;   //990/110           
                }
                else
                {
                    calculationTemp = ((selectedAngle-((startAmFrequency -460)/3.67))/2.73);
                }
                calculationTemp = calculationTemp.toFixed(0)

                //globalSelectedAmFrequency = startAmFrequency + (calculationTemp *stepAmFrequency)
                idFreq.localSelectedAmFrequency = startAmFrequency + (calculationTemp *stepAmFrequency)
                //globalSelectedAmFrequency = globalSelectedAmFrequency.toFixed(0)
                idFreq.localSelectedAmFrequency = idFreq.localSelectedAmFrequency.toFixed(0)
                if((startAmFrequency <= idFreq.localSelectedAmFrequency) && (endAmFrequency >=idFreq.localSelectedAmFrequency)){
                    if(globalSelectedAmFrequency != idFreq.localSelectedAmFrequency)
                        selectedStationBtn = 1 //

                    globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
                } else if(startAmFrequency > idFreq.localSelectedAmFrequency) {
                    idFreq.localSelectedAmFrequency = startAmFrequency;
                        if(globalSelectedAmFrequency != idFreq.localSelectedAmFrequency)
                            selectedStationBtn = 1;
                    globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
                } else if(endAmFrequency < idFreq.localSelectedAmFrequency) {
                    idFreq.localSelectedAmFrequency = endAmFrequency;
                    if(globalSelectedAmFrequency != idFreq.localSelectedAmFrequency)
                        selectedStationBtn = 1;
                    globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
                }
                //                        idAppMain.touchAmAniStop  = false
            }
            else {
                idFreq.localSelectedAmFrequency = 0;
            }
        }

        //////////////////////////////////////////////////////////////////
        //JSH 130426 SAVE Button Pressed or Release
        onSelectKeyPressed: {
            if(btnSave.mEnabled)
                btnSave.state = "pressed";
        }
        onSelectKeyReleased: {
            btnSave.state = "keyReless";
        }
        onCancel:{ // JSH 130708
            btnSave.state = "normal"
        }
        //////////////////////////////////////////////////////////////////
        //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
        onPreventDrag: {
            console.log("[CHECK_11_14_DRAG] : onPreventDrag bManualTouch = " + bManualTouch );
            if(bManualTouch){
                idAppMain.globalSelectedAmFrequency = idRadioHdAmFrequencyDial.rollBackFrequency;
                bManualTouch = false;
            }
        }
        ////
        onClickOrKeySelected: {
            //// 2013.11.21 modified by qutiguy - change to stop while scan.
            if(btnSave.preventSave){
                var searchValue = QmlController.getsearchState();
                QmlController.setsearchState(searchValue);
                return;
            }

            //if(!idAppMain.presetSaveEnabled){                                                 // JSH 130822 Modify
            if((!idAppMain.presetSaveEnabled) && (idAppMain.state != "AppRadioHdOptionMenu")){  // JSH 130822 Modify
                if( QmlController.searchState )
                    QmlController.seekstop();
                idAppMain.presetSaveEnabled = true;
            }

            //            if(!idAppMain.alreadySaved)
            //                idAppMain.presetSaveEnabled = true; //setAppMainScreen( "PopupRadioHdPreset" , true); //JSH 121121 preset list save button enable
            //            else{
            //                idAppMain.strPopupText1 = stringInfo.strHDPopupPresetAlreadySave;
            //                idAppMain.strPopupText3 = idAppMain.strPopupText2 = "";
            //            }
        }
        MouseArea{
            id:mouse
            anchors.fill : parent
            onPressed: {
                idRadioHdAmFrequencyDial.bManualTouch = true
                //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
                idRadioHdAmFrequencyDial.rollBackFrequency = idAppMain.globalSelectedAmFrequency;
                console.log("[CHECK_11_14_PRESS] : onPressed() rollBackFrequency = " + idRadioHdAmFrequencyDial.rollBackFrequency);
                ////
                idAppMain.touchAni = true // JSH 130422 added
                //if(idAppMain.state == "AppRadioHdMain")
                    idRadioHdMain.jogFocusState = "FrequencyDial" // JSH jog focus

                idAppMain.returnToTouchMode()
                if (QmlController.searchState){
                    QmlController.seekstop();
                    idRadioHdAmFrequencyDial.requestStopSearch = true;
                    return;
                }
                //                //if(QmlController.searchState != 0x00)
                //                    idAppMain.touchAmAniStop = true
                //                //else
                //                //    idAppMain.touchAmAniStop = false
            }
            onReleased: {
                QmlController.playAudioBeep(); // JSH 120827 comment
                idAppMain.touchAni = true // dg.jin 140725 ITS KH 0244077, VI 0244078
                if(idRadioHdAmFrequencyDial.bManualTouch == true){
                    idRadioHdAmFrequencyDial.bManualTouch = false

                    if(!idRadioHdAmFrequencyDial.requestStopSearch)
                        idFreq.functionReleased();
                }
                idAppMain.touchAni = false // dg.jin 140725 ITS KH 0244077, VI 0244078
            }
            onMousePositionChanged: {
                console.log("[CHECK_11_14_DRAG] : onMousePositionChanged ");
                console.log("[CHECK_11_14_DRAG]############################  mouseX = " + mouseX + " mouseY = " + mouseY);
                if ((mouseX < 0) || (mouseY < 0)){
                    console.log("[CHECK_11_13_TOUCH_CANCEL]############################  touch - onSignalTouchCancel");
                    preventDrag();
                    return;
                }
                if(idRadioHdAmFrequencyDial.bManualTouch){
                    //                    //idAppMain.touchAmAniStop = true
                    console.log("[CHECK_11_14_DRAG] : idRadioAmFrequencyDial.bManualTouch == true ");
                    idFreq.dialMouseX = mouseX;
                    idFreq.dialMouseY = mouseY;
                    idAppMain.touchAni = true // dg.jin 140725 ITS KH 0244077, VI 0244078
                    if(!idRadioHdAmFrequencyDial.requestStopSearch)
                        idFreq.functionMousePositionChanged(idFreq.dialMouseX,idFreq.dialMouseY);

                    idAppMain.touchAni = false // JSH 130422 added
                }
            }
        }
    } // # End Image

    //****************************** # Dial No Touch & Flick #
    Rectangle { // JSH Circle
        id:circle
        // HD // JSH 130621 Info Window Delete
        //        x: (idAppMain.hdRadioOnOff || idAppMain.menuInfoFlag) ? idFreq.x - 50 : idFreq.x + 50
        //        y: (idAppMain.hdRadioOnOff || idAppMain.menuInfoFlag) ? idFreq.y - 50 : idFreq.y + 50
        x: (idAppMain.hdRadioOnOff) ? idFreq.x - 50 : idFreq.x + 50
        y: (idAppMain.hdRadioOnOff) ? idFreq.y - 50 : idFreq.y + 50
        width:{
            // HD // JSH 130621 Info Window Delete
            //if((idAppMain.hdRadioOnOff || idAppMain.menuInfoFlag)){
            if(idAppMain.hdRadioOnOff){
                if(idFreq.width < idFreq.height)
                    idFreq.width  + 110
                else
                    idFreq.height + 110
            }
            else{
                if(idFreq.width < idFreq.height)
                    idFreq.width  - 100
                else
                    idFreq.height - 100
            }
        }
        height: width
        radius: width*0.5
        opacity : 0.001
        clip:true
        MouseArea{
            id: circleMouseArea
            anchors.fill: circle
            onPressed : {
                idAppMain.returnToTouchMode();
                mouse.accepted = circleMouseArea.contains(mouse.x, mouse.y);
                // HD // JSH 130621 Info Window Delete
                if(QmlController.getRadioDisPlayType()){//if((QmlController.getRadioDisPlayType())&&(!idAppMain.menuInfoFlag)){
                    idRadioHdMain.touchflick = true
                    touchX = mouseX
                    touchY = mouseY
                }
            }
            onReleased: {
                if(idRadioHdMain.touchflick){
                    if(touchY > mouseY + 20){
                        idRadioHdMain.touchflick = false
                        if(QmlController.getRadioDisPlayType())
                            QmlController.hdRadioChange(1);//idAppMain.menuHdRadioFlag = !idAppMain.hdRadioOnOff
                    }
                    else if(touchY < mouseY - 20 ){
                        idRadioHdMain.touchflick = false
                        if(idRadioHdMain.noSignal == 2)// if(idRadioHdMain.noSignal)  , JSH 131009 modify
                            QmlController.hdRadioChange(2); // No Signal View
                        else if(QmlController.getRadioDisPlayType()) // JSH 130621 [ITS 0174881 bug Fixed , getRadioDisPlayType != 0]
                            QmlController.hdRadioChange(3); // HD Radio View //idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff
                    }
                }
            }
            function contains(x, y) {
                var d = (circle.width / 2);
                var dx = (x - circle.width / 2);
                var dy = (y - circle.height / 2);
                return (d * d > dx * dx + dy * dy);
            }
        }
    }

    //****************************** # Needle #
    Image{
        id: redNeedle
        //x: 868+100-691; y: menuInfoFlag || idAppMain.hdRadioOnOff? 233-systemInfo.headlineHeight-1+188+391 : 233-systemInfo.headlineHeight-1+188
        x: 868+100-691 ; y: 233-systemInfo.headlineHeight-1+188
        source: imgFolderRadio+ "frequency_dial_n.svg"//"frequency_dial.svg" , JSH 130715 modify
        //source: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? imgFolderRadio+"frequency_dial_d.svg" : imgFolderRadio+"frequency_dial_n.svg"
        rotation: 180
        smooth: true
        transform: Rotation{
            id:idRot
            origin.x: 9; origin.y: 0
            //  angle: Math.min(Math.max(((startAmFrequency-414)/3.9), (globalSelectedAmFrequency-414)/3.9), ((endAmFrequency-414)/3.9))
            angle: Math.min(Math.max((startAmFrequency-460)/3.67, (globalSelectedAmFrequency-460)/3.67), ((endAmFrequency-460)/3.67))
            /////////////////////////////////////////////////////////////////
            // JSH 130422 added
            Behavior on angle {
                enabled: ((!QmlController.searchState) && idAppMain.touchAni)
                NumberAnimation{duration: 100}
            }
            /////////////////////////////////////////////////////////////////
        }
    }

    //****************************** # Dial Wheel #
    //Keys.onPressed:{tuneKey(event , 2)}

    //****************************** # Dial Image#
    Image{
        //x: 99; y:  menuInfoFlag || idAppMain.hdRadioOnOff? 210-systemInfo.headlineHeight-1+20+391 : 210-systemInfo.headlineHeight-1+20
        x: 99; y: 210-systemInfo.headlineHeight-1+20
        width: 375; height: 381
        source: imgFolderRadio+"bg_frequency_n.png" //"bg_frequency.png" , JSH 130715 modify
        //source: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"bg_frequency_d.png" : imgFolderRadio+"bg_frequency_n.png" //"bg_frequency.png"
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
    }

    //****************************** # Dial Save Button`s Text #
    Item{
        x: 0; y:0 //y: menuInfoFlag || idAppMain.hdRadioOnOff? 391 : 0
        Text{
            id:idAmFreqText
            text: selectedStationBtn != 1 ? globalSelectedAmFrequency+ "<font size=-34>"+"-"+selectedStationBtn+"</font>" : globalSelectedAmFrequency
            //text: globalSelectedAmFrequency+ "<font size=-34>"+"-"+5+"</font>"

//            x:(idAmFreqText.text.length == 4) ? 99+82+20 : idAmFreqText.text.length > 5 ? 99+82-6 : 99+82+42
            x:{
                //JSH 130619 Modify
                //                if((globalSelectedAmFrequency >= 1000) && (selectedStationBtn == 1))    {return 99+82+19} //
                //                else if((globalSelectedAmFrequency < 1000) && (selectedStationBtn == 1)){return 99+82+40}//
                //                else                                                                    {return 99+82   }
                if((globalSelectedAmFrequency >= 1000) && (selectedStationBtn == 1))    {return 99+82+17} //
                else if((globalSelectedAmFrequency < 1000) && (selectedStationBtn == 1)){return 99+82+39}//
                else                                                                    {return 99+81   }
            }
            y: 210-systemInfo.headlineHeight-1+20+173-70/2
            width: 61+8+72+69; height: 70
            font.pixelSize: selectedStationBtn != 1? 60 : 70  //font.pixelSize: 70  //
            font.family: systemInfo.hdb
            horizontalAlignment: (selectedStationBtn !=1) ? Text.AlignHCenter : 0   //
            verticalAlignment: Text.AlignVCenter
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : selectedStationBtn != 1 ? colorInfo.brightGrey : colorInfo.subTextGrey
        }

        MComp.MButtonOnlyRadio{
            id: btnSave
        //// 2013.11.21 modified by qutiguy - change to stop while scan.
        property bool preventSave: (idAppMain.menuPresetScanFlag || idAppMain.menuScanFlag || idAppMain.menuAutoTuneFlag)
            ///////////////////////////////////////////////////////////////////////////////////////////
            // JSH 131018 Modify [Expansion of the touch area]
            //x: 99+82+61-15; y: 210-systemInfo.headlineHeight-1+20+173+49
            //width: 119; height: 50
            x: 99+82+61-15-20; y: 210-systemInfo.headlineHeight-1+20+173+49-15
            width: 119+40; height: 50+30
            //bgImage: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"btn_radio_save_d.png" : imgFolderRadio+"btn_radio_save_n.png"
            //bgImagePress: imgFolderRadio+"btn_radio_save_p.png"
            fgImageX     : 20
            fgImageY     : 15
            fgImageWidth : 119
            fgImageHeight: 50
            fgImage: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"btn_radio_save_d.png" : imgFolderRadio+"btn_radio_save_n.png"
            fgImagePress: imgFolderRadio+"btn_radio_save_p.png"
        //// 2013.11.21 modified by qutiguy - change to stop while scan.
            firstText: preventSave?stringInfo.strRadioPreventSave:stringInfo.strHDRadioSave
            firstTextSize: 27
            firstTextX: fgImageX //+20 - 3 // fgImageX+20
            firstTextY: 41
            firstTextWidth: fgImageWidth   // 79
            firstTextStyle: systemInfo.hdb
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            ///////////////////////////////////////////////////////////////////////////////////////////

            //bgImageActive: imgFolderRadio+"btn_radio_save_n.png"
            //enabled: !(idAppMain.alreadySaved || idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
            //visible: (!(idAppMain.alreadySaved))
            /////////////////////////////////////////////////////////////////
            onClickOrKeySelected: {
                //idAppMain.playBeep(); //HWS // JSH 130307 delete
                console.log(">>>>>>>>>>>>>  btnSave Click")
            //// 2013.11.21 modified by qutiguy - change to stop while scan.
            if(btnSave.preventSave){
                var searchValue = QmlController.getsearchState();
                QmlController.setsearchState(searchValue);
                return;
            }
            ////

                ///////////////////////////////////////////////////////
                // JSH 121121 , popup preset List Delete
                //setAppMainScreen( "PopupRadioHdPreset" , true);
                if((!idAppMain.presetSaveEnabled) && (idAppMain.state != "AppRadioHdOptionMenu")){  // JSH 130822 Modify
                    if( QmlController.searchState )
                        QmlController.seekstop();
                    idAppMain.presetSaveEnabled = true;
                }
                ////////////////////////////////////////////////////////
            }
        }
    }

    //****************************** # Frequency TextValue #
    Item{
        x: 0; y:0 // y: menuInfoFlag || idAppMain.hdRadioOnOff? 391 : 0

        Text{
            text: "570"
            x: 706+23+49+23+10-691; y: 238-systemInfo.headlineHeight-1+81+103+103+81-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey

        }
        Text{
            text: "680"
            x: 706+23-691; y: 238-systemInfo.headlineHeight-1+81+103+103-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "790"
            x: 706-691; y: 238-systemInfo.headlineHeight-1+81+103-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "900"
            x: 706+23-691; y: 238-systemInfo.headlineHeight-1+81-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "1010"
            x: 706+23+49+23+10-691; y: 238-systemInfo.headlineHeight-1-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "1120"
            x: 99+82+61+8; y: 210-systemInfo.headlineHeight-1-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "1230"
            x: 706+23+49+23+10+72+190-691; y: 238-systemInfo.headlineHeight-1-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "1340"
            x: 706+23+49+23+10+72+190+72+5-691; y: 238-systemInfo.headlineHeight-1+81-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "1450"
            x: 706+23+49+23+10+72+190+72+5+23-691; y: 238-systemInfo.headlineHeight-1+81+103-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        }
        Text{
            text: "1560"
            x: 706+23+49+23+10+72+190+72+5-691; y: 238-systemInfo.headlineHeight-1+81+103+103-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        } // # End TextValue
        Text{
            text: "1670"
            x: 706+23+49+23+10+72+190-691; y: 238-systemInfo.headlineHeight-1+81+103+103+81-28/2
            width: 71; height: 28
            font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            //color: colorInfo.brightGrey
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
        } // # End TextValue
    }

//    //****************************** # Station Name #
//    Item{
//        x: 0; y:0 //y: menuInfoFlag || idAppMain.hdRadioOnOff? 391 : 0
//        Text{
//            text: ""//strAmStationName//"SBS Power FM"
//            x: 0; y: 646-systemInfo.headlineHeight-1-(36/2)
//            width: 573; height: 36
//            font.pixelSize: 36
//            font.family: systemInfo.hdr//"HDR"
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//            color: colorInfo.brightGrey
//        } // # End Text
//        Text{
//            text: ""//"Classic Rock"
//            x: 0; y: 646-systemInfo.headlineHeight-1+41-(28/2)
//            width: 573; height: 28
//            font.pixelSize: 28
//            font.family: systemInfo.hdr//"HDR"
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//            color: colorInfo.dimmedGrey
//        } // # End Text
//    }

//    //****************************** # HD LOGO Image #
//    Image{
//        id:idHdLogo
//        x: 493+78+79-691; y: 173-systemInfo.headlineHeight+15
//        source: imgFolderRadio_Hd+"ico_hd_radio_d.png"
//        visible: (idAppMain.hdSignalPerceive && (!QmlController.getRadioDisPlayType())) //!idAppMain.hdRadioOnOff
//    }
//    //****************************** # Scan Image #
//    Image{
//        id: scanIcon
//        x: 1208-691; y: 179-systemInfo.headlineHeight-1
//        width: 57; height: 57
//        source: imgFolderRadio+"ico_radio_scan.png"
//        visible: menuScanFlag || menuPresetScanFlag
//        opacity: 1
//        SequentialAnimation{
//            id: aniScanIcon
//            running: true
//            loops: Animation.Infinite
//            NumberAnimation { target: scanIcon; property: "opacity"; to: 0.0; duration: 500 }
//            NumberAnimation { target: scanIcon; property: "opacity"; to: 1.0; duration: 500 }
//        }
//    }
//    //****************************** # Auto Tune Image #
//    Image{
//        x: 1208-691; y: 179-systemInfo.headlineHeight-1
//        width: 57; height: 57
//        source: imgFolderRadio+"ico_radio_autotune.png"
//        visible: menuAutoTuneFlag
//    }

    Connections {
        target: QmlController
        onChangeSearchState: {
            console.log(" [AM Dial onChangeSearchState ] value: "
                        + value + " requestStopSearch: " +
                        idRadioHdAmFrequencyDial.requestStopSearch );

            if( value == 0 && idRadioHdAmFrequencyDial.requestStopSearch == true ){
                idRadioHdAmFrequencyDial.requestStopSearch = false;
                idFreq.functionMousePositionChanged(idFreq.dialMouseX,idFreq.dialMouseY);
                idFreq.functionReleased();
            }
        }
        //onHdSignalPerceive:{ idHdLogo.source = (onoff && (!QmlController.getRadioDisPlayType())) ? imgFolderRadio_Hd+"ico_hd_radio_d.png" : ""}
    }
    /////////////////////////////////////////////////////////////////
    //# HD Display Dial focus # JSH 120511
    onActiveFocusChanged: { // JSH jog focus
        console.log("========================> AM onActiveFocusChanged :: ",idFreq.activeFocus)
        if((!idFreq.activeFocus) && idRadioHdMain.jogFocusState == "FrequencyDial" && idAppMain.state == "AppRadioHdMain"){
            console.log("========================> AM onActiveFocusChanged :: (!idFreq.activeFocus) ")
            focus = true;
        }
        //****************************** # Arrow On/Off of MVisualCue #
        if(idFreq.activeFocus){
            arrowUp = true
            arrowDown = false
            arrowLeft = true
            arrowRight = false
            QmlController.setQmlFocusState(1); // JSH 121228
        }else{ // JSH 130802
            if(btnSave.state == "pressed")
                btnSave.state = "normal"
        }
    }
    onIsFocusedChanged: {
        console.log("========================> onIsFocusedChanged :: ",isFocused)
        if((QmlController.getRadioDisPlayType() > 1) && isFocused){//if((QmlController.getRadioDisPlayType() > 1) && isFocused && (!menuInfoFlag)){ => JSH 130402 delete [HD Info Delete]
            QmlController.hdRadioChange(1); // HD Acqire View  //idAppMain.menuHdRadioFlag = !idAppMain.hdRadioOnOff
        }
        ///////////////////////////////////////////////////////////////////////
        //        JSH 130202 [RadioHdMain.qml -> RadioHdFmFrequencyDial -> Keys.onPressed: ]
        //        else if((QmlController.getRadioDisPlayType() == 1) && (!isFocused)){
        //
        //            if(idRadioHdMain.noSignal)
        //                QmlController.hdRadioChange(2); // No Signal View
        //            else
        //                QmlController.hdRadioChange(3); // HD Radio View //idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff
        //        }
        ///////////////////////////////////////////////////////////////////////
        UIListener.isDialFocus = isFocused;
    }
}
