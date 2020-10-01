/**
 * FileName: DABInfoEPGPreserveDupCheckPopup.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-01-08 Initial Created by HYANG
 */
import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeText {
    id : idDabInfoEPGPreserveDupCheckPopup
    focus : true
    popupBtnCnt: 2

    popupFirstBtnText: stringInfo.strEPGPopup_Yes
    popupSecondBtnText: stringInfo.strEPGPopup_No
    popupFirstText: stringInfo.strEPGPopup_AlreadyReservedTimer

    onPopupSecondBtnClicked : {     
        console.log("[QML] DABInfoEPGPreserveDupCheckPopup.qml : onPopupSecondBtnClicked")
        gotoBackScreen();
    }

    onHardBackKeyClicked : {
        console.log("[QML] DABInfoEPGPreserveDupCheckPopup.qml : onHardBackKeyClicked")
        gotoBackScreen();
    }

    onVisibleChanged: {
        idDabInfoEPGPreserveDupCheckPopup.giveFocus(1);
    }
}
