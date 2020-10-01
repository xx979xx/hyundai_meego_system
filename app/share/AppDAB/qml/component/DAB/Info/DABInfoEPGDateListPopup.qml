/**
 * FileName: DABInfoEPGDescPopup.qml
 * Author: DaeHyungE
 * Time: 2012-07-16
 *
 * - 2012-07-16 Initial Created by HyungE
 * - 2013-01-08 Added Duplicate reservation check Popup
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MPopupTypeList {
    id : idDabInfoEPGDateListPopup
    focus : true
    objectName: "EPGDateListPopup"

    popupBtnCnt: 1
    popupLineCnt: 7
    popupFirstBtnText: stringInfo.strEPGPopup_Cancel
    idListModel: idDateModel   

    onPopuplistItemClicked: {
        console.log("[QML] idDabInfoEPGDateListPopup - onPopuplistItemClicked, selectedItemIndex : ", selectedItemIndex);
        m_sSelectEPGDate = idDateModel.get(selectedItemIndex).listFirstItem;
        reqEPGListBySelectDate(idDateModel.get(selectedItemIndex).listSecondItem)
        gotoBackScreen()
    }

    onPopupFirstBtnClicked: {
        console.log("[QML] idDabInfoEPGDateListPopup.qml : onPopupFirstBtnClicked")
        gotoBackScreen();
    }

    onBackKeyPressed: {
        console.log("[QML] idDabInfoEPGDateListPopup.qml : onBackKeyPressed")
        gotoBackScreen();
    }

    ListModel {
        id: idDateModel
    }

    //***************************** Function
    function initialize()
    {
        console.log("[QML] DABInfoEPGDescPopup.qml - initialize()")
        idDateModel.clear();
        var today = new Date();
        for(var i = 0; i < 7 ; i++)
        {
            var nextDay = new Date(today.getTime() + i * (24 * 60 * 60 * 1000));
            var dayDate = Qt.formatDate(nextDay, "dd")
            var monthDate = Qt.formatDate(nextDay, "MM")
            var yearDate = Qt.formatDate(nextDay, "yy")
            var dayName = Qt.formatDate(nextDay, "ddd")
            var dayItem = dayDate + "-" + monthDate + "-" + yearDate + ", " + dayName
            idDateModel.append({ "listFirstItem": dayItem, "listSecondItem": nextDay});
        }
    }

    Connections {
        target: AppUIListener
        onCloseEPGDateListPopup:{
            console.log("[QML] ==> Connections : idDabInfoEPGDateListPopup.qml : AppUIListener::onCloseEPGDateListPopup ");
            gotoBackScreen();
        }
    }
}
