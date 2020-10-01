import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeText{
    id: idPopupListEmpty
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    // Msg Info
    popupLineCnt : 2
    popupFirstText: stringInfo.strPOPUP_SearchAgain1
    popupSecondText: stringInfo.strPOPUP_SearchAgain2

    // Btn Info
    popupBtnCnt: 2
    popupFirstBtnText: stringInfo.strPOPUP_BUTTON_Yes
    popupSecondBtnText: stringInfo.strPOPUP_BUTTON_No

    // onBtn0Click
    onPopupFirstBtnClicked: {
        EngineListener.setPopupSearching()
    }
    // onBtn1Click
    onPopupSecondBtnClicked:{
//        if(EngineListener.getDRSShowStatus() == false)
//        {
//            gotoBackScreen();
//        }
//        else
//        {
//            EngineListener.selectOptionMenuByIndex(6);
//        }
        EngineListener.moveToRadio();
    }


    //onPopupBgClicked : gotoBackScreen()
    onBackKeyPressed:{
//        if(EngineListener.getDRSShowStatus() == false)
//        {
//            gotoBackScreen();
//        }
//        else
//        {
//            EngineListener.selectOptionMenuByIndex(6);
//        }
        EngineListener.moveToRadio();
    }

    onHomeKeyPressed: EngineListener.HandleHomeKey();


}

