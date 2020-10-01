import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MPopupTypeText{
    id: idPopupDisasterDeleteConfirm
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    // Msg Info
    popupLineCnt : 1
    popupFirstText: stringInfo.strPOPUP_DisasterInfoDeleteConfirm

    // Btn Info
    popupBtnCnt: 2
    popupFirstBtnText: stringInfo.strPOPUP_BUTTON_Yes
    popupSecondBtnText: stringInfo.strPOPUP_BUTTON_No

    // onBtn0Click
    onPopupFirstBtnClicked: {
        //Do Delete!!
//        console.debug("deleteKey = ", deleteKey)
        if(deleteKey == ""){
            MDmbOperation.CmdReqAMASMessageDelete()
        }
        else{
            MDmbOperation.CmdReqAMASMessageDelete(deleteKey)
        }

        if(EngineListener.getDRSShowStatus() == false)
        {
            //gotoBackScreen()
            setAppMainScreen("PopupDeleted", false)
        }
        else
        {
            EngineListener.selectDisasterDeletePopup(0);
        }
    }
    // onBtn1Click
    onPopupSecondBtnClicked:{
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
            deleteKey = disasterId
        }
    }

}
