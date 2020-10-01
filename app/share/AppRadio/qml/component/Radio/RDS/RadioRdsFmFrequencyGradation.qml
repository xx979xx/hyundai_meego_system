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
    id: idRadioRdsFmFrequencyGradation
    x: 0; y: 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    property string imgFolderRadio : imageInfo.imgFolderRadio
//    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_Rds
    property string imgFolderRadio_Rds : imageInfo.imgFolderRadio_RdsForPremium  //KSW 130731 for premium UX
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //******************************# 121026 frequency calculate 0.05 step
    property int totalStepNum: (UIListener.getRadioRegionCode() == 0) ? 205 :410 // KSW 140327 410 : 50 kstep = 205 : 100 kstep  //dg.jin 20150707 add guam
    //************************************************************
    property int cursor_fm_manual_position;

    property bool   requestStopSearch: false // JSH 120926

    property bool   bMenualTouch: false   //dg.jin 20140317 Gradation press and Seek H/K problem

    //KSW 130731 for premium UX
    //dg.jin 20150311 preset position error
    property int preset_fm_position1 : ((QmlController.fmPresetFreq1 - 8750) * 1152/(410*5));
    property int preset_fm_position2 : ((QmlController.fmPresetFreq2 - 8750) * 1152/(410*5));
    property int preset_fm_position3 : ((QmlController.fmPresetFreq3 - 8750) * 1152/(410*5));
    property int preset_fm_position4 : ((QmlController.fmPresetFreq4 - 8750) * 1152/(410*5));
    property int preset_fm_position5 : ((QmlController.fmPresetFreq5 - 8750) * 1152/(410*5));
    property int preset_fm_position6 : ((QmlController.fmPresetFreq6 - 8750) * 1152/(410*5));
    property int preset_fm_position7 : ((QmlController.fmPresetFreq7 - 8750) * 1152/(410*5));
    property int preset_fm_position8 : ((QmlController.fmPresetFreq8 - 8750) * 1152/(410*5));
    property int preset_fm_position9 : ((QmlController.fmPresetFreq9 - 8750) * 1152/(410*5));
    property int preset_fm_position10 : ((QmlController.fmPresetFreq10 - 8750) * 1152/(410*5));
    property int preset_fm_position11 : ((QmlController.fmPresetFreq11 - 8750) * 1152/(410*5));
    property int preset_fm_position12 : ((QmlController.fmPresetFreq12 - 8750) * 1152/(410*5));

    //KSW 131103 [ITS][194011][minor] freq value and position go to default value and position issue.
    property bool lostFocus : false;


    //added by Qutiguy 08.20 - check frequencyc bar is foused.
    property bool isFocused : (idRadioRdsFmFrequencyGradation.activeFocus )

    onIsFocusedChanged:{
        console.log("[[ UIListener.isDialFocus ]]",isFocused)
        UIListener.isDialFocus = isFocused;
    }

    //KSW 140107 ITS/219032
    Keys.onReleased:{
        console.log("######################## idRadioRdsFmFrequencyGradation onReleased : event.text = " +event.text);
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
        console.log("idRadioRdsFmFrequencyGradation onVisibleChanged visible = " + visible);
        if(visible == true)
        {
            if(idAppMain.menuScanFlag == true)
                idRadioRdsFmFrequencyGradation.forceActiveFocus()
            else
            {
                //20141014 engmode band change focus issue
                if(idAppMain.state != "AppRadioRdsENGMode")
                    idMBand.changeFocus();
            }
        }
    }

//// Frequency Bar FM Image & Controller
    Image{
        id : idFmFrequencyBar
//        x : 0 ; y : 0; source: imgFolderRadio_Rds+"frequencybar/bg_band_fm.png"
        x : 0 ; y : 0; source: imgFolderRadio_Rds +"bg_band_fm.png" //KSW 130731 for premium UX
        MouseArea{
            anchors.fill: parent
            property int validMax : 1204
            property int validMin : 54
            onPressed: {
                console.log("######################## [Press] idFmFrequencyBar mouseX = " + mouseX);
                idRadioRdsMain.bIsScan = false; //KSW 140519
                idRadioRdsFmFrequencyGradation.forceActiveFocus(); //KSW 140223
                if((mouseX >= validMax) || (mouseX <= validMin ))
                    return;

                idAppMain.returnToTouchMode()
                idRadioRdsFmFrequencyGradation.bMenualTouch = true; //dg.jin 20140317 Gradation press and Seek H/K problem

                if (QmlController.searchState){
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.seekstop();
                    idRadioRdsFmFrequencyGradation.requestStopSearch = true;
                    cursor_fm_manual_position = mouseX - (idCursor.width/2);
                    return;
                }

                cursor_fm_position = mouseX - (idCursor.width/2)
                console.log("######################## [Press] idFmFrequencyBar : idCursor.x = " + cursor_fm_position);
            }

            onReleased: {
                console.log("######################## [Release] idFmFrequencyBar mouseX = " + mouseX);
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsFmFrequencyGradation.bMenualTouch){
                    idRadioRdsFmFrequencyGradation.bMenualTouch = false;
                    QmlController.playAudioBeep();
                    if(!idRadioRdsFmFrequencyGradation.requestStopSearch)
                        playFrequency();
                }
            } //# End onPressed

            onMousePositionChanged: {
                console.log("######################## [MousePositionChanged] idFmFrequencyBar mouseX = " + mouseX);
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsFmFrequencyGradation.bMenualTouch) {
                    if((mouseX >= validMax) || (mouseX <= validMin ))
                        return;
                    if(idRadioRdsFmFrequencyGradation.requestStopSearch)
                        return;
                    cursor_fm_position = mouseX - (idCursor.width/2)
                    console.log("######################## [MousePositionChanged] idFmFrequencyBar : idCursor.x = " + cursor_fm_position);
                    getFrequency(cursor_fm_position);
                }
            } //# End onPressed

            //dg.jin 20140317 Gradation press and Seek H/K problem
            Connections{
                target: UIListener
                onSignalTouchCancel:{
                    console.log("[CHECK_11_13_TOUCH_CANCEL]############################  touch - onSignalTouchCancel");
                    if(idRadioRdsFmFrequencyGradation.bMenualTouch){
                        getFrequency(cursor_fm_position);
                        playFrequency();
                        idRadioRdsFmFrequencyGradation.bMenualTouch = false;
                    }
                }
            }
        }
    }

//// CCP Focus Image
    Image{
//          x : 0 ; y : 0; source: imgFolderRadio_Rds+"bg_band_f.png"
          x : 0 ; y : 0; source: imgFolderRadio_Rds +"bg_band_focus.png" //KSW 130731 for premium UX
          width:  idFmFrequencyBar.width
          visible : idAppMain.focusOn && idRadioRdsFmFrequencyGradation.activeFocus
    }

//// Frequency Guage Image & Controller
    Item {
        id: idCursor
        x :cursor_fm_position ; y: 0
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

            drag.minimumX: 0
            drag.maximumX: 1152

            onPressed: {
                console.log("######################## [Press] idCursorController mouseX = " + mouseX);
                idRadioRdsMain.bIsScan = false; //KSW 140519
                idRadioRdsFmFrequencyGradation.bMenualTouch = true; //dg.jin 20140317 Gradation press and Seek H/K problem
                if (QmlController.searchState)
                {
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.seekstop();
                }
                idRadioRdsFmFrequencyGradation.forceActiveFocus(); //KSW 140223
            } //# End onPressed
            onReleased: {
                //dg.jin 20140317 Gradation press and Seek H/K problem
                if(idRadioRdsFmFrequencyGradation.bMenualTouch){
                    idRadioRdsFmFrequencyGradation.bMenualTouch = false;
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
                if(idRadioRdsFmFrequencyGradation.bMenualTouch) {
                    if(mouseX <= 0)
                    {
                        lostFocus = true;
                        console.log("1######################## [MousePositionChanged] return lostFocus(1)");
                    }else{
                        cursor_fm_position = idCursor.x;
                        getFrequency(idCursor.x);
                    }
                }
            } //# End onPressed

            //dg.jin 20140317 Gradation press and Seek H/K problem
            Connections{
                target: UIListener
                onSignalTouchCancel:{
                    console.log("[CHECK_11_13_TOUCH_CANCEL]############################  touch - onSignalTouchCancel");
                    if(idRadioRdsFmFrequencyGradation.bMenualTouch){
                        getFrequency(cursor_fm_position);
                        playFrequency();
                        idRadioRdsFmFrequencyGradation.bMenualTouch = false;
                    }
                }
            }
        }
    }

    //KSW 130731 for premium UX
    Item {
        id: idpreset1
        x :preset_fm_position1 + 51  ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset2
        x :preset_fm_position2 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset3
        x :preset_fm_position3 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset4
        x :preset_fm_position4 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset5
        x :preset_fm_position5 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset6
        x :preset_fm_position6 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset7
        x :preset_fm_position7 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset8
        x :preset_fm_position8 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset9
        x :preset_fm_position9 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset10
        x :preset_fm_position10 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset11
        x :preset_fm_position11 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
    Item {
        id: idpreset12
        x :preset_fm_position12 + 51 ; y: 102
        width: 8; height: 23
        Image {
            anchors.fill: parent
            source: imgFolderRadio_Rds + "ico_preset.png"
        }
    }
//// End idCursor

    function getFrequency(xposition){
        //****************************** # FM Calculator #
        var intPoint, endPoint

        //KSW 140327  //dg.jin 20150707 add guam
        if(UIListener.getRadioRegionCode() == 0)
            intPoint = ((xposition / (1152/totalStepNum) ) * 10) + (startFmFrequency * 100) // 10 : 0.1 * 100
        else
            intPoint = ((xposition / (1152/totalStepNum) ) * 5) + (startFmFrequency * 100) // 5 : 0.05 * 100

        frequenyCalculatorValue = (intPoint / 10)
        frequenyCalculatorValue = frequenyCalculatorValue * 10
        //KSW 140327  //dg.jin 20150707 add guam
        if(UIListener.getRadioRegionCode() != 0)
        {
            endPoint = ( intPoint % 10 )
            if(endPoint >= 5 && endPoint <= 9) frequenyCalculatorValue = frequenyCalculatorValue - 5
        }
            globalSelectedFmFrequency = (frequenyCalculatorValue / 100)

    }
    function playFrequency(){
            QmlController.setRadioFreq(globalSelectedFmFrequency.toFixed(2));
    }// End functionReleased()

    //KSW 131103 [ITS][194011][minor] freq value and position go to default value and position issue.
    function refreshCursor(){
        cursor_fm_position++;
        cursor_fm_position--;
        console.log("######################## [refreshCursor] cursor_fm_position = " + cursor_fm_position);
    }

    ////////////////////////////////////////////////////////////////////////////////////
    Connections {
        target: QmlController
        onChangeSearchState: {
            console.log(" [RDS FM onChangeSearchState ] search state = "
                        + value + " requestStopSearch = " +
                        idRadioRdsFmFrequencyGradation.requestStopSearch );

            if( value == 0 && idRadioRdsFmFrequencyGradation.requestStopSearch == true ){
                idRadioRdsFmFrequencyGradation.requestStopSearch = false;
                getFrequency(cursor_fm_manual_position);
                playFrequency();
            }
        }
    }

    //->
////    MComp.MButton{
//      MComp.MButtonOnlyRadio{
//        id: idCursor
//        x : cursor_fm_position
//        y: 165-186
//        width: 170; height: 140  // width: 10; height: 183
//        bgImage: imgFolderRadio_Rds+"cursor.png"
//        bgImagePress: imgFolderRadio_Rds+"cursor.png"
//    } //# End MButton
//<-
    //**************************************** # Gradation Area #
/*
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
            drag.minimumX: 60
            drag.maximumX: 1093

            onPressed: {
                idRadioRdsFmFrequencyGradation.bMenualTouch = true;
                if (QmlController.searchState){
                    QmlController.seekstop();
                    idRadioRdsFmFrequencyGradation.requestStopSearch = true;
                    return;
                }
            } //# End onPressed
            onReleased: {
                if(idRadioRdsFmFrequencyGradation.bMenualTouch){
                    idRadioRdsFmFrequencyGradation.bMenualTouch = false;
                }

                if(!idRadioRdsFmFrequencyGradation.requestStopSearch)
                    idGradationArea.functionReleased();
            } //# End onReleased

            onMousePositionChanged: {
                if(idRadioRdsFmFrequencyGradation.bMenualTouch){

                    idGradationArea.barMouseX = mouseX;
                    if(!idRadioRdsFmFrequencyGradation.requestStopSearch)
                        idGradationArea.functionMousePositionChanged(idGradationArea.barMouseX);

                } //# End if
            } //# End onmousePositionChanged
        } //# End MouseArea
        Keys.onPressed:{ //Here 0911 RDS Radio to Display CCP Mode
            switch(event.key){
            case Qt.Key_Semicolon: //HWS 130114
            case Qt.Key_Left:{
                break;
            }
            case Qt.Key_Apostrophe: //HWS 130114
            case Qt.Key_Right:{
                break;
            }
            } //# End switch
        } //# End KeysonPressed
        ////////////////////////////////////////////////////////////////////////////////////
        //JSH 120926 MButton Function
        function functionReleased(){
                QmlController.setRadioFreq(globalSelectedFmFrequency.toFixed(2));

        }// End functionReleased()

        function functionMousePositionChanged(mouseX){
            var calculationTemp;
            //****************************** # FM Calculator #

                if( mouseX <= 150 ){
                    idAppMain.globalSelectedFmFrequency = startFmFrequency.toFixed(2);
                    return;
                }
                if( mouseX >= 1176){
                    idAppMain.globalSelectedFmFrequency = endFmFrequency.toFixed(2);
                    return;
                }

                var intPoint, endPoint

                if( mouseX < startMouseX || mouseX > endMouseX ) return
                intPoint = (((mouseX-startMouseX)/((endMouseX-startMouseX)/totalStepNum))*5)+ (startFmFrequency*100) // 5 : 0.05 * 100
                frequenyCalculatorValue = (intPoint / 10)
                frequenyCalculatorValue = frequenyCalculatorValue * 10
                endPoint = ( intPoint % 10 )
                if(endPoint >= 5 && endPoint <= 9) frequenyCalculatorValue = frequenyCalculatorValue - 5

                globalSelectedFmFrequency = (frequenyCalculatorValue / 100)

        }
        //End Function
        ////////////////////////////////////////////////////////////////////////////////////
        Connections {
            target: QmlController
            onChangeSearchState: {
                if( value == 0 && idRadioRdsFmFrequencyGradation.requestStopSearch == true ){
                    idRadioRdsFmFrequencyGradation.requestStopSearch = false;
                    idGradationArea.functionMousePositionChanged(idGradationArea.barMouseX);
                    idGradationArea.functionReleased();
                }
            }
        }
    } //# End MButton
*/
} //# End FocusScope
