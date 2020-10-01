/**
 * FileName: DABStationListView.qml
 * Author: DaeHyungE
 * Time: 2012-07-02
 *
 * - 2012-07-02 Initial Crated by HyungE
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id : idDabStationListView

    property string sortingBy : "" //ensemble, alphabet, pty, lang
    property int currentPlayIndex : 0
    property int screenListCount: 6

    Connections {
        target : idAppMain
        onReqSortingByEnsemble : {
            console.log("[QML] DABStationListView.qml : Connections => onReqSortingByEnsemble:")
            sortingBy = "ensemble";
            idStationListModel.clear();
            DABChannelManager.loadStationList(0);
            idStationTimer.restart();
        }
        onRegSortingByAlphabet : {
            console.log("[QML] DABStationListView.qml : Connections => onRegSortingByAlphabet:")
            sortingBy = "alphabet";
            idStationListModel.clear();
            DABChannelManager.loadStationList(1);
            idStationTimer.restart();
        }
        onRegSortingByPty : {
            console.log("[QML] DABStationListView.qml : Connections => onRegSortingByPty:")
            sortingBy = "pty";
            idStationListModel.clear();
            DABChannelManager.loadStationList(2);
            idStationTimer.restart();
        }
    }

    function getServiceNameX(bPlay, sortingType, serviceType)
    {
        var xPostion;
        if(bPlay)
        {
            if(sortingType == "sortingBy")
                xPostion = 166  //48+79+53 - parent.x(14);
            else
                xPostion = 148  //48+79+58 - parent.x(32);
        }
        else
        {
            if(sortingType == "sortingBy")
                xPostion = 118  //48+84 - parent.x(14);
            else
                xPostion = 100  //48+84 - parent.x(32);
        }

        if(serviceType == 0x00)
        {
            if(sortingType == "listItem")
                xPostion = 206  //180+58 - parent.x(32)
            else
                xPostion = 224
        }
        return xPostion;
    }

    function sortingByEnsemble(){
        console.log("[QML] DABStationListView.qml : sortingByEnsemble : sortingBy = " + sortingBy)
        sortingBy = "ensemble";
        idStationListModel.clear();
        DABChannelManager.loadStationList(0);
    }

    function sortingByAlphabet(){
        sortingBy = "alphabet";
        idStationListModel.clear();
        DABChannelManager.loadStationList(1);
    }

    function sortingByPty(){
        sortingBy = "pty";
        idStationListModel.clear();
        DABChannelManager.loadStationList(2);
    }

    function loadServiceList(freq, isSelect)
    {
        DABChannelManager.loadCurrentFreguencyChannel(freq, isSelect);
    }

    function clearServiceNameInEnsemble(ensemble)
    {
        var count = idStationListModel.count;
        var i = 0;
        for(i = count-1; i >= 0; i--){
            if( (idStationListModel.get(i).ensembleName == ensemble) && (idStationListModel.get(i).type != "section")) { //(idStationListModel.get(i).serviceName != "") ){
                idStationListModel.remove(i);
            }
        }
    }

    function selectService(listIndex, ensembleName, serviceName, type)
    {
        MDabOperation.CmdReqListSelected(listIndex, type);
        console.log("[QML] DABStitionListView.qml : selectService")
        gotoBackScreen();
    }

    function initialize()
    {
        console.log("[QML] DABStationListView.qml : initialize : sortingBy = " + sortingBy)

        if(sortingBy == "ensemble"){
            sortingByEnsemble();
        }else if(sortingBy == "alphabet"){
            sortingByAlphabet();
        }else if(sortingBy == "pty"){
            sortingByPty();
        }else{
            sortingByEnsemble();
        }
    }

    function focusMovementUp()
    {
        if(idStationListModel.get(idStationListMain.currentIndex).type == "section")
        {
            if(idStationListModel.get(idStationListMain.currentIndex).isLoadServiceName == "close")
            {
                idStationListModel.setProperty(idStationListMain.currentIndex, "isLoadServiceName", "open");
                idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
                DABChannelManager.loadListByLongSeekUp(idStationListModel.get(idStationListMain.currentIndex).frequency)
                idStationListMain.currentIndex = idStationListMain.currentIndex+1;
                return;
            }
        }
    }

    function focusMovementDown()
    {
        if(idStationListModel.get(idStationListMain.currentIndex).type == "section")
        {
            if(idStationListModel.get(idStationListMain.currentIndex).isLoadServiceName == "close")
            {
                idStationListModel.setProperty(idStationListMain.currentIndex, "isLoadServiceName", "open");
                DABChannelManager.loadListByLongSeekDown(idStationListModel.get(idStationListMain.currentIndex).frequency)
                return;
            }
        }
    }

    function seekLongKeyReleased()
    {
        if(idStationListModel.get(idStationListMain.currentIndex).type == "section")
        {
            if(idStationListModel.get(idStationListMain.currentIndex).isLoadServiceName == "close")
            {
                idStationListModel.setProperty(idStationListMain.currentIndex, "isLoadServiceName", "open");
                idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
                DABChannelManager.listSelectBySeekDown(idStationListModel.get(idStationListMain.currentIndex).frequency)
                idStationListMain.currentIndex++;
            }
            else if(idStationListModel.get(idStationListMain.currentIndex).isLoadServiceName == "open")
            {
                idStationListMain.currentIndex++;
            }
        }
        MDabOperation.CmdReqListSelected(idStationListModel.get(idStationListMain.currentIndex).listIndex, sortingBy);
        idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
        idStationListModel.setProperty(idStationListMain.currentIndex, "playIcon", true);
        currentPlayIndex = idStationListMain.currentIndex;
    }

    function seekPrevLongKeyReleasedFunc(seekPrevLongKeyPressed){
        console.log("[QML] DABStationListView.qml : onSeekPrevLongKeyPressedChanged : activeFocus = " + activeFocus)
        if(!activeFocus) return;
        if(seekPrevLongKeyPressed)
        {
            idStationTimer.stop();
            idSeekUpLongKeyTimerForStationList.running = true
        }
        else
        {
            idStationTimer.restart();
            idSeekUpLongKeyTimerForStationList.running = false
            seekLongKeyReleased()
        }
    }

    //****************************** # Seek Long Down
    function seekNextLongKeyReleasedFunc(seekNextLongKeyPressed){
        console.log("[QML] DABStationListView.qml : onSeekNextLongKeyPressedChanged : activeFocus = " + activeFocus)
        if(!activeFocus) return;
        if(seekNextLongKeyPressed)
        {
            idStationTimer.stop();
            idSeekDownLongKeyTimerForStationList.running = true
        }
        else
        {
            idStationTimer.restart();
            idSeekDownLongKeyTimerForStationList.running = false
            seekLongKeyReleased()
        }
    }

    onVisibleChanged: {
        if(!visible)
        {
            idSeekUpLongKeyTimerForStationList.stop();
            idSeekDownLongKeyTimerForStationList.stop();
            UIListener.setBlockedStation(false);
        }
    }

    //****************************** # For seek Long Up / Down
    Timer {
        id: idSeekUpLongKeyTimerForStationList
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            if( idStationListMain.currentIndex ){ idStationListMain.decrementCurrentIndex(); }
//            else if((0 >= idStationListMain.currentIndex) && (idStationListMain.count > screenListCount))     //Looping
//            {
//                idStationListMain.positionViewAtIndex(idStationListMain.count-1, idStationListMain.Visible);
//                idStationListMain.currentIndex = idStationListMain.count-1;
//            }
            idDabStationListView.focusMovementUp();
        }
        triggeredOnStart: true
    }

    Timer {
        id: idSeekDownLongKeyTimerForStationList
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            if( idStationListMain.count-1 != idStationListMain.currentIndex ){ idStationListMain.incrementCurrentIndex(); }
//            else if((idStationListMain.count-1 <= idStationListMain.currentIndex) && (idStationListMain.count > screenListCount))     //Looping
//            {
//                idStationListMain.currentIndex = 0;
//            }
            idDabStationListView.focusMovementDown();
        }
        triggeredOnStart: true
    }

    function listCountZeroCheck(){
        if(idStationListMain.count == 0) return true;
        else return false;
    }

    MComp.MListView {
        id : idStationListMain
        anchors.fill : parent
        cacheBuffer: idStationListMain.count - screenListCount
        clip : true
        focus : true
        snapMode : ListView.SnapToItem
        highlightMoveSpeed : 99999
        model : idStationListModel
        delegate : DABStationListDelegate{}      

        onMovementStarted: {
            idDabStationList.isMovemented = true;
            idStationTimer.stop();
        }
        onMovementEnded: {
            idDabStationList.isMovemented = false;
            idStationTimer.restart();

            idDabStationListBand.focus = false;
            idDabStationListView.focus = true;
        }

        onUpKeyLongPressedIsTrue: idStationTimer.stop();
        onUpKeyLongPressedIsFalse: idStationTimer.restart();
        onDownKeyLongPressedIsTrue: idStationTimer.stop();
        onDownKeyLongPressedIsFalse: idStationTimer.restart();
    }

    ListModel {
        id : idStationListModel;
    }

    MComp.MScroll {
        x : 1257
        y : 33
        height : 476
        width : 14
        visible: idStationListMain.count > screenListCount
        scrollArea : idStationListMain
        //selectedScrollImage : imageInfo.imgBgScroll_Menu_List
    }

    Connections {
        target : DABChannelManager
        onUpdateStationList : {
            console.log("[QML] Connections ==> DABStationListView.qml : onUpdateStationList :: idAppMain.state = " + idAppMain.state);
            if(idAppMain.state == "DabStationList")
            {
                sortingBy = "ensemble"
                initialize();
                if(idAppMain.state == "DabStationList") idStationListMain.forceActiveFocus()
            }
        }

        onSendEnsembleName : {
            //            console.log("[QML] DABStationListView.qml : onEnsembleName : " + ensembleName + ", Frequency : " + frequency + ", sectionStatus :" + sectionStatus);
            idStationListModel.append({"type":"section", "listIndex":-1, "frequency":frequency,"ensembleName":ensembleName, "serviceName":"", "pty":"", "ps":0x01,"isDABtoDAB":false, "isDABtoFM":false, "isNoSignal":false , "playIcon":false, "isLoadServiceName":sectionStatus});
        }

        onSendServiceName : {
            var count = idStationListModel.count;
            for(var i = count-1; i >= 0; i--){
                if(idStationListModel.get(i).frequency == frequency){
                    //                    console.log("[QML] DABStationListView.qml : onSendServiceName : " + frequency + ", " + ensembleName + ", " + serviceName + ", " + ps + ", " + isDABtoDAB + ", " + isDABtoFM + ", " + isNoSignal + ", bPlayIcon = " + bPlayIcon);
                    idStationListModel.insert(i+1, {"type":"listItem", "frequency":frequency, "listIndex":listIndex, "ensembleName":ensembleName, "serviceName":serviceName, "pty":pty, "ps":ps, "isDABtoDAB":isDABtoDAB, "isDABtoFM":isDABtoFM, "isNoSignal":isNoSignal, "playIcon":bPlayIcon,"isLoadServiceName":"open"})
                    if(bPlayIcon)
                    {
                        currentPlayIndex = i+1;
                    }
                    return;
                }
            }
        }

        onSendServiceNameForSortingBy:{
            //  console.log("[QML] Connection ==> DABStationListView.qml : onSendServiceNameForSortingBy : " + listIndex + ", " + ensembleName + ", " + serviceName + ", "  + isDABtoDAB + ", " + isDABtoFM + ", " + isNoSignal);
            idStationListModel.append({"type":"sortingBy", "listIndex":listIndex, "frequency":frequency,"ensembleName":ensembleName, "serviceName":serviceName, "pty":pty, "ps":ps, "isDABtoDAB":isDABtoDAB, "isDABtoFM":isDABtoFM, "isNoSignal":isNoSignal, "playIcon":bPlayIcon, "isLoadServiceName":"close"})
            if(bPlayIcon)
            {
                currentPlayIndex = index;
            }
        }

        onPlayIndexUpdate : {
            var count = idStationListModel.count;
            var playIndex = 0;
            for(var i = 0; i < count; i++)
            {
//                console.log("[QML] DABStationListView.qml : onPlayIndexUpdate : ensembleName : " + idStationListModel.get(i).ensembleName + ", serviceName = " + idStationListModel.get(i).serviceName + ", frequency = " + idStationListModel.get(i).frequency + ", PS = " + idStationListModel.get(i).ps);
                if(idStationListModel.get(i).type == "section") //.serviceName == "")
                {
                    console.log("[QML] DABStationListView.qml : onPlayIndexUpdate : This index is Ensemble tap.");
                    continue;
                }

                if(idStationListModel.get(i).playIcon == true)
                {
                    playIndex = i;
                    break;
                }
            }
            console.log("[QML] DABStationListView.qml : onPlayIndexUpdate : playIndex : " + playIndex + ", currentPlayIndex  = " + currentPlayIndex);
            idStationListMain.currentIndex = playIndex
            if(bViewPostionChanged)
            {
                idStationListMain.positionViewAtIndex(playIndex, ListView.Center);
            }
            else
            {
                currentPlayIndex = playIndex
            }
        }

        onUpdatePlayIndex :  {
            console.log("[KKP] DABStationListView.qml : DABChannelManager : onUpdatePlayIndex : list count = " + idStationListModel.count + ", currentPlayIndex = " + currentPlayIndex + ", current index = " + idStationListMain.currentIndex);
            console.log("[KKP] DABStationListView.qml : DABChannelManager : onUpdatePlayIndex : playIndex = " + playIndex);
            idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
            idStationListModel.setProperty(playIndex, "playIcon", true);
            currentPlayIndex = playIndex;
            idStationListMain.currentIndex = playIndex;
            idStationListMain.positionViewAtIndex(playIndex, ListView.Contain);
        }
    }

    Connections {
    target: DABController
        onPlayIndexUpdateForScan: {
            if(sortingBy == "alphabet" || sortingBy == "pty")
            {
                var count = idStationListModel.count;
                var playIndex = 0;
                idStationListModel.setProperty(currentPlayIndex, "playIcon", false);

                playIndex = DABChannelManager.findPlayIndexFromStationList(sortingBy);
                console.log("[QML] DABStationListView.qml : onPlayIndexUpdate : playIndex : " + playIndex + ", currentPlayIndex  = " + currentPlayIndex);
                idStationListMain.currentIndex = playIndex
                currentPlayIndex = playIndex;
                idStationListModel.setProperty(playIndex, "playIcon", true);
                idStationListMain.positionViewAtIndex(playIndex, ListView.Contain);
            }
            else
            {
                console.log("[QML] DABStationListView.qml : onPlayIndexUpdateForScan : list count = " + idStationListModel.count + ", currentPlayIndex = " + currentPlayIndex + ", current index = " + idStationListMain.currentIndex);
                var count = idStationListModel.count;
                var playIndex = 0;
                idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
                playIndex = currentPlayIndex+1;

                if(playIndex >= count){
                    if(count > screenListCount)
                        playIndex = 0;
                    else
                        playIndex = playIndex - 1
                }

                if(idStationListModel.get(playIndex).type == "section")
                {
                    if(idStationListModel.get(playIndex).isLoadServiceName == "open")
                    {
                        playIndex++;
                    }
                    else if(idStationListModel.get(playIndex).isLoadServiceName == "close")
                    {
                        idStationListModel.setProperty(playIndex, "isLoadServiceName", "open");
                        DABChannelManager.loadCurrentFreguencyChannel(idStationListModel.get(playIndex).frequency, true);
                        playIndex++;
                    }
                }
                idStationListModel.setProperty(playIndex, "playIcon", true);
                currentPlayIndex = playIndex;
                idStationListMain.currentIndex = playIndex;
                idStationListMain.positionViewAtIndex(playIndex, ListView.Contain);
            }
        }
        onUpdatePlayIndex:
        {
            console.log("[KKP] DABStationListView.qml : onUpdatePlayIndex : list count = " + idStationListModel.count + ", currentPlayIndex = " + currentPlayIndex + ", current index = " + idStationListMain.currentIndex);
            console.log("[KKP] DABStationListView.qml : onUpdatePlayIndex : playIndex = " + playIndex);
            idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
            idStationListModel.setProperty(playIndex, "playIcon", true);
            currentPlayIndex = playIndex;
            idStationListMain.currentIndex = playIndex;
            idStationListMain.positionViewAtIndex(playIndex, ListView.Contain);
        }
    }

    function seekPrevKeyReleaseFunc(){
        console.log("[QML] DABStationListView.qml : onPlayIndexUpdateFromSeekUp : list count = " + idStationListModel.count + ", currentPlayIndex = " + currentPlayIndex + ", current index = " + idStationListMain.currentIndex);
        if(idDabStationList.isMovemented) return;

        if(idStationListModel.get(idStationListMain.currentIndex).type == "section")
        {
            DABController.seekUpFromStationList();
            return;
        }

        var count = idStationListModel.count;
        var playIndex = 0;

        idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
        playIndex = currentPlayIndex-1;

        if(playIndex == 0)
        {
//            if(count > screenListCount){
                if(idStationListModel.get(playIndex).type == "sortingBy") playIndex = playIndex
                else playIndex = count-1;
//            }
//            else{
//                if(idStationListModel.get(playIndex).type == "sortingBy") playIndex = playIndex
//                else  playIndex = playIndex+1
//            }
        }
        else if(playIndex == -1){
//            if(count > screenListCount)
            playIndex = count-1;
//            else   playIndex = playIndex+1
        }

        if(idStationListModel.get(playIndex).type == "section")
        {          
            if(idStationListModel.get(playIndex).isLoadServiceName == "open")
            {
                if(playIndex == 0)
                {
                    playIndex = count - 1;
                }
                else
                {
                    playIndex--;
                }             
                if((idStationListModel.get(playIndex).type == "section") && (idStationListModel.get(playIndex).isLoadServiceName == "close"))
                {
                    idStationListModel.setProperty(playIndex, "isLoadServiceName", "open");
                    var addedListCount = DABChannelManager.loadCurrentFreguencyChannel(idStationListModel.get(playIndex).frequency, true);
                    playIndex = playIndex + addedListCount
                }
            }
            else if(idStationListModel.get(playIndex).isLoadServiceName == "close")
            {               
                idStationListModel.setProperty(playIndex, "isLoadServiceName", "open");               
                DABChannelManager.loadCurrentFreguencyChannel(idStationListModel.get(playIndex).frequency, true);
                playIndex = idStationListModel.count-1          
            }
        }

        idStationListModel.setProperty(playIndex, "playIcon", true);
        currentPlayIndex = playIndex;

        listLeftPageMovement();
        idStationListMain.currentIndex = playIndex;
        //idStationListMain.positionViewAtIndex(playIndex, ListView.Visible);

        MDabOperation.CmdReqListSelected(idStationListModel.get(idStationListMain.currentIndex).listIndex, sortingBy);
    }

    function seekNextKeyReleasedFunc(){
        console.log("[QML] DABStationListView.qml : onPlayIndexUpdateFromSeekDown : list count = " + idStationListModel.count + ", currentPlayIndex = " + currentPlayIndex + ", current index = " + idStationListMain.currentIndex);
        if(idDabStationList.isMovemented) return;

        if(idStationListModel.get(idStationListMain.currentIndex).type == "section")
        {
            DABController.seekDownFromStationList();
            return;
        }

        var count = idStationListModel.count;
        var playIndex = 0;
        idStationListModel.setProperty(currentPlayIndex, "playIcon", false);
        playIndex = currentPlayIndex+1;

        if(playIndex >= count)
        {
//            if(count > screenListCount)
            playIndex = 0;
//            else
//                playIndex = playIndex - 1
        }

        if(idStationListModel.get(playIndex).type == "section")
        {
            if(idStationListModel.get(playIndex).isLoadServiceName == "open")
            {
                playIndex++;
            }
            else if(idStationListModel.get(playIndex).isLoadServiceName == "close")
            {
                idStationListModel.setProperty(playIndex, "isLoadServiceName", "open");
                DABChannelManager.loadCurrentFreguencyChannel(idStationListModel.get(playIndex).frequency, true);
                playIndex++;
            }
        }

        idStationListModel.setProperty(playIndex, "playIcon", true);
        currentPlayIndex = playIndex;

        if(playIndex == 1)
            idStationListMain.positionViewAtIndex(0, ListView.Beginning);
        else
            listRightPageMovement();

        idStationListMain.currentIndex = playIndex;
        MDabOperation.CmdReqListSelected(idStationListModel.get(idStationListMain.currentIndex).listIndex, sortingBy);
    }

    //#****************************** Page Movement
    function listLeftPageMovement(){
        //# Start item check of ListView
        var startIndex = idStationListMain.getStartIndex(idStationListMain.contentY);
        if(startIndex == idStationListMain.currentIndex){
            if(startIndex < screenListCount){
                idStationListMain.positionViewAtIndex(screenListCount-1, ListView.End);
            }
            else{
                idStationListMain.positionViewAtIndex(idStationListMain.currentIndex-1, ListView.End);
            }
        }
    }
    function listRightPageMovement(){
        //# End item check of ListView
        var endIndex = idStationListMain.getEndIndex(idStationListMain.contentY);
        if(endIndex == idStationListMain.currentIndex){
            if((endIndex + screenListCount) < idStationListMain.count){
                idStationListMain.positionViewAtIndex(idStationListMain.count-1, ListView.End);
            }
            else{
                idStationListMain.positionViewAtIndex(idStationListMain.currentIndex+1, ListView.Beginning);
            }
        }

//        if(((idStationListMain.currentIndex+1) % screenListCount) == 0){
//            if(((idStationListMain.count % screenListCount) != 0) && ((idStationListMain.count - (((idStationListMain.currentIndex+1) / screenListCount) * screenListCount)) < screenListCount)){
//                idStationListMain.positionViewAtIndex(idStationListMain.count-1, ListView.End);
//            }
//            else{
//                idStationListMain.positionViewAtIndex(idStationListMain.currentIndex+1, ListView.Beginning);
//            }
//        }
    }
    //#****************************** Page Movement End
}
