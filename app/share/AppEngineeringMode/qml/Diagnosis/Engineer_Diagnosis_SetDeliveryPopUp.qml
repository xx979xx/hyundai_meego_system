import QtQuick 1.0

import "../Component" as MComp

MComp.MComponent{
    id:idSetDeliveryPopUp
    x: 0; y: 93
    width: 1280; height: 720 - 93
    focus:true
    property alias setDeliveryPopup:idENGSetDeliveryPopUp.visible

    MComp.MPopUpTypeText{
        id: idENGSetDeliveryPopUp
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 1
        popupFirstText: "Start Factory Reset ?"

        // Btn Info
        popupBtnCnt: 2
        popupFirstBtnText: "OK"
        popupSecondBtnText: "Cancel"


        onVisibleChanged: {
            if(visible)idENGSetDeliveryPopUp.focus = true;
        }

        // onBtn0Click
        onPopupFirstBtnClicked: {
            UIListener.reqFactoryReset();
            idENGSetDeliveryPopUp.visible = false
            idDlgSetDelivery.visible = true
            UIListener.hideHomeStatusBar();
        }
        // onBtn1Click
        onPopupSecondBtnClicked:{
            idENGSetDeliveryPopUp.visible = false
            idENGSetDelPopUp.visible = false
        }


    }

    //    MComp.MMsgPopup{
    //        id:idENGSetDeliveryPopUp
    ////        y:0; z:100
    //        visible: false
    //        onVisibleChanged: { if(visible)idENGSetDeliveryPopUp.focus = true;}
    //        popupName: "Factory Reset"
    //        msgModel: ListModel{
    //            ListElement{ msgName:"Factory Reset ?"; }
    //        }
    //        btnModel: ListModel{
    //            ListElement {   btnName: "OK";  }
    //            ListElement {   btnName:    "CANCEL";   }
    //        }
    //        onBtn0Click: {
    ////            naviSystemConfig.Send_PersistDB_SIGNAL();
    //            UIListener.reqFactoryReset();
    //            idENGSetDeliveryPopUp.visible = false
    //            idDlgSetDelivery.visible = true
    //            UIListener.hideHomeStatusBar();
    //        }
    //        onBtn1Click:{
    //            idENGSetDeliveryPopUp.visible = false
    //            idENGSetDelPopUp.visible = false
    //        }
    //    }
    MComp.DimPopUp{
        id:idDlgSetDelivery
        textLineCount: 1
        loadingFlag: true
        firstText: "Emitted Factory Reset ..."
        visible: false
        onVisibleChanged: { /*if(visible)idTimerSetDelivery.start() */   }

    }



    MComp.MMsgPopup{
        id:idENGSetDeliveryFinPopUp
        //y:0; z:100
        visible: false
        onVisibleChanged: { if(visible)idTimerSetDelivery.start()}
        popupName: "Set Delivery Result"
        titleTextSize: 25
        msgModel: ListModel{
            id:factoryMsgModel
            ListElement{ msgName:"Factory Result"; }
            //ListElement{ msgName:"Factory FAIL"; }
        }

    }




    Connections
    {
        target:UIListener
        onStopSetDeliveryPopUp:{
            idDlgSetDelivery.visible = false
            factoryMsgModel.get(0).msgName = FactoryResult
            //factoryMsgModel.get(1).msgName = FactoryOK
            idENGSetDeliveryFinPopUp.visible = true;

            //idDlgSetDeliveryFin.firstText = FactoryFail;
        }
    }

    Timer{
        id:idTimerSetDelivery
        interval: 3000
        repeat:false
        onTriggered:
        {
            idENGSetDeliveryFinPopUp.visible = false
            SystemControl.resetSystem()
            idENGSetDelPopUp.visible = false

        }
    }
}
