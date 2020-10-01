import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MPopupTypeText{
    id: idPopupDisasterDeleteAllConfirm//idPopupDisasterDeleteConfirm
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    // Msg Info
    popupLineCnt : 1
    popupFirstText: stringInfo.strPOPUP_DisasterInfoDeleteAllConfirm

    // Btn Info
    popupBtnCnt: 2
    popupFirstBtnText: stringInfo.strPOPUP_BUTTON_Yes
    popupSecondBtnText: stringInfo.strPOPUP_BUTTON_No

    // onBtn0Click
    onPopupFirstBtnClicked: {

        //MDmbOperation.CmdReqAMASMessageDelete()
        MDmbOperation.cmdReqAMASMessageDeleteAll();
        EngineListener.selectOptionMenuByIndex(6/*Back */);
        EngineListener.selectDisasterDeletePopup(0);

    }
    // onBtn1Click
    onPopupSecondBtnClicked: {
        //MDmbOperation.CmdReqAMASMessageUnseleteAll()
        MDmbOperation.cmdReqAMASMessageCancelDeleteAll();
        disasterMsgUnselectAll()

        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(6/*Back */);
        }
    }

    //onPopupBgClicked : gotoBackScreen()
    onBackKeyPressed: {
        //MDmbOperation.CmdReqAMASMessageUnseleteAll()
        MDmbOperation.cmdReqAMASMessageCancelDeleteAll();
        disasterMsgUnselectAll()

        if(EngineListener.getDRSShowStatus() == false)
        {
            gotoBackScreen()
        }
        else
        {
            EngineListener.selectOptionMenuByIndex(6/*Back */);
        }
    }
    onHomeKeyPressed: EngineListener.HandleHomeKey();

    onSeekPrevKeyReleased:  { idAppMain.dmbSeekPrevKeyPressed()  }
    onSeekNextKeyReleased:  { idAppMain.dmbSeekNextKeyPressed()  }
    onTuneLeftKeyPressed:  { idAppMain.dmbTuneLeftKeyPressed()  }
    onTuneRightKeyPressed: { idAppMain.dmbTuneRightKeyPressed() }

    property string deleteKey : ""

    Connections{
        target: idAppMain
        onShowDisasterMessage:{
            deleteKey = disasterId;
        }
    }

}
