import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeLoading{
    id: idPopupSearching
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    // Msg Info
    popupLineCnt : 3
    popupFirstText: stringInfo.strPOPUP_Searching
    popupSecondText: stringInfo.strPOPUP_SearchTVChannel + CommParser.iChSearchTVIndex + stringInfo.strPOPUP_SearchChannelCount
    popupThirdText: stringInfo.strPOPUP_SearchRadioChannel + CommParser.iChSearchRadioIndex + stringInfo.strPOPUP_SearchChannelCount

    // Btn Info
    popupBtnCnt: 1
    popupFirstBtnText: stringInfo.strPOPUP_BUTTON_Stop

    property bool seekPreKeyLongPressedOnSearching : idAppMain.isSeekPreLongKey;
    property bool seekNextKeyLongPressedOnSearching : idAppMain.isSeekNextLongKey;


    onSeekPreKeyLongPressedOnSearchingChanged:{
        if(idAppMain.state == "PopupSearching")
        {
            if(seekPreKeyLongPressedOnSearching == true){
                CommParser.onScanCancel()
            }
        }
    }

    onSeekNextKeyLongPressedOnSearchingChanged:{
        if(idAppMain.state == "PopupSearching")
        {
            if(seekNextKeyLongPressedOnSearching == true){
                CommParser.onScanCancel()
            }
        }
    }

    // onBtn0Click
    onPopupFirstBtnClicked: {
        CommParser.onScanCancel()
        //console.debug("Searching Channel : stop")
    }
    //onPopupBgClicked : gotoBackScreen() // # by WSH(130110, ISV-69272)
    onBackKeyPressed: { CommParser.onScanCancel() }
    onHomeKeyPressed: EngineListener.HandleHomeKey();

    onSeekPrevKeyReleased: {
        CommParser.onScanCancel()
        idAppMain.dmbSeekPrevKeyPressed()
    }

    onSeekNextKeyReleased: {
        CommParser.onScanCancel()
        idAppMain.dmbSeekNextKeyPressed()
    }

    onTuneLeftKeyPressed: {
        CommParser.onScanCancel()
//        idAppMain.dmbTuneLeftKeyPressed()
        idAppMain.dmbSeekPrevKeyPressed()
    }
    onTuneRightKeyPressed: {
        CommParser.onScanCancel()
//        idAppMain.dmbTuneRightKeyPressed()
        idAppMain.dmbSeekNextKeyPressed()
    }

    Connections{
        target: CommParser
        //**************************************** Changed model of listview when click DMB1, DMB2

        onChSearchTVIndexChanged:{
                popupSecondText = stringInfo.strPOPUP_SearchTVChannel + CommParser.iChSearchTVIndex + stringInfo.strPOPUP_SearchChannelCount
        }
        onChSearchRadioIndexChanged:{
                popupThirdText = stringInfo.strPOPUP_SearchRadioChannel + CommParser.iChSearchRadioIndex + stringInfo.strPOPUP_SearchChannelCount
        }
    }

    Connections{
        target: EngineListener
        onRetranslateUi: {
            popupSecondText = stringInfo.strPOPUP_SearchTVChannel + CommParser.iChSearchTVIndex + stringInfo.strPOPUP_SearchChannelCount
            popupThirdText = stringInfo.strPOPUP_SearchRadioChannel + CommParser.iChSearchRadioIndex + stringInfo.strPOPUP_SearchChannelCount
//            console.log(" [QML][PopupSearching] ===================> onRetranslateUi" )
        }
    }
}
