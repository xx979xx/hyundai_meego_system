/**
 * FileName: DABPresetList.qml
 * Author: DaeHyungE
 * Time: 2012-07-19
 *
 * - 2012-07-19 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id : idDabPresetList

    property int currentPlayIndex       : -1

    width : systemInfo.lcdWidth
    height : systemInfo.subMainHeight
    focus : true
    objectName: "DABPresetList"

    property int presetListMaXPosition : 0
    property int presetListMainYPosition : idDabPresetListBand.height
    property int presetListMainWidth : idDabPresetList.width
    property int presetListMainHeight : idDabPresetList.height - 73

    property bool seekPrevLongKeyPressed : idAppMain.seekPrevLongKeyPressed;
    property bool seekNextLongKeyPressed : idAppMain.seekNextLongKeyPressed;

    function initialize()
    {
        console.log("[QML] DABPresetList.qml : initialize")
        DABChannelManager.getPresetListItem();
        if(m_bIsSaveAsPreset == true) idDabPresetList.objectName = "DABSaveAsPresetList"
        else idDabPresetList.objectName = "DABPresetList"
    }

    //==========================Background Image
    Image {
        id : idPresetListBg
        y : 0//-systemInfo.statusBarHeight
        source : imageInfo.imgBg_Main
    }

    DABPresetListBand {
        id : idDabPresetListBand
        x : 0
        y : 0
        KeyNavigation.down : idDabPresetListView
        onTuneLeftKeyPressed: idDabPresetListView.focus = true
        onTuneRightKeyPressed: idDabPresetListView.focus = true
    }

    DABPresetListView {
        id : idDabPresetListView
        x : presetListMaXPosition
        y : presetListMainYPosition
        width : presetListMainWidth
        height : presetListMainHeight
        focus : true
        KeyNavigation.up : idDabPresetListBand
    }

    onSeekPrevKeyReleased: {
        if(m_bIsSaveAsPreset == true){ gotoMainScreen(); }
        else{
            if(idAppMain.bSeekPrevKeyReleased == true){
                idDabPresetListView.focus = true;
                idDabPresetListView.seekPrevKeyReleasedFunc();
            }
            idAppMain.bSeekPrevKeyReleased = false;
        }
    }
    onSeekNextKeyReleased: {
        if(m_bIsSaveAsPreset == true){ gotoMainScreen(); }
        else{
            if(idAppMain.bSeekNextKeyReleased == true){
                idDabPresetListView.focus = true;
                idDabPresetListView.seekNextKeyReleasedFunc();
            }
            idAppMain.bSeekNextKeyReleased  = false;
        }
    }
    onSeekPrevLongKeyPressedChanged: {
        if(m_bIsSaveAsPreset == true){ gotoMainScreen(); }
        else{
            idDabPresetListView.focus = true;
            idDabPresetListView.seekPrevLongKeyReleasedFunc(seekPrevLongKeyPressed);
        }
    }
    onSeekNextLongKeyPressedChanged: {
        if(m_bIsSaveAsPreset == true){ gotoMainScreen(); }
        else{
            idDabPresetListView.focus = true;
            idDabPresetListView.seekNextLongKeyReleasedFunc(seekNextLongKeyPressed);
        }
    }

    //******************************# For Timer 30s (20130321)
    Timer {
        id: idPresetTimer
        interval: 15000
        running: idAppMain.state == "DabPresetList"
        repeat: false
        onTriggered:
        {
            if(m_bIsSaveAsPreset == false){
                console.log("[QML] DABPresetList.qml : idPresetTimer")
                gotoMainScreen()
            }
        }
    }
    onVisibleChanged: {
        if(visible)
        {
            if(currentPlayIndex == -1 && m_bIsSaveAsPreset == false)
            {
                idDabPresetListView.focus = false;
                idDabPresetListBand.focus = true;
            }
            else
            {
                idDabPresetListView.focus = true;
                idDabPresetListBand.focus = false;
            }
            idPresetTimer.start();
        }
        else
        {
            idPresetTimer.stop();
        }
    }
    onAnyKeyPressed: {
        idPresetTimer.restart();
    }

    onBackKeyPressed: {
        console.log("[QML] DABPresetList.qml : onBackKeyPressed")
        gotoBackScreen();
    }
}
