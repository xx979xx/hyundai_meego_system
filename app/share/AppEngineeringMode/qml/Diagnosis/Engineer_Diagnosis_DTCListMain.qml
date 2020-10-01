import Qt 4.7
import "../Component" as MComp
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDTCListMain
    x:0; y:0
    width: 1280
    height:550
    focus:true

    signal backFromListSignal()
    property alias backKey: idDTCListBand.backKeyButton
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        backKey.forceActiveFocus()
    }

    onBackKeyPressed: {
        if(isMapCareMain)
        {
            mainViewState="MapCareMain"
            setMapCareUIScreen("", true)
            mainViewState = "Diagnosis"
            setMapCareUIScreen("Diagnosis", false)
        }
        else
        {
            mainViewState="Main"
            setMainAppScreen("", true)
            mainViewState = "Diagnosis"
            setMainAppScreen("Diagnosis", false)
        }

    }

    MComp.MBand{
        id:idDTCListBand
        y:0
        titleText: isMapCareMain ?qsTr("DealerMode > Service Code > Service Code List") : qsTr("Engineering Mode > DTC > DTC List")
        focus: true
        onBackKeyClicked: {
            if(isMapCareMain)
            {
                mainViewState="MapCareMain"
                setMapCareUIScreen("", true)
                mainViewState = "Diagnosis"
                setMapCareUIScreen("Diagnosis", false)
            }
            else
            {
                mainViewState="Main"
                setMainAppScreen("", true)
                mainViewState = "Diagnosis"
                setMainAppScreen("Diagnosis", false)
            }

        }
    }


    MComp.DTCListView{
        x:18; y:80;
        width: 1200; height: 90*6
        id:idDTCModeListView
        //focus: true

    }

}
