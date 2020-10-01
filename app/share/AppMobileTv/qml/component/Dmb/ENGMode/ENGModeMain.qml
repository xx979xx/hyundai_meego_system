import Qt 4.7
import "../../QML/DH" as MComp
// WSH(130122)
//import AppEngineQMLConstants 1.0
//import Transparency 1.0
import QmlStatusBar 1.0
//Dmb EngineerMode
// WSH(130122)
//Transparency {
    MComp.MComponent {
        id:idDmbENGModeMain
        x:0; y:0
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true

        property string imgFolderGeneral : imageInfo.imgFolderGeneral
        property string imgFolderDmb: imageInfo.imgFolderDmb

        property string currentName : CommParser.m_iPresetListIndex < 0 ? "" : idAppMain.presetListModel.get(CommParser.m_iPresetListIndex,39)

        property bool screenBlack: idAppMain.drivingRestriction

        property string lastFocusId : "idENDModeListView"

        QmlStatusBar{
            id: statusBarEng
            x: 0
            y: 0-93
            width: 1280
            height: systemInfo.statusBarHeight
            homeType:"button"
            middleEast: false
            visible:true
        }


        ENGModeRestrictionDriving{
            id: idEngDrsView
            visible: idAppMain.drivingRestriction
        }

        FocusScope{
            id: idDmbENGModeMainArea
            x:parent.x; y: parent.y
            width: parent.width
            height: parent.height
            focus: true
            //KeyNavigation.up: idENGModeBand
            //**************************************** Band
            MComp.MBand{
                id:idENGModeBand
                x: 0; y: 0
                titleText: (idAppMain.isDealerMode == true) ? "Dealer Mode" : "Engineering Mode"
                onBackBtnClicked:{
    //                CommParser.onDebugModeOff();
                    if(idAppMain.inputModeDMB == "touch")
                    {
                        EngineListener.setTouchBackKey(true)
                    }
                    else
                    {
                        EngineListener.setTouchBackKey(false)
                    }
                    EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
                }
//                KeyNavigation.down: idDmbENGModeRight
                Keys.onDownPressed: {

                    if(idDmbENGModeMain.lastFocusId == "idDmbENGModeRight"){
                        idDmbENGModeRight.focus = true;
                    }else if(idDmbENGModeMain.lastFocusId == "idENDModeListView"){
                        idENDModeListView.focus = true;
                    }else{
                        idENDModeListView.focus = true;
                    }

                    event.accepted = true;
                }
            }

            //**************************************** Data ListView
            ENGModeListView{
                id: idENDModeListView
                x: 0; y: 176-systemInfo.statusBarHeight
                //focus: true
//                KeyNavigation.right: idDmbENGModeRight
//                KeyNavigation.up: idENGModeBand
                Keys.onUpPressed: {
                    idDmbENGModeMain.lastFocusId = "idENDModeListView";
                    idENGModeBand.focus = true;
                    idENGModeBand.focusBackBtn();
                    event.accepted = true;
                }

                Keys.onDownPressed: {
                    event.accepted = true;
                }
                Keys.onLeftPressed: {
                    event.accepted = true;
                }
                Keys.onRightPressed: {
                    idDmbENGModeRight.focus = true;
                    event.accepted = true;
                }
            }
            //------------------------------ ENGModeInfo #
            ENGModeInfo{
                id: idENGModeInfo
                x : 521; y: 166-systemInfo.statusBarHeight ; z: 1
                width: systemInfo.lcdWidth - 521 - 250 // 1280-521-250 =509
                height: 554
            }
            //------------------------------ ENGModeRight(Button) #
            ENGModeRight{
                id: idDmbENGModeRight
                focus: true
                KeyNavigation.left: idENDModeListView
                Keys.onUpPressed: {
                    idDmbENGModeMain.lastFocusId = "idDmbENGModeRight";
                    idENGModeBand.focus = true;
                    idENGModeBand.focusBackBtn();
                    event.accepted = true;
                }

                Keys.onDownPressed: {
                    event.accepted = true;
                }
//                KeyNavigation.up: idENGModeBand
            }
        }

        //------------------------------ Click Event(Change State) #
        // WSH(130122) ====================== START
        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                if(idDmbENGModeMain.state == "ENGOn"){
                    DmbPlayer.m_iScreenSizeMode = 3
                    EngineListener.updateScreenSizeByOptionMenu()
                    idDmbENGModeMain.state="ENGOff"
                    idENGModeInfo.forceActiveFocus();

                }
                else if(idDmbENGModeMain.state == "ENGOff"){
                    DmbPlayer.m_iScreenSizeMode = 0
                    EngineListener.updateScreenSizeByOptionMenu()
                    idDmbENGModeMain.state="ENGOn"
                    if(CommParser.m_iPresetListIndex < 0)
                    {
                        idDmbENGModeRight.focus = true;
                        idDmbENGModeRight.forceActiveFocus();
                    }else{
                        idENDModeListView.focus = true;
                        idENDModeListView.forceActiveFocus();
                    }
               // EngineListener.HandleStatusBarHide(UIListener.getCurrentScreen());
//                console.debug("idDmbENGModeMain.state :",idDmbENGModeMain.state)
                }
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

        states: [
            State {
                name: "ENGOn"
                PropertyChanges { target: idENGModeBand; visible: true}
                PropertyChanges { target: idENDModeListView; visible: true}
                PropertyChanges { target: idENGModeInfo; visible: true}
                PropertyChanges { target: idDmbENGModeRight; visible: true}
                PropertyChanges { target: statusBarEng; visible: true}
                PropertyChanges {
                    target: idEngDrsView;
                    x:0; y: 0;
                    height: systemInfo.subMainHeight;
                    visible: idDmbENGModeMain.screenBlack ? true : false;
                } //"DrivingRestriction"
            },
            State {
                name: "ENGOff"
                PropertyChanges { target: idENGModeBand; visible: false}
                PropertyChanges { target: idENDModeListView; visible: false}
                PropertyChanges { target: idENGModeInfo; visible: true}
                PropertyChanges { target: idDmbENGModeRight; visible: false}
                PropertyChanges { target: statusBarEng; visible: false}
                PropertyChanges {
                    target: idEngDrsView;
                    x:0; y: 0-systemInfo.statusBarHeight;
                    height: systemInfo.lcdHeight_VEXT;
                    visible: idDmbENGModeMain.screenBlack ? true : false;
                } //"DrivingRestriction"
            }
        ]

        onBackKeyPressed: {
            if(idDmbENGModeMain.state == "ENGOff"){
                idDmbENGModeMain.state = "ENGOn";
                DmbPlayer.m_iScreenSizeMode = 0
                EngineListener.updateScreenSizeByOptionMenu()
//                idDmbENGModeRight.focus = true;
//                idDmbENGModeRight.forceActiveFocus();
                if(CommParser.m_iPresetListIndex < 0)
                {
                    idDmbENGModeRight.focus = true;
                    idDmbENGModeRight.forceActiveFocus();
                }else{
                    idENDModeListView.focus = true;
                    idENDModeListView.forceActiveFocus();
                }
            }else{
//                CommParser.onDebugModeOff();
//                EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
                EngineListener.HandleBackKey( UIListener.getCurrentScreen() );
            }
        }
//        onHomeKeyPressed:{
//            CommParser.onDebugModeOff();
//            EngineListener.HandleHomeKey( UIListener.getCurrentScreen() );
//        }

        onVisibleChanged: {
//            console.debug("-------------------------  [ENGMODE] onVisibleChanged  ")
            if(visible){
                // WSH(130122)
                idDmbENGModeMain.state="ENGOn"
                CommParser.onDebugModeOn();

                if(CommParser.m_iPresetListIndex < 0 || idDmbENGModeMain.lastFocusId == "idDmbENGModeRight")
                {
                    idDmbENGModeRight.focus = true;
                    idDmbENGModeRight.forceActiveFocus();
                }else{
                    idENDModeListView.focus = true;
                    idENDModeListView.forceActiveFocus();
                }

            }/*else{
                CommParser.onDebugModeOff();
            }*/
        }

        Component.onCompleted:{
//            console.debug("-------------------------  [ENGMODE] onCompleted ")
            if(visible){
                idDmbENGModeMain.state="ENGOn"
                CommParser.onDebugModeOn();
                if(CommParser.m_iPresetListIndex < 0)
                {
                    idDmbENGModeRight.focus = true;
                }else{
                    idENDModeListView.focus = true;
                }
            }
        }
        // WSH(130122) ====================== END

        Connections{
            target: EngineListener
            onSendDrsShowHide:{
//                console.log("[QML][ENGMode][onSendDrsShowHide] isShow : " + isShow);
                idDmbENGModeMain.screenBlack = isShow;
                idEngDrsView.visible = isShow;
            }
            onModeENGState:{
//                console.log("[QML][ENGMode][onModeENGState] engstate : " + engstate);
                if(engstate == false)
                {
                    if(idDmbENGModeMain.state == "ENGOff"){
                        DmbPlayer.m_iScreenSizeMode = 0;
                        EngineListener.updateScreenSizeByOptionMenu();
                    }
                }
            }

            onShowPopupSearchingEngMode:{

                idDmbENGModeMain.lastFocusId = "idDmbENGModeRight";

                setAppMainScreen("PopupSearching", true)
            }

        }

//        Connections{
//            target: EngineListener
//            onDmbReqBackgroundFromUISH:{
//                console.debug("-------------------------  [ENGMODE] onDmbReqBackgroundFromUISH ")
//                if(visible){
//                    CommParser.onDebugModeOff();
//                    gotoBackScreen()
//                }
//            }
//        }

    } // End MComponent
//} // End Transparency
