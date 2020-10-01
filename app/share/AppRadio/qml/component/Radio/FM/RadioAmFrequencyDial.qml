/**
 * FileName: RadioAmFrequencyDial.qml
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
    id: idRadioAmFrequencyDial
    x: 0; y: 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioStringInfo{ id: stringInfo }

    property string imgFolderRadio   : imageInfo.imgFolderRadio
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    property real   selectedAngle    : 0
    property real   calculationTemp  : 0

    property string strAmStationName : QmlController.boradcastName
    property bool   bManualTouch
    property bool   requestStopSearch: false
    ////////////////////////////////////////////////

    //added by Qutiguy 07.04
    property bool isFocused : (idRadioAmFrequencyDial.activeFocus && showFocus)

    onIsFocusedChanged:{
        console.log("[[this is handler for changing property]]",isFocused)
        UIListener.isDialFocus = isFocused;
    }

    //****************************** # Background #
    Image{ // JSH 130706
        x: -691
        z:-1
        source: presetAndDialBackground == "FrequencyDial" ? imgFolderGeneral+"bg_menu_r.png" : ""
    }
    Image{
        x: 585-691
        //source: idRadioAmFrequencyDial.activeFocus && showFocus ? imgFolderGeneral+"bg_menu_r_s.png" : ""
        source: presetAndDialBackground == "FrequencyDial" ? imgFolderGeneral+"bg_menu_r_s.png" : ""
    }
    //****************************** # Dial Save Button`s Background Image #
    MComp.MButtonOnlyRadio{
        id:idFreq
        x: 99; y: 210-systemInfo.headlineHeight-1+20
        width: 375; height: 381
        focus: true
        Image{source: imgFolderRadio+"bg_frequency_12_n.png"}//"bg_frequency_12.png"}
        //Image{source: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"bg_frequency_12_d.png" : imgFolderRadio+"bg_frequency_12_n.png"}
        bgImageFocus: imgFolderRadio+"bg_frequency_f.png"
        bgImagePress: imgFolderRadio+"bg_frequency_f.png" // JSH 130426 added
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)

        property  real  touchAngle: 0
        property  real localSelectedAmFrequency : 0
        property  int  dialMouseX : 0
        property  int  dialMouseY : 0

        //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
        property  real  rollBackFrequency : 0
        ////

        function functionReleased(){
            var frequency = idFreq.localSelectedAmFrequency //globalSelectedAmFrequency
            if((startAmFrequency <= idFreq.localSelectedAmFrequency) && (endAmFrequency >=idFreq.localSelectedAmFrequency))
            {
                idAppMain.doNotUpdate = true;
                QmlController.setRadioFreq(idFreq.localSelectedAmFrequency);//(globalSelectedAmFrequency);
                idAppMain.doNotUpdate = false;
                globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
            } else {
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
            if(idFreq.touchAngle >=(((startAmFrequency-423)/3.6) - 5 ) && idFreq.touchAngle <= (((endAmFrequency-423)/3.6) + 5)){
                selectedAngle  = idFreq.touchAngle
                selectedAngle = selectedAngle.toFixed(0)
                calculationTemp = ((selectedAngle-((startAmFrequency -423)/3.6))/2.5)
                calculationTemp = calculationTemp.toFixed(0)
                //globalSelectedAmFrequency = startAmFrequency + (calculationTemp *stepAmFrequency)
                idFreq.localSelectedAmFrequency = startAmFrequency + (calculationTemp *stepAmFrequency)
                //globalSelectedAmFrequency = globalSelectedAmFrequency.toFixed(0)
                idFreq.localSelectedAmFrequency = idFreq.localSelectedAmFrequency.toFixed(0)

                if((startAmFrequency <= idFreq.localSelectedAmFrequency) && (endAmFrequency >=idFreq.localSelectedAmFrequency)) {
                    globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
                } else if(startAmFrequency > idFreq.localSelectedAmFrequency) {
                    idFreq.localSelectedAmFrequency = startAmFrequency;
                    globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
                } else if(endAmFrequency < idFreq.localSelectedAmFrequency) {
                    idFreq.localSelectedAmFrequency = endAmFrequency;
                    globalSelectedAmFrequency = idFreq.localSelectedAmFrequency;
                }
//                        idAppMain.touchAmAniStop = false
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
        //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
        onPreventDrag: {
            console.log("[CHECK_11_14_DRAG] : onPreventDrag bManualTouch = " + bManualTouch );
            if(bManualTouch){
                idAppMain.globalSelectedAmFrequency = idFreq.rollBackFrequency;
                bManualTouch = false;
            }
        }
        ////

        //////////////////////////////////////////////////////////////////
        onClickOrKeySelected: {
            //// 2013.11.21 modified by qutiguy - change to stop while scan.
            if(btnSave.preventSave){
                var searchValue = QmlController.getsearchState();
                QmlController.setsearchState(searchValue);
                return;
            }
            /////////////////////////////////////////////////////////////////////////
            // JSH 121121 , popup preset List Delete
            //                if(!idAppMain.alreadySaved)
            //                    setAppMainScreen( "PopupRadioPreset" , true);
            ////////////////////////////////////////////////////////////////////////
            //if(!idAppMain.presetSaveEnabled){                                                 // JSH 130822 Modify
            if((!idAppMain.presetSaveEnabled) && (idAppMain.state != "AppRadioOptionMenu")){  // JSH 130822 Modify
                if( QmlController.searchState )
                    QmlController.seekstop();
                idAppMain.presetSaveEnabled = true;
            }
        }

        MouseArea{
            id:mouse
            anchors.fill : parent
            onPressed: {
                idRadioAmFrequencyDial.bManualTouch = true
                //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
                idFreq.rollBackFrequency = idAppMain.globalSelectedAmFrequency;
                //// 2013.12.11 modified by qutiguy - ITS 0214716
                console.log("[CHECK_11_14_PRESS] : onPressed() rollBackFrequency = " + idFreq.rollBackFrequency);
                ////
                idAppMain.touchAni = true // JSH 130422 added
                if(idAppMain.state == "AppRadioMain")
                    idRadioMain.jogFocusState = "FrequencyDial" // JSH jog focus

                idAppMain.returnToTouchMode()
                if (QmlController.searchState){
                    QmlController.seekstop();
                    idRadioAmFrequencyDial.requestStopSearch = true;
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
                if(idRadioAmFrequencyDial.bManualTouch == true){
                    idRadioAmFrequencyDial.bManualTouch = false

                    if(!idRadioAmFrequencyDial.requestStopSearch)
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

                if(idRadioAmFrequencyDial.bManualTouch){
                    console.log("[CHECK_11_14_DRAG] : idRadioAmFrequencyDial.bManualTouch == true ");
                    idFreq.dialMouseX = mouseX;
                    idFreq.dialMouseY = mouseY;
                    idAppMain.touchAni = true // dg.jin 140725 ITS KH 0244077, VI 0244078
                    if(!idRadioAmFrequencyDial.requestStopSearch)
                        idFreq.functionMousePositionChanged(idFreq.dialMouseX,idFreq.dialMouseY);

                    idAppMain.touchAni = false // JSH 130422 added
                }
            }
        }
    } // # End Image

    //****************************** # Dial No Touch #
    Rectangle { // JSH Circle
        id:circle
        x:idFreq.x +50  ;y:idFreq.y+50
         width: idFreq.width<idFreq.height?idFreq.width-100  : idFreq.height -100
         height: width
//         color: "red"
//         border.color: "red"
//         border.width: 1
         radius: width*0.5
         opacity : 0.001
         clip:true
         MouseArea{
             id: circleMouseArea
             anchors.fill: circle
             onPressed:mouse.accepted = circleMouseArea.contains(mouse.x, mouse.y);

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
        x: 868+100-691; y: 233-systemInfo.headlineHeight-1+188 //15
        source:  imgFolderRadio+"frequency_dial_n.svg" //frequency_dial.svg" , JSH 130706 modify
        //source: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? imgFolderRadio+"frequency_dial_d.svg" : imgFolderRadio+"frequency_dial_n.svg"
        rotation: 180
        smooth: true
        transform: Rotation{
            id:idRot
            origin.x: 9; origin.y: 0
            //  angle: Math.min(Math.max(((startAmFrequency-414)/3.9), ((globalSelectedAmFrequency-414)/3.9)), ((endAmFrequency-414)/3.9))
            angle: Math.min(Math.max(((startAmFrequency-423)/3.6), ((globalSelectedAmFrequency-423)/3.6)), ((endAmFrequency-423)/3.6))
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
//            case Qt.Key_Minus:{idRadioMain.decreasetune();break;}
//            case Qt.Key_Equal:{idRadioMain.increasetune();break;}
//        }
//    }

    //****************************** # Dial Image#
    Image{
        x: 99; y: 210-systemInfo.headlineHeight-1+20
        width: 375; height: 381
        source: QmlController.getRadioType() == 0 ? imgFolderRadio+ "bg_frequency_n.png" : imgFolderRadio+ "bg_frequency.png" // JSH 130706 modify
        //source: idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled ? imgFolderRadio+"bg_frequency_d.png" : imgFolderRadio+"bg_frequency_n.png" //"bg_frequency.png"
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
    }

    //****************************** # Dial Save Button`s Text #
    Text{
        id:idAmFreqText
        text: globalSelectedAmFrequency
        //x:idAmFreqText.text.length == 3 ? 99+82+42 : 99+82+20
        x:{
            if((globalSelectedAmFrequency >= 1000))    {return 99+82+17}//{return 99+82+20} ,JSH 130619 Modify
            else if((globalSelectedAmFrequency < 1000)){return 99+82+39}//{return 99+82+42} ,JSH 130619 Modify
        }
        y: 210-systemInfo.headlineHeight-1+20+173-70/2
        width: 61+8+72+69; height: 70
        font.pixelSize: 70
        font.family: systemInfo.hdb
        //horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.subTextGrey
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
        firstText: preventSave?stringInfo.strRadioPreventSave:stringInfo.strRadioSave
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
            //setAppMainScreen( "PopupRadioPreset" , true);
            if((!idAppMain.presetSaveEnabled) && (idAppMain.state != "AppRadioOptionMenu")){  // JSH 130822 Modify
                if( QmlController.searchState )
                    QmlController.seekstop();
                idAppMain.presetSaveEnabled = true;
            }
            ////////////////////////////////////////////////////////
        }
    }

    //****************************** # Frequency TextValue #
    Text{
        text: "531"
        x: 706+23+49+23+10-691; y: 238-systemInfo.headlineHeight-1+81+103+103+81-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "639"
        x: 706+23-691; y: 238-systemInfo.headlineHeight-1+81+103+103-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "747"
        x: 706-691; y: 238-systemInfo.headlineHeight-1+81+103-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "855"
        x: 706+23-691; y: 238-systemInfo.headlineHeight-1+81-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "963"
        x: 706+23+49+23+10-691; y: 238-systemInfo.headlineHeight-1-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "1071"
        x: 99+82+61+8; y: 210-systemInfo.headlineHeight-1-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "1179"
        x: 706+23+49+23+10+72+190-691; y: 238-systemInfo.headlineHeight-1-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "1287"
        x: 706+23+49+23+10+72+190+72+5-691; y: 238-systemInfo.headlineHeight-1+81-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "1395"
        x: 706+23+49+23+10+72+190+72+5+23-691; y: 238-systemInfo.headlineHeight-1+81+103-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }
    Text{
        text: "1503"
        x: 706+23+49+23+10+72+190+72+5-691; y: 238-systemInfo.headlineHeight-1+81+103+103-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    } // # End TextValue
    Text{
        text: "1602"//"1611"
        x: 706+23+49+23+10+72+190-691; y: 238-systemInfo.headlineHeight-1+81+103+103+81-28/2
        width: 71; height: 28
        font.pixelSize: 28
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled) ? colorInfo.dimmedGrey : colorInfo.brightGrey
    } // # End TextValue

    //****************************** # Station Name #
    Text{
        text: strAmStationName//"SBS Power FM"
        x: 0; y: 210-systemInfo.headlineHeight-1+20+152+36+39+207-45/2
        width: 573; height: 45
        font.pixelSize: 45
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    } // # End Text

    //****************************** # Scan Image #
    Image{
        id: scanIcon
        property bool bShowIcon : true ;
        x: 1208-691; y: 179-systemInfo.headlineHeight-1
        width: 57; height: 57
        source: imgFolderRadio+"ico_radio_scan.png"
        visible: ((menuScanFlag || menuPresetScanFlag) && bShowIcon)
        opacity: 1
        /////////////////////////////////////////////////////////////////
          Timer{
              id : scanIconTimerAM
              interval : 500
              running : ((QmlController.radioBand == 3 ) && (menuScanFlag || menuPresetScanFlag))
              repeat : true
              onTriggered : {scanIcon.bShowIcon = !scanIcon.bShowIcon;}
          }

    }
    //****************************** # Auto Tune Image #
    Image{
        x: 1208-691; y: 179-systemInfo.headlineHeight-1
        width: 57; height: 57
        source: imgFolderRadio+"ico_radio_autotune.png"
        visible: menuAutoTuneFlag
    }

    Connections {
        target: QmlController
        onChangeSearchState: {
            console.log(" [AM Dial onChangeSearchState ] value: "
                        + value + " requestStopSearch: " +
                        idRadioAmFrequencyDial.requestStopSearch );

            if( value == 0 && idRadioAmFrequencyDial.requestStopSearch == true ){
                idRadioAmFrequencyDial.requestStopSearch = false;
                idFreq.functionMousePositionChanged(idFreq.dialMouseX,idFreq.dialMouseY);
                idFreq.functionReleased();
            }
        }
    }
    /////////////////////////////////////////////////////////////////
    //# focus change #JSH // JSH jog focus 
    onActiveFocusChanged: { 
        console.log("========================> AM onActiveFocusChanged :: ",idFreq.activeFocus,idRadioMain.jogFocusState)
        if((!idFreq.activeFocus) && idRadioMain.jogFocusState == "FrequencyDial" && idAppMain.state == "AppRadioMain"){
            console.log("========================> AM onActiveFocusChanged :: (!idFreq.activeFocus) ")
            focus = true;
        }
        if(idFreq.activeFocus){//if(idRadioAmFrequencyDial.activeFocus){ //#120905
            idAppMain.arrowUp = true
            idAppMain.arrowDown = false
            idAppMain.arrowLeft = true
            idAppMain.arrowRight = false
            QmlController.setQmlFocusState(1); // JSH 121228
        }else{
            if(btnSave.state == "pressed")
                btnSave.state = "normal"
        }
    }
}
