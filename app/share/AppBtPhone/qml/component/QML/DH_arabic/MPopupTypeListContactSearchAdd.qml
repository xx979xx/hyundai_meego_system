/**
 * MPopupTypeListContactSearchAdd.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
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
    property string popupBgImage: ImagePath.imgFolderPopup + "bg_type_d.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 168 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 384

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1    //# 1 or 2
    property QtObject idListModel
    property string listFirstItem
    property string popupTitleText

    property int popupLineCnt: idListView.count    //# 1 ~ limit
    property int overContentCount

    // SIGNALS
    signal popupClicked();
    signal popupBgClicked();
    signal popuplistItemClicked(int currentIndex);
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    signal btnclicked2_1();
    signal btnclicked2_2();
    signal btnclicked3_1();
    signal btnclicked3_2();
    signal btnclicked3_3();


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
    onClickOrKeySelected: {
        popupBgClicked();
    }

    Component.onCompleted: {
        /* 팝업은 2~3개만 나타나는 팝업인데, 현재 화면이 2개짜리면 2개짜리 첫 번째 포커스 가도록 하며,
         * 3개인 경우에는 3개 짜리 첫 번째 포커스 가도록 하는 코드
         */
        if(true == idMPopupTypeList.visible) {
            if(2 == delegate_count) {
                btn_list_Line02_01.forceActiveFocus();
            } else {
                btn_list_Line03_01.forceActiveFocus();
            }
        }
        popupBackGroundBlack = true
    }

    onVisibleChanged: {
        /* 팝업은 2~3개만 나타나는 팝업인데, 현재 화면이 2개짜리면 2개짜리 첫 번째 포커스 가도록 하며,
         * 3개인 경우에는 3개 짜리 첫 번째 포커스 가도록 하는 코드
         */
        if(true == idMPopupTypeList.visible) {
            if(2 == delegate_count) {
                btn_list_Line02_01.forceActiveFocus();
            } else {
                btn_list_Line03_01.forceActiveFocus();
            }
        }
        popupBackGroundBlack = true
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    Image {
        source: popupBgImage
        x: popupBgImageX
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight
        focus: true

        Text{
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
            elide: Text.ElideLeft
        }

        FocusScope {
            id: idList_2Line
            x: 327
            visible: 2 == delegate_count
            focus: 2 == delegate_count
            /*Image {
                source: ImagePath.imgFolderPopup + "bg_Type_b_f.png"
                width: 789
                height: 329
            }*/

            MButton {
                id: btn_list_Line02_01
                y: 149
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: true

                firstText: MOp.checkPhoneNumber(phoneNum)
                firstTextX: 80
                firstTextY: 27
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"
                firstTextElide: "Left"

                Image {
                    source: imageChange(contact_type_1)
                    x: 660
                    y: 19
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_Line02_01.focus = true;
                    btnclicked2_1();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 19
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelRightKeyPressed: btn_list_Line02_02.forceActiveFocus();
            }


            MButton {
                id: btn_list_Line02_02
                y: 149 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(homeNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"
                firstTextElide: "Left"

                Image {
                    source: imageChange(contact_type_2)
                    x: 36
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_Line02_02.focus = true;
                    btnclicked2_2();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 19
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelLeftKeyPressed: btn_list_Line02_01.forceActiveFocus();
            }

            KeyNavigation.left: idButton1
        }


        FocusScope {
            id: idList_3Line
            x: 327
            visible: 3 == delegate_count
            focus: 3 == delegate_count
            /*Image {
                source: ImagePath.imgFolderPopup + "bg_Type_b_f.png"
                width: 789
                height: 329
            }*/

            MButton {
                id: btn_list_Line03_01
                y: 104
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: true

                firstText: MOp.checkPhoneNumber(phoneNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"
                firstTextElide: "Left"

                Image {
                    source: imageChange(contact_type_1)
                    x: 647
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }
                onClickOrKeySelected: {
                    btn_list_Line03_01.focus = true;
                    btnclicked3_1();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelRightKeyPressed: btn_list_Line03_02.forceActiveFocus();
            }


            MButton {
                id: btn_list_Line03_02
                y: 104 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(homeNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"
                firstTextElide: "Left"

                Image {
                    source: imageChange(contact_type_2)
                    x: 647
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                onClickOrKeySelected: {
                    btn_list_Line03_02.focus = true;
                    btnclicked3_2();
                }

                Image {
                    source: ImagePath.imgFolderPopup + "list_line.png"
                    x: 36
                    y: 82
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onWheelLeftKeyPressed: btn_list_Line03_01.forceActiveFocus();
                onWheelRightKeyPressed: btn_list_Line03_03.forceActiveFocus();
            }


            MButton {
                id: btn_list_Line03_03
                y: 104 + 82 + 82
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: MOp.checkPhoneNumber(officeNum)
                firstTextX: 80
                firstTextY: 82 - 39 - 16
                firstTextWidth: 567
                firstTextHeight: 32
                firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey
                firstTextAlies: "Right"
                firstTextElide: "Left"

                Image {
                    source: imageChange(contact_type_3)
                    x: 647
                    y: 82 - 39 - 24
                    width: 50
                    height: 50
                }

                Image {
                    source: ImagePath.imgFolderPopup + "ico_add.png"
                    x: 22
                    y: 82 - 39 - 24
                    width: 45
                    height: 46
                    visible: "" != favoriteAdd
                }

                onClickOrKeySelected: {
                    btn_list_Line03_03.focus = true;
                    btnclicked3_3();
                }

                onWheelLeftKeyPressed: btn_list_Line03_02.forceActiveFocus();

            }

            KeyNavigation.left: idButton1
        }

        //****************************** # Popup Button #
        MButton {
            id: idButton1
            x: 18
            y: 98
            width: 295
            height: 268

            bgImage: (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 226
            fgImageY: 99
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY: 232 - 98 - 18
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            KeyNavigation.right: 3 === delegate_count ? idList_3Line : idList_2Line

            onClickOrKeySelected: {
                MOp.hidePopup();
            }
        }
    }
}
/* EOF */
