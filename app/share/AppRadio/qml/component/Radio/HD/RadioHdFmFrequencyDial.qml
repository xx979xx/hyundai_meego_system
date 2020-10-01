/**
 * FileName: RadioHdFmFrequencyDial.qml
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
    id: idRadioHdFmFrequencyDial
    x: 0 ; y:0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioHdStringInfo{ id: stringInfo }

    property string imgFolderRadio    : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral  : imageInfo.imgFolderGeneral
    property real   selectedAngle     : 0

    ////////////////////////////////////////////////
    // 120308 JSH
    property bool   bManualTouch
    property bool   isFocused        : (showFocus && idFreq.activeFocus)&&(idRadioHdMain.jogFocusState == "FrequencyDial")
    //    property bool isFocused : (idRadioHdFmFrequencyDial.activeFocus && showFocus)
    property bool   requestStopSearch   : false
    property int    touchX              : 0
    property int    touchY              : 0
    //****************************** # Dial Save Button`s Background Image #
    //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
    property  real  rollBackFrequency   : 0

    MComp.MButtonOnlyRadio{
        id:idFreq
       // x: 99; y: menuInfoFlag || idAppMain.hdRadioOnOff? 210-systemInfo.headlineHeight-1+20+391 : 210-systemInfo.headlineHeight-1+20
        x: 99; y: 210-systemInfo.headlineHeight-1+20
        width: 375; height: 381
        focus: true
        Image{ source: imgFolderRadio+"bg_frequency_10_n.png" }
        //Image{ source: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"bg_frequency_10_d.png" : imgFolderRadio+"bg_frequency_10_n.png" }
        bgImageFocus: imgFolderRadio+"bg_frequency_f.png"
        bgImagePress: imgFolderRadio+"bg_frequency_f.png" // JSH 130426 added
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)

        property  int  touchAngle :35
        property  real localSelectedFmFrequency : 0
        property  int  dialMouseX : 0
        property  int  dialMouseY : 0

        function functionReleased(){
            var frequency = idFreq.localSelectedFmFrequency        //globalSelectedFmFrequency

            if((idFreq.localSelectedFmFrequency%1) == 0)
                frequency = idFreq.localSelectedFmFrequency + ".0" //globalSelectedFmFrequency+".0"
            else
                frequency = idFreq.localSelectedFmFrequency.toFixed(1) //globalSelectedFmFrequency

            if((startFmFrequency <= idFreq.localSelectedFmFrequency) && (endFmFrequency >=idFreq.localSelectedFmFrequency)){
                idAppMain.doNotUpdate = true;
                QmlController.setRadioFreq(frequency);
                idAppMain.doNotUpdate = false;
                globalSelectedFmFrequency = idFreq.localSelectedFmFrequency;
            }else{// JSH 130621 [ITS 0174881 bug Fixed
                if((QmlController.getRadioFreq() != globalSelectedFmFrequency)){
                    if((globalSelectedFmFrequency%1) == 0)
                        frequency = globalSelectedFmFrequency + ".0"
                    else
                        frequency = globalSelectedFmFrequency.toFixed(1)

                    idAppMain.doNotUpdate = true;
                    QmlController.setRadioFreq(frequency);
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
            var calculationTemp;

            //if(idFreq.touchAngle >=((startFmFrequency-86)*15) && idFreq.touchAngle <= ((endFmFrequency-86)*15)){
            if(idFreq.touchAngle >=((startFmFrequency-86)*10) && idFreq.touchAngle <= ((endFmFrequency-86)*20)){ //
                selectedAngle  = idFreq.touchAngle
                calculationTemp =  (selectedAngle/15)+86
                calculationTemp = calculationTemp.toFixed(1)

                if(stepFmFrequency == 0.2){
                    if(((calculationTemp*10)%10)%2 == 0)
                        idFreq.localSelectedFmFrequency = parseFloat(calculationTemp)+0.1//return // JSH 121112
                    else idFreq.localSelectedFmFrequency = calculationTemp //globalSelectedFmFrequency = calculationTemp
                }
                else idFreq.localSelectedFmFrequency = calculationTemp     //globalSelectedFmFrequency = calculationTemp

                if((startFmFrequency <= idFreq.localSelectedFmFrequency) && (endFmFrequency >=idFreq.localSelectedFmFrequency)){
                    if(globalSelectedFmFrequency != idFreq.localSelectedFmFrequency)
                        selectedStationBtn = 1 //
                    globalSelectedFmFrequency = idFreq.localSelectedFmFrequency;
                } else if(startFmFrequency > idFreq.localSelectedFmFrequency) {
                    idFreq.localSelectedFmFrequency = startFmFrequency;
                    if(globalSelectedFmFrequency != idFreq.localSelectedFmFrequency)
                        selectedStationBtn = 1;
                    globalSelectedFmFrequency = idFreq.localSelectedFmFrequency;
                } else if(endFmFrequency < idFreq.localSelectedFmFrequency) {
                    idFreq.localSelectedFmFrequency = endFmFrequency;
                    if(globalSelectedFmFrequency != idFreq.localSelectedFmFrequency)
                        selectedStationBtn = 1;
                    globalSelectedFmFrequency = idFreq.localSelectedFmFrequency;
                }
            }
            else {
                idFreq.localSelectedFmFrequency = 0;
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
                idAppMain.globalSelectedFmFrequency = idRadioHdFmFrequencyDial.rollBackFrequency;
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
            //                idAppMain.presetSaveEnabled = true; //setAppMainScreen( "PopupRadioHdPreset" , true);//JSH 121121 preset list save button enable
            //            else{
            //                idAppMain.strPopupText1 = stringInfo.strHDPopupPresetAlreadySave;
            //                idAppMain.strPopupText3 = idAppMain.strPopupText2 = "";
            //            }
        }
        MouseArea{
            id:mouse
            anchors.fill : parent
            onPressed: {
                idRadioHdFmFrequencyDial.bManualTouch   = true
                //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
                idRadioHdFmFrequencyDial.rollBackFrequency = idAppMain.globalSelectedFmFrequency;
                console.log("[CHECK_11_14_PRESS] : onPressed() rollBackFrequency = " + idRadioHdFmFrequencyDial.rollBackFrequency);
                ////
                idAppMain.touchAni = true // JSH 130422 added

                ///////////////////////////////////////////////////////////////////////////
                // JSH 130621 Info Window Delete
                //if(idAppMain.fmInfoFlag)
                //    idRadioHdMain.changeInfoState(1,false); // JSH 130429 Info Timer stop

                //if(idAppMain.state == "AppRadioHdMain")
                    idRadioHdMain.jogFocusState = "FrequencyDial" // JSH jog focus

                idAppMain.returnToTouchMode()
                if (QmlController.searchState){
                    QmlController.seekstop();
                    idRadioHdFmFrequencyDial.requestStopSearch = true;
                    return;
                }
            }
            onReleased: {
                QmlController.playAudioBeep(); // JSH 120827 comment
                idAppMain.touchAni = true // dg.jin 140725 ITS KH 0244077, VI 0244078

                ///////////////////////////////////////////////////////////////////////////
                // JSH 130621 Info Window Delete
                //if(idAppMain.fmInfoFlag)
                //    idRadioHdMain.changeInfoState(2,false); // JSH 130429 Info Timer restart

                if(idRadioHdFmFrequencyDial.bManualTouch == true){
                    idRadioHdFmFrequencyDial.bManualTouch = false

                    if(!idRadioHdFmFrequencyDial.requestStopSearch)
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
                if(idRadioHdFmFrequencyDial.bManualTouch){
                    console.log("[CHECK_11_14_DRAG] : idRadioFmFrequencyDial.bManualTouch == true ");
                    idFreq.dialMouseX = mouseX;
                    idFreq.dialMouseY = mouseY;
                    idAppMain.touchAni = true // dg.jin 140725 ITS KH 0244077, VI 0244078
                    if(!idRadioHdFmFrequencyDial.requestStopSearch)
                        idFreq.functionMousePositionChanged(idFreq.dialMouseX,idFreq.dialMouseY);

                    idAppMain.touchAni = false // JSH 130422 added
                }
            }
        }

    } // # End Image

    //****************************** # Dial No Touch #
    Rectangle { // JSH Circle
        id:circle
        // HD // JSH 130621 Info Window Delete
        //        x: (idAppMain.hdRadioOnOff || idAppMain.menuInfoFlag) ? idFreq.x - 50  : idFreq.x + 50
        //        y: (idAppMain.hdRadioOnOff || idAppMain.menuInfoFlag) ? idFreq.y - 50  : idFreq.y + 50
        x: (idAppMain.hdRadioOnOff) ? idFreq.x - 50  : idFreq.x + 50
        y: (idAppMain.hdRadioOnOff) ? idFreq.y - 50  : idFreq.y + 50
        //         x:idFreq.x +50  ;y:idFreq.y+50
        width:{
            // HD // JSH 130621 Info Window Delete
            if(idAppMain.hdRadioOnOff){//if((idAppMain.hdRadioOnOff || idAppMain.menuInfoFlag)){
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
                ///////////////////////////////////////////////////////////////////////////
                // JSH 130621 Info Window Delete
                //if(QmlController.getRadioDisPlayType()||(idAppMain.fmInfoFlag)){//if((QmlController.getRadioDisPlayType())&&(!idAppMain.menuInfoFlag)){ // 120917 => JSH 130402 Info flick animation added
                if(QmlController.getRadioDisPlayType()){
                    idRadioHdMain.touchflick = true
                    touchX = mouseX
                    touchY = mouseY
                }
            }
            onReleased: {
                if(idRadioHdMain.touchflick){
                    if(touchY > mouseY + 20){          // up
                        idRadioHdMain.touchflick = false
                        if(QmlController.getRadioDisPlayType()) // hd
                            QmlController.hdRadioChange(1);     // idAppMain.menuHdRadioFlag = !idAppMain.hdRadioOnOff
                        ///////////////////////////////////////////////////////////////////////////
                        // JSH 130621 Info Window Delete
                        //else if(idAppMain.fmInfoFlag){          // Info
                        //    idRadioHdMain.changeInfoState(2,false)
                        //    jogFocusState = "FrequencyDial";
                        //}
                    }
                    else if(touchY < mouseY - 20 ){    // down
                        idRadioHdMain.touchflick = false
                        ///////////////////////////////////////////////////////////////////////////
                        // JSH 130621 Info Window Delete
                        //if(idAppMain.fmInfoFlag && (!QmlController.getRadioDisPlayType())) // info
                        //    idRadioHdMain.changeInfoState(1,idAppMain.fmInfoFlag);
                        if(idRadioHdMain.noSignal == 2)// JSH 131009 modify if(idRadioHdMain.noSignal) //else if(idRadioHdMain.noSignal)
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
        //source: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? imgFolderRadio+"frequency_dial_d.svg" : imgFolderRadio+"frequency_dial.svg"
        rotation: 180
        smooth: true
        transform: Rotation{
            id:idRot
            origin.x: 9; origin.y: 0
            angle: Math.min(Math.max(((startFmFrequency-86)*15), (globalSelectedFmFrequency-86)*15), ((endFmFrequency-86)*15))

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
    //    Keys.onPressed:{
    //        switch(event.key){
    //        case Qt.Key_Minus:{tuneKey(-1 , 2);break;}
    //        case Qt.Key_Equal:{tuneKey(1 , 2);break;}
    //        }
    //    }

    //****************************** # Dial Image#
    Image{
        //x: 99; y: menuInfoFlag || idAppMain.hdRadioOnOff? 210-systemInfo.headlineHeight-1+20+391 : 210-systemInfo.headlineHeight-1+20
        x: 99; y: 210-systemInfo.headlineHeight-1+20
        width: 375; height: 381
        source: imgFolderRadio+ "bg_frequency_n.png"// "bg_frequency.png"  , JSH 130715 modify
        //source: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"bg_frequency_d.png" : imgFolderRadio+"bg_frequency_n.png" //"bg_frequency.png"
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
    }

    //****************************** # Frequency value by station value #
    function frequencyStationText(){
        if(selectedStationBtn != 1 && (QmlController.getHDRadioCurrentSPS() != 0xFF))
            if((globalSelectedFmFrequency%1)==0)
                return globalSelectedFmFrequency+".0"+ "<font size=-34>"+"-"+selectedStationBtn+"</font>"
            else
                return globalSelectedFmFrequency.toFixed(1)+"<font size=-34>"+"-"+selectedStationBtn+"</font>"
        else
            return (globalSelectedFmFrequency%1)==0? globalSelectedFmFrequency+".0" : globalSelectedFmFrequency.toFixed(1)
    }


    //****************************** # Dial Save Button`s Text #
    Item{
        x: 0; y: 0 //y: menuInfoFlag || idAppMain.hdRadioOnOff? 391 : 0
        Text{
            id:idFmFreqText

            //            text: {
            //            if((globalSelectedFmFrequency%1)==0)
            //                return globalSelectedFmFrequency+".0"+ "<font size=-34>"+"-"+"6"+"</font>"
            //            else
            //                return globalSelectedFmFrequency.toFixed(1)+"<font size=-34>"+"-"+"6"+"</font>"
            //            }
            text: frequencyStationText()

            //            x: idFmFreqText.text.length == 5 ? 99+82+8 : idFmFreqText.text.length > 5 ? 99+82-8 : 99+82+33 ; // 99+82
            x:{
                //JSH 130619 Modify
                //                if((globalSelectedFmFrequency >= 100) && (selectedStationBtn == 1))    {return 99+82+8} //
                //                else if((globalSelectedFmFrequency < 100) && (selectedStationBtn == 1)){return 99+82+32}//
                //                else                                                                   {return 99+82-8}
                if((globalSelectedFmFrequency >= 100) && (selectedStationBtn == 1))    {return 99+82+5} //
                else if((globalSelectedFmFrequency < 100) && (selectedStationBtn == 1)){return 99+82+29}//
                else                                                                   {return 99+82-8}
            }
            y: 210-systemInfo.headlineHeight-1+20+173-70/2
            width: 61+8+72+69+20
            height: 70
            font.family: systemInfo.hdb
            font.pixelSize: selectedStationBtn != 1? 60 : 70                           //
            horizontalAlignment : (selectedStationBtn !=1)  ? Text.AlignHCenter : 0    //
            verticalAlignment: Text.AlignVCenter
            color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : selectedStationBtn != 1 ? colorInfo.brightGrey : colorInfo.subTextGrey
        }

        MComp.MButtonOnlyRadio{
            id: btnSave
        //// 2013.11.21 modified by qutiguy - change to stop while scan.
        property bool preventSave: (idAppMain.menuPresetScanFlag || idAppMain.menuScanFlag || idAppMain.menuAutoTuneFlag)
        ///////////////////////////////////////////////////////////////////////////////////////////
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
        x: 0; y: 0 //y: menuInfoFlag || idAppMain.hdRadioOnOff? 391 : 0
        Text{
            text: "88"
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
            text: "90"
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
            text: "92"
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
            text: "94"
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
            text: "96"
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
            text: "98"
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
            text: "100"
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
            text: "102"
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
            text: "104"
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
            text: "106"
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
            text: "108"
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
    //****************************** # Station Name #
    Item{
        x: 0; y: 0 //y: menuInfoFlag || idAppMain.hdRadioOnOff? 391 : 0
        visible: QmlController.radioDisPlayType == 0 // JSH 131211 added
        Text{
            text: idRadioHdMain.psText // (RBDS PS) // "SBS Power FM"
            x:691 - 659; y:668-systemInfo.headlineHeight-(34/2) -15
            width: 233; height: 34                               // width: 573; height: 36
            font.pixelSize: 34                                   // font.pixelSize: 36
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignRight                 // Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        } // # End Text
        Text{
            text: idRadioHdMain.ptyText  // PTY(RBDS) // "Classic Rock"
            x: 691-659+233+50-3; y: 668-systemInfo.headlineHeight-(24/2) -15
            width: 300; height: 24                              // width: 573; height: 28
            font.pixelSize: 24                                  // font.pixelSize: 28
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft                 //Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.dimmedGrey
        } // # End Text

        Image{ // RT
          x:554-(691-60); y: 671-systemInfo.headlineHeight
          source:imgFolderRadio_Hd+"bg_info.png"
          width: 726; height: 49
          visible: menuInfoFlag
          //////////////////////////////////////////////////////////////
          // Radio Text , JSH 130709 modify
            MComp.MTickerText{
                id: idText
                x: 105              ; y: 0
                width: 516          ; height: parent.height
                tickerTextSpacing   : 120
                tickerText          : idAppMain.rtText
                tickerTextSize      : 24
                tickerTextColor     : colorInfo.dimmedGrey
                tickerTextStyle     : systemInfo.hdr
                tickerTextAlies     : "Left"
                variantText         : true
                variantTextTickerEnable : (!idAppMain.drsShow) && (QmlController.getRadioDisPlayType() < 2) //idMBand.signalText == "" , JSH 131113 modify[ITS 0208893]
            }
           //          Text{
           //              text: idAppMain.rtText
           //              x: 105; y: 0
           //              width: 516; height: parent.height
           //              font.pixelSize: 24
           //              font.family: systemInfo.hdr
           //              horizontalAlignment: Text.AlignLeft
           //              verticalAlignment: Text.AlignVCenter
           //              color: colorInfo.dimmedGrey
           //          } // # End Text
           //////////////////////////////////////////////////////////////
        }
    }

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
            console.log(" [FM Dial onChangeSearchState ] value: "
                        + value + " requestStopSearch: " +
                        idRadioHdFmFrequencyDial.requestStopSearch );

            if( value == 0 && idRadioHdFmFrequencyDial.requestStopSearch == true ){
                idRadioHdFmFrequencyDial.requestStopSearch = false;
                idFreq.functionMousePositionChanged(idFreq.dialMouseX,idFreq.dialMouseY);
                idFreq.functionReleased();
            }
        }
        //onHdSignalPerceive:{ idHdLogo.source = (onoff && (!QmlController.getRadioDisPlayType()))? imgFolderRadio_Hd+"ico_hd_radio_d.png" : ""}
    }

    /////////////////////////////////////////////////////////////////
    //# HD Display Dial focus # JSH
    onActiveFocusChanged: {// JSH jog focus
        console.log("========================> FM onActiveFocusChanged :: ",idFreq.activeFocus)
        if((!idFreq.activeFocus) && idRadioHdMain.jogFocusState == "FrequencyDial" && idAppMain.state == "AppRadioHdMain"){
            console.log("========================> FM onActiveFocusChanged :: (!idFreq.activeFocus) ")
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
        console.log("========================> onIsFocusedChanged :: ",isFocused , QmlController.getRadioDisPlayType())
        if(QmlController.getRadioDisPlayType() > 1 && isFocused){//if((QmlController.getRadioDisPlayType() > 1) && isFocused && (!menuInfoFlag)){ => JSH 130402 delete [HD Info Delete]
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
