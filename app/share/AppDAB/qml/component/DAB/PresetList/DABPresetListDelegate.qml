/**
 * FileName: DABPresetListDelegate.qml
 * Author: HYANG
 * Time: 2013-05
 *
 * - 2013-05 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MButton {
    id: idDabPresetListDelegate
    x: 0; y: 0
    width: 554; height: 86
    buttonName: index
    active: (buttonName == currentPlayIndex)

    //****************************** # Preperty #
    property string imgFolderRadio_Dab : imageInfo.imgFolderRadio_Dab
    property string imgFolderGeneral : imageInfo.imgFolderGeneral  

    //****************************** # Button Image #
    bgImage: imgFolderRadio_Dab+"btn_preset_n.png"
    bgImagePress: imgFolderRadio_Dab+"btn_preset_p.png"  
    bgImageFocus: imgFolderRadio_Dab+"btn_preset_f.png"
    bgImageActive: imgFolderRadio_Dab+"btn_preset_n.png"

    //****************************** # Index (FirstText) #
    firstText: index+1
    firstTextX: 12
    firstTextY: 9+31+4  //9+31
    firstTextWidth: 66
    firstTextSize: 36
    firstTextStyle: idAppMain.fonts_HDB
    firstTextAlies: "Center"
    firstTextColor: (presetName==stringInfo.strPreset_Empty)? colorInfo.dimmedGrey : colorInfo.brightGrey
    firstTextFocusPressColor: (presetName==stringInfo.strPreset_Empty)? colorInfo.dimmedGrey : colorInfo.brightGrey
    firstTextPressColor: (presetName==stringInfo.strPreset_Empty)? colorInfo.dimmedGrey : colorInfo.brightGrey
    firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey :  "#7CBDFF"

    //****************************** # Line Image #
    fgImage: imgFolderRadio_Dab+"preset_divder.png"
    fgImageX: 12+66+10
    fgImageY: 9
    fgImageWidth: 3
    fgImageHeight: 67

    //****************************** # Play Icon Image #
    property int count: 1
    property int countMax: 30

    Image{
        id: playIcon
        x: 12+66+10+19; y: 9+6
        width: 46 ; height: 46;
        source: count > 9 ? imgFolderGeneral+"/play/ico_play_"+ count +".png" : imgFolderGeneral+"/play/ico_play_0"+ count +".png"
        visible: buttonName == currentPlayIndex

        Timer{
            id: idPlayIconTimer
            interval: 100;
            repeat: true
            running: (buttonName == currentPlayIndex) && (!m_bIsServiceNotAvailable)
            onTriggered: {
                if(count == countMax) count = 1
                count++;
            }
        }
    }

    Connections{
        target: idAppMain
        onM_bIsServiceNotAvailableChanged:{
            if(m_bIsServiceNotAvailable)
            {
                idPlayIconTimer.stop()
                count = 1;
            }
            else idPlayIconTimer.restart();
        }
    }

    onActiveChanged: {
        console.log("[QML] DABPresetListDelegate.qml : onActiveChanged : buttonName = " + buttonName + "  currentPlayIndex = " + currentPlayIndex);
        if(buttonName == currentPlayIndex) idPlayIconTimer.restart()
        else idPlayIconTimer.stop()
    }

    //****************************** # Channel (SecondText) #
    secondText: presetName
    secondTextX: (buttonName == currentPlayIndex)? 12+66+10+19+50 : 12+66+10+27
    secondTextY: 9+31+4//9+31
    secondTextWidth: (buttonName == currentPlayIndex)? 384 : 426
    secondTextSize: 36
    secondTextStyle: (buttonName == currentPlayIndex)? idAppMain.fonts_HDB : idAppMain.fonts_HDR
    secondTextAlies: "Left"
    secondTextColor: (presetName==stringInfo.strPreset_Empty)? colorInfo.dimmedGrey : colorInfo.brightGrey
    secondTextFocusPressColor: (presetName==stringInfo.strPreset_Empty)? colorInfo.dimmedGrey : colorInfo.brightGrey
    secondTextPressColor: (presetName==stringInfo.strPreset_Empty)? colorInfo.dimmedGrey : colorInfo.brightGrey
    secondTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"  //# RGB(124, 189, 255)
    secondTextScrollEnable: (m_bIsDrivingRegulation == false) && (idDabPresetListDelegate.activeFocus) ? true : false

     //****************************** # Item Click or Key Selected #
    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            idDabPresetListDelegate.GridView.view.currentIndex = index
            idDabPresetListDelegate.GridView.view.focus = true
            idDabPresetListDelegate.GridView.view.forceActiveFocus()

            console.log("[QML] DABPresetListMain.qml : onPresetItemClicked : index = " + currentIndex + "  m_bIsSaveAsPreset = " + m_bIsSaveAsPreset + "  m_sServiceName = " + m_sServiceName);
            if(m_bIsSaveAsPreset)
            {
                if(m_sServiceName == "...") return;

                secondText = m_sServiceName;
                idPresetListModel.setProperty(currentIndex, "presetName", m_sServiceName)
                MDabOperation.updatePresetList(currentIndex, idPresetListModel.get(currentIndex).realIndex);
                setAppMainScreen("DabPresetSavedPopup", true);
            }
            else
            {
                if(idPresetListModel.get(currentIndex).realIndex == -1) return;
                MDabOperation.CmdReqPresetSelected(idPresetListModel.get(currentIndex).realIndex);
                gotoBackScreen();
            }
        }
        else{
            idPresetTimer.restart();
        }
    }

    onPressAndHold: {
        idDabPresetListDelegate.GridView.view.currentIndex = index
        idDabPresetListDelegate.GridView.view.focus = true
        idDabPresetListDelegate.GridView.view.forceActiveFocus()
        idPresetTimer.stop();
        if(m_bIsSaveAsPreset)
        {
            console.log("[QML] DABPreetListMain.qml : onPresetItemPressAndHold : Save As Preset Case !!")
            pressAndHoldFlag = false;
        }
        else
        {
            if(m_sServiceName == "...") return;

            console.log("[QML] list index = " + idPresetListModel.get(currentIndex).realIndex)
            secondText = m_sServiceName;            
            idPresetListModel.setProperty(currentIndex, "presetName", m_sServiceName)
            MDabOperation.updatePresetList(currentIndex, idPresetListModel.get(currentIndex).realIndex);
            idAppMain.pressCancelJogSignal();
        }
    }

    onTuneLeftKeyPressed : {  
        idPresetTimer.restart();
        if( idDabPresetListDelegate.GridView.view.currentIndex == 0){
            idDabPresetListDelegate.GridView.view.currentIndex = 0;
        }
        else if( idDabPresetListDelegate.GridView.view.currentIndex ){
            idDabPresetListDelegate.GridView.view.moveCurrentIndexUp();
        }
    }

    onTuneRightKeyPressed : {
        idPresetTimer.restart();
        if(idDabPresetListDelegate.GridView.view.currentIndex == 11){
            idDabPresetListDelegate.GridView.view.currentIndex = 11;
        }
        else if( idDabPresetListDelegate.GridView.view.count-1 != idDabPresetListDelegate.GridView.view.currentIndex ){
            idDabPresetListDelegate.GridView.view.moveCurrentIndexDown();
        }
    }

    onTuneEnterKeyPressed : {
        console.log("[QML] MPresetDelegate.qml : onTuneEnterKeyPressed : idPresetListModel.get(currentIndex).realIndex = " + idPresetListModel.get(currentIndex).realIndex)

        idDabPresetListDelegate.GridView.view.currentIndex = index
        idDabPresetListDelegate.GridView.view.focus = true
        idDabPresetListDelegate.GridView.view.forceActiveFocus()

        if(m_bIsSaveAsPreset)
        {
            if(m_sServiceName == "...") return;

            secondText = m_sServiceName;
            MDabOperation.updatePresetList(currentIndex, idPresetListModel.get(currentIndex).realIndex);
            setAppMainScreen("DabPresetSavedPopup", true);
        }
        else
        {
            if(idPresetListModel.get(currentIndex).realIndex == -1) return;
            MDabOperation.CmdReqPresetSelected(idPresetListModel.get(currentIndex).realIndex);
            gotoBackScreen();
        }
    }

    onWheelLeftKeyPressed: {
        if( idDabPresetListDelegate.GridView.view.currentIndex == 0){
            idDabPresetListDelegate.GridView.view.currentIndex = 0;
        }
        else if( idDabPresetListDelegate.GridView.view.currentIndex ){
            idDabPresetListDelegate.GridView.view.moveCurrentIndexUp();
        }
    }
    onWheelRightKeyPressed: {
        if(idDabPresetListDelegate.GridView.view.currentIndex == 11){
            idDabPresetListDelegate.GridView.view.currentIndex = 11;
        }
        else if( idDabPresetListDelegate.GridView.view.count-1 != idDabPresetListDelegate.GridView.view.currentIndex ){
            idDabPresetListDelegate.GridView.view.moveCurrentIndexDown();
        }
    }

    Keys.onUpPressed: { // Set focus for Band      
        event.accepted = true;
        return;
    } // End onUpPressed
    Keys.onDownPressed:{ // No Movement
        event.accepted = true;
        return;
    } // End onDownPressed

    onUpKeyReleased: {
        if(idAppMain.upKeyReleased == true){
            idDabPresetListBand.focus = true
            event.accepted = true;
            return;
        }
    }  
}

