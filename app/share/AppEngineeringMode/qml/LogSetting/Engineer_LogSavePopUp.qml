import QtQuick 1.0

import "../Component" as MComp

MComp.MComponent{
    id:idSaveLogPopUp
    x: 0; y: 93
    width: 1280; height: 720 - 93
    focus:true
    property alias logPopUp: idStartLogCopyToUSB.visible
    //property alias setLogLevelPopUp:idDlgLogLevelSet.visible

    MComp.DimPopUp{
        id:idDlgLogLevelSet
        textLineCount: 1
        loadingFlag: true
        firstText: "Setting Log Level Start ..."
        visible: false
        z:100
        onVisibleChanged: {
            if(visible){
                idTimerLogLevelSet.start()
                idDlgLogLevelSet.forceActiveFocus()
            }
        }

    }
    MComp.DimPopUp{
        id:idDlgLogLevelSetEnd
        textLineCount: 1
        loadingFlag: false
        firstText: "Setting Log Level End."
        visible: false
        z:100
        onVisibleChanged: {
            if(visible){

                idTimerLogLevelSetEnd.start()
            }
        }

    }

    MComp.DimPopUp{
        id:idStartLogCopyToUSB
        textLineCount: 1
        loadingFlag: true
        firstText: "Processing Copy Log File To USB ... "
        visible: false
        z:100
        onVisibleChanged: {
            if(visible)
            {
                idStartLogCopyToUSB.forceActiveFocus()
            }
        }

    }
    //    MComp.DimPopUp{
    //        id:idDlgSaveLogFin
    //        textLineCount: 1
    //        loadingFlag: false
    //        firstText: "Finished Copying Log File To USB."
    //        visible: false
    //        onVisibleChanged: { if(visible)idTimerSaveLogFinish.start()  }

    //    }
    //    MComp.DimPopUp{
    //        id:idDlgSaveLogFailNoUSB
    //        textLineCount: 1
    //        loadingFlag: false
    //        firstText: "Can not Find USB."
    //        visible: false
    //        onVisibleChanged: { if(visible)idTimerSaveLogFail.start();   }

    //    }
    //    MComp.DimPopUp{
    //        id:idDlgCopyLogFailNoAvail
    //        textLineCount: 1
    //        loadingFlag: false
    //        visible: false
    //        firstText: "There is no Availabe Size in USB."
    //         onVisibleChanged: { if(visible)idTimerSaveLogFail.start();   }
    //    }
    //    MComp.DimPopUp{
    //        id:idDlgSaveLogFail
    //        textLineCount: 1
    //        loadingFlag: false
    //        firstText: "Copy Log File To USB Failed."
    //        visible: false
    //        onVisibleChanged: { if(visible)idTimerSaveLogFail.start();   }

    //    }
    MComp.MPopUpTypeText{
        id: idDlgSaveLogFin
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 1
        popupFirstText: "Finished Copying Log File To USB."

        // Btn Info
        popupBtnCnt: 1
        popupFirstBtnText: "OK"

        onVisibleChanged: {
            if(visible)
            {
                idDlgSaveLogFin.focus = true;
                idDlgSaveLogFin.forceActiveFocus()
            }
            else
            {
                idDlgSaveLogFin.focus = false;
            }
        }
        // onBtn0Click
        onPopupFirstBtnClicked: {
            idDlgSaveLogFin.visible = false
            idLogmain.visible  = true
            idLogmain.focus = true
            if(isSystemLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog = false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            else if(isNaviLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                naviLogCopyBtn.forceActiveFocus()
            }
            else if(isAfLog){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                aflogcopyBtn.forceActiveFocus()
            }
            else{
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }


            idENGSaveLogPopUp.visible = false
        }
    }
    MComp.MPopUpTypeText{
        id: idDlgSaveLogFailNoUSB
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 1
        popupFirstText: "Can not Find USB."

        // Btn Info
        popupBtnCnt: 1
        popupFirstBtnText: "OK"

        onVisibleChanged: {
            if(visible)
            {
                idDlgSaveLogFailNoUSB.focus = true;
                idDlgSaveLogFailNoUSB.forceActiveFocus()
            }
            else
            {
                idDlgSaveLogFailNoUSB.focus = false;
            }
        }
        // onBtn0Click
        onPopupFirstBtnClicked: {
            idDlgSaveLogFailNoUSB.visible = false
            idLogmain.visible  = true
            idLogmain.focus = true
            if(isSystemLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog = false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            else if(isNaviLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                naviLogCopyBtn.forceActiveFocus()
            }
            else if(isAfLog){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                aflogcopyBtn.forceActiveFocus()
            }
            else{
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            idENGSaveLogPopUp.visible = false
        }
    }
    MComp.MPopUpTypeText{
        id: idDlgCopyLogFailNoAvail
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 1
        popupFirstText: "There is no Availabe Size in USB."

        // Btn Info
        popupBtnCnt: 1
        popupFirstBtnText: "OK"

        onVisibleChanged: {
            if(visible)
            {
                idDlgCopyLogFailNoAvail.focus = true;
                idDlgCopyLogFailNoAvail.forceActiveFocus()
            }
            else
            {
                idDlgCopyLogFailNoAvail.focus = false;
            }
        }
        // onBtn0Click
        onPopupFirstBtnClicked: {
            idDlgCopyLogFailNoAvail.visible = false
            idLogmain.visible  = true
            idLogmain.focus = true
            if(isSystemLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog = false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            else if(isNaviLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                naviLogCopyBtn.forceActiveFocus()
            }
            else if(isAfLog){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                aflogcopyBtn.forceActiveFocus()
            }
            else{
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            idENGSaveLogPopUp.visible = false
        }
    }
    MComp.MPopUpTypeText{
        id: idDlgSaveLogFail
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 2
        popupFirstText: "[Warn] Copy Log File To USB Failed. !!!"
        popupSecondText: "Retry Copying Log File ?"
        // Btn Info
        popupBtnCnt: 2
        popupFirstBtnText: "OK"
        popupSecondBtnText: "Cancel"
        onVisibleChanged: {
            if(visible)
            {
                idDlgSaveLogFail.focus = true;
                idDlgSaveLogFail.forceActiveFocus()
            }
            else
            {
                idDlgSaveLogFail.focus = false;
            }
        }
        // onBtn0Click
        onPopupFirstBtnClicked: {
            idDlgRetryCopyPopUp.visible = false
            UpgradeVerInfo.startLogPopUp();
        }
        onPopupSecondBtnClicked:{
            idDlgSaveLogFail.visible = false
             idLogmain.visible  = true
            idLogmain.focus = true
            if(isSystemLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog = false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            else if(isNaviLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                naviLogCopyBtn.forceActiveFocus()
            }
            else if(isAfLog){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                aflogcopyBtn.forceActiveFocus()
            }
            else{
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
             idENGSaveLogPopUp.visible = false
        }
    }
    MComp.MPopUpTypeText{
        id: idDlgRetryCopyPopUp
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        focus: true
        visible: false

        // Msg Info
        popupLineCnt : 2
        popupFirstText: "COPY  Failed !!! (All files are not copied.)"
        popupSecondText: "Retry Copying Log File ?"

        // Btn Info
        popupBtnCnt: 2
        popupFirstBtnText: "OK"
        popupSecondBtnText: "Cancel"


        onVisibleChanged: {
            if(visible)
            {
                idDlgRetryCopyPopUp.focus = true;
                idDlgRetryCopyPopUp.forceActiveFocus()
            }
            else
            {
                idDlgRetryCopyPopUp.focus = false;
            }
        }

        // onBtn0Click
        onPopupFirstBtnClicked: {
            idDlgRetryCopyPopUp.visible = false
            UpgradeVerInfo.startLogPopUp();
        }
        // onBtn1Click
        onPopupSecondBtnClicked:{
            idDlgRetryCopyPopUp.visible = false
            idLogmain.visible  = true
            idLogmain.focus = true
            if(isSystemLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog = false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            else if(isNaviLogCopy){
                isSystemLogCopy = false
                isNaviLogCopy = false
                naviLogCopyBtn.forceActiveFocus()
            }
            else if(isAfLog){
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                aflogcopyBtn.forceActiveFocus()
            }
            else{
                isSystemLogCopy = false
                isNaviLogCopy = false
                isAfLog =false
                logCopyBtn.focus = true;
                logCopyBtn.forceActiveFocus();
            }
            idENGSaveLogPopUp.visible = false
        }
    }
    Timer{
        id:idTimerSaveLogFail
        interval: 2000
        repeat:false
        onTriggered:
        {
            idDlgSaveLogFin.visible = false
            idDlgCopyLogFailNoAvail.visible = false
            idDlgSaveLogFailNoUSB.visible = false
            idDlgSaveLogFail.visible = false
            idENGSaveLogPopUp.visible = false

        }
    }
    Timer{
        id:idTimerSaveLogStart
        interval: 7000
        repeat:false
        onTriggered:
        {
            idStartLogCopyToUSB.visible = false;

        }
    }

    Timer{
        id:idTimerLogLevelSet
        interval: 5000
        repeat:false
        onTriggered:
        {
            idDlgLogLevelSet.visible =false
            idDlgLogLevelSetEnd.visible = true

        }
    }
    Timer{
        id:idTimerLogLevelSetEnd
        interval: 2000
        repeat:false
        onTriggered:
        {
            idDlgLogLevelSetEnd.visible =false
            idENGSaveLogPopUp.visible = false
            if(isEnableLog)
            {
                isEnableLog = false
                isDisableLog = false
                isApplyLogLevel =false
                enableBtn.forceActiveFocus()
            }
            else if(isDisableLog)
            {
                isEnableLog = false
                isDisableLog = false
                isApplyLogLevel =false
                disableBtn.forceActiveFocus()
            }
            else if(isApplyLogLevel)
            {
                isEnableLog = false
                isDisableLog = false
                isApplyLogLevel =false
                applyLogBtn.forceActiveFocus()
            }
            else
            {
                isEnableLog = false
                isDisableLog = false
                isApplyLogLevel =false
                enableBtn.forceActiveFocus()
            }

        }
    }
    Timer{
        id:idTimerSaveLogFinish
        interval: 2000
        repeat:false
        onTriggered:
        {
            idDlgSaveLogFin.visible = false
            idDlgCopyLogFailNoAvail.visible = false
            idDlgSaveLogFailNoUSB.visible = false
            idDlgSaveLogFail.visible = false
            idENGSaveLogPopUp.visible = false

        }
    }
    Connections{
        target: LogSettingData
        onStartLogSetPopUp:{
            console.debug("Start Log Set Level Start ============");
            idENGSaveLogPopUp.visible = true
            idDlgLogLevelSet.visible = true;

        }

    }

    Connections{
        target:UpgradeVerInfo
        onStartCopyPopUp:{
             console.debug("Start Log Copy To USB Start ============");
             idENGSaveLogPopUp.visible = true
             idStartLogCopyToUSB.visible = true
        }

        onCopyToUSBRes:{
           //case : NO USB
           if(state == 0){
                console.debug("Start NO USB PopUp =============")
               idENGSaveLogPopUp.visible = true
               idStartLogCopyToUSB.visible = false
               idDlgSaveLogFailNoUSB.visible = true
           }
           //case : COPY START
           else if(state == 1){
               console.debug("Start Copy Start PopUp =============")
               idENGSaveLogPopUp.visible = true
               idStartLogCopyToUSB.visible = true
           }
            //case : COPY END
           else if(state == 2){
                console.debug("Start COPY END PopUp =============")
                idStartLogCopyToUSB.visible = false

                idDlgSaveLogFin.visible = true
           }    //case : COPY FAIL(There is no Available Size in USB)
           else if(state == 3){
                console.debug("Start CCOPY FAIL(There is no Available Size in USB) PopUp =============")
               idStartLogCopyToUSB.visible = false
               idDlgCopyLogFailNoAvail.visible = true
           }    //case : COPYING FAIL
           else if(state == 4){
               console.debug("Start COPYING FAIL PopUp =============")
               idStartLogCopyToUSB.visible = false
               idDlgSaveLogFail.visible = true
           }    //case : COPY FAIL(All File were not copied.)
           else if(state == 5){
               console.debug("Start Copy Failed(All File were not copied.)")
               idStartLogCopyToUSB.visible = false
               idDlgRetryCopyPopUp.visible = true
           }

        }
    }

}

