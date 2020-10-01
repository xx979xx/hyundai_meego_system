/**
 * DHBtMain.qml
 *
 */
import QtQuick 1.1
import QmlStatusBar 1.0
import Qt.labs.gestures 2.0
import "../QML/DH" as MComp
import "../BT/Common/System/DH" as MSystem
import "../BT/Call/Main" as MBtCall
import "../BT/Common/Javascript/operation.js" as MOp
import "../BT/Common/" as MBt


MComp.MAppMain
{
    id: idAppMain
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo   { id: colorInfo }
    //DEPRECATED MSystem.ImageInfo   { id: imageInfo }
    MSystem.SystemInfo  { id: systemInfo }
    MBt.BtString        { id: stringInfo }

    /* DEBUG
     */
    property bool debugOnOff: false

    //
    property int contact_nstate
    property int recent_nstate
    property int favorite_nstate
    property bool ini_paired_device: false
    property bool ini_bluetooth_setting: false
    property bool blutooth_setting_initialize: false
    property bool initialize_after_disconnecting_state: true
    property bool initialize_after_disconnecting_popup_check: false
    // Common
    property bool duringINI:        true
    property int btPhoneEnter: -1
    property bool btSettingsEnter:  true
    property string callHistoryDownState:   ""
    property string phonebookDownState:     ""
    property string delete_type:            ""

    property string selectedBand: ""
    property int appEntryPoint: 0
    property bool parking: true
    property string sspDeviceName: ""
    property string gInfoViewState: ""
    property string recentCallState: "recent_not_support"
    property string contactState: "ContactsWaitDownMal"
    property string mainViewState: ""
    property string sspDeviceId: ""
    property int recent_value: 0
    property int contact_value : 0
    property int sspDeviceIdType: 0
    property string sspOk: BtCoreCtrl.invokeGetSSPcode()
    property int gIgnoreReleased: 0 //0: 대기 상태, 1: App Release 2: Keypad Release
    property bool gInfoViewFocus: false
    property int gLanguage: UIListener.invokeGetLanguage()
    property string lastView: ""
    property bool menuOn: false

    // POPUP
    property string popupState      :     ""
    //DEPRECCATED property bool gUsePreloadPopup: false
    property string gSwrcInput      :     "" // SWRC Short/Long Press Check
    property bool   testPopup       :       false // test popup property
    property string textPopupName: ""
    property string toastPopupName: ""
    property bool popupBackGroundBlack: true


    // DIAL
    property int dial_list_count:   0
    property bool dialListView:     false

    // CALL
    property string phoneNumInput: ""
    property string callDTMFDialInput: ""
    property bool callPrivateMode: false
    property bool callShowMicVolume: false
    property bool callShowDTMF: false
    property int callType: BtCoreCtrl.m_ncallState
    property string callViewState: "IDLE"
    property string callOldViewState: ""
    //DEPRECATED property string gBluelinkEntryPoint: ""
    //DEPRECATED property string gBluelinkTempDialNumber: ""
    property bool gContactFromCall: false

    // Bluelink
    //DEPRECATED property bool gBluelinkCall: false

    // DEVICE
    property bool selectDeviceDelete: false
    property int selectDevice: 0
    property string changedDeviceName: ""
    property int deviceSelectInt: 0
    property int recentSelectInt: 0
    property bool btHFPConnect : false
    property bool btA2DPConnect : false
    property int connectingDeviceId: -1
    property bool autoConnectStart: false

    // RECENT CALLS
    property int select_recent_call_type: 2 // incoming
    property int recent_list_count
    property variant gRecentsInfo: { 'number': "", 'index': 0, 'name': "" }
    property bool gNoOutgoing: false

    // PHONEBOOK
    property int contact_type_1
    property int contact_type_2
    property int contact_type_3
    property int contact_type_4
    property int contact_type_5
    property string headName: ""
    property string tailName: ""
    property int delegate_count: 3
    property string phoneNum: ""
    property string phoneName: ""
    property string homeNum
    property string officeNum
    property string otherNum
    property string other2Num

    property bool downloadContact
    property bool downloadCallHistory

    property string contactsListName
    property string contactSearchInput: ""
    property int contactsListIndex
    property string first_name : ""
    property string last_name : ""
    property string formatted_name : ""
    property string middle_name : ""
    property int contact_list_count
    property bool gPhonebookReload: false
    property bool gPhonebookReloadForDial: false

    property bool waitContactUpdatePopup: false

    // FAVORITE
    property string favoriteAdd: ""
    property string favoriteState: ""
    property int favoriteSelectInt: 0
    property int favoriteValue: 0
    property int favorite_list_count
    property int add_favorite_index: 0

    // SIRI
    property bool siriViewState: false
    property bool siriLastViewSave: false // 시리 종료후 화면 저장하는 변수 초기화 블루투스 > 설정화면 이동 시에만 변수 값 True 하도록 수정

    // SETTINGS
    property int settingCurrentIndex: 0
    property bool btConnectAfterDisconnect:     false
    property bool btDisconnectAfterSSPAdd:      false   // 연결해제 후 신규 기기 등록 팝업
    property bool btDeleteMode:                 false
    property bool deleteAllMode:                false
    property bool btConnectDeviceDelete:        false
    property bool connectingPopupAddNewClick:   false
    //DEPRECATED property int scrollMargin:                  79
    //DEPRECATED property int scrollBottom:                  0

    // Common
    property bool   systemPopupOn: false
    property bool   favoriteButtonPress: false
    property string beforeFocus: ""
    property int chineseKeypadType: 0
    property int chineseKeypadTypeDeviceName: 0
    property bool keypadPress : false
    property string menuSourcePath: ""
    property string menuSourcePathArab: ""
    property string keypadInputType: ""

    // BT가 BG 상태인지 check
    property bool bgCheck: false
    // BG request sent or not
    property bool bgrequested: false

    // For IQS_15MY
    property bool iqs_15My: BtCoreCtrl.invokeIsIQS15My();

    property int checkedCallViewStateChange: 0
    property bool checkedpopup: false
    property bool visualCueDownActive: true
    property bool setBtDialScreen: false

    /* CarPlay */
    property bool projectionOn: BtCoreCtrl.GetProjectionModeActivated();

    // SIGNALS
    signal selectAll();
    signal selectUnAll();
    signal favoriteSelectUnAll();   //즐겨찾기 리스트 모두 삭제
    signal deviceSelectUnAll();     //기기 리스트 모두 삭제
    signal sigBluetoothDrivingRestrictionShow();
    signal sigBluetoothDrivingRestrictionHide();
    signal phonebookSearch(int index);
    signal clickedBtSspmOn();
    signal clickedBtSspmOff();
    signal sigDialCallKeyHandler();
    signal deviceChangeRecentCallReset();   // Device 변경시 발생하는 Signal
    signal sigHideMicOff();
    signal sigSetSelectedBand(string band);
    signal sigSetVisualCue(bool top, bool right, bool bottom, bool left);

    signal sigSetFocusToMainBand();
    signal sigUpdateUI();
    signal pressContacts();
    signal mouseAreaExit();
    signal btnReleased();
    signal clickedContactsCallView();
    signal resetFocusCallhistory();
    signal phonebookModelChanged();
    signal keypadChange();
    signal keypadChangeChinese();
    signal callEndEvent();

    signal deviceDeleteCancel();
    signal recentDeleteCancel();
    signal favoriteDeleteCancel();
    signal popupTextFocusSet();
    signal setKeypad();
    signal textChange();
    signal menuOffFocus();

    signal sigPopupStateChanged();
    signal deleteBackKeyPress();

    signal sigshowPopup();
    /* [ITS 0233155]
    signal sigHideSiri();
    */
    signal iniKeypadInput();

    signal settingLeftTimerUpStart();
    signal settingLeftTimerDownStart();
    signal settingLeftTimerStop();
    signal settingBandFocus();

    signal popupDisplayToDeviceName();
    signal phonebookSearchUpdate();
    signal setButtonFocus();

    /* CarPlay */
    signal sigAAPConnected();
    signal sigAAPDisconnected();

    /* INTERNAL functions */
    //for MPAutoTest
    function clickBtSSPAddPopupFirstBtn() {
        if("popup_Bt_No_Connection" == popupState || "popup_Bt_No_Device" == popupState) {
            qml_debug("function clickBtSSPAddPopupFirstBtn() --> emit popupFirstBtnClicked()");
            if(true == parking) {
                // 정차상태
                if(BtCoreCtrl.m_pairedDeviceCount < 5) {
                    if(4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                        || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                        MOp.showPopup("popup_Bt_Other_Device_Connect_Menu");
                    } else {
                        // 페어링되어있는 디바이스가 없는 경우 신규 기기등록
                        BtCoreCtrl.invokeSetDiscoverableMode(true);
                        MOp.showPopup("popup_Bt_SSP_Add");
                    }
                } else {
                    // 페어링되어있는 디바이스가 5개인 경우 등록 불가
                    MOp.showPopup("popup_Bt_Max_Device");
                }
            } else {
                // 주행상태
                qml_debug("## parking = false");
                MOp.showPopup("popup_restrict_while_driving");
            }
        }
        else {
            qml_debug("function clickBtSSPAddPopupFirstBtn() --> //Do nothing");
            return;
        }
    }

    // Binding QML function
    function bindGetEntryMode() {
        qml_debug("bindGetEntryMode()");
        return btPhoneEnter;
    }

    function bindGetDeleteMode() {
        qml_debug("bindGetDeleteMode()");
        if(true == btDeleteMode) {
            return 1; // 선택 삭제
        }

        if(true == deleteAllMode) {
            return 2; // 전체 삭제
        }

        return 0;
    }

    function bindGetDrivingRestrictionPopupState() {
        // 주행 규제 팝업이 출력된 상태인지 확인
        qml_debug("bindGetDrivingRestrictionPopupState()");
        qml_debug("popupState = " + popupState);
        if(popupState == "popup_restrict_while_driving") {
            return true;
        }

        return false;
    }

    function bindGetSystemPopup() {
        qml_debug("bindGetSystemPopup()");
        // 시스템 팝업이 출력되어 있는 상태인지 체크
        return (true == systemPopupOn) ? true : false;
    }

    // for debugging
    function qml_debug(msg) {
        if(debugOnOff) {
            console.log("[BT][QML] " + msg)
        }
    }

    function number_debug(msg) {
        if(false) {
            console.log("[BT][NUMBER] " + msg)
        }
    }

    function bindGetCallPopupState() {
        if("Call_popup" == popupState
            || "Call_3way_popup" == popupState
            || "popup_bluelink_popup" == popupState
            || "popup_bt_switch_handfree" == popupState
            || "popup_bt_switch_handfreeNavi" == popupState) {
            return true;
        }

        return false;
    }

    //2015.10.30 [ITS 0269835,0269836] Android Auto Handling (UX Scenario Changed)
    function mainShowAADefend(bShow){
        if(bShow){
            if(idLoaderAADefend.visible == true){
                idLoaderAADefend.show();
                idLoaderAADefend.visible = true;
                idLoaderAADefend.forceActiveFocus();
            }
        }
        else{
            MOp.postBackKey(111);
        }
    }

    //[ITS 0270332] AADefend H/U Key제어
    function mainGetAADefendVisible(){
        return  idLoaderAADefend.visible;
    }

    function mainAADefendKeyHandler(event){
        switch(event.key) {
            case Qt.Key_K:         //Home Key
            case Qt.Key_Period:
                UIListener.invokePostHomeKey();
                break;

            case Qt.Key_Backspace: //Back Key
            case Qt.Key_J:
            case Qt.Key_Comma:

            case Qt.Key_Enter: //Select Key
            case Qt.Key_Return:
                MOp.postBackKey(111);
                break;
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
    }

    Component.onDestruction: {
    }

    onPhoneNumInputChanged: {
        if("" == phoneNumInput){
            dialListView = false;
        } else {
            dialListView = true
        }
    }

    onChineseKeypadTypeChanged: {
        setKeypad();
    }

    onChineseKeypadTypeDeviceNameChanged: {
        setKeypad();
    }

    onStateChanged: {
        UIListener.invokeAutoTestAthenaSendObject();
    }

    onPopupStateChanged: {
        if(popupState != "") {
            if(1 == gIgnoreReleased) {
                gIgnoreReleased = 0
                btnReleased()
            }
        }

        UIListener.invokeSendTouchCleanUpForApps();
        UIListener.invokeAutoTestAthenaSendObject();
        sigPopupStateChanged();
    }

    onBeep: {
        //DEPRECATED BtCoreCtrl.invokePlayBeep();
        UIListener.ManualBeep();
    }


    /* WIDGETS */

    // [LOADER] Background image
    MComp.DDLoader {
        id: idLoaderBackground
        y: 0
        width: 1280
        height: 720

        visible: (-1 < btPhoneEnter) ? true : false

        sourcePath: "../../BT/Common/BtImageBackground.qml"
        arabicSourcePath: "../../BT_arabic/Common/BtImageBackground.qml"
    }

    // [LOADER] Main
    FocusScope {
        id: idMainContainer
        y: 93
        visible: (true == btPhoneEnter) ? true : false
        focus: (true == btPhoneEnter) ? true : false    //idMainContainer.visible

        // [MAIN] Band
        MComp.DDLoader {
            id: idLoaderMainBand
            x: 0
            y: 0
            width: systemInfo.lcdWidth
            height: systemInfo.titleAreaHeight

            visible: (-1 < btPhoneEnter) ? true : false     //(true == btPhoneEnter) ? true : false
            //DEPRECATED focus: idLoaderMainBand.visible

            sourcePath: "../../BT/Band/BtMainBand.qml"
            arabicSourcePath: "../../BT_arabic/Band/BtMainBand.qml"

            KeyNavigation.down: {
                /* Main 화면에 따라 포커스 하단으로 이동 되는 조건문
                 * 전화번호부(수동/자동) 다운로드 화면, 최근통화목록(수동/자동) 다운로드 화면에서
                 * 하단으로 포커스 이동되지 않도록 수정
                 */
                if(idAppMain.state == "BtInfoView" && false == gInfoViewFocus) {
                    idLoaderMainBand
                } else {
                    if(true == idLoaderDial.visible) {
                        idLoaderDial
                    } else if(true == idLoaderRecents.visible) {
                        idLoaderRecents
                    } else if(true == idLoaderRecentsDelete.visible) {
                        idLoaderRecentsDelete
                    } else if(true == idLoaderContacts.visible) {
                        idLoaderContacts
                    } else if(true == idLoaderContactsSearch.visible) {
                        idLoaderContactsSearch
                    } else if(true == idLoaderFavorite.visible) {
                        idLoaderFavorite
                    } else if(true == idLoaderFavoriteDelete.visible) {
                        idLoaderFavoriteDelete
                    } else {
                        idLoaderInfoView
                    }
                }
            }

            onSigReloaded: {
                // 언어변경으로 Reloading된 경우 현재 화면에 맞게 밴드를 재설정해줌
                switch(mainViewState) {
                    case "Dial" :       selectedBand = "BAND_DIAL";        break;
                    case "RecentCall":  selectedBand = "BAND_RECENT";      break;
                    case "Phonebook":   selectedBand = "BAND_PHONEBOOK";   break;
                    case "Favorite":    selectedBand = "BAND_FAVORITE";    break;

                    default:
                        break;
                }
            }

            onActiveFocusChanged: {
                if(true == idLoaderMainBand.activeFocus) {
                    beforeFocus = "MAINBAND"
                }
            }
        }

        // [MAIN]
        MComp.DDLoader {
            id: idLoaderDial
            x: 0
            y: systemInfo.titleAreaHeight
            focus: false
            visible: false

            sourcePath: "../../BT/Dial/Main/BtDialMain.qml"
            arabicSourcePath: "../../BT_arabic/Dial/Main/BtDialMain.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderDial.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoader {
            id: idLoaderRecents
            x: 0
            y: systemInfo.titleAreaHeight
            focus: false
            visible: false

            sourcePath: "../../BT/Recent/Main/BtRecentCallList.qml"
            arabicSourcePath: "../../BT_arabic/Recent/Main/BtRecentCallList.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderRecents.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoader {
            id: idLoaderRecentsDelete
            x: 0
            y: 0
            focus: false
            visible: false

            sourcePath: "../../BT/Recent/Delete/BtRecentDelMain.qml"
            arabicSourcePath: "../../BT_arabic/Recent/Delete/BtRecentDelMain.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderRecentsDelete.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoader {
            id: idLoaderContacts
            x: 0
            y: systemInfo.titleAreaHeight
            focus: false
            visible: false

            sourcePath: "../../BT/Contacts/Main/BtContactMain.qml"
            arabicSourcePath: "../../BT_arabic/Contacts/Main/BtContactMain.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderContacts.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoaderKeypad {
            id: idLoaderContactsSearch
            x: 0
            focus: false
            visible: false

            sourcePath: "../../BT/Contacts/Search/BtContactSearchMain.qml"
            //arabicSourcePath: "../../BT_arabic/Contacts/Search/BtContactSearchMain.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderContactsSearch.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoader {
            id: idLoaderFavorite
            x: 0
            y: systemInfo.titleAreaHeight
            focus: false
            visible: false

            sourcePath: "../../BT/Favorite/Main/BtFavoriteMain.qml"
            arabicSourcePath: "../../BT_arabic/Favorite/Main/BtFavoriteMain.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderFavorite.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoader {
            id: idLoaderFavoriteDelete
            x: 0
            focus: false
            visible: false

            sourcePath: "../../BT/Favorite/Delete/BtFavoriteDelete.qml"
            arabicSourcePath: "../../BT_arabic/Favorite/Delete/BtFavoriteDelete.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderFavoriteDelete.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }

        MComp.DDLoader {
            id: idLoaderInfoView
            x: 0
            y: systemInfo.titleAreaHeight
            focus: false
            visible: false

            sourcePath: "../../BT/Common/BtInfoView.qml"
            arabicSourcePath: "../../BT_arabic/Common/BtInfoView.qml"

            KeyNavigation.up: idLoaderMainBand

            onActiveFocusChanged: {
                if(true == idLoaderInfoView.activeFocus) {
                    beforeFocus = "MAINVIEW"
                }
            }
        }
    }

    // [LOADER] Settings
    FocusScope {
        id: settingMainFocusScope
        y: 93
        visible: (false == btPhoneEnter) ? true : false
        focus: (false == btPhoneEnter) ? true : false   //settingMainFocusScope.visible    //DEPRECATED(false == btPhoneEnter) ? true : false


        function leftFocus() {
            idLoaderRightFocus.visible = false
            idLoaderLeftFocus.visible = true
        }

        function rightFocus() {
            idLoaderRightFocus.visible = true
            idLoaderLeftFocus.visible = false
        }

        MComp.DDLoader {
            id: idLoaderRightFocus
            x: 0
            y: 73

            sourcePath: "../../BT/Common/BtImageFocusRight.qml"
            arabicSourcePath: "../../BT_arabic/Common/BtImageFocusRight.qml"
        }

        MComp.DDLoader {
            id: idLoaderLeftFocus
            x: 0
            y: 71

            sourcePath: "../../BT/Common/BtImageFocusLeft.qml"
            arabicSourcePath: "../../BT_arabic/Common/BtImageFocusLeft.qml"
        }

        MComp.MComponent {
            id: idSettingsViewContainer
            x: 0
            y: 72

            function backKeyHandler() {
                if(false == btSettingsEnter) {
                    if(false == BtCoreCtrl.invokeIsAnyConnected()) {
                        // Dial > 설정화면 진입 > 연결 해제 > BackKey > Home
                        //DEPRECATED MOp.showPopup("disconnectSuccessPopup");
                        //UIListener.invokePostHomeKey();
                        UIListener.invokePostBackKey();
                    } else {
                        // 시리 종료후 화면 저장하는 변수 초기화
                        siriLastViewSave = false

                        popScreen(207);
                        callEndEvent();
                        if(false == BtCoreCtrl.invokeIsHFPConnected()
                            && (4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState() || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState())) {
                            // Dial > 설정화면 진입 > 연결 해제 > HFP미지원 기기 연결 후 BackKey 눌렀을 때 미지원 기기 팝업을 띄운다.
                            MOp.showPopup("popup_Bt_Not_Support_Bluetooth_Phone");
                        } else if(true == BtCoreCtrl.invokeIsBluelinkCallActivated()) {
                            // 블루링크 상태에서 Dial화면으로 전환이면 블루링크 팝업 출력
                            MOp.showPopup("popup_bluelink_popup_Outgoing_Call");
                        }
                    }
                    btSettingsEnter = true
                } else {
                    //DEPRECATED UIListener.invokePostHomeKey();
                    // Home > Settings > BtSettings > BackKey
                    callEndEvent();
                    popScreen(208);
                }
            }

            onBackKeyPressed:   { idSettingsViewContainer.backKeyHandler(); }
            //DEPRECATED onHomeKeyPressed:   { UIListener.invokePostHomeKey(); }
            onClickMenuKey:     { idMenu.show(); }

            // [SETTINGS] Band
            MComp.DDLoader {
                id: idLoaderSettingsBand
                y: -72
                visible: idLoaderSettingsLeft.visible

                sourcePath: "../../BT/Band/BtSettingsBand.qml";
                arabicSourcePath: "../../BT_arabic/Band/BtSettingsBand.qml"

                KeyNavigation.down: {
                    if(0 == settingCurrentIndex) {
                        idLoaderSettingsDeviceConnect
                    } else if(1 == settingCurrentIndex) {
                        idLoaderSettingsAutoConnect
                    } else if(2 == settingCurrentIndex) {
                        idLoaderSettingsAutoDownload
                    } else if(4 == settingCurrentIndex) {
                        idLoaderSettingsDeviceInfo
                    } else {
                        idLoaderSettingsLeft
                    }
                }

                onActiveFocusChanged: {
                    if(true == idLoaderSettingsBand.activeFocus) {
                        beforeFocus = "SETTINGBAND"
                    }
                }
            }

            // [SETTINGS] LEFT list
            MComp.DDLoader {
                id: idLoaderSettingsLeft
                x: 20 != gLanguage ? 34 : 699
                y: 6
                focus: false
                visible: false

                sourcePath: "../../BT/Setting/BtSettingsLeftList.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtSettingsLeftList.qml"

                Connections {
                    target: idAppMain
                    onSettingLeftTimerUpStart: {
                        idUpScrollTimer.start()
                    }

                    onSettingLeftTimerDownStart: {
                        idDownScrollTimer.start()
                    }

                    onSettingLeftTimerStop: {
                        idUpScrollTimer.stop()
                        idDownScrollTimer.stop()
                    }

                    onSettingBandFocus: {
                        idLoaderSettingsBand.forceActiveFocus()
                    }
                }

                function settingSettingView(index) {
                    switch(index) {
                        case 0: switchScreen("SettingsBtDeviceConnect", false, 51); break;
                        case 1: switchScreen("SettingsBtAutoConn", false, 54);      break;
                        case 2: switchScreen("SettingsBtAutoDown", false, 57);      break;
                        case 3: switchScreen("SettingsBtAudioStream", false, 21);   break;
                        case 4: switchScreen("SettingsBtDeviceName", false, 24);    break;
                        case 5: switchScreen("SettingsBtCustomer", false);          break;
                    }
                }

                Timer {
                    id: idUpScrollTimer
                    interval: 100
                    repeat: true
                    triggeredOnStart: true

                    onTriggered: {
                        if(0 != settingCurrentIndex) {
                            settingCurrentIndex --

                            if(true == iqs_15My) {
                                if(3 == settingCurrentIndex) {
                                    settingCurrentIndex --
                                }
                                if(2 == settingCurrentIndex) {
                                    settingCurrentIndex --
                                }
                            }

                            if(1 == settingCurrentIndex) {
                                if(BtCoreCtrl.m_pairedDeviceCount == 0){
                                    settingCurrentIndex --
                                }
                            }
                        } else {
                            settingCurrentIndex = 0
                            stop();
                        }
                        idLoaderSettingsLeft.settingSettingView(settingCurrentIndex);
                        idLoaderSettingsLeft.forceActiveFocus();
                    }
                }

                Timer {
                    id: idDownScrollTimer
                    interval: 100
                    repeat: true
                    triggeredOnStart: true

                    onTriggered: {
                        if(UIListener.invokeGetCountryVariant() == 1 || UIListener.invokeGetCountryVariant() == 0) {
                            if(5 != settingCurrentIndex) {
                                settingCurrentIndex ++
                                if(1 == settingCurrentIndex) {
                                    if(BtCoreCtrl.m_pairedDeviceCount == 0){
                                        settingCurrentIndex ++
                                    }
                                }

                                if(true == iqs_15My) {
                                    if(2 == settingCurrentIndex) {
                                        settingCurrentIndex ++
                                    }
                                    if(3 == settingCurrentIndex) {
                                        settingCurrentIndex ++
                                    }
                                }
                            } else {
                                settingCurrentIndex = 5
                                idDownScrollTimer.stop();
                            }
                        } else {
                            if(4 != settingCurrentIndex) {
                                settingCurrentIndex ++
                                if(1 == settingCurrentIndex) {
                                    if(BtCoreCtrl.m_pairedDeviceCount == 0){
                                        settingCurrentIndex ++
                                    }
                                }

                                if(true == iqs_15My) {
                                    if(2 == settingCurrentIndex) {
                                        settingCurrentIndex ++
                                    }
                                    if(3 == settingCurrentIndex) {
                                        settingCurrentIndex ++
                                    }
                                }
                            } else {
                                settingCurrentIndex = 4
                                idDownScrollTimer.stop();
                            }
                        }

                        idLoaderSettingsLeft.settingSettingView(settingCurrentIndex);
                        idLoaderSettingsLeft.forceActiveFocus();
                    }
                }

                naviLeft: idLoaderSettingsLeft
                naviRight: {
                    if(0 == settingCurrentIndex) {
                        idLoaderSettingsDeviceConnect
                    } else if(1 == settingCurrentIndex) {
                        idLoaderSettingsAutoConnect
                    } else if(2 == settingCurrentIndex) {
                        idLoaderSettingsAutoDownload
                    } else if(4 == settingCurrentIndex) {
                        idLoaderSettingsDeviceInfo
                    } else {
                        idLoaderSettingsLeft
                    }
                }

                onActiveFocusChanged: {
                    if(true == idLoaderSettingsLeft.activeFocus) {
                        settingMainFocusScope.leftFocus();
                        beforeFocus = "SettingsBtDeviceConnect"
                    }
                }
            }

            // [SETTINGS] RIGHT list
            MComp.DDLoader {
                id: idLoaderSettingsDeviceConnect
                x: (20 != gLanguage) ? 708 : 18
                y: 8
                width: systemInfo.lcdWidth - 708
                height: systemInfo.lcdHeight - 166

                sourcePath: "../../BT/Setting/BtRightView/SettingsBtDeviceConnect/BTSettingsDeviceConnect.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtDeviceConnect/BTSettingsDeviceConnect.qml"

                KeyNavigation.up: idLoaderSettingsBand

                naviLeft: idLoaderSettingsLeft
                naviRight: idLoaderSettingsDeviceConnect

                onActiveFocusChanged: {
                    if(true == idLoaderSettingsDeviceConnect.activeFocus) {
                        settingMainFocusScope.rightFocus();
                        beforeFocus = "MAINVIEW"
                    }
                }
            }

            MComp.DDLoader {
                id: idLoaderSettingsAutoConnect
                x: (20 != gLanguage) ? 708 : 18
                y: 8
                width: systemInfo.lcdWidth - 708
                height: systemInfo.lcdHeight - 166

                sourcePath: "../../BT/Setting/BtRightView/SettingsBtAutoConn/BtSettingsAutoConn.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtAutoConn/BtSettingsAutoConn.qml"

                KeyNavigation.up: idLoaderSettingsBand

                naviLeft: idLoaderSettingsLeft
                naviRight: idLoaderSettingsAutoConnect

                onActiveFocusChanged: {
                    if(true == idLoaderSettingsAutoConnect.activeFocus) {
                        settingMainFocusScope.rightFocus();
                        beforeFocus = "MAINVIEW"
                    }
                }
            }

            MComp.DDLoader {
                id: idLoaderSettingsAudioStream
                x: (20 != gLanguage) ? 708 : 18
                y: 8
                width: systemInfo.lcdWidth - 708
                height: systemInfo.lcdHeight - 166

                sourcePath: "../../BT/Setting/BtRightView/SettingsBtAudioStream/BtSettingsAudioStream.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtAudioStream/BtSettingsAudioStream.qml"

                KeyNavigation.up: idLoaderSettingsBand

                naviLeft: idLoaderSettingsAudioStream
                naviRight: idLoaderSettingsAudioStream
            }

            MComp.DDLoader {
                id: idLoaderSettingsAutoDownload
                x: (20 != gLanguage) ? 708 : 18
                y: 8
                width: systemInfo.lcdWidth - 708
                height: systemInfo.lcdHeight - 166

                sourcePath: "../../BT/Setting/BtRightView/SettingsBtAutoDown/BtSettingsAutoDown.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtAutoDown/BtSettingsAutoDown.qml"

                KeyNavigation.up: idLoaderSettingsBand

                naviLeft: idLoaderSettingsLeft
                naviRight: idLoaderSettingsAutoDownload

                onActiveFocusChanged: {
                    if(true == idLoaderSettingsAutoDownload.activeFocus) {
                        settingMainFocusScope.rightFocus();
                        beforeFocus = "MAINVIEW"
                    }
                }
            }

            MComp.DDLoader {
                id: idLoaderSettingsDeviceInfo
                x: (20 != gLanguage) ? 708 : 18
                y: 8
                width: systemInfo.lcdWidth - 708
                height: systemInfo.lcdHeight - 166

                sourcePath: "../../BT/Setting/BtRightView/SettingsBtDeviceName/BtSettingsDeviceName.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtDeviceName/BtSettingsDeviceName.qml"

                KeyNavigation.up: idLoaderSettingsBand

                naviLeft: idLoaderSettingsLeft
                naviRight: idLoaderSettingsDeviceInfo

                onActiveFocusChanged: {
                    if(true == idLoaderSettingsDeviceInfo.activeFocus) {
                        beforeFocus = "MAINVIEW"
                        settingMainFocusScope.rightFocus();
                    }
                }
            }

            MComp.DDLoader {
                id: idLoaderSettingsCustomerCenter
                x: (20 != gLanguage) ? 708 : 18
                y: 8
                width: systemInfo.lcdWidth - 708
                height: systemInfo.lcdHeight - 166

                sourcePath: "../../BT/Setting/BtRightView/SettingsBtCustomer/BtSettingsCustomer.qml";
                arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtCustomer/BtSettingsCustomer.qml"

                KeyNavigation.up: idLoaderSettingsBand

                naviLeft: idLoaderSettingsCustomerCenter
                naviRight: idLoaderSettingsCustomerCenter
            }
        }
    }

    // [LOADER] Visual Cue
    MComp.DDLoader {
        id: idVisualCue
        x: 566
        y: 364
        z: 0
        width: 148
        height: 157

        // 설정화면, 다이얼화면, 폰북화면에서면 VisualCue 활성화
        visible: (idAppMain.state == "BtContactMain") || (idAppMain.state == "BtDialMain") || (false == btPhoneEnter)

        sourcePath: "../../QML/DH/DDVisualCue.qml"
        arabicSourcePath: "../../QML/DH/DDVisualCue.qml"

        function setVisualCue(top, right, bottom, left) {
            sigSetVisualCue(top, right, bottom, left);
        }
    }

    // [LOADER] Submain(기기명변경, PIN코드 변경 등)
    MComp.DDLoaderKeypad {
        id: idLoaderSettingsDeviceName
        x: 0
        y: 93
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        visible: false
        focus: false

        sourcePath: {
            if(2 == UIListener.invokeGetCountryVariant()) {
                "../../BT/Setting/BtRightView/SettingsBtDeviceName/BtSettingsNameChangrForChina.qml"
            } else {
                "../../BT/Setting/BtRightView/SettingsBtDeviceName/BtSettingsNameChange.qml"
            }
        }
        //arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtDeviceName/BtSettingsNameChange.qml"

        onActiveFocusChanged: {
            if(true == idLoaderSettingsDeviceName.activeFocus) {
                beforeFocus = "MAINVIEW"
            }
        }
    }

    MComp.DDLoader {
        id:idLoaderSettingsPINCode
        x: 0
        y: 93
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        visible: false
        focus: false

        sourcePath: "../../BT/Setting/BtRightView/SettingsBtPinCodeIntro/PinCodeChange/SettingsBTPinCodeChange.qml"
        arabicSourcePath: "../../BT_arabic/Setting/BtRightView/SettingsBtPinCodeIntro/PinCodeChange/SettingsBTPinCodeChange.qml"

        onActiveFocusChanged: {
            if(true == idLoaderSettingsPINCode.activeFocus) {
                beforeFocus = "MAINVIEW"
            }
        }
    }

    MComp.DDLoader {
        id: idLoaderSettingsDeviceDelete
        x: 0
        y: 93
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        visible: false
        focus: false

        sourcePath: "../../BT/Device/Delete/BtDeviceDelMain.qml";
        arabicSourcePath: "../../BT_arabic/Device/Delete/BtDeviceDelMain.qml"

        onActiveFocusChanged: {
            if(true == idLoaderSettingsDeviceDelete.activeFocus) {
                beforeFocus = "MAINVIEW"
            }
        }
    }

    // [LOADER] Menu
    MComp.DDMenuLoader {
        id: idMenu
        y: 93
    }

    // StatusBar
    QmlStatusBar {
        id: idStatusBar
        x: 0
        y: 0

        width: 1280
        height: 93
        homeType: "button"
        middleEast: (20 != gLanguage) ? false : true
    }

    // [LOADER] Call
    MBtCall.BtCallMain {
        id: idLoaderCallView
        x: 0
        y: -systemInfo.lcdHeight   //("FOREGROUND" == callViewState || "DELAYED_IDLE" == callViewState) ? 0 : -systemInfo.lcdHeight;
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        focus: false

        visible: {
            if(0 < callType) {
                true
            } else if(1 > callType && "DELAYED_IDLE" == callViewState) {
                /* BG Event가 확정적으로 올 것을 알고 있을때 BG Event가 올때까지 잠깐의 시간동안
                 * 통화화면을 유지함
                 */
                true
            } else {
                false
            }
            //|| (0 == callType &&)) ? true : false;
        }

        onVisibleChanged: {
            if(true == idLoaderCallView.visible) {
                if("" != popupState) {
                    console.log("################################");
                    console.log("## idLoaderCallView.visible + popupState = " + popupState);
                    console.log("################################");
                } else {
                    // 전화화면이 뜨는 경우 입력된 전화번호 초기화
                    phoneNumInput = ""
                    idLoaderCallView.forceActiveFocus();
                }
            } else {
                MOp.returnFocus();
            }
        }

        onActiveFocusChanged: {
            if(true == idLoaderCallView.activeFocus) {
                beforeFocus = "CALL"
            }
        }
    }


    Rectangle {
        id: popupBackGround
        y: 93
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight - 93
        color: "Black"
        visible: (popupState != "")
                 && false == popupBackGroundBlack
                 && ((true == systemPopupOn)
                 ||(popupState == "popup_toast")
                 ||(popupState == "popup_Bt_Add_Favorite")
                 ||(popupState == "popup_Bt_Deleted")
                 ||(popupState == "connectSuccessPopup")
                 ||(popupState == "popup_Bt_Contact_Update_Completed")
                 ||(popupState == "popup_enter_setting_during_call"))
                 ? true : false
    }

    Rectangle {
        id: popupStatusBarDim
        width: systemInfo.lcdWidth
        height: 93
        color: "Black"
        opacity:  (true == systemPopupOn) ? 0 : 0.6
        visible: {
            if(false == popupBackGround.visible) {
                if(popupState != "") {
                    if((popupState == "popup_toast")
                        || (popupState == "popup_Bt_Add_Favorite")
                        || (popupState == "popup_Bt_Deleted")
                        || (popupState == "connectSuccessPopup")
                        || (popupState == "popup_Bt_Connect_Canceled")
                        || (popupState == "connectSuccessA2DPOnlyPopup")
                        || (popupState == "popup_Bt_Initialized")
                        || (popupState == "disconnectSuccessPopup")
                        || (popupState == "popup_Bt_Disconnect_By_Phone")
                        || (popupState == "popup_Dim_For_Call")
                        || (popupState == "popup_Bt_Contact_Update_Completed")) {
                        false
                    } else {
                        true
                    }
                } else {
                    false
                }
            } else {
                if(popupState == "popup_enter_setting_during_call") {
                    true
                } else {
                    false
                }
            }
        }

        MouseArea {
            beepEnabled: false
            anchors.fill: parent
        }
    }

    // [LOADER] Popup
    MBt.BtPopup {
        id: idLoaderPopup
        y: 93
        visible: ("" != popupState) ? true : false
        // focus: idLoaderPopup.visible

        onVisibleChanged: {
            if(true == idLoaderPopup.visible) {
                // 팝업이 화면에 표시될 때 메뉴가 떠 있다면 강제로 메뉴를 없앰
                idMenu.hide();
                idLoaderPopup.forceActiveFocus();
            } else {
                // 팝업이 사라졌을 때
                if("FOREGROUND" == callViewState) {
                    idLoaderCallView.forceActiveFocus();
                } else {
                    MOp.returnFocus();
                }
            }
        }
    }

    // [LOADER] SIRI
    MComp.DDLoader {
        id: idLoaderSiri
        y: 93
        visible: false
        focus: false

        sourcePath: "../../BT/DHBtSiriMain.qml"
        arabicSourcePath: "../../BT/DHBtSiriMain.qml"

        onActiveFocusChanged: {
            if(true == idLoaderSiri.activeFocus) {
                beforeFocus = "SIRIVIEW"
            }
        }
    }

    //2015.10.30 [ITS 0269835,0269836] Android Auto Handling (UX Scenario Changed)
    // [LOADER] AADefend
    MComp.DDLoader {
        id: idLoaderAADefend
        x: 0
        y: 93
        visible: false
        focus: false

        sourcePath: "../../BT/DHBtAADefend.qml"
        arabicSourcePath: "../../BT_arabic/DHBtAADefend.qml"

        onActiveFocusChanged: {
            if(true == visible) {
                focus = true;
            }else{
                focus = false;
            }
        }
    }

    /* SIGNALS */
    DHBtSignals {

        //2015.10.30 [ITS 0269835,0269836] Android Auto Handling (UX Scenario Changed)
        Connections {
            target: UIListener
            onConnectingAADefendShow: {
                if(bShow)   {
                    idLoaderAADefend.show();
                    idLoaderAADefend.visible = true;
                }
                else{
                    idLoaderAADefend.hide();
                    idLoaderAADefend.visible = false;

                    //[ITS 0270818]: D2.BT 신규기기 등록 팝업 포커스 표시 안함
                    if("" != popupState) {
                        idLoaderPopup.forceActiveFocus();
                        idLoaderPopup.resetFocus()
                    }
                }
            }
        }

        Connections {
            target: BtCoreCtrl

            /* Phonebook download state
             */
            //[ITS 0271650]
            onSigCheckPopupForCallState: {
                if((popupState == "Call_3way_popup")&&(callType == 41))
                {
                    BtCoreCtrl.HandleRejectWaitingCall();
                }
            }

            onSigContactStateChanged: {
                switch(nState) {
                    case 9: {/* 다운로드 중 */
                        contactState = "ContactsDownLoading";
                        contact_value = 1;
                        downloadContact = true;

                        if("Phonebook" == mainViewState) {
                            MOp.switchInfoViewScreen(contactState);
                        }
                        break;
                    }

                    case 12: { /* 수동다운로드 대기 상태 */
                        phonebookDownState = "Mal";
                        contactState = "ContactsWaitDownMal";
                        contact_value = 2;
                        downloadContact = false;

                        if("Phonebook" == mainViewState) {
                            MOp.switchInfoViewScreen(contactState);
                        }

                        break;
                    }

                    case 2: { /* 수동다운로드 대기 상태 (휴대폰에서 전화번호부가 없고, 최근통화 목록만 있는 상태)*/
                        phonebookDownState = "Mal";
                        contactState = "ContactsWaitDownMal";
                        contact_value = 2;
                        downloadContact = false;

                        if("Phonebook" == mainViewState) {
                            MOp.switchInfoViewScreen(contactState);
                        }

                        // 폰북 데이터를 하나도 받지 못했을 경우(0개)도 CallHistory download를 시작하도록 한다.
                        if(callHistoryDownState == "Auto"
                            || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())
                        ) {
                            BtCoreCtrl.invokeTrackerDownloadCallHistory();
                        }
                        break;
                    }

                    case 11:
                    case 13: { /* 자동 다운로드 대기 상태 */
                        //phonebookDownState = "Auto";
                        contactState = "ContactsWaitDownAuto";
                        contact_value = 3;
                        downloadContact = false;

                        qml_debug("Phonebook Download Timer Start")

                        if("Phonebook" == mainViewState) {
                            /* 현재 화면이 전화번호부 인 경우 전화번호부 화면을 Update해주고 포커스 Band로 재설정 */
                            MOp.switchInfoViewScreen(contactState);

                            idLoaderMainBand.focus = true;
                        }
                        break;
                    }

                    case 4: { /* 전화번호부 다운로드 미지원 상태 */
                        contactState = "ContactsNotSupport";
                        contact_value = 4;
                        downloadContact = false;

                        if("Phonebook" == mainViewState) {
                            /* 다운로드 대기 상태와 동일하게 화면 Update 필요 */
                            MOp.switchInfoViewScreen(contactState);

                            idLoaderMainBand.focus = true;
                        }
                        break;
                    }

                    case 10: { /* 수동 다운로드 중 상태*/
                        contactState = "ContactsDownLoadingMal";
                        contact_value = 5;
                        downloadContact = true;

                        if("Phonebook" == mainViewState) {
                            if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
                                // 백그라운드 다운로드 모드인 경우는 전화번호부 Have상태를 유지한다.
                            } else {
                                MOp.switchInfoViewScreen(contactState);
                            }
                        }
                        break;
                    }

                    case 8: { /* 다운로드 실패 상태 */
                        contactState = "DownLoadFail";
                        contact_value = 6;
                        downloadContact = false;

                        if("Settings" == mainViewState && "popup_Bt_Dis_Connection" == popupState) {
                            MOp.showPopup("DownLoadFail");
                        }
                        break;
                    }

                    case 0:
                    case 3: { /* 전화번호부 다운로드 미지원 상태 */
                        contactState = "ContactsNotSupport";
                        contact_value = 8;
                        downloadContact = false;
                        if("Phonebook" == mainViewState) {
                            MOp.switchInfoViewScreen(contactState);
                        }
                        break;
                    }

                    case 1: { /* 폰북 다운로드 완료 (전화번호부 화면 출력 필요) */
                        if(popupState != "popup_bt_no_download_phonebook" || popupState != "popup_bt_no_downloading_phonebook") {
                            contactState = "";
                            contact_value = 7;
                            downloadContact = false;
                            phonebookDownState = "Mal";

                            if(popupState == "DeviceContactDis") {
                                MOp.hidePopup();
                            }

                            if("Phonebook" == mainViewState) {
                                if(false == siriViewState) {
                                    /* BackgroundDownloadMode 일 때, 검색 화면에서 다운로드 완료 시, 폰북 화면으로 무조건 천이되는 이슈
                                     * 업데이트 필요 시 팝업 출력, 업데이트 불 필요 시 검색 화면 유지
                                     */
                                    idMenu.hide();
                                    if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
                                        if(-1 /* default */ == BtCoreCtrl.invokeIsContactsUpdated() || 0 /* same */ == BtCoreCtrl.invokeIsContactsUpdated()) {
                                            //do nothing
                                        }
                                        else {
                                            /* not same 1 == BtCoreCtrl.invokeIsContactsUpdated() */
                                            switchScreen("BtContactMain", false, 130);
                                        }
                                    }
                                    else
                                    {
                                        switchScreen("BtContactMain", false, 130);
                                    }
                                }
                            } else if("Dial" == mainViewState) {
                                // Dial 인경우 입력번호가 있으면 전화번호부 다운로드 후 검색해줌
                                if("" != phoneNumInput) {
                                    BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);
                                }
                            }
                        }

                        if(callHistoryDownState == "Auto"
                            || (true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())
                        ) {
                            BtCoreCtrl.invokeTrackerDownloadCallHistory();
                        }

                        break;
                    }

                    case 14: {
                        contactState = "ContactsUpdate";
                        contact_value = 1;
                        downloadContact = true;

                        if("Phonebook" == mainViewState) {
                            MOp.switchInfoViewScreen(contactState);
                        }
                        break;
                    }

                    default:
                        break;
                }

                contact_nstate = nState

                if((2 == contact_value)) {
                    /* InfoView 화면일때 Band에서 포커스가 하단으로 이동할수 있게 해주는 변수 */
                    gInfoViewFocus = true;
                }
            }

            /* Call history download state
             */
            onSigCallhistoryStateChanged: {
                qml_debug("Signal onSigCallhistoryStateChanged")
                qml_debug("nState = " + nState)

                switch(nState) {
                    case 1: {
                        recent_value = 7;
                        recentCallState = "";
                        callHistoryDownState = "Mal";
                        downloadCallHistory = false;

                        if(popupState == "DeviceRecentCallDis") {
                            MOp.hidePopup();
                        }

                        if(false == siriViewState) {
                            // Siri 화면에서 다운로드 완료되었을 때 OSD 출력 후 화면 빠지는 문제 수정
                            if("RecentCall" == mainViewState) {
                                idMenu.hide();
                                switchScreen("BtRecentCall", false, 131);
                            }
                        }
                        break;
                    }

                    case 12:
                    case 2: {
                        callHistoryDownState = "Mal";
                        recentCallState = "recent_mal_download_wait";
                        recent_value = 2;
                        downloadCallHistory = false;

                        if("RecentCall" == mainViewState) {
                            MOp.switchInfoViewScreen(recentCallState);
                        }
                        break;
                    }

                    case 0:
                    case 3: {
                        recent_value = 8;
                        recentCallState = "recent_no_list";
                        gInfoViewState = recentCallState;
                        downloadCallHistory = false;
                        break;
                    }

                    case 4: {
                        recentCallState = "recent_not_support";
                        recent_value = 4;
                        //DEPRECATED callhistoryinPhone = true;
                        downloadCallHistory = false;

                        if("RecentCall" == mainViewState) {
                            MOp.switchInfoViewScreen(recentCallState);
                        }
                        break;
                    }

                    case 8: {
                        recentCallState = "DownLoadFail";
                        recent_value = 6;
                        downloadCallHistory = false;

                        if(mainViewState == "Settings" && popupState == "popup_Bt_Dis_Connection") {
                            MOp.showPopup("DownLoadFail");
                        }

                        if("RecentCall" == mainViewState) {
                            gInfoViewState = recentCallState
                            MOp.showPopup("DownLoadFail");
                        }
                        break;
                    }

                    case 9: {
                        recentCallState = "recent_auto_downloading"
                        recent_value = 1
                        downloadCallHistory = true

                        if("RecentCall" == mainViewState) {
                            MOp.switchInfoViewScreen(recentCallState);
                        }
                        break;
                    }

                    case 11: {
                        // Wait download
                        callHistoryDownState = "Auto";
                        recentCallState = "RecentWaitDownAuto";
                        recent_value = 3;
                        downloadCallHistory = false;

                        if(mainViewState == "RecentCall") {
                            MOp.switchInfoViewScreen(recentCallState);
                        }
                        break;
                    }

                    case 13: {
                        // PBAP connect request
                        //callHistoryDownState = "Auto";
                        recentCallState = "RecentWaitDownAuto";
                        recent_value = 3;
                        downloadCallHistory = false;

                        if(mainViewState == "RecentCall") {
                            MOp.switchInfoViewScreen(recentCallState);
                        }
                        break;
                    }

                    case 10: {
                        recentCallState = "RecentDownLoadingMal";
                        recent_value = 5;
                        downloadCallHistory = true;

                        if("RecentCall" == mainViewState) {
                            if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
                                // 백그라운드 다운로드 상태면 최근통화목록 Have상태 유지
                            } else {
                                MOp.switchInfoViewScreen(recentCallState);
                            }
                        }
                        break;
                    }

                    default:
                        break;
                }

                recent_nstate = nState
            }
        }
    }

    /* DEBUG infos [Qml 디버깅 필요 시 주석 해제] */
    /*DHBtDebug {
        x: 0
        y: 0
        // do nothing
    }*/

    /* EVENT handlers */
    onCallTypeChanged: {
        /* 통화 상태가 변경될때 발생되는 Event */

        console.log("####################################################");
        console.log("[onCallTypeChanged] call type = " + callType);
        console.log("[onCallTypeChanged] callViewState = " + callViewState);
        console.log("####################################################");

        /* 콜화면 전환 중 현재 옵션 메뉴의 상태를 확인하여 보여지고 있으면 
         * 콜화면 변경 시 Menu 없애도록 수정
         */
        //DEPRECATED MOp.hide()
        idMenu.hide();

        switch(callViewState) {
            case "IDLE":
            case "DELAYED_IDLE": {
                //__IQS_15MY_ Call End Modify
                if(10 < callType || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == callType)) {
                    MOp.showCallView(7008);
                } else if(0 == callType) {
                    MOp.returnFocus(9);
                }
                break;
            }

            case "FOREGROUND":
            case "BACKGROUND": {
                console.log("# callType = " + callType);

                if(1 > callType) { // 통화 상태가 아님
                    //DEPRECATED callDTMFDialInput = "";
                    phoneNumInput = ""  // 통화 종료 후 초기화 Issue #461
                    MOp.initCallView(4008);
                }

                /* 통화 종료 후 이전화면을 확인하여 주행규제가 필요한 화면이라면
                 * 주행규제 팝업을 출력하도록 수정
                 */
                if(false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                    if("BtContactSearchMain" == idAppMain.state || "SettingsBtNameChange" == idAppMain.state || "SettingsBtPINCodeChange" == idAppMain.state){
                        MOp.showPopup("popup_search_while_driving");
                    }
                }
                break;
            }

            default: {
                console.log("#############################################");
                console.log("Invalid view state");
                console.log("#############################################");
                break;
            }
        }
    }

    onCallViewStateChanged: {
        /* 통화 화면 상태가 변경될때 발생되는 Event */
        console.log("###################################################");
        console.log("onCallViewStateChanged: " + callOldViewState + ", " + callViewState);
        console.log("###################################################");

        if(callOldViewState == callViewState) {
            // 변경 전 상태와 변경 후 상태가 동일
            console.log("# same call view state");
        } else {
            checkedCallViewStateChange ++;
            // touch long pressed 상태에서 Call view화면으로 천이된 경우 touch값 clean하여 이전 화면 유지
            UIListener.invokeSendTouchCleanUpForApps();
            if("FOREGROUND" == callViewState || "DELAYED_IDLE" == callViewState) {
                idLoaderCallView.y = 93;

                /* idle -> foreground 또는 background -> foreground 시점에(화면에 표시되어야 할 때)
                 * focus 사라짐 방지
                 */
                idLoaderCallView.forceActiveFocus();
            } else {
                //if("BACKGROUND" == callViewState || "IDLE" == callViewState) {
                idLoaderCallView.y = -systemInfo.lcdHeight;
            }

            callOldViewState = callViewState;

            /* 일부상황에서 closeScreen() 이후에  showCallView()가 호출되며
             * 일정 타이밍 동안 Focus를 주어야할 대상을 잃어버리는 문제가 있음
             */
            MOp.returnFocus();
        }
    }


    /* SCREEN management */
    function pushScreen(to_screen, case_num) {
        MOp.debugStack("pushScreen", case_num);
        var from_screen = UIListener.invokeTopScreen();

        if(to_screen == from_screen) {
            /* 동일화면을 push할 수 없도록 함
             */
            console.log("## duplicated");
            return;
        }

        MOp.debugScreen("pushScreen", from_screen, to_screen, case_num);

        // Hide current screen and push it to stack
        if("" != from_screen) {
            /* ITS 238626
             * siri화면 전환 시,이전 화면이 기기 삭제 화면이면 화면 유지
             */
            if(("BtFavoriteDelete" == from_screen || "BtDeviceDelMain" == from_screen) && "BtSiriView" == to_screen) {
                //do nothing
            } else {
                MOp.hideScreen(from_screen);
            }
        }

        UIListener.invokePushScreen(to_screen);
        MOp.showScreen(to_screen);

        idAppMain.state = to_screen;
        MOp.debugStack("pushScreen", case_num);

        MOp.returnFocus();
    }

    function popScreen(case_num) {
        MOp.debugStack("popScreen", case_num);
        var from_screen;
        var to_screen;

        if(2 > UIListener.invokeGetScreenSize()) {
            /* 더 이상 빠질 화면이 없을 경우 Home으로 돌아감
             */

            phoneNumInput = "";

            if("FOREGROUND" == callViewState) {
                from_screen = UIListener.invokePopScreen();
                MOp.closeScreen(from_screen);
            } else {
                if("BtSiriView" != idAppMain.state) {
                    UIListener.invokePostBackKey();
                    to_screen = "BACK";
                }
            }

            // HOME으로 돌아갈때 closeScreen을 하면 화면이 사라지고 HOME로 빠지는 현상이 발생함
            // --> 재 진입 시점에 Stack clear 처리필요
            //DEPRECATED MOp.closeScreen(from_screen);
            //DEPRECATED idAppMain.state = "";

            MOp.debugScreen("popScreen - back", from_screen, to_screen, case_num);
            return;
        }

        from_screen = UIListener.invokePopScreen();
        MOp.closeScreen(from_screen);

        // 되돌아 가는 화면이 InfoView 인 경우 다운로드가 완료 되는 시점 확인
        to_screen = UIListener.invokeTopScreen();
        if("BtInfoView" == to_screen) {
             if("BAND_RECENT" == selectedBand) {
                if(1 == recent_nstate) {
                    // 최근통화목록 다운로드 HAVE 상태면
                    UIListener.invokePopScreen();
                    UIListener.invokePushScreen("BtRecentCall");
                    to_screen = "BtRecentCall";
                } else {
                    MOp.switchInfoViewScreen(recentCallState);
                }
            } else if("BAND_PHONEBOOK" == selectedBand) {
                 if(1 == contact_nstate || (10 == contact_nstate && true == BtCoreCtrl.invokeGetBackgroundDownloadMode())) {
                    // 전화번호부 다운로드 HAVE 상태면
                    UIListener.invokePopScreen();
                    UIListener.invokePushScreen("BtContactMain");
                    to_screen = "BtContactMain";
                } else {
                    MOp.switchInfoViewScreen(contactState);
                }
            } else if("BAND_FAVORITE" == selectedBand) {
                if(1 == favorite_nstate) {
                    to_screen = "BtFavoriteMain"
                    UIListener.invokePopScreen();
                    UIListener.invokePushScreen("BtFavoriteMain");
                } else {
                    MOp.switchInfoViewScreen("FavoritesNoList");
                }
            }
        } else if("BtContactMain" == to_screen) {
            if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode() && "" == favoriteAdd) {
                //  전화번호부 백그라운드 다운로드 상태였다면 Have 상태 화면으로 전환
                UIListener.invokePopScreen();
                UIListener.invokePushScreen("BtContactMain");
                to_screen = "BtContactMain";
            } else {
                if("" != favoriteAdd) {
                    // 즐겨찾기 -> Add New -> 검색 -> BackKey -> 다운로드 중 화면 출력문제 수정
                } else if(1 != contact_nstate) {
                    console.log("# READJUST contact");

                    gInfoViewState = contactState;
                    UIListener.invokePopScreen();
                    UIListener.invokePushScreen("BtInfoView");
                    to_screen = "BtInfoView";
                } else {
                    console.log("# do nothing, contact");
                }
            }
        } else if("BtRecentCall" == to_screen) {
            if(1 != recent_nstate) {
                console.log("# READJUST recent");

                gInfoViewState = recentCallState;
                UIListener.invokePopScreen();
                UIListener.invokePushScreen("BtInfoView");
                to_screen = "BtInfoView";
            } else {
                console.log("# do nothing, recent");
            }
        } else if("BtFavoriteMain" == to_screen) {
            if(1 != favoriteValue) {
                console.log("# READJUST favorite");

                gInfoViewState = "FavoritesNoList";
                UIListener.invokePopScreen();
                UIListener.invokePushScreen("BtInfoView");
                to_screen = "BtInfoView";
            } else {
                console.log("# do nothing, favorite");
            }
        } else {
            console.log("do nothing");
        }

        //to_screen = UIListener.invokeTopScreen();
        MOp.showScreen(to_screen);

        idAppMain.state = to_screen;
        MOp.debugScreen("popScreen", from_screen, to_screen, case_num);
    }

    function switchScreen(to_screen, update_force, case_num) {
        MOp.debugStack("switchScreen", case_num);

        var from_screen = UIListener.invokeTopScreen();
        MOp.debugScreen("switchScreen", from_screen, to_screen, case_num);

        if(to_screen != "BtInfoView") {
            /* BtInfoView는 모두 동일한 화면으로 특별히 update_force 값을 주지 않아도
             * 항상 강제 업데이트 함
             */
            if(false == update_force && to_screen == UIListener.invokeTopScreen()) {
                // 현재화면과 동일화면으로 Switch하는 경우 아무것도 하지 않음
                return;
            }
        }

        // Pop and push screen
        from_screen = UIListener.invokePopScreen();
        MOp.closeScreen(from_screen);

        UIListener.invokePushScreen(to_screen);
        MOp.showScreen(to_screen);

        idAppMain.state = to_screen;
    }


    /**************************************************************************
     * Temporary
     **************************************************************************/
/*TODO
    MComp.MPopupTypeText {
        id: idTestPopup
        y: 93
        visible: testPopup
        focus: testPopup

        popupBtnCnt: 1
        popupLineCnt: 1

        popupFirstText: "Incorrect bluetooth module firmware is installed.\nBluetooth function may not work properly.\nPlease upgrade with official upgrade method."
        popupFirstBtnText: stringInfo.str_Ok;

        onPopupFirstBtnClicked: { testPopup = false }
        onHardBackKeyClicked: { testPopup = false }
    }
TODO*/
}
/* EOF */
