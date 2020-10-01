/**
 * /BT_arabic/Contacts/BtContactOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idBtContactOptionMenu;
    linkedModels: contactListModel;
    focus: true;
    visible: true;

    // 전화번호부 다운로드가 완료 되었을 때, 버튼 활성화 코드
    menu0Dimmed: {
        if(contact_nstate == 1 || contact_nstate == 2
            || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())) {
            false
        } else {
            true
        }
    }
    menu1Dimmed: (1 == contact_nstate || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())) ? false : true
    menu2Dimmed: (1 == contact_nstate || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())) ? false : true

    ListModel {
        id:contactListModel

        ListElement { name:"";      opType: "" }
        ListElement { name:"";      opType: "" }
        ListElement { name:"";      opType: "" }
        //ListElement { name:"";      opType: "" }
        ListElement { name:"";      opType: "" }
    }


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtContactOptionMenu.linkedModels.get(0).name = stringInfo.str_Menu_Download
            idBtContactOptionMenu.linkedModels.get(1).name = stringInfo.str_Search_Phonebook_Menu
            idBtContactOptionMenu.linkedModels.get(2).name = stringInfo.str_Bt_Menu_Add_Favorite
            //idBtContactOptionMenu.linkedModels.get(3).name = stringInfo.str_Bt_Auto_Download_Setting_Btn
            idBtContactOptionMenu.linkedModels.get(3).name = stringInfo.str_Con_Menu_Setting
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtContactOptionMenu.linkedModels.get(0).name = stringInfo.str_Menu_Download
        idBtContactOptionMenu.linkedModels.get(1).name = stringInfo.str_Search_Phonebook_Menu
        idBtContactOptionMenu.linkedModels.get(2).name = stringInfo.str_Bt_Menu_Add_Favorite
        //idBtContactOptionMenu.linkedModels.get(3).name = stringInfo.str_Bt_Auto_Download_Setting_Btn
        idBtContactOptionMenu.linkedModels.get(3).name = stringInfo.str_Con_Menu_Setting
/*DEPRECATED
        if(callHistoryDownState == "Auto") {
            menu2Dimmed = "true"
        }
DEPRECATED*/
    }

    onVisibleChanged: {
        if(true == idBtContactOptionMenu.visible) {
            idBtContactOptionMenu.linkedModels.get(0).name = stringInfo.str_Menu_Download
            idBtContactOptionMenu.linkedModels.get(1).name = stringInfo.str_Search_Phonebook_Menu
            idBtContactOptionMenu.linkedModels.get(2).name = stringInfo.str_Bt_Menu_Add_Favorite
            //idBtContactOptionMenu.linkedModels.get(3).name = stringInfo.str_Bt_Auto_Download_Setting_Btn
            idBtContactOptionMenu.linkedModels.get(3).name = stringInfo.str_Con_Menu_Setting
        }
    }

    onMenu0Click: {
        idMenu.off();

        if(true == downloadCallHistory) {
            MOp.showPopup("popup_Bt_Downloading_Callhistory");
        } else if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
            MOp.showPopup("popup_bt_no_downloading_phonebook");
        } else {
            if(2 == contact_nstate || 12 == contact_nstate) {
                BtCoreCtrl.invokeTrackerDownloadPhonebook()
            } else {
                /* 1번상태 일때만 재다운로드 팝업이 떠야하지만 2번12번1번 이외의 화면에서는
                 * 버튼이 dim 처리 되어 메뉴를 선택 할 수 없으므로  상태 확인 없이 무조건 팝업 표시
                 */
                MOp.showPopup("popup_redownload");
            }
        }
    }

    onMenu1Click: {
        idMenu.off();

        // UX변경 - 주행중 등록 불가 팝업
        if(false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
            MOp.showPopup("popup_search_while_driving");
        } else {
            //setMainAppScreen("BtContactSearchMain", false);
            contactSearchInput = ""
            pushScreen("BtContactSearchMain", 501);
        }
    }

    onMenu2Click:  {
        // Add favorite
        idMenu.off();

        if(10 > BtCoreCtrl.m_nCountFavoriteContactsList) {
            if(delegate_count == 1) {
                BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, contact_type_1, phoneNum)
            } else if(2 == delegate_count || 3 == delegate_count) {
                MOp.showPopup("popup_favorite_add_contacts_add");
            } else {
                MOp.showPopup("popup_favorite_add_contacts");
            }
        } else {
            MOp.showPopup("popup_Bt_Favorite_Max");
        }
    }

    /*onMenu3Click: {
        // 설정 -> 자동다운로드
        idMenu.off();

        //__IQS_15MY_ Call End Modify
        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
            /* 통화중일 경우 진입 막음

            MOp.showPopup("popup_bt_invalid_during_call");
        } else {
            //settingCurrentIndex = 2

            // Go to the settings
            pushScreen("SettingsBtAutoDown", 502);
        }
    }*/

    onMenu3Click: {
        // 설정 -> 연결설정
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
            //settingCurrentIndex = 0

            // Go to the settings
            btSettingsEnter = false;
            pushScreen("SettingsBtDeviceConnect", 503);
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
}
/* EOF */
