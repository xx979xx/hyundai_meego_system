/**
 * FileName: RadioHdPresetList.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp


FocusScope {
    id: idRadioHdPresetListFM
    x: 0; y: 0
    width: 462+14  //553+11;
    height: 532
    visible: idAppMain.globalSelectedBand != stringInfo.strHDBandAm
    //enabled: idAppMain.globalSelectedBand != stringInfo.strHDBandAm
    MSystem.ImageInfo{id: imageInfo}
    RadioHdStringInfo{ id: stringInfo }

    //****************************** # Preperty #
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    property int selectedItem: 0  // currentIndex when clicked
    property int overContentCount;

    /////////////////////////////////////////////////////////////
    // 120307 JSH
    property bool   requestStopSearch       : false
    property bool   requestStopSearchReplace: false
    property int    requestStopIndex        : -1
    property int    listPresetIndex         : 0
//    property bool   dragMode                : false
//    property bool   jogMode                 : false
//    property int    jogIndex                : -1
    property alias  currentIndex            : idChListView.currentIndex

    /////////////////////////////////////////////////////////////////////
    //JSH 131024 RadioHdMain.qml[onSigChangeBand] => RadioHdPresetList.qml[onSignalUpdateModelData] moved
    property string prevFocus         : ""
    property int    prevPresetIndex   : 0
    property string prevGlobalBand    : ""
    /////////////////////////////////////////////////////////////////////

    //// 2013.10.23 added by qutiguy - Update ListView data after drawing.
    Connections{
        target: UIListener
        onSignalUpdateModelData : {
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;

            //idChListView.model = PresetListFM1;

            ///////////////////////////////////////////////////////////////////////////////////////////////
            //JSH 131024 RadioHdMain.qml[onSigChangeBand] => RadioHdPresetList.qml[onSignalUpdateModelData] moved
            //if(idAppMain.state == "AppRadioHdMain" && (!(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled))){ // JSH 130706 deleted [focus bug]
            if((idAppMain.state == "AppRadioHdMain" || (!idAppMain.globalMenuAnimation)) && (!(idAppMain.presetSaveEnabled ||  idAppMain.presetEditEnabled))){
                if((prevGlobalBand  == idAppMain.globalSelectedBand) && (band  > 0x03)){ // when FG [or HD Display]
                    idRadioHdPresetListFM.currentIndex = prevPresetIndex;
                    idRadioHdMain.jogFocusState = prevFocus;
                }
                else{               // when AV MODE
                    /////////////////////////////////////////////////////////////
                    // JSH 130819 Modify
                    //if(prevGlobalBand != idAppMain.globalSelectedBand)//if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0) // JSH 130429 added [do not update the preset]
                    //    idRadioHdPresetListFM.currentIndex    = 0; // Model Changed [Index No.1 Select]
                    //idRadioHdPresetListFM.changeState();
                    if(prevGlobalBand != idAppMain.globalSelectedBand){ // JSH 130429 added [do not update the preset]
                        idRadioHdPresetListFM.currentIndex    = 0;        // Model Changed [Index No.1 Select]
                        idRadioHdPresetListFM.changeState();
                    }else{
                        if(QmlController.searchState == 7) // JSH 131213  preset Scan when do not update the preset
                            return;

                        idAppMain.doNotUpdate = true;
                        idRadioHdPresetListFM.changeState();
                        idAppMain.doNotUpdate = false;
                    }
                    ///////////////////////////////////////////////////////////////////
                    // JSH 130402 added Info restore
                    if(QmlController.radioBand == 0x01 && (prevGlobalBand  != idAppMain.globalSelectedBand))
                        idAppMain.menuInfoFlag = QmlController.getRadioDisPlayType() ? false : idAppMain.fmInfoFlag
                    else if(QmlController.radioBand == 0x03 && (prevGlobalBand  != idAppMain.globalSelectedBand))
                        idAppMain.menuInfoFlag = idAppMain.amInfoFlag
                    ///////////////////////////////////////////////////////////////////
                }
            }
            else if((idAppMain.presetSaveEnabled||idAppMain.presetEditEnabled)&&(idRadioHdMain.jogFocusState == "")){ // JSH 140211 ITS[0224615]
                    idRadioHdMain.jogFocusState = prevFocus;
            }
            ///////////////////////////////////////////////////////////////////////////////////////////////
        }

        onSignalSetModelData :{
            if((idChListView.model == "") && (band  == 0x01))
                idChListView.model = PresetListFM1;
        }
    }
    ////
    //****************************** # ChannelList ListView #
    ListView{
        id: idChListView
        clip: true
        focus: true
        anchors.fill: parent;
        orientation: ListView.Vertical
        highlightMoveSpeed: 99999
        cacheBuffer       : 99999   //dg.jin 20140905 ITS 245877 flick block 10000 -> 99999
        snapMode          : ListView.SnapToItem
        //boundsBehavior    : Flickable.StopAtBounds
        //////////////////////////////////////////////////////
        // 120307 JSH
        property bool   requestStopSearch       : false
        property bool   requestStopSearchReplace: false
        property int    requestStopIndex        : -1
        property string channelChangedFreq      : ""
        property int    channelChangedSps       : 0xFF
        //////////////////////////////////////////////////////
        // Preset List Edit & Save
        property int    curIndex        : -1;
        property int    insertedIndex   : -1;
        property int    selectedIndex   : -1;
        property int    savedIndex      : -1;
        property bool   isDragStarted   : false;
        signal itemInitWidth()
        signal itemMoved(int selectedIndex, bool isUp)

        property bool       listSave        : idAppMain.presetSaveEnabled
        property bool       listEdit        : idAppMain.presetEditEnabled
        property bool       ccpAccelerate   : false
        property int        backupIndex     : -1
        //Behavior on contentY {enabled: isDragStarted; NumberAnimation { duration: 100 }}
        //////////////////////////////////////////////////////
        // Preset List Edit & Save Click Signal
        onListSaveChanged: {
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;

            QmlController.setPresetSaveOrEditMode(listSave); //KSW 140403

            // JSH 121121 , init value(SAVE ON/OFF)
            idAppMain.initMode() // JSH 130718
            if(idChListView.listSave == true){                                         // JSH 121121 , save button enabled
                idChListView.backupIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;
                //if(idAppMain.state == "AppRadioHdMain")                // JSH 130706 deleted [ Focus bug]
                    idRadioHdMain.jogFocusState = "PresetList";             // JSH jog focus

                selectedItem                = 0xFF; // selected clear
                if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0) // Focus Start position //dg.jin 20150327 Start position change
                    idChListView.currentIndex   = 0;
                changeListViewPosition(idChListView.currentIndex); // Prest List No.1 Moved

                idAppMain.arrowUp       = true;
                idAppMain.arrowDown     = false;
                idAppMain.arrowLeft     = false;
                idAppMain.arrowRight    = false;
                idAppMain.doNotUpdate   = true;
            }else{
                idAppMain.arrowUp       = true;
                idAppMain.arrowDown     = false;
                idAppMain.arrowLeft     = false;
                idAppMain.arrowRight    = true;
                //if(idChListView.backupIndex != (QmlController.getPresetIndex(QmlController.radioBand)-1)){
                //    QmlController.presetListHighlightUpdate();
                //}
                //else{
                    //QmlController.setPresetIndex(QmlController.radioBand,0xFF) // Index Init
                    //if(idChListView.backupIndex+1 == 0xFF){
                    //        if(QmlController.getRadioDisPlayType() < 2)
                    //            idRadioHdMain.jogFocusState = "FrequencyDial";
                    //        else
                    //            idRadioHdMain.jogFocusState = "HDDisplay";
                    //}else{
                    // JSH 130821 -> 131214 modify , sequence 1
                    //QmlController.presetListHighlightUpdate();//QmlController.setPresetIndex(QmlController.radioBand,idChListView.backupIndex+1);
                    if(idChListView.currentIndex != (QmlController.getPresetIndex(QmlController.radioBand)-1)){
                        selectedItem = idChListView.currentIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;
                    }
                    else //ITS 0259352 dg.jin 20150306 FM Radio current playing preset is not orange in color or bold
                    {
                        selectedItem = idChListView.currentIndex;
                    }
                        // JSH 130821 , sequence 2
                        if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0){
                            changeListViewPosition(0); // JSH 130718
                            if(QmlController.getRadioDisPlayType() < 2)
                                idRadioHdMain.jogFocusState = "FrequencyDial";
                            else
                                idRadioHdMain.jogFocusState = "HDDisplay";
                        }
                        else{ // JSH 130821
                            changeListViewPosition(selectedItem); // JSH 140123
                            if(idRadioHdMain.jogFocusState != "PresetList")
                                idRadioHdMain.jogFocusState = "PresetList";
                        }
                    //}
                //}
                idChListView.backupIndex= -1;
                idAppMain.doNotUpdate   = false;
            }
        }
        onListEditChanged: {                                            // JSH 121121 , init value(Edit ON/OFF)
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;

            console.log("===================================>onListEditChanged",idChListView.curIndex,listEdit)

            QmlController.setPresetSaveOrEditMode(listEdit); //KSW 140403

            idAppMain.initMode() // JSH 130718
            if(idChListView.listEdit == true){                                       // JSH 121121 , Edit button enabled
                //idChListView.cacheBuffer = 100000 //dg.jin 20140905 ITS 245877 flick block 10000 -> 99999
                idChListView.backupIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;
                changeListViewPosition(idChListView.count-1);         // JSH 140213 roundBar error
                //if(idAppMain.state == "AppRadioHdMain")             // JSH 130706 deleted [ Focus bug]
                    idRadioHdMain.jogFocusState   = "PresetList";     // JSH jog focus

                selectedItem                = 0xFF; // selected clear

                if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0) // Focus Start position , JSH 130815 Modify
                    idChListView.currentIndex   = 0;

                changeListViewPosition(idChListView.currentIndex); // Prest List No.1 Moved

                idAppMain.arrowUp       = true;
                idAppMain.arrowDown     = false;
                idAppMain.arrowLeft     = false;
                idAppMain.arrowRight    = false;
                idAppMain.doNotUpdate   = true;

            }else{
                //idChListView.cacheBuffer = 10000 //dg.jin 20140905 ITS 245877 flick block 10000 -> 99999
                if(idChListView.currentItem.editMoveRunnig){             // JSH 140108
                    idChListView.currentItem.editMoveRunnig = false;
                    idChListView.currentItem.isDragItem     = false;
                    idChListView.isDragStarted              = false;
                    idChListView.itemInitWidth();
                    idChListView.curIndex                   = -1;
                    idChListView.insertedIndex              = -1;
                    selectedItem = idChListView.currentIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;
                }
                else if(idChListView.isDragStarted || idChListView.currentItem.isDragItem){ //else{ , JSH 140204
                    idChListView.currentItem.unlockListView();
                }

                //QmlController.setPresetIndex(QmlController.radioBand,0xFF) // Index Init
                //if(idChListView.backupIndex+1 == 0xFF){
                //    if(QmlController.getRadioDisPlayType() < 2)
                //        idRadioHdMain.jogFocusState = "FrequencyDial";
                //    else
                //        idRadioHdMain.jogFocusState = "HDDisplay";
                //}else{

                /////////////////////////////////////
                // JSH 130821 -> 131123 modify, sequence 1
                //QmlController.presetListHighlightUpdate();//QmlController.setPresetIndex(QmlController.radioBand,idChListView.backupIndex+1);
                if(idChListView.currentIndex != (QmlController.getPresetIndex(QmlController.radioBand)-1))
                    selectedItem = idChListView.currentIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;
                else //ITS 0259352 dg.jin 20150306 FM Radio current playing preset is not orange in color or bold
                {
                    selectedItem = idChListView.currentIndex;
                }
                /////////////////////////////////////

                idAppMain.arrowUp       = true;
                idAppMain.arrowDown     = false;
                idAppMain.arrowLeft     = false;
                idAppMain.arrowRight    = true;

                // JSH 130821 , sequence 2
                if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0){
                    changeListViewPosition(0); // JSH 130718
                    if(QmlController.getRadioDisPlayType() < 2)
                        idRadioHdMain.jogFocusState = "FrequencyDial";
                    else
                        idRadioHdMain.jogFocusState = "HDDisplay";
                }
                else{
                    changeListViewPosition(selectedItem); // JSH 140108
                    if(idRadioHdMain.jogFocusState != "PresetList")
                        idRadioHdMain.jogFocusState = "PresetList";
                }
                //}
                UIListener.sendDataToCluster(); // OSD UPDATE
                idAppMain.doNotUpdate   = false;
                idChListView.backupIndex= -1
            }
        }

        delegate: MComp.MChListDelegateOnlyRadio{ // MChListDelegateOnlyRadio ->MChListDelegateOnlyRadio2
                    id: idMChListDelegate
                    property int    presetSpsNum      : PresetSPS+1
                    property string presetStationName : PresetName //mChListThirdText
                    property string presetFreq        : StringFreq
                    property alias  editMoveRunnig    : moveTimer.running // JSH 140108

                    selectedApp         : "HdRadio"
                    //onlyPresetName      : true                                              // #120725 HYANG
                    mChListFirstText    : PresetNum                                         //qutiguy 1003 //index+1
                    mChListSecondText   : presetFreq //PresetName != "" ? PresetName : presetFreq        //qutiguy 1003  // # 120725 HYANG ( title != "" ? title : name )
                    mChListThirdText    : PresetName //globalSelectedBand=="AM" ? "" : PresetName
                    mChIconHdText       : (PresetSPS < 0xF0 )  ? "0" + presetSpsNum : "" //"HD" + presetSpsNum : "" , JSH 13071
                    menuHdRadioFlag     : idAppMain.hdRadioButton || QmlController.radioHDbutton //idAppMain.menuHdRadioFlag , hd saved - showed when hd button ON

                    //////////////////////////////////////////////////////////////////////
                    // preset list edit property // JSH 121121
                    presetSave                    : idChListView.listSave            // JSH 121121 , preset list save enable
                    presetSaveText                : stringInfo.strHDRadioSave        //"SAVE"  // JSH 121121 , preset list save Text
                    presetOrderHandler            : idChListView.listEdit            // JSH 121121 , preset list Edit enable

                    Timer {
                        id: moveTimer
                        interval: 100
                        onTriggered: move()
                        running: false
                        repeat: true
                        triggeredOnStart: true
                    } // End Timer

                    onPresetSaveClickOrKeySelected:{// JSH 121121 , preset list Save Button Clicked
                        //console.log("----------------------------------->> onPresetSaveClickOrKeySelected")
                        //idRadioHdMain.jogFocusState = "PresetList"; // JSH jog focus
                        if( ListView.view.requestStopSearchReplace ){
                            ListView.view.requestStopIndex = index;
                            return;
                        }
                        if( QmlController.searchState ){
                            ListView.view.requestStopSearchReplace = true;
                            ListView.view.requestStopIndex = index;
                            QmlController.seekstop();
                            return;
                        }
                        //if(idAppMain.alreadySaved == 1){
                        //    setAppMainScreen("PopupPresetWarning", true);
                        //    return;
                        //}

                        idChListView.backupIndex            = mChListFirstText - 1;
                        idAppMain.toastMessage              = stringInfo.strHDPopupPresetSaveSuccessfully;
                        idAppMain.toastMessageSecondText    = ""; // JSH 131104 [ITS 0206422]
                        //setAppMainScreen( "PopupRadioHdDimAcquiring" , true); // JSH 130911 Moved down

                        //if(!idChListView.backupIndex) , JSH 130617 delete
                        //    idAppMain.modelLoadOn = false

                        QmlController.presetReplace(idChListView.backupIndex,QmlController.radioFreq);
                        idAppMain.presetSaveEnabled = false //JSH 121121 preset list save button disable
                        //idAppMain.modelLoadOn = true , JSH 130617 delete

                        if(mChListFirstText - 1 == 0){ // JSH 130617 added
                            QmlController.presetModelSync();//    ListView.view.positionViewAtIndex (11, ListView.Beginning )
                            ListView.view.positionViewAtIndex (mChListFirstText - 1, ListView.Beginning ) // JSH 131104 , position error modify
                        }

                        setAppMainScreen( "PopupRadioHdDimAcquiring" , true); // JSH 130911 moved
                    }
                    ///////////////////////////////////////////////////////////////////////////////////////
                    ///////////////////////////////////////////////////////////////////////////////////////

                    onClickOrKeySelected: {
                        ///////////////////////////////////////////////////////////////////////
                        // Preset List Edit & Save Code
                        if(presetSave || presetOrderHandler){ // JSH 121121 , save button enabled
                            selectedItem = 0xFF;            // selected clear
                            if(showFocus && presetSave){       //  Focus on
                                presetSaveClickOrKeySelected(); // Freq Save
                            }
                            else if(showFocus && presetOrderHandler && mode){
                                if(isDragItem)
                                {
                                    var contentYBackup = ListView.view.contentY;
                                    isDragItem = false;
                                    setPresetListIndex();
                                    changeRow(ListView.view.insertedIndex, ListView.view.curIndex);
                                    unlockListView();
                                    ListView.view.contentY = contentYBackup;
                                    idAppMain.initMode(); //20141020 dg.jin reorderpreset ccplongpressed -> ccprelease
                                }else
                                {
                                    //console.log("aaaaa 1 ----------------------------------->> ",ListView.view.flicking);
                                    //console.log("aaaaa 2 ----------------------------------->> ",ListView.view.moving);
                                    //console.log("aaaaa 3 ----------------------------------->> ",isDragItem);
                                    if(isDragItem || ListView.view.flicking)
                                        return;
                                    changeListViewPosition(idChListView.currentIndex); //dg.jin 20150325 changed list When CCP press after reorder preset
                                    changeFocusIsDragItem(ListView.view.moving);
                                    isDragItem = true;
                                    lockListView();
                                    //console.log("aaaaa 4 ----------------------------------->> ");
                                }
                            }
                            return ;
                        }
                        ///////////////////////////////////////////////////////////////////////
                        console.log("----------------------------------->> onClickOrKeySelected")
                        idAppMain.touchAni = true; // JSH 130422 added
                        if( ListView.view.requestStopSearch)
                        {
                            ListView.view.requestStopIndex = index;
                            idAppMain.touchAni = false // JSH 130422 added
                            return;
                        }
                        if( QmlController.searchState )
                        {
                            ListView.view.requestStopSearch = true;
                            ListView.view.requestStopIndex = index;
                            QmlController.seekstop();
                            QmlController.setsearchState(0x00); // JSH 131115 , Preset stop issue , focus moved
                            idAppMain.touchAni = false // JSH 130422 added
                            return;
                        }

                        saveLastFrequencyToQmlController();
                        calculateFrequencyInView();
                        idRadioHdMain.jogFocusState = "PresetList";
                        idAppMain.touchAni = false // JSH 130422 added
                        console.log("### globalSelectedFrequency Item click ###")
                    } // End onClickOrKeySelected

                    ///////////////////////////////////////////////////////////////////////////////
                    // JSH 131213   onSelectKeyPressed -> onClickOrKeySelected Moved
                    //                    onSelectKeyPressed: {
                    //                        console.log(" [QML] onSelectKeyPressed : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",isDragItem)
                    //                        if(presetOrderHandler)
                    //                        {
                    //                            if(isDragItem)
                    //                            {
                    //                                var contentYBackup = ListView.view.contentY;
                    //                                isDragItem = false;
                    //                                setPresetListIndex();
                    //                                changeRow(ListView.view.insertedIndex, ListView.view.curIndex);
                    //                                unlockListView();
                    //                                ListView.view.contentY = contentYBackup;
                    //                            }else
                    //                            {
                    //                                isDragItem = true;
                    //                                lockListView();
                    //                            }
                    //                        } // End if
                    //                    } // End onSelectKeyPressed
                    ///////////////////////////////////////////////////////////////////////
                    // Preset List Edit & Save Code
                    onMousePosChanged:{ // JSH 121121
                        if(isDragItem == false)  return;

                        var point = mapToItem(idChListView, x, y);

                        if((point.y <= idChListView.y +  (88/2) || point.y >= idChListView.height -  (88/2)) && (moveTimer.running == true))
                        {
                            lastMousePositionY = point.y;
                            return;
                        }else if(point.y <= idChListView.y +  (88/2))
                        {
                            lastMousePositionY = point.y;
                            isMoveUpScroll = true;
                            moveTimer.running = true;
                            return;
                        }else if(point.y >= idChListView.height -  (88/2))
                        {
                            lastMousePositionY = point.y;
                            isMoveUpScroll = false;
                            moveTimer.running = true;
                            return;
                        }else
                        {
                            moveTimer.running = false;
                        }

                         point.y += idChListView.contentY;

                        if(point.y < 0)
                            return;

                        if(point.y > (idChListView.count * idMChListDelegate.height))
                            return;

                        var indexByPoint = parseInt(point.y / idMChListDelegate.height);
                        if(indexByPoint == idChListView.curIndex)
                            return;

                        idChListView.curIndex = indexByPoint;
                        idChListView.itemMoved(0,0);
                    }

                    onClickReleased: { // JSH 121121
                        //console.log("+++++++++++[Touch onReleased]+++++++++++");
                        if(!presetOrderHandler) { // JSH 140108 modify
                            if(!idChListView.interactive)
                                idChListView.interactive = true;
                            return;
                        }

                        if(isDragItem)
                        {
                            var contentYBackup = idChListView.contentY;
                            moveTimer.running = false;
                            isDragItem = false;
                            setPresetListIndex();
                            changeRow(idChListView.insertedIndex, idChListView.curIndex);
                            unlockListView();
                            idChListView.contentY = contentYBackup;
                            changeListViewPosition(idChListView.currentIndex); // JSH 130506 added display update
                            idAppMain.initMode(); //20141020 dg.jin reorderpreset ccplongpressed -> ccprelease
                        }
                        idRadioHdMain.jogFocusState   = "PresetList";  //dg.jin 20141024 focus issue
                    }
                    ///////////////////////////////////////////////////////////////////////
                    ///////////////////////////////////////////////////////////////////////

                    onPressAndHold: {
                        //console.log("----------------------------------->> onPressAndHold")
                        // isLongKey = true; // JSH 130711 //dg.jin 20140731 ITS 244590
                        ///////////////////////////////////////////////////////////////////////
                        // Preset List Edit & Save Code
                        if(presetOrderHandler){ // JSH 121121 , save button enabled
                            //20141020 dg.jin reorderpreset ccplongpressed -> ccprelease
                            if(!idAppMain.isTouchMode())
                            {
                                return;
                            }
                            if(isDragItem || ListView.view.flicking)
                              return;

                            if(idChListView.isDragStarted)
                            {
                                unlockListView();
                                idChListView.itemInitWidth();
                            }
                            isLongKey = true; //dg.jin 20140731 ITS 244590
                            changeFocusIsDragItem(ListView.view.moving);
                            isDragItem = true;
                            console.log(" [QML] onPressAndHold : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",isDragItem)
                            lockListView();
                            idAppMain.playBeep();   // JSH 130307
                            return ;
                        }else if(presetSave)
                            return;
                        ///////////////////////////////////////////////////////////////////////
                        isLongKey = true; //dg.jin 20140731 ITS 244590
                        if( ListView.view.requestStopSearchReplace )
                        {
                            ListView.view.requestStopIndex = index;
                            return;
                        }
                        if( QmlController.searchState )
                        {
                            ListView.view.requestStopSearchReplace = true;
                            ListView.view.requestStopIndex = index;
                            QmlController.seekstop();
                            QmlController.setsearchState(0x00); // JSH 131115 , Preset stop issue
                            return;
                        }

                        if(selectedItem == PresetNum-1)
                            QmlController.setPresetIndex(QmlController.radioBand, 0xFF);//return; // JSH 130324 Modify

                        //if(idAppMain.alreadySaved == 1 || (((mChListFirstText - 1) != (QmlController.presetIndexFM1 -1)) && (idAppMain.alreadySaved == 2))){ // 120917 PresetList HD ICON Number Change Code
                        //if(idAppMain.alreadySaved == 1){
                            //setAppMainScreen("PopupPresetWarning", true);
                        //    idAppMain.strPopupText1 = stringInfo.strHDPopupPresetAlreadySave;
                        //    idAppMain.strPopupText3 = idAppMain.strPopupText2 = "";
                        //    return;
                        //}

                        //if(mChListFirstText - 1 == 0) , JSH 130617 delete
                        //   idAppMain.modelLoadOn = false

                        QmlController.presetReplace(mChListFirstText - 1,QmlController.radioFreq)
                        idAppMain.toastMessage              = stringInfo.strHDPopupPresetSaveSuccessfully;
                        idAppMain.toastMessageSecondText    = ""; // JSH 131104 [ITS 0206422]
                        //if(mChListFirstText - 1 == 0) // JSH
                        //    ListView.view.positionViewAtIndex (mChListFirstText - 1, ListView.Beginning )

                        idRadioHdMain.jogFocusState = "PresetList";//changeState()
                        //idAppMain.modelLoadOn       = true , JSH 130617 delete
                        if(mChListFirstText - 1 == 0){ // JSH 130617
                            QmlController.presetModelSync();
                            ListView.view.positionViewAtIndex (mChListFirstText - 1, ListView.Beginning ) // JSH 131104 , position error modify
                        }
                        //dg.jin 20150213 ITS 0258199 presetlist CCP longpress beep problem
                        //UIListener.writeToLogFile("playBeep Check")
                        if(playBeepOnHold == true)
                        {
                            //UIListener.writeToLogFile("playBeep");
                            idAppMain.playBeep();   // JSH 130307
                        }
                        setAppMainScreen( "PopupRadioHdDimAcquiring" , true);
                    }

                    function calculateFrequencyInView(){
                        var freq = parseFloat(idMChListDelegate.presetFreq);//mChListSecondText);
                        /*******Select FM********/
                        //                    if(idAppMain.globalSelectedBand =="FM")
                        //                        idAppMain.globalSelectedFmFrequency =  idMChListDelegate.mChListSecondText
                        //                    /*******Select AM*********/
                        //                    else if(idAppMain.globalSelectedBand =="AM")  // AM
                        //                        idAppMain.globalSelectedAmFrequency =  idMChListDelegate.mChListSecondText

                        /*******Select FM1********/
                        if(idAppMain.globalSelectedBand =="FM1")
                            idAppMain.globalSelectedFmFrequency = freq;//  idMChListDelegate.mChListSecondText
                        /*******Select FM2********/
                        else if(idAppMain.globalSelectedBand =="FM2")
                            idAppMain.globalSelectedFmFrequency = freq;// idMChListDelegate.mChListSecondText
                        /*******Select AM*********/
                        else if(idAppMain.globalSelectedBand =="AM")  // AM
                            idAppMain.globalSelectedAmFrequency = freq;// idMChListDelegate.mChListSecondText

                        idMChListDelegate.ListView.view.currentIndex = index; //Select Index Save
                    }

                    function saveLastFrequencyToQmlController(){
                        //if(idAppMain.globalSelectedBand =="FM"){
                        if(idAppMain.globalSelectedBand =="FM1"){
                            if(QmlController.presetIndexFM1 == mChListFirstText && (presetSpsNum - 1) ==  QmlController.toFlag(QmlController.getHDRadioCurrentSPS())){
                                console.log("---------------->FM1 Preset  index is same",QmlController.presetIndexFM1 , mChListFirstText);
                                return;
                            }
                            //QmlController.presetRecall(mChListFirstText - 1,mChListSecondText); // micom has index from 0 so it need to -1
                            //QmlController.setPresetIndexFM1(mChListFirstText); // JSH 121109 comment

                            //0x01[MPS] ~ 0x08[SPS] // JSH 130328 Add => 130430 deleted
                            //if(QmlController.getRadioDisPlayType() && (QmlController.toBit(PresetSPS) < 0xFF)
                            //        && (presetStationName == QmlController.getHDRadioSIS()) && (presetFreq == QmlController. getRadioFreq()))
                            //        QmlController.hdTuneChange(QmlController.toBit(PresetSPS));
                            //else

                            //if(QmlController.getHDRadiobutton()) //(idAppMain.hdRadioButton) JSH 130329 delete
                                QmlController.presetRecall(mChListFirstText - 1,presetFreq , PresetSPS); // micom has index from 0 so it need to -1 //JSH 111007
                            //else
                            //    QmlController.presetRecall(mChListFirstText - 1,presetFreq , 0xFF); // micom has index from 0 so it need to -1 //JSH 111007
                        }
                        else if(idAppMain.globalSelectedBand =="FM2"){
                            if(QmlController.presetIndexFM2 == mChListFirstText && (presetSpsNum - 1) ==  QmlController.toFlag(QmlController.getHDRadioCurrentSPS())){
                                console.log("---------------->FM2 Preset  index is same",QmlController.presetIndexFM2 , mChListFirstText);
                                return;
                            }
                            //QmlController.presetRecall(mChListFirstText - 1,mChListSecondText); // micom has index from 0 so it need to -1
                            //QmlController.setPresetIndexFM2(mChListFirstText); // JSH 121109 comment

                            //0x01[MPS] ~ 0x08[SPS] // JSH 130328 Add=> 130430 deleted
                            //if(QmlController.getRadioDisPlayType() && (QmlController.toBit(PresetSPS) < 0xFF)
                            //       && (presetStationName == QmlController.getHDRadioSIS())  && (presetFreq == QmlController. getRadioFreq()))
                            //    QmlController.hdTuneChange(QmlController.toBit(PresetSPS));
                            //else

                            //if(QmlController.getHDRadiobutton())//(idAppMain.hdRadioButton) JSH 130329 delete
                                QmlController.presetRecall(mChListFirstText - 1,presetFreq , PresetSPS); // micom has index from 0 so it need to -1 //JSH 111007
                            //else
                            //    QmlController.presetRecall(mChListFirstText - 1,presetFreq , 0xFF); // micom has index from 0 so it need to -1 //JSH 111007

                        }
                        else if(idAppMain.globalSelectedBand =="AM") {
                            //if(QmlController.presetIndexAM == mChListFirstText){
                            if(QmlController.presetIndexAM == mChListFirstText && (presetSpsNum - 1) ==  QmlController.toFlag(QmlController.getHDRadioCurrentSPS())){
                                console.log("---------------->AM Preset  index is same");
                                return;
                            }
                            //QmlController.presetRecall(mChListFirstText - 1,mChListSecondText); // micom has index from 0 so it need to -1
                            //QmlController.setPresetIndexAM(mChListFirstText); // JSH 121109 comment

                            //0x01[MPS] ~ 0x08[SPS] // JSH 130328 Add => 130430 deleted
                            //if(QmlController.getRadioDisPlayType() && (QmlController.toBit(PresetSPS) < 0xFF)
                            //        && (presetStationName == QmlController.getHDRadioSIS()) && (presetFreq == QmlController. getRadioFreq()))
                            //    QmlController.hdTuneChange(QmlController.toBit(PresetSPS));
                            //else

                            //if(QmlController.getHDRadiobutton())//(idAppMain.hdRadioButton) JSH 130329 delete
                                QmlController.presetRecall(mChListFirstText - 1,presetFreq , PresetSPS); // micom has index from 0 so it need to -1 //JSH 111007
                            //else
                            //    QmlController.presetRecall(mChListFirstText - 1,presetFreq , 0xFF); // micom has index from 0 so it need to -1 //JSH 111007
                        }
                    }

                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                }
        model : "" //selectModel()
//        onCountChanged: {
//            console.log("=====================================>onCountChanged",idChListView.count,idAppMain.preset_Num);
//            //var prevIndex = idChListView.currentIndex // JSH jog focus (comment)
//            if(idChListView.count <idAppMain.preset_Num -1)
//                return;

////            if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
////                idChListView.currentIndex = 0; // Model Changed [Index No.1 Select]
////                changeState();
////            }
//        }
        onContentYChanged:{
            overContentCount = contentY/(contentHeight/count)
        }// for RoundScroll

        ///////////////////////////////////////////////////////////////////
        // JSH 130717 modify
        //        onFlickEnded: { // JSH 111117
        //            //            if(globalSelectedBand=="FM")
        //            //                listPresetIndex = QmlController.getPresetIndexFM1()-1
        //            //            else if(globalSelectedBand=="AM")
        //            //                listPresetIndex = QmlController.getPresetIndexAM()-1

        //            ///////////////////////////////////////////////////////
        //            // JSH 130620 reoder , save added
        //            if(idAppMain.presetSaveEnabled){
        //                listPresetIndex = idChListView.currentIndex;
        //            }else if(idAppMain.presetEditEnabled){
        //                if(!idChListView.isDragStarted)
        //                    listPresetIndex = idChListView.currentIndex;
        //            }else{
        //                if(globalSelectedBand=="FM1")
        //                    listPresetIndex = QmlController.getPresetIndexFM1()-1
        //                if(globalSelectedBand=="FM2")
        //                    listPresetIndex = QmlController.getPresetIndexFM2()-1
        //                else if(globalSelectedBand=="AM")
        //                    listPresetIndex = QmlController.getPresetIndexAM()-1
        //            }

        //            flickStartTimer.restart()
        //            idAppMain.returnToTouchMode(); // JSH 130624
        //        }
        onMovementStarted: {flickStartTimer.stop();} // JSH 140123
        onMovementEnded: { // JSH 130717
            //            if(globalSelectedBand=="FM")
            //                listPresetIndex = QmlController.getPresetIndexFM1()-1
            //            else if(globalSelectedBand=="AM")
            //                listPresetIndex = QmlController.getPresetIndexAM()-1

            ///////////////////////////////////////////////////////
            // JSH 130620 reoder , save added
            if(idAppMain.presetSaveEnabled){
                listPresetIndex = idChListView.currentIndex;
            }else if(idAppMain.presetEditEnabled){
                if(!idChListView.isDragStarted)
                    listPresetIndex = idChListView.currentIndex;
            }else{
                if(globalSelectedBand=="FM1")
                    listPresetIndex = QmlController.getPresetIndexFM1()-1
                if(globalSelectedBand=="FM2")
                    listPresetIndex = QmlController.getPresetIndexFM2()-1
                else if(globalSelectedBand=="AM")
                    listPresetIndex = QmlController.getPresetIndexAM()-1
            }

            flickStartTimer.restart()
            idAppMain.returnToTouchMode(); // JSH 130624
        }
        ///////////////////////////////////////////////////////////////////
    }

    /////////////////////////////////////////////////////
    //****************************** # ChannelList Background Image #
    // JSH 130715 modify
    Image{
        z: -1
        source: presetAndDialBackground == "PresetList" ? imgFolderRadio_Hd+"bg_menu_l.png" : ""
        //source: (presetAndDialBackground == "PresetList")  && (idAppMain.state == "AppRadioHdMain")? imgFolderRadio_Hd+"bg_menu_l.png" : "" //JSH 131108 ITS[0207844]
    }
    Image{
        y: -8//-9
        source: presetAndDialBackground == "PresetList" ? imgFolderRadio_Hd+"bg_menu_l_s.png" : ""
    }
    /////////////////////////////////////////////////////
    // JSH flick
    Timer{
        id:flickStartTimer
        interval: 5000; running: false; repeat: false
        onTriggered:{
            if(listPresetIndex != idChListView.currentIndex)
                return;

            if(idChListView.isDragStarted)// JSH 131016 , isDragStarted == true
                return;

            ///////////////////////////////////////////////////////////////////////////////////
            // JSH 140123
            if(listPresetIndex > 12)
                return;
            //if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled){
            //    if(idRadioHdMain.jogFocusState != "PresetList")
            //        return;
            //}
            ///////////////////////////////////////////////////////////////////////////////////
            // JSH 131030 modify
            // changeListViewPosition(listPresetIndex);
            idChListView.currentIndex = listPresetIndex;
            if(idChListView.currentIndex<overContentCount)
            {
                idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
            }
            else
            {
                idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex-overContentCount)%6), ListView.Beginning);
            }
            ///////////////////////////////////////////////////////////////////////////////////
        }
    }
    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 482 //486 //588;
        y: 198-systemInfo.upperAreaHeight
        moveBarPosition: idChListView.height/idChListView.count*overContentCount
        listCount: idChListView.count
    }
    //****************************** # Visual Cue #
    MComp.MVisualCue{
        id: idMVisualCue
        //x: 460  //560; //y: 358 - systemInfo.upperAreaHeight //-4
        x: 466; y: 358-systemInfo.upperAreaHeight+4; z: 10 // JSH 130817 Modify
        arrowUpFlag: arrowUp
        arrowDownFlag: arrowDown
        arrowLeftFlag: arrowLeft
        arrowRightFlag: arrowRight
    }
    Connections{
        target: UIListener
        onSigGoFirstStation:{
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;
            //if(idAppMain.state == "AppRadioHdMain"){ // JSH 130910 added
            if(idAppMain.state == "AppRadioHdMain" && (!idChListView.isDragStarted)){  // JSH 131015 modify
                if( idChListView.currentIndex ){
                    idChListView.decrementCurrentIndex();
                    idChListView.ccpAccelerate = true
                    //////////////////////////////////////////////////////////////
                    // JSH 130809 added
                    if(!(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled)){
                        idAppMain.doNotUpdate = true
                        QmlController.setPresetIndex(QmlController.radioBand,idChListView.currentIndex+1);
                        idAppMain.doNotUpdate = false
                    }
                    //////////////////////////////////////////////////////////////
                }
            }
        }

        onSigGoLastStation:{
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;
            //if(idAppMain.state == "AppRadioHdMain"){ // JSH 130910 added
            if(idAppMain.state == "AppRadioHdMain" && (!idChListView.isDragStarted)){  // JSH 131015 modify
                if( idChListView.count-1 != idChListView.currentIndex ){
                    idChListView.incrementCurrentIndex();
                    idChListView.ccpAccelerate = true
                    //////////////////////////////////////////////////////////////
                    // JSH 130809 added
                    if(!(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled)){
                        idAppMain.doNotUpdate = true
                        QmlController.setPresetIndex(QmlController.radioBand,idChListView.currentIndex+1);
                        idAppMain.doNotUpdate = false
                    }
                    //////////////////////////////////////////////////////////////

                    //dg.jin 150430 ITS 262190 Down Key Long Pressed VisualCueFocus
                    if(false == idAppMain.downKeyLongPressedVisualCueFocus) {
                        idAppMain.downKeyLongPressedVisualCueFocus = true; 
                    }
                }
            }
        }
        onSigGoFirstorLastStationTimerEnd:{ // 130822
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;
            //if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled)                                        // JSH 130910 deleted
            if((idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled) || (idAppMain.state != "AppRadioHdMain")) // JSH 130910 modify
                return;

            var index = QmlController.getPresetIndex(QmlController.radioBand);
            QmlController.setPresetIndex(QmlController.radioBand,0xFF);
            QmlController.setChannel(index);
        }
    }

    Connections{
        target: QmlController
        onChangeSearchState: {
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;
            console.log(" HJIGKS: [RadioFMMode2List] onChangeSearchState value :" , value,idChListView.requestStopSearch,idChListView.requestStopSearchReplace);
            if( value == 0 && idChListView.requestStopSearch == true )
            {
                console.log(" HJIGKS : onChangeSearchState requestStopSearch: " + idChListView.requestStopSearch);
                idChListView.requestStopSearch = false;
                QmlController.setPresetIndex(QmlController.radioBand,0xFF);
                idChListView.currentIndex = idChListView.requestStopIndex;
                idChListView.currentItem.saveLastFrequencyToQmlController();
                idChListView.currentItem.calculateFrequencyInView();
            }
            else if( value == 0 && idChListView.requestStopSearchReplace == true )
            {
                console.log(" HJIGKS : onChangeSearchState requestStopSearchReplace: " + idChListView.requestStopSearchReplace);
                idChListView.requestStopSearchReplace = false;
                idChListView.currentIndex = idChListView.requestStopIndex;
                //idChListView.currentItem.saveLastFrequencyToQmlController();
                //idChListView.currentItem.calculateFrequencyInView();
                /////////////////////////////////////////////////////////////////////////
                // JSH 121107 Searching Preset Replace

                //if(idChListView.currentIndex == 0) , JSH 130617 delete
                //   idAppMain.modelLoadOn = false

                QmlController.presetReplace(idChListView.currentIndex,QmlController.radioFreq)
                idAppMain.toastMessage              = stringInfo.strHDPopupPresetSaveSuccessfully;
                idAppMain.toastMessageSecondText    = ""; // JSH 131104 [ITS 0206422]
                //setAppMainScreen( "PopupRadioHdDimAcquiring" , true); , JSH 130911 Moved down

                //if(idChListView.currentIndex == 0) // JSH
                //   ListView.view.positionViewAtIndex (idChListView.currentIndex, ListView.Beginning )
                //changeState();
                //idAppMain.modelLoadOn = true , JSH 130617 delete
                //if(mChListFirstText - 1 == 0){    // JSH 130617 added => 140303 deleted
                if(idChListView.currentIndex == 0){ // JSH 140303 added
                    QmlController.presetModelSync();
                    //ListView.view.positionViewAtIndex (mChListFirstText - 1, ListView.Beginning ) // JSH 131104 , position error modify => 140303 deleted
                    idChListView.positionViewAtIndex (idChListView.currentIndex, idChListView.Beginning) // JSH 140303 added
                }

                setAppMainScreen( "PopupRadioHdDimAcquiring" , true); // JSH 130911 moved
                /////////////////////////////////////////////////////////////////////////
            }
//            else if(value == 0 && idRadioHdPresetListFM.requestStopSearch == true ){
//                console.log("onChangeSearchState requestStopSearch: " + idRadioHdPresetListFM.requestStopSearch + idRadioHdPresetListFM.requestStopIndex);
//                idRadioHdPresetListFM.requestStopSearch = false;
//                //QmlController.setPresetIndexFM1(idRadioHdPresetListFM.requestStopIndex); // JSH 121109 comment ==> presetRecall
//                QmlController.presetRecall(idRadioHdPresetListFM.requestStopIndex - 1,idRadioHdPresetListFM.channelChangedFreq,idRadioHdPresetListFM.channelChangedSps); // micom has index from 0 so it need to -1
//                idChListView.currentItem.calculateFrequencyInView();
//                idRadioHdPresetListFM.requestStopIndex   = -1;
//                idRadioHdPresetListFM.channelChangedFreq = "";
//                idRadioHdPresetListFM.channelChangedSps  = 0xFF;
//            }

            ///////////////////////////////////////////////////////////////////////////////////////
            // JSH 130808 => 130819 Modify ,  Do not update the focus during the seek[search]
            //changeState();

            //if(value > 2 && value < 8) // scan , preset scan , bsm
            //    changeState();
            //else{                      // fast seek , seek

            //if(idRadioHdMain.jogFocusState != "FrequencyDial" && (value))
            //    idRadioHdMain.jogFocusState = "FrequencyDial";

            //    idAppMain.doNotUpdate = true
            //    changeState();
            //    idAppMain.doNotUpdate = false
            //}
            if(value){ // search start
                idChListView.currentIndex = overContentCount; // preset list up/down scroll bug , JSH 131106
                if((idRadioHdMain.jogFocusState != "PresetList") && (value == 7)){
                    //idRadioHdPresetListFM.forceActiveFocus(); // , JSH 131106 deleted
                    idRadioHdMain.jogFocusState = "PresetList";
                }
                //else if(idRadioHdMain.jogFocusState != "FrequencyDial" && (value != 7))
                //      idRadioHdMain.jogFocusState = "FrequencyDial";
                else if(value != 7){
                    // JSH 131215 modify
                    //if((idRadioHdMain.jogFocusState != "HDDisplay")&&(value == 0xFF)&&(QmlController.getPresetIndex(QmlController.radioBand) > 12)){
                    if((value == 0xFF) && (QmlController.getPresetIndex(QmlController.radioBand) > 12)){ // sps changed or sps -> analog changed
                        if(QmlController.getRadioDisPlayType() > 1)
                            idRadioHdMain.jogFocusState = "HDDisplay";
                        else
                            idRadioHdMain.jogFocusState = "FrequencyDial";
                    }
                    else if(idRadioHdMain.jogFocusState != "FrequencyDial" && (value != 7)&&(value != 0xFF))
                          idRadioHdMain.jogFocusState = "FrequencyDial";
                }
            }

            idAppMain.doNotUpdate = true
            changeState();
            idAppMain.doNotUpdate = false
            ///////////////////////////////////////////////////////////////////////////////////////
        }
        onChannelChanged:{
            if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
                return;
            console.log(" [RadioFMMode2List] onChannelChanged mode :" , index , freq , search);
            if(search){
                idChListView.requestStopSearch  = true;
                idChListView.requestStopIndex   = index-1;
                //idChListView.channelChangedFreq = freq;
                //idChListView.channelChangedSps  = sps;
            }
            idAppMain.popupClose(true);
        }

        //onHdRadioChangeSignal: QmlController.presetListHighlightUpdate();//changeState(); // HD Radio DISPLAY CHANGE // 121109
        onChangeIndexFM1:{
            //if(idAppMain.globalSelectedBand !="FM")
            if(idAppMain.globalSelectedBand !="FM1")
                return;

            //////////////////////////////////////////////////////////////
            // JSH 130808 => 130819 Modify ,  Do not update the focus during the seek[search]
            //changeState();
            //if((!QmlController.searchState) || (QmlController.searchState > 2 && QmlController.searchState < 8))
            if((!QmlController.searchState))
                changeState();
            else{
                idAppMain.doNotUpdate = true
                changeState();
                idAppMain.doNotUpdate = false
                if(idRadioHdMain.jogFocusState == "PresetList" && (QmlController.getPresetIndex(QmlController.radioBand) > 12)){ //JSH 130820 Modify
                    if(QmlController.getRadioDisPlayType() < 2)
                        idRadioHdMain.jogFocusState = "FrequencyDial"
                    else
                        idRadioHdMain.jogFocusState = "HDDisplay"
                }
            }
            //////////////////////////////////////////////////////////////
        }
        onChangeIndexFM2:{
            if(idAppMain.globalSelectedBand !="FM2")
                return;

            //////////////////////////////////////////////////////////////
            // JSH 130808 => 130819 Modify ,  Do not update the focus during the seek[search]
            //changeState();
            //if((!QmlController.searchState) || (QmlController.searchState > 2 && QmlController.searchState < 8))
            if((!QmlController.searchState))
                changeState();
            else{
                idAppMain.doNotUpdate = true
                changeState();
                idAppMain.doNotUpdate = false
                if(idRadioHdMain.jogFocusState == "PresetList" && (QmlController.getPresetIndex(QmlController.radioBand) > 12)){ //JSH 130820 Modify
                    if(QmlController.getRadioDisPlayType() < 2)
                        idRadioHdMain.jogFocusState = "FrequencyDial"
                    else
                        idRadioHdMain.jogFocusState = "HDDisplay"
                }
            }
            //////////////////////////////////////////////////////////////
        } 
    }
    /////////////////////////////////////////////////////////////////
    // idRadioHdPresetListFM functions
    function selectModel() {
        //    if(idAppMain.globalSelectedBand =="FM") return PresetListFM1;
        //    else if(idAppMain.globalSelectedBand =="AM") return PresetListAM;
        if(idAppMain.globalSelectedBand =="FM1"      && idAppMain.modelLoadOn) return PresetListFM1;//idAppMain.firstBootCheck) return PresetListFM1;
        else if(idAppMain.globalSelectedBand =="FM2" && idAppMain.modelLoadOn) return PresetListFM2;//idAppMain.firstBootCheck) return PresetListFM2;
        else if(idAppMain.globalSelectedBand =="AM"  && idAppMain.modelLoadOn) return PresetListAM; //idAppMain.firstBootCheck) return PresetListAM;
    }
    function changeState(){
        //idChListView.currentIndex = 0; // band change[presetindex == 0xFF] Preset No.1 select
        if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
            return;

        if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
            return;

        idAppMain.alreadySaved = 0;
        idRadioHdPresetListFM.selectedItem = 0xFF;

        if(idAppMain.globalSelectedBand != stringInfo.strHDBandAm){////if(idAppMain.globalSelectedBand =="FM"){
            if(QmlController.radioBand != 0x01)
                return;
            if((QmlController.presetIndexFM1 -1) < 0xF0 ){
                if(idChListView.currentIndex != QmlController.presetIndexFM1 -1)
                    idChListView.currentIndex = QmlController.presetIndexFM1 -1;

                if(idChListView.currentItem == null){
                    idAppMain.alreadySaved = 0;
                    idRadioHdPresetListFM.selectedItem = 0xFF;
                    //return;
                }else{
                    console.log("function changeState(){ qt index , qml index , qml sps , qt sps  ================> FM1 :: "
                                ,QmlController.presetIndexFM1 -1,idChListView.currentIndex,idChListView.currentItem.presetSpsNum -1
                                ,QmlController.toFlag(QmlController.getHDRadioCurrentSPS()))

                    console.log("function changeState(){ ================> FM1 :: presetName , SIS "
                                ,idChListView.currentItem.presetStationName ,QmlController.getHDRadioSIS())

                    if(QmlController.getHDRadiobutton()){
                        if((idChListView.currentItem.presetSpsNum - 1) ==  QmlController.toFlag(QmlController.getHDRadioCurrentSPS())){
                            if(((idChListView.currentItem.presetStationName == QmlController.getHDRadioSIS())
                               || (idChListView.currentItem.presetStationName == "") //dg.jin 20140911 ITS 248028 HD Radio PresetList focus issue
                               || (QmlController.getHDRadioSIS() == ""))
                            && (QmlController.getRadioDisPlayType())){
                                //idAppMain.alreadySaved = 1; // JSH 121012 (alreadySaved) not used
                                idRadioHdPresetListFM.selectedItem = QmlController.presetIndexFM1 -1;
                            }
                            else if(!QmlController.getRadioDisPlayType()){
                                //idAppMain.alreadySaved = 1; // JSH 121012 (alreadySaved) not used
                                idRadioHdPresetListFM.selectedItem = QmlController.presetIndexFM1 -1;
                            }
                        }
                    }else{
                        idRadioHdPresetListFM.selectedItem = QmlController.presetIndexFM1 -1;
                    }
                }
            }
        }

        //if((!idAppMain.doNotUpdate) && ((idAppMain.state == "AppRadioHdMain") || (!idAppMain.globalMenuAnimation))){            , JSH 140129 ITS [0223314]
        if((!idAppMain.doNotUpdate) && ((idAppMain.state == "AppRadioHdMain")
                                        || (idAppMain.state == "PopupRadioHdDimAcquiring") || (!idAppMain.globalMenuAnimation))){ // JSH 140129 ITS [0223314]
            //console.log("------------------changeState jogFocusState ::",idRadioHdMain.jogFocusState)
            //if(QmlController.getRadioDisPlayType() > 1)
            //    idRadioHdMain.jogFocusState =  "HDDisplay"
            //else
            if(QmlController.getRadioDisPlayType() < 2){
                if(idRadioHdPresetListFM.selectedItem < 12)
                    idRadioHdMain.jogFocusState =  "PresetList"
                else
                    idRadioHdMain.jogFocusState =  "FrequencyDial"
            }
        }
        if(!idAppMain.isTouchMode()) // JSH 130624
            changeListViewPosition(idChListView.currentIndex);

        //if((QmlController.getRadioDisPlayType() && idAppMain.fmInfoFlag) || (idAppMain.hdSignalPerceive && idAppMain.fmInfoFlag))

        if((idAppMain.menuInfoFlag != idAppMain.fmInfoFlag) && (QmlController.getHDRadioCurrentSPS() > 0xF0)){ // JSH 130402 Info On/OFF Check added
            if((!QmlController.getRadioDisPlayType()) && (QmlController.radioBand == 1))//if(!QmlController.getRadioDisPlayType())
               idAppMain.menuInfoFlag = idAppMain.fmInfoFlag// idRadioHdMain.changeInfoState(2,false) , JSH 130621 Info Window Delete
        }

        console.log("=====>changeState(globalSelectedBand :: " , idAppMain.globalSelectedBand , "currentIndex :: ",idChListView.currentIndex,"alreadySaved :: ",idAppMain.alreadySaved,")")
    }

    function changeListViewPosition(index){
        if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
            return;
        if(index <= 5)
            idChListView.positionViewAtIndex(0, ListView.Beginning)
        else if(index > 5 && index < 12)
            idChListView.positionViewAtIndex(6, ListView.Beginning)
    }

    function changeFocusIsDragItem(listmoving) {
        if(idAppMain.globalSelectedBand == stringInfo.strHDBandAm)
            return;
        if(listPresetIndex != idChListView.currentIndex)
        {
            //console.log("aaaaa ----------------------------------->> 1",listPresetIndex)
            //console.log("aaaaa ----------------------------------->> 1",idChListView.currentIndex)
            return;
        }
        
        if(idChListView.isDragStarted)
        {
            //console.log("aaaaa ----------------------------------->> 2",idChListView.isDragStarted)
            return;
        }
            
        if(listPresetIndex > 12)
        {
            //console.log("aaaaa ----------------------------------->> 3",listPresetIndex)
            return;
        }
        
            //console.log("aaaaa ----------------------------------->> a",flickStartTimer.running)
            //console.log("aaaaa ----------------------------------->> b",listmoving)
        if(false == flickStartTimer.running && false == listmoving)
        {
            //console.log("aaaaa ----------------------------------->> c",flickStartTimer.running)
            //console.log("aaaaa ----------------------------------->> d",listmoving)
            return;
        }
        
        //console.log("aaaaa ----------------------------------->> 5")
        flickStartTimer.stop();
        
        idChListView.currentIndex = listPresetIndex;
        if(idChListView.currentIndex<overContentCount)
        {
            idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex%6)), ListView.Beginning);
        }
        else
        {
            idChListView.positionViewAtIndex((idChListView.currentIndex - (idChListView.currentIndex-overContentCount)%6), ListView.Beginning);
        }
    }
}

