/**
 * MPopupTypeListContactSearch.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MComponent
{
    id: idMPopupTypeList
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupName
    property string popupBgImage: ImagePath.imgFolderPopup + "bg_type_e.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 131 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 459

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1    //# 1 or 2
    property QtObject idListModel
    property string listFirstItem
    property string popupTitleText

    property int popupLineCnt: idListView.count    //# 1 ~ limit
    property int overContentCount
    property bool black_opacity

    // SIGNALS
    signal popupClicked();
    //DEPRECCATED signal popupBgClicked();
    signal popuplistItemClicked(int currentIndex);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    signal btnclicked4_1();
    signal btnclicked4_2();
    signal btnclicked4_3();
    signal btnclicked4_4();
    signal btnclicked5();


    function imageChange(type) {
        if(1 == type) {
            return ImagePath.imgFolderPopup + "ico_bt_phone.png"
        } else if(2 == type) {
            return ImagePath.imgFolderPopup + "ico_bt_home.png"
        } else if(3 == type) {
            return ImagePath.imgFolderPopup + "ico_bt_office.png"
        } else {
            return ImagePath.imgFolderPopup + "ico_bt_other.png"
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeList.visible) {
            idSearchContacts.model.get(4).contactsIconType = contact_type_5
            idSearchContacts.model.get(3).contactsIconType = contact_type_4
            idSearchContacts.model.get(2).contactsIconType = contact_type_3
            idSearchContacts.model.get(1).contactsIconType = contact_type_2
            idSearchContacts.model.get(0).contactsIconType = contact_type_1

            idSearchContacts.model.get(4).contactNumber = other2Num
            idSearchContacts.model.get(3).contactNumber = otherNum
            idSearchContacts.model.get(2).contactNumber = officeNum
            idSearchContacts.model.get(1).contactNumber = homeNum
            idSearchContacts.model.get(0).contactNumber = phoneNum

            /* 팝업은 4~5개만 나타나는 팝업인데, 현재 화면이 4개짜리면 4개짜리 첫 번째 포커스 가도록 하며,
             * 5개인 경우에는 5개를 나타내는 리스트에 포커스 가도록 하는 코드
             */
            if(4 == delegate_count) {
                btn_list_04_01.forceActiveFocus();
            } else {
                idSearchContacts.forceActiveFocus();
                idSearchContacts.currentIndex = 0
            }
            popupBackGround = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeList.visible) {
            idSearchContacts.model.get(4).contactsIconType = contact_type_5
            idSearchContacts.model.get(3).contactsIconType = contact_type_4
            idSearchContacts.model.get(2).contactsIconType = contact_type_3
            idSearchContacts.model.get(1).contactsIconType = contact_type_2
            idSearchContacts.model.get(0).contactsIconType = contact_type_1

            idSearchContacts.model.get(4).contactNumber = MOp.checkPhoneNumber(other2Num)
            idSearchContacts.model.get(3).contactNumber = MOp.checkPhoneNumber(otherNum)
            idSearchContacts.model.get(2).contactNumber = MOp.checkPhoneNumber(officeNum)
            idSearchContacts.model.get(1).contactNumber = MOp.checkPhoneNumber(homeNum)
            idSearchContacts.model.get(0).contactNumber = MOp.checkPhoneNumber(phoneNum)

            /* 팝업은 4~5개만 나타나는 팝업인데, 현재 화면이 4개짜리면 4개짜리 첫 번째 포커스 가도록 하며,
             * 5개인 경우에는 5개를 나타내는 리스트에 포커스 가도록 하는 코드
             */
            if(4 == delegate_count) {
                btn_list_04_01.forceActiveFocus();
            } else {
                idSearchContacts.forceActiveFocus();
                idSearchContacts.currentIndex = 0
            }
            popupBackGround = black_opacity
        }
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: popupBgImage
        x: popupBgImageX
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight
        focus: true

        Text {
            id: idTitle
            text: popupTitleText
            x: 55
            y: 37
            width: 983
            height: 44
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }

        FocusScope {
            id: idList_4Line
            x: 26
            visible: 4 == delegate_count
            focus: 4 == delegate_count

            MButton {
                id: btn_list_04_01
                y: 104
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: true

                firstText: MOp.checkPhoneNumber(phoneNum)
                firstTextX: 36 + 20 + 63
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                lineImage: ImagePath.imgFolderPopup + "list_line.png"
                lineImageX: 5
                lineImageY: 82

                Image {
                    source: imageChange(contact_type_1)
                    x: 36
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_04_01.focus = true;
                    btnclicked4_1();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 678
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelRightKeyPressed: btn_list_04_02.forceActiveFocus()
            }


            MButton {
                id: btn_list_04_02
                y: 104 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(homeNum)
                firstTextX: 36 + 20 + 63
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                lineImage: ImagePath.imgFolderPopup + "list_line.png"
                lineImageX: 5
                lineImageY: 82

                Image {
                    source: imageChange(contact_type_2)
                    x: 36
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_04_02.focus = true;
                    btnclicked4_2();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 678
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelLeftKeyPressed: btn_list_04_01.forceActiveFocus()
                onWheelRightKeyPressed: btn_list_04_03.forceActiveFocus()
            }


            MButton {
                id: btn_list_04_03
                y: 104 + 82 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(officeNum)
                firstTextX: 36 + 20 + 63
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                lineImage: ImagePath.imgFolderPopup + "list_line.png"
                lineImageX: 5
                lineImageY: 82

                Image {
                    source: imageChange(contact_type_3)
                    x: 36
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_04_03.focus = true;
                    btnclicked4_3();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 678
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelLeftKeyPressed: btn_list_04_02.forceActiveFocus()
                onWheelRightKeyPressed: btn_list_04_04.forceActiveFocus()
            }


            MButton {
                id: btn_list_04_04
                y: 104 + 82 + 82 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(otherNum)
                firstTextX: 36 + 20 + 63
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                lineImage: ImagePath.imgFolderPopup + "list_line.png"
                lineImageX: 5
                lineImageY: 82

                Image {
                    source: imageChange(contact_type_4)
                    x: 36
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_04_04.focus = true;
                    btnclicked4_4();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 678
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelLeftKeyPressed: btn_list_04_03.forceActiveFocus()
            }

            KeyNavigation.right: idButton1
        }

        FocusScope {
            id: idList_5Line
            x: 26
            y: 104
            visible: 5 == delegate_count
            focus: 5 == delegate_count

            ListView {
                id: idSearchContacts
                width: 740
                height: 82 * 4
                focus: true
                model: favoriteModel
                clip: true
                highlightMoveSpeed: 9999999
                boundsBehavior: Flickable.StopAtBounds

                delegate: favoriote_btn

                onContentYChanged:{
                    overContentCount = contentY / (contentHeight / count)
                }

                function getStartIndex(posY) {
                    var startIndex = -1;
                    for(var i = 1; i < 10; i++) {
                        startIndex = indexAt(100, posY + 50 * i);
                        if(-1 < startIndex) {
                            break;
                        }
                    }

                    return startIndex;
                }

                onMovementStarted: {
                }

                onMovementEnded: {
                    if(false == idSearchContacts.visible) {
                        return;
                    }

                    if("" == popupState && menuOn == false) {
                        idSearchContacts.forceActiveFocus();
                    }

                    var flickingIndex = getStartIndex(contentY);
                    if(-1 != flickingIndex) {
                        positionViewAtIndex(flickingIndex, ListView.Beginning);
                        currentIndex = flickingIndex;
                    }
                }
            }

            ListModel{
                id:favoriteModel
                ListElement {contactsIconType: "";  contactNumber: "" }
                ListElement {contactsIconType: "";  contactNumber: "" }
                ListElement {contactsIconType: "";  contactNumber: "" }
                ListElement {contactsIconType: "";  contactNumber: "" }
                ListElement {contactsIconType: "";  contactNumber: "" }
            }

            Component {
                id: favoriote_btn

                MButton {
                    width: 740
                    height: 82

                    bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                    bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                    bgImageWidth: 740
                    bgImageHeight: 85
                    focus: index == idSearchContacts.currentIndex

                    firstText: MOp.checkPhoneNumber(contactNumber)
                    firstTextX: 36 + 20 + 63
                    firstTextY: 82 - 39 - 16
                    firstTextWidth: 567
                    firstTextHeight: 32
                    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                    firstTextSize: 32
                    firstTextColor: colorInfo.brightGrey

                    lineImage: ImagePath.imgFolderPopup + "list_line.png"
                    lineImageX: 5
                    lineImageY: 82

                    Image {
                        source: imageChange(contactsIconType)
                        x: 36
                        y: 82 - 39 - 24
                        width: 50
                        height: 50
                    }

                    onWheelLeftKeyPressed: {
                        if(0 == index ){
                            idSearchContacts.currentIndex = idSearchContacts.count - 1
                        } else {
                            idSearchContacts.decrementCurrentIndex()
                        }
                    }

                    onWheelRightKeyPressed: {
                        if(idSearchContacts.count == index + 1){
                            idSearchContacts.currentIndex = 0
                        } else {
                            idSearchContacts.incrementCurrentIndex()
                        }
                    }

                    onClickOrKeySelected: {
                        idSearchContacts.currentIndex = index;

                        // 즐겨찾기 모드를 통하여 각각 동작 추가
                        if("" == favoriteAdd) {
                            //__IQS_15MY_ Call End Modify
                            if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                                /* 통화중일 경우 진입 막음
                                 */
                                MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                            } else {
                                if(index == 0) {
                                    BtCoreCtrl.HandleCallStart(phoneNum)
                                } else if(index == 1) {
                                    BtCoreCtrl.HandleCallStart(homeNum)
                                } else if(index == 2) {
                                    BtCoreCtrl.HandleCallStart(officeNum)
                                } else if(index == 3) {
                                    BtCoreCtrl.HandleCallStart(otherNum)
                                } else if(index == 4) {
                                    BtCoreCtrl.HandleCallStart(other2Num)
                                }
                            }
                        } else {
                            if(index == 0) {
                                BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name
                                                                              , contact_type_1, phoneNum, middle_name);
                            } else if(index == 1) {
                                BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name
                                                                              , contact_type_2, homeNum, middle_name);
                            } else if(index == 2) {
                                BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name
                                                                              , contact_type_3, officeNum, middle_name);
                            } else if(index == 3) {
                                BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name
                                                                              , contact_type_4, otherNum, middle_name);
                            } else if(index == 4) {
                                BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name
                                                                              , contact_type_5, other2Num, middle_name);
                            }
                        }
                    }


                    Image {
                        source: ImagePath.imgFolderPopup + "ico_add.png"
                        x: 678
                        y: 82 - 39 - 24
                        width: 45
                        height: 46
                        visible: "" != favoriteAdd
                    }

                    KeyNavigation.right: idButton1
                }
            }

            MRoundScroll {
                x: 766 - 26
                y: 117 - 104
                scrollWidth: 39
                scrollHeight: 306
                scrollBgImage: idSearchContacts.count > 4 ? ImagePath.imgFolderPopup + "scroll_bg.png" : ""
                scrollBarImage: idSearchContacts.count > 4 ? ImagePath.imgFolderPopup + "scroll.png" : ""
                listCountOfScreen: 4
                moveBarPosition: idSearchContacts.height / idSearchContacts.count * overContentCount
                listCount: idSearchContacts.count
            }
        }

        MButton {
            id: idButton1
            x: 780
            y: 98
            width: 295
            height: 343
            
            bgImage: (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_e_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_e_01_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_e_01_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_e_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -2
            fgImageY: 136
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton1.activeFocus == true

            firstText: popupFirstBtnText
            firstTextX: 832 - 780
            firstTextY: 153
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            KeyNavigation.left: 4 == delegate_count ? idList_4Line : idList_5Line

            onWheelRightKeyPressed: idButton2.forceActiveFocus()

            onClickOrKeySelected: {
                MOp.hidePopup();
            }
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }
}
/* EOF */
