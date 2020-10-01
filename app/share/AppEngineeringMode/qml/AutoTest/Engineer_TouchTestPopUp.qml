import QtQuick 1.0

import "../Component" as MComp

MComp.MComponent{
    id:idTouchTestPopUp
    x: 0; y: 93
    width: 1280; height: 720 - 93
    focus:true
    property alias touchTestOkPopUp:idENGTouchTestFinPopUp.visible
    property alias touchTestFailPopUp: idENGTouchTestFailPopUp.visible

    MComp.MMsgPopup{
        id:idENGTouchTestFinPopUp
        //y:0; z:100
        visible: false
        onVisibleChanged: { /*if(visible)idENGSetDeliveryPopUp.focus = true;*/}
        popupName: "Touch Test : OK"
        msgModel: ListModel{
            ListElement{ msgName:"Touch Test : OK"; }
        }
        btnModel: ListModel{
            ListElement {   btnName: "OK";  }
            //ListElement {   btnName:    "CANCEL";   }
        }
        onBtn0Click: {

        }

    }

        MComp.MMsgPopup{
            id:idENGTouchTestFailPopUp
            //y:0; z:100
            visible: false
            onVisibleChanged: { /*if(visible)idTimerSetDelivery.start()*/}
            popupName: "Touch Test : Fail"
            titleTextSize: 25
            msgModel: ListModel{
                id:idTouchTestFailModel
                ListElement{ msgName:"Touch Test : Fail"; }
                //ListElement{ msgName:"Factory FAIL"; }
            }
            btnModel: ListModel{
                ListElement {   btnName: "OK";  }

            }
            onBtn0Click: {

            }

        }


        //    MComp.DimPopUp{
        //        id:idDlgSetDeliveryFin
        //        textLineCount: 1
        //        loadingFlag: false
        ////        firstText: "Emitted Set Delivery Setting."
        //        visible: false
        //        onVisibleChanged: { if(visible)idTimerSetDelivery.start()   }

        //    }

    Connections{
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
        interval: 8000
        repeat:false
        onTriggered:
        {
            idENGSetDeliveryFinPopUp.visible = false
            SystemControl.resetSystem()
            idENGSetDelPopUp.visible = false

        }
    }
}

