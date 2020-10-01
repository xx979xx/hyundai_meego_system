/**
 * FileName: RadioHdMenuHdRadioOn.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 * - 2012-08-13 add NoSignal text
 */

import QtQuick 1.0

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioHdMenuHdRadioOn
    x: 0; y: 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioHdStringInfo{ id: stringInfo }

    property string imgFolderRadio_Hd   : imageInfo.imgFolderRadio_Hd
    ///////////////////////////////////////////////////////////////////
    // 120329 JSH
    property string padImagePath        : ""
    property int    sGeneralX           : 78+79
    property int    sGeneralY           : 173
    property int    sButtonWidthSize    : 70
    property int    sButtonHeightSize   : 60
    property int    sButtonWidthMargin  : 6
    property bool   isFocused           : ((idRadioHdMenuHdRadioOn.activeFocus && showFocus) && (jogFocusState == "HDDisplay"))
    ///////////////////////////////////////////////////////////////////    
    property int scrollTextSpacing: 120;

    onIsFocusedChanged:{
        console.log("[[idRadioHdMenuHdRadioOn this is handler for changing property]]",isFocused)
        UIListener.isDialFocus = isFocused;
    }

    //focus: true
    Item{
        //****************************** # HdRadio On #
        focus: true
        //visible: (idAppMain.hdRadioOnOff)
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)

        onVisibleChanged: {
            if((!visible) && (!QmlController.getRadioDisPlayType())){
                idMPS.visible  = false ;
                idSPS1.visible = false ;
                idSPS2.visible = false ;
                idSPS3.visible = false ;
                idSPS4.visible = false ;
                idSPS5.visible = false ;
                idSPS6.visible = false ;
                idSPS7.visible = false ;
            }
        }
        Image{
            x: (sGeneralX-79-78); y: 0//sGeneralY-systemInfo.headlineHeight
            source: imgFolderRadio_Hd+"bg_hd_station.png"
        }

        Image{
            x: (sGeneralX-79); y: 15//sGeneralY-systemInfo.headlineHeight+15
            //dg.jin 20150212 change mps nosignal HDlog is activated for a while
            source: ((idRadioHdMain.noSignal == 2) || idAppMain.hdSignalPerceive || idMBand.signalText != "" || (QmlController.radioDisPlayType == 0)) ? imgFolderRadio_Hd+"ico_hd_radio_d.png" : imgFolderRadio_Hd+"ico_hd_radio_n.png"
        }

        //****************************** # HdRadio Station Number 1~8 #
        Row{
            x: sGeneralX;y: 15//sGeneralY-systemInfo.headlineHeight+15
            spacing: sButtonWidthMargin
            MComp.MButtonOnlyRadio{
                id:idMPS
                //x: sGeneralX; y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png" //(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "1"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "1"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus && showFocus ? colorInfo.brightGrey : colorInfo.grey
                firstTextSelectedColor: activeFocus  && showFocus ? colorInfo.brightGrey : colorInfo.black
                bgImageFocus : imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"
                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)     {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)  {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down){jogFocusState = "FrequencyDial"}
                }

                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS1.enabled ? idSPS1 : idSPS2.enabled ? idSPS2 : idSPS3.enabled ?idSPS3 : idSPS4.enabled ? idSPS4 : idSPS5.enabled ? idSPS5 : idSPS6.enabled ? idSPS6 : idSPS7.enabled ? idSPS7 : idMPS
                //                KeyNavigation.left  : idRadioHdPresetList
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial
                /////////////////////////////////////////////////////////////////
                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 Modify
                        selectedStationBtn = "1"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x01); // JSH
                    }
                }
            }
            MComp.MButtonOnlyRadio{
                id:idSPS1
                //x: sGeneralX+(sButtonWidthMargin+sButtonWidthSize); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "2"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "2"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus  && showFocus? colorInfo.brightGrey : colorInfo.grey
                firstTextSelectedColor: activeFocus  && showFocus? colorInfo.brightGrey : colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS2.enabled ? idSPS2 : idSPS3.enabled ? idSPS3 : idSPS4.enabled ?idSPS4 : idSPS5.enabled ? idSPS5 : idSPS6.enabled ? idSPS6 : idSPS7.enabled ? idSPS7 : idSPS1
                //                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idMPS.enabled ? idMPS : idSPS1
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 Modify
                        selectedStationBtn = "2"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x02); // JSH
                    }
                }
            }

            MComp.MButtonOnlyRadio{
                id:idSPS2
                //x: sGeneralX+((sButtonWidthMargin+sButtonWidthSize)*2); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "3"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "3"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus  && showFocus? colorInfo.brightGrey : colorInfo.grey
                firstTextSelectedColor: activeFocus  && showFocus? colorInfo.brightGrey : colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS3.enabled ? idSPS3 : idSPS4.enabled ? idSPS4 : idSPS5.enabled ?idSPS5 : idSPS6.enabled ? idSPS6 : idSPS7.enabled ? idSPS7 : idSPS2
                //                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idSPS1.enabled ? idSPS1 : idMPS.enabled ? idMPS : idSPS2
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 Modify
                        selectedStationBtn = "3"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x04); // JSH
                    }
                }
            }

            MComp.MButtonOnlyRadio{
                id:idSPS3
                //x: sGeneralX+((sButtonWidthMargin+sButtonWidthSize)*3); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "4"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "4"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus  && showFocus? colorInfo.brightGrey :colorInfo.grey
                firstTextSelectedColor: activeFocus && showFocus ? colorInfo.brightGrey :colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS4.enabled ? idSPS4 : idSPS5.enabled ? idSPS5 : idSPS6.enabled ?idSPS6 : idSPS7.enabled ? idSPS7 : idSPS3
                //                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idSPS2.enabled ? idSPS2 : idSPS1.enabled ? idSPS1 : idMPS.enabled ? idMPS :idSPS3
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 Modify
                        selectedStationBtn = "4"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x08); // JSH , JSH 131122 Modify
                    }
                }
            }

            MComp.MButtonOnlyRadio{
                id:idSPS4
                //x: sGeneralX+((sButtonWidthMargin+sButtonWidthSize)*4); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "5"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "5"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus  && showFocus? colorInfo.brightGrey :colorInfo.grey
                firstTextSelectedColor:activeFocus && showFocus ? colorInfo.brightGrey : colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS5.enabled ? idSPS5 : idSPS6.enabled ? idSPS6 : idSPS7.enabled ?idSPS7: idSPS4
                //                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idSPS3.enabled ? idSPS3 : idSPS2.enabled ? idSPS2 : idSPS1.enabled ? idSPS1 : idMPS.enabled ? idMPS :idSPS4
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 Modify
                        selectedStationBtn = "5"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x10); // JSH
                    }
                }
            }

            MComp.MButtonOnlyRadio{
                id:idSPS5
                //x: sGeneralX+((sButtonWidthMargin+sButtonWidthSize)*5); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive:imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "6"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "6"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus && showFocus ? colorInfo.brightGrey : colorInfo.grey
                firstTextSelectedColor: activeFocus && showFocus ? colorInfo.brightGrey : colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS6.enabled ? idSPS6 : idSPS7.enabled ? idSPS7 : idSPS5
                //                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idSPS4.enabled ? idSPS4 : idSPS3.enabled ? idSPS3 : idSPS2.enabled ? idSPS2 : idSPS1.enabled ? idSPS1 : idMPS.enabled ? idMPS :idSPS5
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 => 131201Modify
                        selectedStationBtn = "6"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x20); // JSH
                    }
                }
            }

            MComp.MButtonOnlyRadio{
                id:idSPS6
                //x: sGeneralX+((sButtonWidthMargin+sButtonWidthSize)*6); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress:  imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png", JSH 131030 modify
                buttonName: "7"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "7"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus && showFocus ? colorInfo.brightGrey : colorInfo.grey
                firstTextSelectedColor: activeFocus && showFocus ? colorInfo.brightGrey : colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
                //                KeyNavigation.up    : idMBand
                //                //KeyNavigation.right : idSPS7.enabled ? idSPS7 : idSPS6
                //                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idSPS5.enabled ? idSPS5 : idSPS4.enabled ? idSPS4 : idSPS3.enabled ? idSPS3 : idSPS2.enabled ? idSPS2 : idSPS1.enabled ? idSPS1 : idMPS.enabled ? idMPS :idSPS6
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 => 131201Modify
                        selectedStationBtn = "7"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x40); // JSH
                    }
                }
            }

            MComp.MButtonOnlyRadio{
                id:idSPS7
                //x: sGeneralX+((sButtonWidthMargin+sButtonWidthSize)*7); y: sGeneralY-systemInfo.headlineHeight+15
                width: sButtonWidthSize; height: sButtonHeightSize
                bgImage: imgFolderRadio_Hd+"bg_station_n.png"
                bgImagePress: imgFolderRadio_Hd+"bg_station_p.png"
                bgImageActive: imgFolderRadio_Hd+"bg_station_s.png"//(activeFocus && showFocus) ? "" : imgFolderRadio_Hd+"bg_station_s.png" , JSH 131030 modify
                buttonName: "8"
                active: buttonName == selectedStationBtn
                visible : false

                firstText: "8"
                firstTextX: 0; firstTextY: 29
                firstTextWidth: sButtonWidthSize
                firstTextSize: 32//22
                firstTextStyle: systemInfo.hdb
                firstTextAlies: "Center"
                firstTextColor: activeFocus  && showFocus? colorInfo.brightGrey : colorInfo.grey
                firstTextSelectedColor: activeFocus  && showFocus? colorInfo.brightGrey : colorInfo.black
                bgImageFocus :imgFolderRadio_Hd + "bg_station_f.png"
                //bgImageFocusPress: imgFolderRadio_Hd + "bg_station_fp.png"

                Keys.onPressed: {
                    if (event.key == Qt.Key_Left)       {jogFocusState = "PresetList"}
                    else if (event.key == Qt.Key_Up)    {jogFocusState = "Band"      }
                    else if (event.key == Qt.Key_Down)  {jogFocusState = "FrequencyDial"}
                }
//                KeyNavigation.up    : idMBand
//                KeyNavigation.left  : idRadioHdPresetList//KeyNavigation.left  : idSPS6.enabled ? idSPS6 : idSPS5.enabled ? idSPS5 : idSPS4.enabled ? idSPS4 : idSPS3.enabled ? idSPS3 : idSPS2.enabled ? idSPS2 : idSPS1.enabled ? idSPS1 : idMPS.enabled ? idMPS :idSPS7
                KeyNavigation.down  : globalSelectedBand == stringInfo.strHDBandAm ? idRadioHdAmFrequencyDial : idRadioHdFmFrequencyDial

                onClickOrKeySelected: {
                    idRadioHdMain.jogFocusState =  "HDDisplay"

                    if(mode == 2){
                        var searchValue = QmlController.getsearchState(); // JSH 131122
                        if(searchValue)
                            QmlController.setsearchState(searchValue);
                        idAppMain.presetSaveEnabled = true;
                    }
                    else if(mode == 0){
                        if(active==true)return;          // JSH , JSH 131122 Modify
                        selectedStationBtn = "8"
                        idAppMain.popupClose(false); // JSH 130331 , scan , preset scan  Stop
                        QmlController.hdTuneChange(0x80); // JSH
                    }
                }
            }
        }
    }

    Item {
        //****************************** # Frequency Value #
        //visible: idAppMain.hdRadioOnOff
        //enabled: !(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
        Text{
            id: idSelectedFrequency
            text: frequencyStationText()
            x: 886-493                  //x: 596-493                            JSH 130510 Modify
            y: 335-173 - (88/2)         //y: 312+15-173 - (70/2)                JSH 130426 Modify
            width:340 ; height: 88      //width:201+4+51 ; height: 70           JSH 130510 Modify

            font.pixelSize: 88          //                                      JSH 130426 [84 -> 70 -> 88]Modify
            font.family: systemInfo.hdb
            horizontalAlignment: Text.AlignLeft // Text.AlignRight              JSH 130510 Modify
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }
        //****************************** # Station Name Value #
        Text{
            text: idRadioHdMain.hdSIS   // (HD Radio SIS ) //"KBS1 FM"  //
            x:  890-493                 // 596+201+4+51+26-493           , JSH 130510  Modify
            y: 416 -173 - (46/2)      // y: 312+18-173 - (84/2)        , JSH 130510  Modify
            width: 340 ; height: 46     //width: (selectedStationBtn == 1) ? 310 : 242 ; height: 40 , JSH 130510  Modify
            font.pixelSize: 46          // 40 -> 46                      , JSH 130510  Modify
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            visible: (!idRadioHdMain.noSignal)
        } // # End Text
        Text{
            text: idRadioHdMain.hdPtyText   // PTY(HD )//"Classic Rock" //
            x:  890-493                     // 596+201+4+51+26-493      , 130510  Modify
            y: 416-173+45-(32/2)            // y: 312-173+15+25-(28/2)  , 130510  Modify
            width: 340 ; height: 32         // width: (selectedStationBtn == 1) ? 310 : 242 ; height: 28 , 130510  Modify
            font.pixelSize: 32              // 28 -> 32                      , JSH 130510  Modify
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.dimmedGrey
            visible: (!idRadioHdMain.noSignal)
        } // # End Text

        //****************************** # Album Infomation #
        Image{
            x: 654-493; y: 284-173  // x: 654-493; y: 399-173  , JSH 130510 Modify
            width: 198 ;height: 198                     //width: 202 ;height: 202
            source: imageInfo.imgFolderRadio_Hd + "bg_pty.png"
            Image{ // PSD Cover IMAGE //statusBarHeight
                width: 198 ;height: 198
                smooth: true
                //source: idRadioHdMain.noSignal ? imageInfo.imgFolderRadio_Hd + "/pty/ico_pty_00.png" : ( padImagePath == "" &&  idRadioHdMain.ptyImage == "") ? imageInfo.imgFolderRadio_Hd + "/pty/ico_pty_00.png" : padImagePath != "" ? padImagePath : imageInfo.imgFolderRadio_Hd + "/pty/"+ idRadioHdMain.ptyImage
                source : {
                    ////////////////////////////////////////////////////////////////////////////////////////
                    // JSH 130528 Modify
                    if((idRadioHdMain.noSignal == 2) || ( padImagePath == ""))
                         imageInfo.imgFolderRadio_Hd + "/pty/ico_pty_00.png"
                    else if(padImagePath != "")
                        padImagePath

                    //if(idRadioHdMain.noSignal || ( padImagePath == "" &&  idRadioHdMain.ptyImage == ""))
                    //     imageInfo.imgFolderRadio_Hd + "/pty/ico_pty_00.png"
                    //else if(padImagePath != "")
                    //    padImagePath
                    //else if(idRadioHdMain.ptyImage !="" && (!QmlController.getPsdImageTimer()))
                    //    imageInfo.imgFolderRadio_Hd + "/pty/"+ idRadioHdMain.ptyImage
                    ////////////////////////////////////////////////////////////////////////////////////////
                }
                //////////////////////////////////////
                // 121218 Cover Animation => JSH 130402 delete [AM , HD Info Delete]
                //MouseArea{
                //    id:idPsdImageMouseArea
                //    anchors.fill: parent
                //    onClicked: {
                //        idRadioHdMenuInfoOn.x       = 632//691-60
                //        idAppMain.menuInfoFlag      = !idAppMain.menuInfoFlag
                //        idRadioHdMenuInfoOn.xAni    = true;
                //    }
                //}
                //////////////////////////////////////
            }
        }
        Item{
            id:idPsdArea
            x: 0; y: 0
            visible: (!idRadioHdMain.noSignal) //(!menuInfoFlag) && (!idRadioHdMain.noSignal) => JSH 130402 delete [AM , HD Info Delete]
            Image{
                id:idArtistImage
                x: 654-493; y: 284+207-173          //x: 654+216-493; y: 399+27-173 , 130510  Modify
                source: imgFolderRadio_Hd+"ico_artist_n.png"
            }
            Image{
                id:idTitleImage
                x: 654-493; y: 284+207+23+27-173    //x: 654+216-493; y: 399+27+23+27-173 , 130510  Modify
                source: imgFolderRadio_Hd+"ico_song_n.png"
            }
            function scrollSequenceChange(num){ // JSH 140114
                if(num == 0){
                    if(idFirstTextItem.overTextPaintedWidth){
                        idFirstTextItem.scrollSequenceOn  = true;
                        idSecondTextItem.scrollSequenceOn = false;
                    }
                    else if(idSecondTextItem.overTextPaintedWidth){
                        idFirstTextItem.scrollSequenceOn  = false;
                        idSecondTextItem.scrollSequenceOn = true;
                    }
                }else if(num == (-1)){;
                    idFirstTextItem.scrollSequenceOn  = false;
                    idSecondTextItem.scrollSequenceOn = false;
                }
            }
            /////////////////////////////////////////////////////////////
            //****************************** # For Scroll Text
            MComp.MTickerText{
                id: idFirstTextItem
                x: 654+47-493       ; y: idArtistImage.y
                width: 531          ; height: idArtistImage.height
                tickerTextSpacing   : scrollTextSpacing
                tickerText          : idAppMain.psdArtist
                tickerTextSize      : 28
                tickerTextColor     : colorInfo.dimmedGrey
                tickerTextStyle     : systemInfo.hdr
                tickerTextAlies     : "Left"
                variantText         : true
                variantTextTickerEnable : (!idAppMain.drsShow) && (idMBand.signalText == "") && (idPsdArea.visible)  && (scrollSequenceOn)
                //tickerEnable        : (!idAppMain.drsShow) && idMBand.signalText == "" && (overTextPaintedWidth)
                ////////////////////////////////////////////////////////////////
                // JSH 140113
                scrollSequenceOn    : false
                onCheckScrollChanged: {
                    if((checkScroll == 0) && (scrollSequenceOn) && idSecondTextItem.overTextPaintedWidth){ // Next move
                        idFirstTextItem.scrollSequenceOn  = false;
                        idSecondTextItem.scrollSequenceOn = true;
                    }
                }
                ////////////////////////////////////////////////////////////////
            }
            ///////////////////////////////////////////////////////////////////////
            MComp.MTickerText{
                //****************************** # Second Text
                id: idSecondTextItem
                x: 654+47-493       ; y: idTitleImage.y
                width: 531          ; height: idTitleImage.height
                tickerTextSpacing   : scrollTextSpacing
                tickerText          : idAppMain.psdTitle
                tickerTextSize      : 28
                tickerTextColor     : colorInfo.dimmedGrey
                tickerTextStyle     : systemInfo.hdr
                tickerTextAlies     : "Left"
                variantText         : true
                variantTextTickerEnable : (!idAppMain.drsShow) &&  (idMBand.signalText == "") && (idPsdArea.visible) && (scrollSequenceOn) // JSH 131124 modifyg
                //tickerEnable        : (!idAppMain.drsShow) && idMBand.signalText == "" && (overTextPaintedWidth)
                ////////////////////////////////////////////////////////////////
                // JSH 140113
                scrollSequenceOn    : false
                onCheckScrollChanged: {
                    if((checkScroll == 0) && (scrollSequenceOn) && idFirstTextItem.overTextPaintedWidth){ // Next move
                        idFirstTextItem.scrollSequenceOn  = true;
                        idSecondTextItem.scrollSequenceOn = false;
                    }
                }
                ////////////////////////////////////////////////////////////////
            }
        }
        Text{
            text: stringInfo.strHDMstNoSignal//"NO Signal"
            x: 666-493 ; y: 538-173-(50/2) //x: 666-493 ; y: 466-173-(50/2)
            width: 531 ; height: 50
            font.pixelSize: 50
            font.family: systemInfo.hdr//"HDR"
            horizontalAlignment: Text.AlignHCenter
            //verticalAlignment: Text.AlignVCenter
            color: colorInfo.dimmedGrey
            visible: idRadioHdMain.noSignal == 2 // (!menuInfoFlag) ? idRadioHdMain.noSignal : false => JSH 130402 delete [AM , HD Info Delete]
        } // # End Text
    }
    //////////////////////////////////////////////////////////////////////////////////
    //JSH Connections SPS Display
    Connections{
        target:QmlController
        onChagneHdRadioPsdImage:{
            console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",imagePath)
            if(imagePath == 0){
                 padImagePath  = "";
            }
            else{
                //                var img = new String(imagePath);
                //                if((img.indexOf("_HD")>0) && (padImagePath.indexOf("_psd_")>0)){ //if((img.indexOf("_HD")>0) && (padImagePath.indexOf("_sps")>0)){
                //                    delete img;
                //                    var pos = padImagePath.indexOf("_sps");
                //                    var spsNum = parseInt(padImagePath.substring(pos+4,pos+4+1));
                //                    if(QmlController.toFlag(QmlController.getHDRadioCurrentSPS()) == spsNum)
                //                        return;
                //                }
                //                else
                //                    delete img;

                var img = new String(imagePath);
                if(img.indexOf("pty") >= 0)
                    padImagePath = imageInfo.imgFolderRadio_Hd + imagePath;
                else
                    padImagePath = imagePath;

                 delete img;
                console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>imagePath [true]",imageInfo.imgFolderRadio_Hd, padImagePath)
            }
        }
        onHdRadioPsdUptate:{
            // 0 : clear , 1 : title , 2 : artist , 3 : album , 4:commnet , 5 : Lot ID
            if(type == 0){
                idAppMain.psdTitle     = ""
                idAppMain.psdArtist    = ""
                idAppMain.psdAlbum     = ""
                idAppMain.hdRtText = ""
                idRadioHdMain.ptyImage = ""     // JSH 130327
                QmlController.setQmlPsdImage(); // padImagePath = ""; JSH 130327 Modify
                idPsdArea.scrollSequenceChange(-1) // JSH 140114
            }
            if(type == 0x01)              // Title Name
                idAppMain.psdTitle = msg
            else if(type == 0x02){         // Artist Name
                idAppMain.psdArtist = msg
                idPsdArea.scrollSequenceChange(0) // JSH 140114 ,  scroll Sequence initialzation
            }
            else if(type == 0x03)       // Album Name
                idAppMain.psdAlbum = msg
            else if(type == 0x04)         // Comment Text
                idAppMain.hdRtText = msg
            //else if(type ==0x05)        // Lot ID
        }
        onHdRadioSisUptate:{
            if(type == 0x01)                                                        // short station Name 1
                idRadioHdMain.hdSIS = msg
            else if((type >= 0x02 && type <= 0x04)&& idRadioHdMain.hdSIS == "")      // Long  station Name 2 ,ALFN 3, Universal 4
                idRadioHdMain.hdSIS = msg
            else                                                                    // type == 0x05(clear)
                idRadioHdMain.hdSIS = msg
        }
        onHdSpsUpdate:{
            if(onoff){
                ////////////////////////////////////////////////////////////////////////////
                // JSH 131031 Modify
                // SPS , PSD DISPLAY RESET
                //idMPS.visible  = false ; idMPS.opacity =0.4 ;
                //idSPS1.visible = false ; idSPS1.opacity=0.4 ;
                //idSPS2.visible = false ; idSPS2.opacity=0.4 ;
                //idSPS3.visible = false ; idSPS3.opacity=0.4 ;
                //idSPS4.visible = false ; idSPS4.opacity=0.4 ;
                //idSPS5.visible = false ; idSPS5.opacity=0.4 ;
                //idSPS6.visible = false ; idSPS6.opacity=0.4 ;
                //idSPS7.visible = false ; idSPS7.opacity=0.4 ;

                if((sps & 0x01) == 0x01){idMPS.visible  = true ; idMPS.opacity =1;  }
                else                    {idMPS.visible  = false; idMPS.opacity =0.4;}// JSH 131031 added
                if((sps & 0x02) == 0x02){idSPS1.visible = true ; idSPS1.opacity=1;  }
                else                    {idSPS1.visible = false; idSPS1.opacity=0.4;}// JSH 131031 added
                if((sps & 0x04) == 0x04){idSPS2.visible = true ; idSPS2.opacity=1;  }
                else                    {idSPS2.visible = false; idSPS2.opacity=0.4;}// JSH 131031 added
                if((sps & 0x08) == 0x08){idSPS3.visible = true ; idSPS3.opacity=1;  }
                else                    {idSPS3.visible = false; idSPS3.opacity=0.4;}// JSH 131031 added
                if((sps & 0x10) == 0x10){idSPS4.visible = true ; idSPS4.opacity=1;  }
                else                    {idSPS4.visible = false; idSPS4.opacity=0.4;}// JSH 131031 added
                if((sps & 0x20) == 0x20){idSPS5.visible = true ; idSPS5.opacity=1;  }
                else                    {idSPS5.visible = false; idSPS5.opacity=0.4;}// JSH 131031 added
                if((sps & 0x40) == 0x40){idSPS6.visible = true ; idSPS6.opacity=1;  }
                else                    {idSPS6.visible = false; idSPS6.opacity=0.4;}// JSH 131031 added
                if((sps & 0x80) == 0x80){idSPS7.visible = true ; idSPS7.opacity=1;  }
                else                    {idSPS7.visible = false; idSPS7.opacity=0.4;}// JSH 131031 added
                ////////////////////////////////////////////////////////////////////////////
                //idFmMode2View.hdSelect = 1 // HD Radio Change (MPS select)
            }

            switch(select){ // SPS Select button ON
            case 0x01 :{selectedStationBtn = "1";idMPS.focus = true;break;}
            case 0x02 :{selectedStationBtn = "2";idSPS1.focus = true;break;}
            case 0x04 :{selectedStationBtn = "3";idSPS2.focus = true;break;}
            case 0x08 :{selectedStationBtn = "4";idSPS3.focus = true;break;}
            case 0x10 :{selectedStationBtn = "5";idSPS4.focus = true;break;}
            case 0x20 :{selectedStationBtn = "6";idSPS5.focus = true;break;}
            case 0x40 :{selectedStationBtn = "7";idSPS6.focus = true;break;}
            case 0x80 :{selectedStationBtn = "8";idSPS7.focus = true;break;}
            default:break;
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //****************************** # Frequency value by station value #
    function frequencyStationText(){
        //JSH font size -24 -> -10 -> -33 Modify
        if(selectedStationBtn != 1){
            if(globalSelectedBand==stringInfo.strHDBandAm){
                return globalSelectedAmFrequency+"<font size=-33>"+"-"+selectedStationBtn+"</font>"
            }
            else{
                if((globalSelectedFmFrequency%1)==0)
                    return globalSelectedFmFrequency+".0"+ "<font size=-33>"+"-"+selectedStationBtn+"</font>"
                else
                    return globalSelectedFmFrequency.toFixed(1)+ "<font size=-33>"+"-"+selectedStationBtn+"</font>"
            }
        }
        else
            return (globalSelectedBand==stringInfo.strHDBandAm)? globalSelectedAmFrequency : (globalSelectedFmFrequency%1)==0? globalSelectedFmFrequency+".0" : globalSelectedFmFrequency.toFixed(1)
    }
}
