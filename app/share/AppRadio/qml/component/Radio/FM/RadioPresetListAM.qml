/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03- Initial Created by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp


FocusScope {
    id: idRadioPresetListAM
    x: 0; y: 0
    width: 553+11; height: 532
    visible: idAppMain.globalSelectedBand == "AM"
    //enabled: idAppMain.globalSelectedBand == "AM"

    MSystem.ImageInfo{id: imageInfo}
    RadioStringInfo{ id: stringInfo }

    //****************************** # Preperty #
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    property int selectedItem: 0  // currentIndex when clicked
    property int overContentCount;  // for RoundScroll

    /////////////////////////////////////////////////////////////
    // 120307 JSH
    property bool   requestStopSearch: false
    property bool   requestStopSearchReplace: false
    property int    requestStopIndex: -1
    property int    listPresetIndex : 0
//    property bool   dragMode        : false
//    property bool   jogMode         : false
//    property int    jogIndex        : -1
    property alias  currentIndex    : idChListView.currentIndex

    Connections{
        target: QmlController
        onChangeSearchState: {
            if(idAppMain.globalSelectedBand !="AM")
              return;
            console.log(" HJIGKS: [RadioFMMode2List] onChangeSearchState value :" + value );
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
                idAppMain.toastMessage = stringInfo.strRadioPopupPresetSaveSuccessfully;
                setAppMainScreen( "PopupRadioDimAcquiring" , true);
                //if(idChListView.currentIndex == 0) // JSH
                //  ListView.view.positionViewAtIndex (idChListView.currentIndex, ListView.Beginning )
                //changeState();
                //idAppMain.modelLoadOn = true , JSH 130617 delete
                //if(mChListFirstText - 1 == 0)    // JSH 130617 added => 140303 deleted
                if(idChListView.currentIndex == 0) // JSH 140303 added
                    QmlController.presetModelSync();

                /////////////////////////////////////////////////////////////////////////
            }
//            else if(value == 0 && idRadioPresetListAM.requestStopSearch == true ){
//                console.log("onChangeSearchState requestStopSearch: " + idRadioPresetListAM.requestStopSearch + idRadioPresetListAM.requestStopIndex);
//                idRadioPresetListAM.requestStopSearch = false;
//                QmlController.setPresetIndex(QmlController.radioBand,idRadioPresetListAM.requestStopIndex)//QmlController.setPresetIndexFM1(idRadioPresetListAM.requestStopIndex);
//                QmlController.presetRecall(idRadioPresetListAM.requestStopIndex - 1,idRadioPresetListAM.channelChangedFreq); // micom has index from 0 so it need to -1
//                idChListView.currentItem.calculateFrequencyInView();
//                idRadioPresetListAM.requestStopIndex   = -1;
//                idRadioPresetListAM.channelChangedFreq = "";
//            }

//// 2013.12.05 modified by qutiguy : ITS 211952 211918 - donot change focus  while scaning.
//            // 2013.10.01 modified by qutiguy - ITS 0192408, 0191722
//            if(!value)changeState();

            if(value){ // search start
                idChListView.currentIndex = overContentCount; // preset list up/down scroll bug , JSH 131106
                if((idRadioMain.jogFocusState != "PresetList") && (value == 7)){
                    idRadioMain.jogFocusState = "PresetList";
                }
                else if(value != 7){
                    idRadioMain.jogFocusState = "FrequencyDial";
                }
            }
            idAppMain.doNotUpdate = true
            changeState();
            idAppMain.doNotUpdate = false
////
        }
        onChannelChanged:{
            if(idAppMain.globalSelectedBand !="AM")
              return;
            console.log(" [RadioFMMode2List] onChannelChanged mode :" , index-1 , freq ,search);
            if(search){
                idChListView.requestStopSearch = true;
                idChListView.requestStopIndex  = index-1;
                //idChListView.channelChangedFreq = freq;
            }
            idAppMain.popupClose(true);
            //// 2013.12.29 added by qutiguy - ITS 0210488
            idAppMain.checkVRStatus();
            ////
        }
    }
    //// 2013.10.23 added by qutiguy - Update ListView data after drawing.
    Connections{
        target: UIListener
        onSignalUpdateModelData :{
            //idChListView.model = selectModel();
        }

        onSignalSetModelData :{
            if((idChListView.model == "") && (band  == 0x03))
                idChListView.model = PresetListAM;
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
        cacheBuffer       : 99999 //dg.jin 20140905 ITS 245877 flick block 10000 -> 99999
        snapMode: ListView.SnapToItem
        //boundsBehavior    : Flickable.StopAtBounds
        //////////////////////////////////////////////////////
        // 120307 JSH
        property bool   requestStopSearch       : false
        property bool   requestStopSearchReplace: false
        property int    requestStopIndex        : -1
        property string channelChangedFreq      : ""
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
        onListSaveChanged: {                                              // JSH 121121 , init value(SAVE ON/OFF)
            if(idAppMain.globalSelectedBand !="AM")
              return;

            console.log("===================================>onListSaveChanged",idChListView.listSave)
            idAppMain.initMode() // JSH 130718
            if(idChListView.listSave == true){               // JSH 121121 , save button enabled
                idChListView.backupIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;

                //if(idAppMain.state == "AppRadioMain") // JSH 130706 deleted [ Focus bug]
                    idRadioMain.jogFocusState = "PresetList";    // JSH jog focus

                selectedItem = 0xFF;            // selected clear
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
                if(idChListView.backupIndex != (QmlController.getPresetIndex(QmlController.radioBand)-1)){}
                else{
                    //selectedItem = idChListView.backupIndex;
                    QmlController.setPresetIndex(QmlController.radioBand,0xFF) // Index Init
                    if(idChListView.backupIndex+1 == 0xFF){
                        //if(idAppMain.state == "AppRadioMain")
                            idRadioMain.jogFocusState = "FrequencyDial";
                        changeListViewPosition(0); // JSH 130718
                    }else{
                        QmlController.setPresetIndex(QmlController.radioBand,idChListView.backupIndex+1);   // JSH 130821 , sequence 1
                        if(idRadioMain.jogFocusState != "PresetList")                                       // JSH 130821 , sequence 2
                            idRadioMain.jogFocusState = "PresetList";
                    }
                }

                //UIListener.sendDataToCluster(); // OSD UPDATE

                idChListView.backupIndex= -1;
                idAppMain.doNotUpdate   = false;
            }
        }
        onListEditChanged: {                                            // JSH 121121 , init value(Edit ON/OFF)
            if(idAppMain.globalSelectedBand !="AM")
              return;

            console.log("===================================>onListEditChanged",idChListView.curIndex,listEdit,QmlController.getPresetIndex(QmlController.radioBand))
            idAppMain.initMode() // JSH 130718
            if(idChListView.listEdit == true){                                       // JSH 121121 , Edit button enabled
                //idChListView.cacheBuffer = 100000; //dg.jin 20140905 ITS 245877 flick block 10000 -> 99999
                //idChListView.currentItem.unlockListView();
                idChListView.backupIndex = QmlController.getPresetIndex(QmlController.radioBand)-1;
                //QmlController.setPresetIndex(QmlController.radioBand,0xFF)

                //if(idAppMain.state == "AppRadioMain") // JSH 130706 deleted [ Focus bug]
                    idRadioMain.jogFocusState = "PresetList";                     // JSH jog focus

                selectedItem = 0xFF;            // selected clear
                if(QmlController.getPresetIndex(QmlController.radioBand) > 0xF0) // Focus Start position , JSH 130815 Modify
                    idChListView.currentIndex = 0;

                changeListViewPosition(idChListView.currentIndex); // Prest List No.1 Moved

                idAppMain.arrowUp       = true;
                idAppMain.arrowDown     = false;
                idAppMain.arrowLeft     = false;
                idAppMain.arrowRight    = false;
                idAppMain.doNotUpdate   = true;
            }else{
                //idChListView.cacheBuffer = 10000; //dg.jin 20140905 ITS 245877 flick block 10000 -> 99999

                ///////////////////////////////////////////////////////////////////
                //idChListView.currentItem.unlockListView(); //JSH 130527 added
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
                ///////////////////////////////////////////////////////////////////

                QmlController.setPresetIndex(QmlController.radioBand,0xFF) // Index Init

                idAppMain.arrowUp       = true;
                idAppMain.arrowDown     = false;
                idAppMain.arrowLeft     = false;
                idAppMain.arrowRight    = true;

                if(idChListView.backupIndex+1 == 0xFF){
                    //if(idAppMain.state == "AppRadioMain")
                        idRadioMain.jogFocusState = "FrequencyDial";
                    changeListViewPosition(0); // JSH 130718
                }else{
                    QmlController.setPresetIndex(QmlController.radioBand,idChListView.backupIndex+1);   // JSH 130821 , sequence 1
                    if(idRadioMain.jogFocusState != "PresetList")                                       // JSH 130821 , sequence 2
                        idRadioMain.jogFocusState = "PresetList";
                }

                UIListener.sendDataToCluster(); // OSD UPDATE
                idAppMain.doNotUpdate   = false;
                idChListView.backupIndex= -1;
            }
        }

        delegate: MComp.MChListDelegateOnlyRadio{
                  id: idMChListDelegate
                  selectedApp       : "Radio"
                  mChListFirstText  : PresetNum          // qutiguy 1003 //index+1
                  mChListSecondText : StringFreq         // qutiguy 1003 //name
                  mChListThirdText  : PresetName         // qutiguy 1003 //title
                  //////////////////////////////////////////////////////////////////////
                  // preset list edit property // JSH 121121
                  presetSave                    : idChListView.listSave            // JSH 121121 , preset list save enable
                  presetSaveText                : stringInfo.strRadioSave          //"SAVE" // JSH 121121 , preset list save Text
                  presetOrderHandler            : idChListView.listEdit            // JSH 121121 , preset list Edit enablee
                  property alias      editMoveRunnig  : moveTimer.running          // JSH 140108

                  Timer {
                      id: moveTimer
                      interval: 100
                      onTriggered: move()
                      running: false
                      repeat: true
                      triggeredOnStart: true
                  } // End Timer

                  onPresetSaveClickOrKeySelected:{// JSH 121121 , preset list Save Button Clicked
                      console.log("----------------------------------->> onPresetSaveClickOrKeySelected")
                      //idRadioMain.jogFocusState = "PresetList"; // JSH jog focus
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
//// 20130607 removed by qutiguy - no use.
//                      if(idAppMain.alreadySaved == 1){
//                          setAppMainScreen("PopupPresetWarning", true);
//                          return;
//                      }
////
                      idChListView.backupIndex    = mChListFirstText - 1;
                      idAppMain.toastMessage = stringInfo.strRadioPopupPresetSaveSuccessfully;
                      setAppMainScreen( "PopupRadioDimAcquiring" , true);

                      //if(!idChListView.backupIndex) , JSH 130617 delete
                      //    idAppMain.modelLoadOn = false

                      QmlController.presetReplace(idChListView.backupIndex,QmlController.radioFreq);

                      idAppMain.presetSaveEnabled = false //JSH 121121 preset list save button disable
                      //idAppMain.modelLoadOn       = true , JSH 130617 delete

                      //if(mChListFirstText - 1 == 0) // JSH
                      //  ListView.view.positionViewAtIndex (mChListFirstText - 1, ListView.Beginning )
                      if(mChListFirstText - 1 == 0) // JSH 130617 added
                        QmlController.presetModelSync();

                  }
                  ///////////////////////////////////////////////////////////////////////////////////////
                  ///////////////////////////////////////////////////////////////////////////////////////

                  onClickOrKeySelected: {
                  console.log("----------------------------------->>PresetList  onClickOrKeySelected")
                      if(presetSave || presetOrderHandler){ // JSH 121121 , save button enabled
                          selectedItem = 0xFF;            // selected clear
                          if(showFocus && presetSave)       //  Focus on
                              presetSaveClickOrKeySelected(); // Freq Save
                              //KSW 131224 refer HDRadio ITS/217062
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

                      console.log("----------------------------------->> onClickOrKeySelected")
                      idAppMain.touchAni = true; // JSH 130422 added
                      if( ListView.view.requestStopSearch )
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
                        idAppMain.touchAni = false // JSH 130422 added
                        return;
                      }

                      saveLastFrequencyToQmlController();
                      calculateFrequencyInView();
                      if(idRadioMain.jogFocusState != "PresetList" && (idAppMain.state == "AppRadioMain"))
                          idRadioMain.jogFocusState = "PresetList";

                      idAppMain.touchAni = false // JSH 130422 added
                   } // End onClickOrKeySelected
                    //KSW 131224 refer HDRadio ITS/217062
//                  onSelectKeyPressed: {
//                      console.log(" [QML] onSelectKeyPressed : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",isDragItem)
//                      if(presetOrderHandler)
//                      {
//                          if(isDragItem)
//                          {
//                              var contentYBackup = ListView.view.contentY;
//                              isDragItem = false;
//                              setPresetListIndex();
//                              changeRow(ListView.view.insertedIndex, ListView.view.curIndex);
//                              unlockListView();
//                              ListView.view.contentY = contentYBackup;
//                          }else
//                          {
//                              isDragItem = true;
//                              lockListView();
//                          }
//                      } // End if
//                  } // End onSelectKeyPressed

                  onMousePosChanged:{ // JSH 121121
//                      console.log("+++++++++++[onMousePosChanged]+++++++++++");

                      if(isDragItem == false)  return;

                      var point = mapToItem(idChListView, x, y);

                      //if(lastMousePositionY <= 88 && (!idChListView.curIndex))
                      //{
                      //    lastMousePositionY = point.y;
                      //    return;
                      //}else
                      if((point.y <= idChListView.y + (88/2) || point.y >= idChListView.height - (88/2)) && (moveTimer.running == true))
                      {
                          lastMousePositionY = point.y;
                          return;
                      }else if(point.y <= idChListView.y + (88/2))
                      {
                          lastMousePositionY = point.y;
                          isMoveUpScroll = true;
                          moveTimer.running = true;
                          return;
                      }else if(point.y >= idChListView.height - (88/2))
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
//                      console.log("+++++++++++[onReleased]+++++++++++");
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
                      idRadioMain.jogFocusState   = "PresetList";  //dg.jin 20141024 focus issue
                  }
                  ///////////////////////////////////////////////////////////////////////
                  onPressAndHold: {
                     //console.log("+++++++++++[onPressAndHold]+++++++++++",isDragItem);
                     if(presetOrderHandler){ // JSH 121121
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
                      isLongKey = true;  // JSH 130711
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
                          return;
                      }

                      if(selectedItem == PresetNum-1)
                          QmlController.setPresetIndex(QmlController.radioBand, 0xFF);//return; // JSH 130324 Modify
//// 20130607 removed by qutiguy - no use.
//                      if(idAppMain.alreadySaved == 1){
//                          setAppMainScreen("PopupPresetWarning", true);
//                          return;
//                      }
////

//                      //idAppMain.touchFmAniStop = false;
//                      //idAppMain.touchAmAniStop = false;
//                      idAppMain.touchFmAniStop = true
//                      idAppMain.touchAmAniStop = true

                      //if(mChListFirstText - 1 == 0) , JSH 130617 delete
                      //   idAppMain.modelLoadOn = false

                      QmlController.presetReplace(mChListFirstText - 1,QmlController.radioFreq)
//                      //idAppMain.touchFmAniStop = true
//                      //idAppMain.touchAmAniStop = true

                      idAppMain.toastMessage = stringInfo.strRadioPopupPresetSaveSuccessfully;
                      setAppMainScreen( "PopupRadioDimAcquiring" , true);

                      //if(mChListFirstText - 1 == 0) // JSH
                      //    ListView.view.positionViewAtIndex (mChListFirstText - 1, ListView.Beginning )

                      changeState();
                      //idAppMain.modelLoadOn       = true , JSH 130617 delete
                      if(mChListFirstText - 1 == 0) // JSH 130617 added
                        QmlController.presetModelSync();

                      //dg.jin 20150213 ITS 0258199 presetlist CCP longpress beep problem
                      //UIListener.writeToLogFile("playBeep Check")
                      if(playBeepOnHold == true)
                      {
                          //UIListener.writeToLogFile("playBeep");
                          idAppMain.playBeep();   // JSH 130307
                      }
                  }

                function calculateFrequencyInView(){
                    /*******Select FM1********/
                    if(idAppMain.globalSelectedBand =="FM1")
                        idAppMain.globalSelectedFmFrequency =  idMChListDelegate.mChListSecondText
                    /*******Select FM2********/
                    else if(idAppMain.globalSelectedBand =="FM2")
                        idAppMain.globalSelectedFmFrequency =  idMChListDelegate.mChListSecondText
                    /*******Select AM*********/
                    else if(idAppMain.globalSelectedBand =="AM")  // AM
                        idAppMain.globalSelectedAmFrequency =  idMChListDelegate.mChListSecondText

                    idMChListDelegate.ListView.view.currentIndex = index; //Select Index Save
                }

                function saveLastFrequencyToQmlController(){
                    if(idAppMain.globalSelectedBand =="FM1"){
                        if(QmlController.presetIndexFM1 == mChListFirstText){
                            console.log("---------------->FM1 Preset  index is same",QmlController.presetIndexFM1 , mChListFirstText);
                            return;
                        }
                        QmlController.setPresetIndexFM1(mChListFirstText);
                        QmlController.presetRecall(mChListFirstText - 1,mChListSecondText); // micom has index from 0 so it need to -1
                    }
                    else if(idAppMain.globalSelectedBand =="FM2"){
                        if(QmlController.presetIndexFM2 == mChListFirstText){
                            console.log("---------------->FM2 Preset  index is same");
                            return;
                        }
                        QmlController.setPresetIndexFM2(mChListFirstText);
                        QmlController.presetRecall(mChListFirstText - 1,mChListSecondText); // micom has index from 0 so it need to -1
                    }
                    else if(idAppMain.globalSelectedBand =="AM") {
                        if(QmlController.presetIndexAM == mChListFirstText){
                            console.log("---------------->AM Preset  index is same");
                            return;
                        }
                        QmlController.setPresetIndexAM(mChListFirstText);
                        QmlController.presetRecall(mChListFirstText - 1,mChListSecondText); // micom has index from 0 so it need to -1
                    }
                }
                /////////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////////
        }
        model : "" //PresetListAM //selectModel()
//        onCountChanged: {
//            console.log("=====================================>onCountChanged",idChListView.count,idAppMain.preset_Num);
//            //var prevIndex = idChListView.currentIndex // JSH jog focus (comment)
//            if(idChListView.count <idAppMain.preset_Num)
//                return;
////            if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
////                idChListView.currentIndex =  0; // Model Changed [Index No.1 Select]
////                changeState();
////            }
//        }
        onContentYChanged:{
            overContentCount = contentY/(contentHeight/count)
//            if(idAppMain.state == "AppRadioMain") // JSH jog focus (comment)
//                forceActiveFocus();
        }// for RoundScroll

        ///////////////////////////////////////////////////////////////////
        // JSH 130717 modify
        //        onFlickEnded: { // JSH 111117
        //            if(globalSelectedBand=="FM1")
        //                listPresetIndex = QmlController.getPresetIndexFM1()-1
        //            if(globalSelectedBand=="FM2")
        //                listPresetIndex = QmlController.getPresetIndexFM2()-1
        //            else if(globalSelectedBand=="AM")
        //                listPresetIndex = QmlController.getPresetIndexAM()-1

        //            flickStartTimer.restart()
        //            idAppMain.returnToTouchMode(); // JSH 130624

        //        }
        onMovementStarted: {flickStartTimer.stop();} // JSH 140123
        onMovementEnded: {
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

    //****************************** # ChannelList Background Image #
    Image{ // JSH 130706
        z: -1
        //source: showFocus && idRadioPresetListAM.activeFocus ? imgFolderGeneral+"bg_menu_l_s.png" : ""//imgFolderGeneral+"bg_ch_l_n.png"
        source: presetAndDialBackground == "PresetList" ? imgFolderGeneral+"bg_menu_l.png" : ""
    }

    Image{
        y: -9
        x: -4 // JSH 130706
        //source: showFocus && idRadioPresetListAM.activeFocus ? imgFolderGeneral+"bg_menu_l_s.png" : ""//imgFolderGeneral+"bg_ch_l_n.png"
        source: presetAndDialBackground == "PresetList" ? imgFolderGeneral+"bg_menu_l_s.png" : ""
    }

    /////////////////////////////////////////////////////
    // JSH flick
    Timer{
        id:flickStartTimer
        interval: 5000; running: false; repeat: false
        onTriggered:{
            if(listPresetIndex != idChListView.currentIndex)//if(listPresetIndex != (QmlController.getPresetIndex(QmlController.radioBand)-1))
                return;

            if(idChListView.isDragStarted)// JSH 131016 , isDragStarted == true
                return;

            if(listPresetIndex > 12) // JSH 140123
                return;

            changeListViewPosition(listPresetIndex);
        }
    }
    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 582; y: 198-systemInfo.upperAreaHeight
        moveBarPosition: idChListView.height/idChListView.count*overContentCount
        listCount: idChListView.count
    }

    //****************************** # Visual Cue #
    MComp.MVisualCue{
        id: idMVisualCue
        x: 560; y: 358-systemInfo.upperAreaHeight; z: 1
        //menuVisualCue: true
        arrowUpFlag: arrowUp
        arrowDownFlag: arrowDown
        arrowLeftFlag: arrowLeft
        arrowRightFlag: arrowRight
    }

    /////////////////////////////////////////////////////////////////
    // idRadioPresetListAM functions

    function selectModel() {
//        if(idAppMain.globalSelectedBand =="FM1") return PresetListFM1;
//        else if(idAppMain.globalSelectedBand =="FM2") return PresetListFM2;
//        else return PresetListAM;

        if(idAppMain.globalSelectedBand =="FM1"      && idAppMain.modelLoadOn) return PresetListFM1;//idAppMain.firstBootCheck) return PresetListFM1;
        else if(idAppMain.globalSelectedBand =="FM2" && idAppMain.modelLoadOn) return PresetListFM2;//idAppMain.firstBootCheck) return PresetListFM2;
        else if(idAppMain.globalSelectedBand =="AM"  && idAppMain.modelLoadOn) return PresetListAM; //idAppMain.firstBootCheck) return PresetListAM;
    }

    function changeListViewPosition(index){
        if(idAppMain.globalSelectedBand !="AM")
           return;
        if(index <= 5)
            idChListView.positionViewAtIndex(0, ListView.Beginning)
        else if(index > 5 && index < 12)
            idChListView.positionViewAtIndex(6, ListView.Beginning)
    }

    function changeState(){
        //idChListView.currentIndex = 0; // band change[presetindex == 0xFF] Preset No.1 select
        if(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)
            return;

        if(idAppMain.globalSelectedBand !="AM")
            return;

        if(idAppMain.globalSelectedBand =="AM"){
            if(QmlController.radioBand != 0x03)
                return;
            if((QmlController.presetIndexAM -1) < 0xF0){ // JSH Jog focus
                //idAppMain.alreadySaved  = 1 // JSH 121012 (alreadySaved) not used
                idChListView.currentIndex      = QmlController.presetIndexAM -1
                idRadioPresetListAM.selectedItem = QmlController.presetIndexAM -1
            }
            else{
                idAppMain.alreadySaved         = 0
                idRadioPresetListAM.selectedItem = QmlController.presetIndexAM
            }
        }

        //if((!idAppMain.doNotUpdate) && (idAppMain.state == "AppRadioMain" )){ // JSH 130706 deleted[focus bug]
        if((!idAppMain.doNotUpdate) && (idAppMain.state == "AppRadioMain" || (!idAppMain.globalMenuAnimation))){
            if(idRadioPresetListAM.selectedItem < 12)
                idRadioMain.jogFocusState =  "PresetList"
            else
                idRadioMain.jogFocusState =  "FrequencyDial"
        }

        if(!idAppMain.isTouchMode()) // JSH 130624
            changeListViewPosition(idChListView.currentIndex);

       console.log("=====>changeState(globalSelectedBand :: " , idAppMain.globalSelectedBand , "currentIndex :: ",idChListView.currentIndex,"selectedItem :: ",idRadioPresetListAM.selectedItem ,idRadioMain.jogFocusState )
    }

    /////////////////////////////////////////////////////////////////
    Connections{
        target: UIListener
        onSigGoFirstStation:{
        if(idAppMain.globalSelectedBand !="AM")
           return;
        //if(idAppMain.state == "AppRadioMain"){ // JSH 130910 added
        if(idAppMain.state == "AppRadioMain" && (!idChListView.isDragStarted)){  // JSH 131015 modify
                if( idChListView.currentIndex ){
                    idChListView.decrementCurrentIndex();
                    idChListView.ccpAccelerate = true
                    QmlController.setPresetIndex(QmlController.radioBand,idChListView.currentIndex+1);// JSH 130809 added
                }
            }
        }
        onSigGoLastStation:{
        //if(idAppMain.state == "AppRadioMain"){ // JSH 130910 added
        if(idAppMain.globalSelectedBand !="AM")
           return;
        if(idAppMain.state == "AppRadioMain" && (!idChListView.isDragStarted)){  // JSH 131015 modify
                if( idChListView.count-1 != idChListView.currentIndex ){
                    idChListView.incrementCurrentIndex();
                    idChListView.ccpAccelerate = true
                    QmlController.setPresetIndex(QmlController.radioBand,idChListView.currentIndex+1);// JSH 130809 added

                    //dg.jin 140530 Down Key Long Pressed VisualCueFocus
                    if(false == idAppMain.downKeyLongPressedVisualCueFocus) {
                        idAppMain.downKeyLongPressedVisualCueFocus = true; 
                    }
                }
            }
        }
        onSigGoFirstorLastStationTimerEnd:{ // 130822
            if(idAppMain.globalSelectedBand !="AM")
               return;
            //if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled)                                        // JSH 130910 deleted
            if((idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled) || (idAppMain.state != "AppRadioMain")) // JSH 130910 modify
                return;

            var index = QmlController.getPresetIndex(QmlController.radioBand);
            QmlController.setPresetIndex(QmlController.radioBand,0xFF);
            QmlController.setChannel(index);
            //// 2013.12.29 added by qutiguy - ITS 0210488
            idAppMain.checkVRStatus();
            ////
        }
    }
    Connections{
      target: QmlController
      onChangeIndexAM:{
        console.log("=========================>onChangeIndexAM")
        if(idAppMain.globalSelectedBand !="AM")
           return;
        //// 2013.12.05 modified by qutiguy : ITS 211952 211918 - donot change focus  while scaning.
        //changeState();
        if(!QmlController.searchState){
            changeState();
        }else{
            idAppMain.doNotUpdate = true
            changeState();
            idAppMain.doNotUpdate = false
            if((idRadioMain.jogFocusState == "PresetList") && (QmlController.getPresetIndex(QmlController.radioBand) > 12))
                idRadioMain.jogFocusState = "FrequencyDial";
        }
        ////
      }
// 2013.10.01 removed by qutiguy - duplicated
//      //added by qutiguy 0623 : update save icon when end of search
//      onChangeSearchState:{
//        console.log("=========================>signalSearchEnd")
//        changeState();
//      }
        //dg.jin 20140731 ITS 244683
        onChangePresetIndex:{
            if(idAppMain.globalSelectedBand !="AM")
               return;
            //console.log("+++++++++++onChangePresetIndex+++++++++++++++")
            if(((idAppMain.displayState == 0) || (idAppMain.displayState == 1)) && (QmlController.getAppState() == 2)){
                if(QmlController.getPresetIndex(QmlController.radioBand) > 12){
                    idRadioMain.jogFocusState = "FrequencyDial"
                }
                else{
                    idRadioMain.jogFocusState = "PresetList"
                }
            }
            changeListViewPosition(QmlController.getPresetIndex(QmlController.radioBand)-1);
            idAppMain.displayState = QmlController.getAppState();
        }
    }
    /////////////////////////////////////////////////////////////////
    //# focus change #JSH
    onActiveFocusChanged: { // JSH jog focus
        if(idAppMain.globalSelectedBand != "AM")
            return;

        console.log("========================> PresetList onActiveFocusChanged :: ",idRadioPresetListAM.activeFocus,idRadioMain.jogFocusState)
        if(idRadioMain.jogFocusState == "PresetList" && idAppMain.state == "AppRadioMain" && (!idRadioPresetListAM.activeFocus))
            focus = true;

        if(idRadioPresetListAM.activeFocus){
            if(!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled)){
                idAppMain.arrowUp   = true
                idAppMain.arrowDown = false
                idAppMain.arrowLeft = false
                idAppMain.arrowRight= true
            }
            else{
                idAppMain.arrowUp   = true
                idAppMain.arrowDown = false
                idAppMain.arrowLeft = false
                idAppMain.arrowRight= false
            }
            QmlController.setQmlFocusState(0); // JSH 121228
        }
    }

    function changeFocusIsDragItem(listmoving) {
        if(idAppMain.globalSelectedBand !="AM")
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

