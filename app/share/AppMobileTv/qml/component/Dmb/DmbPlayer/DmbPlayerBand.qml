import Qt 4.7
import "../../../component/QML/DH" as MComp

//**************************************** Dmb Player Band
MComp.MBand{
    id: idDmbPlayerBand
    x: 0; y: 0
    menuBtnEnabledFlag: (idAppMain.presetEditEnabled == true) ? false : true

    titleText: stringInfo.strAppName // +" Edit" //title Label Text input

    menuBtnFlag: true
    menuBtnText: "Menu"
    //menuBtnText: "MENU"
    //menuBtnText: stringInfo.strDmbBand_Menu
    onMenuBtnClicked: {
//        console.debug("idDmbPlayerBand ======================== onMenuBtnClicked ")

        idDmbPlayerMain.playerList.forceActiveFocus();
        idAppMain.isPopUpShow = true;
        EngineListener.selectOptionMenuByIndex(9/*LongKey Cancel*/);
        EngineListener.m_bJogUpkeyLongPressed = false;
        EngineListener.m_bJogDownkeyLongPressed = false;

        if(idAppMain.isOnclickedByTouch == true){
            idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex);
            idAppMain.isOnclickedByTouch = false;
        }
        if(CommParser.m_bIsFullScreen == true)
        {
            CommParser.m_bIsFullScreen = false;
            setAppMainScreen("AppDmbPlayerOptionMenu", true);
        }
        else
        {
            setAppMainScreen("AppDmbPlayerOptionMenu", true);
        }
    }

    onBackBtnClicked: {
        //console.debug("### BackKey Clicked ###")

        // Preset Order - WSH(130205)
        if(presetEditEnabled == true) {


//            EngineListener.sendToClusterWhenAVChanged();
            if(EngineListener.getDRSShowStatus() == false)
            {
                presetEditEnabled = false
                idDmbPlayerMain.playerList.isDragStarted = false;
                idDmbPlayerMain.playerList.interactive = true;
                idDmbPlayerMain.playerList.itemInitWidth();
                idDmbPlayerMain.playerList.curIndex = -1;
                idDmbPlayerMain.playerList.insertedIndex = -1;
                idDmbPlayerMain.playerList.forceActiveFocus();

                //WSH
                if(playerList.count > 0) {
//                    console.log(" [QML] ====== > [DHDmbPlayerMain][onBackKeyPressed] playerLis.count =", idDmbPlayerMain.playerList.count)
                    idDmbPlayerMain.playerList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Center)
                } // End If
            }
            else
            {
                EngineListener.selectOptionMenuByIndex(9/*LongKey Cancel*/);
                EngineListener.m_bJogUpkeyLongPressed = false;
                EngineListener.m_bJogDownkeyLongPressed = false;
                EngineListener.selectOptionMenuByIndex(3/*Back in Move Channel menu */);
            }



        }else{ // None Preset Order

            if(CommParser.m_bIsFullScreen == true)
            {
                CommParser.m_bIsFullScreen = false;
            }
            else
            {
                if(idAppMain.inputModeDMB == "touch")
                {
                    EngineListener.setTouchBackKey(true)
                }
                else
                {
                    EngineListener.setTouchBackKey(false)
                }
                gotoBackScreen()
            }
        }
    }


    Connections{
        target: EngineListener
        onModeDRSChanged:{
            if( (CommParser.m_iPresetListIndex == -1) && (idAppMain.drivingRestriction == true) ) {
                idDmbPlayerBand.focusBackBtn()
            }
        }
    }

    Connections{
        target: CommParser

        onPresetListIndexChanged:{
            if(CommParser.m_iPresetListIndex == -1) //return;
            {
                idDmbPlayerBand.focus = true;
            }
        }
    }
}
