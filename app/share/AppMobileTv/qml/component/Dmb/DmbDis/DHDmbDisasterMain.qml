import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation
import QmlStatusBar 1.0

MComp.MComponent {
    id: idDmbDisasterMain
    x:0; y:0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderXMData : imageInfo.imgFolderXMData
    property string imgFolderMusic: imageInfo.imgFolderMusic
    property string imgFolderDmb: imageInfo.imgFolderDmb
    property QtObject disInfoList : idDmbDisasterList.disInfoView
    property int dmbDisasterSortTypeindex : 0
    property string dmbDisasterSortType : stringInfo.strDmbDis_Tab_SortType_Time
    property string disasterMainLastFocusId: (disInfoList.count > 0) ? "idDmbDisasterList" : "idDmbDisasterTabView"

    Image { source: imgFolderGeneral + "bg_main.png" }

    QmlStatusBar{
        id: statusBarDisaser
        x: 0
        y: 0-systemInfo.statusBarHeight
        width: 1280
        height: systemInfo.statusBarHeight
        homeType:"button"
        middleEast: false
        visible:true
    }

    FocusScope{
        id: idDmbDisasterListArea
        x:0; y:idDmbDisasterBand.height
        width: systemInfo.lcdWidth
        height: systemInfo.contentAreaHeight	
        focus: true
        KeyNavigation.up: idDmbDisasterBand

        //---------------------------------------- DmbDisasterBand
        DmbDisasterBand{
            id:idDmbDisasterBand
            y: 0-idDmbDisasterBand.height
            KeyNavigation.down: (disInfoList.count > 0) ? idDmbDisasterList : idDmbDisasterTabView
        } // End MDmb.DmbDisasterBand
        //------------------------------ DmbDisasterTabView
        DmbDisasterTabView{
            id: idDmbDisasterTabView
            width:267;
            focus: (disInfoList.count <= 0) ? true : false
	    
            KeyNavigation.right: (disInfoList.count > 0) ? idDmbDisasterList : idDmbDisasterTabView
        } // End FocusScope

        //------------------------------ DmbDisasterListView
        DmbDisasterListView {
            id : idDmbDisasterList
            x: 287;
            width: systemInfo.lcdWidth - 287
            height: systemInfo.contentAreaHeight
            focus: (disInfoList.count > 0) ? true : false
            visible: (disInfoList.count > 0) ? true : false

            KeyNavigation.left: idDmbDisasterTabView
        } // End DmbDisasterListView

        //------------------------------ DmbDisasterListEmpty
        DmbDisasterListEmpty {
            id : idDmbDisasterListEmpty
            x: idDmbDisasterTabView.width-6;
            width: systemInfo.lcdWidth - 287
            height: systemInfo.contentAreaHeight
            //focus: (disInfoList.count > 0) ? false : true
            visible: (disInfoList.count > 0) ? false : true

            KeyNavigation.left: idDmbDisasterTabView
        } // End DmbDisasterListEmpty
    } // End FocusScope

//    onActiveFocusChanged:{
//        if(activeFocus == false)
//        {
//            idDmbDisasterList.disInfoView.interactive = false;
//            mouseExit();
//        }
//        else
//        {
//            idDmbDisasterList.disInfoView.interactive = true;
//        }
//    }

    onVisibleChanged: {
        if(!visible)
            idDmbDisasterList.disInfoView.currentIndex = 0;
    }

    onClickMenuKey: {
        if(MDmbOperation.CmdReqAMASMessageRowCount() == 0) return;
        idDmbDisasterList.forceActiveFocus();
        //idDmbDisasterList.disInfoView.currentIndex = 0;
        setAppMainScreen("AppDmbDisasterOptionMenu", true);
    }
    onBackKeyPressed: {
        EngineListener.setShowOSDFrontRear(false);
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectDisasterEvent(0/*List - Back*/)
        }

    }

    Component.onCompleted: {
        if(disInfoList.count > 0)
            MDmbOperation.CmdReqAMASMessageSort("time");
    }

    Connections{
        target:EngineListener
        onSetDisasterDeletePopup:{
            if(index == 0)
            {
                setAppMainScreen("PopupDeleted", false)
            }
        }

        onSetDisasterEvent:{
//            console.debug("[QML]=========== onSetDisasterEvent :: index = "+ index);
            if(index == 0/*List - Back*/)
            {
                idAppMain.gotoMainScreen()
            }
            else if(index == 2/*List - OptionMenu*/)
            {
                if(idAppMain.state == "AppDmbDisasterOptionMenu")
                {
                    idAppMain.gotoBackScreen()
                    idAppMain.setAppMainScreen("AppDmbDisaterListEdit", true);
                }
                else
                {
                    idAppMain.setAppMainScreen("AppDmbDisaterListEdit", true);
                }
            }

//            if(index == 0/*List - Back*/)
//            {
//                gotoMainScreen()
//            }
//            else if( (index == 1/*Ch List - Back*/) || (index == 3/*Ck List - OptionMenu*/) )
//            {
//                gotoDisaterListScreen()
//            }
//            else if(index == 2/*List - OptionMenu*/)
//            {
//                if(idAppMain.state == "AppDmbDisasterOptionMenu")
//                {
//                    gotoBackScreen()
//                    setAppMainScreen("AppDmbDisaterListEdit", true);
//                }
//                else
//                {
//                    setAppMainScreen("AppDmbDisaterListEdit", true);
//                }
//            }
        }

        onDmbReqPreForeground:{
            if(idAppMain.state != "AppDmbDisaterList")
                return;

            var target = EngineListener.getTargetScreen();
            var bSwap = EngineListener.getIswapEnabled();
            var lastButtonId = "";


            if(bSwap)
            {
                if(UIListener.getCurrentScreen() != target)
                {
                    if(idDmbDisasterMain.disasterMainLastFocusId == "idDmbDisasterTabView"){
                        lastButtonId = idDmbDisasterTabView.getFocusLastPosition();
                    }else if(idDmbDisasterMain.disasterMainLastFocusId == "idDmbDisasterBand"){
                        lastButtonId = idDmbDisasterBand.getFocusLastPosition();
                    }

                    EngineListener.saveDisasterMainLastFocusId(idDmbDisasterMain.disasterMainLastFocusId, lastButtonId);
                }
            }

        }

        onDmbReqForeground:{
            if(idAppMain.state != "AppDmbDisaterList")
                return;

            var target = EngineListener.getTargetScreen();
            var bSwap = EngineListener.getIswapEnabled();

            var lastFocusId = EngineListener.getDisasterMainLastFocusId();
            var lastButtonId = EngineListener.getDisasterMainLastButtonId();

            if(bSwap)
            {
                if(UIListener.getCurrentScreen() == EngineListener.getTargetScreen())
                {
                    if(lastFocusId == "idDmbDisasterTabView"){
                        idDmbDisasterTabView.focus = true;
                        idDmbDisasterTabView.syncLastFocusPosition(lastButtonId);
                    }else if(lastFocusId == "idDmbDisasterBand"){
                        idDmbDisasterBand.focus = true;
                        idDmbDisasterBand.syncLastFocusPosition(lastButtonId);
                    }else{
                        if(disInfoList.count > 0){
                            idDmbDisasterList.focus = true;
                        }else{
                            idDmbDisasterTabView.focus = true;
                            idDmbDisasterTabView.syncLastFocusPosition(lastButtonId);
                        }
                    }
                }
            }

        }

    }

    Connections{
        target:CommParser
        //onAmasReceived:{
        onEwsReceived:{
            if(disInfoList.count > 0){
                if(dmbDisasterSortTypeindex == 1)
                    MDmbOperation.CmdReqAMASMessageSort("area");
                else if(dmbDisasterSortTypeindex == 2)
                    MDmbOperation.CmdReqAMASMessageSort("priority");
                else
                    MDmbOperation.CmdReqAMASMessageSort("time");
            }

        }

        onDeleteAMASMessage:{
//            console.log("[QML][onDeleteAMASMessage]================")
//            console.log("[QML] idAppMain.state : " + idAppMain.state)
//            console.log("[QML] idDmbDisasterList.disInfoView.count : " + idDmbDisasterList.disInfoView.count)
//            console.log("[QML] idDmbDisasterList.disInfoView.currentIndex : " + idDmbDisasterList.disInfoView.currentIndex)
//            console.log("[QML] idDmbDisasterMain.focus : " + idDmbDisasterMain.focus)
//            console.log("[QML] idDmbDisasterBand.focus : " + idDmbDisasterBand.focus)
//            console.log("[QML] idDmbDisasterListEmpty.focus : " + idDmbDisasterListEmpty.focus)
//            console.log("[QML] idDmbDisasterList.focus : " + idDmbDisasterList.focus)
//            console.log("[QML] idDmbDisasterList.disInfoView.focus : " + idDmbDisasterList.disInfoView.focus)
//            console.log("[QML] idDmbDisasterTabView.focus : " + idDmbDisasterTabView.focus)
//            console.log("[QML] idDmbDisasterTabView.dispInfoTapListView.focus : " + idDmbDisasterTabView.dispInfoTapListView.focus)

            if(idAppMain.state == "AppDmbDisaterList"){
                if(idDmbDisasterList.disInfoView.count > 0){
                    idDmbDisasterList.disInfoView.currentIndex = 0;
                    idDmbDisasterList.disInfoView.focus = true;
                    idDmbDisasterList.disInfoView.forceActiveFocus();
                    idDmbDisasterList.disInfoView.positionViewAtIndex (idDmbDisasterList.disInfoView.currentIndex, ListView.Center);
                } else {
                    idDmbDisasterList.focus = false;
                    idDmbDisasterTabView.focus = true;
                    idDmbDisasterTabView.dispInfoTapListView.forceActiveFocus();
                }
            }

        }
    }

    onSeekPrevKeyReleased:  { idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  { idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  { idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: { idAppMain.dmbTuneRightKeyPressed() }

    onTuneEnterKeyPressed:{

        if(idAppMain.state != "AppDmbDisaterList") return;

        //if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        if( EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == false && EngineListener.getShowOSDFrontRear() == true) )
        {
            EngineListener.SetExternal()
            return;
        }
    }

} // End FocusScope
