import Qt 4.7
import "../../../system/DH" as MSystem
import "../../../QML/DH" as MComp
import "../../../../component/Radio/RDS" as MRadio

MComp.MPopupTypeLoading{
    id: idPopupSearching
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }
    MRadio.RadioRdsStringInfo{ id: stringInfo }

    //****************************** # Line Count (1 or 2 or 3) #
    popupLineCnt : 2

    //****************************** # Text Setting #
    popupFirstText: stringInfo.strRDSPopupBeingUpdated1 //"The station list is being updated"
    popupSecondText: stringInfo.strRDSPopupBeingUpdated2 //"Please wait"

    // Btn Info
    popupBtnCnt: 1
    popupFirstBtnText: stringInfo.strRDSPopupCancel  //"Cancel"

    // onBtn0Click
    onPopupFirstBtnClicked: {
        console.log("AM refresh cancel button clicked")
        if(QmlController.getIsRefreshing() == true) //KSW 131028 [ITS][198566][minor]
            QmlController.setForceSeekStop(true);
        QmlController.stopRefresh();
//20130604 modified by qutiguy - update st.list then goback.
        QmlController.getStationListModel();
        gotoBackScreen()

    }

    onBackKeyPressed: {
        console.log("comma pressed")
        gotoBackScreen()
    }

    onSeekPrevKeyPressed: {
        console.log(" [QML] ======================>>> [PopupSearching][onSeekPrevKeyPressed] ")
    }

    // [TRACK] ============================================ # by WSH(130128)
    onSeekNextKeyPressed: {
        console.log(" [QML] ======================>>> [PopupSearching][onSeekNextKeyPressed] ")
    }

    // [Tune] ============================================ # by WSH(130128)
    onTuneLeftKeyPressed: {
        console.log(" [QML] ======================>>> [PopupSearching][onTuneLeftKeyPressed] ")
    }
    onTuneRightKeyPressed: {
        console.log(" [QML] ======================>>> [PopupSearching][onTuneRightKeyPressed] ")
    }
    //20130110 added by qutiguy - to stopping refreshing if refreshing .
    onVisibleChanged: {
        console.log(" [QML] ======================>>> [PopupSearching][onVisibleChanged] visible = " + idRadioRdsPopupLoading.visible)
        if(!idRadioRdsPopupLoading.visible){
            if(QmlController.getIsRefreshing() == true)
                QmlController.setForceSeekStop(true)
            QmlController.stopRefresh();
        }
    }
    Connections{
        target : QmlController
        onSigRDSStationEndUpdate:{
            console.log(" >>>>>> onSigRDSStationEndUpdate");
//20130110 added by qutiguy - do not update and goback if not refreshing.
            if(!idRadioRdsPopupLoading.visible)
                return;
            QmlController.getStationListModel();
            gotoBackScreen(); //KSW 131224
            initStationListView();
        }
    }
}
