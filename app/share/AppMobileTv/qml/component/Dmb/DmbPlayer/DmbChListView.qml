/**
 * FileName: DmbChListView.qml
 * Author: WSH
 * Time: 2013-02-05
 *
 * - 2013-01-29 Initial Crated by WSH
 */
import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MComponent {
    id: idDmbChListView
    x: 0; y: 0
    //width: 521; height: 534
    width: 529; height: 554

    property string inputMode: idAppMain.inputMode//"touch" //"jog" //
    property QtObject playerView : idPresetChList
    property int selectedItem: CommParser.m_iPresetListIndex  // currentIndex when clicked
    property int overContentCount;
    property int wheelLastSelectedCH: 0 //Added by Jeon_130112

    function isLargeViewMode()
    {
        return viewMode == "big";
    }
    function isTouchMode()
    {
        //return idAppMain.isTouchMode();
        if(inputMode == "jog")
            return false
        else
            return true // "touch" or "tuneFocus"
    }
    function getListBtImgSource()
    {
        if(isLargeViewMode()){
            return isTouchMode()?imageInfo.imgBgPreset02:imageInfo.imgBgPreset03
        }else if(!isLargeViewMode()){
            return isTouchMode()?imageInfo.imgBgPreset01:imageInfo.imgBgPreset_Jog
        }
    }
    function getListWidth()
    {
        if(isLargeViewMode()){
            return isTouchMode()?389:422
        }else if(!isLargeViewMode()){
            return isTouchMode()?(240-17):250
        }
        //console.log("imageInfo.imgBgPreset_Jog:" + imageInfo.imgBgPreset_Jog);
    }

    // # Bg Image #
    Image {
        id: idDmbChListViewBgImage
        anchors.verticalCenter: parent.verticalCenter
        source: imgFolderGeneral + "bg_ch_l.png"
        //visible: (CommParser.m_bIsFullScreen == false) &&
    } // End Image

    // # Round Bg Image #
    Image{
        id: idDmbChListViewRoundImage
        anchors.verticalCenter: parent.verticalCenter
        source: imgFolderGeneral+"bg_ch_l_s.png"
    }

    // # ChannelList ListView
    MComp.MListView{
        id: idPresetChList
        clip: true
        focus: true
        anchors.fill: parent;
        anchors.topMargin: 9
        anchors.bottomMargin: 11
        orientation: ListView.Vertical
        highlightMoveSpeed: 99999
        snapMode: ListView.SnapToItem
        cacheBuffer: 99999
        //boundsBehavior:Flickable.StopAtBounds

        model: DmbPresetModel1 //preset chList
        // ========================================= START Preset Order - WSH(130205)
        property int insertedIndex: -1
        property int selectedIndex:-1;
        property int curIndex:-1;
        property bool isDragStarted: false;
        signal itemInitWidth()
        signal itemMoved(int selectedIndex, bool isUp)
        //        Behavior on contentY {enabled: idPresetChList.isDragStarted; /*NumberAnimation { duration: 100 }*/ }
        // ========================================= END Preset Order - WSH(130205)

        delegate: DmbChListDelegate{}

        // for RoundScroll
        onContentYChanged: {
            overContentCount =parseInt(contentY/(contentHeight/count));
        }

        Component.onCompleted: {

            if(idPresetChList.count > 6)
            {
                var i;
                for(i=idPresetChList.count+5; i<idPresetChList.count ; i++)
                {
                    idDmbChListView.playerView.currentIndex = i;
                    idPresetChList.positionViewAtIndex (idDmbChListView.playerView.currentIndex, ListView.Center)
                }

                for(i=idPresetChList.count-1; i>=0 ; i--)
                {
                    idDmbChListView.playerView.currentIndex = i;
                    idPresetChList.positionViewAtIndex (idDmbChListView.playerView.currentIndex, ListView.Center)
                }

                idDmbChListView.playerView.currentIndex = CommParser.m_iPresetListIndex;
                idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex)
            }

        }


        onVisibleChanged: {
            if(visible){
                if(idPresetChList.count > 0) {
                    idDmbChListView.playerView.currentIndex = CommParser.m_iPresetListIndex;
                }
            }
        }

        // Set state : NoSignal
        onCountChanged: {
            if(presetListModel.rowCount() == 0) {
                EngineListener.SetExternal()
                if(CommParser.m_bIsFullScreen == true){
                    idDmbPlayer.state="Full_NoSignal"
                }
                else{
                    idDmbPlayer.state="NoSignal"
                }
            } // End If
        }
    }//end ListView

    // # Jog Left/Right in ListView
    onLeftKeyPressed:{
        if(CommParser.m_bIsFullScreen == true){
            if(recivingChannelTimer.running == true)
            {
                CommParser.setChangingTimerMode(2/*ReStart*/)
            }

            idAppMain.dmbSeekPrevKeyPressed()
        }
    }

    onRightKeyPressed:{
        if(CommParser.m_bIsFullScreen == true){
            if(recivingChannelTimer.running == true)
            {
                CommParser.setChangingTimerMode(2/*ReStart*/)
            }

            idAppMain.dmbSeekNextKeyPressed()
        }
    }

    onSeekPrevKeyReleased: {
        EngineListener.setToKeyTimmerStop();
    }
    onSeekNextKeyReleased:{
        EngineListener.setToKeyTimmerStop();
    }
    onTuneLeftKeyPressed:{
        EngineListener.setToKeyTimmerStop();
    }
    onTuneRightKeyPressed:{
        EngineListener.setToKeyTimmerStop();
    }

    // # Left/Right Wheel in ListView
    onWheelRightKeyPressed: {
        if(idAppMain.state != "AppDmbPlayer") return;// by WSH (ITS-67718)
        if(presetEditEnabled == true) return;  // Preset Order - WSH(130205)
        if(idPresetChList.flicking || idPresetChList.moving) return;
        if(idPresetChList.count == 0 || idPresetChList.count == 1) return;

        if(CommParser.m_bIsFullScreen == false && EngineListener.getShowOSDFrontRear() == false)
        {
            if(idPresetChList.count <= 6 && idDmbChListView.playerView.currentIndex == idPresetChList.count-1 )
                return;
        }

        CommParser.setChangingTimerMode(2/*ReStart*/);
        idDmbChListView.playerView.currentIndex = wheelLastSelectedCH = (idDmbChListView.playerView.currentIndex+count)%idPresetChList.count;

        idAppMain.dmbListPageRight()

        if(CommParser.m_bIsFullScreen == true){
            if( idDmbChListView.playerView.currentIndex == CommParser.m_iPresetListIndex)
            {
                EngineListener.setOSD_onFG(true, idDmbChListView.playerView.currentItem.secondText)
            }
            else
            {
                EngineListener.setOSD_onFG(false, idDmbChListView.playerView.currentItem.secondText)
            }
        }
        idWheelKeyTimer.restart();
    }

    onWheelLeftKeyPressed: {
        if(idAppMain.state != "AppDmbPlayer") return;
        if(presetEditEnabled == true) return;        
        if(idPresetChList.flicking || idPresetChList.moving) return;
        if(idPresetChList.count == 0 || idPresetChList.count == 1) return;

        if(CommParser.m_bIsFullScreen == false && EngineListener.getShowOSDFrontRear() == false)
        {
            if(idPresetChList.count <= 6 && idDmbChListView.playerView.currentIndex == 0 )
                return;
        }

        CommParser.setChangingTimerMode(2/*ReStart*/);
        idDmbChListView.playerView.currentIndex = wheelLastSelectedCH = (idDmbChListView.playerView.currentIndex+count)%idPresetChList.count < 0 ?
                    idPresetChList.count + (idDmbChListView.playerView.currentIndex+count)%idPresetChList.count : (idDmbChListView.playerView.currentIndex+count)%idPresetChList.count;

        idAppMain.dmbListPageLeft()

        if(CommParser.m_bIsFullScreen == true){
            if( idDmbChListView.playerView.currentIndex == CommParser.m_iPresetListIndex)
            {
                EngineListener.setOSD_onFG(true, idDmbChListView.playerView.currentItem.secondText)
            }
            else
            {
                EngineListener.setOSD_onFG(false, idDmbChListView.playerView.currentItem.secondText)
            }
        }

        idWheelKeyTimer.restart();

    }

    Timer{
        id : idWheelKeyTimer
        interval: 500
        repeat: false;

        onTriggered:
        {
            finishTimer();
        }

        function finishTimer()
        {
            if(wheelLastSelectedCH != CommParser.m_iPresetListIndex )
            {
                CommParser.onChannelSelectedByIndex(wheelLastSelectedCH, false, false);
                // Move for page by page
                if(idPresetChList.count > 6)
                {
                    EngineListener.changePresetListContentY(idPresetChList.contentY);
                }
            }

        }
    }

    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 457; y: 196-166//196-systemInfo.upperAreaHeight
        height: 491
        moveBarPosition: parseInt(height/idPresetChList.count*overContentCount);
        listCount: idPresetChList.count
        visible: idPresetChList.count > 6
    }

    Connections{
        target: EngineListener
        onSetPresetListContentY:{
            idPresetChList.contentY = signal_contentY;
        }

        onSetKeyTimmerStop:{
//            if(idWheelKeyTimer.running == true)
//            {
                idWheelKeyTimer.stop();
//            }
        }
    }

    Connections{
        target: CommParser

        onPresetListIndexChanged:{
//            console.log("[QML] DmbChListView:: onPresetListIndexChanged befor index: " + idPresetChList.currentIndex)

            if(idAppMain.presetEditEnabled == true) return;
            if(CommParser.m_iPresetListIndex == -1 || idAppMain.state == "AppDmbENGMode") return;

            selectedItem = CommParser.m_iPresetListIndex;
            idPresetChList.currentIndex = CommParser.m_iPresetListIndex

            if(idAppMain.state == "AppDmbPlayer")
            {
                if(idPresetChList.currentItem) idPresetChList.currentItem.forceActiveFocus()
            }
        }

    }
}
