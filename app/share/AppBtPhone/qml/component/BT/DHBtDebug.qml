/**
 * DHBtMain.qml
 *
 */
import QtQuick 1.1
import "../QML/DH" as MComp
import "../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idAppDebug

    property int debugColumn: 0
    property int debugRow: 0


    Item {
        id: debugInfo
        width: 400
        height: 600
        x: systemInfo.lcdWidth - 400
        y: systemInfo.lcdHeight - 600
        visible: debugOnOff

        Column {
            Text { text: " 1. mainViewState: " + mainViewState;                                                     color:"Yellow"; font.pointSize: 15; }
            Text { text: "    idAppMain.state: " + idAppMain.state;                                                 color:"Yellow"; font.pointSize: 15; }
            Text { text: " 2. recentCallState: " + recentCallState;                                                 color:"Yellow"; font.pointSize: 15; }
            Text { text: "    recent_value: " + recent_value;                                                       color:"Yellow"; font.pointSize: 15; }
            Text { text: "    recent_nstate: " + recent_nstate;                                                     color:"Yellow"; font.pointSize: 15; }
            Text { text: " 3. contactState: " + contactState;                                                       color:"Yellow"; font.pointSize: 15; }
            Text { text: "    contact_value: " + contact_value;                                                     color:"Yellow"; font.pointSize: 15; }
            Text { text: "    contact_nstate: " + contact_nstate;                                                   color:"Yellow"; font.pointSize: 15; }
            Text { text: " 4  favorite_nstate: " + favorite_nstate;                                                 color:"Yellow"; font.pointSize: 15; }
            Text { text: " 6. callType: " + callType;                                                               color:"Red";    font.pointSize: 20; }
            Text { text: " 7. BtCoreCtrl.m_ncallState: " + BtCoreCtrl.m_ncallState;                                 color:"Red";    font.pointSize: 20; }
            Text { text: " 8. CountryVariant(): " + UIListener.invokeGetCountryVariant();                           color:"White";  font.pointSize: 15; }
            Text { text: " 9. downloadCallHistory: " + downloadCallHistory;                                         color:"Yellow"; font.pointSize: 15; }
            Text { text: "  . favoriteAdd: " + favoriteAdd;                                                         color:"Yellow"; font.pointSize: 15; }
            Text { text: "10. callViewSate: " + callViewState;                                                      color:"Red";    font.pointSize: 20; }
            Text { text: "11. popup : " + popupState;                                                               color:"Yellow"; font.pointSize: 15; }
            Text { text: "12. parking : " + parking;                                                                color:"Yellow"; font.pointSize: 15; }
            Text { text: "13. BtCoreCtrl.m_micVolume : "+ BtCoreCtrl.m_micVolume;                                   color:"Green";  font.pointSize: 15; }
            Text { text: "14. m_pairedDeviceCount : "+ BtCoreCtrl.m_pairedDeviceCount;                              color:"Green";  font.pointSize: 15; }
            Text { text: "15. BtCoreCtrl.m_strPhoneName0 : "+ BtCoreCtrl.m_strPhoneName0;                           color:"Orange"; font.pointSize: 15; }
            Text { text: "16. BtCoreCtrl.m_strPhoneName1 : "+ BtCoreCtrl.m_strPhoneName1;                           color:"Orange"; font.pointSize: 15; }
            Text { text: "17. BtCoreCtrl.m_strPhoneNumber0 : "+ BtCoreCtrl.m_strPhoneNumber0;                       color:"Orange"; font.pointSize: 15; }
            Text { text: "18. BtCoreCtrl.m_strPhoneNumber1 : "+ BtCoreCtrl.m_strPhoneNumber1;                       color:"Orange"; font.pointSize: 15; }
            Text { text: "18. BtCoreCtrl.m_strTimeStamp0 : "+ BtCoreCtrl.m_strTimeStamp0;                           color:"Orange"; font.pointSize: 15; }
            Text { text: "18. BtCoreCtrl.m_strTimeStamp1 : "+ BtCoreCtrl.m_strTimeStamp1;                           color:"Orange"; font.pointSize: 15; }
            Text { text: "19. BtCoreCtrl.m_handsfreeMicVolume : "+ BtCoreCtrl.m_handsfreeMicVolume;                 color:"Orange"; font.pointSize: 15; }

            //Can't find variable.   Text { text: "19. popupPreloadState: " + popupPreloadState;                                             color:"Red";    font.pointSize: 20; }
            //Can't find variable.   Text { text: "19. popupDelayedLoadState: " + popupDelayedLoadState;                                     color:"Red";    font.pointSize: 20; }
        }
    }

    MouseArea {
        width: 40
        height: 40
        x: systemInfo.lcdWidth - 40
        y: systemInfo.lcdHeight - 40
        
        onPressAndHold: {
            //Qml 디버거 활성화 필요한 경우 아래의 주석 해제
            debugOnOff = !debugOnOff
        }
    }

    //MComp.MDebug { column: 0;   row: 0;     boxColor: "Red";      onClicked: { BtCoreCtrl.m_ncallState = 31 } }
    //MComp.MDebug { column: 1;   row: 0;     boxColor: "Orange";   onClicked: { BtCoreCtrl.m_ncallState = 61 } }
    //MComp.MDebug { column: 2;   row: 0;     boxColor: "Orange";   onClicked: { callPrivateMode = !callPrivateMode } }

    MouseArea {
        width: 40
        height: 40
        x: systemInfo.lcdWidth - 40
        y: systemInfo.lcdHeight - 80

        onPressAndHold: {
            //Qml 디버거 활성화 필요한 경우 아래의 주석 해제
            //textWidth = !textWidth
        }
    }

    MouseArea {
        x: 0
        y: 93
        width: 100
        height: 100

        visible: debugOnOff

        Rectangle {
            anchors.fill:parent
            color: "Grey"

            Text {
                text: {
                    if(0 == gLanguage) {
                        "UnKnow"
                    } else if(1 == gLanguage) {
                        "English"
                    } else if(2 == gLanguage) {
                        "Korean"
                    } else if(3 == gLanguage) {
                        "China"
                    } else if(4 == gLanguage) {
                        "Peoples Republic Of China"
                    } else if(5 == gLanguage) {
                        "Europeen Portuguese"
                    } else if(6 == gLanguage) {
                        "English (UK)"
                    } else if(7 == gLanguage) {
                        "English (US)"
                    } else if(8 == gLanguage) {
                        "European French"
                    } else if(9 == gLanguage) {
                        "Italian"
                    } else if(10 == gLanguage) {
                        "German"
                    } else if(11 == gLanguage) {
                        "European Spanish"
                    } else if(12 == gLanguage) {
                        "Russian"
                    } else if(13 == gLanguage) {
                        "Dutch"
                    } else if(14 == gLanguage) {
                        "Swedish"
                    } else if(15 == gLanguage) {
                        "Polish"
                    } else if(16 == gLanguage) {
                        "Turkish"
                    } else if(17 == gLanguage) {
                        "Czech"
                    } else if(18 == gLanguage) {
                        "Danish"
                    } else if(19 == gLanguage) {
                        "Slovakia"
                    } else if(20 == gLanguage) {
                        "Arabic"
                    } else {
                        "Who are you???"
                    }
                }
                font.pointSize: 20
                color: "Yellow"
            }

            Text {
                y: 20
                text: "column >" + debugColumn + "\nrow" + debugRow + "\nlang" + gLanguage
                font.pointSize: 20
                color: "Red"
            }
        }

        onClicked: {
            UIListener.invokeTESTLanguageChange(true);
        }
    }

    MouseArea {
        x: 100
        y: 93
        width: 100
        height: 100

        visible: debugOnOff

        Rectangle {
            anchors.fill:parent
            color: "Grey"

            Text {
                text: {
                    if(0 == gLanguage) {
                        "UnKnown"
                    } else if(1 == gLanguage) {
                        "English"
                    } else if(2 == gLanguage) {
                        "Korean"
                    } else if(3 == gLanguage) {
                        "China"
                    } else if(4 == gLanguage) {
                        "Peoples Republic Of China"
                    } else if(5 == gLanguage) {
                        "Europeen Portuguese"
                    } else if(6 == gLanguage) {
                        "English (UK)"
                    } else if(7 == gLanguage) {
                        "English (US)"
                    } else if(8 == gLanguage) {
                        "European French"
                    } else if(9 == gLanguage) {
                        "Italian"
                    } else if(10 == gLanguage) {
                        "German"
                    } else if(11 == gLanguage) {
                        "European Spanish"
                    } else if(12 == gLanguage) {
                        "Russian"
                    } else if(13 == gLanguage) {
                        "Dutch"
                    } else if(14 == gLanguage) {
                        "Swedish"
                    } else if(15 == gLanguage) {
                        "Polish"
                    } else if(16 == gLanguage) {
                        "Turkish"
                    } else if(17 == gLanguage) {
                        "Czech"
                    } else if(18 == gLanguage) {
                        "Danish"
                    } else if(19 == gLanguage) {
                        "Slovakia"
                    } else if(20 == gLanguage) {
                        "Arabic"
                    } else {
                        "Who are you???"
                    }
                }

                font.pointSize: 20
                color: "Yellow"
            }

            Text {
                y: 20
                text: "column >" + debugColumn + "\nrow" + debugRow
                font.pointSize: 20
                color: "Red"
            }
        }

        onClicked: {
            UIListener.invokeTESTLanguageChange(false);
        }
    }

    /* //주행 규제 모드 Test 코드
    MComp.MDebug { column: 0;   row: 0;     boxColor: "Green";      onClicked: {sigBluetoothDrivingRestrictionShow(); }}
    MComp.MDebug { column: 1;   row: 0;     boxColor: "Red";        onClicked: {sigBluetoothDrivingRestrictionHide(); }}
    */
    /* //CarPlay 모드 Test 코드
    MComp.MDebug { column: 0;   row: 0;     boxColor: "Green";      onClicked: {sigAAPConnected(); }}
    MComp.MDebug { column: 1;   row: 0;     boxColor: "Red";        onClicked: {sigAAPDisconnected(); }}
    */
    MComp.MDebug { column: 0;   row: 0;     boxColor: "Red";      onClicked: { MOp.showPopup("Call_popup"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 1;   row: 0;     boxColor: "Orange";   onClicked: { MOp.showPopup("Call_3way_popup"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 2;   row: 0;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_bluelink_popup"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 3;   row: 0;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_bluelink_popup_Outgoing_Call"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 4;   row: 0;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_Bt_Phonebook_Downloading_Dis_Connect"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 5;   row: 0;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_redownload"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 6;   row: 0;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_bt_conn_paired_device_delete"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 7;   row: 0;     boxColor: "White";    onClicked: { MOp.showPopup("popup_bt_paired_device_delete"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 8;   row: 0;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_device_name_empty"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 9;   row: 0;     boxColor: "Pink";     onClicked: { MOp.showPopup("popup_bt_paired_device_delete_all"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 10;  row: 0;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_bt_conn_paired_device_all"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 11;  row: 0;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_Bt_Other_Device_Connect"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 12;  row: 0;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_Bt_Other_Device_Connect_Menu"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 13;  row: 0;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_Disconnect_By_Phone"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 14;  row: 0;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_delete_select"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 15;  row: 0;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_delete_all"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 16;  row: 0;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_bt_delete_all_history"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 17;  row: 0;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_launch_help_in_driving"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 18;  row: 0;     boxColor: "White";    onClicked: { MOp.showPopup("disconnectSuccessPopup"); debugColumn = column; debugRow = row; } }
    //DEPRECATED MComp.MDebug { column: 19;  row: 0;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_Bt_Connected_enter_bt_phone"); debugColumn = column; debugRow = row; } }

    MComp.MDebug { column: 0;   row: 1;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_Bt_Add_Favorite"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 1;   row: 1;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_enter_setting_during_call"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 2;   row: 1;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_Deleting"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 3;   row: 1;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_Bt_Deleted"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 4;   row: 1;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_Bt_Max_Device"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 5;   row: 1;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_Bt_Max_Phonebook"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 6;   row: 1;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_Bt_Callhistory_Downloading_Dis_Connect"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 7;   row: 1;     boxColor: "White";    onClicked: { MOp.showPopup("popup_Bt_Dis_Connecting"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 8;   row: 1;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_Bt_Dis_Connecting_No_Btn"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 9;   row: 1;     boxColor: "Pink";     onClicked: { MOp.showPopup("popup_Bt_Linkloss"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 10;  row: 1;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Contact_Down_fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 11;  row: 1;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_recent_info"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 12;  row: 1;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_number_list5"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 13;  row: 1;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_number_list3"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 14;  row: 1;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_number_list5"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 15;  row: 1;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_number_list3"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 16;  row: 1;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_bt_checkbox_ini"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 17;  row: 1;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_Bt_Disconect_Initialize"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 18;  row: 1;     boxColor: "White";    onClicked: { MOp.showPopup("popup_Bt_PBAP_Not_Support"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 19;  row: 1;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_toast_outgoing_calls_empty"); debugColumn = column; debugRow = row; } }

    MComp.MDebug { column: 0;   row: 2;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_Bt_Authentication_Fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 1;   row: 2;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_Bt_Ini"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 2;   row: 2;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_device_name_limit_char"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 3;   row: 2;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_device_name_limit_length"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 4;   row: 2;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_bt_no_downloading_phonebook"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 5;   row: 2;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_bt_no_download_phonebook"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 6;   row: 2;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_bt_contact_download_fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 7;   row: 2;     boxColor: "White";    onClicked: { MOp.showPopup("popup_bt_callhistory_download_fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 8;   row: 2;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_Bt_Add_Favorite_Duplicate"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 9;   row: 2;     boxColor: "Pink";     onClicked: { MOp.showPopup("popup_Bt_Call_No_Outgoing"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 10;  row: 2;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_outgoing_calls_empty"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 11;  row: 2;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_Bt_Favorite_Max"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 12;  row: 2;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_Bt_State_Calling_No_OutCall"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 13;  row: 2;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_bt_invalid_during_call"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 14;  row: 2;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_Bt_No_Dial_No_Connect_Device"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 15;  row: 2;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_Bt_Downloading_Phonebook"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 16;  row: 2;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_Bt_No_Phonebook_Phone"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 17;  row: 2;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_Bt_enter_setting_during_CarPlay"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 18;  row: 2;     boxColor: "White";    onClicked: { MOp.showPopup("popup_Bt_No_CallHistory"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 19;  row: 2;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_Bt_Call_Fail"); debugColumn = column; debugRow = row; } }

    MComp.MDebug { column: 0;   row: 3;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_Bt_Request_Phonebook"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 1;   row: 3;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_bt_phonebook_download_completed"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 2;   row: 3;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_RecentCall_Down_completed"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 3;   row: 3;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_Bt_Downloading_Callhistory"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 4;   row: 3;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_bt_recentcall_download_fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 5;   row: 3;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_bt_phonebook_download_fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 6;   row: 3;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_Bt_Authentication_Wait_Btn"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 7;   row: 3;     boxColor: "White";    onClicked: { MOp.showPopup("popup_Bt_Authentication_Wait"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 8;   row: 3;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_Bt_No_Device"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 9;   row: 3;     boxColor: "Pink";     onClicked: { MOp.showPopup("popup_Bt_No_Connection"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 10;  row: 3;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_Connect_Wait_Phone"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 11;  row: 3;     boxColor: "Red";      onClicked: { MOp.showPopup("popup_Bt_Dis_Connection"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 12;  row: 3;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_Bt_SSP_Add"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 13;  row: 3;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_Connection_Auth_Fail_Ssp"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 14;  row: 3;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_Bt_Connection_Auth_Fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 15;  row: 3;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_Bt_Connection_Fail_Re_Connect"); debugColumn = column; debugRow = row; } }
    //DEPRECATED MComp.MDebug { column: 16;  row: 3;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_Bt_Connected"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 17;  row: 3;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_restrict_while_driving"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 18;  row: 3;     boxColor: "White";    onClicked: { MOp.showPopup("popup_Bt_Connection_Fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 19;  row: 3;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_Bt_Initialized"); debugColumn = column; debugRow = row; } }

    MComp.MDebug { column: 0;   row: 4;     boxColor: "Orange";   onClicked: { MOp.showPopup("popup_Bt_Disconnection_Fail"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 1;   row: 4;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_Connect_Cancelling"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 2;   row: 4;     boxColor: "Green";    onClicked: { MOp.showPopup("popup_Bt_Connecting"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 3;   row: 4;     boxColor: "Blue";     onClicked: { MOp.showPopup("popup_Bt_Initialized"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 4;   row: 4;     boxColor: "Navy";     onClicked: { MOp.showPopup("popup_Bt_Connecting_APP"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 5;   row: 4;     boxColor: "Purple";   onClicked: { MOp.showPopup("popup_Bt_Phone_Request_Connect_Device"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 6;   row: 4;     boxColor: "White";    onClicked: { MOp.showPopup("popup_Bt_SSP"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 7;   row: 4;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_paired_list"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 8;   row: 4;     boxColor: "Pink";     onClicked: { MOp.showPopup("connectSuccessPopup"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 9;   row: 4;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_Bt_AutoConnect_Device"); debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 10;  row: 4;     boxColor: "Grey";    onClicked: { MOp.showPopup("popup_Bt_No_Outgoing_Call_Power_Off"); debugColumn = column; debugRow = row; } }


//    // Siri Popup 테스트 코드 (중동엔 없음)
//    MComp.MDebug { column: 10;  row: 4;     boxColor: "Grey";     onClicked: { MOp.showPopup("popup_bt_siri_connect"); debugColumn = column; debugRow = row; } }
//    MComp.MDebug { column: 11;  row: 4;     boxColor: "Pink";     onClicked: { MOp.showPopup("popup_bt_siri_turn_on_device"); debugColumn = column; debugRow = row; } }
//    MComp.MDebug { column: 12;  row: 4;     boxColor: "Yellow";   onClicked: { MOp.showPopup("popup_bt_siri_Setting"); debugColumn = column; debugRow = row; } }*/

    MComp.MDebug { column: 13;  row: 4;     boxColor: "Blue";     onClicked: { BtCoreCtrl.m_ncallState =  1; debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 14;  row: 4;     boxColor: "Red";      onClicked: { BtCoreCtrl.m_ncallState = 20; debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 15;  row: 4;     boxColor: "Blue";     onClicked: { BtCoreCtrl.m_ncallState = 30; debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 16;  row: 4;     boxColor: "Red";      onClicked: { BtCoreCtrl.m_ncallState = 50; debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 17;  row: 4;     boxColor: "Blue";     onClicked: { BtCoreCtrl.m_ncallState = 61; debugColumn = column; debugRow = row; } }
    MComp.MDebug { column: 18;  row: 4;     boxColor: "Red";      onClicked: { BtCoreCtrl.m_ncallState = 62; debugColumn = column; debugRow = row; } }
}
/* EOF */
