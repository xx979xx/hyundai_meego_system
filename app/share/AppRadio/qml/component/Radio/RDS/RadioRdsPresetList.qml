/**
 * FileName: RadioRdsPresetList.qml
 * Author: HYANG
 * Time: 2012-06
 *
 * - 2012-06 Initial Created by HYANG
 * - 140115 seek up/down enabled rooping. by KSW
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp


MComp.MComponent {
    id: idRadioRdsPresetList
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight-systemInfo.titleAreaHeight+systemInfo.contentTopMargin
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }
    /////////////////////////////////////////////////////////////////

    //--------------------- Timer Info(Property) #
    property int timerCount : 1;
    property int timerMaxCount : 15;
    property bool bMaualTune : false; //KSW 131230-3 ITS/217596
    property bool bMaualTunePress : false; //dg.jin 20141007 band tune press issue
    signal signalClosePresetListView();
    signal signalRestartTimerPresetList();

    Timer{
        id : idRDSPresetListViewTimer
        interval: 1000
        repeat: true;

        onTriggered:{
            if(timerCount == timerMaxCount){
                finishTimer();
                return;
            }
            timerCount++;
            console.log(" [RadioRdsPresetList][idRDSPresetListViewTimer][onTriggered] " + timerCount);

        }
        function startTimer()
        {
            timerCount = 1;
            idRDSPresetListViewTimer.restart()
        }
        function finishTimer()
        {
            idRDSPresetListViewTimer.stop()
            signalClosePresetListView();
        }
        function resetTimer(){
            timerCount = 1;
        }
    } // End Timer

    //--------------------- Visible change(Function) #
    onVisibleChanged: {
        console.log(" [RadioRdsPresetList][idRadioRdsPresetList][onVisibleChanged] " + idRadioRdsPresetList.visible)
        console.log(" [RadioRdsPresetList][idRadioRdsPresetList][onVisibleChanged] selectedIndex = " + idRadioRdsPreset.selectedIndex)
        if(visible) {
            if((idRadioRdsPreset.selectedIndex < 0) || (idRadioRdsPreset.selectedIndex > 11))
                //KSW 131224 ITS/217054
                if(b_presetsavemode == true)
                {
                    idRadioRdsPreset.forceActiveFocus();
                    idRadioRdsPreset.updateCurrentIndex(0);
                }
                else
                    idMBand.forceActiveFocus();
            else{
                idRadioRdsPreset.forceActiveFocus();
                idRadioRdsPreset.updateCurrentIndex(idRadioRdsPreset.selectedIndex);
                idRadioRdsPresetList.focus = true
            }
            //KSW 140515-1
            if(b_presetsavemode != true)
                idRDSPresetListViewTimer.startTimer()
        }
        else {
            idRDSPresetListViewTimer.stop()
        }
    }
    //--------------------- Focus change(Function) #
    onActiveFocusChanged: {
        console.log(" [RadioRdsPresetList][idRadioRdsPresetList][onActiveFocusChanged] " )
        if(activeFocus)
        {
            //KSW 140515-1
            if(b_presetsavemode != true)
                idRDSPresetListViewTimer.startTimer()
        }
        else { idRDSPresetListViewTimer.stop() }
    }
    onSignalRestartTimerPresetList:
    {
        //KSW 140515-1
        if(b_presetsavemode != true)
            idRDSPresetListViewTimer.startTimer()
    }
    onAnyKeyReleased:
    {
        //KSW 140515-1
        if(b_presetsavemode != true)
            idRDSPresetListViewTimer.startTimer()
    }
    onSignalClosePresetListView:{
        if(idAppMain.state == "AppRadioRdsPresetList")
            gotoBackScreen();
    }

    Connections{
        target: QmlController
        //////////////////////////////////////////////////////////////////////////////////////
        // 120927 JSH
        onChangeSearchState: {
            console.log(" HJIGKS: [idRadioRdsPreset] onChangeSearchState value :" + value + idRadioRdsPreset.requestStopSearch);
            console.log(" HJIGKS: [idRadioRdsPreset] onChangeSearchState value :" + value + idRadioRdsPreset.requestStopSearchReplace);
            if( value == 0 && idRadioRdsPreset.requestStopSearch == true )
            {
                idRadioRdsPreset.requestStopSearch = false;
                //idRadioRdsPreset.currentIndex = idChListView.requestStopIndex;
                idRadioRdsPreset.presetItemClickedFunction();
                signalRestartTimerPresetList();
            }
            else if( value == 0 && idRadioRdsPreset.requestStopSearchReplace == true )
            {
                idRadioRdsPreset.requestStopSearchReplace = false;
                //idRadioRdsPreset.currentIndex = idChListView.requestStopIndex;
                idRadioRdsPreset.presetItemPressAndHoldFunction();
                signalRestartTimerPresetList();
            }
        }
        //////////////////////////////////////////////////////////////////////////////////////
        onChannelChanged:{
            console.log(" [idRadioRdsPreset] onChannelChanged mode :" + index + freq );
            if(idRadioRdsPresetList.visible)
                signalRestartTimerPresetList();
//            idRadioRdsPreset.requestStopSearch = true;
//            idRadioRdsPreset.requestStopIndex  = index;
//            idRadioRdsPreset.channelChangedFreq = freq;
//0512            idRadioRdsPreset.currentIndex = index;
//0512            idRadioRdsPreset.currentIndex = index -1;
//            signalRestartTimerPresetList();
        }

        //KSW 131029[ITS][195955][comment]
        onChangeIndexFM1:{ // preset list highlight
            console.log("=========================>onChangeIndexFM1, index =", index);
            if(idAppMain.state != "AppRadioRdsPresetList")
                return ;
            if(index > 0 && index < 13)
                idRadioRdsPreset.updateCurrentIndex(index-1);
            else
                console.log("=========================>escape index range!");
        }
        onChangeIndexAM:{
            console.log("=========================>onChangeIndexAM, index =", index);
            if(idAppMain.state != "AppRadioRdsPresetList")
                return ;
            if(index > 0 && index < 13)
                idRadioRdsPreset.updateCurrentIndex(index-1);
            else
                console.log("=========================>escape index range!");
        }
        //KSW 131108 [ITS][207621][minor]
        onChangePresetListFocus:{
            console.log("=========================>onChangePresetListFocus, nPresetListInx =", nPresetListInx);
            if(idAppMain.state != "AppRadioRdsPresetList")
                return ;
            if(nPresetListInx > 0 && nPresetListInx < 13)
            {
                idRadioRdsPreset.updateCurrentIndex(nPresetListInx-1);
                forceActiveFocus();
            }
            else
                console.log("=========================>escape index range!");
        }
    }
    property string imgFolderRadio_Dab : imageInfo.imgFolderRadio_Dab
    property string imgFolderSettings: imageInfo.imgFolderSettings

    //****************************** # ChannelList Background Image #
//20130204 change bg image.
//    Image{ source: imgFolderGeneral+"bg_type_a.png"}
    //KSW 140120 for KH
    Image{
         x: 0; y: -systemInfo.statusBarHeight
         source: imgFolderGeneral+"bg_main.png"
    }

    //****************************** # Preset List #
    MComp.MPreset {
        id: idRadioRdsPreset
        selectedIndex: (currentPresetIndex > 12)?-1:currentPresetIndex-1;

        //////////////////////////////////////////////////////
        // 120927 JSH
        property bool   requestStopSearch       : false
        property bool   requestStopSearchReplace: false
        property int    requestStopIndex        : -1
        property bool   islastIndex : false //[0182929][EU][ITS][comment] KSW fixed focus error

        function presetItemClickedFunction(){
            console.log("[RDS:PRESET] presetItemClickedFunction()")
            console.log("[RDS:PRESET] currentIndex  =  " + currentIndex );
            console.log("[RDS:PRESET] currentPresetIndex  =  " + currentPresetIndex );
            console.log("[RDS:PRESET] b_presetsavemode  =  " + b_presetsavemode );
            console.log("[RDS:PRESET] globalSelectedBand  =  " + globalSelectedBand );

            //dg.jin 20141007 System popup hide
            if(idAppMain.systemPopupShow == true)
            {
                UIListener.handleSystemPopupClose();
            }
            
            if(b_presetsavemode == true){
                QmlController.presetReplace(currentIndex,QmlController.radioFreq);
                //KSW 130731 for premium UX
                QmlController.presetListUpdate((globalSelectedBand == 0x01)? 1 : 2, /*FM : AM*/
                                               (globalSelectedBand == 0x01)? QmlController.radioFreq * 100 : QmlController.radioFreq,
                                                currentIndex); // band, freq, index//KSW PQ issue 131119-1
//20130111 added by qutiguy - fixed a defect wrong current index after saving preset
                idRadioRdsPreset.updateCurrentIndex(currentIndex - 1);
                forceActiveFocus();
//0512                b_presetsavemode = false;
                setAppMainScreen( "PopupRadioRdsSaved" , true);
            }
            else{
                if(globalSelectedBand == 0x01){
                    globalSelectedFmFrequency = currentItem.presetItemFrequency;
                    QmlController.setPresetIndexFM1(currentIndex + 1);
                    //KSW 130731 for premium UX
                    QmlController.presetListUpdate(1/*FM*/, globalSelectedFmFrequency * 100, currentIndex); // band, freq, index
                }
                else{
                    globalSelectedAmFrequency = currentItem.presetItemFrequency;
                    QmlController.setPresetIndexAM(currentIndex + 1);
                    //KSW 130731 for premium UX
                    QmlController.presetListUpdate(2/*AM*/, globalSelectedAmFrequency, currentIndex); // band, freq, index
                }
                QmlController.presetRecall(currentIndex, currentItem.presetItemFrequency, currentItem.presetItemPSName,currentItem.presetItemPTYType, currentItem.presetItemPICOCE );
//// 20130512 modified by qutiguy - return only recall mode.
                gotoBackScreen() ;
            }
        }

        function presetItemPressAndHoldFunction(){
// 20130301 removed by qutiguy - fixed defect to show wrong preset list bg image
//            if(currentPresetIndex == currentIndex + 1){ //skip when duplicated
//                gotoBackScreen();
//                return;
//            }
              //dg.jin 20141007 System popup hide
              if(idAppMain.systemPopupShow == true)
              {
                  UIListener.handleSystemPopupClose();
              }
              
            islastIndex = (currentIndex == 11)? true : false; //[0182929][EU][ITS][comment] KSW fixed focus error
            QmlController.presetReplace(currentIndex, QmlController.radioFreq);
            //KSW 130731 for premium UX
            QmlController.presetListUpdate((globalSelectedBand == 0x01)? 1 : 2, /*FM : AM*/
                                           (globalSelectedBand == 0x01)? QmlController.radioFreq * 100 : QmlController.radioFreq,
                                           islastIndex ? 11 : currentIndex); // band, freq, index //[0182929][EU][ITS][comment] KSW fixed focus error
            //KSW 131104 [ITS][206299][minor] preset index bar error(currentIndex-1 -> currentIndex)
			//20130111 added by qutiguy - fixed a defect wrong current index after saving preset
            //KSW 131103 fexed focus error, case current playing freq
            if(idRadioRdsPreset.selectedIndex == currentIndex - 1)
                idRadioRdsPreset.updateCurrentIndex(currentIndex - 1);
            else if(islastIndex == true)
                idRadioRdsPreset.updateCurrentIndex(11); //131104 KSW fixed focus error

            //KSW 131101 fixed about 195955 issue
            forceActiveFocus();
//// 20130528 removed by qutiguy - replace and stay in presetlist.
//            gotoBackScreen() ;
        }

        //////////////////////////////////////////////////////
        //////////////////////////////////////////////////////

        onPresetItemClicked: {

            console.log("[idRadioRdsPreset_onPresetItemClicked]",idRadioRdsPreset.requestStopSearch)
            //////////////////////////////////////////////////////
            // 120927 JSH
            if( idRadioRdsPreset.requestStopSearch )
            {
              //idRadioRdsPreset.requestStopIndex = index;
              return;
            }
            if( QmlController.searchState )
            {
              idRadioRdsPreset.requestStopSearch = true;
              //idRadioRdsPreset.requestStopIndex = index;
              QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
              QmlController.seekstop();
              return;
            }
            //////////////////////////////////////////////////////

            presetItemClickedFunction();
        }
        onPresetItemPressAndHold: {
            //////////////////////////////////////////////////////
            // 120927 JSH
            console.log("[onPresetItemPressAndHold]",idRadioRdsPreset.requestStopSearchReplace)
            if( idRadioRdsPreset.requestStopSearchReplace )
            {
                //idRadioRdsPresetrequestStopIndex = index;
                return;
            }
            if( QmlController.searchState )
            {
                idRadioRdsPreset.requestStopSearchReplace = true;
                //idRadioRdsPresetrequestStopIndex = index;
                QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                QmlController.seekstop();
                return;
            }
            //////////////////////////////////////////////////////
            if(b_presetsavemode != true)
            {
                presetItemPressAndHoldFunction();
                 //dg.jin 20141103 ITS 251755 presetlist longpress beep
                // UIListener.writeToLogFile("playBeep check");
                if(beepplay == true)
                {
                    //UIListener.writeToLogFile("playBeep");
                    idAppMain.playBeep();
                }
            }
        }

        presetModel: globalSelectedBand == 0x01?PresetListFM1:PresetListAM;

        Component.onCompleted : {
            console.log("[Component.onCompleted] selectedIndex = ", selectedIndex);
            if(selectedIndex < 0)
                idMBand.forceActiveFocus();
            else{
                idRadioRdsPreset.forceActiveFocus();
                idRadioRdsPreset.updateCurrentIndex(idRadioRdsPreset.selectedIndex);
            }

        }

        KeyNavigation.up: idMBand

        //dg.jin 20141013 list osd start
        //Keys.onPressed: {
        //    switch(event.key){
                //****************************** # Wheel in GridView #
        //       case Qt.Key_Semicolon:{
        //            if(currentItem.buttonName == selectedIndex)
        //            {
        //                UIListener.sendDataToOSDInfo(currentItem.presetItemFrequency, currentItem.presetItemPSName, false);
        //            }
        //            else
        //            {
        //                UIListener.sendDataToOSDInfo(currentItem.presetItemFrequency, currentItem.presetItemPSName, true);
        //            }
        //            break;
        //        }

        //        case Qt.Key_Apostrophe:{
        //            if(currentItem.buttonName == selectedIndex)
        //            {
        //                UIListener.sendDataToOSDInfo(currentItem.presetItemFrequency, currentItem.presetItemPSName, false);
        //            }
        //            else
        //            {
        //                UIListener.sendDataToOSDInfo(currentItem.presetItemFrequency, currentItem.presetItemPSName, true);
        //            }
        //            break;
        //        }
        //    }
        //}
        //dg.jin 20141013 list osd end
    }

    //****************************** # Title Band #
    MComp.MBand{
        id: idMBand
        x: 0; y: 0

        titleText: b_presetsavemode==true?stringInfo.strRDSLabelPresetSelectNumber:stringInfo.strRDSLabelPreset
        menuBtnFlag: false
        tunePress: bMaualTunePress //dg.jin 20141007 band tune press issue

        onBackBtnClicked: { b_presetsavemode = false; gotoBackScreen() }

        KeyNavigation.down: idRadioRdsPreset

        //KSW 131230-2 ITS/217601
        Keys.onPressed: {
            if(bMaualTune != true)
            {
                console.log("=========================>key bypass");
                return;
            }
            switch(event.key){
                case Qt.Key_Semicolon:{
                    //console.log("=========================>Key_Semicolon");
                    idRadioRdsPreset.forceActiveFocus();
                    break;
                }
                case Qt.Key_Apostrophe:{
                    //console.log("=========================>Key_Apostrophe");
                    idRadioRdsPreset.forceActiveFocus();
                    break;
                }
                default:
                    break;
            }
        }
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        gotoBackScreen();
    }
//// 20130512 added by qutiguy - slots.
    Connections{
        target: UIListener
        onSigGoFirstStation:{
            console.log("[[[[[[[[ PresetList::onSigGoFirstStation ]]]]]]]]");
            if(UIListener.VIEWSTATE != 2) //         VIEW_PRESETLIST, //2
                return;
            idRadioRdsPreset.decreaseCurrentIndex();
            //KSW 140515-1
            if(b_presetsavemode != true)
                idRDSPresetListViewTimer.startTimer();
        }
        onSigGoLastStation:{
            console.log("[[[[[[[[ PresetList::onSigGoLastStation ]]]]]]]]");
            if(UIListener.VIEWSTATE != 2) //         VIEW_PRESETLIST, //2
                return;
            idRadioRdsPreset.increaseCurrentIndex();
            //KSW 140515-1
            if(b_presetsavemode != true)
                idRDSPresetListViewTimer.startTimer();
        }
        onSigPlayStation:{
            console.log("[[[[[[[[ PresetList::onSigPlayStation = PresetList]]]]]]]]" );
            if(UIListener.VIEWSTATE == 2) //VIEW_PRESETLIST
            {
                if(idRadioRdsPreset.focus == true)//KSW 131108 [ITS][207899][minor]
                    idRadioRdsPreset.currentItem.clickOrKeySelected(0);
                else
                    console.log("onSigPlayStation is return, this item is backKey");
            }
        }
        onSignalRDSSEEKNext:{
            console.log("[[[[[[[[ PresetList::onSignalRDSSEEKNext = ]]]]]]]]" + mode);
            if(UIListener.VIEWSTATE == 2) //VIEW_PRESETLIST
            {
                //KSW 140113-1 ITS/219475
                if(b_presetsavemode == true)
                {
                    console.log("[[[[[[[[ PresetList::returned because saveAsPreset mode = " + b_presetsavemode);
                    gotoBackScreen();
                    return;
                }

                if(mode == 0){ //SEEK
                    idRadioRdsPreset.forceActiveFocus();
//                    if(idRadioRdsPreset.selectedIndex == 0) //KSW 140115
//                        return;
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.changeChannel(0) //down
                    idRadioRdsPreset.updateCurrentIndex(idRadioRdsPreset.selectedIndex);
                }
                //KSW 140513 When long seek key pressed, It resolved does not move focus at focus on back key in presetlist
                else if(mode == 1){
                    idRadioRdsPreset.forceActiveFocus();
                    if(currentPresetIndex > 12 || currentPresetIndex < 1)
                    {
                        idRadioRdsPreset.updateCurrentIndex(0);
                    }
                }
                else if(mode == 3){ //SEEK LONG RELEASE
                    QmlController.changeChannelWhileSearch(idRadioRdsPreset.currentIndex + 1);
                }
            }
        }
        onSignalRDSSEEKPrev:{
            console.log("[[[[[[[[ PresetList::onSignalRDSSEEKPrev = ]]]]]]]]" + mode);
            if(UIListener.VIEWSTATE == 2) //VIEW_PRESETLIST
            {
                //KSW 140113-1 ITS/219475
                if(b_presetsavemode == true)
                {
                    console.log("[[[[[[[[ PresetList::returned because saveAsPreset mode = " + b_presetsavemode);
                    gotoBackScreen();
                    return;
                }
                if(mode == 0){//SEEK
                    idRadioRdsPreset.forceActiveFocus();
//                    if(idRadioRdsPreset.selectedIndex == 11) //KSW 140115
//                        return;
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.changeChannel(1) //up
                    idRadioRdsPreset.updateCurrentIndex(idRadioRdsPreset.selectedIndex);
                }
                //KSW 140513 When long seek key pressed, It resolved does not move focus at focus on back key in presetlist
                else if(mode == 1){
                    idRadioRdsPreset.forceActiveFocus();
                    if(currentPresetIndex > 12 || currentPresetIndex < 1)
                    {
                        idRadioRdsPreset.updateCurrentIndex(0);
                    }
                }
                else if(mode == 3){ //SEEK LONG RELEASE
                    QmlController.changeChannelWhileSearch(idRadioRdsPreset.currentIndex + 1);
                }
            }
        }
        onSignalRDSSWRCNext:{
            console.log("[[[[[[[[ PresetList::onSignalRDSSWRCNext = ]]]]]]]]" + mode);
            if(UIListener.VIEWSTATE == 2) //VIEW_PRESETLIST
            {
                //KSW 140113-1 ITS/219475
                if(b_presetsavemode == true)
                {
                    console.log("[[[[[[[[ PresetList::returned because saveAsPreset mode = " + b_presetsavemode);
                    gotoBackScreen();
                    return;
                }

                if(mode == 0){//SEEK
                    idRadioRdsPreset.forceActiveFocus();
//                    if(idRadioRdsPreset.selectedIndex == 0) //KSW 140115
//                        return;
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.changeChannel(0) //down
                    idRadioRdsPreset.updateCurrentIndex(idRadioRdsPreset.selectedIndex);
                }else if(mode == 3){ //SEEK LONG RELEASE
                    QmlController.changeChannelWhileSearch(idRadioRdsPreset.currentIndex + 1);
                }
            }
        }
        onSignalRDSSWRCPrev:{
            console.log("[[[[[[[[ PresetList::onSignalRDSSWRCPrev = ]]]]]]]]" + mode);
            if(UIListener.VIEWSTATE == 2) //VIEW_PRESETLIST
            {
                //KSW 140113-1 ITS/219475
                if(b_presetsavemode == true)
                {
                    console.log("[[[[[[[[ PresetList::returned because saveAsPreset mode = " + b_presetsavemode);
                    gotoBackScreen();
                    return;
                }

                if(mode == 0){//SEEK
                    idRadioRdsPreset.forceActiveFocus();
//                    if(idRadioRdsPreset.selectedIndex == 11) //KSW 140115
//                        return;
                    QmlController.setIsTpSearching(false); //KSW 131007 no search tp station popup
                    QmlController.changeChannel(1) //up
                    idRadioRdsPreset.updateCurrentIndex(idRadioRdsPreset.selectedIndex);
                }else if(mode == 3){ //SEEK LONG RELEASE
                    QmlController.changeChannelWhileSearch(idRadioRdsPreset.currentIndex + 1);
                }
            }
        }

        //KSW 131230-3 ITS/217596
        onSignalIsManualTune: {
            console.log(" [PresetList][idRadioRdsPresetList][onSignalIsManualTune] "+bIsManualTune )
            bMaualTune = bIsManualTune;
        }

        //dg.jin 20141007 band tune press issue
        onSignalIsManualTunePress: {
            bMaualTunePress = bIsManualTunePress;
        }     
    }
////
}
