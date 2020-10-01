/**
 * BtFavoriteOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idFavoriteMenu;
    linkedModels: favoriteListModel;
    focus: true;
    visible: true;

    menu0Dimmed: (13 == contact_nstate) || (4 == favorite_nstate) ? true : false
    //[ITS 0269311]
    menu1Dimmed:((0 == BtCoreCtrl.m_nCountFavoriteContactsList) || !favoriteValue) ? true : false
    /* CarPlay */
    menu2TextColor: (true == projectionOn) ? colorInfo.disableGrey : colorInfo.subTextGrey

    /* LIST MODEL */
    ListModel {
        id: favoriteListModel
        ListElement { name: ""; opType: "" }
        ListElement { name: ""; opType: "" }
        ListElement { name: ""; opType: "" }
    }

    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idFavoriteMenu.linkedModels.get(0).name = stringInfo.str_New_Device_Popup
            idFavoriteMenu.linkedModels.get(1).name = stringInfo.str_Delete_Menu
            idFavoriteMenu.linkedModels.get(2).name = stringInfo.str_Con_Menu_Setting
        }
    }

    Component.onCompleted: {
        idFavoriteMenu.linkedModels.get(0).name = stringInfo.str_New_Device_Popup
        idFavoriteMenu.linkedModels.get(1).name = stringInfo.str_Delete_Menu
        idFavoriteMenu.linkedModels.get(2).name = stringInfo.str_Con_Menu_Setting
    }

    onVisibleChanged: {
        if(true == idFavoriteMenu.visible) {
            idFavoriteMenu.linkedModels.get(0).name = stringInfo.str_New_Device_Popup
            idFavoriteMenu.linkedModels.get(1).name = stringInfo.str_Delete_Menu
            idFavoriteMenu.linkedModels.get(2).name = stringInfo.str_Con_Menu_Setting
        }
    }


    /* EVENT handlers */
    onMenu0Click: {
        // 즐겨찾기 추가
        idMenu.off();

        /* 즐겨찾기 9개 인경우 추가 안되는 문제 수정
         */
        if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
            if(14 /* UPDATING */ == contact_nstate) {
                // 팝업 변경 필요
                MOp.showPopup("popup_bt_no_downloading_phonebook");
            } else if(10 > BtCoreCtrl.m_nCountFavoriteContactsList) {
                favoriteAdd = "FROM_CONTACT";
                pushScreen("BtContactMain", 511);
                favoriteButtonPress = false
            } else {
                // 10개를 넘을 경우 추가할 수 없음
                MOp.showPopup("popup_Bt_Favorite_Max");
            }
        } else {
            if(10 > BtCoreCtrl.m_nCountFavoriteContactsList) {
                qml_debug("\n\n + contact_nstate : " + contact_nstate)

                switch(contact_nstate) {
                    case 1: {
                        favoriteAdd = "FROM_CONTACT";
                        //mainViewState = "Phonebook"
                        //mainBand.selectedBand = "Phonebook"
                        //setMainAppScreen("BtContactMain", false)
                        pushScreen("BtContactMain", 511);
                        favoriteButtonPress = false
                        break;
                    }

                    case 2:
                    case 3:
                    case 11:
                    case 12:
                    case 0:
                    case 13: {
                        // No Download phonebook
                        MOp.showPopup("popup_bt_no_download_phonebook");
                        break;
                    }

                    case 5:
                    case 9:
                    case 10: {
                        // Downloading
                        MOp.showPopup("popup_bt_no_downloading_phonebook");
                        break;
                    }

                    case 4:
                    default:
                        break;
                }
            } else {
                // 10개를 넘을 경우 추가할 수 없음
                MOp.showPopup("popup_Bt_Favorite_Max");
            }
        }
    }

    onMenu1Click: {
        // 삭제
        idMenu.off();

        pushScreen("BtFavoriteDelete", 513);
        delete_type = "favorite";
        //favoriteSelectInt = 0;
    }

    onMenu2Click: {
        // 설정 -> 연결설정
        idMenu.off();

        //__IQS_15MY_ Call End Modify
        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
            /* 통화중일 경우 진입 막음
             */
            MOp.showPopup("popup_bt_invalid_during_call");
        }
        /* CarPlay */
        else if(true == projectionOn) {
            MOp.showPopup("popup_Bt_enter_setting_during_CarPlay")
        }
        else {
            btSettingsEnter = false;
            pushScreen("SettingsBtDeviceConnect", 514);
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

