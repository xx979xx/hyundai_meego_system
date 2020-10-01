import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MPopupTypeText{
    id: idPopupChannelDeleteConfirm
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    // Msg Info
    popupLineCnt : 1
    popupFirstText: stringInfo.strPOPUP_ChannelDeletedConfrim

    // Btn Info
    popupBtnCnt: 2
    popupFirstBtnText: stringInfo.strPOPUP_BUTTON_Yes
    popupSecondBtnText: stringInfo.strPOPUP_BUTTON_No


    onVisibleChanged: {
        if(idPopupChannelDeleteConfirm.visible == true)
        {
            idAppMain.isPopUpShow = true;
        }
        else
        {
            idAppMain.isPopUpShow = false;
        }
    }

    Component.onCompleted:{
        idAppMain.isPopUpShow = true;
    }

    // onBtn0Click
    onPopupFirstBtnClicked: {
        //Do Delete!!
        MDmbOperation.CmdReqPresetDelete(CommParser.m_iPresetListIndex)
        EngineListener.selectOptionMenuByIndex(1);
    }
    // onBtn1Click
    onPopupSecondBtnClicked:{
        EngineListener.selectOptionMenuByIndex(6/*Back */);
    }

    //onPopupBgClicked : gotoBackScreen()
    onBackKeyPressed: {
        EngineListener.selectOptionMenuByIndex(6/*Back */);
    }
    onHomeKeyPressed: EngineListener.HandleHomeKey();

    onSeekPrevKeyReleased: {
        EngineListener.selectOptionMenuByIndex(6/*Back */);
        idAppMain.dmbSeekPrevKeyPressed()
    }

    onSeekNextKeyReleased: {
        EngineListener.selectOptionMenuByIndex(6/*Back */);
        idAppMain.dmbSeekNextKeyPressed()
    }

    onTuneLeftKeyPressed: {
        EngineListener.selectOptionMenuByIndex(6/*Back */);
        idAppMain.dmbTuneLeftKeyPressed()
    }
    onTuneRightKeyPressed: {
        EngineListener.selectOptionMenuByIndex(6/*Back */);
        idAppMain.dmbTuneRightKeyPressed()
    }
}
