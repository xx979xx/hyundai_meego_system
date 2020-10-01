import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/Dmb" as MDmb
import "../../../subapp"as Msubapp
import "../DmbDis" as MDmbDis
import "../ChSignal" as MChSignal
import AppEngineQMLConstants 1.0
//import Transparency 1.0
import QmlStatusBar 1.0

MComp.MComponent{
    id:idDmbPlayerMain
    focus: true
    //color: "#00990099"

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb: imageInfo.imgFolderDmb
    property QtObject playerList : idDmbChListView.playerView //playerList`s ListView'

    property int lastXPosition:-1
    property int firstXPosition:-1

    property int lastYPosition:-1
    property int firstYPosition:-1

    property bool changeChannelToPre:false
    property bool changeChannelToNext:false

    property bool isPreStateSet : false

//    property bool beRefreshList: false

    //signal signalKeyTimerOff();

//    signal signalRefreshList();

    ////**************************************** Dmb Player Main
    MComp.MComponent{
        id:idDmbPlayer
        x:0; y:0
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true

        property bool seekPreKeyLongPressed : idAppMain.isSeekPreLongKey;
        property bool seekNextKeyLongPressed : idAppMain.isSeekNextLongKey;

//        //--------------------- Bg Image #
//        Image {
//            id: idDmbPlayerBgImg
//            y: systemInfo.headlineHeight - systemInfo.statusBarHeight
//            source: imgFolderGeneral + "bg_ch_l.png"
//        } // End Image

        signal dlsReceived();

        function getDLSMessageX(){
            switch(DmbPlayer.m_iScreenSizeMode){
            case 0: return 529  //screen full => 759*554
            case 1: return 548  //screen 4:3 => 708*532
//            case 2: return 548  //screen 16:9 => 708*398
            case 2: return 160  //full screen 4:3 => 960*720
            case 3: return 0    //full screen 16:9 => 1280 : 720
            default: return 521 //screen full => 759*554
            }
        }

        function getDLSMessageY(){
            switch(DmbPlayer.m_iScreenSizeMode){
            case 0: return 166 -systemInfo.statusBarHeight  //screen full => 759*554
            case 1: return 176 -systemInfo.statusBarHeight  //screen 4:3 => 708*532
//            case 2: return 243 -systemInfo.statusBarHeight  //screen 16:9 => 708*398
            case 2: return 0 //-systemInfo.statusBarHeight    //full screen 4:3 => 960*720
            case 3: return 0 //-systemInfo.statusBarHeight    //full screen 16:9 => 1280 : 720
            default: return 166 -systemInfo.statusBarHeight //screen full => 759*554
            }
        }

        function getDLSMessageWidth(){
            switch(DmbPlayer.m_iScreenSizeMode){
            case 0: return 751  //screen full => 759*554
            case 1: return 708  //screen 4:3 => 708*532
//            case 2: return 708  //screen 16:9 => 708*398
            case 2: return 960  //full screen 4:3 => 960*720
            case 3: return 1280 //full screen 16:9 => 1280 : 720
            default: return 759 //screen full => 759*554
            }
        }

        function getDLSMessageHeight(){
            switch(DmbPlayer.m_iScreenSizeMode){
            case 0: return 554  //screen full => 759*554
            case 1: return 532  //screen 4:3 => 708*532
//            case 2: return 398  //screen 16:9 => 708*398
            case 2: return 720  //full screen 4:3 => 960*720
            case 3: return 720  //full screen 16:9 => 1280 : 720
            default: return 554 //screen full => 759*554
            }
        }

        function playerMainListPageLeft()
        {
            if(idDmbChListView.playerView.count <= 6) return;

            if(idDmbChListView.playerView.currentIndex%6 == 5)
                idDmbChListView.playerView.positionViewAtIndex(idDmbChListView.playerView.currentIndex-5, ListView.Beginning);
        }

        function playerMainListPageRight()
        {
            if(idDmbChListView.playerView.count <= 6) return;

            if(idDmbChListView.playerView.currentIndex%6 == 0)
                idDmbChListView.playerView.positionViewAtIndex(idDmbChListView.playerView.currentIndex, ListView.Beginning);
        }

        function playerMainListPageInit(index)
        {

            var currentPage = 0;
            var totalPage = 0;

            currentPage = EngineListener.getPresetListPageValue(1,index);
            totalPage = EngineListener.getPresetListPageValue(2, index);

            if(idDmbChListView.playerView.count % 6 == 0)
            {
                var temp = 0;
                currentPage = currentPage -1;
                temp = currentPage*6;
                idDmbChListView.playerView.positionViewAtIndex(temp, ListView.Beginning);

            }
            else
            {
                if(currentPage != totalPage)
                {
                    var temp = 0;
                    currentPage = currentPage -1;
                    temp = currentPage*6;
                    idDmbChListView.playerView.positionViewAtIndex(temp, ListView.Beginning);
                }
                else
                {
                    var temp = 0;
                    temp = idDmbChListView.playerView.count-6;
                    idDmbChListView.playerView.positionViewAtIndex(temp, ListView.Beginning);
                }
            }

        }

        Timer{
            id : idSeekKeyTimer
            interval: 25
            repeat: false;

            onTriggered:{
                finishTimer();
            }

            function finishTimer()
            {
                if(idDmbChListView.playerView.count > 6)
                {
                    EngineListener.changePresetListContentY(idDmbChListView.playerView.contentY);
                }

            }
        }

        function playerMainSeekPrevKeyPressed()
        {
            if(presetEditEnabled == true) { presetEditEnabled = false }  //  Preset Order - WSH(130205)

            //if(idAppMain.state != "AppDmbPlayer") return;

            if(playerList.count == 0 || playerList.count == 1) return;

            if(idKeyTimer.running == true)
            {
                idKeyTimer.stop();
            }

            var seekIndex = 0;

            if(idDmbChListView.playerView.currentIndex != CommParser.m_iPresetListIndex)
            {
                seekIndex = idDmbChListView.playerView.currentIndex;
            }
            else
            {
                seekIndex = CommParser.m_iPresetListIndex;
            }

            if(CommParser.m_bIsFullScreen == false && EngineListener.getShowOSDFrontRear() == false && EngineListener.isFrontRearBG() == false)
            {
                if(idDmbChListView.playerView.count <= 6 && idDmbChListView.playerView.currentIndex == 0 )
                    return;
            }

            if(seekIndex == 0)
                seekIndex = idDmbChListView.playerView.count - 1
            else
                seekIndex--;

            EngineListener.setSeekMoveFocus(seekIndex, 0);
//            idDmbChListView.playerView.currentIndex = seekIndex;
            CommParser.onChannelSelectedByIndex(seekIndex, false, false);
//            idDmbPlayer.playerMainListPageLeft()


//            idSeekKeyTimer.start()

            if(recivingChannelTimer.running == true)
            {
                CommParser.setChangingTimerMode(2/*ReStart*/)
            }
        }

        function playerMainSeekNextKeyPressed()
        {

            if(presetEditEnabled == true) { presetEditEnabled = false }  //  Preset Order - WSH(130205)

            //if(idAppMain.state != "AppDmbPlayer") return;

            if(playerList.count == 0 || playerList.count == 1) return;

            if(idKeyTimer.running == true)
            {
                idKeyTimer.stop();
            }

            var seekIndex = 0;

            if(idDmbChListView.playerView.currentIndex != CommParser.m_iPresetListIndex)
            {
                seekIndex = idDmbChListView.playerView.currentIndex;
            }
            else
            {
                seekIndex = CommParser.m_iPresetListIndex;
            }

            if(CommParser.m_bIsFullScreen == false && EngineListener.getShowOSDFrontRear() == false && EngineListener.isFrontRearBG() == false)
            {
                if(idDmbChListView.playerView.count <= 6 && idDmbChListView.playerView.currentIndex == idDmbChListView.playerView.count-1 )
                    return;
            }

            if(seekIndex == idDmbChListView.playerView.count - 1 )
                seekIndex = 0;
            else
                seekIndex++;

            EngineListener.setSeekMoveFocus(seekIndex, 1);
//            idDmbChListView.playerView.currentIndex = seekIndex;
            CommParser.onChannelSelectedByIndex(seekIndex, false, false);
//            idDmbPlayer.playerMainListPageRight()

//            idSeekKeyTimer.start()

            if(recivingChannelTimer.running == true)
            {
                CommParser.setChangingTimerMode(2/*ReStart*/)
            }
        }

        function playerMainTuneLeftKeyPressed()
        {

            if(presetEditEnabled == true) { presetEditEnabled = false }  //  Preset Order - WSH(130205)

            //if(idAppMain.state != "AppDmbPlayer" ) return;
            if(idDmbPlayerBand.focus == true)
            {
                idDmbChListView.focus = true;
            }

            if(playerList.count == 0 || playerList.count == 1) return;


            if(CommParser.m_bIsFullScreen == true || EngineListener.getShowOSDFrontRear() == true)
            {
                CommParser.setChangingTimerMode(2/*ReStart*/);

                if(idDmbChListView.playerView.currentIndex == 0)
                    idDmbChListView.playerView.currentIndex = idDmbChListView.playerView.count - 1
                else
                    idDmbChListView.playerView.currentIndex--;

//                CommParser.onChannelSelectedByIndex(idDmbChListView.playerView.currentIndex, false, false);
                EngineListener.setShowOSDTune(idDmbChListView.playerView.currentItem.secondText);
                idKeyTimer.restart();

                idDmbPlayer.playerMainListPageLeft()
            }
            else
            {
                if(idDmbChListView.playerView.count <= 6 && idDmbChListView.playerView.currentIndex == 0 && EngineListener.isFrontRearBG() == false)
                    return;

                CommParser.setChangingTimerMode(2/*ReStart*/);

                if(idDmbChListView.playerView.currentIndex == 0)
                    idDmbChListView.playerView.currentIndex = idDmbChListView.playerView.count - 1
                else
                    idDmbChListView.playerView.currentIndex--;

//                if(EngineListener.isFrontRearBG() == true)
//                {
//                    CommParser.onChannelSelectedByIndex(idDmbChListView.playerView.currentIndex, false, false);
//                }
//                else
                {
                    EngineListener.setShowOSDTune(idDmbChListView.playerView.currentItem.secondText);
                    idKeyTimer.restart();
                }
                idDmbPlayer.playerMainListPageLeft()
            }
        }

        function playerMainTuneRightKeyPressed()
        {

            if(presetEditEnabled == true) { presetEditEnabled = false }  //  Preset Order - WSH(130205)

            //if(idAppMain.state != "AppDmbPlayer" ) return;
            if(idDmbPlayerBand.focus == true)
            {
                idDmbChListView.focus = true;
            }

            if(playerList.count == 0 || playerList.count == 1) return;


            if(CommParser.m_bIsFullScreen == true || EngineListener.getShowOSDFrontRear() == true)
            {
                CommParser.setChangingTimerMode(2/*ReStart*/);

                if(idDmbChListView.playerView.currentIndex == idDmbChListView.playerView.count - 1 )
                    idDmbChListView.playerView.currentIndex = 0;
                else
                    idDmbChListView.playerView.currentIndex++;

//                CommParser.onChannelSelectedByIndex(idDmbChListView.playerView.currentIndex, false, false);

                EngineListener.setShowOSDTune(idDmbChListView.playerView.currentItem.secondText);
                idKeyTimer.restart();

                idDmbPlayer.playerMainListPageRight()
            }
            else
            {
                if(idDmbChListView.playerView.count <= 6 && idDmbChListView.playerView.currentIndex == idDmbChListView.playerView.count - 1 && EngineListener.isFrontRearBG() == false)
                    return;

                CommParser.setChangingTimerMode(2/*ReStart*/);

                if(idDmbChListView.playerView.currentIndex == idDmbChListView.playerView.count - 1 )
                    idDmbChListView.playerView.currentIndex = 0;
                else
                    idDmbChListView.playerView.currentIndex++;

//                if(EngineListener.isFrontRearBG() == true)
//                {
//                    CommParser.onChannelSelectedByIndex(idDmbChListView.playerView.currentIndex, false, false);
//                }
//                else
                {
                    EngineListener.setShowOSDTune(idDmbChListView.playerView.currentItem.secondText);
                    idKeyTimer.restart();
                }
                idDmbPlayer.playerMainListPageRight()
            }
        }

        function isXYPositionMoved()
        {
            var moveMode = 0
            var xPositionMoveScope = 0
            var yPositionMoveScope = 0

            if(lastXPosition > firstXPosition){
                xPositionMoveScope = lastXPosition - firstXPosition;
            }
            else if(lastXPosition < firstXPosition)
            {
                xPositionMoveScope = firstXPosition - lastXPosition;
            }


            if(lastYPosition > firstYPosition){
                yPositionMoveScope = lastYPosition - firstYPosition;
            }
            else if(lastYPosition < firstYPosition)
            {
                yPositionMoveScope = firstYPosition - lastYPosition;
            }


            if(lastXPosition == -1 || lastXPosition == firstXPosition || xPositionMoveScope <= 10 || yPositionMoveScope >= 100 )
            {
                if(lastXPosition == -1 || lastXPosition == firstXPosition)
                {
                    moveMode = 0; // just onclick
                }
                else if(yPositionMoveScope >= 10)
                {
                    moveMode = 1; // y position move over 10 pixel(?) so do nothing
                }
                else if( xPositionMoveScope <= 10 )
                {
                    moveMode = 2; // x position move under 10 pixel(?) so do nothing
                }

            }
            else
            {
                if(lastXPosition > firstXPosition)
                {
                    changeChannelToNext = true;
                }
                else if(lastXPosition < firstXPosition)
                {
                    changeChannelToPre = true;
                }

                moveMode = 3;
            }



            lastXPosition = -1
            firstXPosition = -1

            lastYPosition = -1
            firstYPosition = -1
            return moveMode;
        }

        function changeChannelByXPosition()
        {            
            if(idAppMain.isDrag == true)
            {
                if(changeChannelToPre == true)
                {
                    if(CommParser.m_iPresetListIndex <= 0)
                        CommParser.m_iPresetListIndex = playerList.count - 1
                    else
                        CommParser.m_iPresetListIndex--;
                }
                else if(changeChannelToNext == true)
                {
                    if(CommParser.m_iPresetListIndex == playerList.count - 1 )
                        CommParser.m_iPresetListIndex = 0;
                    else
                        CommParser.m_iPresetListIndex++;
                }

                if(recivingChannelTimer.running == true)
                {
                    //recivingChannelTimer.restart()
                    CommParser.setChangingTimerMode(2/*ReStart*/)
                }
                CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);
            }

            changeChannelToPre = false;
            changeChannelToNext = false;
        }

        function longKeyTimerOff()
        {
            if(idSeekPreLongKeyTimer.running == true)
            {
                idSeekPreLongKeyTimer.stop()
            }
            if(idSeekNextLongKeyTimer.running == true)
            {
                idSeekNextLongKeyTimer.stop()
            }
        }

        Timer{
            id: recivingChannelTimer
            interval: 10000;//changingChInterval
            running: false; repeat: false
            onTriggered: {
                if(idDmbPlayer.state == "ChangingChannel"){
                    if(CommParser.m_bIsFullScreen == true){
                        if(CommParser.m_eSignalState == 0/*SIGNALPLAYING*/ && CommParser.getPlaySvcState() != 0){
                            idDmbPlayer.state="ChangePlayerOnly"
                        }else{
                            idDmbPlayer.state="Full_NoSignal"
                        }
                    }
                    else{
                        if(CommParser.m_eSignalState == 0/*SIGNALPLAYING*/ && CommParser.getPlaySvcState() != 0){
                            idDmbPlayer.state="ChangePlayer"
                        }else{
                            idDmbPlayer.state="NoSignal"
                        }
                    }
                    if(idDmbPlayer.state == "NoSignal" || idDmbPlayer.state == "Full_NoSignal")
                        CommParser.m_eSignalState = 2; /*SIGNALWEEK*/
                    EngineListener.SetExternal()

                }
            }
        }
        Timer{
            id : idKeyTimer
            interval: 500
            repeat: false;

            onTriggered:{
                finishTimer();
            }

            function finishTimer()
            {
                if(idDmbChListView.playerView.currentIndex != CommParser.m_iPresetListIndex )
                {
                    CommParser.onChannelSelectedByIndex(idDmbChListView.playerView.currentIndex, false, false);
                }

                // Move for page by page
                if(idDmbChListView.playerView.count > 6)
                {
                    EngineListener.changePresetListContentY(idDmbChListView.playerView.contentY);
                }
            }
        }

        Timer {
            id: idSeekPreLongKeyTimer
            interval: 200
            repeat: true
            running: false
            onTriggered:
            {
// #if 0 move function from qt to qml if (#if) is 1
//                var currDispTarget = EngineListener.getCurrentDisplayTarget();
//                var currRearDispStatus = EngineListener.getRearDisplayOnOffStatus();

//                if(idSeekNextLongKeyTimer.running == true){
//                    idSeekNextLongKeyTimer.stop();
//                }

//                if(EngineListener.getIsRRC() == false){
//                    if( currDispTarget == 2 || currDispTarget == 0 || statusBar.visible == false || idAppMain.state != "AppDmbPlayer" ){
//                        if(idDmbChListView.playerView.count-1 != idDmbChListView.playerView.currentIndex)
//                        {
//                            idDmbPlayer.playerMainSeekNextKeyPressed();
//                        }else{
//                            idSeekPreLongKeyTimer.stop();
//                        }
//                    }else{
//                        if(idDmbChListView.playerView.currentIndex !=0 )
//                        {
//                            idDmbPlayer.playerMainSeekPrevKeyPressed();
//                        }else{
//                            idSeekPreLongKeyTimer.stop();
//                        }
//                    }
//                }else{
//                    if( currDispTarget == 1 || currDispTarget == 0 || currRearDispStatus == 3 || statusBar.visible == false || idAppMain.state != "AppDmbPlayer" ){

//                        if(idDmbChListView.playerView.count-1 != idDmbChListView.playerView.currentIndex)
//                        {
//                            idDmbPlayer.playerMainSeekNextKeyPressed();
//                        }else{
//                            idSeekPreLongKeyTimer.stop();
//                        }
//                    }else{
//                        if(idDmbChListView.playerView.currentIndex !=0 )
//                        {
//                            idDmbPlayer.playerMainSeekPrevKeyPressed();
//                        }else{
//                            idSeekPreLongKeyTimer.stop();
//                        }
//                    }
//                }
// #else move function from qt to qml if (#if) is 1

                if(idDmbChListView.playerView.currentIndex !=0 )
                {
                    idDmbPlayer.playerMainSeekPrevKeyPressed();
                }else{
                    idSeekPreLongKeyTimer.stop();
                }
// #endif move function from qt to qml if (#if) is 1
            }
            triggeredOnStart: true
        }

        Timer {
            id: idSeekNextLongKeyTimer
            interval: 200
            repeat: true
            running: false
            onTriggered:
            {
// #if 0 move function from qt to qml if (#if) is 1
//                var currDispTarget = EngineListener.getCurrentDisplayTarget();
//                var currRearDispStatus = EngineListener.getRearDisplayOnOffStatus();

//                if(idSeekPreLongKeyTimer.running == true){
//                    idSeekPreLongKeyTimer.stop();
//                }

//                if(EngineListener.getIsRRC() == false){
//                    if( currDispTarget == 2 || currDispTarget == 0 || statusBar.visible == false || idAppMain.state != "AppDmbPlayer" ){
//                        if(idDmbChListView.playerView.currentIndex !=0 )
//                        {
//                            idDmbPlayer.playerMainSeekPrevKeyPressed();
//                        }else{
//                            idSeekNextLongKeyTimer.stop();
//                        }
//                    }else{
//                        if(idDmbChListView.playerView.count-1 != idDmbChListView.playerView.currentIndex)
//                        {
//                            idDmbPlayer.playerMainSeekNextKeyPressed();
//                        }else{
//                            idSeekNextLongKeyTimer.stop();
//                        }
//                    }
//                }else{
//                    if( currDispTarget == 1 || currDispTarget == 0 || currRearDispStatus == 3 || statusBar.visible == false || idAppMain.state != "AppDmbPlayer" ){
//                        if(idDmbChListView.playerView.currentIndex !=0 )
//                        {
//                            idDmbPlayer.playerMainSeekPrevKeyPressed();
//                        }else{
//                            idSeekNextLongKeyTimer.stop();
//                        }
//                    }else{
//                        if(idDmbChListView.playerView.count-1 != idDmbChListView.playerView.currentIndex)
//                        {
//                            idDmbPlayer.playerMainSeekNextKeyPressed();
//                        }else{
//                            idSeekNextLongKeyTimer.stop();
//                        }
//                    }
//                }
// #else move function from qt to qml if (#if) is 1

                if(idDmbChListView.playerView.count-1 != idDmbChListView.playerView.currentIndex)
                {
                    idDmbPlayer.playerMainSeekNextKeyPressed();
                }else{
                    idSeekNextLongKeyTimer.stop();
                }
// #endif move function from qt to qml if (#if) is 1
            }
            triggeredOnStart: true
        }

        // DLS Message
        DmbDLSMessage{
            id:idDmbDLSMessage
            dmbDLStext: ""
            visible: isDLSChannel
            onVisibleChanged: {
                if(!idDmbDLSMessage.visible) return
                if(idDmbDLSMessage.isBottom){ // Bottom
                    idDmbDLSMessage.x = idDmbPlayer.getDLSMessageX();
                    idDmbDLSMessage.y = idDmbPlayer.getDLSMessageY();
                    idDmbDLSMessage.width = idDmbPlayer.getDLSMessageWidth();
                    idDmbDLSMessage.height = idDmbPlayer.getDLSMessageHeight();
                }
                else{ // Bottom X
                    idDmbDLSMessage.x = CommParser.m_bIsFullScreen ? 43 : 542
                    idDmbDLSMessage.y = (258-systemInfo.statusBarHeight)
                    idDmbDLSMessage.width = CommParser.m_bIsFullScreen ? 1204 : 724
                    idDmbDLSMessage.height = 380
                }
            }

            Connections{
                target : DmbPlayer
                onDmbScreenSizeChanged:{

                    if(!idDmbDLSMessage.visible) return
                    if(idDmbDLSMessage.isBottom){ // Bottom
                        idDmbDLSMessage.x = idDmbPlayer.getDLSMessageX();
                        idDmbDLSMessage.y = idDmbPlayer.getDLSMessageY();
                        idDmbDLSMessage.width = idDmbPlayer.getDLSMessageWidth();
                        idDmbDLSMessage.height = idDmbPlayer.getDLSMessageHeight();
                    }
                    else{ // Bottom X
                        idDmbDLSMessage.x = CommParser.m_bIsFullScreen ? 43 : 542
                        idDmbDLSMessage.y = (258-systemInfo.statusBarHeight)
                        idDmbDLSMessage.width = CommParser.m_bIsFullScreen ? 1204 : 724
                        idDmbDLSMessage.height = 380
                    }
                }
            }
        }

        MChSignal.DmbChangingChannel{
            id:idDmbChangingChannel
            visible: false
        }
        MChSignal.DmbNoSignal{
            id:idDmbNoSinal
            visible: false
        }

        MChSignal.DmbRestrictionDriving{
            id: idDmbRestrictionDriving
            visible: false
        }

        MComp.MComponent{
            id: idDmbPlayerArea
            focus: true

            //**************************************** Dmb Player Band
            DmbPlayerBand{
                id:idDmbPlayerBand
                x:0; y:0
                height: 73
                focus: (playerList.count == 0) ? true : false
                KeyNavigation.down: (playerList.count == 0) ? idDmbPlayerBand : idDmbChListView
            }

            //**************************************** Dmb Player ListView
            DmbChListView{
                id: idDmbChListView
                focus: (playerList.count == 0) ? false : true
                x:0; y:166-systemInfo.statusBarHeight//y:176-systemInfo.statusBarHeight //by WSH # 176 : DMB_PlanB_v1.0.8(10p/52p)
                KeyNavigation.up: idDmbPlayerBand
            }
        }

        QmlStatusBar{
            id: statusBar
            x: 0
            y: 0-93
            width: 1280
            height: 93
            homeType:"button"
            middleEast: false
            visible:false
        }
        // by WSH (ITS-68308)
        onVisibleChanged: {

            if(visible){
                if(presetListModel.rowCount() == 0 || CommParser.m_iPresetListIndex == -1 ){
                    idDmbPlayer.state="NoSignal"
                    EngineListener.SetExternal()
                }
            } // End If
        }

//        onActiveFocusChanged:{
//            if(activeFocus == false)
//            {
//                idDmbPlayerMain.playerList.interactive = false;
//                mouseExit();
//            }
//            else
//            {
//                idDmbPlayerMain.playerList.interactive = true;
//            }
//        }

        Component.onCompleted: {
            if(presetListModel.rowCount() == 0 || CommParser.m_iPresetListIndex == -1){

                if(CommParser.m_bIsFullScreen == true){
                    idDmbPlayer.state="Full_NoSignal"
                }
                else{
                    idDmbPlayer.state="NoSignal"
                }
                EngineListener.SetExternal()
            }
            else{
                idDmbPlayer.state="ChangingChannel";

//                idDmbPlayer.state="ChangePlayer";
//                if(UIListener.getCurrentScreen() == 1){
//                    idDmbPlayer.state="ChangePlayer";
//                }else if(UIListener.getCurrentScreen() == 2){
//                    if(EngineListener.getAppPlayerState() == ""){
//                        idDmbPlayer.state="ChangePlayer";
//                    }else{
//                        idDmbPlayer.state=EngineListener.getAppPlayerState();
//                    }
//                }

                //if(UIListener.getCurrentScreen() == 1)
                    //CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);
            }

//            if(UIListener.getCurrentScreen() == 2){
//                if(idAppMain.state != EngineListener.getAppMainState())
//                    setAppMainScreen(EngineListener.getAppMainState(), false);
//            }

            //CommParser.autoTest_athenaSendObject()
        }

        onStateChanged: {


            switch(idDmbPlayer.state){
            case "ChangePlayer":
            {
                if(recivingChannelTimer.running == true)
                {
                    CommParser.setChangingTimerMode(1/*STOP*/)
                }
                break;
            }
            case "ChangePlayerOnly":
            {
                if(recivingChannelTimer.running == true)
                {
                    CommParser.setChangingTimerMode(1/*STOP*/)
                }
                break;
            }
            case "ChangingChannel":
            {
                if(isDLSChannel){
                    isDLSChannel = false;
                    idDmbDLSMessage.visible = false;
                }

                //recivingChannelTimer.restart()
                CommParser.setChangingTimerMode(2/*ReStart*/)
                break
            }
            case "Full_NoSignal":
            {
                break
            }
            case "NoSignal":
            {
                break
            }
            default:
//                EngineListener.HandleStatusBarShow(UIListener.getCurrentScreen());
                break
            }

            //CommParser.autoTest_athenaSendObject()
        }

        onMousePosChanged:
        {

            if(CommParser.m_bIsFullScreen == true)
            {
                if((firstXPosition == -1 && lastXPosition == -1) || (firstYPosition == -1 && lastYPosition == -1) )
                {
                    firstXPosition = x;
                    firstYPosition = y;
                    return;
                }
                else
                {
                    lastXPosition = x;
                    lastYPosition = y;
                }
            }
        }

        onClickOrKeySelected:{
            if(pressAndHoldFlag == false){

                if( EngineListener.m_ScreentSettingMode == true && idAppMain.drivingRestriction == false) return;
                //idAppMain.playBeep();

                if(CommParser.m_bIsFullScreen == true){
                    var touchType = 0;
                    touchType = isXYPositionMoved();

                    if( touchType != 0)  // touchType == 0 is just click
                    {
                        if(touchType == 3) // touchType == 3 means x position move over 10 Pixel(?)
                        {
                            changeChannelByXPosition();
                        }
                    }
                    else
                    {
                        CommParser.m_bIsFullScreen = false;
                    }

                }
                else
                {
                    if(presetEditEnabled == true) return;  //  Preset Order - WSH(130205)

                    CommParser.m_bIsFullScreen = true;

                }
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && presetEditEnabled == false) idAppMain.playBeep();
        }

        onClickMenuKey:{
            if(presetEditEnabled == true ) return;  //  Preset Order - WSH(130205)

            if(idDmbPlayer.state=="ChangingChannel" && CommParser.m_bIsFullScreen == true)
            {
                CommParser.m_bIsFullScreen = false;
//                EngineListener.HandleStatusBarShow(UIListener.getCurrentScreen());
            }
            else if(idDmbPlayer.state=="ChangePlayerOnly" || idDmbPlayer.state=="Full_NoSignal")
            {
                CommParser.m_bIsFullScreen = false;                
            }

            if(idDmbPlayer.state=="ChangePlayer"
                    || idDmbPlayer.state=="ChangingChannel"
                    || idDmbPlayer.state=="NoSignal" )
            {
                playerList.forceActiveFocus();
                EngineListener.selectOptionMenuByIndex(9/*LongKey Cancel*/);
                EngineListener.m_bJogUpkeyLongPressed = false;
                EngineListener.m_bJogDownkeyLongPressed = false;
                if(idAppMain.isOnclickedByTouch == true){
                    idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex);
                    idAppMain.isOnclickedByTouch = false;
                }
                setAppMainScreen("AppDmbPlayerOptionMenu", true);
            }
        }

        onBackKeyPressed: {
            if(CommParser.m_bIsFullScreen == true){
                CommParser.m_bIsFullScreen = false
            }
            else{

                //  Preset Order - WSH(130205)                 
                if(presetEditEnabled == true) {
//                    EngineListener.sendToClusterWhenAVChanged();
                    if(EngineListener.getDRSShowStatus() == false)
                    {
                        presetEditEnabled = false
                        idDmbPlayerMain.playerList.isDragStarted = false;
                        idDmbPlayerMain.playerList.interactive = true;
                        idDmbPlayerMain.playerList.itemInitWidth();
                        idDmbPlayerMain.playerList.curIndex = -1;
                        idDmbPlayerMain.playerList.insertedIndex = -1;
                        idDmbPlayerMain.playerList.forceActiveFocus();

                        if(playerList.count > 0) {
//                            console.log(" [QML] ====== > [DHDmbPlayerMain][onBackKeyPressed] playerLis.count =", playerList.count)
                            playerList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Center)
                        } // End If
                    }
                    else
                    {
                        EngineListener.selectOptionMenuByIndex(3/*Back in Move Channel menu */);
                    }


                }else{ // None preset order
                    gotoBackScreen()
                }
            } // End if
        }

        onSeekPrevKeyReleased: {
            if(idDmbChListView.playerView.flicking || idDmbChListView.playerView.moving) return;
            EngineListener.seekKeyPressed(0);
            idDmbPlayer.playerMainSeekPrevKeyPressed()
        }
        onSeekNextKeyReleased:{
            if(idDmbChListView.playerView.flicking || idDmbChListView.playerView.moving) return;
            EngineListener.seekKeyPressed(1);
            idDmbPlayer.playerMainSeekNextKeyPressed()
        }


        onSeekPreKeyLongPressedChanged:{
//            console.log(" [QML] ====== > [DHDmbPlayerMain][onSeekPreKeyLongPressedChanged] isSeekPreLongKey = "+ idAppMain.isSeekPreLongKey)
            if( idDmbChListView.playerView.count < 2) return;

            if(idAppMain.isSeekPreLongKey == true)
            {
                if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
                if(idAppMain.state == "AppDmbPlayerOptionMenu" || idAppMain.presetEditEnabled == true || idAppMain.state == "PopupChannelDeleteConfirm")
                {
                    EngineListener.moveGoToMainScreen()
                }

                idSeekPreLongKeyTimer.start();
            }
            else
            {
                idSeekPreLongKeyTimer.stop();
            }
        }

        onSeekNextKeyLongPressedChanged:{
//            console.log(" [QML] ====== > [DHDmbPlayerMain][onSeekNextKeyLongPressedChanged] isSeekNextLongKey= "+ idAppMain.isSeekNextLongKey)
            if( idDmbChListView.playerView.count < 2) return;

            if(idAppMain.isSeekNextLongKey == true)
            {
                if(playBeepOn && pressAndHoldFlagDMB == false) idAppMain.playBeep();
                if(idAppMain.state == "AppDmbPlayerOptionMenu" || idAppMain.presetEditEnabled == true || idAppMain.state == "PopupChannelDeleteConfirm")
                {
                    EngineListener.moveGoToMainScreen()
                }
                idSeekNextLongKeyTimer.start();
            }
            else
            {
                idSeekNextLongKeyTimer.stop();
            }
        }

        onTuneLeftKeyPressed: {
            if(idDmbChListView.playerView.flicking || idDmbChListView.playerView.moving) return;
            if(EngineListener.isFrontRearBG() == true)
            {
                idDmbPlayer.playerMainTuneLeftKeyPressed()
            }
            else
            {
                if(CommParser.m_bIsFullScreen == true){
                    idDmbPlayer.playerMainTuneLeftKeyPressed();
                }
                else
                {
//                    if(EngineListener.getDRSShow() == false){
//                        idDmbPlayer.playerMainTuneLeftKeyPressed();
//                    }else{
                        EngineListener.tuneKeyPressed(0/*Left*/)
//                    }
                }
            }
        }
        onTuneRightKeyPressed: {
            if(idDmbChListView.playerView.flicking || idDmbChListView.playerView.moving) return;
            if(EngineListener.isFrontRearBG() == true)
            {
                idDmbPlayer.playerMainTuneRightKeyPressed()
            }
            else
            {
                if(CommParser.m_bIsFullScreen == true){
                    idDmbPlayer.playerMainTuneRightKeyPressed();
                }
                else
                {
//                    if(EngineListener.getDRSShow() == false){
//                        idDmbPlayer.playerMainTuneRightKeyPressed();
//                    }else{
                        EngineListener.tuneKeyPressed(1/*Right*/)
//                    }
                }
            }
        }
        onTuneEnterKeyPressed:{

            if(idAppMain.state != "AppDmbPlayer") return;
            if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
            {
                if(idDmbPlayer.state !="ChangingChannel")
                {
                    EngineListener.SetExternal()
                }
                return;
            }
            if(presetEditEnabled==true) { return; }    //  Preset Order - WSH(130205)

            if(CommParser.m_iPresetListIndex == playerList.currentIndex)
            {
                if(CommParser.m_bIsFullScreen == true){
                    CommParser.m_bIsFullScreen = false;
                }
                else
                {
                    CommParser.m_bIsFullScreen = true;
                }
            }
            else
            {

                CommParser.onChannelSelectedByIndex(playerList.currentIndex, false, false);
            }
        }

        //**************************************** States
        states: [
            State {
                name: "ChangePlayer"
                PropertyChanges {
                    target: idDmbPlayer;
                    y: (CommParser.m_bIsFullScreen) ? 0-systemInfo.statusBarHeight : 0;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                }
                PropertyChanges { target: idDmbChListView; x: 0; visible:true}
                PropertyChanges { target: idDmbPlayerBand; x: 0; visible:true}
                PropertyChanges { target: idDmbChangingChannel; visible:false}
                PropertyChanges { target: idDmbNoSinal; visible:false}
                PropertyChanges { target: idDmbDLSMessage; visible:isDLSChannel} //DLS
                PropertyChanges { target: idDmbRestrictionDriving; visible:idAppMain.drivingRestriction ; x:0} //"DrivingRestriction"
                PropertyChanges { target: statusBar; visible:true}
                //PropertyChanges { target: idDmbPlayerBgImg; visible: true}
            },
            State {
                name: "ChangePlayerOnly"
                PropertyChanges {
                    target: idDmbPlayer;
                    y: (CommParser.m_bIsFullScreen) ? 0-systemInfo.statusBarHeight : 0;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                }
                PropertyChanges { target: idDmbChListView; x: -systemInfo.lcdWidth ; visible:true}
                PropertyChanges { target: idDmbPlayerBand; x: -systemInfo.lcdWidth ; visible:true}
                PropertyChanges { target: idDmbDLSMessage; visible:isDLSChannel} //DLS
                PropertyChanges { target: idDmbRestrictionDriving; visible:idAppMain.drivingRestriction ; x:0; y: 0; height: systemInfo.lcdHeight_VEXT } //"DrivingRestriction"
                PropertyChanges { target: statusBar; visible:false}
                //PropertyChanges { target: idDmbPlayerBgImg; visible: false}
            },
            State {
                name: "ChangingChannel"
                PropertyChanges {
                    target: idDmbChangingChannel;
                    visible:true;
                    y: (CommParser.m_bIsFullScreen) ? 0-systemInfo.statusBarHeight : 0;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                }
                //PropertyChanges { target: idDmbChListView; x: 0; visible:!(CommParser.m_bIsFullScreen)}
                PropertyChanges { target: idDmbChListView; x: CommParser.m_bIsFullScreen ? -systemInfo.lcdWidth : 0; visible:true}
                PropertyChanges { target: idDmbPlayerBand; x: 0; visible:!(CommParser.m_bIsFullScreen)}
                PropertyChanges { target: idDmbRestrictionDriving; visible:false /*idAppMain.drivingRestriction*/ ; x:0;
                                  y: (CommParser.m_bIsFullScreen) ? 0-systemInfo.statusBarHeight : 0;
                                  height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight} //"DrivingRestriction"
                PropertyChanges { target: statusBar; visible:(CommParser.m_bIsFullScreen) ? false : true}
                //PropertyChanges { target: idDmbPlayerBgImg;  visible: false}
            },
            State {
                name: "NoSignal"
                PropertyChanges {
                    target: idDmbPlayer;
                    y: (CommParser.m_bIsFullScreen) ? 0-systemInfo.statusBarHeight : 0;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                }
                PropertyChanges {
                    target: idDmbNoSinal;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                    visible: true;
                }
                //PropertyChanges { target: idDmbNoSinal; visible:true}
                PropertyChanges { target: idDmbChangingChannel; visible:false}
                PropertyChanges { target: idDmbChListView; x: 0; visible:true}
                PropertyChanges { target: idDmbPlayerBand; x: 0; visible:true}
                PropertyChanges { target: idDmbRestrictionDriving; visible:false /*idAppMain.drivingRestriction*/ ; x:0} //"DrivingRestriction"
                PropertyChanges { target: statusBar; visible:true}
                //PropertyChanges { target: idDmbPlayerBgImg; visible: true}
            },
            State {
                name: "Full_NoSignal"
                PropertyChanges {
                    target: idDmbPlayer;
                    y: (CommParser.m_bIsFullScreen) ? 0-systemInfo.statusBarHeight : 0;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                }
                PropertyChanges {
                    target: idDmbNoSinal;
                    //y: 0-systemInfo.statusBarHeight;
                    height: (CommParser.m_bIsFullScreen) ? systemInfo.lcdHeight_VEXT : systemInfo.subMainHeight
                    visible: true;
                }
                PropertyChanges { target: idDmbChangingChannel; visible:false}
                PropertyChanges { target: idDmbChListView; x: -systemInfo.lcdWidth ; visible:true}
                PropertyChanges { target: idDmbPlayerBand; x: -systemInfo.lcdWidth ; visible:true}
                PropertyChanges { target: idDmbRestrictionDriving; visible:false /*idAppMain.drivingRestriction*/ ; x:0; y:0; height: systemInfo.lcdHeight_VEXT } //"DrivingRestriction"
                PropertyChanges { target: statusBar; visible:false}
                //PropertyChanges { target: idDmbPlayerBgImg; visible: false}
            }

        ] // End states

        Connections{
            target: idAppMain

            onInputModeChanged:{

                if(inputMode == "jog")
                {
                    if(playerList.count == 0) return;

//                    if(idDmbPlayer.state == "ChangePlayerOnly") idDmbPlayer.state="ChangePlayer"
                    idDmbChListView.state = "selected"

                }else{

                    idDmbChListView.state = "focused"

                }
            }

            onGoToMainSeekPrevKeyPressed:{ idDmbPlayer.playerMainSeekPrevKeyPressed() }

            onGoToMainSeekNextKeyPressed:{ idDmbPlayer.playerMainSeekNextKeyPressed() }

            onGoToMainTuneLeftKeyPressed:{ idDmbPlayer.playerMainTuneLeftKeyPressed() }

            onGoToMainTuneRightKeyPressed:{ idDmbPlayer.playerMainTuneRightKeyPressed() }

            onGoToMainListPageLeft:{ idDmbPlayer.playerMainListPageLeft() }

            onGoToMainListPageRight:{ idDmbPlayer.playerMainListPageRight() }

            onGoToMainListPageInit:{ idDmbPlayer.playerMainListPageInit(index) }

            onSignalSaveReorderPreset:{
                if(idAppMain.presetEditEnabled == true && idAppMain.isDragItemSelect == true){
                    if(idDmbPlayerMain.playerList.insertedIndex >= 0 && idDmbPlayerMain.playerList.curIndex >= 0)
                        EngineListener.selectChangeList(idDmbPlayerMain.playerList.insertedIndex, idDmbPlayerMain.playerList.curIndex, idDmbPlayerMain.playerList.contentY, CommParser.m_iPresetListIndex, idDmbPlayerMain.playerList.currentIndex);
                }
            }
        }

        Connections{
            target: CommParser


            onIsFullScreenChanged:{

//                console.debug("[QML]============================= [onisFullScreenChanged] "+CommParser.m_bIsFullScreen+" idDmbPlayer.state:"+idDmbPlayer.state)

                if(idDmbChListView.playerView.currentIndex != CommParser.m_iPresetListIndex)
                {
                    idDmbChListView.playerView.currentIndex =  CommParser.m_iPresetListIndex;
                }

                if(CommParser.m_bIsFullScreen == true)
                {

                    if(idAppMain.state != "AppDmbPlayer")
                    {
                        gotoMainScreen()
                    }

                    if(idDmbPlayer.state=="NoSignal" )
                    {
                        idDmbPlayer.state="Full_NoSignal"
                    }
                    else if(idDmbPlayer.state =="ChangePlayer")
                    {
                        idDmbPlayer.state="ChangePlayerOnly"
                    }
                    else if(idDmbPlayer.state =="ChangingChannel")
                    {
                        idDmbPlayer.state="ChangingChannel"
                        EngineListener.setOSDOnFullScreenInChannneChanging(false);
                    }

                    playerList.forceActiveFocus();
                    setAppMainScreen("PopupSetFullScreen", true);

                    if(EngineListener.isScreenSettingMode() == false)
                    {
                        if( CommParser.m_ScreenRatio == 1 /*ASPECT_RATIO_16_9*/){
                            DmbPlayer.m_iScreenSizeMode = 3 /*EScreenSize_fullscreen_16x9*/
                        }
                        else DmbPlayer.m_iScreenSizeMode = 2 /*EScreenSize_fullscreen_4x3*/

                        EngineListener.updateScreenSizeByOptionMenu();
                    }
                }
                else
                {
                    if(idDmbPlayer.state == "Full_NoSignal" )
                    {
                        idDmbPlayer.state="NoSignal"
                    }
                    else if(idDmbPlayer.state =="ChangePlayerOnly")
                    {
                        idDmbPlayer.state="ChangePlayer"
                    }
                    else if(idDmbPlayer.state =="ChangingChannel")
                    {
                        idDmbPlayer.state="ChangingChannel"
                    }

                    playerList.forceActiveFocus();

                    //EngineListener.setOSD_ClearAll();
                    if(EngineListener.isScreenSettingMode() == false)
                    {
                        if(CommParser.m_ScreenRatio == 1/*ASPECT_RATIO_4_3*/) DmbPlayer.m_iScreenSizeMode = 0 /*EScreenSize_full*/
                        else DmbPlayer.m_iScreenSizeMode = 1 /*EScreenSize_4x3*/

                        EngineListener.updateScreenSizeByOptionMenu();
                    }
                }
            }

            onChannelChanging: {
//                console.debug("[luna] onChannelChanging : idDmbPlayer.state == " + idDmbPlayer.state + ", idAppMain.state = " + idAppMain.state)
                if(CommParser.m_iPresetListIndex == -1){
                    if(CommParser.m_bIsFullScreen == true){
                        idDmbPlayer.state="Full_NoSignal"
                    }
                    else{
                        idDmbPlayer.state="NoSignal"
                    }
                    EngineListener.SetExternal()
                }
                else{
                    idAppMain.beRefreshList = true;
                    idDmbPlayer.state = "ChangingChannel";

                    if(recivingChannelTimer.running == true)
                        CommParser.setChangingTimerMode(2/*ReStart*/);

                    CommParser.m_eSignalState = 1; /*SIGNALRECEVING*/
                }
            }

            onChangingTimerControl:{
//                changingChInterval = 10000;
                if(isDLSChannel){
                    isDLSChannel = false;
                    idDmbDLSMessage.visible = false;
                }
                if(timerMode==1/*Stop*/){
                    recivingChannelTimer.stop()
                }else if(timerMode==2/*ReStart*/){
//                    if(isRadioChannel)
//                        changingChInterval = 20000;
                    recivingChannelTimer.restart()
                }

            }

            onChannelChanged: {
//                console.debug("[QML] ==> onChannelChanged, idDmbPlayer.state == "+idDmbPlayer.state)
//                console.debug("[QML] ==> onChannelChanged, m_ScreentSettingMode == "+EngineListener.m_ScreentSettingMode+"  m_bNotUpdateScreen= "+DmbPlayer.m_bNotUpdateScreen)

                if(idAppMain.beRefreshList)
                    idAppMain.beRefreshList = false;

                if( EngineListener.m_ScreentSettingMode == true )
                {
                    EngineListener.updateScreenSizeByOptionMenu();
                }

                if(DmbPlayer.m_bNotUpdateScreen == true)
                {
                    DmbPlayer.m_bNotUpdateScreen = false;
                    EngineListener.updateScreenSizeByOptionMenu();
                }

                if( EngineListener.checkPossibleGSTPlay() == false)
                {
                    if(EngineListener.getIsHaveGstRight() == true)
                        if(EngineListener.m_stateFG && (idAppMain.drivingRestriction == false)) DmbPlayer.Play() /*EngineListener.onGstPlay()*/ //for DMB<->Camara pipeline issue
                }

                if(idDmbPlayer.state =="ChangingChannel" ||idDmbPlayer.state =="NoSignal" || idDmbPlayer.state == "Full_NoSignal")
                {
                    //recivingChannelTimer.stop()
                    CommParser.setChangingTimerMode(1/*Stop*/)
//                    console.debug("[luna] onChannelChanged, isFullScreen == "+CommParser.m_bIsFullScreen)
                    if(CommParser.m_bIsFullScreen == true){
                        idDmbPlayer.state="ChangePlayerOnly"
                    }
                    else
                    {
                        idDmbPlayer.state="ChangePlayer"
                    }
                }
            }

            onChannelSearchStopped :{
//                console.debug("[idDmbPlayer] onChannelSearchStopped")
                if(presetListModel.rowCount() == 0)
                {
                    idDmbPlayer.state="NoSignal"
                    EngineListener.SetExternal()
                }
                // else idDmbPlayer.state="ChangingChannel"
            }
            onSignalLosted:{
//                console.log("[luna] onNoSignalArea")

                if( EngineListener.m_ScreentSettingMode == true )
                {
                    DmbPlayer.MoveToScreenOut(true);
                }

                if(CommParser.m_bIsFullScreen == true)
                {
                    idDmbPlayer.state="Full_NoSignal"
                }
                else
                {
                    idDmbPlayer.state="NoSignal"
                }

//                if(EngineListener.m_stateFG == true)
//                {
//                    DmbPlayer.Pause();
//                }

            }
            onDlsReceived:{
                idDmbDLSMessage.dmbDLStext = DLSMessage
//                console.debug("***** onDlsReceived--> DLSMessage : " + DLSMessage)

                if((DLSMessage.length*32) > 1116) idDmbDLSMessage.isBottom = false
                else idDmbDLSMessage.isBottom = true

                isDLSChannel = true;
                idDmbDLSMessage.visible = true
            } 

//            onNotifyCurChItemSvcTypeName:{
//                isRadioChannel = false;

//                if(svcType == 0) // AUDIO : 0 / VIDEO : 1 / DATA : 2
//                    isRadioChannel = true;
//            }
        }

        Connections{
            target:EngineListener

            onSetFocusAfterEngModeClose:{
                idDmbChListView.forceActiveFocus();
            }

            onSendSeekMoveFocus:{
                /*
                  signal_key 0 :  preseek
                  signal_key 1 :  nextseek
                  */

                if(idAppMain.state == "AppDmbPlayerOptionMenu")
                {
                    EngineListener.moveGoToMainScreen()
                }

                idDmbChListView.playerView.currentIndex = signal_seek_index;

                if(presetListModel.rowCount() > 0 && idAppMain.state == "AppDmbPlayer"){
                    if(playerList.activeFocus){
                        idAppMain.beRefreshList = true;
                    }
                }

                if(signal_key == 0)
                {
                    if(idDmbChListView.playerView.count <= 6) return;

                    if(idDmbChListView.playerView.currentIndex%6 == 5)
                        idDmbChListView.playerView.positionViewAtIndex(idDmbChListView.playerView.currentIndex-5, ListView.Beginning);
                }
                else if(signal_key == 1)
                {
                    if(idDmbChListView.playerView.count <= 6) return;

                    if(idDmbChListView.playerView.currentIndex%6 == 0)
                        idDmbChListView.playerView.positionViewAtIndex(idDmbChListView.playerView.currentIndex, ListView.Beginning);
                }

            }

            onSetGoToMainScreen:{
                if(idAppMain.isENGMode == true){
                    return;
                }

                if(idAppMain.state == "PopupListEmpty")
                    return;

                if(idAppMain.presetEditEnabled == true)
                {
                    idAppMain.presetEditEnabled =false;

                    idDmbPlayerMain.playerList.isDragStarted = false;
                    idDmbPlayerMain.playerList.interactive = true;
                    idDmbPlayerMain.playerList.itemInitWidth();
                    idDmbPlayerMain.playerList.curIndex = -1;
                    idDmbPlayerMain.playerList.insertedIndex = -1;
                    idDmbPlayerMain.playerList.forceActiveFocus();

                    if(playerList.count > 0) {
//                        console.log(" [QML] ====== > [DHDmbPlayerMain][onBackKeyPressed] playerLis.count =", playerList.count)
                        idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex)
                    }
                }

                if(fromVr == true){
                    if(idAppMain.state == "AppDmbPlayer" || idAppMain.state == "AppDmbPlayerOptionMenu")
                        return;
                }

                if(idAppMain.upKeyLongPressed == true ){
                    idAppMain.upKeyLongPressed = false;
                    EngineListener.m_bOptionMenuOpen = false;
                }
                if(idAppMain.downKeyLongPressed == true ){
                    idAppMain.downKeyLongPressed = false;
                    EngineListener.m_bOptionMenuOpen = false;
                }
                idAppMain.gotoMainScreen()
            }

            onModeDRSChanged:{
                if(idAppMain.presetEditEnabled == true)
                {
                    if(EngineListener.getTemporalModeFG() == true){
//                        console.log(" [QML][DmbPlayerMain][onModeDRSChanged] RETURN----------------TemporalMode");
                        return;
                    }
                    if(( EngineListener.getDRSShow() == true && EngineListener.m_DRSmode == false) ){
//                        console.log(" [QML][DmbPlayerMain][onModeDRSChanged] RETURN----------------DRSShow(true)/m_DRSmode(false)");
                        return;
                    }
                    if(EngineListener.getDRSShow() == false){
//                        console.log(" [QML][DmbPlayerMain][onModeDRSChanged] RETURN----------------DRSShow(false)");
                        return;
                    }

                    if(idDmbPlayerMain.playerList.isDragItem == true)
                    {
                        presetEditEnabled = false;
                        idDmbPlayerMain.playerList.isDragStarted = false;
                        idDmbPlayerMain.playerList.interactive = true;
                        idDmbPlayerMain.playerList.itemInitWidth();
                        idDmbPlayerMain.playerList.curIndex = -1;
                        idDmbPlayerMain.playerList.insertedIndex = -1;
                        idDmbPlayerMain.playerList.forceActiveFocus();

                        if(playerList.count > 0) {
//                            console.log(" [QML] ====== > [DHDmbPlayerMain][onBackKeyPressed] playerLis.count =", playerList.count)
//                            playerList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Center)
                            idAppMain.dmbListPageInit( idDmbChListView.playerView.currentIndex);
                        } // End If
                        presetEditEnabled = true;
                    }
                }
            }

            onSetSyncPresetEditListIndex:{
                if(EngineListener.getPresetEditListCurrentIndex() != -1 && idAppMain.presetEditEnabled){
                    playerList.currentIndex = EngineListener.getPresetEditListCurrentIndex()
                    if(UIListener.getCurrentScreen() == 2){
                        EngineListener.setPresetEditListCurrentIndex(-1);
                    }
                }
            }
            onSendDrsShowHide:{
                if(idAppMain.presetEditEnabled == true){
                    if(EngineListener.getIswapEnabled() == false){
                        if(UIListener.getCurrentScreen() == 1){
                            EngineListener.setPresetEditListCurrentIndex(playerList.currentIndex);
                        }
                    }else if(EngineListener.getIswapEnabled() == true){
                        if(UIListener.getCurrentScreen() == 2){
                            EngineListener.setPresetEditListCurrentIndex(playerList.currentIndex);
                        }
                    }
                }

//                console.log(" [QML][DmbPlayerMain][onSendDrsShowHide] isShow : " + isShow);
//                if(isShow == false){
//                    if(idAppMain.presetEditEnabled == true)
//                    {
//                        if(idAppMain.isDragItemSelect == true)
//                        {
//                            presetEditEnabled = false;
//                            idDmbPlayerMain.playerList.isDragStarted = false;
//                            idDmbPlayerMain.playerList.interactive = true;
//                            idDmbPlayerMain.playerList.itemInitWidth();
//                            idDmbPlayerMain.playerList.curIndex = -1;
//                            idDmbPlayerMain.playerList.insertedIndex = -1;
//                            //idDmbPlayerMain.playerList.forceActiveFocus();

//                            if(playerList.count > 0) {
//                                idAppMain.dmbListPageInit( idDmbChListView.playerView.currentIndex);
//                            }
//                            presetEditEnabled = true;
//                        }else{
//                            idDmbChListView.playerView.currentIndex = CommParser.m_iPresetListIndex

//                            if(playerList.count > 0) {
//                                idAppMain.dmbListPageInit( idDmbChListView.playerView.currentIndex);
//                            }
//                        }
//                    }
//                }
            }

            onRequestBackgroundImg:{
//                console.debug("================================> onRequestBackgroundImg : onOff = " + onOff +"  idDmbPlayer.state=" +idDmbPlayer.state)
                if(onOff == true)
                {
                    if(idDmbPlayer.state == "ChangePlayerOnly" || idDmbPlayer.state == "ChangePlayer" )
                    {
                        isPreStateSet = true;
                        idDmbPlayer.state="ChangingChannel";
                    }
                    else if(idDmbPlayer.state == "ChangingChannel")
                    {
                        CommParser.setChangingTimerMode(2/*Start*/)
                    }
                }
                else
                {
                    if(isPreStateSet == true)
                    {
                        if(idDmbPlayer.state == "ChangingChannel")
                        {
                            if(CommParser.m_bIsFullScreen == false)
                            {
                                idDmbPlayer.state = "ChangePlayer"
                            }
                            else
                            {
                                idDmbPlayer.state = "ChangePlayerOnly"
//                                if(DmbPlayer.m_bNotUpdateScreen == true)
//                                {
//                                    DmbPlayer.MoveToScreenOut(false);
//                                    DmbPlayer.m_bNotUpdateScreen = false;
//                                }

                            }
                        }
                    }
                    isPreStateSet = false;

                }

//                bgImageEnable = onOff;
            }

            onStateFGChanged:{
                if(EngineListener.m_stateFG){
//                    console.debug("[QML][TRUE]================================> [onStateFGChanged] idAppMain.state :"+idAppMain.state + " idDmbPlayer.state:"+idDmbPlayer.state)
                    if( EngineListener.getDRSShowStatus() == true && EngineListener.getIsScreenSizeChange() == true && EngineListener.getIsVRBSM() == false)
                    {
//                        console.debug("[QML][TRUE]================================> [onStateFGChanged] return!!! ")
                        return;
                    }
                    else if(EngineListener.getIsDRSEventOnFG() == true)
                    {
//                        console.debug("[QML][TRUE]================================> [onStateFGChanged] return  2 !!! ")
                        return;
                    }

                    // Unset Preset Order WSH(130205)
                    if(presetEditEnabled == true) {
                        EngineListener.selectOptionMenuByIndex(3/*Back in Move Channel menu */);
                        presetEditEnabled = false
                    }

//                    idDmbPlayerMain.Show()
                    gotoMainScreen()

                    if(idAppMain.state == "AppDmbPlayer")
                    {

                        if(EngineListener.getIsScreenSizeChange() == false)
                        {
                            if(CommParser.m_bIsFullScreen == true)
                            {
                                CommParser.m_bIsFullScreen = false
                            }
                        }
			
                        if(presetListModel.rowCount() == 0){
                            setAppMainScreen("PopupListEmpty", true);
                        } //End If
                        else {
                            playerList.currentIndex = CommParser.m_iPresetListIndex

                            idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex)

                            if(playerList.activeFocus == false){
                                playerList.forceActiveFocus();
                            }
//                            else{
//                                idAppMain.beRefreshList = true;
//                                idDmbPlayerMain.signalRefreshList();
//                            }
                        }
                        EngineListener.setShowOSDFrontRear(false);
                    } // End If
                }
                else{ // this case back from camera. Must matain befor state
//                    console.debug("[QML][FALSE]================================> [onStateFGChanged] idAppMain.state :"+idAppMain.state + "EngineListener.getDisplayOnOffStatus="+EngineListener.getDisplayOnOffStatus())

                    idDmbPlayer.longKeyTimerOff();

                    idAppMain.signalKeyTimerOff();

                    if(EngineListener.m_DRSmode == false){
                        idAppMain.scrollTextTimerChange = true;
                        idAppMain.signalScrollTextTimerOff();
                    }

//                    if(presetEditEnabled == true  && EngineListener.isFrontRearBG() == true && EngineListener.getDisplayOnOffStatus() == false && EngineListener.getIsCameraOn() == false ) {
//                        presetEditEnabled = false

//                        idDmbPlayerMain.playerList.isDragStarted = false;
//                        idDmbPlayerMain.playerList.interactive = true;
//                        idDmbPlayerMain.playerList.itemInitWidth();
//                        idDmbPlayerMain.playerList.curIndex = -1;
//                        idDmbPlayerMain.playerList.insertedIndex = -1;
//                        idDmbPlayerMain.playerList.forceActiveFocus();
//                    }

                    if(idDmbPlayer.state =="ChangingChannel")
                    {
                        EngineListener.setOSDOnFullScreenInChannneChanging(true);
                    }
                }
            }

            onDmbReqPreForeground:{
//                console.debug("[QML]================================> [onDmbReqPreForeground]")

//                idDmbPlayerMain.Show()
            }

            onDmbReqForeground:{
                if(idAppMain.scrollTextTimerChange){
                    idAppMain.signalScrollTextTimerOn();
                    idAppMain.scrollTextTimerChange = false;
                }
                if(listState != "pressed" || idAppMain.iskeyRelease == true) return;
                idAppMain.iskeyRelease = true;
            }

            onKeyChChangedFromUISH:{
//                console.debug("[QML]============================================= onKeyChChangedFromUISH")
//                CommParser.onChannelSelectedByIndex(AVIndex)
                CommParser.onChannelSelectedByIndex(AVIndex, false, false);
                //playerList.currentIndex = CommParser.m_iPresetListIndex
            }

            onKeyChChangedByIndexFromUISH:{
//                console.debug("[QML]============================================= onKeyChChangedByIndexFromUISH")
//                if(AVPresetIndex >= 24) //DMB2
//                    CommParser.m_iPresetListIndex = AVPresetIndex - 24
//                else
                    CommParser.m_iPresetListIndex = AVPresetIndex

                CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);
            }

            onKeyChSearchSelectedFromUISH:{
//                console.debug("[QML]============================================= onKeyChSearchSelectedFromUISH")
                if(idAppMain.state != "PopupSearching" )
                    selectedMainScreen = "PopupSearching"
            }

            onGotoTotalChannelFromUISH:{

                selectedMainScreen = "AppDmbTotalChannel"
            }

            onShowPopupSearching:{
                //console.debug("-- DHDmbplayerMain::onShowPopupSearching [idAppMain.state]:"+ idAppMain.state+", [drivingRestriction]:"+idAppMain.drivingRestriction)

                if(idAppMain.state != "AppDmbPlayer")
                {
                    gotoMainScreen()
                }

                setAppMainScreen("PopupSearching", true)
            }

            onSetOptionMenuByIndex:{
//                console.debug("[QML]=========== onSetOptionMenuByIndex :: index = "+ index);

                if(index == 0 /*Move Channel */){
                    if(idAppMain.state == "AppDmbPlayerOptionMenu")
                    {
                        gotoBackScreen()
                    }
                    idAppMain.presetEditEnabled = true
                }
                else if( index == 1/*Delete Channel */){
                    if(idAppMain.state == "PopupChannelDeleteConfirm")
                    {
                        gotoBackScreen()
                        idAppMain.isMainDeletedPopup = true
                        setAppMainScreen("PopupDeleted", true);
                    }
                    else
                    {
                        idAppMain.isMainDeletedPopup = true
                        setAppMainScreen("PopupDeleted", true);
                    }

                    if(playerList.count  <= 6)
                    {
                        playerList.contentY = 0
                    }
                }
                else if( index == 2/*Disaster Broadcasting List*/){
                     if(idAppMain.state == "AppDmbPlayerOptionMenu")
                     {
                         gotoBackScreen()
                         setAppMainScreen("AppDmbDisaterList", true);
                     }
                     else
                     {
                         setAppMainScreen("AppDmbDisaterList", true);
                     }
                }
                else if(index ==3 /*Back in Move Channel menu */){
                    if(presetEditEnabled == true)
                    {
                        presetEditEnabled = false
                        idDmbPlayerMain.playerList.isDragStarted = false;
                        idDmbPlayerMain.playerList.interactive = true;
                        idDmbPlayerMain.playerList.itemInitWidth();
                        idDmbPlayerMain.playerList.curIndex = -1;
                        idDmbPlayerMain.playerList.insertedIndex = -1;
                        idDmbPlayerMain.playerList.forceActiveFocus();

                        if(playerList.count > 0) {
//                            console.log(" [QML] ====== > [DHDmbPlayerMain][onBackKeyPressed] playerLis.count =", playerList.count)
                            idDmbPlayer.playerMainListPageInit(CommParser.m_iPresetListIndex)
                        } // End If
                    }
                }
                else if( index == 6 /*Back  Disaster Delete Menu */){
                    gotoBackScreen();
                }
                else if( index == 8 /* Delete Channel Confirm */){
                    if(idAppMain.state == "AppDmbPlayerOptionMenu")
                    {
                        gotoBackScreen()
                        setAppMainScreen("PopupChannelDeleteConfirm", true);
                    }
                    else
                    {
                        setAppMainScreen("PopupChannelDeleteConfirm", true);
                    }
                }
                else if(index == 9 /* LongKey Cancel */)
                {
//                    EngineListener.m_bJogUpkeyLongPressed = false;
//                    EngineListener.m_bJogDownkeyLongPressed = false;
                    idAppMain.upKeyLongPressed = false;
                    idAppMain.downKeyLongPressed = false;
                    idAppMain.isSeekPreLongKey = false;
                    idAppMain.isSeekNextLongKey = false;
                }

            }

            onSetSeekKeyPressed:{
                if(idAppMain.state == "AppDmbPlayerOptionMenu")
                {
                    EngineListener.moveGoToMainScreen()
                }

                if(presetEditEnabled == true)
                {
                    EngineListener.selectOptionMenuByIndex(3/*Back in Move Channel menu */);
                }

//                if(seekType == 0 /* Left */)
//                {
//                    idAppMain.dmbSeekPrevKeyPressed()
//                }
//                else /* Right */
//                {
//                    idAppMain.dmbSeekNextKeyPressed()
//                }
            }

            onSetTuneKeyPressed:{
                if(idAppMain.state == "AppDmbPlayerOptionMenu")
                {
                    EngineListener.moveGoToMainScreen()
                }

                if(presetEditEnabled == true)
                {
                    EngineListener.selectOptionMenuByIndex(3/*Back in Move Channel menu */);
                }

                if(tuneType == 0 /* Left */)
                {
                    idAppMain.dmbTuneLeftKeyPressed()
                }
                else /* Right */
                {
                    idAppMain.dmbTuneRightKeyPressed()
                }
            }

            onSetRearMainScreen:{
                if(UIListener.getCurrentScreen() == 1)
                    EngineListener.setAppPlayerState(idDmbPlayer.state);
            }
        }
    }

    Connections{
        target: UIListener
        onBgReceived:{
//            console.debug("[QML]----------------------------------- [onBgReceived] : EngineListener.m_ScreentSettingMode = " + EngineListener.m_ScreentSettingMode)
//DaeHyung 2013.01.09 ISV 67556 Fixed Start
//            if(!EngineListener.m_ScreentSettingMode)
//            {
//                EngineListener.onGstStop()
//                idDmbPlayerMain.Hide()
//            } // End if
//DaeHyung 2013.01.09 ISV 67556 Fixed End
        }
    }
}
