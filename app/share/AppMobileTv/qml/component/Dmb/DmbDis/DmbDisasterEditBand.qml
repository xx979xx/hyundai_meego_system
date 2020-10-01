import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MBand{
    id:idDmbDisasterEditBand

    property int disasterEditTextHeight: idDmbDisasterEditBand.titleTextHeight
    property int disasterEditTextSize: idDmbDisasterEditBand.titleTextSize
    property string disasterEditTextStyle: idDmbDisasterEditBand.titleTextStyle
    property string disasterEditTextVerticalAlies: idDmbDisasterEditBand.titleTextVerticalAlies
    property string disasterEditTextHorizontalAlies: idDmbDisasterEditBand.titleTextHorizontalAlies

    // # Title Info
    titleText: stringInfo.strDmbDis_Title_Delete

    // # Title Small Info
    titleTextSmallFlag: true
    titleTextSmall: "(" + CommParser.m_iAMACheckCount  + ")"

    // # Menu Info
    menuBtnFlag: true
    menuBtnText: "Menu"
    //menuBtnText: "MENU"
    //menuBtnText: stringInfo.strDmbBand_Menu
    onMenuBtnClicked:{
        if(MDmbOperation.CmdReqAMASMessageRowCount() != 0)
        {
            EngineListener.selectOptionMenuByIndex(9/*LongKey Cancel*/);
            EngineListener.m_bJogUpkeyLongPressed = false;
            EngineListener.m_bJogDownkeyLongPressed = false;
            idDmbDisasterEdit.disCheckList.forceActiveFocus();
            //idDmbDisasterEdit.disCheckList.currentIndex = 0;
        }
        setAppMainScreen("AppDmbDisasterEditOptionMenu", true);
    }

    // # Back Info
    onBackBtnClicked:{
        MDmbOperation.CmdReqAMASMessageUnseleteAll()
        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.m_bJogUpkeyLongPressed = false;
            EngineListener.m_bJogDownkeyLongPressed = false;
            EngineListener.selectDisasterEvent(1/*Ch List - Back*/)
        }
    }

    onActiveFocusChanged: {
        if(idDmbDisasterEditBand.activeFocus == true)
            idDmbDisasterEdit.disasterEditLastFocusId = "idDmbDisasterEditBand";
    }

    Connections{
        target: CommParser
        onAMACheckCountChanged:{
            titleTextSmall = "(" + CommParser.m_iAMACheckCount  + ")"
        }
    }

    Connections{
        target: EngineListener
        onRetranslateUi: titleText = stringInfo.strDmbDis_Title_Delete// + titleTextSmall
    }
}
