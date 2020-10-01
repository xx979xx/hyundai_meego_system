/**
 * FileName: DABPresetListView.qml
 * Author: DaeHyungE
 * Time: 2012-07-19
 *
 * - 2012-07-19 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id : idDabPresetListView

    property int currentIndex: idPresetGridView.currentIndex
    property int virtualCurrentIndex

    Component.onCompleted: {
        console.log("[QML] DABPresetListView.qml :  Component.onCompleted")
        stringNameSetting();
    }
    
    //****************************** # GridView #
    FocusScope {
        id: idPresetView
        x: 58; y: 184 - systemInfo.headlineHeight
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight-systemInfo.statusBarHeight
        focus: true
        MComp.MGridView {
            id: idPresetGridView
            anchors.fill: parent
            cellWidth: 610; cellHeight: 86
            focus: true
            model: idPresetListModel
            flow: GridView.TopToBottom
            boundsBehavior: Flickable.StopAtBounds
            delegate: DABPresetListDelegate{ id: idDabPresetListDelegate }
        }
    }

    //****************************** # Grid ListModel #
    ListModel {
        id: idPresetListModel
    }

    //****************************** # Seek Up
    function seekPrevKeyReleasedFunc() {
        if(idAppMain.state != "DabPresetList") return;
        idPresetTimer.restart();
        var virtualCurrentIndex = currentPlayIndex;

        while(virtualCurrentIndex >= -1){       //while(virtualCurrentIndex != currentPlayIndex)
            if(virtualCurrentIndex == 0){ virtualCurrentIndex = 11; }
            else if(virtualCurrentIndex == -1){ virtualCurrentIndex = 0; }
            else { virtualCurrentIndex--; }

            if(  idPresetGridView.model.get(virtualCurrentIndex).realIndex != -1 ){
                idPresetGridView.currentIndex = virtualCurrentIndex;
                currentPlayIndex = virtualCurrentIndex
                break;
            }
        }
        MDabOperation.CmdReqPresetSelected(idPresetGridView.model.get(currentPlayIndex).realIndex);
    }
    //****************************** # Seek Down
    function seekNextKeyReleasedFunc() {
        if(idAppMain.state != "DabPresetList") return;
        idPresetTimer.restart();
        var virtualCurrentIndex = currentPlayIndex;

        while(virtualCurrentIndex <= 11){     //while(virtualCurrentIndex != currentPlayIndex)
            if(virtualCurrentIndex == 11){ virtualCurrentIndex = 0; }
            else if(virtualCurrentIndex == -1){ virtualCurrentIndex = 0; }
            else { virtualCurrentIndex++; }

            if(  idPresetGridView.model.get(virtualCurrentIndex).realIndex != -1 ){
                idPresetGridView.currentIndex = virtualCurrentIndex;
                currentPlayIndex = virtualCurrentIndex
                break;
            }
        }
        MDabOperation.CmdReqPresetSelected(idPresetGridView.model.get(currentPlayIndex).realIndex);
    }
    //****************************** # Seek Long Up
    function seekPrevLongKeyReleasedFunc(seekPrevLongKeyPressed) {        
        //console.log("[QML] MPresetDelegate.qml : onSeekPrevLongKeyPressedChanged : activeFocus = " + activeFocus + ", idAppMain.state = " + idAppMain.state)
        if(idAppMain.state != "DabPresetList") return;
        if(seekPrevLongKeyPressed){        
            idPresetTimer.stop();
            idDabPresetListView.virtualCurrentIndex = currentPlayIndex
            idSeekUpLongKeyTimer.running = true
        }
        else{
            idPresetTimer.restart();
            idSeekUpLongKeyTimer.running = false
            currentPlayIndex = idPresetGridView.currentIndex
            MDabOperation.CmdReqPresetSelected(idPresetGridView.model.get(currentPlayIndex).realIndex);       
        }
    }
    //****************************** # Seek Long Down
    function seekNextLongKeyReleasedFunc(seekNextLongKeyPressed) {        
        //console.log("[QML] MPresetDelegate.qml : onSeekNextLongKeyPressedChanged : activeFocus = " + activeFocus)
        if(idAppMain.state != "DabPresetList") return;
        if(seekNextLongKeyPressed){        
            idPresetTimer.stop();            
            idDabPresetListView.virtualCurrentIndex = currentPlayIndex
            idSeekDownLongKeyTimer.running = true
        }
        else
        {
            idPresetTimer.restart();
            idSeekDownLongKeyTimer.running = false
            currentPlayIndex = idPresetGridView.currentIndex
            while(idPresetGridView.model.get(currentPlayIndex).realIndex == -1)
            {
                currentPlayIndex--;
            }
            if(currentPlayIndex == -1) currentPlayIndex = 0;
            idPresetGridView.currentIndex = currentPlayIndex
            MDabOperation.CmdReqPresetSelected(idPresetGridView.model.get(currentPlayIndex).realIndex);
        }
    }

    //******************************# Connections
    Connections {
        target: UIListener
        onRetranslateUi:
        {
            console.log("[QML] DABPresetListView.qml : onRetranslateUi");
            stringNameSetting();
        }
    }

    // mseok.lee
    Connections {
        target : AppComUIListener
        onRetranslateUi: {
            console.log("[QML] DABPresetListView.qml : AppComUIListener::onRetranslateUi");
            stringNameSetting();
        }
    }

    //******************************# String Translation
    function stringNameSetting()
    {
        var data1 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data2 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data3 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data4 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data5 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data6 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data7 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data8 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data9 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data10 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data11 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };
        var data12 = {"presetName" : stringInfo.strPreset_Empty, "realIndex": -1 };

        idPresetListModel.clear();
        idPresetListModel.append(data1);
        idPresetListModel.append(data2);
        idPresetListModel.append(data3);
        idPresetListModel.append(data4);
        idPresetListModel.append(data5);
        idPresetListModel.append(data6);
        idPresetListModel.append(data7);
        idPresetListModel.append(data8);
        idPresetListModel.append(data9);
        idPresetListModel.append(data10);
        idPresetListModel.append(data11);
        idPresetListModel.append(data12);
    }

    onVisibleChanged: {
        console.log("[QML] MPresetDelegate.qml : onVisibleChanged : visible = " + visible)
        if(visible){
            if(currentPlayIndex == -1){// || m_bIsSaveAsPreset){ // only save as preset index 0
                idPresetGridView.currentIndex = 0;
            }
            else
            {
                idPresetGridView.currentIndex = currentPlayIndex;
            }
        }
        else{
            idSeekUpLongKeyTimer.stop();
            idSeekDownLongKeyTimer.stop();
        }
    }

    //****************************** # For seek Long Up / Down
    Timer {
        id: idSeekUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: { focusMovementUp(); }
        triggeredOnStart: true
    }

    Timer {
        id: idSeekDownLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: { focusMovementDown(); }
        triggeredOnStart: true
    }

    function focusMovementUp(){      
        while(idSeekUpLongKeyTimer.running==true){
            if(idDabPresetListView.virtualCurrentIndex == -1){ idDabPresetListView.virtualCurrentIndex = 0; }
            else idDabPresetListView.virtualCurrentIndex--;

            if(  idPresetGridView.model.get(idDabPresetListView.virtualCurrentIndex).realIndex != -1 ){
                idPresetGridView.currentIndex = idDabPresetListView.virtualCurrentIndex
                break;
            }
        }
    }

    function focusMovementDown(){        
        while(idSeekDownLongKeyTimer.running==true){
            if(idDabPresetListView.virtualCurrentIndex == -1){ idDabPresetListView.virtualCurrentIndex = 0; }
            else idDabPresetListView.virtualCurrentIndex++;

            if(  idPresetGridView.model.get(idDabPresetListView.virtualCurrentIndex).realIndex != -1 ){
                idPresetGridView.currentIndex = idDabPresetListView.virtualCurrentIndex
                break;
            }
        }
    }

    Connections {
        target : DABChannelManager
        onServiceNameForPresetList:{
            console.log("[QML] ==> Connections: DABPresetListView.qml: onServiceNameForPresetList: serviceName = " + serviceName + " ensembleName = " + ensembleName + " index = " + index + " realIndex = " + realIndex);
            idPresetListModel.set(index, {"presetName": serviceName, "realIndex":realIndex})
        }

        onPlayIconUpdateInPresetList : {
            console.log("[QML] ==> DABChannelManager Connections: DABPresetListView.qml : onPlayIconUpdateInPresetList: CurrentPlayIndex = " + currentPlayIndex + " index = " + currPresetindex)
            currentPlayIndex = currPresetindex
            idPresetGridView.currentIndex = currPresetindex
        }
    }

    Connections {
        target : DABListener
        onPlayIconUpdateInPresetList : {
            console.log("[QML] ==> DABListener Connections: DABPresetListView.qml : onPlayIconUpdateInPresetList: CurrentPlayIndex = " + currentPlayIndex + " index = " + currPresetindex)
            currentPlayIndex = currPresetindex
            idPresetGridView.currentIndex = currPresetindex
        }

        onIndexUpdateInPresetList : {
            console.log("[QML] ==> Connections: DABPresetListView.qml : onIndexUpdateInPresetList: CurrentPlayIndex = " + currentPlayIndex + " currIndex = " + currPresetindex + "  realIndex = " + realPresetindex)
            currentPlayIndex = currPresetindex
            idPresetGridView.currentIndex = currPresetindex
            idPresetListModel.setProperty(currPresetindex, "realIndex", realPresetindex)
        }
    }
}
