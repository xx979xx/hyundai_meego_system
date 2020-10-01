/**
 * FileName: RadioRdsFmFrequencyGradation.qml
 * Author: HYANG
 * Time: 2012-06
 *
 * - 2012-06 Initial Created by HYANG
 */

import QtQuick 1.0

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioRdsAmFrequencyGradation
    x: 0; y: 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    property string imgFolderRadio : imageInfo.imgFolderRadio
//    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_Rds
    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_RdsForPremium  //KSW 130731 for premium UX
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //************************************************************
    property int cursor_am_manual_position;

    property bool   requestStopSearch: false // JSH 120926

    property bool   bMenualTouch: false //dg.jin 20140317 Gradation press and Seek H/K problem

    //KSW 130731 for premium UX
    property int preset_am_position1 : (((QmlController.amPresetFreq1 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position2 : (((QmlController.amPresetFreq2 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position3 : (((QmlController.amPresetFreq3 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position4 : (((QmlController.amPresetFreq4 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position5 : (((QmlController.amPresetFreq5 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position6 : (((QmlController.amPresetFreq6 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position7 : (((QmlController.amPresetFreq7 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position8 : (((QmlController.amPresetFreq8 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position9 : (((QmlController.amPresetFreq9 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position10 : (((QmlController.amPresetFreq10 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position11 : (((QmlController.amPresetFreq11 - 522) / 9) * (1126/122) + 24);
    property int preset_am_position12 : (((QmlController.amPresetFreq12 - 522) / 9) * (1126/122) + 24);

    //KSW 131103 [ITS][194011][minor] freq value and position go to default value and position issue.
    property bool lostFocus : false;

    //added by Qutiguy 08.20 - check frequencyc bar is foused.
    property bool isFocused : (idRadioRdsAmFrequencyGradation.activeFocus )

    onIsFocusedChanged:{
        console.log("[[ UIListener.isDialFocus ]]",isFocused)
        UIListener.isDialFocus = isFocused;
    }

    //KSW 140107 ITS/219032
    Keys.onReleased:{
        console.log("######################## idRadioRdsAmFrequencyGradation onReleased : event.text = " +event.text);
        if(event.text == "ccp")
        {
            if(idAppMain.menuScanFlag == true)
            {
                QmlController.setIsTpSearching(false);
                QmlController.seekstop();
                idMBand.changeFocus();
            }
        }
    }

    //KSW 140107 ITS/219032
    onVisibleChanged:{
        console.log("idRadioRdsAmFrequencyGradation onVisibleChanged visible = " + visible);
        if(visible == true)
        {
            if(idAppMain.menuScanFlag == true)
                idRadioRdsAmFrequencyGradation.forceActiveFocus()
            else
            {
                //20141014 engmode band change focus issue
                if(idAppMain.state != "AppRadioRdsENGMode")
                    idMBand.changeFocus();
            }
        }
    }

//// Frequency Bar AM Image & Controller
  Image{
        id : idAmFrequencyBar
//        x : 0 ; y : 0; source: imgFolderRadio_Rds+"frequencybar/bg_band_am.png"
          x : 0 ; y : 0; source: imgFolderRadio_Rds +"bg_band_am.png" //KSW 130731 for premium UX
        MouseArea{
            anchors.fill: parent
            //dg.jin 20140912 EU AM range change 522 - 1620 -> 531 - 1602 for KH  //dg.jin 20150707 add guam
            property int validMax : (UIListener.getRadioRegionCode() == 0) ? 1202 - ((1126/122)*2) : 1202
            property int validMin : (UIListener.getRadioRegionCode() == 0) ? 76 + (1126/122) : 76
            onPressed: {
                console.log("######################## [Press] idAmFrequencyBar mouseX = " + mouseX);
                idRadioRdsMain.bIsScan = false; //KSW 140519
                idRadioRdsAmFrequencyGradation.forceActiveFocus(); //KSW 140223
                if((mouseX >= validMax) || (mouseX <= validMin ))
                    return;

                idAppMain.returnToTouchMode()
                idRadioRdsAmFrequencyGradation.bMenualTouch = true; //dg.jin 20140317 Gradation press and Seek H/K problem

                if (QmlController.searchState){
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.seekstop();
                    idRadioRdsAmFrequencyGradation.requestStopSearch = true;
                    cursor_am_manual_position = mouseX - (idCursor.width/2)
                    return;
                }
                cursor_am_position = mouseX - (idCursor.width/2)
                console.log("######################## [Press] idAmFrequencyBar : idCursor.x = " + cursor_am_position);
            }
            onReleased: {
                console.log("######################## [Release] idAmFrequencyBar mouseX = " + mouseX);
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsAmFrequencyGradation.bMenualTouch){
                    idRadioRdsAmFrequencyGradation.bMenualTouch = false;
                    QmlController.playAudioBeep();
                    if(!idRadioRdsAmFrequencyGradation.requestStopSearch)
                        playFrequency();
                }
            } //# End onPressed
            onMousePositionChanged: {
                console.log("######################## [MousePositionChanged] idAmFrequencyBar mouseX = " + mouseX);
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsAmFrequencyGradation.bMenualTouch) {
                    if((mouseX >= validMax) || (mouseX <= validMin ))
                        return;
                    if(idRadioRdsAmFrequencyGradation.requestStopSearch)
                        return;
                    cursor_am_position = mouseX - (idCursor.width/2)
                    console.log("######################## idAmFrequencyBar : idCursor.x = " + cursor_am_position);
                    getFrequency(cursor_am_position);
                }
            } //# End onPressed

            //dg.jin 20140317 Gradation press and Seek H/K problem
            Connections{
                target: UIListener
                onSignalTouchCancel:{
                    console.log("[CHECK_11_13_TOUCH_CANCEL]############################  touch - onSignalTouchCancel");
                    if(idRadioRdsAmFrequencyGradation.bMenualTouch){
                        getFrequency(cursor_am_position);
                        playFrequency();
                        idRadioRdsAmFrequencyGradation.bMenualTouch = false;
                    }
                }
            }
        }
    }

//// CCP Focus Image
  Image{
        //x : 0 ; y : 0; source: imgFolderRadio_Rds+"bg_band_f.png"
        x : 0 ; y : 0; source: imgFolderRadio_Rds +"bg_band_focus.png" //KSW 130731 for premium UX

        width:  idAmFrequencyBar.width
        visible : idAppMain.focusOn && idRadioRdsAmFrequencyGradation.activeFocus
  }

//// Frequency Guage Image & Controller
    Item {
        id: idCursor
        x :cursor_am_position ; y: 0
        width: 106; height: 125
        Image {
            anchors.fill: parent
//            source: imgFolderRadio_Rds+"frequencybar/cursor.png"
            source: imgFolderRadio_Rds + "cursor.png" //KSW 130731 for premium UX
        }
        MouseArea{
            id: idCursorController
            anchors.fill: parent
            drag.target: idCursor
            drag.axis: Drag.XAxis

            //dg.jin 20140912 EU AM range change 522 - 1620 -> 531 - 1602 for KH  //dg.jin 20150707 add guam
            drag.minimumX: (UIListener.getRadioRegionCode() == 0) ? 24 + (1126/122) : 24
            drag.maximumX: (UIListener.getRadioRegionCode() == 0) ? 1150 - ((1126/122)*2) : 1150

            onPressed: {
                console.log("######################## [Press] idCursorController mouseX = " + mouseX);
                idRadioRdsMain.bIsScan = false; //KSW 140519
                idRadioRdsAmFrequencyGradation.bMenualTouch = true; //dg.jin 20140317 Gradation press and Seek H/K problem
                if (QmlController.searchState)
                {
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.seekstop();
                }
                idRadioRdsAmFrequencyGradation.forceActiveFocus(); //KSW 140223
            } //# End onPressed
            onReleased: {
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsAmFrequencyGradation.bMenualTouch){
                    idRadioRdsAmFrequencyGradation.bMenualTouch = false;
                    if(lostFocus == true)//KSW 131103 [ITS][194011][minor] freq value and position go to default value and position issue.
                        refreshCursor();
                    console.log("######################## [Release] idCursorController mouseX = " + mouseX);
                    playFrequency();
                    lostFocus = false;  //KSW 131103 [ITS][194011][minor]
                    console.log("######################## [Release] lostFocus(" + lostFocus + ")");
                }
            } //# End onPressed
            onMousePositionChanged: {
                //KSW 131103 [ITS][194011][minor] freq value and position go to default value and position issue.
                console.log("######################## [MousePositionChanged] idCursorController : idCursor.x = " + idCursor.x);
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsAmFrequencyGradation.bMenualTouch) {
                    if(mouseX <= 0)
                    {
                        lostFocus = true;
                        console.log("######################## [MousePositionChanged] return lostFocus(1)");
                    }else{
                        cursor_am_position = idCursor.x;
                       getFrequency(idCursor.x);
                    }
                }
            } //# End onPressed

            //dg.jin 20140317 Gradation press and Seek H/K problem
            Connections{
                target: UIListener
                onSignalTouchCancel:{
                    console.log("[CHECK_11_13_TOUCH_CANCEL]############################  touch - onSignalTouchCancel");
                    if(idRadioRdsAmFrequencyGradation.bMenualTouch){
                        getFrequency(cursor_am_position);
                        playFrequency();
                        idRadioRdsAmFrequencyGradation.bMenualTouch = false;
                    }
                }
            }
        }
    }

    //KSW 130731 for premium UX
    Item {
        id: idpreset1
        x :preset_am_position1 + 51  ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset2
        x :preset_am_position2 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset3
        x :preset_am_position3 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset4
        x :preset_am_position4 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset5
        x :preset_am_position5 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset6
        x :preset_am_position6 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset7
        x :preset_am_position7 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset8
        x :preset_am_position8 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset9
        x :preset_am_position9 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset10
        x :preset_am_position10 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset11
        x :preset_am_position11 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset12
        x :preset_am_position12 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
//// End idCursor

    function getFrequency(xposition){
        //****************************** # AM Calculator #
        var calculationTemp;
        calculationTemp = ((xposition - 24) / (1126/122));
        calculationTemp = calculationTemp.toFixed(0);
        idAppMain.globalSelectedAmFrequency  = 522 + (calculationTemp * 9);

    }
    function playFrequency(){
            QmlController.setRadioFreq(globalSelectedAmFrequency);
    }// End functionReleased()

    //KSW 131103 [ITS][194011][minor] freq value and position go to default value and position issue.
    function refreshCursor(){
        cursor_am_position++;
        cursor_am_position--;
        console.log("######################## [refreshCursor] cursor_am_position = " + cursor_am_position);
    }

    ////////////////////////////////////////////////////////////////////////////////////
    Connections {
        target: QmlController
        onChangeSearchState: {
            console.log(" [RDS AM onChangeSearchState ] search state = "
                        + value + " requestStopSearch = " +
                        idRadioRdsAmFrequencyGradation.requestStopSearch );

            if( value == 0 && idRadioRdsAmFrequencyGradation.requestStopSearch == true ){
                idRadioRdsAmFrequencyGradation.requestStopSearch = false;
                getFrequency(cursor_am_manual_position);
                playFrequency();
            }
        }
    }
/*->
//    MComp.MButton{
      MComp.MButtonOnlyRadio{
        id: idCursor
        x : cursor_am_position
        y: 165-186
        width: 170; height: 140  // width: 10; height: 183
        bgImage: imgFolderRadio_Rds+"cursor.png"
        bgImagePress: imgFolderRadio_Rds+"cursor.png"
    } //# End MButton

//    MComp.MButton{
    MComp.MButtonOnlyRadio{
        id: idGradationArea
        x: 0; y: 0
        width: 1250; height: 107
        focus: true
        bgImageFocus: imgFolderRadio_Rds+"bg_band_f.png"
        property int barMouseX : 0

        MouseArea{
            anchors.fill: parent
            drag.target: idCursor
            drag.axis: Drag.XAxis
//            drag.minimumX: 5
            height: idGradationArea.height
            width: idGradationArea.width
            x: 0+idCursor.width/2
            y: 0
            drag.minimumX: -68
            drag.maximumX: 1149

            onPressed: {
                idRadioRdsAmFrequencyGradation.bMenualTouch = true;
                if (QmlController.searchState){
                    QmlController.seekstop();
                    idRadioRdsAmFrequencyGradation.requestStopSearch = true;
                    return;
                }
            } //# End onPressed
            onReleased: {
                if(idRadioRdsAmFrequencyGradation.bMenualTouch){
                    idRadioRdsAmFrequencyGradation.bMenualTouch = false;
                }

                if(!idRadioRdsAmFrequencyGradation.requestStopSearch)
                    idGradationArea.functionReleased();
            } //# End onReleased

            onMousePositionChanged: {
                if(idRadioRdsAmFrequencyGradation.bMenualTouch){

                    idGradationArea.barMouseX = mouseX;
                    if(!idRadioRdsAmFrequencyGradation.requestStopSearch)
                        idGradationArea.functionMousePositionChanged(idGradationArea.barMouseX);

                } //# End if
            } //# End onmousePositionChanged
        } //# End MouseArea
        Keys.onPressed:{ //Here 0911 RDS Radio to Display CCP Mode
            switch(event.key){
            case Qt.Key_Semicolon: //HWS 130114
            case Qt.Key_Left:{
//                if(globalSelectedBand == "FM"){
//                    idCursor.x = idCursor.x  - 5
//                    idAppMain.globalSelectedFmFrequency = (idAppMain.globalSelectedFmFrequency-stepFmFrequency).toFixed(1);
//                    QmlController.setRadioFreq(globalSelectedFmFrequency);
//                }
//                else if(globalSelectedBand == "AM"){
//                    idCursor.x = idCursor.x  - 10
//                    idAppMain.globalSelectedAmFrequency  = idAppMain.globalSelectedAmFrequency -stepAmFrequency
//                    QmlController.setRadioFreq(globalSelectedAmFrequency);
//                }
                break;
            }
            case Qt.Key_Apostrophe: //HWS 130114
            case Qt.Key_Right:{
//                if(globalSelectedBand == "FM"){
//                    idCursor.x = idCursor.x  + 5
//                    idAppMain.globalSelectedFmFrequency = (idAppMain.globalSelectedFmFrequency + stepFmFrequency).toFixed(1);
//                    QmlController.setRadioFreq(globalSelectedFmFrequency);
//                }
//                else if(globalSelectedBand == "AM"){
//                    idCursor.x = idCursor.x  + 10
//                    idAppMain.globalSelectedAmFrequency  = idAppMain.globalSelectedAmFrequency + stepAmFrequency
//                    QmlController.setRadioFreq(globalSelectedAmFrequency);
//                }
                break;
            }
            } //# End switch
        } //# End KeysonPressed
        ////////////////////////////////////////////////////////////////////////////////////
        //JSH 120926 MButton Function
        function functionReleased(){

                QmlController.setRadioFreq(globalSelectedAmFrequency);

        }// End functionReleased()

        function functionMousePositionChanged(mouseX){
            var calculationTemp;

                if( mouseX < 17 ){
                    idAppMain.globalSelectedAmFrequency = startAmFrequency;
                    return;
                }
                //if( mouse.x > 1234){
                if( mouseX > 1234){
                    idAppMain.globalSelectedAmFrequency = endAmFrequency;
                    return;
                }
                //idCursor.x = mouse.x - idCursor.width/2 ; //# cursor image`s position moving when click

                //if(mouse.x <= 14){
                if(mouseX <= 14){
                    //calculationTemp = 512
                    calculationTemp = 513
                    idAppMain.globalSelectedAmFrequency  = calculationTemp.toFixed(0)
                }
                else{
                    //calculationTemp = ((mouse.x-5) / 10)
                    calculationTemp = ((mouseX-5) / 10)
                    calculationTemp = calculationTemp.toFixed(0)
                    idAppMain.globalSelectedAmFrequency  = 513 + (calculationTemp * 9)
                    idAppMain.globalSelectedAmFrequency  = idAppMain.globalSelectedAmFrequency.toFixed(0)
                }

        }
        //End Function
        ////////////////////////////////////////////////////////////////////////////////////
        Connections {
            target: QmlController
            onChangeSearchState: {
                if( value == 0 && idRadioRdsAmFrequencyGradation.requestStopSearch == true ){
                    idRadioRdsFmFrequencyGradation.requestStopSearch = false;
                    idGradationArea.functionMousePositionChanged(idGradationArea.barMouseX);
                    idGradationArea.functionReleased();
                }
            }
        }
    } //# End MButton
<-*/
} //# End FocusScope
