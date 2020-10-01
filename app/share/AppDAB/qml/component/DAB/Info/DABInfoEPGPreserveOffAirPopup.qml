/**
 * FileName: DABInfoEPGPreservePopup.qml
 * Author: kyoungpyo.kang
 * Time: 2014-03-03
 */

import Qt 4.7
import "../../QML/DH" as MComp


MComp.MPopupTypeText {
    id : idDabInfoEPGPreserveOffAirPopup
    objectName: "EPGOffAirPopup"

    focus : true
    popupBtnCnt: 1

    popupFirstBtnText: stringInfo.strEPGPopup_OK
    popupFirstText: stringInfo.strEPGPopup_Listen

    onPopupFirstBtnClicked :
    {
        gotoBackScreen();
    }

    onHardBackKeyClicked : {
        gotoBackScreen();
    }

    Connections {
        target: AppUIListener
        onCloseEPGOffAirPopup:{
            console.log("[QML] ==> Connections : DABInfoEPGPreserveOffAirPopup.qml : AppUIListener::onCloseEPGOffAirPopup ");
            gotoBackScreen();
        }
    }
}
