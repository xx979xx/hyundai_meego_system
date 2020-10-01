/**
 * BtContactRightInfo.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idBtContactRightView
    width: 535
    height: 305     //61 * 5
    //focus: true

    property int icon_y:            (5 == delegate_count) ? 13 : ((4 == delegate_count) ? 17 : 38)
    property int button_y:          (5 == delegate_count) ?  0 : ((4 == delegate_count) ?  0 : 0)
    property int firsttext_y:       (5 == delegate_count) ? 13 : ((4 == delegate_count) ? 20 : 38)
    property int button_height:     (5 == delegate_count) ? 65 : ((4 == delegate_count) ? 81 : 111)

    property string button_image:       "" //(5 == delegate_count) ? ImagePath.imgFolderBt_phone + "btn_contacts_list_s_n.png" : ((4 == delegate_count) ? ImagePath.imgFolderBt_phone + "btn_contacts_list_m_n.png" : ImagePath.imgFolderBt_phone + "btn_contacts_list_l_n.png")
    property string button_press_image: (5 == delegate_count) ? ImagePath.imgFolderBt_phone + "btn_contacts_list_s_p.png" : ((4 == delegate_count) ? ImagePath.imgFolderBt_phone + "btn_contacts_list_m_p.png" : ImagePath.imgFolderBt_phone + "btn_contacts_list_l_p.png")
    property string button_focus_image: (5 == delegate_count) ? ImagePath.imgFolderBt_phone + "btn_contacts_list_s_f.png" : ((4 == delegate_count) ? ImagePath.imgFolderBt_phone + "btn_contacts_list_m_f.png" : ImagePath.imgFolderBt_phone + "btn_contacts_list_l_f.png")


    /* INTERNAL functions */
    function clickHandler(number, type) {
        if("" == number) {
            // TODO: error handling
            return;
        }

        if("" == favoriteAdd) {
            // 휴대폰 통화
            //__IQS_15MY_ Call End Modify
            if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                /* 통화중 추가 통화 막음
                 */
                MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
            } else {
                BtCoreCtrl.HandleCallStart(number);
            }
        } else {
            // 즐겨찾기 등록
            if(9 < BtCoreCtrl.m_nCountFavoriteContactsList) {
                // 10개 이상 등록할 수 없음
                MOp.showPopup("popup_Bt_Favorite_Max");
            } else {
                if(false == favoriteButtonPress) {
                    favoriteButtonPress = true
                    BtCoreCtrl.invokeTrackerAddFavoriteFromPhonebook(add_favorite_index, type, number); // 즐겨찾기 Event
                } else {

                }
            }
        }
    }

    function setIcons(type) {
        if(1 == type) {
            return ImagePath.imgFolderBt_phone + "ico_contact_list_mobile.png";
        } else if(2 == type) {
            return ImagePath.imgFolderBt_phone + "ico_contact_list_home.png";
        } else if(3 == type) {
            return ImagePath.imgFolderBt_phone + "ico_contact_list_office.png";
        } else {
            return ImagePath.imgFolderBt_phone + "ico_contact_list_other.png";
        }
    }


    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onPhonebookSearch: {
            // 최근통화목록 -> 전화번호부 이동 할때 포커스 설정
            btn_contact3_1.forceActiveFocus();
        }
    }


    /* EVENT handlers */
    onActiveFocusChanged: {
        if(idBtContactRightView.activeFocus == false) {
            btn_contact3_1.focus = true;
            btn_contact3_2.focus = false;
            btn_contact3_3.focus = false;
            btn_contact3_4.focus = false;
            btn_contact3_5.focus = false;
        }
    }


    /* WIDGETS */
    // 1st. line
    Image {
        id: calltype_icon3_1
        source: setIcons(contact_type_1)
        x: 10 + 18
        z: 1
        anchors.top: btn_contact3_1.top
        anchors.topMargin: icon_y
    }

    MComp.MButtonHaveTicker {
        id: btn_contact3_1
        x: 0
        y: button_y
        width: 567
        height: button_height
        focus: true

        bgImage: button_image
        bgImagePress: button_press_image
        bgImageFocus: button_focus_image

        firstText: MOp.checkPhoneNumber(phoneNum)
        firstTextX: 90 + 18
        firstTextY: firsttext_y
        firstTextHeight: 36
        firstTextSize: 36
        firstTextWidth: ("" == favoriteAdd) ? 369 : 325
        firstTextAlies: "Left"
        firstTextElide: "Right"
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextColor: colorInfo.brightGrey

        tickerEnable: true

        onFirstTextChanged: {
            calltype_icon3_1.source = setIcons(contact_type_1);
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "ico_add_l.png"
            x: 478 + 18
            y: delegate_count <= 3 ? 31 : delegate_count == 4 ? 10 : 6
            z: 1
            visible: ("" == favoriteAdd) ? false : true
        }

        onClickOrKeySelected: {
            btn_contact3_1.forceActiveFocus();
            idBtContactRightView.clickHandler(phoneNum, contact_type_1);
        }

        onWheelLeftKeyPressed: {
        }

        onWheelRightKeyPressed: {
            if(1 == delegate_count) {
                btn_contact3_1.forceActiveFocus();
            } else {
                btn_contact3_2.forceActiveFocus();
            }
        }

        onActiveFocusChanged: {
            // 하단 비쥬얼 큐 삭제 Issue List #573
            if(true == btn_contact3_1.activeFocus) {
                idVisualCue.setVisualCue(true, false, false, true);
            }
        }

        onVisibleChanged: {
            if(false == btn_contact3_1.visible) {
                if(true == btn_contact3_1.activeFocus) {
                    btn_contact3_1.forceActiveFocus();
                }
            }
        }
    }

    // Mid-line
    Image {
        source: ImagePath.imgFolderBt_phone + "contact_list_line.png"
        x: 0
        width: 521
        height: 3
        visible: 2 <= delegate_count
        anchors.top: btn_contact3_1.bottom
        anchors.topMargin: (5 == delegate_count) ? -2 : ((4 == delegate_count) ? 0 : -3)
    }

    // 2nd. line
    Image {
        id: calltype_icon3_2
        source: setIcons(contact_type_2)
        x: 10 + 18
        z: 1
        visible: delegate_count >= 2
        anchors.top: btn_contact3_2.top
        anchors.topMargin: icon_y

        onVisibleChanged: {
            if(btn_contact3_2.visible == false) {
                btn_contact3_2.focus = false
                btn_contact3_1.focus = true
            }
        }
    }

    MComp.MButtonHaveTicker {
        id: btn_contact3_2
        x: 0
        width: 567
        height: button_height
        visible: delegate_count >= 2
        anchors.top: btn_contact3_1.bottom
        anchors.topMargin: button_y

        bgImage: button_image
        bgImagePress: button_press_image
        bgImageFocus: button_focus_image

        firstText: MOp.checkPhoneNumber(homeNum)
        firstTextX: 90 + 18
        firstTextY: firsttext_y
        firstTextHeight: 36
        firstTextSize: 36
        firstTextWidth: ("" == favoriteAdd) ? 369 : 325
        firstTextAlies: "Left"
        firstTextElide: "Right"
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextColor: colorInfo.brightGrey

        tickerEnable: true

        onFirstTextChanged: {
            calltype_icon3_2.source = setIcons(contact_type_2);
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "ico_add_l.png"
            x: 478 + 18
            y: (delegate_count <= 3) ? 31 : (delegate_count == 4) ? 10 : 8
            z: 1
            visible: ("" == favoriteAdd) ? false : true
        }

        onClickOrKeySelected: {
            btn_contact3_2.forceActiveFocus();
            idBtContactRightView.clickHandler(homeNum, contact_type_2);
        }

        //KeyNavigation.up: btn_contact3_1
        //KeyNavigation.down: btn_contact3_3.visible == true ? btn_contact3_3 : btn_contact3_2

        onWheelLeftKeyPressed: btn_contact3_1.forceActiveFocus()
        onWheelRightKeyPressed: {
/*DEPRECATED
            if(delegate_count == 2) {
                btn_contact3_1.forceActiveFocus()
            } else
DEPRECATED*/
            if(delegate_count >= 3) {
                btn_contact3_3.forceActiveFocus()
            }
        }

        onActiveFocusChanged: {
            // 하단 비쥬얼 큐 삭제 Issue List #573
            if(true == btn_contact3_2.activeFocus) {
                idVisualCue.setVisualCue(true, false, false, true);
            }
        }

        onVisibleChanged: {
            if(false == btn_contact3_2.visible) {
                if(true == btn_contact3_2.activeFocus) {
                    btn_contact3_1.forceActiveFocus();
                }
            }
        }
    }

    // Mid-line
    Image {
        source: ImagePath.imgFolderBt_phone + "contact_list_line.png"
        x: 0
        width: 521
        height: 3
        visible: delegate_count >= 3
        anchors.top: btn_contact3_2.bottom
        anchors.topMargin: (5 == delegate_count) ? -2 : ((4 == delegate_count) ? 0 : -3)
    }

    // 3rd. row
    Image {
        id: calltype_icon3_3
        source: setIcons(contact_type_3)
        x: 10 + 18
        z: 1
        visible: delegate_count >= 3
        anchors.top: btn_contact3_3.top
        anchors.topMargin: icon_y

        onVisibleChanged: {
            if(btn_contact3_3.visible == false) {
                btn_contact3_3.focus = false
                btn_contact3_1.focus = true
            }
        }
    }

    MComp.MButtonHaveTicker {
        id: btn_contact3_3
        x: 0
        width: 567
        height: button_height
        anchors.top: btn_contact3_2.bottom
        anchors.topMargin: button_y
        visible: delegate_count >= 3
        bgImage: button_image
        bgImagePress: button_press_image
        bgImageFocus: button_focus_image

        firstText: MOp.checkPhoneNumber(officeNum)
        firstTextX: 90 + 18
        firstTextY: firsttext_y
        firstTextHeight: 36
        firstTextSize: 36
        firstTextWidth: ("" == favoriteAdd) ? 369 : 325
        firstTextAlies: "Left"
        firstTextElide: "Right"
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextColor: colorInfo.brightGrey

        tickerEnable: true

        onFirstTextChanged: {
            calltype_icon3_3.source = setIcons(contact_type_3);
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "ico_add_l.png"
            x: 478 + 18
            y: delegate_count <= 3 ? 31 : delegate_count == 4 ? 10 : 6
            z: 1
            visible: ("" == favoriteAdd) ? false : true
        }

        onClickOrKeySelected: {
            btn_contact3_3.forceActiveFocus();
            idBtContactRightView.clickHandler(officeNum, contact_type_3);
        }

        //KeyNavigation.up: btn_contact3_2
        //KeyNavigation.down: btn_contact3_4.visible == true ? btn_contact3_4 : btn_contact3_3

        onWheelLeftKeyPressed: btn_contact3_2.forceActiveFocus()
        onWheelRightKeyPressed: {
/*DEPRECATED
            if(gContactsInfo.count == 3) {
                btn_contact3_1.forceActiveFocus()
            } else
DEPRECATED*/
            if(delegate_count >= 4) {
                btn_contact3_4.forceActiveFocus()
            }
        }

        onActiveFocusChanged: {
            // 하단 비쥬얼 큐 삭제 Issue List #573
            if(true == btn_contact3_3.activeFocus) {
                idVisualCue.setVisualCue(true, false, false, true);
            }
        }

        onVisibleChanged: {
            if(false == btn_contact3_3.visible) {
                if(true == btn_contact3_3.activeFocus) {
                    btn_contact3_1.forceActiveFocus();
                }
            }
        }
    }

    // Mid-line
    Image {
        source: ImagePath.imgFolderBt_phone + "contact_list_line.png"
        x: 0
        width: 521
        height: 3
        visible: delegate_count >= 4
        anchors.top: btn_contact3_3.bottom
        anchors.topMargin: (5 == delegate_count) ? -2 : ((4 == delegate_count) ? 0 : -3)
    }

    // 4th. row
    Image {
        id: calltype_icon3_4
        source: ""      //setIcons(contact_type_4)
        x: 10 + 18
        z: 1
        visible: delegate_count >= 4
        anchors.top: btn_contact3_4.top
        anchors.topMargin: icon_y

        onVisibleChanged: {
            if(btn_contact3_4.visible == false) {
                btn_contact3_4.focus = false
                btn_contact3_1.focus = true
            }
        }
    }

    MComp.MButtonHaveTicker {
        id: btn_contact3_4
        x: 0
        width: 567
        height: button_height
        visible: delegate_count >= 4
        anchors.top: btn_contact3_3.bottom
        anchors.topMargin: button_y

        bgImage: button_image
        bgImagePress: button_press_image
        bgImageFocus: button_focus_image

        firstText: MOp.checkPhoneNumber(otherNum)
        firstTextX: 90 + 18
        firstTextY: firsttext_y
        firstTextHeight: 36
        firstTextSize: 36
        firstTextWidth: ("" == favoriteAdd) ? 369 : 325
        firstTextAlies: "Left"
        firstTextElide: "Right"
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextColor: colorInfo.brightGrey

        tickerEnable: true

        onFirstTextChanged: {
            calltype_icon3_4.source = setIcons(contact_type_4);
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "ico_add_l.png"
            x: 478 + 18
            y: delegate_count == 4 ? 10 : 6
            z: 1
            visible: ("" == favoriteAdd) ? false : true
        }

        onClickOrKeySelected:  {
            btn_contact3_4.forceActiveFocus();
            idBtContactRightView.clickHandler(otherNum, contact_type_4);
        }

        //KeyNavigation.up:   btn_contact3_3
        //KeyNavigation.down: btn_contact3_5.visible == true ? btn_contact3_5 : btn_contact3_4

        onWheelLeftKeyPressed: btn_contact3_3.forceActiveFocus()
        onWheelRightKeyPressed: {
/*DEPRECATED
            if(gContactsInfo.count == 4) {
                btn_contact3_1.forceActiveFocus()
            } else 
DEPRECATED*/
            if(delegate_count >= 5) {
                btn_contact3_5.forceActiveFocus()
            }
        }

        onActiveFocusChanged: {
            // 하단 비쥬얼 큐 삭제 Issue List #573
            if(true == btn_contact3_4.activeFocus) {
                idVisualCue.setVisualCue(true, false, false, true);
            }
        }

        onVisibleChanged: {
            if(false == btn_contact3_4.visible) {
                if(true == btn_contact3_4.activeFocus) {
                    btn_contact3_1.forceActiveFocus();
                }
            }
        }
    }

    // Mid-line
    Image {
        source: ImagePath.imgFolderBt_phone + "contact_list_line.png"
        x: 0
        width: 521
        height: 3
        visible: delegate_count >= 5
        anchors.top: btn_contact3_4.bottom
        anchors.topMargin: (5 == delegate_count) ? -2 : ((4 == delegate_count) ? 0 : -3)
    }

    // 5th. row
    Image {
        id: calltype_icon3_5
        source: ""      //setIcons(contact_type_5)
        x: 10 + 18
        z: 1
        visible: delegate_count >= 5
        anchors.top: btn_contact3_5.top
        anchors.topMargin: icon_y

        onVisibleChanged: {
            if(btn_contact3_5.visible == false) {
                btn_contact3_5.focus = false
                btn_contact3_1.focus = true
            }
        }
    }

    MComp.MButtonHaveTicker {
        id: btn_contact3_5
        width: 567
        x: 0
        height: button_height
        visible: delegate_count >= 5
        anchors.top: btn_contact3_4.bottom
        anchors.topMargin: button_y

        bgImage: button_image
        bgImagePress: button_press_image
        bgImageFocus: button_focus_image

        firstText: MOp.checkPhoneNumber(other2Num)
        firstTextX: 90 + 18
        firstTextY: firsttext_y
        firstTextHeight: 36
        firstTextSize: 36
        firstTextWidth: ("" == favoriteAdd) ? 369 : 325
        firstTextAlies: "Left"
        firstTextElide: "Right"
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextColor: colorInfo.brightGrey

        tickerEnable: true

        onFirstTextChanged: {
            calltype_icon3_5.source = setIcons(contact_type_5);
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "ico_add_l.png"
            x: 478 + 18
            y: 6
            z: 1
            visible: ("" == favoriteAdd) ? false : true
        }

        onClickOrKeySelected: {
            btn_contact3_5.forceActiveFocus();
            idBtContactRightView.clickHandler(other2Num, contact_type_5);
        }

        onWheelLeftKeyPressed: btn_contact3_4.forceActiveFocus()
        onWheelRightKeyPressed: {
            //btn_contact3_1.forceActiveFocus();
        }

        onActiveFocusChanged: {
            if(true == btn_contact3_5.activeFocus) {
                idVisualCue.setVisualCue(true, false, false, true);
            }
        }

        onVisibleChanged: {
            if(false == btn_contact3_5.visible) {
                if(true == btn_contact3_5.activeFocus) {
                    btn_contact3_1.forceActiveFocus();
                }
            }
        }
    }
}
/* EOF */
