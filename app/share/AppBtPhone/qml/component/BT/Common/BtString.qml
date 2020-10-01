/**
 * BtString.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/Javascript/operation.js" as MOp


Item
{
    id: idStringInfoContainer

    property string fontFamilyBold: "DH_HDB"
    property string fontFamilyRegular: "DH_HDR"

    property string str_Accept:                             qsTr("STR_BT_ACCEPT")
    property string str_Accept_Phone_Popup:                 qsTr("STR_BT_ACCEPT_PHONE_POPUP")
    property string str_Accept_Phone_Text:                  qsTr("STR_BT_ACCEPT_PHONE_TEXT")
    property string str_Add_Device_To_Phone:                qsTr("STR_BT_ADD_DEVICE_TO_PHONE")
    property string str_Add_Message:                        qsTr("STR_BT_ADD_MESSAGE")
    property string str_Audio_Streming:                     qsTr("STR_BT_AUDIO_STREMING")
    property string str_Authentication_Fail:                qsTr("STR_BT_AUTHENTICATION_FAIL")
    property string str_Authentication_Fail_Message:        qsTr("STR_BT_AUTHENTICATION_FAIL_MESSAGE")
    // 10
    property string str_Authentication_Fail_Web:            qsTr("STR_BT_AUTHENTICATION_FAIL_WEB")
    property string str_Auto_Connection_Device:             qsTr("STR_BT_AUTO_CONNECTION_DEVICE")
    property string str_Auto_Connection_Priority:           qsTr("STR_BT_AUTO_CONNECTION_PRIORITY")
    property string str_Bt_Auto_Download_Setting_Btn:       qsTr("STR_BT_AUTO_DOWNLOAD_SETTING_BTN")
    property string str_Auto_Downloading:                   qsTr("STR_BT_AUTO_DOWNLOADING")
    property string str_Bell_Save:                          qsTr("STR_BT_BELL_SAVE")
    property string str_Bluelink_OutgoingCall:              qsTr("STR_BT_BLUELINK_OUTGOINGCALL")
    property string str_Bluelink_Popup:                     qsTr("STR_BT_BLUELINK_POPUP")
    // 20
    property string str_Bluetooth:                          qsTr("STR_BT_BLUETOOTH")
    property string str_Bluetooth_Connect_Setting:          qsTr("STR_BT_BLUETOOTH_CONNECT_SETTING")
    property string str_Bt_Btn_Call:                        qsTr("STR_BT_BTN_CALL")
    property string str_Btn_Download:                       qsTr("STR_BT_BTN_DOWNLOAD")
    property string str_Btn_Mic_Vol:                        qsTr("STR_BT_BTN_MIC_VOL")
    property string str_Bt_Call_End_Two_Btn:                qsTr("STR_BT_CALL_END_TWO_BTN")
    property string str_Bt_Call_Phonebook:                  qsTr("STR_BT_CALL_PHONEBOOK")
    property string str_Callhistory_Auto_Download:          qsTr("STR_BT_CALLHISTORY_AUTO_DOWNLOAD")
    property string str_Callhistory_Delete_Download:        qsTr("STR_BT_CALLHISTORY_DELETE_DOWNLOAD")
    property string str_CallHistory_Down_Completed:         qsTr("STR_BT_CALLHISTORY_DOWN_COMPLETED")
    // 30
    property string str_CallHistory_Down_Fail_1:            qsTr("STR_BT_CALLHISTORY_DOWN_FAIL_1")
    property string str_CallHistory_Down_Fail_2:            qsTr("STR_BT_CALLHISTORY_DOWN_FAIL_2")
    property string str_Callhistory_Download_Message:       qsTr("STR_BT_CALLHISTORY_DOWNLOAD_MESSAGE")
    property string str_Callhistory_Downloading:            qsTr("STR_BT_CALLHISTORY_DOWNLOADING")
    property string str_Callhistory_Downloading_Dis_Connect:qsTr("STR_BT_CALLHISTORY_DOWNLOADING_DIS_CONNECT")
    property string str_Callhistory_Reqdown:                qsTr("STR_BT_CALLHISTORY_REQDOWN")
    property string str_Bt_Cancel:                          qsTr("STR_BT_CANCEL")
    property string str_Cancel_Ok:                          qsTr("STR_BT_CANCEL_OK")
    property string str_Center:                             qsTr("STR_BT_CENTER")
    property string str_Change:                             qsTr("STR_BT_CHANGE")
    // 40
    property string str_Change_Device:                      qsTr("STR_BT_CHANGE_DEVICE")
    property string str_Change_Device_New:                  qsTr("STR_BT_CHANGE_DEVICE_NEW")
    property string str_Change_Handfree:                    qsTr("STR_BT_CHANGE_HANDFREE")
    property string str_Change_Phone:                       qsTr("STR_BT_CHANGE_PHONE")
    property string str_Close:                              qsTr("STR_BT_CLOSE")
    property string str_Con_Cancel:                         qsTr("STR_BT_CON_CANCEL")
    property string str_Conferencecall:                     qsTr("STR_BT_CONFERENCECALL")
    property string str_Connect_Device_Delete:              qsTr("STR_BT_CONNECT_DEVICE_DELETE")
    property string str_Connect_Fail:                       qsTr("STR_BT_CONNECT_FAIL")
    property string str_Connect_Fail_Re_Connect:            qsTr("STR_BT_CONNECT_FAIL_RE_CONNECT")
    // 50
    property string str_Connecting:                         qsTr("STR_BT_CONNECTING")
    property string str_Connection_Suc:                     qsTr("STR_BT_CONNECTION_SUC")
    property string str_Bt_Customer:                        qsTr("STR_BT_CUSTOMER")
    property string str_Bt_Delete_All:                      qsTr("STR_BT_DELETE_ALL")
    property string str_Delete_All_Device:                  qsTr("STR_BT_DELETE_ALL_DEVICE")
    property string str_Delete_All_Message:                 qsTr("STR_BT_DELETE_ALL_MESSAGE")
    property string str_Delete_All_Ok:                      qsTr("STR_BT_DELETE_ALL_OK")
    property string str_Delete_Band:                        qsTr("STR_BT_DELETE_BAND")
    property string str_Delete_Btn:                         qsTr("STR_BT_DELETE_BTN")
    property string str_Bt_Delete_Cancel:                   qsTr("STR_BT_DELETE_CANCEL")
    // 60
    property string str_Delete_Menu:                        qsTr("STR_BT_DELETE_MENU")
    property string str_Delete_Ok:                          qsTr("STR_BT_DELETE_OK")
    property string str_Deleting:                           qsTr("STR_BT_DELETING")
    property string str_Deselect:                           qsTr("STR_BT_DESELECT")
    property string str_Device_Add:                         qsTr("STR_BT_DEVICE_ADD")
    property string str_Device_Connect_Cancel_Wait:         qsTr("STR_BT_DEVICE_CONNECT_CANCEL_WAIT")
    property string str_Device_Delete:                      qsTr("STR_BT_DEVICE_DELETE")
    property string str_Device_Delete_All:                  qsTr("STR_BT_DEVICE_DELETE_ALL")
    property string str_Device_Disconnect_Wait:             qsTr("STR_BT_DEVICE_DISCONNECT_WAIT")
    // 70
    property string str_Device_Info:                        qsTr("STR_BT_DEVICE_INFO")
    property string str_Device_Name_Band:                   qsTr("STR_BT_DEVICE_NAME_BAND")
    property string str_Device_Name_Bottom:                 qsTr("STR_BT_DEVICE_NAME_BOTTOM")
    property string str_Device_Name_Popup:                  qsTr("STR_BT_DEVICE_NAME_POPUP")
    property string str_Device_Name_Setting:                qsTr("STR_BT_DEVICE_NAME_SETTING")
    property string str_Device_Ssp:                         qsTr("STR_BT_DEVICE_SSP")
    property string str_Device_Ssp_Wait:                    qsTr("STR_BT_DEVICE_SSP_WAIT")
    property string str_Dial_Fail:                          qsTr("STR_BT_DIAL_FAIL")
    property string str_Dialcall:                           qsTr("STR_BT_DIALCALL")
    property string str_Disconnect_Device:                  qsTr("STR_BT_DISCONNECT_DEVICE")
    property string str_Disconnection_Suc:                  qsTr("STR_BT_DISCONNECTION_SUC")
    // 80
    property string str_During_Call:                        qsTr("STR_BT_DURING_CALL")
    property string str_During_Call_Nocall:                 qsTr("STR_BT_DURING_CALL_NOCALL")
    property string str_Empty_Device_Name:                  qsTr("STR_BT_EMPTY_DEVICE_NAME")
    property string str_Favorite_Save:                      qsTr("STR_BT_FAVORITE_SAVE")
    property string str_First_End_Call:                     qsTr("STR_BT_FIRST_END_CALL")

    property string str_First_Hold_Call:                    qsTr("STR_BT_FIRST_HOLD_CALL")
    property string str_Help:                               qsTr("STR_BT_HELP")
    property string str_Help_Phonebook_Down_Fail:           qsTr("STR_BT_HELP_PHONEBOOK_DOWN_FAIL")
    property string str_Help_Phonebook_Down_Message:        qsTr("STR_BT_HELP_PHONEBOOK_DOWN_MESSAGE")
    property string str_Bt_Ini:                             qsTr("STR_BT_INI")
    // 90
    property string str_Ini_Connect_Device:                 qsTr("STR_BT_INI_CONNECT_DEVICE")
    property string str_Inializing:                         qsTr("STR_BT_INITIALIZING")
    property string str_Input_Number:                       qsTr("STR_BT_INPUT_NUMBER")
    property string str_Items:                              qsTr("STR_BT_ITEMS")
    property string str_Keypad:                             qsTr("STR_BT_KEYPAD")

    property string str_Bt_Limite_Char:                     qsTr("STR_BT_LIMITE_CHAR")
    property string str_Linkloss:                           qsTr("STR_BT_LINKLOSS")
    property string str_Mal_Downloading:                    qsTr("STR_BT_MAL_DOWNLOADING")
    property string str_Max_Device:                         qsTr("STR_BT_MAX_DEVICE")
    property string str_Max_Favorite:                       qsTr("STR_BT_MAX_FAVORITE")
    // 100
    property string str_Menu:                               qsTr("STR_BT_MENU")
    property string str_Bt_Menu_Add_Favorite:               qsTr("STR_BT_MENU_ADD_FAVORITE")
    property string str_Con_Menu_Setting:                   qsTr("STR_BT_MENU_CON_SETTING")
    property string str_Bt_Menu_Delete_All:                 qsTr("STR_BT_MENU_DELETE_ALL")
    property string str_Menu_Download:                      qsTr("STR_BT_MENU_DOWNLOAD")

    property string str_Mic_Message:                        qsTr("STR_BT_MIC_MESSAGE")
    property string str_Mic_Off:                            qsTr("STR_BT_MIC_OFF")
    property string str_Missedcall:                         qsTr("STR_BT_MISSEDCALL")
    //DEPRECATED property string str_New_Device_Menu:                    qsTr("STR_BT_NEW_DEVICE_MENU")
    // 110
    property string str_New_Device_Popup:                   qsTr("STR_BT_NEW_DEVICE_POPUP")
    property string str_New_Registration_Btn:               qsTr("STR_BT_NEW_REGISTRATION_BTN")
    property string str_New_Registration_Menu:              qsTr("STR_BT_NEW_REGISTRATION_MENU")
    property string str_Bt_No:                              qsTr("STR_BT_NO")
    property string str_No_Callhistory:                     qsTr("STR_BT_NO_CALLHISTORY")

    property string str_No_Callhistory_Message:             qsTr("STR_BT_NO_CALLHISTORY_MESSAGE")
    property string str_No_Callhistory_Recent:              qsTr("STR_BT_NO_CALLHISTORY_RECENT")
    property string str_Bt_No_Connect_Re_Connect:           qsTr("STR_BT_NO_CONNECT_RE_CONNET")
    property string str_No_Favorite:                        qsTr("STR_BT_NO_FAVORITE")
    // 120
    property string str_Bt_No_Number:                       qsTr("STR_BT_NO_NUMBER")
    property string str_No_Paired_Device:                   qsTr("STR_BT_NO_PAIRED_DEVICE")
    property string str_No_Phonebook:                       qsTr("STR_BT_NO_PHONEBOOK")
    property string str_Nosel_Phone:                        qsTr("STR_BT_NOSEL_PHONE")
    property string str_Nosup_Callhistory:                  qsTr("STR_BT_NOSUP_CALLHISTORY")

    property string str_Bt_Null_Name:                       qsTr("STR_BT_NULL_NAME")
    property string str_Ok:                                 qsTr("STR_BT_OK")
    property string str_Pair_Search_Device:                 qsTr("STR_BT_PAIR_SEARCH_DEVICE")
    property string str_Parking_Device_Add_1:               qsTr("STR_BT_PARKING_DEVICE_ADD_1")
    property string str_Parking_Device_Add_2:               qsTr("STR_BT_PARKING_DEVICE_ADD_2")
    // 130
    property string str_Passkey_Btn:                        qsTr("STR_BT_PASSKEY_BTN")
    property string str_Passkey_Message:                    qsTr("STR_BT_PASSKEY_MESSAGE")
    property string str_Passkey_Popup:                      qsTr("STR_BT_PASSKEY_POPUP")
    property string str_Passkey_Title:                      qsTr("STR_BT_PASSKEY_TITLE")
    property string str_Phonebook_Auto_Download:            qsTr("STR_BT_PHONEBOOK_AUTO_DOWNLOAD")

    property string str_Phonebook_Auto_Download_Message:    qsTr("STR_BT_PHONEBOOK_AUTO_DOWNLOAD_MESSAGE")
    property string str_Phonebook_Down_Fail_1:              qsTr("STR_BT_PHONEBOOK_DOWN_FAIL_1")
    property string str_Phonebook_Download_Message:         qsTr("STR_BT_PHONEBOOK_DOWNLOAD_MESSAGE")
    property string str_Phonebook_Downloaded:               qsTr("STR_BT_PHONEBOOK_DOWNLOADED")
    property string str_Phonebook_Downloading:              qsTr("STR_BT_PHONEBOOK_DOWNLOADING")
    // 140
    property string str_Phonebook_Downloading_Dis_Connect:  qsTr("STR_BT_PHONEBOOK_DOWNLOADING_DIS_CONNECT")
    property string str_Phonebook_Full:                     qsTr("STR_BT_PHONEBOOK_FULL")
    property string str_Phonebook_Reqdown:                  qsTr("STR_BT_PHONEBOOK_REQDOWN")
    property string str_Bt_Pincode_Delete_All:              qsTr("STR_BT_PINCODE_DELETE_ALL")
    property string str_Bt_Popup_Add_Favorite:              qsTr("STR_BT_POPUP_ADD_FAVORITE")

    property string str_Con_Popup_Setting:                  qsTr("STR_BT_POPUP_CON_SETTING")
    property string str_Power_On_Connection:                qsTr("STR_BT_POWER_ON_CONNECTION")
    property string str_pravite_message_1:                  qsTr("STR_BT_PRAVITE_MESSAGE_1")
    // 150
    property string str_Receivecall:                        qsTr("STR_BT_RECEVICECALL")
    property string str_Reject:                             qsTr("STR_BT_REJECT")
    property string str_Req_Down_Phonebook:                 qsTr("STR_BT_REQ_DOWN_PHONEBOOK")
    property string str_Save_Favorite:                      qsTr("STR_BT_SAVE_FAVORITE")

    property string str_Search_Phonebook_Menu:              qsTr("STR_BT_SEARCH_PHONEBOOK_MENU")
    property string str_Search_Phonebook_Text:              qsTr("STR_BT_SEARCH_PHONEBOOK_TEXT")
    property string str_Bt_Second:                          qsTr("STR_BT_SECOND")
    property string str_Bt_Siri_Cancel:                     qsTr("STR_BT_SIRI_CANCEL")
    // 160
    property string str_Siri_Use_Message:                   qsTr("STR_BT_SIRI_USE_MESSAGE")
    property string str_Spam:                               qsTr("STR_BT_SPAM")
    property string str_Speak:                              qsTr("STR_BT_SPEAK")
    property string str_Ssp_Auto_Accept:                    qsTr("STR_BT_SSP_AUTO_ACCRPT")
    property string str_Suc_Ini:                            qsTr("STR_BT_SUC_INI")
    property string str_Wait:                               qsTr("STR_BT_WAIT")
    property string str_Wait_Device_Connection:             qsTr("STR_BT_WAIT_DEVICE_CONNECTION")
    property string str_Yes:                                qsTr("STR_BT_YES")
    property string str_Nosup_Phonebook:                    qsTr("STR_NOSUP_PHONEBOOK")
    // 170
    property string launch_help_in_driving:                 qsTr("STR_BT_LAUNCH_HELP_IN_DRIVING")
    property string not_supported_favorite:                 qsTr("STR_BT_NOT_SUPPORTED_FAVORITE")
    property string disconnect_fail:                        qsTr("STR_BT_DISCONNECT_FAIL")
    property string str_Bt_Not_Sup_HFP:                     qsTr("STR_BT_NOT_SUP_HFP")
    property string str_Bt_Disconnect_Download_Stop:        qsTr("STR_BT_DISCONNECT_DOWNLOAD_STOP")
    property string str_Bt_No_List:                         qsTr("STR_BT_NO_LIST")
    property string str_Recent_Incoming:                    qsTr("STR_BT_RECENT_INCOMING")
    property string str_Recent_Outgoing:                    qsTr("STR_BT_RECENT_OUTGOING")
    property string str_Recent_Missed:                      qsTr("STR_BT_RECENT_MISSED")
    // 180
    property string warning:                                qsTr("STR_BT_WARNING")
    property string no_phonebook_phone:                     qsTr("STR_BT_NO_PHONEBOOK_PHONE")
    property string ford_popup_message:                     qsTr("STR_BT_FORD_POPUP_MESSAGE")
    property string view_phonebook:                         qsTr("STR_BT_VIEW_PHONEBOOK")
    property string str_Bt_Setting_Ini:                     qsTr("STR_BT_SETTING_INI")
    property string str_Customer_USA:                       qsTr("STR_BT_CUSTOMER_USA")
    property string str_Bt_RecentCall_Delete_All:           qsTr("STR_BT_RECENTCALL_DELETE_ALL")
    property string str_Swith_Handfree:                     qsTr("STR_BT_SWITCH_HANDFREE")
    property string str_Mic_On:                             qsTr("STR_BT_MIC_ON")
    //190
    property string str_End:                                qsTr("STR_BT_END")
    property string str_Device_Delete_All_Select_2:         qsTr("STR_BT_DEVICE_DELETE_ALL_SELECT_2")
    property string str_Connect_Device_Delete_Select_2:     qsTr("STR_BT_CONNECT_DEVICE_DELETE_SELECT_2")
    property string str_Cancel_Delete:                      qsTr("STR_BT_CANCEL_DELETE")
    property string sSTR_BT_SWITCH_HANDFREE_NAVI:           qsTr("STR_BT_SWITCH_HANDFREE_NAVI")
    property string str_No_Change_Handfree:                 qsTr("STR_BT_NO_CHANGE_HANFREE")
    property string str_Help_Phonebook_Down_Message_EU:     qsTr("STR_BT_HELP_PHONEBOOK_DOWN_MESSAGE_EU")
    property string str_Call_Title:                         qsTr("STR_BT_CALL_TITLE")
    property string str_Wait_Device_Connection_15MY:        qsTr("STR_BT_WAIT_DEVICE_CONNECTION_15MY")
    //200
    property string str_Keypad_Pinyin:                      qsTr("STR_KEYPAD_CHINESE_PINYIN")
    property string str_Keypad_Sound:                       qsTr("STR_SETTING_GENERAL_KEYPAD_CHINESE_VOCAL_SOUND")
    property string str_Keypad_Hand:                        qsTr("STR_KEYPAD_CHINESE_HAND_WRITING")
    property string str_Dial_Delete:                        qsTr("STR_DIAL_DELETE")
    property string str_Device_Ssp_Wait_2Line:              qsTr("STR_BT_DEVICE_SSP_WAIT_2LINE")
    property string str_Bt_Connect_Error_For_US:            (1 == UIListener.invokeGetVehicleVariant())? qsTr("STR_BT_CONNECT_ERROR_FOR_US") : qsTr("STR_BT_CONNECT_ERROR_FOR_US").arg(url_DH)
    property string str_Bt_Connect_Error_For_KR:            qsTr("STR_BT_CONNECT_ERROR_FOR_KR").arg(url_KH)
    property string str_Bt_Connect_Error_For_COMMON:        qsTr("STR_BT_CONNECT_ERROR_FOR_COMMON")
    property string str_Bt_Toast_Popup_Call_Fail:           qsTr("STR_BT_TOAST_POPUP_CALL_FAIL")
    //210
    property string str_Bt_All:                             qsTr("STR_BT_ALL")
    property string str_Bt_Updating:                        qsTr("STR_BT_UPDATING")
    property string str_Bt_Contact_Update_Call:             qsTr("STR_BT_CONTACT_UPDATE_CALL")
    property string str_Bt_Contact_Update:                  qsTr("STR_BT_CONTACT_UPDATE")
    property string str_Bt_Download_Progress:               qsTr("STR_BT_DOWNLOAD_PROGRESS")
    property string str_Bt_Name_Device_Wait:                qsTr("STR_BT_DEVICE_NAME_WAIT")
    property string str_Settings_Change_Language:           qsTr("STR_SETTINGS_CHANGE_LANGUAGE")
    property string str_Help_Phonebook_Down_Fail_CA:        qsTr("STR_BT_HELP_PHONEBOOK_DOWN_FAIL_CA")
    //220
    property string str_Help_Phonebook_Down_Message_CA:     qsTr("STR_BT_HELP_PHONEBOOK_DOWN_MESSAGE_CA")
    property string str_Authentication_Fail_Web_CA:         qsTr("STR_BT_AUTHENTICATION_FAIL_WEB_CA");
    property string str_Authentication_Fail_Message_CA:     qsTr("STR_BT_AUTHENTICATION_FAIL_MESSAGE_CA")
    property string str_Bt_Connect_Error_For_CA:            qsTr("STR_BT_CONNECT_ERROR_FOR_CA")
    property string str_Vehicle_Name_Popup:                 qsTr("STR_BT_VEHICLE_NAME_POPUP")

    /* CenterCall string
      */
    property string str_CenterCall_OutgoingCall:            qsTr("STR_BT_CENTERCALL_OUTGOINGCALL")
    property string str_CenterCall_Popup:                   qsTr("STR_BT_CENTERCALL_POPUP")

    /* VehicleVariants
      */
    property string str_UVO_OutgoingCall:                   qsTr("STR_BT_UVO_OUTGOINGCALL")
    property string str_UVO_Popup:                          qsTr("STR_BT_UVO_POPUP")

    /* Fixed string
     */
    property string url_DH:                                 (0 == UIListener.invokeGetCountryVariant())? "BLU.hyundai.com" : "www.hyundaiusa.com/bluetooth";
    property string url_KH:                                 (0 == UIListener.invokeGetCountryVariant())? "q.kia.com" : "Kiaeurope.nextgen-technology.net";
    property string url_KOREA:                              (1 == UIListener.invokeGetVehicleVariant())? "q.kia.com" : "BLU.hyundai.com";
    property string url_USA:                                (1 == UIListener.invokeGetVehicleVariant())? "855-4KIA-VIP" : "www.hyundaiusa.com/bluetooth";
    property string url_USA_short:                          (1 == UIListener.invokeGetVehicleVariant())? "855-4KIA-VIP" : "www.hyundaiusa.com /bluetooth";

    /* CarPlay */
    property string str_enter_setting_during_CarPlay:        qsTr("STR_BT_ENTER_SETTING_DURING_CARPLAY")

    //2015.10.30 [ITS 0269835,0269836] Android Auto Handling (UX Scenario Changed)
    /* AADefend */
    property string str_AADefend_Popup_Text:                   qsTr("STR_BT_AA_DEFEND_TEXT")

    /*
    property string url_KOREA_HMC:                          "http://blu.hyundai.com";
    property string url_KOREA_KMC:                          "http://q.kia.com ";
    property string url_USA_HMC:                            "https://www.hyundaiusa.com/bluetooth";
    property string url_USA_KMC:                            "http://www.kia.com/us/Bluetooth";
    property string url_USA_short_HMC:                      "https://www.hyundaiusa.com /bluetooth";
    property string url_USA_short_KMC:                      "http://www.kia.com/us/Bluetooth";
    property string url_EU_short_KMC:                       "http://kiaeurope.nextgen-technology.net";
    */

    function retranslateUi(languageId) {
        str_Accept =                                qsTr("STR_BT_ACCEPT");
        str_Accept_Phone_Popup =                    qsTr("STR_BT_ACCEPT_PHONE_POPUP");
        str_Accept_Phone_Text =                     qsTr("STR_BT_ACCEPT_PHONE_TEXT");
        str_Add_Device_To_Phone  =                  qsTr("STR_BT_ADD_DEVICE_TO_PHONE");
        str_Add_Message =                           qsTr("STR_BT_ADD_MESSAGE");
        str_Audio_Streming =                        qsTr("STR_BT_AUDIO_STREMING");
        str_Authentication_Fail =                   qsTr("STR_BT_AUTHENTICATION_FAIL");
        str_Authentication_Fail_Message =           qsTr("STR_BT_AUTHENTICATION_FAIL_MESSAGE");
        // 10
        str_Authentication_Fail_Web =               qsTr("STR_BT_AUTHENTICATION_FAIL_WEB");
        str_Auto_Connection_Device =                qsTr("STR_BT_AUTO_CONNECTION_DEVICE");
        str_Auto_Connection_Priority =              qsTr("STR_BT_AUTO_CONNECTION_PRIORITY");
        str_Bt_Auto_Download_Setting_Btn =          qsTr("STR_BT_AUTO_DOWNLOAD_SETTING_BTN");
        str_Auto_Downloading =                      qsTr("STR_BT_AUTO_DOWNLOADING");
        str_Bell_Save =                             qsTr("STR_BT_BELL_SAVE");
        str_Bluelink_OutgoingCall =                 qsTr("STR_BT_BLUELINK_OUTGOINGCALL");
        str_Bluelink_Popup =                        qsTr("STR_BT_BLUELINK_POPUP");
        // 20
        str_Bluetooth =                             qsTr("STR_BT_BLUETOOTH");
        str_Bluetooth_Connect_Setting =             qsTr("STR_BT_BLUETOOTH_CONNECT_SETTING");
        str_Bt_Btn_Call =                           qsTr("STR_BT_BTN_CALL");
        str_Btn_Download =                          qsTr("STR_BT_BTN_DOWNLOAD");
        str_Btn_Mic_Vol =                           qsTr("STR_BT_BTN_MIC_VOL");
        str_Bt_Call_End_Two_Btn =                   qsTr("STR_BT_CALL_END_TWO_BTN");
        str_Bt_Call_Phonebook =                     qsTr("STR_BT_CALL_PHONEBOOK");
        str_Callhistory_Auto_Download =             qsTr("STR_BT_CALLHISTORY_AUTO_DOWNLOAD");
        str_Callhistory_Delete_Download =           qsTr("STR_BT_CALLHISTORY_DELETE_DOWNLOAD");
        str_CallHistory_Down_Completed =            qsTr("STR_BT_CALLHISTORY_DOWN_COMPLETED");
        // 30
        str_CallHistory_Down_Fail_1 =               qsTr("STR_BT_CALLHISTORY_DOWN_FAIL_1");
        str_CallHistory_Down_Fail_2 =               qsTr("STR_BT_CALLHISTORY_DOWN_FAIL_2");
        str_Callhistory_Download_Message =          qsTr("STR_BT_CALLHISTORY_DOWNLOAD_MESSAGE");
        str_Callhistory_Downloading =               qsTr("STR_BT_CALLHISTORY_DOWNLOADING");
        str_Callhistory_Downloading_Dis_Connect =   qsTr("STR_BT_CALLHISTORY_DOWNLOADING_DIS_CONNECT");
        str_Callhistory_Reqdown =                   qsTr("STR_BT_CALLHISTORY_REQDOWN");
        str_Bt_Cancel =                             qsTr("STR_BT_CANCEL");
        str_Cancel_Ok =                             qsTr("STR_BT_CANCEL_OK");
        str_Center =                                qsTr("STR_BT_CENTER");
        str_Change =                                qsTr("STR_BT_CHANGE");
        // 40
        str_Change_Device =                         qsTr("STR_BT_CHANGE_DEVICE");
        str_Change_Device_New =                     qsTr("STR_BT_CHANGE_DEVICE_NEW");
        str_Change_Handfree =                       qsTr("STR_BT_CHANGE_HANDFREE");
        str_Change_Phone =                          qsTr("STR_BT_CHANGE_PHONE");
        str_Close =                                 qsTr("STR_BT_CLOSE");
        str_Con_Cancel =                            qsTr("STR_BT_CON_CANCEL");
        str_Conferencecall =                        qsTr("STR_BT_CONFERENCECALL");
        str_Connect_Device_Delete =                 qsTr("STR_BT_CONNECT_DEVICE_DELETE");
        str_Connect_Fail =                          qsTr("STR_BT_CONNECT_FAIL");
        str_Connect_Fail_Re_Connect =               qsTr("STR_BT_CONNECT_FAIL_RE_CONNECT");
        // 50
        str_Connecting =                            qsTr("STR_BT_CONNECTING");
        str_Connection_Suc =                        qsTr("STR_BT_CONNECTION_SUC");
        str_Bt_Customer =                           qsTr("STR_BT_CUSTOMER");
        str_Bt_Delete_All =                         qsTr("STR_BT_DELETE_ALL");
        str_Delete_All_Device =                     qsTr("STR_BT_DELETE_ALL_DEVICE");
        str_Delete_All_Message =                    qsTr("STR_BT_DELETE_ALL_MESSAGE");
        str_Delete_All_Ok =                         qsTr("STR_BT_DELETE_ALL_OK");
        str_Delete_Band =                           qsTr("STR_BT_DELETE_BAND");
        str_Delete_Btn =                            qsTr("STR_BT_DELETE_BTN");
        str_Bt_Delete_Cancel =                      qsTr("STR_BT_DELETE_CANCEL");
        // 60
        str_Delete_Menu  =                          qsTr("STR_BT_DELETE_MENU")
        str_Delete_Ok  =                            qsTr("STR_BT_DELETE_OK")
        str_Deleting  =                             qsTr("STR_BT_DELETING")
        str_Deselect  =                             qsTr("STR_BT_DESELECT")
        str_Device_Add  =                           qsTr("STR_BT_DEVICE_ADD")
        str_Device_Connect_Cancel_Wait  =           qsTr("STR_BT_DEVICE_CONNECT_CANCEL_WAIT")
        str_Device_Delete  =                        qsTr("STR_BT_DEVICE_DELETE")
        str_Device_Delete_All  =                    qsTr("STR_BT_DEVICE_DELETE_ALL")
        str_Device_Disconnect_Wait  =               qsTr("STR_BT_DEVICE_DISCONNECT_WAIT")
        // 70
        str_Device_Info  =                          qsTr("STR_BT_DEVICE_INFO");
        str_Device_Name_Band  =                     qsTr("STR_BT_DEVICE_NAME_BAND");
        str_Device_Name_Bottom  =                   qsTr("STR_BT_DEVICE_NAME_BOTTOM");
        str_Device_Name_Popup  =                    qsTr("STR_BT_DEVICE_NAME_POPUP");
        str_Device_Name_Setting  =                  qsTr("STR_BT_DEVICE_NAME_SETTING");
        str_Device_Ssp  =                           qsTr("STR_BT_DEVICE_SSP");
        str_Device_Ssp_Wait =                       qsTr("STR_BT_DEVICE_SSP_WAIT");
        str_Dial_Fail  =                            qsTr("STR_BT_DIAL_FAIL");
        str_Dialcall  =                             qsTr("STR_BT_DIALCALL");
        str_Disconnect_Device  =                    qsTr("STR_BT_DISCONNECT_DEVICE");
        str_Disconnection_Suc  =                    qsTr("STR_BT_DISCONNECTION_SUC");
        // 80
        str_During_Call =                           qsTr("STR_BT_DURING_CALL");
        str_During_Call_Nocall =                    qsTr("STR_BT_DURING_CALL_NOCALL");
        str_Empty_Device_Name =                     qsTr("STR_BT_EMPTY_DEVICE_NAME");
        str_Favorite_Save =                         qsTr("STR_BT_FAVORITE_SAVE");
        str_First_End_Call =                        qsTr("STR_BT_FIRST_END_CALL");
        str_First_Hold_Call =                       qsTr("STR_BT_FIRST_HOLD_CALL");
        str_Help =                                  qsTr("STR_BT_HELP");
        str_Help_Phonebook_Down_Fail =              qsTr("STR_BT_HELP_PHONEBOOK_DOWN_FAIL");
        str_Help_Phonebook_Down_Message =           qsTr("STR_BT_HELP_PHONEBOOK_DOWN_MESSAGE");
        str_Bt_Ini =                                qsTr("STR_BT_INI");
        // 90
        str_Ini_Connect_Device =                    qsTr("STR_BT_INI_CONNECT_DEVICE");
        str_Inializing =                            qsTr("STR_BT_INITIALIZING");
        str_Input_Number =                          qsTr("STR_BT_INPUT_NUMBER");
        str_Items =                                 qsTr("STR_BT_ITEMS");
        str_Keypad =                                qsTr("STR_BT_KEYPAD");
        str_Bt_Limite_Char =                        qsTr("STR_BT_LIMITE_CHAR");
        str_Linkloss =                              qsTr("STR_BT_LINKLOSS");
        str_Mal_Downloading =                       qsTr("STR_BT_MAL_DOWNLOADING");
        str_Max_Device =                            qsTr("STR_BT_MAX_DEVICE");
        str_Max_Favorite =                          qsTr("STR_BT_MAX_FAVORITE");
        // 100
        str_Menu =                                  qsTr("STR_BT_MENU");
        str_Bt_Menu_Add_Favorite =                  qsTr("STR_BT_MENU_ADD_FAVORITE");
        str_Con_Menu_Setting =                      qsTr("STR_BT_MENU_CON_SETTING");
        str_Bt_Menu_Delete_All =                    qsTr("STR_BT_MENU_DELETE_ALL");
        str_Menu_Download =                         qsTr("STR_BT_MENU_DOWNLOAD");
        str_Mic_Message =                           qsTr("STR_BT_MIC_MESSAGE");
        str_Mic_Off =                               qsTr("STR_BT_MIC_OFF");
        str_Missedcall =                            qsTr("STR_BT_MISSEDCALL");
        //DEPRECATED str_New_Device_Menu =                       qsTr("STR_BT_NEW_DEVICE_MENU");
        // 110
        str_New_Device_Popup =                      qsTr("STR_BT_NEW_DEVICE_POPUP");
        str_New_Registration_Btn =                  qsTr("STR_BT_NEW_REGISTRATION_BTN");
        str_New_Registration_Menu =                 qsTr("STR_BT_NEW_REGISTRATION_MENU");
        str_Bt_No =                                 qsTr("STR_BT_NO");
        str_No_Callhistory =                        qsTr("STR_BT_NO_CALLHISTORY");
        str_No_Callhistory_Message =                qsTr("STR_BT_NO_CALLHISTORY_MESSAGE");
        str_No_Callhistory_Recent =                 qsTr("STR_BT_NO_CALLHISTORY_RECENT");
        str_Bt_No_Connect_Re_Connect =              qsTr("STR_BT_NO_CONNECT_RE_CONNET");
        str_No_Favorite =                           qsTr("STR_BT_NO_FAVORITE");
        // 120
        str_Bt_No_Number =                          qsTr("STR_BT_NO_NUMBER");
        str_No_Paired_Device =                      qsTr("STR_BT_NO_PAIRED_DEVICE");
        str_No_Phonebook =                          qsTr("STR_BT_NO_PHONEBOOK");
        str_Nosel_Phone =                           qsTr("STR_BT_NOSEL_PHONE");
        str_Nosup_Callhistory =                     qsTr("STR_BT_NOSUP_CALLHISTORY");
        str_Bt_Null_Name  =                         qsTr("STR_BT_NULL_NAME");
        str_Ok =                                    qsTr("STR_BT_OK");
        str_Pair_Search_Device =                    qsTr("STR_BT_PAIR_SEARCH_DEVICE");
        str_Parking_Device_Add_1 =                  qsTr("STR_BT_PARKING_DEVICE_ADD_1");
        str_Parking_Device_Add_2 =                  qsTr("STR_BT_PARKING_DEVICE_ADD_2");
        // 130
        str_Passkey_Btn =                           qsTr("STR_BT_PASSKEY_BTN");
        str_Passkey_Message =                       qsTr("STR_BT_PASSKEY_MESSAGE");
        str_Passkey_Popup =                         qsTr("STR_BT_PASSKEY_POPUP");
        str_Passkey_Title =                         qsTr("STR_BT_PASSKEY_TITLE");
        str_Phonebook_Auto_Download =               qsTr("STR_BT_PHONEBOOK_AUTO_DOWNLOAD")
        str_Phonebook_Auto_Download_Message =       qsTr("STR_BT_PHONEBOOK_AUTO_DOWNLOAD_MESSAGE");
        str_Phonebook_Down_Fail_1 =                 qsTr("STR_BT_PHONEBOOK_DOWN_FAIL_1");
        str_Phonebook_Download_Message =            qsTr("STR_BT_PHONEBOOK_DOWNLOAD_MESSAGE");
        str_Phonebook_Downloaded =                  qsTr("STR_BT_PHONEBOOK_DOWNLOADED");
        str_Phonebook_Downloading =                 qsTr("STR_BT_PHONEBOOK_DOWNLOADING");
        // 140
        str_Phonebook_Downloading_Dis_Connect =     qsTr("STR_BT_PHONEBOOK_DOWNLOADING_DIS_CONNECT");
        str_Phonebook_Full =                        qsTr("STR_BT_PHONEBOOK_FULL");
        str_Phonebook_Reqdown =                     qsTr("STR_BT_PHONEBOOK_REQDOWN");
        str_Bt_Pincode_Delete_All =                 qsTr("STR_BT_PINCODE_DELETE_ALL");
        str_Bt_Popup_Add_Favorite =                 qsTr("STR_BT_POPUP_ADD_FAVORITE");
        str_Con_Popup_Setting =                     qsTr("STR_BT_POPUP_CON_SETTING");
        str_Power_On_Connection =                   qsTr("STR_BT_POWER_ON_CONNECTION");
        str_pravite_message_1 =                     qsTr("STR_BT_PRAVITE_MESSAGE_1");
        // 150
        str_Receivecall =                           qsTr("STR_BT_RECEVICECALL");
        str_Reject =                                qsTr("STR_BT_REJECT");
        str_Req_Down_Phonebook =                    qsTr("STR_BT_REQ_DOWN_PHONEBOOK");
        str_Save_Favorite =                         qsTr("STR_BT_SAVE_FAVORITE");
        str_Search_Phonebook_Menu =                 qsTr("STR_BT_SEARCH_PHONEBOOK_MENU");
        str_Search_Phonebook_Text =                 qsTr("STR_BT_SEARCH_PHONEBOOK_TEXT");
        str_Bt_Second =                             qsTr("STR_BT_SECOND");
        str_Bt_Siri_Cancel =                        qsTr("STR_BT_SIRI_CANCEL");
        // 160
        str_Siri_Use_Message =                      qsTr("STR_BT_SIRI_USE_MESSAGE");
        str_Spam =                                  qsTr("STR_BT_SPAM");
        str_Speak =                                 qsTr("STR_BT_SPEAK");
        str_Ssp_Auto_Accept =                       qsTr("STR_BT_SSP_AUTO_ACCRPT");
        str_Suc_Ini =                               qsTr("STR_BT_SUC_INI");
        str_Wait =                                  qsTr("STR_BT_WAIT");
        str_Wait_Device_Connection =                qsTr("STR_BT_WAIT_DEVICE_CONNECTION");
        str_Yes =                                   qsTr("STR_BT_YES");
        str_Nosup_Phonebook =                       qsTr("STR_NOSUP_PHONEBOOK");
        // 170
        launch_help_in_driving =                    qsTr("STR_BT_LAUNCH_HELP_IN_DRIVING");
        not_supported_favorite =                    qsTr("STR_BT_NOT_SUPPORTED_FAVORITE");
        disconnect_fail =                           qsTr("STR_BT_DISCONNECT_FAIL");
        str_Bt_Not_Sup_HFP =                        qsTr("STR_BT_NOT_SUP_HFP");
        str_Bt_Disconnect_Download_Stop =           qsTr("STR_BT_DISCONNECT_DOWNLOAD_STOP");
        str_Bt_No_List =                            qsTr("STR_BT_NO_LIST");
        str_Recent_Incoming =                       qsTr("STR_BT_RECENT_INCOMING");
        str_Recent_Outgoing =                       qsTr("STR_BT_RECENT_OUTGOING");
        str_Recent_Missed =                         qsTr("STR_BT_RECENT_MISSED");
        // 180
        warning =                                   qsTr("STR_BT_WARNING");
        no_phonebook_phone =                        qsTr("STR_BT_NO_PHONEBOOK_PHONE")
        ford_popup_message =                        qsTr("STR_BT_FORD_POPUP_MESSAGE")
        view_phonebook =                            qsTr("STR_BT_VIEW_PHONEBOOK")
        str_Bt_Setting_Ini =                        qsTr("STR_BT_SETTING_INI")
        str_Customer_USA =                          qsTr("STR_BT_CUSTOMER_USA")
        str_Bt_RecentCall_Delete_All =              qsTr("STR_BT_RECENTCALL_DELETE_ALL")
        str_Swith_Handfree =                        qsTr("STR_BT_SWITCH_HANDFREE")
        str_Mic_On =                                qsTr("STR_BT_MIC_ON")
        //190
        str_End =                                   qsTr("STR_BT_END")
        str_Device_Delete_All_Select_2 =            qsTr("STR_BT_DEVICE_DELETE_ALL_SELECT_2")
        str_Connect_Device_Delete_Select_2 =        qsTr("STR_BT_CONNECT_DEVICE_DELETE_SELECT_2")
        str_Cancel_Delete =                         qsTr("STR_BT_CANCEL_DELETE")
        sSTR_BT_SWITCH_HANDFREE_NAVI=               qsTr("STR_BT_SWITCH_HANDFREE_NAVI")
        str_No_Change_Handfree =                    qsTr("STR_BT_NO_CHANGE_HANFREE")
        str_Help_Phonebook_Down_Message_EU =        qsTr("STR_BT_HELP_PHONEBOOK_DOWN_MESSAGE_EU")
        str_Call_Title =                            qsTr("STR_BT_CALL_TITLE")
        str_Wait_Device_Connection_15MY =           qsTr("STR_BT_WAIT_DEVICE_CONNECTION_15MY")
        //200
        str_Keypad_Pinyin =                         qsTr("STR_KEYPAD_CHINESE_PINYIN")
        str_Keypad_Sound =                          qsTr("STR_SETTING_GENERAL_KEYPAD_CHINESE_VOCAL_SOUND")
        str_Keypad_Hand =                           qsTr("STR_KEYPAD_CHINESE_HAND_WRITING")
        str_Bt_Toast_Popup_Call_Fail =              qsTr("STR_BT_TOAST_POPUP_CALL_FAIL")
        str_Dial_Delete =                           qsTr("STR_DIAL_DELETE")
        str_Device_Ssp_Wait_2Line =                 qsTr("STR_BT_DEVICE_SSP_WAIT_2LINE")
        str_Bt_All =                                qsTr("STR_BT_ALL")
        str_Bt_Updating =                           qsTr("STR_BT_UPDATING")
        str_Bt_Contact_Update_Call =                qsTr("STR_BT_CONTACT_UPDATE_CALL")
        //210

        str_Bt_Name_Device_Wait =                   qsTr("STR_BT_DEVICE_NAME_WAIT")
        str_Bt_Contact_Update =                     qsTr("STR_BT_CONTACT_UPDATE")
        str_Bt_Download_Progress =                  qsTr("STR_BT_DOWNLOAD_PROGRESS")
        str_Settings_Change_Language =              qsTr("STR_SETTINGS_CHANGE_LANGUAGE")
        str_Vehicle_Name_Popup =                    qsTr("STR_BT_VEHICLE_NAME_POPUP")
        /* CarPlay */
        str_enter_setting_during_CarPlay =          qsTr("STR_BT_ENTER_SETTING_DURING_CARPLAY")

        str_UVO_OutgoingCall =                      qsTr("STR_BT_UVO_OUTGOINGCALL")
        str_UVO_Popup =                             qsTr("STR_BT_UVO_POPUP")

        str_CenterCall_OutgoingCall =               qsTr("STR_BT_CENTERCALL_OUTGOINGCALL")
        str_CenterCall_Popup =                      qsTr("STR_BT_CENTERCALL_POPUP")

        str_Bt_Connect_Error_For_US =               (1 == UIListener.invokeGetVehicleVariant())? qsTr("STR_BT_CONNECT_ERROR_FOR_US") : qsTr("STR_BT_CONNECT_ERROR_FOR_US").arg(url_DH)
        str_Bt_Connect_Error_For_KR =               qsTr("STR_BT_CONNECT_ERROR_FOR_KR").arg(url_KH)
        str_Bt_Connect_Error_For_COMMON =           qsTr("STR_BT_CONNECT_ERROR_FOR_COMMON")
        str_Bt_Connect_Error_For_CA =               qsTr("STR_BT_CONNECT_ERROR_FOR_CA")

        str_Help_Phonebook_Down_Fail_CA =           qsTr("STR_BT_HELP_PHONEBOOK_DOWN_FAIL_CA")
        str_Help_Phonebook_Down_Message_CA =        qsTr("STR_BT_HELP_PHONEBOOK_DOWN_MESSAGE_CA")
        str_Authentication_Fail_Web_CA =            qsTr("STR_BT_AUTHENTICATION_FAIL_WEB_CA");
        str_Authentication_Fail_Message_CA =        qsTr("STR_BT_AUTHENTICATION_FAIL_MESSAGE_CA")

        //2015.10.30 [ITS 0269835,0269836] Android Auto Handling (UX Scenario Changed)
        /* AADefend */
        str_AADefend_Popup_Text =                   qsTr("STR_BT_AA_DEFEND_TEXT")

        fontFamilyBold      = "DH_HDB"
        fontFamilyRegular   = "DH_HDR"
    }

    Connections {
        target: UIListener

        onRetranslateUi: {
            // UPDATE language
            var reload = false;
            if(20 != gLanguage) {
                if(20 != languageId) {
                    // do nothing, just reload string resource
                } else {
                    // RELOAD
                    reload = true;
                }
            } else {
                if(20 != languageId) {
                    // RELOAD
                    reload = true;
                } else {
                    // do nothing, just reload string resource
                }
            }

            if("BtDialMain" == idAppMain.state || "BtContactMain" == idAppMain.state || "BtContactSearchMain" == idAppMain.state) {
                // 현재 폰북화면이라면 폰북 리로드가 필요함(정렬순서가 바뀌기 때문)
                BtCoreCtrl.invokeTrackerReloadPhonebook(gLanguage, languageId);
            } else {
                // 탭을 누를때 폰북을 리로드 하도록 Flag 설정(/Band/BtMainBand.qml)
                gPhonebookReload = true;
                gPhonebookReloadForDial = true;
            }

            if("BtRecentCall" == idAppMain.state || "BtRecentDelete" == idAppMain.state) {
                // 현재 최근통화목록(또는 삭제)화면이라면 최근통화목록 리로드가 필요
                BtCoreCtrl.invokeTrackerReloadPhonebook(gLanguage, languageId);
                BtCoreCtrl.invokeTrackerReloadRecents(true, select_recent_call_type);
            } else {
                // 이름만 초기화
                BtCoreCtrl.invokeTrackerReloadRecents(false);
            }

            // 즐겨찾기는 10개밖에 되지 않으므로 그냥 바로 로딩함
            BtCoreCtrl.invokeTrackerReloadFavorite();

            gLanguage = languageId;
            //DEPRECATED gPhonebookReload = true;

            stringInfo.retranslateUi(languageId);
            LocTrigger.retrigger();

            if(true == reload) {
                // UI reload!
                //DEPRECATED MOp.reloadUI();
                sigUpdateUI();


                // 포커스도 재설정해야 함
                MOp.returnFocus();
            }

            phonebookModelChanged();
        }
    }
}
/* EOF */
