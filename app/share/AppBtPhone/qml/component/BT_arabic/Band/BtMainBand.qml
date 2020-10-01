/**
 * /BT_arabic/Band/DHBtMainBand.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic/" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MBand
{
    id: idMainBandContainer
    focus: true

    tabBtnFlag: true
    tabBtnCount: 4
    menuBtnFlag: (true == idMenu.loaded)  ? true : false

    menuBtnText: stringInfo.str_Menu

    tabBtnText:  "BAND_DIAL"
    tabBtnText2: "BAND_RECENT"
    tabBtnText3: "BAND_PHONEBOOK"
    tabBtnText4: "BAND_FAVORITE"

    /* 폰북 카운트 표시 여부, 아래 3가지 경우 화면에 표시됨
     * 1) 폰북: 폰북이 있을 경우
     * 2) 즐겨찾기: 즐겨찾기가 있을 경우
     * 3) 다이얼: 전화번호가 입력된 경우
     */
    titleFavoriteImg: {
        // added conditions for icon and number.
        if((selectedBand == "BAND_PHONEBOOK" /*&& gInfoViewState != "ContactsDownLoadingMal"*/ && (contact_value == 7 || contact_value == 1 || contact_value == 5))
            || (selectedBand == "BAND_FAVORITE" && (favorite_nstate == 1 || favorite_nstate == 5))
            || (selectedBand == "BAND_DIAL" && phoneNumInput != "" && dialListView == true && (contact_value == 7 || contact_value == 1 ||contact_value == 2 || contact_value == 5))
            || (selectedBand == "BAND_RECENT" /*&& gInfoViewState != "RecentDownLoadingMal"*/ && (recent_value == 7 || recent_value == 5))) {
            true
        } else {
            false
        }
    }

    // 폰북 카운트
    signalText: {
        if("BAND_DIAL" == selectedBand) {
            dial_list_count
        } else if("BAND_RECENT" == selectedBand) {
            recent_list_count
        } else if("BAND_PHONEBOOK" == selectedBand) {
            contact_list_count
        } else if("BAND_FAVORITE" == selectedBand) {
            BtCoreCtrl.m_nCountFavoriteContactsList
        } else {
            0
        }
    }


    /* INTERNAL functions */
    function backKeyHandler() {
        console.log("% main band backKeyHandler = " + gContactFromCall);
        /* [주의] 유사한 코드가 MainBand, Contact, Infoview에 존재함
         */
        if(true == gContactFromCall) {
            MOp.reshowCallView(8001);
/*
            UIListener.invokePostCallView(3);
            MOp.showCallView(7006);
            gContactFromCall = false;
*/
        } else {
            popScreen(2301);
        }

        // 메인으로 이동 될때 현재 입력 되었던 번호 초기화
        phoneNumInput = "";
    }


    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onSigSetFocusToMainBand: {
            idMainBandContainer.forceActiveFocus();
        }
    }
    

    /* EVENT handlers */
    onBackBtnClicked: { backKeyHandler(); }
    onMenuBtnClicked: { idMenu.show(); }

    onActiveFocusChanged: {
        if(true == activeFocus) {
            idVisualCue.setVisualCue(false, false, true, false)
        }
    }

    // [TAB 1]: Dial
    onTabBtn1Clicked: {
        if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
            switchScreen("BtDialMain", false, 114);
        }
    }

    // [TAB 2]: Call history
    onTabBtn2Clicked: {
        if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
            switch(recent_value) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 8: {
                    MOp.switchInfoViewScreen(recentCallState);
                    break;
                }

                default:
                    switchScreen("BtRecentCall", false, 116);
                    break;
            }
            // UX 변경: 밴드 선택 시 포커스 남아있지 않도록 변경
            //mainBand.forceActiveFocus();
        }
    }

    // [TAB 3]: Phonebook
    onTabBtn3Clicked: {
        console.log("### popupState = " + popupState);
        if(true == iqs_15My && popupState == "" && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
            pressContacts();
            switchScreen("BtContactMain", false, 118);
        } else {
            if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
                switch(contact_value) {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 8:  {
                        MOp.switchInfoViewScreen(contactState);
                        break;
                    }

                    default: {
                        pressContacts();
                        if(true == gPhonebookReload) {
                            /* 언어설정이 바뀔때마다 폰북을 다시 읽어오면 속도 문제가 발생함
                             * 폰북화면이 보일때로 시점 조정
                             */
                            /* 폰북 화면이 Visble Changed 될 때 부르도록 변경
                             */
                            BtCoreCtrl.invokeTrackerReloadPhonebook();
                            gPhonebookReload = false;
                        }

                        switchScreen("BtContactMain", false, 118);
                        break;
                    }
                }
            }
        }
    }

    // [TAB 4]: Favorite
    onTabBtn4Clicked: {
        if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
            if(1 == favoriteValue) {
                // 즐겨찾기가 있을 경우
                // favoirteValue == HAVE state
                switchScreen("BtFavoriteMain", false, 119);
            } else {
                MOp.switchInfoViewScreen("FavoritesNoList");
            }
        }
    }
}
/* EOF*/
