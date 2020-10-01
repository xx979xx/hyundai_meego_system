import QtQuick 1.0

import "../Component" as MComp

MComp.MComponent{
    id:idDelNaviPersistPopUp
    x: 0; y: 93
    width: 1280; height: 720 - 93
    focus:true
    property alias deleteNaviPopup:idENGDeleteNaviPopUp.visible
    MComp.MPopUpTypeText{
        id: idENGDeleteNaviPopUp
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 1
        popupFirstText: "Delete Navi Persistence ?"

        // Btn Info
        popupBtnCnt: 2
        popupFirstBtnText: "OK"
        popupSecondBtnText: "Cancel"


        onVisibleChanged: {
            if(visible)idENGDeleteNaviPopUp.focus = true;
        }

        // onBtn0Click
        onPopupFirstBtnClicked: {
            naviSystemConfig.Send_PersistDB_SIGNAL();
            idENGDeleteNaviPopUp.visible = false
            idDlgDeleteNavi.visible = true
        }
        // onBtn1Click
        onPopupSecondBtnClicked:{
            idENGDeleteNaviPopUp.visible = false
            idENGDelNaviPopUp.visible = false
        }


    }

//    MComp.MMsgPopup{
//        id:idENGDeleteNaviPopUp
////        y:0; z:100
//        visible: false
//        onVisibleChanged: { if(visible)idENGDeleteNaviPopUp.focus = true;}
//        popupName: "Delete Navi Persistence"
//        msgModel: ListModel{
//            ListElement{ msgName:"Delete Navi Persistence ?"; }
//        }
//        btnModel: ListModel{
//            ListElement {   btnName: "OK";  }
//            ListElement {   btnName:    "CANCEL";   }
//        }
//        onBtn0Click: {
//            naviSystemConfig.Send_PersistDB_SIGNAL();
//            idENGDeleteNaviPopUp.visible = false
//            idDlgDeleteNavi.visible = true
//        }
//        onBtn1Click:{
//            idENGDeleteNaviPopUp.visible = false
//            idENGDelNaviPopUp.visible = false
//        }
//    }
    MComp.DimPopUp{
        id:idDlgDeleteNavi
        textLineCount: 1
        loadingFlag: false
        firstText: "Emitted Delete Navi Persistence."
        visible: false
        onVisibleChanged: { if(visible)idTimerDeleteNavi.start()    }

    }
    Timer{
        id:idTimerDeleteNavi
        interval: 1000
        repeat:false
        onTriggered:
        {
            idDlgDeleteNavi.visible = false

            idENGDelNaviPopUp.visible = false

        }
    }
}
