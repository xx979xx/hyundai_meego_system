/**
 * BtPopup.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idPopupMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: idPopupMain.visible


    Connections {
        target: UIListener

        onRetranslateUi: {
            if((("popup_recent_info" == popupState)
                || ("popup_phonebook_search_add" == popupState)
                || ("popup_phonebook_search" == popupState)
                || ("popup_favorite_add_contacts" == popupState)
                || ("popup_favorite_add_contacts_add" == popupState)) && false == checkedpopup) {
                MOp.hidePopup();
                MOp.showPopup("popup_Language_Changed");
                return;
            }

            switch(textPopupName) {
                case "popup_Bt_Authentication_Fail": {
                    idPopupLoaderText.buttonCount = 2;
                    idPopupLoaderText.backgroundOpacity = true;

                    idPopupLoaderText.bodyText = stringInfo.str_Authentication_Fail;

                    idPopupLoaderText.button1Text = stringInfo.str_Yes;
                    idPopupLoaderText.button2Text = stringInfo.str_Bt_No;
                    break;
                }

                case "popup_Bt_Ini": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = true;

                    idPopupLoaderText.bodyText = stringInfo.str_Inializing;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_no_downloading_phonebook": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Phonebook_Downloading;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_no_download_phonebook": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory_Message;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_contact_download_fail": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Phonebook_Down_Fail_1;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_callhistory_download_fail": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_CallHistory_Down_Fail_1;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Add_Favorite_Duplicate": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Save_Favorite;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Call_No_Outgoing": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Bt_No_Number;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_outgoing_calls_empty": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Favorite_Max": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Max_Favorite;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_State_Calling_No_OutCall": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_During_Call_Nocall;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_invalid_during_call": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_During_Call;
                    idPopupLoaderText.button1Text= stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_No_Dial_No_Connect_Device": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Dial_Fail
                    idPopupLoaderText.button1Text = stringInfo.str_Close
                    break;
                }

                case "popup_Bt_Downloading_Phonebook": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Phonebook_Downloading;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_No_Phonebook_Phone": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Max_Device;
                    idPopupLoaderText.button1Text = stringInfo.str_No_Phonebook_Phone;
                    break;
                }

                case "popup_Bt_No_CallHistory_Phone": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory_Phone;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                case "popup_Bt_No_CallHistory": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Call_Fail": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Dial_Fail;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                /*case "popup_Bt_Request_Phonebook": {
                    idPopupLoaderText.buttonCount =  1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Req_Down_Phonebook + ' ' + stringInfo.str_Accept_Phone_Popup;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }*/

                case "popup_bt_contact_callhistory_download_stop_disconnect": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Bt_Disconnect_Download_Stop
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_outgoing_calls_empty": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_no_phonebook_on_phone": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.no_phonebook_phone;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_not_transfer_call": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.ford_popup_message;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                case "popup_during_bluelink_not_transfer": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Change_Handfree;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_not_transfer_call": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.ford_popup_message;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                case "popup_during_bluelink_not_transfer": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Change_Handfree;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_outgoing_calls_empty_download": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory_Recent;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Preparing": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = true;

                    idPopupLoaderText.bodyText = stringInfo.str_Preparing;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                default:
                    break;
            }
        }
    }


    /*
     */
    function showTextPopup(name) {
        if(idPopupLoaderText.popupType == name) {
            // Duplicate, do nothing
            return;
        }

        idPopupLoaderText.popupType = name;
    }

    function closeTextPopup() {
        if("" == idPopupLoaderText.popupType) {
            // Already closed
            return;
        }

        idPopupLoaderText.popupType = "";
    }

    function showToastPopup(name) {
	    toastPopupName = name;
        switch(name) {
            case "popup_bt_phonebook_download_completed":
                idPopupLoaderToast.text = stringInfo.str_Phonebook_Downloaded;
                gPhonebookReloadForDial = true
                break;

            case "popup_Bt_RecentCall_Down_completed":
                idPopupLoaderToast.text = stringInfo.str_CallHistory_Down_Completed;
                break;

            case "popup_Bt_Downloading_Callhistory":
                idPopupLoaderToast.text = stringInfo.str_Callhistory_Downloading;
                break;

            case "popup_bt_recentcall_download_fail":
                idPopupLoaderToast.text = stringInfo.str_CallHistory_Down_Fail_2;
                break;

            case "popup_bt_phonebook_download_fail":
                idPopupLoaderToast.text = stringInfo.str_Phonebook_Down_Fail_1;
                break;

            //DEPRECATED case "popup_Bt_Initialized":
            //DEPRECATED     idPopupLoaderToast.text = stringInfo.str_Suc_Ini
            //DEPRECATED     break;

            default:
                console.log("Invalid toast popup name: " + name);
                break;
        }
    }

    /* [TOAST] Common toast popup 아래 팝업 통함
     * 1) popup_bt_phonebook_download_completed
     * 2) popup_Bt_RecentCall_Down_completed
     * 3) popup_bt_phonebook_download_completed
     * 4) popup_bt_recentcall_download_fail
     * 5) popup_bt_phonebook_download_fail
     //DEPRECATED * 6) popup_Bt_Initialized
     */
    MComp.DDPopupLoader {
        id: idPopupLoaderToast
        popupName: "popup_toast"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupToast.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupToast.qml"

        property string text: ""
    }

    /* 아래의 팝업 통합
     * 01) popup_Bt_Authentication_Fail
     * 02) popup_Bt_Ini
     //DEPRECATED * 03) popup_Bt_Initialized
     * 05) popup_device_name_limit_length
     //* 06) popup_device_name_empty
     * 07) popup_bt_no_downloading_phonebook
     * 08) popup_bt_no_download_phonebook
     * 09) popup_bt_contact_download_fail
     * 10) popup_bt_callhistory_download_fail
     * 11) popup_Bt_Add_Favorite_Duplicate
     * 12) popup_Bt_Call_No_Outgoing                                발신할 전화번호 정보가 없습니다.
     * 13) popup_Bt_Favorite_Max
     * 14) popup_Bt_State_Calling_No_OutCall
     * 15) popup_bt_invalid_during_call
     * 16) popup_Bt_No_Dial_No_Connect_Device
     * 17) popup_Bt_Downloading_Phonebook
     * 18) popup_Bt_No_Phonebook_Phone
     * 19) popup_Bt_No_CallHistory_Phone
     * 20) popup_Bt_No_CallHistory
     * 21) popup_Bt_Call_Fail
     * 22) popup_Bt_Request_Phonebook
     * 23) popup_outgoing_calls_empty                               최근통화목록이 없습니다.
     * 24) popup_bt_contact_callhistory_download_stop_disconnect    연결이 해제되어 다운로드를 중단합니다.
     * 25) popup_bt_not_transfer_call
     * 26) popup_during_bluelink_not_transfer
     * 27) popup_outgoing_calls_empty_download

     */
    MComp.DDPopupLoader {
        id: idPopupLoaderText
        popupName: "popup_text"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupText.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupText.qml"

        property string popupType: ""
        property int buttonCount: 0
        property string bodyText: ""
        property string button1Text: ""
        property string button2Text: ""
        property bool backgroundOpacity: false      // true: 까만색, false: 투명


        function showTextPopup(name) {
            textPopupName = name
            switch(name) {
                case "popup_Bt_Authentication_Fail": {
                    idPopupLoaderText.buttonCount = 2;
                    idPopupLoaderText.backgroundOpacity = true;

                    idPopupLoaderText.bodyText = stringInfo.str_Authentication_Fail;

                    idPopupLoaderText.button1Text = stringInfo.str_Yes;
                    idPopupLoaderText.button2Text = stringInfo.str_Bt_No;
                    break;
                }

                case "popup_bt_no_downloading_phonebook": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Phonebook_Downloading;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_no_download_phonebook": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory_Message;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_contact_download_fail": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Phonebook_Down_Fail_1;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_callhistory_download_fail": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_CallHistory_Down_Fail_1;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Add_Favorite_Duplicate": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Save_Favorite;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Call_No_Outgoing": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Bt_No_Number;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_outgoing_calls_empty": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Favorite_Max": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Max_Favorite;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_State_Calling_No_OutCall": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_During_Call_Nocall;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_invalid_during_call": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_During_Call;
                    idPopupLoaderText.button1Text= stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_No_Dial_No_Connect_Device": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Dial_Fail
                    idPopupLoaderText.button1Text = stringInfo.str_Close
                    break;
                }

                case "popup_Bt_Downloading_Phonebook": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Phonebook_Downloading;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_No_Phonebook_Phone": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Max_Device;
                    idPopupLoaderText.button1Text = stringInfo.str_No_Phonebook_Phone;
                    break;
                }

                case "popup_Bt_No_CallHistory_Phone": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory_Phone;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                case "popup_Bt_No_CallHistory": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_Bt_Call_Fail": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Dial_Fail;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                /*case "popup_Bt_Request_Phonebook": {
                    idPopupLoaderText.buttonCount =  1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Req_Down_Phonebook + ' ' + stringInfo.str_Accept_Phone_Popup;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }*/

                case "popup_bt_contact_callhistory_download_stop_disconnect": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_Bt_Disconnect_Download_Stop
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_outgoing_calls_empty": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_no_phonebook_on_phone": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.no_phonebook_phone;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_bt_not_transfer_call": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.ford_popup_message;
                    idPopupLoaderText.button1Text = stringInfo.str_Close;
                    break;
                }

                case "popup_during_bluelink_not_transfer": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Change_Handfree;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                case "popup_outgoing_calls_empty_download": {
                    idPopupLoaderText.buttonCount = 1;
                    idPopupLoaderText.backgroundOpacity = false;

                    idPopupLoaderText.bodyText = stringInfo.str_No_Callhistory_Recent;
                    idPopupLoaderText.button1Text = stringInfo.str_Ok;
                    break;
                }

                default:
                    console.log("Invalid text popup name: " + name);
                    break;
            }
        }

        Connections {
            target: UIListener

            onRetranslateUi: {
                if("" == idPopupLoaderText.popupType) {
                    return;
                }

                showTextPopup(idPopupLoaderText.popupType);
            }
        }

        onPopupTypeChanged: {
            if("" == idPopupLoaderText.popupType) {
                return;
            }

            showTextPopup(idPopupLoaderText.popupType);
        }
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderA2DPConnectSuccess
        popupName: "connectSuccessA2DPOnlyPopup"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupA2DPConnectSuccess.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupA2DPConnectSuccess.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderA2DPOnlyConnect
        popupName: "popup_Bt_AutoConnect_Device_A2DPOnly"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupA2DPOnlyConnect.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupA2DPOnlyConnect.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderAuthenticationFail
        popupName: "popup_Bt_Connection_Auth_Fail"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAuthenticationFail.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAuthenticationFail.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderAuthenticationFailSSP
        popupName: "popup_Bt_Connection_Auth_Fail_Ssp"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAuthenticationFailSSP.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAuthenticationFailSSP.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderAuthenticationWait
        popupName: "popup_Bt_Authentication_Wait"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAuthenticationWait.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAuthenticationWait.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderAuthenticationWaitBtn
        popupName: "popup_Bt_Authentication_Wait_Btn"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAuthenticationWaitWithButton.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAuthenticationWaitWithButton.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderAutoConnectDevice
        popupName: "popup_Bt_AutoConnect_Device"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAutoConnectDevice.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAutoConnectDevice.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderCallConnectFail
        popupName: "popup_Bt_Call_Connect_Fail"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupCallConnectFail.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupCallConnectFail.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectCanceled
        popupName: "popup_Bt_Connect_Canceled"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnectCanceled.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectCanceled.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectCancelling
        popupName: "popup_Bt_Connect_Cancelling"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnectCancelling.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectCancelling.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnecting
        popupName: "popup_Bt_Connecting"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnecting.qml"
        arabicSourcePath: "../../BT/Common/PopupLoader/BtPopupConnecting.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnecting_15MY
        popupName: "popup_Bt_Connecting_15MY"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnecting_15MY.qml"
        arabicSourcePath: "../../BT/Common/PopupLoader/BtPopupConnecting_15MY.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectionFail
        popupName: "popup_Bt_Connection_Fail"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnectionFail.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectionFail.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectionFail_15MY
        popupName: "popup_Bt_Connection_Fail_15MY"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnectionFail_15MY.qml"
        //[ITS 0270992]
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectionFail.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectSuccess
        popupName: "connectSuccessPopup"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupConnectSuccess.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectSuccess.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectWaitPhone
        popupName: "popup_Bt_Connect_Wait_Phone"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnectWaitPhone.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectWaitPhone.qml"
    }

    MComp.DDPopupLoader {
        id: idDisconnection
        popupName: "popup_Bt_Dis_Connection"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupDisconnect.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnect.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderDisconnectionFail
        popupName: "popup_Bt_Disconnection_Fail"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupDisconnectionFail.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnectionFail.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderInitialized
        popupName: "popup_Bt_Initialized"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupInitialized.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupInitialized.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderNoConnection
        popupName: "popup_Bt_No_Connection"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupNoConnection.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupNoConnection.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderNoDevice
        popupName: "popup_Bt_No_Device"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupNoDevice.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupNoDevice.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderNotSupportBluetoothPhone
        popupName: "popup_Bt_Not_Support_Bluetooth_Phone"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupNotSupportBluetoothPhone.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupNotSupportBluetoothPhone.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderPairedList
        popupName: "popup_paired_list"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupPairedList.qml"
        arabicSourcePath: "../../BT/Common/PopupLoader/BtPopupPairedList.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderPhoneRequestConnectDevice
        popupName: "popup_Bt_Phone_Request_Connect_Device"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupPhoneRequestConnectDevice.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupPhoneRequestConnectDevice.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderContactUpdate
        popupName: "popup_Bt_Contacts_Update"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupContactUpdate.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactUpdate.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderContactUpdateForSearch
        popupName: "popup_Bt_Contacts_Update_Search"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupContactUpdateForSearch.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactUpdateForSearch.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderConnectionFailReConnect
        popupName: "popup_Bt_Connection_Fail_Re_Connect"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupReConnect.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupReConnect.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderRestrictWhileDeiving
        popupName: "popup_restrict_while_driving"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupRestrictWhileDriving.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupRestrictWhileDriving.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderSearchWhileDeiving
        popupName: "popup_search_while_driving"

        sourcePath : "../../BT/Common/PopupLoader/BtPopupSearchWhileDriving.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupSearchWhileDriving.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoaderSSP
        popupName: "popup_Bt_SSP"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSSP.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupSSP.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLoderSSPAdd
        popupName: "popup_Bt_SSP_Add"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSSPAdd.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupSSPAdd.qml"
    }
    
    MComp.DDPopupLoader {
        id: idPopupCall
        popupName: "Call_popup"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupCall.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupCall.qml"
    }

    MComp.DDPopupLoader {
        id: idPopup3WalCall
        popupName: "Call_3way_popup"

        sourcePath: "../../BT/Common/PopupLoader/BtPopup3WayCall.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopup3WayCall.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupBluelinkCall
        popupName: "popup_bluelink_popup"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupBluelinkCall.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupBluelinkCall.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupBluelinkOutgoingCall
        popupName: "popup_bluelink_popup_Outgoing_Call"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupBluelinkOutgoingCall.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupBluelinkOutgoingCall.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDisconnectWhileContactDownloading
        popupName: "popup_Bt_Phonebook_Downloading_Dis_Connect"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDisconnectWhileContactDownloading.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnectWhileContactDownloading.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupRedownload
        popupName: "popup_redownload"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupRedownload.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupRedownload.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupConnectDeviceDelete
        popupName: "popup_bt_conn_paired_device_delete"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupConnectDeviceDelete.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupConnectDeviceDelete.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupPairedDeviceDelete
        popupName: "popup_bt_paired_device_delete"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupPairedDeviceDelete.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupPairedDeviceDelete.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupEmptyDeviceName
        popupName: "popup_device_name_empty"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupEmptyDeviceName.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupEmptyDeviceName.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDeviceDeleteAll1
        popupName: "popup_bt_paired_device_delete_all"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDeviceDeleteAll1.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDeviceDeleteAll1.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDeviceDeleteAll2
        popupName: "popup_bt_conn_paired_device_all"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDeviceDeleteAll2.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDeviceDeleteAll2.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupPairingDevice
        popupName: "popup_Bt_Other_Device_Connect"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupPairingDevice.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupPairingDevice.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupPairingAnotherDevice
        popupName: "popup_Bt_Other_Device_Connect_Menu"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupPairingAnotherDevice.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupPairingAnotherDevice.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDisconnectByPhone
        popupName: "popup_Bt_Disconnect_By_Phone"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDisconnectByPhone.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnectByPhone.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDeleteAll
        popupName: "popup_delete_all"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDeleteAll.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDeleteAll.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDeleteAllRecents
        popupName: "popup_bt_delete_all_history"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDeleteAllRecents.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDeleteAllRecents.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLaunchHelpInDriving
        popupName: "popup_launch_help_in_driving"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupLaunchHelpInDriving.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupLaunchHelpInDriving.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDisconnectSuccess
        popupName: "disconnectSuccessPopup"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDisconnectSuccess.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnectSuccess.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupAddFavorite
        popupName: "popup_Bt_Add_Favorite"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAddFavorite.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAddFavorite.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupPreventDuringCall
        popupName: "popup_enter_setting_during_call"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupPreventDuringCall.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupPreventDuringCall.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDeviceDeleting
        popupName: "popup_Bt_Deleting"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDeviceDeleting.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDeviceDeleting.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDeviceDeleted
        popupName: "popup_Bt_Deleted"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDeviceDeleted.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDeviceDeleted.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupContactUpdateCompleted
        popupName: "popup_Bt_Contact_Update_Completed"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupContactUpdateCompleted.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactUpdateCompleted.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupMaxDevices
        popupName: "popup_Bt_Max_Device"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupMaxDevices.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupMaxDevices.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupMaxDevicesSetting
        popupName: "popup_Bt_Max_Device_Setting"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupMaxDevicesSetting.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupMaxDevicesSetting.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupMaxContacts
        popupName: "popup_Bt_Max_Phonebook"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupMaxContacts.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupMaxContacts.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDisconnectWhileRecentsDownloading
        popupName: "popup_Bt_Callhistory_Downloading_Dis_Connect"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDisconnectWithRecentsDownloading.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnectWithRecentsDownloading.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDisconnectingWithClose
        popupName: "popup_Bt_Dis_Connecting"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDisconnectingWithClose.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnectingWithClose.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDisconnecting
        popupName: "popup_Bt_Dis_Connecting_No_Btn"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDisconnecting.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDisconnecting.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLinkloss
        popupName: "popup_Bt_Linkloss"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupLinkloss.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupLinkloss.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupContactDownloadFailed
        popupName: "popup_Contact_Down_fail"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupContactDownloadFailed.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactDownloadFailed.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupContactDownloadFailedEU
        popupName: "popup_Contact_Down_fail_EU"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupContactDownloadFailedEU.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactDownloadFailedEU.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupRecentCallInfo
        popupName: "popup_recent_info"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupRecentCallInfo.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupRecentCallInfo.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupAddFavoriteFromContact5
        popupName: "popup_favorite_add_contacts"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAddFavoriteFromContact5.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAddFavoriteFromContact5.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupAddFavoriteFromContact3
        popupName: "popup_favorite_add_contacts_add"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAddFavoriteFromContact3.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAddFavoriteFromContact3.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupAddFavoriteFromSearch
        popupName: "popup_phonebook_search"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAddFavoriteFromSearch3.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAddFavoriteFromSearch3.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupFavoriteAddFromSearch
        popupName: "popup_phonebook_search_add"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupAddFavoriteFromSearch5.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupAddFavoriteFromSearch5.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupResetSettings
        popupName: "popup_bt_checkbox_ini"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupResetSettings.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupResetSettings.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupInitializeAfterDisconnecting
        popupName: "popup_Bt_Disconect_Initialize"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupInitializeAfterDisconnecting.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupInitializeAfterDisconnecting.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupPBAPNotSupported
        popupName: "popup_Bt_PBAP_Not_Support"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupPBAPNotSupported.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupPBAPNotSupported.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupRecentCallEmpty
        popupName: "popup_toast_outgoing_calls_empty"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupRecentCallEmpty.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupRecentCallEmpty.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDuringInitialization
        popupName: "popup_Bt_Ini"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDuringInitialization.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDuringInitialization.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupNoOutgoingCallPowerOff
        popupName: "popup_Bt_No_Outgoing_Call_Power_Off"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupNoOutgoingCallPowerOff.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupNoOutgoingCallPowerOff.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupSwitchHandfree
        popupName: "popup_bt_switch_handfree"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSwitchHandfree.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupSwitchHandfree.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupSwitchHandfreeNavi
        popupName: "popup_bt_switch_handfreeNavi"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSwitchHandfreeNavi.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupSwitchHandfreeNavi.qml"
    }

    MComp.DDPopupLoader {
        id: idPopup_Bt_Request_Phonebook
        popupName: "popup_Bt_Request_Phonebook"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupRequestPhoneBook.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupRequestPhoneBook.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupInitialing
        popupName: "popup_Bt_Initialing"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupInitialing.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupInitialing.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupKeypadChange
        popupName: "popup_Keypad_Change"

        sourcePath: "../../BT/Common/PopupLoader/MPopupTypeKeypadType.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/MPopupTypeKeypadType.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupKeypadChangeDeviceName
        popupName: "popup_Keypad_Change_Device_Name"

        sourcePath: "../../BT/Common/PopupLoader/MPopupTypeKeypadTypeNameChanged.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/MPopupTypeKeypadTypeNameChanged.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupDimForCall
        popupName: "popup_Dim_For_Call"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDimCallFail.qml"
        arabicSourcePath: "../../BT/Common/PopupLoader/BtPopupDimCallFail.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupContactChange
        popupName: "popup_Contact_Change"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupContactChange.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactChange.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLanguageChanged
        popupName: "popup_Language_Changed"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupLanguageChanged.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupLanguageChanged.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupPreparing
        popupName: "popup_Bt_Preparing"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupDuringInitialization.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDuringInitialization.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupLimitDeviceName
        popupName: "popup_device_name_limit_length"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupLimitDeviceName.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupDuringInitialization.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupEnterSettingDuringCarPlay
        popupName: "popup_Bt_enter_setting_during_CarPlay"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupEnterSettingDuringCarPlay.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupEnterSettingDuringCarPlay.qml"
    }

/*DEPRECATED
    MComp.DDPopupLoader {
        id: idPopupContactChangeCall
        popupName: "popup_Contact_Change_Call"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupContactChangeCall.qml"
        arabicSourcePath: "../../BT_arabic/Common/PopupLoader/BtPopupContactChangeCall.qml"
    }

    MComp.DDPopupLoader {
        id: idPopupSiriConnect
        popupName: "popup_bt_siri_connect"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSiriConnect.qml"
        arabicSourcePath: ""
    }

    MComp.DDPopupLoader {
        id: idPopupSiriTurnOn
        popupName: "popup_bt_siri_turn_on_device"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSiriTurnOn.qml"
        arabicSourcePath: ""
    }

    MComp.DDPopupLoader {
        id: idPopupSiriSettings
        popupName: "popup_bt_siri_Setting"

        sourcePath: "../../BT/Common/PopupLoader/BtPopupSiriSettings.qml"
        arabicSourcePath: ""
    }
DEPRECATED*/

    function resetFocus() {
        switch(popupState) {
            case "popup_toast":                                 idPopupLoaderToast.forceActiveFocus();                        break;
            case "popup_text":                                  idPopupLoaderText.forceActiveFocus();                         break;
            case "connectSuccessA2DPOnlyPopup":                 idPopupLoaderA2DPConnectSuccess.forceActiveFocus();           break;
            case "popup_Bt_AutoConnect_Device_A2DPOnly":        idPopupLoaderA2DPOnlyConnect.forceActiveFocus();              break;
            case "popup_Bt_Connection_Auth_Fail":               idPopupLoaderAuthenticationFail.forceActiveFocus();           break;
            case "popup_Bt_Connection_Auth_Fail_Ssp":           idPopupLoaderAuthenticationFailSSP.forceActiveFocus();        break;
            case "popup_Bt_Authentication_Wait":                idPopupLoaderAuthenticationWait.forceActiveFocus();           break;
            case "popup_Bt_Authentication_Wait_Btn":            idPopupLoaderAuthenticationWaitBtn.forceActiveFocus();        break;
            case "popup_Bt_AutoConnect_Device":                 idPopupLoaderAutoConnectDevice.forceActiveFocus();            break;
            case "popup_Bt_Connect_Canceled":                   idPopupLoaderConnectCanceled.forceActiveFocus();              break;
            case "popup_Bt_Connect_Cancelling":                 idPopupLoaderConnectCancelling.forceActiveFocus();            break;
            case "popup_Bt_Connecting":                         idPopupLoaderConnecting.forceActiveFocus();                   break;
            case "popup_Bt_Connecting_15MY":                    idPopupLoaderConnecting_15MY.forceActiveFocus();              break;
            case "popup_Bt_Connection_Fail":                    idPopupLoaderConnectionFail.forceActiveFocus();               break;
            case "popup_Bt_Connection_Fail_15MY":               idPopupLoaderConnectionFail_15MY.forceActiveFocus();          break;
            case "connectSuccessPopup":                         idPopupLoaderConnectSuccess.forceActiveFocus();               break;
            case "popup_Bt_Connect_Wait_Phone":                 idPopupLoaderConnectWaitPhone.forceActiveFocus();             break;
            case "popup_Bt_Dis_Connection":                     idDisconnection.forceActiveFocus();                           break;
            case "popup_Bt_Disconnection_Fail":                 idPopupLoaderDisconnectionFail.forceActiveFocus();            break;
            case "popup_Bt_Initialized":                        idPopupLoaderInitialized.forceActiveFocus();                  break;
            case "popup_Bt_No_Connection":                      idPopupLoaderNoConnection.forceActiveFocus();                 break;
            case "popup_Bt_No_Device":                          idPopupLoaderNoDevice.forceActiveFocus();                     break;
            case "popup_Bt_Not_Support_Bluetooth_Phone":        idPopupLoaderNotSupportBluetoothPhone.forceActiveFocus();     break;
            case "popup_paired_list":                           idPopupLoaderPairedList.forceActiveFocus();                   break;
            case "popup_Bt_Phone_Request_Connect_Device":       idPopupLoaderPhoneRequestConnectDevice.forceActiveFocus();    break;
            case "popup_Bt_Contacts_Update":                    idPopupLoaderContactUpdate.forceActiveFocus();                break;
            case "popup_Bt_Contacts_Update_Search":             idPopupLoaderContactUpdateForSearch.forceActiveFocus();       break;
            case "popup_Bt_Connection_Fail_Re_Connect":         idPopupLoaderConnectionFailReConnect.forceActiveFocus();      break;
            case "popup_restrict_while_driving":                idPopupLoaderRestrictWhileDeiving.forceActiveFocus();         break;
            case "popup_search_while_driving":                  idPopupLoaderSearchWhileDeiving.forceActiveFocus();           break;
            case "popup_Bt_SSP":                                idPopupLoaderSSP.forceActiveFocus();                          break;
            case "popup_Bt_SSP_Add":                            idPopupLoderSSPAdd.forceActiveFocus();                        break;
            case "Call_popup":                                  idPopupCall.forceActiveFocus();                               break;
            case "Call_3way_popup":                             idPopup3WalCall.forceActiveFocus();                           break;
            case "popup_bluelink_popup":                        idPopupBluelinkCall.forceActiveFocus();                       break;
            case "popup_bluelink_popup_Outgoing_Call":          idPopupBluelinkOutgoingCall.forceActiveFocus();               break;
            case "popup_Bt_Phonebook_Downloading_Dis_Connect":  idPopupDisconnectWhileContactDownloading.forceActiveFocus();  break;
            case "popup_redownload":                            idPopupRedownload.forceActiveFocus();                         break;
            case "popup_bt_conn_paired_device_delete":          idPopupConnectDeviceDelete.forceActiveFocus();                break;
            case "popup_bt_paired_device_delete":               idPopupPairedDeviceDelete.forceActiveFocus();                 break;
            case "popup_device_name_empty":                     idPopupEmptyDeviceName.forceActiveFocus();                    break;
            case "popup_bt_paired_device_delete_all":           idPopupDeviceDeleteAll1.forceActiveFocus();                   break;
            case "popup_bt_conn_paired_device_all":             idPopupDeviceDeleteAll2.forceActiveFocus();                   break;
            case "popup_Bt_Other_Device_Connect":               idPopupPairingDevice.forceActiveFocus();                      break;
            case "popup_Bt_Other_Device_Connect_Menu":          idPopupPairingAnotherDevice.forceActiveFocus();               break;
            case "popup_Bt_Disconnect_By_Phone":                idPopupDisconnectByPhone.forceActiveFocus();                  break;
            case "popup_delete_all":                            idPopupDeleteAll.forceActiveFocus();                          break;
            case "popup_bt_delete_all_history":                 idPopupDeleteAllRecents.forceActiveFocus();                   break;
            case "popup_launch_help_in_driving":                idPopupLaunchHelpInDriving.forceActiveFocus();                break;
            case "disconnectSuccessPopup":                      idPopupDisconnectSuccess.forceActiveFocus();                  break;
            case "popup_Bt_Add_Favorite":                       idPopupAddFavorite.forceActiveFocus();                        break;
            case "popup_enter_setting_during_call":             idPopupPreventDuringCall.forceActiveFocus();                  break;
            case "popup_Bt_Deleting":                           idPopupDeviceDeleting.forceActiveFocus();                     break;
            case "popup_Bt_Deleted":                            idPopupDeviceDeleted.forceActiveFocus();                      break;
            case "popup_Bt_Contact_Update_Completed":           idPopupContactUpdateCompleted.forceActiveFocus();             break;
            case "popup_Bt_Max_Device":                         idPopupMaxDevices.forceActiveFocus();                         break;
            case "popup_Bt_Max_Phonebook":                      idPopupMaxContacts.forceActiveFocus();                        break;
            case "popup_Bt_Callhistory_Downloading_Dis_Connect":idPopupDisconnectWhileRecentsDownloading.forceActiveFocus();  break;
            case "popup_Bt_Dis_Connecting":                     idPopupDisconnectingWithClose.forceActiveFocus();             break;
            case "popup_Bt_Dis_Connecting_No_Btn":              idPopupDisconnecting.forceActiveFocus();                      break;
            case "popup_Bt_Linkloss":                           idPopupLinkloss.forceActiveFocus();                           break;
            case "popup_Contact_Down_fail":                     idPopupContactDownloadFailed.forceActiveFocus();              break;
            case "popup_Contact_Down_fail_EU":                  idPopupContactDownloadFailedEU.forceActiveFocus();            break;
            case "popup_recent_info":                           idPopupRecentCallInfo.forceActiveFocus();                     break;
            case "popup_favorite_add_contacts":                 idPopupAddFavoriteFromContact5.forceActiveFocus();            break;
            case "popup_favorite_add_contacts_add":             idPopupAddFavoriteFromContact3.forceActiveFocus();            break;
            case "popup_phonebook_search":                      idPopupAddFavoriteFromSearch.forceActiveFocus();              break;
            case "popup_phonebook_search_add":                  idPopupFavoriteAddFromSearch.forceActiveFocus();              break;
            case "popup_bt_checkbox_ini":                       idPopupResetSettings.forceActiveFocus();                      break;
            case "popup_Bt_Disconect_Initialize":               idPopupInitializeAfterDisconnecting.forceActiveFocus();       break;
            case "popup_Bt_PBAP_Not_Support":                   idPopupPBAPNotSupported.forceActiveFocus();                   break;
            case "popup_toast_outgoing_calls_empty":            idPopupRecentCallEmpty.forceActiveFocus();                    break;
            case "popup_Bt_No_Outgoing_Call_Power_Off":         idPopupNoOutgoingCallPowerOff.forceActiveFocus();             break;
            case "popup_bt_switch_handfree":                    idPopupSwitchHandfree.forceActiveFocus();                     break;
            case "popup_bt_switch_handfreeNavi":                idPopupSwitchHandfreeNavi.forceActiveFocus();                 break;
            case "popup_Bt_Max_Device_Setting":                 idPopupMaxDevicesSetting.forceActiveFocus();                  break;
            case "popup_Bt_Request_Phonebook":                  idPopup_Bt_Request_Phonebook.forceActiveFocus();              break;
            case "popup_Bt_Initialing":                         idPopupInitialing.forceActiveFocus();                         break;
            case "popup_Keypad_Change":                         idPopupKeypadChange.forceActiveFocus();                       break;
            case "popup_Bt_Call_Connect_Fail":                  idPopupLoaderCallConnectFail.forceActiveFocus();              break;
            case "popup_Dim_For_Call":                          idPopupDimForCall.forceActiveFocus();                         break;
            case "popup_Contact_Change":                        idPopupContactChange.forceActiveFocus();                      break;
            case "popup_Bt_Ini":                                idPopupDuringInitialization.forceActiveFocus();               break;
            case "popup_Language_Changed":                      idPopupLanguageChanged.forceActiveFocus();                    break;
            case "popup_device_name_limit_length":              idPopupLimitDeviceName.forceActiveFocus();                    break;
            case "popup_Bt_enter_setting_during_CarPlay":       idPopupEnterSettingDuringCarPlay.forceActiveFocus();          break;


            default:
                break;
        }
    }

    function reload() {
        switch(popupState) {
            case "popup_toast":                                 idPopupLoaderToast.reload();                                  break;
            case "popup_text":                                  idPopupLoaderText.reload();                                   break;
            case "connectSuccessA2DPOnlyPopup":                 idPopupLoaderA2DPConnectSuccess.reload();                     break;
            case "popup_Bt_AutoConnect_Device_A2DPOnly":        idPopupLoaderA2DPOnlyConnect.reload();                        break;
            case "popup_Bt_Connection_Auth_Fail":               idPopupLoaderAuthenticationFail.reload();                     break;
            case "popup_Bt_Connection_Auth_Fail_Ssp":           idPopupLoaderAuthenticationFailSSP.reload();                  break;
            case "popup_Bt_Authentication_Wait":                idPopupLoaderAuthenticationWait.reload();                     break;
            case "popup_Bt_Authentication_Wait_Btn":            idPopupLoaderAuthenticationWaitBtn.reload();                  break;
            case "popup_Bt_AutoConnect_Device":                 idPopupLoaderAutoConnectDevice.reload();                      break;
            case "popup_Bt_Connect_Canceled":                   idPopupLoaderConnectCanceled.reload();                        break;
            case "popup_Bt_Connect_Cancelling":                 idPopupLoaderConnectCancelling.reload();                      break;
            case "popup_Bt_Connecting":                         idPopupLoaderConnecting.reload();                             break;
            case "popup_Bt_Connecting_15MY":                    idPopupLoaderConnecting_15MY.forceActiveFocus();              break;
            case "popup_Bt_Connection_Fail":                    idPopupLoaderConnectionFail.reload();                         break;
            case "popup_Bt_Connection_Fail_15MY":               idPopupLoaderConnectionFail_15MY.forceActiveFocus();          break;
            case "connectSuccessPopup":                         idPopupLoaderConnectSuccess.reload();                         break;
            case "popup_Bt_Connect_Wait_Phone":                 idPopupLoaderConnectWaitPhone.reload();                       break;
            case "popup_Bt_Dis_Connection":                     idDisconnection.reload();                                     break;
            case "popup_Bt_Disconnection_Fail":                 idPopupLoaderDisconnectionFail.reload();                      break;
            case "popup_Bt_Initialized":                        idPopupLoaderInitialized.reload();                            break;
            case "popup_Bt_No_Connection":                      idPopupLoaderNoConnection.reload();                           break;
            case "popup_Bt_No_Device":                          idPopupLoaderNoDevice.reload();                               break;
            case "popup_Bt_Not_Support_Bluetooth_Phone":        idPopupLoaderNotSupportBluetoothPhone.reload();               break;
            case "popup_paired_list":                           idPopupLoaderPairedList.reload();                             break;
            case "popup_Bt_Phone_Request_Connect_Device":       idPopupLoaderPhoneRequestConnectDevice.reload();              break;
            case "popup_Bt_Contacts_Update":                    idPopupLoaderContactUpdate.forceActiveFocus();                break;
            case "popup_Bt_Contacts_Update_Search":             idPopupLoaderContactUpdateForSearch.forceActiveFocus();       break;
            case "popup_Bt_Connection_Fail_Re_Connect":         idPopupLoaderConnectionFailReConnect.reload();                break;
            case "popup_restrict_while_driving":                idPopupLoaderRestrictWhileDeiving.reload();                   break;
            case "popup_search_while_driving":                  idPopupLoaderSearchWhileDeiving.forceActiveFocus();           break;
            case "popup_Bt_SSP":                                idPopupLoaderSSP.reload();                                    break;
            case "popup_Bt_SSP_Add":                            idPopupLoderSSPAdd.reload();                                  break;
            case "Call_popup":                                  idPopupCall.reload();                                         break;
            case "Call_3way_popup":                             idPopup3WalCall.reload();                                     break;
            case "popup_bluelink_popup":                        idPopupBluelinkCall.reload();                                 break;
            case "popup_bluelink_popup_Outgoing_Call":          idPopupBluelinkOutgoingCall.reload();                         break;
            case "popup_Bt_Phonebook_Downloading_Dis_Connect":  idPopupDisconnectWhileContactDownloading.reload();            break;
            case "popup_redownload":                            idPopupRedownload.reload();                                   break;
            case "popup_bt_conn_paired_device_delete":          idPopupConnectDeviceDelete.reload();                          break;
            case "popup_bt_paired_device_delete":               idPopupPairedDeviceDelete.reload();                           break;
            case "popup_device_name_empty":                     idPopupEmptyDeviceName.reload();                              break;
            case "popup_bt_paired_device_delete_all":           idPopupDeviceDeleteAll1.reload();                             break;
            case "popup_bt_conn_paired_device_all":             idPopupDeviceDeleteAll2.reload();                             break;
            case "popup_Bt_Other_Device_Connect":               idPopupPairingDevice.reload();                                break;
            case "popup_Bt_Other_Device_Connect_Menu":          idPopupPairingAnotherDevice.reload();                         break;
            case "popup_Bt_Disconnect_By_Phone":                idPopupDisconnectByPhone.reload();                            break;
            case "popup_delete_all":                            idPopupDeleteAll.reload();                                    break;
            case "popup_bt_delete_all_history":                 idPopupDeleteAllRecents.reload();                             break;
            case "popup_launch_help_in_driving":                idPopupLaunchHelpInDriving.reload();                          break;
            case "disconnectSuccessPopup":                      idPopupDisconnectSuccess.reload();                            break;
            case "popup_Bt_Add_Favorite":                       idPopupAddFavorite.reload();                                  break;
            case "popup_enter_setting_during_call":             idPopupPreventDuringCall.reload();                            break;
            case "popup_Bt_Deleting":                           idPopupDeviceDeleting.reload();                               break;
            case "popup_Bt_Deleted":                            idPopupDeviceDeleted.reload();                                break;
            case "popup_Bt_Contact_Update_Completed":           idPopupContactUpdateCompleted.forceActiveFocus();             break;
            case "popup_Bt_Max_Device":                         idPopupMaxDevices.reload();                                   break;
            case "popup_Bt_Max_Phonebook":                      idPopupMaxContacts.reload();                                  break;
            case "popup_Bt_Callhistory_Downloading_Dis_Connect":idPopupDisconnectWhileRecentsDownloading.reload();            break;
            case "popup_Bt_Dis_Connecting":                     idPopupDisconnectingWithClose.reload();                       break;
            case "popup_Bt_Dis_Connecting_No_Btn":              idPopupDisconnecting.reload();                                break;
            case "popup_Bt_Linkloss":                           idPopupLinkloss.reload();                                     break;
            case "popup_Contact_Down_fail":                     idPopupContactDownloadFailed.reload();                        break;
            case "popup_Contact_Down_fail_EU":                  idPopupContactDownloadFailedEU.forceActiveFocus();            break;
            case "popup_recent_info":                           idPopupRecentCallInfo.reload();                               break;
            case "popup_favorite_add_contacts":                 idPopupAddFavoriteFromContact5.reload();                      break;
            case "popup_favorite_add_contacts_add":             idPopupAddFavoriteFromContact3.reload();                      break;
            case "popup_phonebook_search":                      idPopupAddFavoriteFromSearch.reload();                        break;
            case "popup_phonebook_search_add":                  idPopupFavoriteAddFromSearch.reload();                        break;
            case "popup_bt_checkbox_ini":                       idPopupResetSettings.reload();                                break;
            case "popup_Bt_Disconect_Initialize":               idPopupInitializeAfterDisconnecting.reload();                 break;
            case "popup_Bt_PBAP_Not_Support":                   idPopupPBAPNotSupported.reload();                             break;
            case "popup_toast_outgoing_calls_empty":            idPopupRecentCallEmpty.reload();                              break;
            case "popup_Bt_No_Outgoing_Call_Power_Off":         idPopupNoOutgoingCallPowerOff.reload();                       break;
            case "popup_bt_switch_handfree":                    idPopupSwitchHandfree.forceActiveFocus();                     break;
            case "popup_bt_switch_handfreeNavi":                idPopupSwitchHandfreeNavi.forceActiveFocus();                 break;
            case "popup_Bt_Max_Device_Setting":                 idPopupMaxDevicesSetting.forceActiveFocus();                  break;
            case "popup_Bt_Request_Phonebook":                  idPopup_Bt_Request_Phonebook.forceActiveFocus();              break;
            case "popup_Bt_Initialing":                         idPopupInitialing.forceActiveFocus();                         break;
            case "popup_Keypad_Change":                         idPopupKeypadChange.forceActiveFocus();                       break;
            case "popup_Bt_Call_Connect_Fail":                  idPopupLoaderCallConnectFail.forceActiveFocus();              break;
            case "popup_Dim_For_Call":                          idPopupDimForCall.forceActiveFocus();                         break;
            case "popup_Contact_Change":                        idPopupContactChange.forceActiveFocus();                      break;
            case "popup_Language_Changed":                      idPopupLanguageChanged.forceActiveFocus();                    break;
            case "popup_device_name_limit_length":              idPopupLimitDeviceName.forceActiveFocus();                    break;
            case "popup_Bt_enter_setting_during_CarPlay":       idPopupEnterSettingDuringCarPlay.forceActiveFocus();          break;

            default:
                break;
        }
    }
}
/* EOF */
