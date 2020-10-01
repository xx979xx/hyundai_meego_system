import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MBand{
    id:idDmbDisasterBand

    // # Title Info
    titleText: stringInfo.strDmbDis_Title //title Label Text input

    // # Menu Info
    menuBtnFlag: true
    menuBtnText: "Menu"
    //menuBtnText: "MENU"
    //menuBtnText: stringInfo.strDmbBand_Menu
    onMenuBtnClicked: {
        idDmbDisasterMain.disInfoList.forceActiveFocus()
        //idDmbDisasterMain.disInfoList.currentIndex = 0;
        EngineListener.selectOptionMenuByIndex(9/*LongKey Cancel*/);
        EngineListener.m_bJogUpkeyLongPressed = false;
        EngineListener.m_bJogDownkeyLongPressed = false;

        setAppMainScreen("AppDmbDisasterOptionMenu", true);
    }
    menuBtnEnabledFlag: (MDmbOperation.CmdReqAMASMessageRowCount() == 0) ? false : true

    // # Back Info
    onBackBtnClicked:
    {
        EngineListener.setShowOSDFrontRear(false);
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.m_bJogUpkeyLongPressed = false;
            EngineListener.m_bJogDownkeyLongPressed = false;
            EngineListener.selectDisasterEvent(0/*List - Back*/)
        }
    }

    onActiveFocusChanged: {
        if(idDmbDisasterBand.activeFocus == true)
            idDmbDisasterMain.disasterMainLastFocusId = "idDmbDisasterBand";
    }

    Connections{
        target: idAppMain
        onDisasterListCountChanged:{
            if(MDmbOperation.CmdReqAMASMessageRowCount() == 0)
                menuBtnEnabledFlag = false
            else
                menuBtnEnabledFlag = true
        }
    }
}

