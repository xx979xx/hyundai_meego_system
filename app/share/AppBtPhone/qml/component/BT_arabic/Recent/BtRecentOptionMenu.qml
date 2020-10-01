/**
 * BtRecentOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id:idBtRecentOptionMenu;
    linkedModels: recentListModel;
    focus: true;
    visible: true;


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtRecentOptionMenu.linkedModels.get(0).name = stringInfo.str_Menu_Download
            idBtRecentOptionMenu.linkedModels.get(1).name = stringInfo.str_Delete_Menu
            idBtRecentOptionMenu.linkedModels.get(2).name = stringInfo.str_Bt_RecentCall_Delete_All
            //idBtRecentOptionMenu.linkedModels.get(3).name = stringInfo.str_Bt_Auto_Download_Setting_Btn
            idBtRecentOptionMenu.linkedModels.get(3).name = stringInfo.str_Con_Menu_Setting
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtRecentOptionMenu.linkedModels.get(0).name = stringInfo.str_Menu_Download
        idBtRecentOptionMenu.linkedModels.get(1).name = stringInfo.str_Delete_Menu
        idBtRecentOptionMenu.linkedModels.get(2).name = stringInfo.str_Bt_RecentCall_Delete_All
        //idBtRecentOptionMenu.linkedModels.get(3).name = stringInfo.str_Bt_Auto_Download_Setting_Btn
        idBtRecentOptionMenu.linkedModels.get(3).name = stringInfo.str_Con_Menu_Setting

/*DEPRECATED
        if(callHistoryDownState == "Auto") {
            menu1Dimmed = "true"
            menu2Dimmed = "true"
        }
DEPRECATED*/
    }

    onVisibleChanged: {
        if(true == idBtRecentOptionMenu.visible) {
            idBtRecentOptionMenu.linkedModels.get(0).name = stringInfo.str_Menu_Download
            idBtRecentOptionMenu.linkedModels.get(1).name = stringInfo.str_Delete_Menu
            idBtRecentOptionMenu.linkedModels.get(2).name = stringInfo.str_Bt_RecentCall_Delete_All
            //idBtRecentOptionMenu.linkedModels.get(3).name = stringInfo.str_Bt_Auto_Download_Setting_Btn
            idBtRecentOptionMenu.linkedModels.get(3).name = stringInfo.str_Con_Menu_Setting
        }
    }

    onMenu0Click: {
        idMenu.off();

        if(true == downloadContact) {
            MOp.showPopup("popup_Bt_Downloading_Phonebook");
        } else if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
            MOp.showPopup("popup_Bt_Downloading_Callhistory");
        } else {
            if(2 == recent_nstate || 12 == recent_nstate) {
                BtCoreCtrl.invokeTrackerDownloadCallHistory();
            } else {
                /* 1번상태 일때만 재다운로드 팝업이 떠야하지만 2번12번1번 이외의 화면에서는
                 * 버튼이 dim 처리 되어 메뉴를 선택 할 수 없으므로  상태 확인 없이 무조건 팝업 표시
                 */
                MOp.showPopup("popup_redownload");
            }
        }
    }

    onMenu1Click: {
        // 선택 삭제
        idMenu.off();
        resetFocusCallhistory();
        pushScreen("BtRecentDelete", 515);
        delete_type = "recent";
    }

    onMenu2Click: {
        // 전체 삭제(수신, 발신, 부재중 모두를 삭제함)
        idMenu.off();

        MOp.showPopup("popup_bt_delete_all_history");
        delete_type = "recent";
    }


    /*onMenu3Click: {
        // 설정 > 자동 다운로드
        idMenu.off();
        //__IQS_15MY_ Call End Modify
        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
            MOp.showPopup("popup_bt_invalid_during_call");
        } else {
            pushScreen("SettingsBtAutoDown", 901);
        }
    }*/

    onMenu3Click: {
        // 설정 > 연결설정
        idMenu.off();
        //__IQS_15MY_ Call End Modify
        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
            /* 통화중일 경우 진입 막음
             */
            MOp.showPopup("popup_bt_invalid_during_call");
        } else {
            btSettingsEnter = false;
            pushScreen("SettingsBtDeviceConnect", 902);
        }
    }

    onOptionMenuFinished: {
        if(true == visible) {
            idMenu.hide();
        }
    }

    onClickDimBG: {
        idMenu.hide();
    }

    /* 최근 통화 목록이 다운받은 상태 / 수동 다운로드 대기 상태에서 버튼 활성화 코드
     */
    menu0Dimmed: (1 == recent_nstate || 2 == recent_nstate || 12 == recent_nstate)
                 || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) ? false : true
    menu1Dimmed: (0 < recent_list_count && 1 == recent_nstate && false == BtCoreCtrl.m_autoDownloadCallHistory)
                 || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) ? false : true
    menu2Dimmed: ((0 < BtCoreCtrl.m_incomingCallHistoryCount || 0 < BtCoreCtrl.m_outgoingCallHistoryCount || 0 < BtCoreCtrl.m_missedCallHistoryCount) && (1 == recent_nstate || 3 == recent_nstate) && false == BtCoreCtrl.m_autoDownloadCallHistory)
                 || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) ? false : true

    ListModel {
        id:recentListModel
        ListElement { name: "DownLoad";          opType: "" }
        ListElement { name: "Delete";            opType: "" }
        ListElement { name: "Auto Down Setting"; opType: "" }
        // ListElement { name: "Settings";          opType: "" }
        ListElement { name: "Pairing Setting";   opType: "" }
    }
}
/* EOF */
