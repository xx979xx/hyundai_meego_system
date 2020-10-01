/**
 * operation.js
 *
 */

/******************************************************************************
 * Heleprs for <, >
 *****************************************************************************/
function greaterThan(left, right)
{
    return (right <= left) ? true : false;
}


function lessThan(left, right)
{
    return !greaterThan(left, right);
}


/******************************************************************************
 * Device names
 *****************************************************************************/
// 디바이스 명에 입력불가능한 문자 Filtering
/*DEPRECATED
function validateDeviceName(name) {
    var regexp = /[:,!,#,$,^,&,*,(,),\-,;,,,\\,/,?,<,>,",']/g

    return (null == name.match(regexp)) ? true : false;
}
DEPRECATED*/

/*DEPRECATED
function excludingHTML(param) {
    console.log("param = " + param);
    console.log("param = " + param.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/'/g, "&#39;").replace(/\\/g, "&#47;"));
    return param.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/'/g, "&#39;").replace(/\\/g, "&#47;").replace(/"/g, "&quot;");
}
DEPRECATED*/


/******************************************************************************
 * Phone numbers
 *****************************************************************************/
function filterPhoneNumber(number)
{
    switch(UIListener.invokeGetCountryVariant()) {
        case 1: /* eCVNorthAmerica */
        case 6: /* eCVCanada */ {
            // +1, 1을 제외한 전화번호 반환
            if(2 < number.length && "+1" == number.substr(0, 2)) {
                return number.substring(2);
            }
            else if(1 < number.length && '1' == number[0]) {
                return number.substring(1);
            }

            break;
        }

        case 0: { /* eCVKorea */
            // +82를 제외한 전화번호 반환
            if(3 < number.length && "+82" == number.substr(0, 3)) {
                return number.substring(3);
            }

            // BtBaseProxy.cpp Comment 참고
            if(6 < number.length && "0" == number.substr(0, 1)) {
                return number.substring(1);
            }

            break;
        }

        default:
            return null;
    }

    return null;
}


function containsNumber(phoneNumber, inputNumber) {
    if(1 > phoneNumber.length) {
        return false;
    }

    var filteredNumber = "";

    // 입력된 번호에 +82 or +1/1 제거
    var regexp = filterPhoneNumber(inputNumber);
    if(null == regexp) {
        regexp = inputNumber;
    }

    // 입력된 번호에 +82 or +1 포함
    regexp = regexp.replace("+", "[+]").replace("*", "[*]");

    // 저장된 번호에서 +82, +1/1 제거
    filteredNumber = filterPhoneNumber(phoneNumber);
    if(null == filteredNumber) {
        filteredNumber = phoneNumber;
    }

    if(0 == filteredNumber.search(regexp)) {
        return true;
    } else {
        return (null == phoneNumber.match(regexp)) ? false : true;
    }

/*DEPRECATED
    var regexp = filterPhoneNumber(inputNumber);
    if(null == regexp) {
        // +1, +82등이 섞여있지 않은 경우, 포함여부를 검사함
        regexp = inputNumber;

        regexp = regexp.replace("+", "[+]").replace("*", "[*]");
        return (null == phoneNumber.match(regexp)) ? false : true;
    }

    // +1, +82등이 섞여 있어 제외하고 검색해야 하는 경우 제일 앞과 matching되는지 검사함
    regexp = regexp.replace("+", "[+]").replace("*", "[*]");

    var filteredNumber = filterPhoneNumber(phoneNumber);
    if(null == filteredNumber) {
        filteredNumber = phoneNumber;
    }

    if(0 == filteredNumber.search(regexp)) {
        // 1-700을 입력했을때 1-700-XXX-XXXX를 검색
        return true;
    } else {
        // 1-700을 입력했을때 XXX-XXX-1700을 검색
        regexp = inputNumber;

        regexp = regexp.replace("+", "[+]").replace("*", "[*]");
        return (null == phoneNumber.match(regexp)) ? false : true;
    }
DEPRECATED*/
}


//return true/false
function containsOnlyNumber(number) {
    if(1 > number.length) {
        return false;
    }

    /* 숫자(그리고 +, *)만 있는 경우 길이가 0 이상
     * 그렇지 않은 경우 length = 0
     */
    number = number.replace(/[^0-9,*,#,+]/g,'')
    if(1 > number.length) {
        //
        return false;
    }

    return true;
}

// return 이름 or dash가 포함된 전화번호 or 발신번호표시제한
function getCallerId(name, number) {
    if("" == name) {
        if("" == number) {
            // 발신자 표시제한번호
            return stringInfo.str_Spam;
        } else {
            return checkPhoneNumber(number);
        }
    } else {
        return name;
    }
}

// return dash가 포함된 전화번호, 발신번호표시제한
function getCallerNumber(phone_number) {
    if(true == containsOnlyNumber(phone_number)) {
        return checkPhoneNumber(phone_number);
    }

    return stringInfo.str_Spam;
}

// return 하이라이팅된 dash 포함 전화번호
function getHighlightNumber(phoneNumber, inputNumber) {
/*DEPRECATED
    var regexp = inputNumber[0]
    if('+' == regexp) {
        regexp = "[+]";
    }
DEPRECATED*/

    var regexp= "";
    for(var i = 0; i < inputNumber.length; i++) {
        regexp = regexp + ((i > 0) ? "-?" : "") + inputNumber[i];
    }

    regexp = regexp.replace("+", "[+]").replace("*", "[*]");

    // Find token from input number including '-'
    var dashToken = phoneNumber.match(regexp);
    if(null == dashToken) {
        // no match

        // 입력된 전화번호 그대로를 검색했을때 matching되지 않는다면
        var searchNumber = filterPhoneNumber(inputNumber);
        if(null == searchNumber) {
            return phoneNumber;
        }

        regexp= "";
        for(var i = 0; i < searchNumber.length; i++) {
            regexp = regexp + ((i > 0) ? "-?" : "") + searchNumber[i];
        }

        dashToken = phoneNumber.match(regexp);
        if(null == dashToken) {
            return phoneNumber;
        }
    }

    // Find start index
    var startIndex = phoneNumber.indexOf(dashToken[0])
    if(0 > startIndex) {
        return phoneNumber;
    }

    var token = new Array();
    token[0] = phoneNumber.substr(0, startIndex);
    token[1] = phoneNumber.substr(startIndex, dashToken[0].length);
    token[2] = phoneNumber.substr(startIndex + dashToken[0].length);

    return token[0] + "<FONT COLOR = GRAY>" + token[1] + "</FONT>" + token[2];
}

// 앞뒤 스페이스가 제거된 전화번호
function stringTrim(phoneNumber)
{
    return phoneNumber.replace(/(^\s*)|(\s*$)/gi, "");
}


/******************************************************************************
 * Screen
 *****************************************************************************/
function closeScreen(screen) {
    console.log("## [closeScreen] " + screen);
    //idMenu.source = ""
    //idMenu.delayedLoad = false;

    switch(screen) {
        case "BtDialMain":              idLoaderDial.unload();                  break;
        case "BtRecentCall":            idLoaderRecents.unload();               break;
        case "BtRecentDelete":          idLoaderRecentsDelete.unload();         break;

        case "BtContactMain":
            idLoaderContacts.unload();
            if("ContactsUpdate" != contactState) {
                favoriteAdd = "";
            }
            break;

        case "BtContactSearchMain":
            idLoaderContactsSearch.unload();
            UIListener.invokeUpdateViewportUpdateMode(false);
            break;
        case "BtFavoriteMain":          idLoaderFavorite.unload();              break;
        case "BtFavoriteDelete":        idLoaderFavoriteDelete.unload();        break;

        case "BtInfoView":
            idLoaderInfoView.unload();
            gInfoViewFocus = false;
            break;

        // Settings
        case "SettingsBtAudioStream":   idLoaderSettingsAudioStream.unload();   break;
        case "SettingsBtDeviceConnect": idLoaderSettingsDeviceConnect.unload(); break;
        case "SettingsBtAutoConn":      idLoaderSettingsAutoConnect.unload();   break;
        case "SettingsBtAutoDown":      idLoaderSettingsAutoDownload.unload();  break;
        case "SettingsBtDeviceName":    idLoaderSettingsDeviceInfo.unload();    break;
        case "SettingsBtCustomer":      idLoaderSettingsCustomerCenter.unload();break;
        case "SettingsBtPINCodeChange": idLoaderSettingsPINCode.unload();       break;
        case "SettingsBtNameChange":
            idLoaderSettingsDeviceName.unload();
            UIListener.invokeUpdateViewportUpdateMode(false);
            break;
        case "BtDeviceDelMain":         idLoaderSettingsDeviceDelete.unload();  break;

        /* Siri */
        case "BtSiriView":
            idLoaderSiri.unload();
            lastView = ""
            break;

        default:
            break;
    }
}

function hideScreen(screen) {
    console.log("## [hideScreen] " + screen);

    idMenu.hide();
    //idMenu.source = ""
    //idMenu.delayedLoad = false;

    switch(screen) {
        case "BtDialMain":          idLoaderDial.hide();                    break;
        case "BtRecentCall":        idLoaderRecents.hide();                 break;
        case "BtRecentDelete":      idLoaderRecentsDelete.hide();           break;
        case "BtContactMain":       idLoaderContacts.hide();                break;
        case "BtContactSearchMain":
            idLoaderContactsSearch.hide();
            UIListener.invokeUpdateViewportUpdateMode(false);
            break;
        case "BtFavoriteMain":      idLoaderFavorite.hide();                break;
        case "BtFavoriteDelete":    idLoaderFavoriteDelete.hide();          break;

        case "BtInfoView":
            idLoaderInfoView.hide();
            gInfoViewFocus = false;
            break;

        // Setting
        case "SettingsBtAudioStream":
            idLoaderSettingsLeft.hide();
            idLoaderSettingsAudioStream.hide();
            break;

        case "SettingsBtDeviceConnect":
            idLoaderSettingsLeft.hide();
            idLoaderSettingsDeviceConnect.hide();
            break;

        case "SettingsBtAutoConn":
            idLoaderSettingsLeft.hide(false);
            idLoaderSettingsAutoConnect.hide();
            break;

        case "SettingsBtAutoDown":
            idLoaderSettingsLeft.hide();
            idLoaderSettingsAutoDownload.hide();
            break;

        case "SettingsBtDeviceName":
            idLoaderSettingsLeft.hide();
            idLoaderSettingsDeviceInfo.hide();
            break;

        case "SettingsBtCustomer":
            idLoaderSettingsLeft.hide();
            idLoaderSettingsCustomerCenter.hide();
            break;

        // Setting sub
        case "SettingsBtPINCodeChange": idLoaderSettingsPINCode.hide();     break;
        case "SettingsBtNameChange":
            idLoaderSettingsDeviceName.hide();
            UIListener.invokeUpdateViewportUpdateMode(false);
            break;
        case "BtDeviceDelMain":         idLoaderSettingsDeviceDelete.hide();break;

        // Siri
        case "BtSiriView":
            idLoaderSiri.hide();
            break;

        default:
            break;
    }
}

function showScreen(screen) {
    console.log("## [showScreen] " + screen);
    //idMenu.source = "";
    //idMenu.delayedLoad = false;

    /*if(true == UIListener.invokeRequestCameraMode()) {
        idMenu.off();
    }*/

    BtCoreCtrl.invokeRequestCloseSystemPopup();

    lastView = screen
    idAppMain.state = screen

    switch(screen) {
        /* Dial */
        case "BtDialMain" : {
            menuSourcePath = "../../BT/Dial/Main/BtDialOptionMenu.qml";
            menuSourcePathArab = "../../BT_arabic/Dial/Main/BtDialOptionMenu.qml"

            idLoaderDial.show();
            showBand("BAND_DIAL");

            idLoaderDial.forceActiveFocus();
            btPhoneEnter = true;
            mainViewState = "Dial";
            popupBackGroundBlack = true

            if(true == gPhonebookReload) {
                BtCoreCtrl.invokeTrackerReloadPhonebook();
                gPhonebookReload = false
            }

            if(true == gPhonebookReloadForDial) {
                if("" != phoneNumInput) {
                    /* Dial에 입력 값이 있는 경우 입력 값에 대하여 검색 */
                    BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);

                    gPhonebookReloadForDial = false
                }
            }

            beforeFocus = "MAINVIEW"

            break;
        }

        /* Recents */
        case "BtRecentCall" : {
            if(true == iqs_15My)
            {
                menuSourcePath = "../../BT/Recent/BtRecentOptionMenuNoDelete.qml";
                menuSourcePathArab = "../../BT_arabic/Recent/BtRecentOptionMenuNoDelete.qml";
            }
            else
            {
                menuSourcePath = "../../BT/Recent/BtRecentOptionMenu.qml";
                menuSourcePathArab = "../../BT_arabic/Recent/BtRecentOptionMenu.qml";
            }

            idLoaderRecents.show();
            showBand("BAND_RECENT");

            btPhoneEnter = true;
            mainViewState = "RecentCall";
            popupBackGroundBlack = true

            beforeFocus = "MAINVIEW"

            break;
        }

        case "BtRecentDelete": {
            menuSourcePath = "../../BT/Recent/Delete/BtRecentDeleteOptionMenu.qml";
            menuSourcePathArab = "../../BT_arabic/Recent/Delete/BtRecentDeleteOptionMenu.qml";

            idLoaderRecentsDelete.show();
            hideBand();

            btPhoneEnter = true;
            popupBackGroundBlack = true

            beforeFocus = "MAINVIEW"

            break;
        }

        /* Contact */
        case "BtContactMain": {
            if("" == favoriteAdd) {
                menuSourcePath = "../../BT/Contacts/BtContactOptionMenu.qml"
                menuSourcePathArab = "../../BT_arabic/Contacts/BtContactOptionMenu.qml";
            } else {
                // 즐겨찾기 등록
                menuSourcePath = "";
                menuSourcePathArab = "";
            }

            idLoaderContacts.show();

            if("" == favoriteAdd) {
                showBand("BAND_PHONEBOOK");
            } else {
                // favorite_add 상태일때 Band는 없음
                hideBand();
            }

            mainViewState = "Phonebook";
            btPhoneEnter = true;
            popupBackGroundBlack = true

            beforeFocus = "MAINVIEW"

            break;
        }

        case "BtContactSearchMain": {
            menuSourcePath = ""
            menuSourcePathArab = ""

            UIListener.invokeUpdateViewportUpdateMode(true);
            idLoaderContactsSearch.show();
            hideBand();

            btPhoneEnter = true;
            popupBackGroundBlack = true

            /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
             * 주행규제 팝업을 출력하도록 수정
             */
            if(1 > callType && false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                if("BtContactSearchMain" == idAppMain.state
                    || "SettingsBtNameChange" == idAppMain.state
                    || "SettingsBtPINCodeChange" == idAppMain.state) {
                	showPopup("popup_search_while_driving");
                }
            }

            beforeFocus = "MAINVIEW"

            break;
        }

        /* Favorite */
        case "BtFavoriteMain": {
            menuSourcePath = "../../BT/Favorite/BtFavoriteOptionMenu.qml";
            menuSourcePathArab = "../../BT_arabic/Favorite/BtFavoriteOptionMenu.qml";

            idLoaderFavorite.show();
            showBand("BAND_FAVORITE");

            btPhoneEnter = true;
            mainViewState = "Favorite";
            popupBackGroundBlack = true

            beforeFocus = "MAINVIEW"

            break;
        }

        case "BtFavoriteDelete": {
            menuSourcePath = "../../BT/Favorite/Delete/BtFavoriteDeleteOptionMenu.qml";
            menuSourcePathArab = "../../BT_arabic/Favorite/Delete/BtFavoriteDeleteOptionMenu.qml";

            idLoaderFavoriteDelete.show();

            hideBand();
            btPhoneEnter = true;
            popupBackGroundBlack = true

            beforeFocus = "MAINVIEW"

            break;
        }

        /* Common */
        case "BtInfoView": {
            menuSourcePath = ""
            menuSourcePathArab = ""

            idLoaderInfoView.show();

            switch(gInfoViewState) {
                case "FavoritesNoList": {
                    menuSourcePath = "../../BT/Favorite/BtFavoriteOptionMenu.qml";
                    menuSourcePathArab = "../../BT_arabic/Favorite/BtFavoriteOptionMenu.qml";

                    showBand("BAND_FAVORITE");
                    mainViewState = "Favorite";

                    // 즐겨찾기 항목이 없는 경우에도 메뉴 버튼 추가
                    gInfoViewFocus = true
                    beforeFocus = "MAINVIEW"

                    if((13 == contact_nstate) || (4 == favorite_nstate)) {
                        // 전화번호부 다운로드 지원하지 않는 항목이라면 포커스 이동 할수 없도록 변수 설정
                        gInfoViewFocus = false;
                        beforeFocus = "MAINBAND"
                    }

                    break;
                }

                case "ContactsDownLoadingMal":
                case "ContactsNotSupport":
                case "ContactsWaitDownAuto":
                case "ContactsDownLoading":
                case "ContactsUpdate":
                {
                    menuSourcePath = "../../BT/Contacts/BtContactOptionMenu.qml";
                    menuSourcePathArab = "../../BT_arabic/Contacts/BtContactOptionMenu.qml";
                    showBand("BAND_PHONEBOOK");
                    mainViewState = "Phonebook";
                    gInfoViewFocus = false;
                    beforeFocus = "MAINBAND"
                    break;
                }

                case "ContactsWaitDownMal":{
                    menuSourcePath = "../../BT/Contacts/BtContactOptionMenu.qml";
                    menuSourcePathArab = "../../BT_arabic/Contacts/BtContactOptionMenu.qml";
                    showBand("BAND_PHONEBOOK");
                    mainViewState = "Phonebook";
                    gInfoViewFocus = true;
                    beforeFocus = "MAINVIEW"
                    break;
                }

                case "RecentDownLoadingMal":
                case "recent_no_list":
                case "recent_not_support":
                case "RecentWaitDownAuto":
                case "recent_auto_downloading": {
                    if(true == iqs_15My)
                    {
                        menuSourcePath = "../../BT/Recent/BtRecentOptionMenuNoDelete.qml";
                        menuSourcePathArab = "../../BT_arabic/Recent/BtRecentOptionMenuNoDelete.qml";
                    }
                    else
                    {
                        menuSourcePath = "../../BT/Recent/BtRecentOptionMenu.qml";
                        menuSourcePathArab = "../../BT_arabic/Recent/BtRecentOptionMenu.qml";
                    }					
                    showBand("BAND_RECENT");
                    mainViewState = "RecentCall";
                    gInfoViewFocus = false;
                    beforeFocus = "MAINBAND"
                    break;
                }

                case "recent_mal_download_wait": {
                    if(true == iqs_15My)
                    {
                        menuSourcePath = "../../BT/Recent/BtRecentOptionMenuNoDelete.qml";
                        menuSourcePathArab = "../../BT_arabic/Recent/BtRecentOptionMenuNoDelete.qml";
                    }
                    else
                    {
                        menuSourcePath = "../../BT/Recent/BtRecentOptionMenu.qml";
                        menuSourcePathArab = "../../BT_arabic/Recent/BtRecentOptionMenu.qml";
                    }
                    showBand("BAND_RECENT");
                    mainViewState = "RecentCall";
                    gInfoViewFocus = true;
                    beforeFocus = "MAINVIEW"
                    break;
                }

                default:
                    console.log("### invalid infoState = " + gInfoViewState);
                    break;
            }

            btPhoneEnter = true;

            idAppMain.state = "BtInfoView"
            popupBackGroundBlack = true
            break;
        }

        /* Siri */
        case "BtSiriView":
            idLoaderSiri.show();
            popupBackGroundBlack = true
            break;

        /* Settings */
        case "SettingsBtDeviceConnect":
        case "SettingsBtAutoConn":
        case "SettingsBtAutoDown":
        case "SettingsBtAudioStream":
        case "SettingsBtDeviceName":
        case "SettingsBtCustomer": {
            menuSourcePath = ""
            menuSourcePathArab = ""

            // 연결설정
            if("SettingsBtDeviceConnect" == idAppMain.state){
                menuSourcePath = "../../BT/Setting/BtRightView/SettingsBtDeviceConnect/BTSettingsDeviceConnectOptionMenu.qml";
                menuSourcePathArab = "../../BT_arabic/Setting/BtRightView/SettingsBtDeviceConnect/BTSettingsDeviceConnectOptionMenu.qml";
            }

            mainViewState = "";
            hideBand();

            idLoaderSettingsLeft.show();

            switch(screen) {
                case "SettingsBtDeviceConnect":
                    settingCurrentIndex = 0;
                    idLoaderSettingsDeviceConnect.show();
                    break;

                case "SettingsBtAutoConn":
                    settingCurrentIndex = 1;
                    idLoaderSettingsAutoConnect.show();
                    break;

                case "SettingsBtAutoDown":
                    settingCurrentIndex = 2;
                    idLoaderSettingsAutoDownload.show();
                    break;

                case "SettingsBtAudioStream":
                    settingCurrentIndex = 3;
                    idLoaderSettingsAudioStream.show();
                    break;

                case "SettingsBtDeviceName":
                    settingCurrentIndex = 4;    // 0-based index
                    idLoaderSettingsDeviceInfo.show();
                    break;

                case "SettingsBtCustomer":
                    settingCurrentIndex = 5;    // 0-based index
                    idLoaderSettingsCustomerCenter.show();
                    break;
            }

            // 설정 좌측 리스트에 포커스 설정
            //idLoaderSettingsLeft.focus = true;
            btPhoneEnter = false;
            popupBackGroundBlack = true

            if((true == bgCheck) && ("SettingsBtDeviceConnect" == screen)) {
                bgCheck = false;
            } else if ((false == bgCheck) && ("SettingsBtDeviceConnect" == screen)) {
                beforeFocus = "MAINVIEW"
            }

            break;
        }

        case "SettingsBtNameChange": {
            menuSourcePath = ""
            menuSourcePathArab = ""

            // 기기명 변경
            mainViewState = "";
            hideBand();

            idLoaderSettingsDeviceName.show();
            btPhoneEnter = false;
            UIListener.invokeUpdateViewportUpdateMode(true);
            popupBackGroundBlack = true

            /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
             * 주행규제 팝업을 출력하도록 수정
             */
            if(1 > callType && false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                if("BtContactSearchMain" == idAppMain.state
                    || "SettingsBtNameChange" == idAppMain.state
                    || "SettingsBtPINCodeChange" == idAppMain.state) {
	                showPopup("popup_search_while_driving");
                }
            }
            break;
        }

        case "SettingsBtPINCodeChange": {
            menuSourcePath = ""
            menuSourcePathArab = ""

            // PIN 코드 변경
            mainViewState = "";
            hideBand();

            idLoaderSettingsPINCode.show();
            btPhoneEnter = false;
            popupBackGroundBlack = true

            /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
             * 주행규제 팝업을 출력하도록 수정
             */
            if(1 > callType && false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                if("BtContactSearchMain" == idAppMain.state
                    || "SettingsBtNameChange" == idAppMain.state
                    || "SettingsBtPINCodeChange" == idAppMain.state) {
                	showPopup("popup_search_while_driving");
            	}
	    }
            break;
        }

        case "BtDeviceDelMain": {
            menuSourcePath = "../../BT/Device/Delete/BtDeviceDeleteOptionMenu.qml";
            menuSourcePathArab = "../../BT_arabic/Device/Delete/BtDeviceDeleteOptionMenu.qml";

            // 디바이스 삭제
            mainViewState = "";
            hideBand();

            idLoaderSettingsDeviceDelete.show();
            btPhoneEnter = false;
            popupBackGroundBlack = true
            break;
        }

        default:
            break;
    }

    returnFocus();
}

function findScreen(screen) {
    if(0 > UIListener.invokeFindScreen(screen)) {
        console.log("####################################");
        console.log("Can't find screen = " + screen);
        console.log("####################################");
        return false;
    }

    return true;
}

function clearScreen(case_num) {
    debugStack("clearScreen", case_num);

    var count = UIListener.invokeGetScreenSize();
    if(0 < count) {
        var top_screen = UIListener.invokeTopScreen();

        // 마지막 화면을 close 해주지 않으면 잔상에 의해 화면겹침현상 발생함
        closeScreen(top_screen);

        UIListener.invokeClearScreen();
    } else {
        // do nothing
    }

    mainViewState = "";
    idAppMain.state = "";

    returnFocus();
}

function raiseScreen(to_screen, case_num) {
    debugStack("raiseScreen", case_num);

    /* 설정을 제외한 모든 화면을 제거함(e.g. dial, phonebook, phonebook search 등)
     * 이때, screen stack 순서는 유지되며, 주어진 화면을 취상위에 위치시킴(화면을 끌어올리는 효과)
     */
    var count = UIListener.invokeGetScreenSize();

    if(0 < count) {
        // 최상위 화면을 hiding
        hideScreen(UIListener.invokeTopScreen());

        for(var i = count; i > 0; i--) {
            var screen = UIListener.invokeGetScreen(i - 1);
            switch(screen) {
                case "BtDialMain":
                case "BtRecentCall":
                case "BtRecentDelete":
                case "BtContactMain":
                case "BtContactSearchMain":
                case "BtFavoriteMain":
                case "BtFavoriteDelete":
                case "BtInfoView": {
                    console.log("## remove: " + screen);
                    UIListener.invokeRemoveScreen(i - 1);
                    break;
                }

                default:
                    break;
            }
        }
    }

    debugScreen("raiseScreen", "", to_screen, case_num);
    pushScreen(to_screen, case_num);
}

function recallScreen(to_screen, case_num) {
    debugStack("recallScreen", case_num);

    /* 주어진 화면이 최상위에 없으면 모든 screen stack을 비우고 주어진 화면으로 이동함
     */
    var top_screen = UIListener.invokeTopScreen();
    if(top_screen == to_screen) {
        // do nothing
        console.log("## already top screen");
        return false;
    }

    clearScreen(773);
    pushScreen(to_screen, 772);

    debugScreen("recallScreen", "", to_screen, 773);
    return true;
}

function recoverScreen(type) {
    console.log("% recoverScreen() " + type);
    if(1 > UIListener.invokeGetScreenSize()) {
        if("DIAL" == type) {
            if(10 == BtCoreCtrl.m_ncallState) {
                // 화면복구가 필요할때 수신팝업이 떠 있다면 다이얼화면을 복구하지 않음
            } else {
                pushScreen("BtDialMain", 989);
            }
        } else if("SETTINGS" == type) {
            switch(settingCurrentIndex) {
                case 1: pushScreen("SettingsBtAutoConn", 981);     break;
                case 2: pushScreen("SettingsBtAutoDown", 982);     break;
                case 3: pushScreen("SettingsBtAudioStream", 983);  break;
                case 4: pushScreen("SettingsBtDeviceName", 984);   break;
                case 5: pushScreen("SettingsBtCustomer", 985);     break;

                case 0:
                default:
                    pushScreen("SettingsBtDeviceConnect", 986);
                    if("" == popupState) {
                        idLoaderSettingsLeft.forceActiveFocus();
                    }
                    break;
            }

            //[ITS 0269965 - BT 설정 화면에서 DISP OFF > 신규 기기 등록 팝업 출력 후 취소 시 팝업 유지 됨]
            if("popup_Bt_SSP_Add" == popupState) {
                textPopupName = "";
                popupState = "";
            }

        } else {
            console.log("recoverScreen - INVALID type");
        }
    } else {
        if("SETTINGS" == type) {
            clearScreen(1511);
            switch(settingCurrentIndex) {
                case 1: pushScreen("SettingsBtAutoConn", 981);     break;
                case 2: pushScreen("SettingsBtAutoDown", 982);     break;
                case 3: pushScreen("SettingsBtAudioStream", 983);  break;
                case 4: pushScreen("SettingsBtDeviceName", 984);   break;
                case 5: pushScreen("SettingsBtCustomer", 985);     break;

                case 0:
                default:
                    pushScreen("SettingsBtDeviceConnect", 986);
                    if("" == popupState) {
                        idLoaderSettingsLeft.forceActiveFocus();
                    }
                    break;
            }
        } else {
            var top_screen = UIListener.invokeTopScreen();
            console.log("# DO NOT recover, just show top screen = " + top_screen);

            // 화면 재진입 시 최상위 화면이 Siri화면인 경우 Dial 화면으로 표시하도록 수정
            if("BtSiriView" == top_screen) {
                showScreen("BtDialMain");

                //[ITS 0269879]
                if("BtSiriView" == top_screen){
                    if(1 == UIListener.invokeGetScreenSize()){
                        console.log("# appEntryPoint:" + appEntryPoint);
                        if((appEntryPoint == 8)||(appEntryPoint == 9)){
                            console.log("# Recover fail... so close siriview");
                            UIListener.invokePostBackKey();
                        }
                    }
                }

            } else {
                showScreen(top_screen);
            }
        }
    }
}

function removeScreen(to_screen, case_num) {
    MOp.debugStack("removeScreen", case_num);

    var from_screen;

    if(2 > UIListener.invokeGetScreenSize()) {
        /* 더 이상 빠질 화면이 없을 경우 Home으로 돌아감
         */
        UIListener.invokePostBackKey();
        to_screen = "BACK";

        // HOME으로 돌아갈때 closeScreen을 하면 화면이 사라지고 HOME로 빠지는 현상이 발생함
        // --> 재 진입 시점에 Stack clear 처리필요
        //from_screen = UIListener.invokePopScreen();
        //MOp.closeScreen(from_screen);

        idAppMain.state = "";
    } else {
        /* 선택한 화면을 screen stack에서 제거함
         * 이때 선택한 화면이 최상위에 있을 경우 아래 화면을 표시하고
         * 최상위 화면이 아닌 경우 stack에서만 빼냄
         */
        var top_screen = UIListener.invokeTopScreen();
        if(top_screen == to_screen) {
            UIListener.invokePopScreen();
            MOp.closeScreen(top_screen);
        } else {
            for(var i = UIListener.invokeGetScreenSize(); i > 0; i--) {
                if(to_screen == UIListener.invokeGetScreen(i - 1)) {
                    UIListener.invokeRemoveScreen(i - 1);
                    MOp.closeScreen(to_screen);
                    break;
                }
            }
        }

        to_screen = UIListener.invokeTopScreen();
        MOp.showScreen(to_screen);

        idAppMain.state = to_screen;
    }

    MOp.debugScreen("removeScreen", from_screen, to_screen, case_num);
    return;
}

// Helpers
function isSettingsScreen(screen) {
    switch(screen) {
        case "SettingsBtAutoConn":
        case "SettingsBtAutoDown":
        case "SettingsBtAudioStream":
        case "SettingsBtDeviceName":
        case "SettingsBtCustomer":
        case "SettingsBtDeviceConnect":
        case "SettingsBtNameChange":
        case "SettingsBtPINCodeChange":
        case "BtDeviceDelMain":
            return true;

        default:
            return false;
    }
}

function debugStack(function_name, case_num) {
    console.log("=====================================================");
    console.log("[" + function_name + "] case: " + case_num);
    for(var i = UIListener.invokeGetScreenSize(); i > 0; i--) {
        console.log("== (" + (i - 1) + ") " + UIListener.invokeGetScreen(i - 1));
    }
    console.log("=====================================================");
}

function debugScreen(function_name, from_screen, to_screen, case_num) {
    console.log("*********************************************************");
    if("" == from_screen) {
        console.log("[" + function_name + "] from: "    + UIListener.invokeTopScreen());
    } else {
        console.log("[" + function_name + "] from: "    + from_screen);
    }

    console.log("[" + function_name + "] to: "      + to_screen);
    console.log("[" + function_name + "] case: "    + case_num);
    console.log("[" + function_name + "] mainViewState: " + mainViewState);
    console.log("[" + function_name + "] btPhoneEnter: " + btPhoneEnter);
    console.log("[" + function_name + "] btSettingsEnter: " + btSettingsEnter);
    console.log("[" + function_name + "] siriViewState: " + siriViewState);
    console.log("[" + function_name + "] callType: " + callType);
    console.log("*********************************************************");
}


/******************************************************************************
 * Band
 *****************************************************************************/
function showBand(band) {
    switch(band) {
        case "BAND_DIAL":
        case "BAND_RECENT":
        case "BAND_PHONEBOOK":
        case "BAND_FAVORITE": {
            selectedBand = band;
            idLoaderMainBand.show();

            sigSetSelectedBand(band);
            break;
        }

        default:
            break;
    }
}

function hideBand() {
    idLoaderMainBand.hide();
}


/******************************************************************************
 * FOCUS!!!
 *****************************************************************************/
// 포커스를 가지고 있어야할 곳으로 되돌림(상황에 맞춰서..)
function returnFocus() {
    if("FOREGROUND" == callViewState) {
        // 콜화면이 표시되고 있을때는 무조건 콜화면으로 포커스를 되돌림
        if("" != popupState) {
            // 콜화면이라도 Ford 특허팝업은 표시될 수 있으므로 검사
            idLoaderPopup.forceActiveFocus();
            idLoaderPopup.resetFocus()
            return;
        }

        idLoaderCallView.forceActiveFocus();

        if(true == siriViewState) {
            idLoaderSiri.forceActiveFocus();
        }
    } else {
        console.log("\n\n## beforeFocus : " + beforeFocus);
        console.log("## idLoaderMainBand.visible : " + idLoaderMainBand.visible);
        console.log("## popupState : " + popupState);
        console.log("## menuOn : " + menuOn);
        if(beforeFocus == "MAINBAND" && true == idLoaderMainBand.visible) {
            if("BtSiriView" == idAppMain.state) {
            } else {
                idLoaderMainBand.setFocus();
            }

            if("" != popupState) {
                /* 상황에 맞춰 포커스를 돌렸음에도 팝업이 떠있는 경우는 팝업에 우선권을 줌
                 */
                //idLoaderPopup.forceActiveFocus();
                console.log("***\n\npopupState != ''\n\n\n****")
                idLoaderPopup.resetFocus();
                return;
            }

            if(menuOn == true) {
                idMenu.forceActiveFocus();
                return;
            }

        } else if(beforeFocus == "SETTINGBAND" && true == idLoaderSettingsBand.visible) {
            idLoaderSettingsBand.setFocus();

            if("" != popupState) {
                /* 상황에 맞춰 포커스를 돌렸음에도 팝업이 떠있는 경우는 팝업에 우선권을 줌
                 */
                //idLoaderPopup.forceActiveFocus();
                console.log("***\n\npopupState != ''\n\n\n****")
                idLoaderPopup.resetFocus();
                return;
            }

            if(menuOn == true) {
                idMenu.forceActiveFocus();
                return;
            }
        } else if(beforeFocus == "SETTINGLEFT" && true == idLoaderSettingsLeft.visible) {
            idLoaderSettingsLeft.forceActiveFocus();

            if("" != popupState) {
                /* 상황에 맞춰 포커스를 돌렸음에도 팝업이 떠있는 경우는 팝업에 우선권을 줌
                 */
                //idLoaderPopup.forceActiveFocus();
                console.log("***\n\npopupState != ''\n\n\n****")
                idLoaderPopup.resetFocus();
                return;
            }

            if(menuOn == true) {
                idMenu.forceActiveFocus();
                return;
            }
        } else if(beforeFocus == "SIRIVIEW" && true == idLoaderSiri.visible) {
            idLoaderSiri.forceActiveFocus();
        } else {
            // "BACKGROUND" and "IDLE" == callViewState

            /* 콜화면이 표시되고 있지 않을때 적절한 곳으로 포커스를 설정함
             */
            if("" != popupState) {
                /* 상황에 맞춰 포커스를 돌렸음에도 팝업이 떠있는 경우는 팝업에 우선권을 줌
                 */
                //idLoaderPopup.forceActiveFocus();
                console.log("***\n\npopupState != ''\n\n\n****")
                idLoaderPopup.resetFocus();
                return;
            }

            if(menuOn == true) {
                idMenu.forceActiveFocus();
                return;
            }

            /*if(true == idLoaderMainBand.activeFocus) {
                /* 통화 종료 시 포커스가 Band에 있는 경우 아무동작 하지 않음
                 * 언어변경으로 Reloading될 경우 포커스 재설정이 필요함
                 *
                console.log("######################################### 1");
                idLoaderMainBand.forceActiveFocus();
                return;
            }*/

            var top_screen = UIListener.invokeTopScreen();
            console.log("## top_screen : " + top_screen);
            switch(top_screen) {
                case "BtDialMain":          idLoaderDial.setFocus();            break;
                case "BtRecentCall":        idLoaderRecents.setFocus();         break;
                case "BtRecentDelete":      idLoaderRecentsDelete.setFocus();   break;
                case "BtContactMain":       idLoaderContacts.setFocus();        break;
                case "BtContactSearchMain": idLoaderContactsSearch.setFocus();  break;
                case "BtFavoriteMain":      idLoaderFavorite.setFocus();        break;

                case "BtFavoriteDelete":
                    idLoaderFavoriteDelete.setFocus();
                    break;

                case "BtInfoView": {
                    if(false == gInfoViewFocus) {
                        idLoaderMainBand.forceActiveFocus();
                    } else {
                        idLoaderInfoView.setFocus();
                    }
                    break;
                }

                case "BtSiriView":              idLoaderSiri.setFocus();                    break;
                case "SettingsBtDeviceConnect": idLoaderSettingsDeviceConnect.setFocus();   break;
                case "SettingsBtAutoConn":      idLoaderSettingsAutoConnect.setFocus();     break;
                case "SettingsBtAutoDown":      idLoaderSettingsAutoDownload.setFocus();    break;

                case "SettingsBtDeviceName":
                    idLoaderSettingsDeviceInfo.setFocus();
                    break;

                case "SettingsBtNameChange":    idLoaderSettingsDeviceName.setFocus();      break;
                case "SettingsBtPINCodeChange": idLoaderSettingsPINCode.setFocus();         break;
                case "BtDeviceDelMain":         idLoaderSettingsDeviceDelete.setFocus();    break;

                /* 세팅 화면에서 우측에 포커스가 이동 할 수 없는 화면
                 * 포커스는 왼쪽 리스트 버튼쪽으로 이동
                 */
                case "SettingsBtAudioStream":
                case "SettingsBtCustomer":
                    idLoaderSettingsLeft.setFocus();
                    break;

                default:
                    console.log("## invalid focus target: " + top_screen);
                    break;
            }
        }
    }
}


/******************************************************************************
 * Key wrappers
 *****************************************************************************/
function postBackKey(case_num) {
    console.log("=========================================================");
    console.log("[postBackKey] case: " + case_num);
    console.log("=========================================================");
    UIListener.invokePostBackKey();
}

function postPopupBackKey(case_num) {
    console.log("=========================================================");
    console.log("[postPopupBackKey] case: " + case_num);
    console.log("=========================================================");
    UIListener.invokePostPopupBackKey();

    // 재연결 팝업에서 "아니오"버튼 눌렀을 때 설정화면으로 이동하면서 화면 깨지는 문제 수정
    //DEPRECATED clearScreen(4081);
}

/******************************************************************************
 * InfoView
 *****************************************************************************/
function switchInfoViewScreen(state) {
    console.log("% switchInfoViewScreen() " + state);
    idMenu.hide();

    gInfoViewState = state;
    switchScreen("BtInfoView", false, 9001);
}


/******************************************************************************
 * Siri
 *****************************************************************************/
function showSiriView() {
    if(1 == gIgnoreReleased) {
        gIgnoreReleased = 0
        btnReleased()
    }

    //console.log("########################################");
    //console.log("showSiriView() = ", siriViewState);
    //console.log("########################################");

    //Siri 표시 될 때, 입력된 Touch 동작 무시하도록 방어 코드 추가
    UIListener.invokeSendTouchCleanUpForApps();

    pushScreen("BtSiriView", 1999);
    //phoneNumInput = ""
    siriLastViewSave = true
    idLoaderSiri.setFocus()
    siriViewState = true;
    //16MY
    BtCoreCtrl.invokeGetSiriView(true);
}

function hideSiriView(switchScreen) {

    /* [ITS 0233155]
    sigHideSiri();
    console.log("########################################");
    console.log("hideSiriView() = ", siriViewState);
    console.log("########################################");
    */

    if(true == siriViewState) {
        siriViewState = false;
        //16MY
        BtCoreCtrl.invokeGetSiriView(false);

        if(true == switchScreen) {
            // Siri중 전화를 할 경우
            debugStack("siri off", 1);
            var from_screen = UIListener.invokePopScreen();
            closeScreen(from_screen);

            if(0 < UIListener.invokeGetScreenSize()) {
                var to_screen = UIListener.invokeTopScreen();
                showScreen(to_screen);
                idAppMain.state = to_screen;
            }
        } else if(popupState == "popup_Bt_Disconnect_By_Phone") {
            /* Siri실행 후 폰에서 BT 연결 해제했을 경우
             * Dial화면, Settings화면에서 팝업을 띄웠는지를 보고 해당 화면을 보여주도록 한다.
             * 안했을 경우 Black Screen문제가 발생함
             */
            var from_screen = UIListener.invokePopScreen();
            closeScreen(from_screen);

            if(0 < UIListener.invokeGetScreenSize()) {
                var to_screen = UIListener.invokeTopScreen();
                showScreen(to_screen);

                idAppMain.state = to_screen;
            }
        } else {
            popScreen(2000);
        }
    } else {
        console.log("## siriViewState = ", siriViewState);
    }
}

function closeSiriView() {
    console.log ("siri get state = "+ BtCoreCtrl.invokeSiriGetState());

    BtCoreCtrl.invokeSiriStopFromKeyHandler();
    MOp.hideSiriView(false);

    if(true == BtCoreCtrl.invokeSiriGetState()) {
        /* ISV(NA) 75223
         * ISV(NA) 75219
         * Media, Mode 키를 누를 경우 Key Event 없이 BG만 전달됨 Siri 종료 필요함
         */
        BtCoreCtrl.invokeSiriCancel();
    }

    /* Siri가 제일 상단에 있을 경우 CloseScreen 없이 BG로 빠질 경우 다음번 화면이 모두 Siri 화면에 의해 덮혀 보이지 않는 문제 발생함
     */
    var screen = UIListener.invokeTopScreen();
    bgCheck = true;
    console.log("screen = " + screen);
    console.log("FOCUS = " + beforeFocus);
    console.log("bgCheck = " + bgCheck);

    if("BtSiriView" == screen) {
        /* Home 화면에서 Siri 실행 후 후방카메라 진입 > Incoming Call > 후방카메라 해제 했을 때 Siri 화면 남아있는 문제 수정
         * Home 화면에서 popupScreen은 invokeBackKey처리가 됨
         */
        UIListener.invokePopScreen();
        closeScreen(screen);
    }
}


/******************************************************************************
 * CALL!!!
 *****************************************************************************/
function initCallView(case_num) {
    //console.log("###################################################");
    //console.log("## initCallView() = " + callViewState + ", case_num = " + case_num);
    //console.log("###################################################");
    if("IDLE" == callViewState) {
        // Already IDLE state
        return;
    }

    if("DELAYED_IDLE" == callViewState) {
        console.log("# DELAYED_IDLE");
        callViewState = "IDLE";
        BtCoreCtrl.invokeGetCallView(callViewState);
        return;
    }

    gContactFromCall = false;

    if(0 < UIListener.invokeGetScreenSize()) {
        callViewState = "IDLE";

        var top_screen = UIListener.invokeTopScreen();
        if("" == top_screen) {
            console.log("## [error] top screen is EMPTY");
            postBackKey(9872);
        } else {
            showScreen(top_screen);
        }
    } else {
        //DEPRECATED postBackKey(9871);
        //DEPRECATED callViewState = "DELAYED_IDLE";
        callViewState = "IDLE";
        if(false == UIListener.invokeGetAppState()) {
            // App이 이미 Background 상태라면 화면복구가 필요없음
            console.log("#################################################");
            console.log("Already in background, DO NOT recover!");
            console.log("#################################################");
        } else {
            recallScreen("BtDialMain", 4081);
        }
    }
    BtCoreCtrl.invokeGetCallView(callViewState);
}

function showCallView() {
    if(callViewState != "FOREGROUND") {
        if(1 == gIgnoreReleased) {
            gIgnoreReleased = 0
            btnReleased()
        }
    }

    //console.log("###################################################");
    //console.log("## showCallView()");
    //console.log("###################################################");

    callViewState = "FOREGROUND";
    BtCoreCtrl.invokeGetCallView(callViewState);
    //__NEW_FORD_PATENT__ start 포더 특허 변경 사양 적용.
    // 포드 특허 상태에서 CallView시 포더 특허 popup 이 없으면 show
    BtCoreCtrl.invokeCallFordPatentPopup(true);
    //__NEW_FORD_PATENT__ end
    // 통화중 setting 진입 popup 상태 초기화
    BtCoreCtrl.invokeSetEnterSettingDuringCall(false);

    // 시스템 팝업 종료
    BtCoreCtrl.invokeRequestCloseSystemPopup();
}

function reshowCallView() {
    //console.log("###################################################");
    //console.log("## reshowCallView()");
    //console.log("###################################################");
    if(true == gContactFromCall) {
        showCallView(7009);
        gContactFromCall = false;

        //DEPRECATED UIListener.invokePostCallView();
    }

    var from_screen = UIListener.invokePopScreen();
    closeScreen(from_screen);

    /* 최근통화/폰북/즐겨찾기 등 -> 메뉴/설정 -> 통화 -> 폰북 -> BACK -> 통화종료의 시나리오에서
     * BACK 동작에 대해 표준형은 설정화면 후 HOME으로 이동하지만
     * 설정화면 후 다시 Dial이 나와야 한다면 recallScreen()에서 Flag 체크가 필요함
     */
}

function hideCallView() {
    //console.log("# hideCallView()");
/*DEPRECATED
    if(0 < UIListener.invokeGetScreenSize()) {
        // 콜화면 아래 뭔가 있다면 아래 화면을 표시함
        if(9 > BtCoreCtrl.m_ncallState) {
            callViewState = "IDLE";
        } else {
            callViewState = "BACKGROUND";
        }

        var top_screen = UIListener.invokeTopScreen();
        if("" == top_screen) {
            console.log("## [error] top screen is EMPTY");
        } else {
            // UISH에 내부 화면전환 알림(폰북 -> 통화화면)
            UIListener.invokePostDialView();
            showScreen(top_screen);
        }
    } else {
        //DEPRECATED popScreen(9874);
        //DEPRECATED postBackKey(9874);
        postPopupBackKey(9874);
    }
DEPRECATED*/
    postPopupBackKey(9874);
}

function dragdownCallView() {
    //console.log("# dragdownCallView");
    //__IQS_15MY_ Call End Modify)
    if(1 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
        callViewState = "BACKGROUND";
    } else {
        callViewState = "IDLE";
    }

    if(1 < contact_nstate) {
    	if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()
	    && "ContactsUpdate" != contactState) {
            // 백그라운드 다운로드 상태면 현재화면을 유지한다.
            raiseScreen("BtContactMain", 101);
        } else {
            gInfoViewState = contactState;
                raiseScreen("BtInfoView", 100);
        }
    } else {
        raiseScreen("BtContactMain", 101);
    }

    // UISH에 내부 화면전환 알림(통화화면 -> 폰북)
    //DEPRECATED UIListener.invokePostDialView();
    BtCoreCtrl.invokeGetCallView(callViewState);
}


/******************************************************************************
 * POPUP
 *****************************************************************************/
function showPopup(popup_name) {

    popupDisplayToDeviceName();

    console.log("###################################################");
    console.log("# popup_name = " + popup_name);
    console.log("###################################################");

    // 발신 실패 popup 상태에서 다른 popup show시 call end event 전달을 위해 추가.
    if("popup_Bt_Call_Connect_Fail" == popupState) {
        BtCoreCtrl.invokeHandsfreeCallEndedEventToUISH();
    }

    if("FOREGROUND" == callViewState) {
        /*
         */
        switch(popup_name) {
            case "Call_popup":
            case "Call_3way_popup":
            case "popup_bluelink_popup":
            case "popup_Bt_Dis_Connecting_No_Btn":
            case "popup_Bt_Dis_Connecting":
            case "popup_Bt_Disconnect_By_Phone": 
            case "popup_enter_setting_during_call":
            case "popup_bt_switch_handfree": 
            case "popup_bt_switch_handfreeNavi":
            case "popup_Dim_For_Call":
            case "popup_Contact_Change": {
                if(popupState == popup_name) {
                    // duplicated, do nothing
                    return;
                }

                popupState = popup_name;

                // 팝업 표시 될 때, 시스템 팝업 사라지도록 수정
                if(true == systemPopupOn) {
                    UIListener.invokeCloseSystemPopup();
                }
                break;
            }

            case "popup_bt_not_transfer_call":
            case "popup_during_bluelink_not_transfer": {
                // Ford 특허 팝업
                if(popupState == "popup_text") {
                    // duplicated, do nothing
                    return;
                }

                popupState = "popup_text";
                idLoaderPopup.showTextPopup(popup_name);

                // 팝업 표시 될 때, 시스템 팝업 사라지도록 수정
                if(true == systemPopupOn) {
                    UIListener.invokeCloseSystemPopup();
                }
                break;
            }

            case "popup_Bt_Connecting": {
                if(popupState == popup_name) {
                    // duplicated, do nothing
                    return;
                }

                if(false == autoConnectStart) {
                    // TODO: OJ comment, do nothing
                    return;
                }

                if(true == iqs_15My) {
                    popup_name = "popup_Bt_Connecting_15MY";
                }

                popupState = popup_name;
                break;
            }

            default:
                console.log("# default state");
                break;
        }
    } else {
        switch(popup_name) {
            case "popup_bt_phonebook_download_completed":
            case "popup_Bt_RecentCall_Down_completed":
            case "popup_Bt_Downloading_Callhistory":
            case "popup_bt_recentcall_download_fail":
            case "popup_bt_phonebook_download_fail": {
            //DEPRECATED case "popup_Bt_Initialized": {
                if(popupState == "popup_toast") {
                    // duplicated, do nothing
                    return;
                }

                popupState = "popup_toast";
                idLoaderPopup.showToastPopup(popup_name);
                break;
            }

            case "popup_Bt_Authentication_Fail":
            //DEPRECATED case "popup_Bt_Ini":
            case "popup_bt_no_downloading_phonebook":
            case "popup_bt_no_download_phonebook":
            case "popup_bt_contact_download_fail":
            case "popup_bt_callhistory_download_fail":
            case "popup_Bt_Add_Favorite_Duplicate":
            case "popup_Bt_Call_No_Outgoing":
            case "popup_outgoing_calls_empty":
            case "popup_Bt_Favorite_Max":
            case "popup_Bt_State_Calling_No_OutCall":
            case "popup_bt_invalid_during_call":
            case "popup_Bt_No_Dial_No_Connect_Device":
            case "popup_Bt_Downloading_Phonebook":
            case "popup_Bt_No_Phonebook_Phone":
            case "popup_Bt_No_CallHistory_Phone":
            case "popup_Bt_No_CallHistory":
            case "popup_Bt_Call_Fail":
            // case "popup_Bt_Request_Phonebook":
            case "popup_bt_contact_callhistory_download_stop_disconnect":
            case "popup_bt_outgoing_calls_empty":
            case "popup_bt_no_phonebook_on_phone":
            case "popup_outgoing_calls_empty_download":
            {
                //[ITS 0272243]
                if("popup_Bt_State_Calling_No_OutCall" == popup_name){
                    if(popupState == "Call_popup")  {
                        return;//[ITS 0272243]
                    }
                }

                if(textPopupName == popup_name) {
                    // duplicated, do nothing
                    return;
                }

                popupState = "popup_text";
                idLoaderPopup.showTextPopup(popup_name);

                // 팝업 표시 될 때, 시스템 팝업 사라지도록 수정
                if(true == systemPopupOn) {
                    UIListener.invokeCloseSystemPopup();
                }

                break;
            }

            default: {
                if(popupState == popup_name) {
                    // duplicated, do nothing
                    if("popup_bluelink_popup_Outgoing_Call" ==popupState) {
                        setButtonFocus();
                    }
                    return;
                }

                if(true == iqs_15My && "popup_Bt_Connecting" == popup_name) {
                    popup_name = "popup_Bt_Connecting_15MY";
                }

                popupState = popup_name;

                if("popup_bt_phonebook_download_completed" == popupState ||
                    "popup_Bt_RecentCall_Down_completed" == popupState ||
                    "popup_Bt_Downloading_Callhistory" == popupState ||
                    "popup_bt_recentcall_download_fail" == popupState ||
                    "popup_bt_phonebook_download_fail" == popupState ||
                    "connectSuccessA2DPOnlyPopup" == popupState ||
                    "popup_Bt_Connect_Canceled" == popupState ||
                    "popup_Bt_Initialized" == popupState ||
                    "disconnectSuccessPopup" == popupState ||
                    "popup_Bt_Add_Favorite" == popupState ||
                    "popup_Bt_Deleted" == popupState ||
                    "popup_Bt_Contact_Update_Completed" == popupState) {
                } else {
                    if(true == systemPopupOn) {
                        // 팝업 표시 될 때, 시스템 팝업 사라지도록 수정
                        UIListener.invokeCloseSystemPopup()
                    }
                }

                break;
            }
        }
    }

    // 다른 팝업에 의해서 사라지는 경우 popupshow 관련 변수 초기화
    if("popup_enter_setting_during_call"  != MOp.getPopupState()) {
        BtCoreCtrl.invokeSetEnterSettingDuringCall(false);
    }

    returnFocus();

    //__NEW_FORD_PATENT__ start 포더 특허 변경 사양 적용.
    // 다른 팝업에 의해서 포드 특허 팝업이 사라지는 경우 popupshow 관련 변수 초기화
    if((("popup_bt_switch_handfree"  != MOp.getPopupState())
        && ("popup_bt_switch_handfreeNavi"  != MOp.getPopupState()))
        || ("FOREGROUND" != callViewState)) {
        BtCoreCtrl.invokeSetFordPopupShow(false);
    }
    //__NEW_FORD_PATENT__ end
}

function hidePopup() {
    if("" == popupState) {
        // Already empty, do nothing
        return;
    }

/*DEPRECATED
    // Linkloss발생 후 연결 중 팝업을 띄워야 하나 popupState초기화 코드로 팝업이 사라지는 문제 수정
    if(true == autoConnectStart && "popup_Bt_Connecting" == popupState) {
        returnFocus();
        return;
    }
DEPRECATED*/

    if("popup_text" == popupState) {
        idLoaderPopup.closeTextPopup();
    }

    textPopupName = "";
    popupState = "";
    // 통화중 setting 진입 popup 상태 초기화
    BtCoreCtrl.invokeSetEnterSettingDuringCall(false);
    //__NEW_FORD_PATENT__ start 포더 특허 변경 사양 적용.
    // 포드 특허 팝업 상태 초기화
    BtCoreCtrl.invokeSetFordPopupShow(false);
    //__NEW_FORD_PATENT__ end
}

function getPopupState() {
	if("popup_text" == popupState) {
		return textPopupName;
	} else if("popup_toast" == popupState) {
		return toastPopupName;
	} else {
		return popupState;
	}
}


/******************************************************************************
 * Phone number DASH!!
 *****************************************************************************/
var COUNTRY_CODE_TABLE = [   "1",  "20", "212", "213", "216", "218", "220", "221", "222", "223", "224"
                         , "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235"
                         , "236", "237", "238", "239", "240", "241", "242", "243", "244", "245", "246"
                         , "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257"
                         , "258", "260", "261", "262", "263", "264", "265", "266", "267", "268", "269"
                         ,  "27", "290", "291", "297", "298", "299",  "30",  "31",  "32",  "33",  "34"
                         , "350", "351", "352", "353", "354", "355", "356", "357", "358", "359",  "36"
                         , "370", "371", "372", "373", "374", "375", "376", "377", "378", "380", "381"
                         , "382", "385", "386", "387", "389",  "39",  "40",  "41", "420", "421", "423"
                         ,  "43",  "44",  "45",  "46",  "47",  "48",  "49", "500", "501", "502", "503"
                         , "504", "505", "506", "507", "508", "509",  "51",  "52",  "53",  "54",  "55"
                         ,  "56",  "57",  "58", "590", "591", "592", "593", "594", "595", "596", "597"
                         , "598", "599",  "60",  "61",  "62",  "63",  "64",  "65",  "66", "670", "672"
                         , "673", "674", "675", "676", "677", "678", "679", "680", "681", "682", "683"
                         , "685", "686", "687", "688", "689", "690", "691", "692",   "7",  "81",  "82"
                         ,  "84", "850", "852", "853", "855", "856",  "86", "880", "886",  "90",  "91"
                         ,  "92",  "93",  "94",  "95", "961", "962", "963", "964", "965", "966", "967"
                         , "968", "970", "971", "972", "973", "974", "975", "976", "977",  "98", "992"
                         , "993", "994", "995", "996", "998"
                         ];

var COUNTRY_CODE_SUB_TABLE = [	"340", "670", "671", "684", "787", "939", "441", "242", "246", "264", "268"
                              , "284", "345", "473", "649", "664", "758", "767", "784", "809", "829", "868"
                              , "869", "876" ];

var SERVICE_CODE_TABLE = [ /* eCVKorea */		  [ "+", "001", "002", "00700", "00306", "00365", "005", "008", "006", "00300" ]
                           /* eCVNorthAmerica */, [ "+1" ]				//, [ "+1" , "011" ]
                           /* eCVChina */		, [ "+", "00" ]
                           /* eCVGeneral */		, [ "+" ]
                           /* eCVMiddleEast */	, [ "+" ]
                           /* eCVEuropa */		, [ "+" ]
                         ];



/* 한국, 미국, 중국 국가코드인 경우 지역번호 인식을 위함
 * 주의) 아래 테이블의 index와 LOCAL_CODE_TABLE 및 MOBILE_CODE_TABLE index가 동일해야 함
 */
var COUNTRY_CODE_FOR_LOCAL_TABLE = [ /* 한국 */   "82"
                                     /* 북미 */ , "1"
                                     /* 중국 */ , "86"
                                   ];

var MOBILE_CODE_TABLE = [ /* eCVKorea */		  [ "011", "016", "017", "018", "019", "010" ]
                          /* eCVNorthAmerica */ , [ ]
                          /* eCVChina */        , [ "134", "135", "136", "137", "138", "139", "147", "150", "151", "152", "157", "158", "159", "182", "187", "188"
                                                  , "130", "131", "132", "155", "156", "185", "186"
                                                  , "133", "153", "180", "189" ]
                          /* eCVGeneral */		, [ ]
                          /* eCVMiddleEast */	, [ ]
                          /* eCVEuropa */		, [ ]
                        ];

var LOCAL_CODE_TABLE  = [   /* eCVKorea */
                              [  "02", "031", "032", "033", "041", "042", "043", "044", "051", "052", "053"
                              , "054", "055", "061", "062", "063", "064", "070", "080" ]
                            /* eCVNorthAmerica */
                            , [ "205", "256", "334", "907", "602", "623", "480", "520", "501", "870", "626"
                              , "341", "510", "530", "935", "909", "768", "562", "661", "760", "310", "616"
                              , "714", "818", "805", "408", "831", "619", "925", "949", "209", "424", "323"
                              , "213", "858", "707", "650", "916", "415", "559", "719", "303", "720", "970"
                              , "203", "860", "202", "904", "305", "786", "407", "727", "813", "912", "706"
                              , "404", "678", "770", "808", "208", "618", "217", "312", "630", "224", "847"
                              , "815", "309", "812", "219", "317", "319", "515", "712", "913", "785", "316"
                              , "270", "606", "502", "225", "337", "504", "318", "207", "410", "443", "617"
                              , "508", "413", "734", "313", "906", "810", "231", "517", "218", "612", "507"
                              , "651", "228", "417", "816", "314", "406", "402", "308", "702", "603", "609"
                              , "908", "973", "732", "856", "505", "518", "607", "718", "347", "516", "212"
                              , "914", "716", "585", "315", "704", "336", "252", "701", "330", "513", "216"
                              , "614", "740", "937", "419", "405", "918", "541", "503", "971", "610", "484"
                              , "814", "570", "717", "215", "412", "401", "803", "605", "423", "865", "901"
                              , "615", "915", "806", "512", "214", "972", "817", "409", "713", "281", "832"
                              , "210", "903", "801", "802", "425", "206", "509", "360", "304", "920", "608"
                              , "414", "715", "307" ]
                            /* eCVChina */
                            , [  "010",  "020",  "021",  "022",  "023",  "024",  "025",  "027",  "028",  "029"
                              , "0310", "0311", "0312", "0313", "0314", "0315", "0316", "0317", "0318", "0319", "0335"
                              , "0350", "0351", "0352", "0353", "0354", "0355", "0356", "0357", "0358", "0359"
                              , "0370", "0371", "0372", "0373", "0374", "0375", "0376", "0377", "0378", "0379", "0391", "0392", "0393", "0394"
                              , "0395", "0396", "0398"
                              , "0410", "0411", "0412", "0413", "0414", "0415", "0416", "0417", "0418", "0419"
                              , "0421", "0427", "0429"
                              , "0431", "0432", "0433", "0434", "0435", "0436", "0437", "0438", "0439", "0440"
                              , "0450", "0451", "0452", "0453", "0454", "0455", "0456", "0457", "0458", "0459"
                              , "0470", "0471", "0472", "0473", "0474", "0475", "0476", "0477", "0478", "0479"
                              , "0482", "0483"
                              , "0510", "0511", "0512", "0513", "0514", "0515", "0516", "0517", "0518", "0519", "0523"
                              , "0530", "0531", "0532", "0533", "0534", "0535", "0536", "0537", "0538", "0539"
                              , "0550", "0551", "0552", "0553", "0554", "0555", "0556", "0557", "0558", "0559"
                              , "0561", "0562", "0563", "0564", "0565", "0566"
                              , "0570", "0571", "0572", "0573", "0574", "0575", "0576", "0577", "0578", "0579", "0580"
                              , "0591", "0592", "0593", "0594", "0595", "0596", "0597", "0598", "0599"
                              , "0660", "0661", "0662", "0663"
                              , "0701"
                              , "0710", "0711", "0712", "0713", "0714", "0715", "0716", "0717", "0718", "0719"
                              , "0722", "0724", "0728"
                              , "0730", "0731", "0732", "0733", "0734", "0735", "0736", "0737", "0738", "0739", "0743", "0744", "0745", "0746"
                              , "0751", "0752", "0753", "0754", "0755", "0756", "0757", "0758", "0759"
                              , "0760", "0762", "0763", "0765", "0766", "0768", "0769"
                              , "0770", "0771", "0772", "0773", "0774", "0775", "0776", "0777", "0778", "0779"
                              , "0790", "0791", "0792", "0793", "0794", "0795", "0796", "0797", "0798", "0799"
                              , "0810", "0811", "0812", "0813", "0814", "0816", "0817", "0818", "0819"
                              , "0825", "0826", "0827"
                              , "0830", "0831", "0832", "0833", "0834", "0835", "0836", "0837", "0838", "0839"
                              , "0840"
                              , "0851", "0852", "0853", "0854", "0855", "0856", "0857", "0858", "0859"
                              , "0870", "0871", "0872", "0873", "0874", "0875", "0876", "0877", "0878", "0879", "0691", "0692"
                              , "0881", "0883", "0886", "0887", "0888"
                              , "0890", "0898", "0899", "0891", "0892", "0893"
                              , "0901", "0902", "0903", "0906", "0908", "0909"
                              , "0910", "0911", "0912", "0913", "0914", "0915", "0916", "0917", "0919"
                              , "0930", "0931", "0932", "0933", "0934", "0935", "0936", "0937", "0938"
                              , "0941", "0943"
                              , "0971", "0972", "0973", "0974", "0975", "0976", "0977"
                              , "0990", "0991", "0992", "0993", "0994", "0995", "0996", "0997", "0998", "0999" ]
                            /* eCVGeneral */
                            , [ ]
                            /* eCVMiddleEast */
                            , [ ]
                            /* eCVEuropa */
                            , [ ]
                        ];

/**
 *
 */
function checkPhoneNumber(phone_number) {
    // Remove all non-numbers
    phone_number = phone_number.replace(/[^0-9,*,#,+]/g, '');

    if(3 > phone_number.length) {
        return phone_number;
    }

    // 국제전화번호 검사
    var plus_call = ('+' == phone_number[0]) ? true : false;
    var service_code_length = 0;
    if(true == plus_call) {
        // + 인경우 국제전화로 간주함
        service_code_length = 1;
    } else {
         // +가 아닌 경우 해당 향지별 국제전화 서비스 코드를 검사함
        service_code_length = filterServiceCode(getTableIndexFromVariant(), phone_number);
    }

    if(0 < service_code_length) {
        // 국제전화
        switch(UIListener.invokeGetCountryVariant())
        {
            case 1: // eCVNorthAmerica
            case 6: // eCVCanada
                // 북미만 별도 구현, 아래 processNorthAmerica() 함수와 맞춰 사용할 것
                return processNorthAmericaInternational(phone_number, plus_call, service_code_length);

            case 4: // eCVMiddleEast
            case 5: // eCVEuropa
            case 3: // eCVGeneral
                // 유럽, 중동, 일반향지
                return processGeneral(phone_number);

            default:
                return processInternational(phone_number, plus_call, service_code_length);
        }
    }

    // 향지별 지역 전화번호
    switch(UIListener.invokeGetCountryVariant()) {
        case 0: /* eCVKorea */
        case 2: /* eCVChina */
            // 중국전화번호도 한국과 같은 000-0000 or 0000-0000 체계를 사용함
            return processKorea(phone_number);

        case 1: /* eCVNorthAmerica */
        case 6: /* eCVCanada */
            return processNorthAmerica(phone_number);

        // TODO: 중동, 유럽, 일반은 모두 일반으로 적용함(추후 개별 구현 필요할수도 있음)
        case 4: /* eCVMiddleEast */
            //return processNumberMiddleEast(phone_number);
        case 5: /* eCVEuropa */
            //return processNumberEurope(phone_number);
        case 3: /* eCVGeneral */
            return processGeneral(phone_number);

        default:
            //qml_debug("invalid country variant");
            break;
    }

    // Variant 오류일 경우 General로 적용함
    return processGeneral(phone_number);
}

/**
 *
 */
function getTableIndexFromVariant() {
    var country_variant = UIListener.invokeGetCountryVariant();

    switch(country_variant) {
        case 1: /* eCVNorthAmerica */
        case 6: /* eCVCanada */
            return 1;

        case 0: /* eCVKorea */
        case 2: /* eCVChina */
        case 3: /* eCVGeneral */
        case 4: /* eCVMiddleEast */
        case 5: /* eCVEuropa */
            return country_variant;

        default:
            // Country variant가 없을 경우 강제로 3으로 설정(general)
            return 3;
    }
}

/* [주의] Index 반환함
 */
function getLocalCodeTableIndex(phone_number) {
    for(var i = 0; i < COUNTRY_CODE_FOR_LOCAL_TABLE.length; i++) {
        if(phone_number.substr(0, COUNTRY_CODE_FOR_LOCAL_TABLE[i].length) == COUNTRY_CODE_FOR_LOCAL_TABLE[i]) {
            return i;
        }
    }
    return -1;
}

/*
 */
function filterServiceCode(table_index, phone_number) {
    for(var i = 0; i < SERVICE_CODE_TABLE[table_index].length; i++) {
        if(phone_number.substr(0, SERVICE_CODE_TABLE[table_index][i].length) == SERVICE_CODE_TABLE[table_index][i]) {
            return SERVICE_CODE_TABLE[table_index][i].length;
        }
    }

    return 0;
}

/*
 */
function filterCountryCode(phone_number) {
    for(var i = 0; i < COUNTRY_CODE_TABLE.length; i++) {
        if(phone_number.substr(0, COUNTRY_CODE_TABLE[i].length) == COUNTRY_CODE_TABLE[i]) {
            return COUNTRY_CODE_TABLE[i].length;
        }
    }

    return 0;
}

/*
 */
function filterMobileCode(table_index, phone_number, drop0) {
    if(true == drop0) {
        for(var i = 0; i < MOBILE_CODE_TABLE[table_index].length; i++) {
            if(phone_number.substr(0, MOBILE_CODE_TABLE[table_index][i].length - 1) == MOBILE_CODE_TABLE[table_index][i].substr(1)) {
                return MOBILE_CODE_TABLE[table_index][i].length - 1;
            }
        }
    } else {
        for(var i = 0; i < MOBILE_CODE_TABLE[table_index].length; i++) {
            if(phone_number.substr(0, MOBILE_CODE_TABLE[table_index][i].length) == MOBILE_CODE_TABLE[table_index][i]) {
                return MOBILE_CODE_TABLE[table_index][i].length;
            }
        }
    }

    return 0;
}

/*
 */
function filterLocalCode(table_index, phone_number, drop0) {
    if(true == drop0) {
        for(var i = 0; i < LOCAL_CODE_TABLE[table_index].length; i++) {
            if("0" == LOCAL_CODE_TABLE[table_index][i][0]) {
                if(phone_number.substr(0, LOCAL_CODE_TABLE[table_index][i].length - 1) == LOCAL_CODE_TABLE[table_index][i].substr(1)) {
                    return LOCAL_CODE_TABLE[table_index][i].length - 1;
                }
            } else {
                if(phone_number.substr(0, LOCAL_CODE_TABLE[table_index][i].length) == LOCAL_CODE_TABLE[table_index][i]) {
                    return LOCAL_CODE_TABLE[table_index][i].length;
                }
            }
        }
    } else {
        for(var i = 0; i < LOCAL_CODE_TABLE[table_index].length; i++) {
            if(phone_number.substr(0, LOCAL_CODE_TABLE[table_index][i].length) == LOCAL_CODE_TABLE[table_index][i]) {
                return LOCAL_CODE_TABLE[table_index][i].length;
            }
        }
    }

    return 0;
}

/*
 */
function generateFormat(count) {
    var format = "";
    for(var i = 0; i < count; i++) {
        format += ("$" + (i + 1) + "-");
    }

    return format.substr(0, format.length - 1);
}

/*
 */
function generateNumberForm(phone_number, format_count, reg_expr) {
    //number_debug("phone_number = " + phone_number);
    //number_debug("reg_expr = " + reg_expr);

    // Generate format string "$1-$2 ... "
    var format = generateFormat(format_count);

    if(0 < reg_expr.length) {
        // Convert to dash-number format
        var reg = new RegExp(reg_expr, "g");
        if(true == reg.test(phone_number)) {
            phone_number = phone_number.replace(reg, format);
        }
    }

    return phone_number;
}

/* 국제전화 처리 함수
 */
function processInternational(phone_number, plus_call, service_code_length) {
    var reg_expr = "";
    var format_count = 0;

    var cut_number = phone_number.substr(service_code_length);

    // 지역번호 또는 모바일 번호를 검사하는 국가코드인지 검사
    var local_code_table_index = getLocalCodeTableIndex(cut_number);

    if(-1 < local_code_table_index) {
        /* 지역번호 또는 모바일 번호를 검사하는 국가코드인 경우
         */
        var country_code_length = filterCountryCode(cut_number);
        cut_number = cut_number.substr(country_code_length);

        if(0 < country_code_length) {
            /* 서비스 코드, 국가코드 모두 찾은 상태
             */
            var mobile_code_length = filterMobileCode(local_code_table_index, cut_number, true);
            cut_number = cut_number.substr(mobile_code_length);

            if(0 < mobile_code_length) {
                // [PATTERN] 001-82-10-000-0000 or 001-82-10-0000-0000
                number_debug("-- case 1");
                if(true == plus_call) {
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})([0-9,*,#,+]{" + mobile_code_length + "})";
                } else {
                    format_count = 3;
                    reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})([0-9,*,#,+]{" + mobile_code_length + "})";
                }

                if(0 < cut_number.length) {
                    if(4 > cut_number.length) {
                        number_debug("-- case 1-1");
                        format_count++;
                        reg_expr += "([0-9,*,#,+])";
                    } else if(8 > cut_number.length) {
                        number_debug("-- case 1-2");
                        format_count += 2;
                        reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                    } else {
                        /*if(0 == local_code_table_index) {
                            // 한국의 경우 4-4 패턴을 추가함
                            if(8 == cut_number.length) {
                                number_debug("-- case 2-4");
                                format_count += 2;
                                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                            } else {
                                // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                number_debug("-- case 2-5");
                                return phone_number;
                            }
                        } else*/ {
                            // [PATTERN] 000-0000 을 벗어난 경우 - 삽입하지 않음
                            number_debug("-- case 2-5");
                            return phone_number;
                        }
                    }
                }
            } else {
                // 지역코드 검사
                var local_code_length = filterLocalCode(local_code_table_index, cut_number, true);
                cut_number = cut_number.substr(local_code_length);

                if(0 < local_code_length) {
                    number_debug("-- case 2");
                    if(true == plus_call) {
                        format_count = 2;
                        reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})([0-9,*,#,+]{" + local_code_length + "})";
                    } else {
                        format_count = 3;
                        reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})([0-9,*,#,+]{" + local_code_length + "})";
                    }

                    if(0 < cut_number.length) {
                        if(4 > cut_number.length) {
                            number_debug("-- case 2-2");
                            format_count++;
                            reg_expr += "([0-9,*,#,+])";
                        } else if(8 > cut_number.length) {
                            number_debug("-- case 2-3");
                            format_count += 2;
                            reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                        } else {
                            /*if(0 == local_code_table_index) {
                                // 한국의 경우 4-4 패턴을 추가함
                                if(8 == cut_number.length) {
                                    number_debug("-- case 2-4");
                                    format_count += 2;
                                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                                } else {
                                    // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                    number_debug("-- case 2-5");
                                    return phone_number;
                                }
                            } else*/ {
                                // [PATTERN] 000-0000 을 벗어난 경우 - 삽입하지 않음
                                number_debug("-- case 2-5");
                                return phone_number;
                            }
                        }
                    } else {
                        number_debug("-- case 2-1");
                    }
                } else {
                    /* 서비스 코드, 국가코드를 찾았지만 지역코드를 못찾은 상태
                     * [PATTERN] +82-2-0000000
                     */
                    if(true == plus_call) {
                        format_count = 1;
                        reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})";
                    } else {
                        format_count = 2;
                        reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})";
                    }

                    if(0 < cut_number.length) {
                        if(4 > cut_number.length) {
                            number_debug("-- case 3-2");
                            format_count++;
                            reg_expr += "([0-9,*,#,+])";
                        } else if(8 > cut_number.length) {
                            number_debug("-- case 3-3");
                            format_count++;
                            reg_expr += "([0-9,*,#,+]{" + cut_number.length + "})";
                        } else {
                            /*if(0 == local_code_table_index) {
                                // 한국의 경우 4-4 패턴을 추가함
                                if(8 == cut_number.length) {
                                    number_debug("-- case 3-4");
                                    format_count += 2;
                                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                                } else {
                                    // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                    number_debug("-- case 3-5");
                                    return phone_number;
                                }
                            } else*/ {
                                // [PATTERN] +82-2-0000000 을 벗어난 경우 - 삽입하지 않음
                                number_debug("-- case 3-6");
                                return phone_number;
                            }
                        }
                    } else {
                        number_debug("-- case 3-1");
                    }
                }
            }
        } else {
            /* 서비스 코드는 찾았지만 국가코드를 못찾은 상태
             * [PATTERN] +8, 00 등
             */
            if(true == plus_call) {
                number_debug("-- case 4-1");
                format_count = 1;
                reg_expr = "([0-9,*,#,+])";
            } else {
                if(8 > cut_number.length) {
                    number_debug("-- case 4-2");
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+])";
                } else {
                    /*if(0 == local_code_table_index) {
                        // 한국의 경우 4-4 패턴을 추가함
                        if(8 == cut_number.length) {
                            number_debug("-- case 4-3");
                            format_count += 2;
                            reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                        } else {
                            // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                            number_debug("-- case 4-4");
                            return phone_number;
                        }
                    } else*/ {
                        // [PATTERN] 000-000-0000 을 벗어난 경우 - 삽입하지 않음
                        number_debug("-- case 4-4");
                        return phone_number;
                    }
                }
            }
        }
    } else {
        /* 지역번호를 검사하지 않는 국가코드인 경우
         */
        var country_code_length = filterCountryCode(cut_number);
        cut_number = cut_number.substr(country_code_length);

        if(0 < country_code_length) {
            // [PATTERN] 001-465-0000000, +465-000-0000
            number_debug("-- case 10");
            if(true == plus_call) {
                format_count = 1;
                reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})";
            } else {
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})([0-9,*,#,+]{" + mobile_code_length + "})";
            }

            if(0 < cut_number.length) {
                if(8 > cut_number.length) {
                    // [PATTERN] 001-465-0000000
                    number_debug("-- case 10-1");
                    format_count++;
                    reg_expr += "([0-9,*,#,+]{" + cut_number.length + "})";
                } else {
                    // [PATTERN] 001-465-0000000 을 벗어난 경우 - 삽입하지 않음
                    number_debug("-- case 10-2");
                    return phone_number;
                }

                number_debug(reg_expr);
            }
        } else {
            /* 서비스 코드는 찾았지만 국가코드는 못찾은 상태
             * [PATTERN] +8, 00 등
             */
            if(true == plus_call) {
                number_debug("-- case 11-1");
                format_count = 1;
                reg_expr = "([0-9,*,#,+])";
            } else {
                if(8 > cut_number.length) {
                    // [PATTERN] 001-465-0000000
                    number_debug("-- case 3-2");
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{3})([0-9,*,#,+])";
                } else {
                    // [PATTERN] 001-465-0000000 을 벗어난 경우 001-465-000-000000.. 형태를 유지함
                    number_debug("-- case 3-4");
                    format_count = 3;
                    reg_expr =  "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 6) + "})";
                }
            }
        }
    }

    // Generate!!
    return generateNumberForm(phone_number, format_count, reg_expr);
}

/* 지역번호와 무관하게 3-3-4 패턴으로 표시할때만 사용(북미전용)
 */
function processNorthAmericaInternational(phone_number, plus_call, service_code_length) {
    var reg_expr = "";
    var format_count = 0;

    var cut_number = "";

    /* 북미 국제전화는  +1, 011 인 경우만 PATTERN 유지함 +1-000-000-0000, 011-000-0000
     */
/*DEPRECATED
    service_code_length = filterServiceCode(getTableIndexFromVariant(), phone_number);
    if(0 < service_code_length) {
        cut_number = phone_number.substr(service_code_length);

        format_count = 1;
        reg_expr = "([0-9,*,#,+]{" + service_code_length + "})";
    } else {
        // 발생하지 않음
        cut_number = phone_number;
    }

    if(0 < cut_number.length) {
        if(3 > service_code_length) {
            // [PATTERN] +1 인 경우, +1-000-000-0000
            if(5 > cut_number.length) {
                qml_debug("-- NA case 1-1");
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                qml_debug("-- NA case 1-2");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } else {
                // [PATTERN] +1-000-000-0000을 벗어난 경우 - +1-000-000-0000  패턴을 계속 유지
                qml_debug("-- case 1-3");
                format_count += 3;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 6) + "})";
            }
        } else {
            // [PATTERN] 011 인 경우, 011-000-0000
            if(4 > cut_number.length) {
                qml_debug("-- NA case 2-1");
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else {
                // [PATTERN] 011-000-0000 을 벗어난 경우 - 000-000-0000  패턴을 계속 유지
                qml_debug("-- case 2-3");
                format_count += 3;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 6) + "})";
            }
        }
    }
DEPRECATED*/

    if(6 > phone_number.length) {
        return phone_number;
    }
    cut_number = phone_number.substr(service_code_length);

    if("1" == cut_number[0]) {
        cut_number = cut_number.substr(1);

        var i = 0;
        for(/* var i = 0 */; i < cut_number.length; i++) {
            // do nothing
            if("1" != cut_number[i]) { break; }
        }
        qml_debug("1cut_number = " + cut_number);
        qml_debug("1cut_number.length = " + cut_number.length);
        qml_debug("i = " + i);

        if(i < cut_number.length) {
            if(4 > i) {
            qml_debug("-----------1");
                // [PATTERN] +1111-XXX-XXX-XXXXXXX
                cut_number = cut_number.substr(i);

                if(8 > cut_number.length) {
                    // +1111-XXX-XXXX
                    format_count = 3;
                    reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 3)+ "})";
                } else {
                    format_count = 4;
                    reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 6)+ "})";
                }
            } else {
                // [PATTERN] +111111-XXX-XXXXXXXX
                qml_debug("-----------2");
                cut_number = cut_number.substr(i);

                if(4 > cut_number.length) {
                    // [PATTERN] +111111-XXX
                    format_count = 2;
                    reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{" + (cut_number.length - i)+ "})";
                } else {
                    // [PATTERN] +111111-XXX-XXXXXXXXXXXXx
                    format_count = 3;
                    reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - (3 + i))+ "})";
                }
            }
        } else {
            // [PATTERN] +1111111111111111111111
            return phone_number;
        }
    } else {
        // [PATTERN] +XXXXXXXXXXXXX....
        return phone_number;
    }

    // Generate!!
    return generateNumberForm(phone_number, format_count, reg_expr);
}

/* 북미향
 */
function processNorthAmerica(phone_number) {
    var format_count = 0;
    var reg_expr = "";

    // 지역코드 검사
/*DEPRECATED
    var local_code_length = filterLocalCode(getTableIndexFromVariant(), phone_number, false);
    var cut_number = phone_number.substr(local_code_length);

    if(0 < local_code_length) {
        // 지역코드를 찾은 경우
        // [PATTERN] 000-000-0000
        number_debug("-- [America] case 1");
        format_count = 1;
        reg_expr = "([0-9,*,#,+]{" + local_code_length + "})";

        if(4 > cut_number.length) {
            // [PATTERN] 000
            number_debug("-- [America] case 1-1");
            format_count++;
            reg_expr += "([0-9,*,#,+])";
        } else if(8 > cut_number.length) {
            // [PATTERN] 000-000-0000
            number_debug("-- [America] case 1-2");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
        } else {
            // [PATTERN] 000-000-0000을 벗어난 경우 000-000-00000000... 형태를 유지함
            number_debug("-- [America] case 1-3");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 3)+ "})";
        }
    } else {
        // 지역 코드를 찾지 못한 경우
        number_debug("-- [America] case 2");
        return phone_number;
    }
DEPRECATED*/

    /* 아래 코드는 지역번호 무관하게 3-3-4 패턴에 맞춘 코드로 필요시 위 코드와 대체하여 사용할 것
     */
    if(6 > phone_number.length) {
        // 1 ~ 5자리 까지는 - 삽입 없이 출력
         return phone_number;
    }

    // [PATTERN] 000-000-0000
    if(1 != phone_number[0]) {
        // 제일 앞자리가 1이 아닌 경우
        if(6 > phone_number.length) {
            // [PATTERN] 000
            qml_debug("-- [America] case 1");
            format_count = 1;
            reg_expr = "([0-9,*,#,+])";
        } else if(7 > phone_number.length) {
            // [PATTERN] 000-000
            qml_debug("-- [America] case 2");
            format_count = 2;
            reg_expr = "([0-9,*,#,+]{" + (phone_number.length - 3) + "})([0-9,*,#,+]{3})";
        } else if(8 > phone_number.length) {
            format_count = 2;
            reg_expr = "([0-9,*,#,+]{" + (phone_number.length - 4) + "})([0-9,*,#,+]{4})";
        } else {
            // [PATTERN] 000-000-0000
            format_count = 3;
            reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 6) + "})";
        }
    } else {
        // 제일 앞자리가 1 또는 011 인 경우
        if(9 > phone_number.length) {
            // [PATTERN] 000
            format_count = 3;
            reg_expr = "([0-9,*,#,+]{1})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 4) + "})";
        } else {
            // [PATTERN] 000-000-0000
            format_count = 4;
            reg_expr = "([0-9,*,#,+]{1})([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 7) + "})";
        }
    }

    // Generate!!
    return generateNumberForm(phone_number, format_count, reg_expr);
}

/* 내수
 */
function processKorea(phone_number) {
    var reg_expr = "";
    var format_count = 0;

    var table_index = getTableIndexFromVariant();

    // 모바일 번호 검사
    var mobile_code_length = filterMobileCode(table_index, phone_number, false);
    var cut_number = phone_number.substr(mobile_code_length);

    if(0 < mobile_code_length) {
        // 모바일 번호가 있을 경우(e.g. 011, 010, ... )
        number_debug("-- [Korea] case 1");
        format_count = 1;
        reg_expr = "([0-9,*,#,+]{" + mobile_code_length + "})";

        if(4 > cut_number.length) {
            // [PATTERN] 001-000
            number_debug("-- [Korea] case 1 - 1");
            format_count++;
            reg_expr += "([0-9,*,#,+])";
        } else if(8 > cut_number.length) {
            // [PATTERN] 001-000-0000
            number_debug("-- [Korea] case 1 - 2");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
        } /*else if(8 == cut_number.length) {
            // [PATTERN] 001-0000-0000
            number_debug("-- [Korea] case 1 - 3");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
        }*/ else {
            // [PATTERN] 001-0000-0000 을 벗어난 경우 001-0000-00000000... 형태를 유지함
            number_debug("-- [Korea] case 1 - 4");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
        }
    } else {
        // 모바일 번호가 없는 경우, 지역번호 검사
        var local_code_length = filterLocalCode(table_index, cut_number, false);
        cut_number = cut_number.substr(local_code_length);

        if(0 < local_code_length) {
            // 지역번호가 있는 경우(e.g. 02, 031... )
            number_debug("-- [Korea] case 2");
            format_count = 1;
            reg_expr = "([0-9,*,#,+]{" + local_code_length + "})";

            if(4 > cut_number.length) {
                number_debug("-- [Korea] case 2-1");
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                number_debug("-- [Korea] case 2-2");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } /*else if(8 == cut_number.length) {
                number_debug("-- [Korea] case 2-3");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
            }*/ else {
                // [PATTERN] 02-0000-0000을 벗어난 경우 02-0000-00000000.. 형태를 유지함
                number_debug("-- [Korea] case 2-4");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
            }
        } else {
            // 모바일 번호, 지역번호 모두 없는 경우
            number_debug("-- [Korea] case 3");
            if(4 > cut_number.length) {
                // [PATTERN] 000
                number_debug("-- [Korea] case 3-1");
                format_count = 1;
                reg_expr = "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                // [PATTERN] 000-0000
                number_debug("-- [Korea] case 3-2");
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } /*else if(8 == cut_number.length) {
                // [PATTERN] 0000-0000
                number_debug("-- [Korea] case 3-3");
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+])"
            }*/ else {
                // [PATTERN] 0000-0000 을 벗어난 경우 0000-00000000... 형태를 유지함
                number_debug("-- [Korea] case 3-4");
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (phone_number.length - 4)+ "})"
            }
        }
    }

    // Generate!!
    return generateNumberForm(phone_number, format_count, reg_expr);
}

/* 일반향지
 */
function processGeneral(phone_number) {
    // 유럽, 중동, (일반?) 향지는 - 모두 제거 by HMC
    return phone_number;

/*DEPRECATED
    var reg_expr = "";
    var format_count = 0;

    if(4 > phone_number.length) {
        // [PATTERN] 000
        number_debug("[general] case 1");
        format_count = 1;
        reg_expr = "([0-9,*,#,+])";
    } else if(7 > phone_number.length) {
        // [PATTERN] 000-000
        number_debug("[general] case 2");
        format_count = 2;
        reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+])";
    } else if(11 > phone_number.length) {
        // [PATTERN] 000-000-0000
        number_debug("[general] case 3");
        format_count = 3;
        reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+])";
    } else {
        // [PATTERN] 000-0000 을 벗어난 경우 000-000-00000000... 형태를 유지함
        number_debug("[general] case 4");
        format_count = 3;
        reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 6) + "})";

    }

    // Generate!!
    return generateNumberForm(phone_number, format_count, reg_expr);
DEPRECATED*/
}

/*
 */
function processMiddleEast(phone_number) {
    var table_index = getTableIndexFromVariant();
    return phone_number;
}

/*
 */
function processEurope(phone_number) {
    var table_index = getTableIndexFromVariant();
    return phone_number;
}

/* [주의] 한국과 동일한 체계를 사용하므로 사용하지 않음
 */
function processChina(phone_number) {
    var reg_expr = "";
    var format_count = 0;
    
    var table_index = getTableIndexFromVariant();
    
    // 모바일 번호 검사
    var mobile_code_length = filterMobileCode(table_index, phone_number, false);
    var cut_number = phone_number.substr(mobile_code_length);
    
    if(0 < mobile_code_length) {
        // 모바일 번호가 있을 경우(e.g. 011, 010, ... )
        qml_debug("-- [Korea] case 1");
        format_count = 1;
        reg_expr = "([0-9,*,#,+]{" + mobile_code_length + "})";
        
        if(4 > cut_number.length) {
            // [PATTERN] 001-000
            qml_debug("-- [Korea] case 1 - 1");
            format_count++;
            reg_expr += "([0-9,*,#,+])";
        } else if(8 > cut_number.length) {
            // [PATTERN] 001-000-0000
            qml_debug("-- [Korea] case 1 - 2");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
        } /*else if(8 == cut_number.length) {
            // [PATTERN] 001-0000-0000
            qml_debug("-- [Korea] case 1 - 3");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
        }*/ else {
            // [PATTERN] 001-0000-0000 을 벗어난 경우 001-0000-00000000... 형태를 유지함
            qml_debug("-- [Korea] case 1 - 4");
            format_count += 2;
            reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
        }
    } else {
        // 모바일 번호가 없는 경우, 지역번호 검사
        var local_code_length = filterLocalCode(table_index, cut_number, false);
        cut_number = cut_number.substr(local_code_length);
        
        if(0 < local_code_length) {
            // 지역번호가 있는 경우(e.g. 02, 031... )
            qml_debug("-- [Korea] case 2");
            format_count = 1;
            reg_expr = "([0-9,*,#,+]{" + local_code_length + "})";
            
            if(4 > cut_number.length) {
                qml_debug("-- [Korea] case 2-1");
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                qml_debug("-- [Korea] case 2-2");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } /*else if(8 == cut_number.length) {
                qml_debug("-- [Korea] case 2-3");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
            }*/ else {
                // [PATTERN] 02-0000-0000을 벗어난 경우 02-0000-00000000.. 형태를 유지함
                qml_debug("-- [Korea] case 2-4");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
            }
        } else {
            // 모바일 번호, 지역번호 모두 없는 경우
            qml_debug("-- [Korea] case 3");
            if(4 > cut_number.length) {
                // [PATTERN] 000
                qml_debug("-- [Korea] case 3-1");
                format_count = 1;
                reg_expr = "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                // [PATTERN] 000-0000
                qml_debug("-- [Korea] case 3-2");
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } /*else if(8 == cut_number.length) {
                // [PATTERN] 0000-0000
                qml_debug("-- [Korea] case 3-3");
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+])"
            }*/ else {
                // [PATTERN] 0000-0000 을 벗어난 경우 0000-00000000... 형태를 유지함
                qml_debug("-- [Korea] case 3-4");
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (phone_number.length - 4)+ "})"
            }
        }
    }

    // Generate!!
    return generateNumberForm(phone_number, format_count, reg_expr);
}

 function checkArab(number) {
        var firstChar = number.substring(0,1);
        console.log("firstChar > " + firstChar)
        if(("؀" <= firstChar && "ۿ" >= firstChar) || ("ݐ" <= firstChar && "ݭ" >= firstChar)){
            return true;
        } else {
            return false;
        }
}
/* EOF */
