/**
 * BtInfoView.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idInfoViewContainer
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight - systemInfo.headlineHeight
    state: gInfoViewState
    focus: true


    /* Event handlers */
    onBackKeyPressed:{
        // MOp.postBackKey(4);
        /* [주의] 유사한 코드가 MainBand, Contact, Infoview에 존재함
         */
        if(true == gContactFromCall) {
            MOp.reshowCallView(003);
/*
            UIListener.invokePostCallView(3);
            MOp.showCallView(7006);
            gContactFromCall = false;
*/
        } else {
            popScreen(4);
        }
    }

    onClickMenuKey: {
        idMenu.show();
    }

    // Menu off 동작 시 focus
    Connections {
        target: idAppMain
        onMenuOffFocus: {
            if(true == idInfoViewContainer.visible) {
                if("recent_mal_download_wait" == gInfoViewState
                || "ContactsWaitDownMal" == gInfoViewState
                || "FavoritesNoList" == gInfoViewState) {
                    idInfoViewContainer.forceActiveFocus();
                }
            }
        }
    }

    /* WIDGETS */
    MouseArea {
        anchors.fill: parent
        beepEnabled: false
    }

    Image {
        source: ImagePath.imgFolderBt_phone + "bg_bottom.png"
        visible: (gInfoViewState != "FavoritesNoList") ? true : false
        anchors.bottom: parent.bottom

        Text {
            text: BtCoreCtrl.m_strConnectedDeviceName + " : " + stringInfo.str_Device_Name_Bottom
            x: 50
            y: 35 - 16
            width: 1180
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    /* 1. recent_auto_downloading
     */
    Item {
        id: recent_auto_downloading
        visible: ("recent_auto_downloading" == gInfoViewState) ? true : false

        MComp.DDLoadingAnimation {
            x: 590
            y: 104
        }

        Text {
            text: stringInfo.str_Auto_Downloading
            x: 50
            y: 269
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        // 최근 통화 목록 다운로드 중인 화면에서 숫자에 따라 글자의 좌표가 이동하는것을 처리한 부분
        Item {
            x: 150
            y: 343
            width: 980
            height: 40

            Item {
                width: 60 + idRecentCountAuto.paintedWidth
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: BtCoreCtrl.m_downloadingCallHistoryCount
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    height: 40
                    color: colorInfo.bandBlue
                    anchors.left: idRecentCountAuto.right
                    anchors.leftMargin: 4
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id:idRecentCountAuto
                    text:stringInfo.str_Items
                    height: 40
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    color: colorInfo.brightGrey
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    /* 2. recent_mal_download_wait
     */
    Item {
        id: recent_mal_download_wait
        focus: ("recent_mal_download_wait" == gInfoViewState) ? true : false
        visible: ("recent_mal_download_wait" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_No_Callhistory_Recent
            x: 50
            y: 84
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: stringInfo.str_Callhistory_Download_Message
            x: 50
            y: 219
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        MComp.MButton  {
            id: btnRecentWaitDownMal
            x: 409
            y: 331      //497 - 93 - 73
            width: 462
            height: 85
            focus: ("recent_mal_download_wait" == gInfoViewState) ? true : false

            bgImage:        ImagePath.imgFolderAha_radio + "btn_ok_n.png"
            bgImagePress:   ImagePath.imgFolderAha_radio + "btn_ok_p.png"
            bgImageFocus:   ImagePath.imgFolderAha_radio + "btn_ok_f.png"

            firstText: stringInfo.str_Btn_Download
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextX: 14
            firstTextY: 42 - 18
            firstTextWidth: 422
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                //BtCoreCtrl.HandlePbapDownloadCallHistory()
                if(true == downloadContact) {
                    MOp.showPopup("popup_Bt_Downloading_Phonebook");
                } else {
                    BtCoreCtrl.invokeTrackerDownloadCallHistory()
                    idLoaderMainBand.forceActiveFocus();
                }
            }
        }
    }

    /* 3. recent_not_support
     */
    Item {
        id: recent_not_support
        focus: ("recent_not_support" == gInfoViewState) ? true : false
        visible: ("recent_not_support" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_No_Callhistory_Recent
            x: 50
            y: 144      //164 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: stringInfo.str_Nosup_Callhistory
            x: 50
            y: 249      //164 + 105 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }

    /* 4. recent_no_list
     */
    Item {
        id: recent_no_list
        visible: ("recent_no_list" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_No_Callhistory_Recent
            x: 50
            y: 221      //407 - 166 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }

    /* 5. RecentDownLoadingMal
     */
    Item {
        id:recentDownLoadingMal
        visible: ("RecentDownLoadingMal" == gInfoViewState) ? true : false
        focus: ("RecentDownLoadingMal" == gInfoViewState) ? true : false

        MComp.DDLoadingAnimation {
            x: 590
            y: 104
        }

        Text {
            text: stringInfo.str_Mal_Downloading
            x: 150
            y: 269
            width: 980
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        // 최근 통화 목록 다운로드 중인 화면에서 숫자에 따라 글자의 좌표가 이동하는것을 처리한 부분
        Item {
            x: 150
            y: 343
            width: 980
            height: 40

            Item {
                width: 60 + idRecentCountMal.paintedWidth
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: BtCoreCtrl.m_downloadingCallHistoryCount
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    height: 40
                    color: colorInfo.bandBlue
                    anchors.left: idRecentCountMal.right
                    anchors.leftMargin: 4
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id:idRecentCountMal
                    text:stringInfo.str_Items
                    height: 40
                    //width: idRecentCountMal.paintedWidth
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    color: colorInfo.brightGrey
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    /* 6. RecentWaitDownAuto
     */
    Item {
        id: recentWaitDownAuto
        visible: ("RecentWaitDownAuto" == gInfoViewState) ? true : false
        focus: ("RecentWaitDownAuto" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_Callhistory_Reqdown
            x: 50
            y: 144      //164 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: stringInfo.str_Accept_Phone_Text
            x: 50
            y: 249      //164 + 105 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }


    /* 1. ContactsDownLoading
     */
    Item {
        id: contactsDownLoading
        visible: ("ContactsDownLoading" == gInfoViewState) ? true : false

        MComp.DDLoadingAnimation {
            x: 590
            y: 104
        }

        Text {
            text: stringInfo.str_Auto_Downloading
            x: 50
            y: 269
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Item {
            x: 150
            y: 343
            width: 980
            height: 40

            Item {
                width: 94 + idContactsCountAuto.paintedWidth
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: BtCoreCtrl.m_nCountContactsList
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    height: 40
                    color: colorInfo.bandBlue
                    anchors.left: idContactsCountAuto.right
                    anchors.leftMargin: 4
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: idContactsCountAuto
                    text: stringInfo.str_Items
                    height: 40
                    //width: idContactsCountAuto.paintedWidth
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    color: colorInfo.brightGrey
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    /* 2. ContactsWaitDownMal
     */
    Item {
        id: contactsWaitDownMal
        focus: ("ContactsWaitDownMal" == gInfoViewState) ? true : false
        visible: ("ContactsWaitDownMal" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_No_Phonebook
            x: 50
            y: 84
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: stringInfo.str_Phonebook_Download_Message
            x: 50
            y: 219
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        MComp.MButton {
            id: btnContactsWaitDownMal
            x: 409
            y: 331
            width: 462
            height: 85
            focus: ("ContactsWaitDownMal" == gInfoViewState) ? true : false

            bgImage:        ImagePath.imgFolderAha_radio + "btn_ok_n.png"
            bgImagePress:   ImagePath.imgFolderAha_radio + "btn_ok_p.png"
            bgImageFocus:   ImagePath.imgFolderAha_radio + "btn_ok_f.png"

            firstText: stringInfo.str_Btn_Download
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextX: 14
            firstTextY: 42 - 18
            firstTextWidth: 422
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                //BtCoreCtrl.HandlePbapDownloadPhoneBook()
                if(true == downloadCallHistory) {
                    MOp.showPopup("popup_Bt_Downloading_Callhistory");
                } else {
                    BtCoreCtrl.invokeTrackerDownloadPhonebook()
                    idLoaderMainBand.forceActiveFocus();
                }
            }
        }
    }

    /* 3. ContactsWaitDownAuto
     */
    Item  {
        id: contactsWaitDownAuto
        focus: ("ContactsWaitDownAuto" == gInfoViewState) ? true : false
        visible: ("ContactsWaitDownAuto" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_Phonebook_Reqdown
            x: 50
            y: 164 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: stringInfo.str_Accept_Phone_Text
            x: 50
            y: 164 + 105 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }

    /* 4. contact_no_list
     */
    Item {
        id: contactsNotSupport
        visible: ("contact_no_list" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_No_Phonebook
            x: 50
            y: 144      //164 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: stringInfo.str_Nosup_Phonebook
            x: 50
            y: 249      //164 + 105 - 20
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }

    /* 5. ContactsDownLoadingMal
     */
    Item {
        id:contactsDownLoadingMal
        visible: ("ContactsDownLoadingMal" == gInfoViewState) ? true : false
        focus: ("ContactsDownLoadingMal" == gInfoViewState) ? true : false

        MComp.DDLoadingAnimation {
            x: 590
            y: 104
        }

        Text {
            text: stringInfo.str_Mal_Downloading
            x: 50
            y: 269
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        // 전화번호부 목록 다운로드 중인 화면에서 숫자에 따라 글자의 좌표가 이동하는것을 처리한 부분
        Item {
            x: 150
            y: 343
            width: 980
            height: 40

            Item {
                width: 94 + idContactsCountMal.paintedWidth
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: BtCoreCtrl.m_nCountContactsList
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    height: 40
                    color: colorInfo.bandBlue
                    anchors.left: idContactsCountMal.right
                    anchors.leftMargin: 4
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id:idContactsCountMal
                    text: stringInfo.str_Items
                    height: 40
                    //width: idContactsCountMal.paintedWidth
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    color: colorInfo.brightGrey
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    /* 6. contactsUpdate
     */
    Item {
        id: contactUpdateView
        visible: ("ContactsUpdate" == gInfoViewState) ? true : false
        focus: ("ContactsUpdate" == gInfoViewState) ? true : false

        MComp.DDLoadingAnimation {
            x: 590
            y: 104
        }


        Text {
            text: stringInfo.str_Bt_Updating
            x: 50
            y: 269
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Item {
            x: 150
            y: 343
            width: 980
            height: 40



            Item {
                width: idTextProgress.paintedWidth + 108 + idContactsUpdate.paintedWidth
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: idTextProgress
                    text: stringInfo.str_Bt_Download_Progress
                    height: 40
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    color: colorInfo.brightGrey
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: idTextCount
                    text: BtCoreCtrl.m_nCountContactsList
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    height: 40
                    color: colorInfo.bandBlue
                    anchors.left: idContactsUpdate.right
                    anchors.leftMargin: 4
                    anchors.right: idTextProgress.left
                    anchors.rightMargin: (2000 <= BtCoreCtrl.m_nCountContactsList) ? 8 : 4
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id:idContactsUpdate
                    text: stringInfo.str_Items
                    height: 40
                    font.family: stringInfo.fontFamilyRegular    //"HDR"
                    font.pointSize: 40
                    color: colorInfo.brightGrey
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    /* 1. FavoritesNoList
     */
    Item {
        id: favoritesNoList
        visible: ("FavoritesNoList" == gInfoViewState) ? true : false
        focus: ("FavoritesNoList" == gInfoViewState) ? true : false

        Text {
            text: stringInfo.str_No_Favorite
            x: 50
            y: 101
            width: 1180
            height: 32
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        Text {
            text: (4 == favorite_nstate) ? stringInfo.not_supported_favorite : stringInfo.str_Add_Message
            x: 50
            y: 121 - 20 + 95
            width: 1180
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            color: colorInfo.dimmedGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }

        MComp.MButton {
            id: favoriteButton1
            x: 409
            y: 524 - 166
            width: 462
            height: 85
            focus: ("FavoritesNoList" == gInfoViewState) ? true : false

            bgImage:        ImagePath.imgFolderAha_radio + "btn_ok_n.png"
            bgImagePress:   ImagePath.imgFolderAha_radio + "btn_ok_p.png"
            bgImageFocus:   ImagePath.imgFolderAha_radio + "btn_ok_f.png"

            firstText: stringInfo.str_New_Device_Popup
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextX: 14
            firstTextY: 24      //42 - 18
            firstTextWidth: 422
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"

            // NOT SUPPORT 상태일때 버튼 Disable 처리
            mEnabled: (13 == contact_nstate) || (4 == favorite_nstate) ? false : true

            onClickOrKeySelected: {
                if(true == iqs_15My && true == BtCoreCtrl.invokeGetBackgroundDownloadMode()) {
                    if(10 > BtCoreCtrl.m_nCountFavoriteContactsList) {
                        // 즐겨찾기 추가모드로 폰북 진입
                        favoriteAdd = "FROM_CONTACT";
                        pushScreen("BtContactMain", 800);
                        favoriteButtonPress = false
                    } else {
                        // 발생할 수 없는 케이스
                        MOp.showPopup("popup_Bt_Favorite_Max");
                    }
                } else {
                    if(10 > BtCoreCtrl.m_nCountFavoriteContactsList) {
                        switch(contact_nstate) {
                            case 1: {
                                // 즐겨찾기 추가모드로 폰북 진입
                                favoriteAdd = "FROM_CONTACT";
                                pushScreen("BtContactMain", 800);
                                favoriteButtonPress = false
                                break;
                            }

                            case 2:
                            case 3:
                            case 8:
                            case 11:
                            case 12:
                            case 13:
                            case 0: {
                                // No sup Phonebook list
                                MOp.showPopup("popup_bt_no_download_phonebook");
                                break;
                            }

                            case 9:
                            case 10: {
                                MOp.showPopup("popup_bt_no_downloading_phonebook");
                                break;
                            }

                            case 4:
                            default:
                                qml_debug("Invalid contact download state");
                                break;
                        }
                    } else {
                        // 발생할 수 없는 케이스
                        MOp.showPopup("popup_Bt_Favorite_Max");
                    }
                }
            }

            onMEnabledChanged: {
                if((true == favoriteButton1.mEnabled) && ("FavoritesNoList" == gInfoViewState)) {
                    gInfoViewFocus = true;
                }
            }
        }
    }

    /* STATES */
    states: [
        State {
            name: "recent_auto_downloading"
            PropertyChanges { target: recent_auto_downloading;  visible:true}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "recent_mal_download_wait"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:true}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "RecentWaitDownAuto"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:true}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "recent_not_support"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:true}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "recent_no_list"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:true}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "RecentDownLoadingMal"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:true}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "ContactsDownLoading"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:true}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "ContactsWaitDownMal"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:true}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "ContactsWaitDownAuto"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:true}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "ContactsNotSupport"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:true}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "ContactsDownLoadingMal"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:true}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "ContactsUpdate"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:true}
            PropertyChanges { target: favoritesNoList;          visible:false}
        }
        , State {
            name: "FavoritesNoList"
            PropertyChanges { target: recent_auto_downloading;  visible:false}
            PropertyChanges { target: recent_mal_download_wait; visible:false}
            PropertyChanges { target: recentWaitDownAuto;       visible:false}
            PropertyChanges { target: recent_not_support;       visible:false}
            PropertyChanges { target: recent_no_list;           visible:false}
            PropertyChanges { target: recentDownLoadingMal;     visible:false}
            PropertyChanges { target: contactsDownLoading;      visible:false}
            PropertyChanges { target: contactsWaitDownMal;      visible:false}
            PropertyChanges { target: contactsWaitDownAuto;     visible:false}
            PropertyChanges { target: contactsNotSupport;       visible:false}
            PropertyChanges { target: contactsDownLoadingMal;   visible:false}
            PropertyChanges { target: contactUpdateView;        visible:false}
            PropertyChanges { target: favoritesNoList;          visible:true}
        }
    ]
}
/* EOF */
