import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation
import QmlStatusBar 1.0

MComp.MComponent {
    id: idDmbDisasterEdit
    x:0; y:0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderMusic: imageInfo.imgFolderMusic
    property string imgFolderDmb: imageInfo.imgFolderDmb
    property QtObject disCheckList : idDmbDisasterCheckList.disCheckView
    property string disasterEditLastFocusId: (disCheckList.count > 0) ? "idDmbDisasterCheckList" : "idDisasterEditMode"

    //------------------------------ Dis Edit background
    Image { source: imgFolderGeneral + "bg_main.png" }
    QmlStatusBar{
        id: statusBarDisaserEdit
        x: 0
        y: 0-systemInfo.statusBarHeight
        width: 1280
        height: systemInfo.statusBarHeight
        homeType:"button"
        middleEast: false
        visible:true
    }

    FocusScope{
        id: idDmbDisasterEditArea
        x:0; y: systemInfo.titleAreaHeight
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight - y
        focus : true
        KeyNavigation.up: idDmbDisasterEditBand

                //------------------------------ DmbDisasterBand
        DmbDisasterEditBand{
            id:idDmbDisasterEditBand
            y: 0-systemInfo.titleAreaHeight
            KeyNavigation.down: (disCheckList.count > 0) ? idDmbDisasterCheckList : idDisasterEditMode
        }

        //------------------------------ DmbDisasterCheckList
        DmbDisasterCheckList{
            id : idDmbDisasterCheckList
            x: 0; //y:systemInfo.titleAreaHeight
            width: 1030; height: systemInfo.contentAreaHeight
            focus: (disCheckList.count > 0) ? true : false
            //        onWheelLeftKeyPressed:{ idDmbDisasterTabView.focus = true }
            //        onWheelRightKeyPressed:{ idDmbDisasterCheckList.focus = true }	    
            KeyNavigation.right: idDisasterEditMode
        } // End DmbDisasterCheckList

        //------------------------------ Disaster List Select/Cancel Button
        MComp.MEditMode{
            id: idDisasterEditMode
            width: parent.width-idDmbDisasterCheckList.width
            height: systemInfo.contentAreaHeight
            focus: (disCheckList.count == 0) ? true : false

            KeyNavigation.left: (disCheckList.count > 0) ? idDmbDisasterCheckList : idDisasterEditMode

            buttonNumber: 4
            buttonText1: stringInfo.strDmbDis_Edit_Delete
            buttonText2: stringInfo.strDmbDis_Edit_DeleteAll
            buttonText3: stringInfo.strDmbDis_Edit_UnselectAll
            buttonText4: stringInfo.strDmbDis_Edit_Cancel

            // Button Enabled, Disabled - by WSH
            buttonEnabled1: (CommParser.m_iAMACheckCount == 0) ? false:true;  //(!CommParser.m_bIsAMASUnseleteAll)  // More than one
            buttonEnabled2: true                                // Always on
            buttonEnabled3: (CommParser.m_iAMACheckCount == 0) ? false:true;  //(!CommParser.m_bIsAMASUnseleteAll)  // More than one
            buttonEnabled4: true                                // Always on

            onClickButton1: { //Delete
                //console.debug("------------------>>> onClickButton1")
//                disasterMsgDelete() //Must call disasterMsgDelete first!!

                MDmbOperation.CmdReqAMASMessageDelete()
                if(EngineListener.getDRSShowStatus() == false)
                {
                    setAppMainScreen("PopupDeleted", false)
                }
                else
                {
                    EngineListener.selectDisasterEditButtonMenu(0); /*Delete*/
                }
            }
            onClickButton2: { //Delete All
                //console.debug("------------------>>> onClickButton2")
                MDmbOperation.CmdReqAMASMessageSeleteAll()
                if(EngineListener.getDRSShowStatus() == false)
                {
//                    disasterMsgSelectAll()
                    setAppMainScreen("PopupDisasterDeleteAllConfirm", true)
                }
                else
                {
                   EngineListener.selectDisasterEditButtonMenu(1); /*Delete All */
                }
            }
            onClickButton3: { //Cancel All
                //console.debug("------------------>>> onClickButton3")
                MDmbOperation.CmdReqAMASMessageUnseleteAll()
                if(EngineListener.getDRSShowStatus() == false)
                {
                    //idDmbDisasterCheckList.disCheckView.forceActiveFocus() // Move to ListView # by WSH
                    //idDmbDisasterCheckList.disCheckView.currentIndex = 0;  // Movt to First Index # by WSH
//                    disasterMsgUnselectAll()
                    idDisasterEditMode.setFocusLastPosition()
                }
                else
                {
                    EngineListener.selectDisasterEditButtonMenu(2); /*Cancel All */
                }
            }
            onClickButton4: { //Cancel
                //console.debug("------------------>>> onClickButton4")
                CommParser.m_iAMACheckCount = 0;
                if(EngineListener.getDRSShowStatus() == false)
                {
                    idDisasterEditMode.setFocusLastPosition()
                    gotoBackScreen()
                }
                else
                {
                    EngineListener.selectDisasterEditButtonMenu(3); /*Cancel */
                    EngineListener.selectDisasterEvent(1/*Ck List - Back*/)
                }
            }

            Component.onCompleted:{
                // Button Enabled, Disabled - by WSH
                buttonEnabled1: (CommParser.m_iAMACheckCount == 0) ? false:true;  //(!CommParser.m_bIsAMASUnseleteAll)  // More than one
                buttonEnabled2: true                                // Always on
                buttonEnabled3: (CommParser.m_iAMACheckCount == 0) ? false:true;  //(!CommParser.m_bIsAMASUnseleteAll)  // More than one
                buttonEnabled4: true                                // Always on
            }

            onVisibleChanged: {               
                if(idDmbDisasterEdit.visible == true){
                    // Button Enabled, Disabled - by WSH
                    buttonEnabled1: (CommParser.m_iAMACheckCount == 0) ? false:true;  //(!CommParser.m_bIsAMASUnseleteAll)  // More than one
                    buttonEnabled2: true                                // Always on
                    buttonEnabled3: (CommParser.m_iAMACheckCount == 0) ? false:true;  //(!CommParser.m_bIsAMASUnseleteAll)  // More than one
                    buttonEnabled4: true                                // Always on
                }               
            }

            Keys.onUpPressed: {
                idDmbDisasterEditBand.focus = true;
                idDmbDisasterEditBand.focusMenuBtn();
                event.accepted = true;
            }

            Keys.onDownPressed: {
                event.accepted = true;
            }

            onActiveFocusChanged: {
                if(idDisasterEditMode.activeFocus == true)
                    idDmbDisasterEdit.disasterEditLastFocusId = "idDisasterEditMode";
            }

        } // End MEditMode
    } // End FocusScope

    onClickMenuKey:{

        if(MDmbOperation.CmdReqAMASMessageRowCount() != 0)
        {
            idDmbDisasterCheckList.disCheckView.forceActiveFocus()
            //idDmbDisasterCheckList.disCheckView.currentIndex = 0;
        }
        setAppMainScreen("AppDmbDisasterEditOptionMenu", true);
    }

//    onActiveFocusChanged:{
//        if(activeFocus == false)
//        {
//            idDmbDisasterCheckList.disCheckView.interactive = false;
//            mouseExit();
//        }
//        else
//        {
//            idDmbDisasterCheckList.disCheckView.interactive = true;
//        }
//    }

    onBackKeyPressed:{
        MDmbOperation.CmdReqAMASMessageUnseleteAll()
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectDisasterEvent(1/*Ck List - Back*/)
        }
    }

    // Set initialization of list # by WSH(121109)
    Component.onCompleted:{
        disasterMsgUnselectAll()
        MDmbOperation.CmdReqAMASMessageUnseleteAll();
    }
    onVisibleChanged: {
        if(idDmbDisasterEdit.visible == true){
            //MDmbOperation.CmdReqAMASMessageUnseleteAll() //# UnSelectAll - KEH (20130305)
            disasterMsgUnselectAll()

            if(MDmbOperation.CmdReqAMASMessageRowCount() > 0)
            {
                idDmbDisasterCheckList.disCheckView.forceActiveFocus();
                idDmbDisasterCheckList.disCheckView.currentIndex = 0;
            }
        }else{
            MDmbOperation.CmdReqAMASMessageUnseleteAll();
        }
    }

    Connections{
        target:EngineListener

        onSetDisasterEvent:{
            if(idAppMain.state == "AppDmbDisasterEditOptionMenu"){
                idAppMain.signalHideOptionMenu();
            }

            if( index == 1/*Ck List - Back*/)
            {
                idAppMain.gotoBackScreen()
            }
            else if( index == 3/*Ck List - OptionMenu*/ )
            {
                idAppMain.gotoBackScreen();
            }
        }

        onSetDisasterEditButtonMenu:{

            if(menuIndex == 0 /*Delete */)
            {
                setAppMainScreen("PopupDeleted", false);
            }
            else if(menuIndex == 1  /*Delete All */)
            {
                disasterMsgSelectAll();
                idDisasterEditMode.setFocusLastPosition()
                idDmbDisasterCheckList.disCheckView.forceActiveFocus()
                setAppMainScreen("PopupDisasterDeleteAllConfirm", true);
            }
            else if(menuIndex == 2  /*Cancel All */)
            {
                //idDmbDisasterCheckList.disCheckView.forceActiveFocus() // Move to ListView # by WSH
                //idDmbDisasterCheckList.disCheckView.currentIndex = 0;  // Movt to First Index # by WSH
                disasterMsgUnselectAll()
                idDisasterEditMode.setFocusLastPosition()
                idDmbDisasterCheckList.disCheckView.forceActiveFocus()
            }
            else if(menuIndex == 3  /*Cancel */)
            {
                if(idAppMain.state == "AppDmbDisasterEditOptionMenu"){
                    gotoBackScreen();
                    idAppMain.setAppMainScreen("AppDmbDisaterListEdit", true);
                }
                //EngineListener.selectDisasterEvent(1/*Ck List - Back*/)
                //gotoBackScreen();
            }
        }

        onDmbReqPreForeground:{
            if(idAppMain.state != "AppDmbDisaterListEdit")
                return;

            var target = EngineListener.getTargetScreen();
            var bSwap = EngineListener.getIswapEnabled();
            var lastButtonId = "";


            if(bSwap)
            {
                if(UIListener.getCurrentScreen() != target)
                {
                    if(idDmbDisasterEdit.disasterEditLastFocusId == "idDisasterEditMode"){
                        lastButtonId = idDisasterEditMode.getFocusLastPosition();
                    }else if(idDmbDisasterEdit.disasterEditLastFocusId == "idDmbDisasterEditBand"){
                        lastButtonId = idDmbDisasterEditBand.getFocusLastPosition();
                    }

                    EngineListener.saveDisasterEditLastFocusId(idDmbDisasterEdit.disasterEditLastFocusId, lastButtonId);
                }
            }

        }

        onDmbReqForeground:{
            if(idAppMain.state != "AppDmbDisaterListEdit")
                return;

            var target = EngineListener.getTargetScreen();
            var bSwap = EngineListener.getIswapEnabled();

            var lastFocusId = EngineListener.getDisasterEditLastFocusId();
            var lastButtonId = EngineListener.getDisasterEditLastButtonId();

            if(bSwap)
            {
                if(UIListener.getCurrentScreen() == EngineListener.getTargetScreen())
                {
                    if(lastFocusId == "idDisasterEditMode"){
                        idDisasterEditMode.focus = true;
                        idDisasterEditMode.syncLastFocusPosition(lastButtonId);
                    }else if(lastFocusId == "idDmbDisasterEditBand"){
                        idDmbDisasterEditBand.focus = true;
                        idDmbDisasterEditBand.syncLastFocusPosition(lastButtonId);
                    }else{
                        idDmbDisasterCheckList.focus = true;
                    }
                }
            }
        }
    }

    onSeekPrevKeyReleased:  { idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  { idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  { idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: { idAppMain.dmbTuneRightKeyPressed() }

    onTuneEnterKeyPressed:{

        if(idAppMain.state != "AppDmbDisaterListEdit") return;

        //if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        if( EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == false && EngineListener.getShowOSDFrontRear() == true) )
        {
            EngineListener.SetExternal()
            return;
        }
    }

} // End MComponent
