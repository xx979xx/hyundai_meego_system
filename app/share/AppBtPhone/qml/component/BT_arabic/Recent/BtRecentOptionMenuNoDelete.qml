/**
 * BtRecentOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id:idBtRecentOptionMenuNoDelete;
    linkedModels: recentListModel;
    focus: true;
    visible: true;


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtRecentOptionMenuNoDelete.linkedModels.get(0).name = stringInfo.str_Menu_Download
            idBtRecentOptionMenuNoDelete.linkedModels.get(1).name = stringInfo.str_Con_Menu_Setting
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtRecentOptionMenuNoDelete.linkedModels.get(0).name = stringInfo.str_Menu_Download
        idBtRecentOptionMenuNoDelete.linkedModels.get(1).name = stringInfo.str_Con_Menu_Setting
    }

    onVisibleChanged: {
        if(true == idBtRecentOptionMenuNoDelete.visible) {
            idBtRecentOptionMenuNoDelete.linkedModels.get(0).name = stringInfo.str_Menu_Download
            idBtRecentOptionMenuNoDelete.linkedModels.get(1).name = stringInfo.str_Con_Menu_Setting
        }
    }

    onMenu0Click: {
        idMenu.off();

        if(true == downloadContact) {
            MOp.showPopup("popup_Bt_Downloading_Phonebook");
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
        // 설정 > 연결설정
        idMenu.off();
        //__IQS_15MY_ Call End Modify
        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
            /* 통화중일 경우 진입 막음
             */
            MOp.showPopup("popup_bt_invalid_during_call");
        }
        /* CarPlay */
        //[ITS 0272577]
        else if(true == projectionOn) {
            MOp.showPopup("popup_Bt_enter_setting_during_CarPlay")
        }
        else {
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
    menu0Dimmed: (1 == recent_nstate || 2 == recent_nstate || 12 == recent_nstate) ? false : true

    ListModel {
        id:recentListModel
        ListElement { name: "DownLoad";          opType: "" }
        ListElement { name: "Pairing Setting";   opType: "" }
    }
}
/* EOF */
