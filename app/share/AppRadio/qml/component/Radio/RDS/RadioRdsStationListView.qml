/**
 * FileName: RadioRdsStationListView.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 * - 140115 seek up/down enabled rooping by KSW
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioRdsStationListView
    x: 0; y: 0
    width: systemInfo.lcdWidth;
// 20121205 modified by qutiguy - fixed StationList position defects
//    height: systemInfo.subMainHeight-systemInfo.titleAreaHeight+systemInfo.contentTopMargin
//20121214 modified by qutiguy - height = delegate height * count
//    height:systemInfo.subMainHeight-systemInfo.titleAreaHeight
    height: 90 * 6


    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    property int modelTotCount: idFullListView.count
    property int modelCurCount: idFullListView.currentIndex+1    

    property int selectedIndex : 0

    Connections{
        target: idAppMain
        onInitStationList:{
            console.log(" on handler ////////////////////////////////////////////// complete station list");
            initStationListView();
        }
    }
    //////////// 2013.11.11 added by qutiguy  - EU ITS 0207136: to simulate on desktop.
    //dg.jin 20150622 ITS 0264654 Station list jog right left event remove
    //signal signalRight(int mode);
    //signal signalLeft(int mode);
    //onSignalRight:
    //{
    //     console.log("[[[[[[[[ StationList::onSignalRight = ]]]]]]]]" + mode);
    //    if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
    //    {
    //        if(mode == 0){ //SEEK
    //            moveStationList(-1)
    //        }else if(mode == 3){ //SEEK LONG RELEASE
    //            selectedIndex = idFullListView.currentIndex;
    //            idFullListView.currentItem.playStationItem();
     //       }
      //  }
    //}
    //onSignalLeft:
    //{
    //    console.log("[[[[[[[[ StationList::onSignalLeft = ]]]]]]]]" + mode);
    //    if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
    //    {
    //        if(mode == 0){ //SEEK
     //           moveStationList(1)
     //       }else if(mode == 3){ //SEEK LONG RELEASE
      //          selectedIndex = idFullListView.currentIndex;
      //          idFullListView.currentItem.playStationItem();
      //      }
     //   }
    //}
    ////////////

    //// 2013.11.11 added by qutiguy - EU ITS 0207136: create signalWeelUp/Down
    signal signalWheelUp();
    signal signalWheelDn();

    onSignalWheelUp:{
        console.log("[[[[[[[[ StationList::onSignalWheelUp ]]]]]]]]");
        if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
        {
            if( idFullListView.currentIndex ){
                idFullListView.decrementCurrentIndex();
            }
            else if( 6 < idFullListView.count ){ // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS
                idFullListView.positionViewAtIndex(idFullListView.count-1, idFullListView.Visible);
                idFullListView.currentIndex = idFullListView.count-1;
            }
            setPageofList();
        }
    } // end onSignalWheelUp


    onSignalWheelDn:{
        console.log("[[[[[[[[ StationList::onSignalWheelUp ]]]]]]]]");
        if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
        {
            if( idFullListView.count-1 != idFullListView.currentIndex ){
                idFullListView.incrementCurrentIndex();
            }
            else if( 6 < idFullListView.count ){ // KSW 130715 [ITS][176658] Station/Preset list looping issue fixed to RDS
                idFullListView.positionViewAtIndex(0, ListView.Visible);
                idFullListView.currentIndex = 0;
            }
            setPageofList();
        }
    } // end onSignalWheelDn
    ////

    function initStationListView(){

        var listcount;
        listcount = idFullListView.count;
        console.log("[[[[[[ Begin initStationListView ]]]]]]");
        console.log("[[[[[[ listcount = ]]]]]]",listcount);

        for (var i = 0; i < listcount; i++){
            idFullListView.currentIndex = i;
//            console.log("[[[[[[ i = ]]]]]]",i);
//            console.log("[[[[[[ idFullListView.currentItem.StringFreq = ]]]]]]",idFullListView.currentItem.strFreq);
//            console.log("[[[[[[ idFullListView.currentItem.StationName = ]]]]]]",idFullListView.currentItem.strName);
//            console.log("[[[[[[ idFullListView.currentItem.intFreq = ]]]]]]",idFullListView.currentItem.intFreq);
//            console.log("[[[[[[ idFullListView.currentItem.realPICODE = ]]]]]]",idFullListView.currentItem.realPICODE);
//            console.log("[[[[[[ idFullListView.currentItem.strPty = ]]]]]]",idFullListView.currentItem.strPty);
            if(globalSelectedBand == 0x01){
//20121211 modified by qutiguy - check current station.
//                if(((globalSelectedFmFrequency)*100 == idFullListView.currentItem.intFreq ) && (QmlController.picode == idFullListView.currentItem.realPICODE)){
//                    console.log("FM frequency is same here =>", i);
//                    selectedIndex = i;
//                    idFullListView.currentIndex = selectedIndex;
//                    return;
//                }

                if(QmlController.picode != 0){
                    if (QmlController.picode == idFullListView.currentItem.realPICODE){
                        console.log("picode is same here =>", i);
                        selectedIndex = i;
                        idFullListView.positionViewAtIndex(selectedIndex, ListView.Center); // 2013.10.30 DaehyungE ITS 204954
//                        idFullListView.currentIndex = selectedIndex;
                        return;
                    }
                }else{
                    if((globalSelectedFmFrequency)*100 == idFullListView.currentItem.intFreq){
                        console.log("FM frequency is same here =>", i);
                        selectedIndex = i;
                        idFullListView.positionViewAtIndex(selectedIndex, ListView.Center); // 2013.10.30 DaehyungE ITS 204954
//                        idFullListView.currentIndex = selectedIndex;
                        return;
                    }
                }
            }
            if(globalSelectedBand == 0x03){
                if(globalSelectedAmFrequency == idFullListView.currentItem.intFreq){
                    console.log("AM frequency is same here =>", i);
                    selectedIndex = i;
                    idFullListView.positionViewAtIndex(selectedIndex, ListView.Center); // 2013.10.30 DaehyungE ITS 204954
//                    idFullListView.currentIndex = selectedIndex;
                    return;
                }
            }
        }
        //KSW 131116-1 [ITS][208742][minor]
        if(globalSelectedBand == 0x01){
            console.log("force selected list item : cur FM frequency  =>", globalSelectedFmFrequency);
            selectedIndex = listcount-1;
            idFullListView.positionViewAtIndex(selectedIndex, ListView.Center);
        }

    }
//// 20130513 added by qutiguy - 
    function moveStationList(direction){
        signalRestartTimerStationList();
        if(idFullListView.count < 2)
            return;
        if (direction > 0){
            if (selectedIndex < (idFullListView.count-1)){
                selectedIndex += 1;
            }
            else{
                //KSW 140115
//                if(idFullListView.count < 7)
//                    return;
//                else
                    selectedIndex = 0
            }
        }else{
            if (selectedIndex <= 0){
                //KSW 140115
//                if(idFullListView.count < 7)
//                    return;
//                else
                    selectedIndex = (idFullListView.count -1);
            }
            else{
                selectedIndex -= 1;
            }
        }
        idFullListView.currentIndex = selectedIndex;
        idFullListView.currentItem.playStationItem();
    //// 2013.11.11 added by qutiguy - EU ITS 0207136: Page Movement in the station list
        setPageofList();
     ////
    }

    //// 2013.11.11 added by qutiguy - EU ITS 0207136: Page Movement in the station list
    function setPageofList(){
//// 2013.11.13 update by qutiguy : Change the rule of moving the page
/*
        var n_currentIndex;
        var n_selectedIndex;
        var n_totalListCount;
        var n_currentPageIndex;
        var n_totalPageIndex;
        var n_modIndex;
        var n_onePageCount = 6;

        n_currentIndex = idFullListView.currentIndex //idRadioRdsStationListView.modelCurCount;
        n_selectedIndex = idFullListView.selectedIndex;
        n_totalListCount = idFullListView.count;
        n_currentPageIndex =  parseInt(n_currentIndex / n_onePageCount);
        n_totalPageIndex = parseInt(n_totalListCount / n_onePageCount);
        n_modIndex = parseInt(n_totalListCount % n_onePageCount);

        console.log(" [CHECK_11_11_QML_STATIONLIST] " +
                    "n_currentIndex = " + n_currentIndex +
                    " n_selectedIndex = " + n_selectedIndex +
                    " n_totalListCount = " + n_totalListCount +
                    " n_currentPageIndex = " + n_currentPageIndex +
                    " n_totalPageIndex = " + n_totalPageIndex +
                    " n_modIndex = " + n_modIndex
                    )
        if(n_currentPageIndex < 1 ){  // first page
            idFullListView.positionViewAtIndex( 0 , ListView.Beginning)
        }else if(n_totalPageIndex == n_currentPageIndex){ //last page
            idFullListView.positionViewAtIndex( n_totalListCount - n_onePageCount , ListView.Beginning)
        }else{
            idFullListView.positionViewAtIndex( n_currentPageIndex * n_onePageCount, ListView.Beginning)
        }
*/
        //
        var n_currentIndex;

        var n_totalListCount;
        var n_onePageCount = 6;

        var n_begineIndex;
        var n_endIndex;

        n_currentIndex = idFullListView.currentIndex;
        n_totalListCount = idFullListView.count;
        console.log("[CHECH_11_13_POSITION] n_currentIndex = " + n_currentIndex);

        n_begineIndex = idFullListView.indexAt(300, idFullListView.contentY+85);
        console.log("[CHECH_11_13_POSITION] n_begineIndex = " + n_begineIndex);

        n_endIndex = idFullListView.indexAt(300, idFullListView.contentY + (85*n_onePageCount));
        console.log("[CHECH_11_13_POSITION] n_endIndex = " + n_endIndex);

        if(n_currentIndex < n_onePageCount)
            idFullListView.positionViewAtIndex( 0 , ListView.Beginning)
        else if(n_currentIndex >= (n_totalListCount - n_onePageCount))
            idFullListView.positionViewAtIndex( n_totalListCount - n_onePageCount , ListView.Beginning)
        else if(n_currentIndex < n_begineIndex)
            idFullListView.positionViewAtIndex( n_currentIndex,  ListView.End);
        else if(n_currentIndex > n_endIndex)
            idFullListView.positionViewAtIndex( n_currentIndex, ListView.Beginning);
        //
    }
    ////

    RadioRdsStationListModel {id: stationListFM}

    //****************************** # ListView #
    ListView{
        id: idFullListView
        y: systemInfo.titleAreaHeight
        clip: true
        focus: true
        anchors.fill: parent;
        orientation: ListView.Vertical
        highlightMoveSpeed: 99999
//20121129 added by qutiguy - Set cacheBuffer size to prevent displaying error.
        cacheBuffer : 90 * 50
        snapMode: ListView.SnapToItem

        Component.onCompleted: {
            console.log("[[[[[[ idFullListView Component.onCompleted ]]]]]]");
        }
        onActiveFocusChanged: {
            console.log("[[[[[[ idFullListView onActiveFocusChanged ]]]]]]", idFullListView.activeFocus);
        }
        onFocusChanged: {
            console.log("[[[[[[ idFullListView onFocusChanged ]]]]]]", idFullListView.focus);
        }
        onVisibleChanged: {
            console.log("[[[[[[ idFullListView onVisibleChanged ]]]]]]", idFullListView.visible);
        }
        onMovementStarted: {
            console.log("[[[[[[ idFullListView onMovementStarted ]]]]]]");
        }
//// 2013.11.13 added by qutiguy - Implement Common rules :  Focus movement when page chaged with flick
        onMovementEnded: {
            console.log("[[[[[[ idFullListView onMovementEnded ]]]]]]");
            var point = mapFromItem(currentItem, 0, 0);
            if(point.y+85 < 0 || point.y+85 > idFullListView.height)
                currentIndex = indexAt(300, contentY+85);
        }
////
        Connections{
            target: UIListener
            onSigGoFirstStation:{
                console.log("[[[[[[[[ StationList::onSigGoFirstStation ]]]]]]]]");
                if(UIListener.VIEWSTATE != 3) //         VIEW_STATIONLIST, //3
                    return;
                if( idFullListView.currentIndex ){
                    idFullListView.decrementCurrentIndex();
                }
                //KSW 131230-1 ITS/217597 del looping
//                else if(6 < idFullListView.count){      //Looping check
//                        idFullListView.positionViewAtIndex(idFullListView.count - 1, ListView.Visible);
//                        idFullListView.currentIndex = idFullListView.count -1;
//                }
//20130107 added by qutiguy - station list view 30' limited show
                signalRestartTimerStationList();
            }
            onSigGoLastStation:{
                console.log("[[[[[[[[ StationList::onSigGoLastStation ]]]]]]]]");
                if(UIListener.VIEWSTATE != 3) //         VIEW_STATIONLIST, //3
                    return;
                if( idFullListView.count-1 != idFullListView.currentIndex ){
                    idFullListView.incrementCurrentIndex();
                }
                //KSW 131230-1 ITS/217597 del looping
//                else if( 6 < idFullListView.count){     //Looping check
//                        idFullListView.positionViewAtIndex(0, ListView.Visible);
//                        idFullListView.currentIndex = 0;
//                }
//20130107 added by qutiguy - station list view 30' limited show
                signalRestartTimerStationList();
            }
//// 20130513 added by qutiguy - slots
            onSignalRDSSEEKNext:{
                console.log("[[[[[[[[ StationList::onSignalRDSSEEKNext = ]]]]]]]]" + mode);
                if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
                {
                    if(mode == 0){ //SEEK
                        moveStationList(-1)
                    }else if(mode == 3){ //SEEK LONG RELEASE
			selectedIndex = idFullListView.currentIndex;
                        idFullListView.currentItem.playStationItem();
                    }
                }
            }
            onSignalRDSSEEKPrev:{
                console.log("[[[[[[[[ StationList::onSignalRDSSEEKPrev = ]]]]]]]]" + mode);
                if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
                {
                    if(mode == 0){ //SEEK
                        moveStationList(1)
                    }else if(mode == 3){ //SEEK LONG RELEASE
			selectedIndex = idFullListView.currentIndex;
                        idFullListView.currentItem.playStationItem();
                    }
                }
            }
            onSignalRDSSWRCNext:{
                console.log("[[[[[[[[ StationList::onSignalRDSSWRCNext = ]]]]]]]]" + mode);
                if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
                {
                    if(mode == 0){ //SEEK
                        moveStationList(-1)
                    }else if(mode == 3){ //SEEK LONG RELEASE
		    	selectedIndex = idFullListView.currentIndex;
                        idFullListView.currentItem.playStationItem();
                    }
                }
            }
            onSignalRDSSWRCPrev:{
                console.log("[[[[[[[[ StationList::onSignalRDSSWRCPrev = ]]]]]]]]" + mode);
                if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
                {
                    if(mode == 0){ //SEEK
                        moveStationList(1)
                    }else if(mode == 3){ //SEEK LONG RELEASE
		    	selectedIndex = idFullListView.currentIndex;
                        idFullListView.currentItem.playStationItem();
                    }
                }
            }
            onSigPlayStation:{
                console.log("[[[[[[[[ StationList::onSigPlayStation = StationList ]]]]]]]]" );
                if(UIListener.VIEWSTATE == 3) //VIEW_STATIONLIST
                {
                    console.log("onSigPlayStation = StationList idFullListView.activeFocus"+ idFullListView.activeFocus);
                    if(idFullListView.activeFocus == true)//KSW 131108 [ITS][207899][minor]
                        idFullListView.currentItem.clickOrKeySelected(0);
                    else
                        console.log("onSigPlayStation is return, this item is Mband Key");
                }

            }
////
        }
        onModelChanged: console.log(" /////////   onModelChanged  /////////");
        onMovingChanged:{ console.log(" /////////   onMovingChanged  /////////");
//20130107 added by qutiguy - station list view 30' limited show
            signalRestartTimerStationList();
        }
        model: {
//here0727
//            if(globalSelectedBand == stringInfo.strRDSBandFm) stationListFM
//            else if(globalSelectedBand == stringInfo.strRDSBandMw) stationListFM
            StationListSorted
        }
        delegate:
            MComp.MFullListDelegate {
            id: idMFullListDelegate
            //2013.10.30 DaehyungE ITS 204954
            x:0
            y:0
//            property int sIndex
            //here 0910
            signal playStationItem();
            //here0803
            property string strFreq : StringFreq;
            property string strName : StationName;
            property int intFreq : StationFreq;
            property real realPICODE : PICode
// 2013.09.10 added by qutiguy - change language pty issue.
            property int intPty : PtyType
            property string strPty : PtyName

            selectedFgImageFlag: true
//20121129 removed by qutiguy - change highlight
//            selectedBgImageFlag: true
            textCount: {
                if (idAppMain.globalSelectedBand == 0x01) 2
                else 1
            }

            //KSW 131231-2 debug mode del
            //mChListFirstText: idAppMain.debugMode?DispName+" : PICODE = "+ realPICODE.toString(16):DispName;//StationName? StationName : StringFreq
            mChListFirstText: DispName;
            mChListSecondText: (PtyName !="z")?idAppMain.getptyname(PtyType): ""
            onClickOrKeySelected: {
                //here 0830
                console.log("### Item click ###")
                // added by qutiguy 0514 : implementation tune with picode
                console.log("PICode", PICode)
                console.log("freq", StringFreq)

                //dg.jin 20141007 System popup hide
                if(idAppMain.systemPopupShow == true)
                {
                    UIListener.handleSystemPopupClose();
                }

                if(PICode > 0
                    && QmlController.getIsStorestationLists() == false) //KSW 140211 add case
                {
                    QmlController.tunePICode(PICode,StationName,PtyType);
                    QmlController.setBlockedStation(false);
                    gotoBackScreen();
                    return;
                }
                // end add
                QmlController.playRadioStation(StringFreq);
                if(!QmlController.getIndexfromModel(QmlController.radioBand,StringFreq))
                    QmlController.setPresetIndex(QmlController.radioBand,0xFF)
                else
                    QmlController.setPresetIndex(QmlController.radioBand,QmlController.getIndexfromModel(QmlController.radioBand,StringFreq))

                QmlController.setBlockedStation(false);
                gotoBackScreen();
            }
            onPlayStationItem : {
                //here 0830
                console.log("### Item click ###")
                // added by qutiguy 0514 : implementation tune with picode
                console.log("PICode", PICode)
                console.log("freq", StringFreq)

                if(PICode > 0
                    && QmlController.getIsStorestationLists() == false) //KSW 140211 add case
                {
                    QmlController.tunePICode(PICode,StationName,PtyType);
                    return;
                }
                // end add
                QmlController.playRadioStation(StringFreq);
                if(!QmlController.getIndexfromModel(QmlController.radioBand,StringFreq))
                    QmlController.setPresetIndex(QmlController.radioBand,0xFF)
                else
                    QmlController.setPresetIndex(QmlController.radioBand,QmlController.getIndexfromModel(QmlController.radioBand,StringFreq))

            }

            //****************************** # Key Event (wheel dial,wheel ccp) #
            Keys.onPressed: {
                console.log("[[[[[[[ StationList is focused on  and received key pressed ]]]]]]]")
                console.log("[ idAppMain.isJogMode(event, true) = ]" + idAppMain.isJogMode(event, true));
                //// 2013.11.11 added by qutiguy  - EU ITS 0207136: Page Movement in the station list
                switch(event.key){
                //////////// to simulate on desktop.
                //dg.jin 20150622 ITS 0264654 Station list jog right left event remove
                //case Qt.Key_Right:
                //    console.log("[CHECK_11_11_DESKTOP] Key_Right - right wheel ");
                //    signalRight(0);
                //    break;
                //case Qt.Key_Left:
                //    console.log("[CHECK_11_11_DESKTOP] Key_Left - left wheel ");
                //    signalLeft(0);
                //    break;
                //////////// to wheel control.
                case Qt.Key_Semicolon: {
                    signalWheelUp();

                    //dg.jin 20141013 list osd start
                    //if(buttonName == selectedIndex)
                    //{
                    //    UIListener.sendDataToOSDInfo(StringFreq, StationName, false);
                    //}
                    //else
                    //{
                    //    UIListener.sendDataToOSDInfo(StringFreq, StationName, true);
                    //}
                    //dg.jin 20141013 list osd end
                    break;
                }
                case Qt.Key_Apostrophe:{
                    signalWheelDn();

                    //dg.jin 20141013 list osd start
                    //if(buttonName == selectedIndex)
                    //{
                    //    UIListener.sendDataToOSDInfo(StringFreq, StationName, false);
                    //}
                    //else
                    //{
                    //    UIListener.sendDataToOSDInfo(StringFreq, StationName, true);
                    //}
                    //dg.jin 20141013 list osd end
                    break;
                }
                default:
                    break;
                } //# End switch
                ////

//20130107 added by qutiguy - station list view 30' limited show
                signalRestartTimerStationList();
            } //# End onPressed

    } //# End MFullListDelegate
    } //# End ListView
// 20121205 modified by qutiguy - fixed StationList position defects
//    //****************************** # Scroll #
//    MComp.MScroll {
//        x: parent.x+parent.width-13; y: 199-systemInfo.headlineHeight; z:1
//        scrollArea: idFullListView;
//        height: 474; width: 13
//        anchors.right: idFullListView.right
//        visible: idFullListView.count > 6
//        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
//    } // End MScroll
//****************************** # Scroll #
MComp.MScroll {
    x: 1257; y: 199-systemInfo.headlineHeight; z: 1
    scrollArea: idFullListView;
    height: 477; width: 14

    visible: idFullListView.count > 6
//    selectedScrollImage:imgFolderGeneral+"scroll_menu_list_bg.png"
    selectedScrollImage:imageInfo.imgFolderGeneralForPremium + "scroll_menu_list_bg.png"  //KSW 130731 for premium UX
    //
} // End MScroll

}//# End FocusScope

