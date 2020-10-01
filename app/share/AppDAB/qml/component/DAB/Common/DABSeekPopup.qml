/**
 * FileName: DABSeekPopup.qml
 * Author: DaeHyungE
 * Time: 2012-11-21
 *
 * - 2012-07-31 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation


MComp.MPopupTypeText{
    id : idDabSeekPopup
    focus : true

    popupBtnCnt: 1

    popupFirstBtnText: stringInfo.strPlayerPopup_Cancel
   // popupFirstBtnText2Line: stringInfo.strPlayerPopup_Seek
    popupFirstText: stringInfo.strPlayerPopup_SearchNextEnsemble


    onPopupFirstBtnClicked :
    {
        console.log("[QML] DABSeekPopup.qml : onFirstBtnClicked ")
        MDabOperation.CmdReqSeekCancel();
        gotoBackScreen();
    }

    onHardBackKeyClicked :
    {
        console.log("[QML] DABSeekPopup.qml : onHardBackKeyClicked ")
        MDabOperation.CmdReqSeekCancel();
        gotoBackScreen();
    }
}
