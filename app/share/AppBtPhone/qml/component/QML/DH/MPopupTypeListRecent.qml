/**
 * /QML/DH/MPopupTypeLisyRecent.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MPopup
{
    id: idMPopupTypeList
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // PROPERTIES
    property string popupName: ""


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeList.visible) {
            idListButton1.forceActiveFocus();
            popupBackGroundBlack = true
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeList.visible) {
            idListButton1.forceActiveFocus();
            popupBackGroundBlack = true
        }
    }

    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 208 - systemInfo.statusBarHeight;
        width: 1093
        height: 304

        /* 최근 통화 목록 팝업 상단 타이틀 삭제
        // Hidden
        Text {
            id: hiddenText
            text: gRecentsInfo.name + " " + gRecentsInfo.number
            height: 44
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenterl
            color: colorInfo.brightGrey
            visible: false
        }

        Text {
            id: idTitle1Line
            text: gRecentsInfo.name + " " + gRecentsInfo.number
            x: 55
            y: 67
            visible: hiddenText.width < 983
            width: 983
            height: 44
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }

        Text {
            id: idTitle2Line1
            text: gRecentsInfo.name
            x: 55
            y: 37
            width: 983
            height: 44
            visible: hiddenText.width > 982
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }

        Text {
            id: idTitle2Line2
            text: gRecentsInfo.number
            x: 55
            y: 97
            width: 983
            height: 44
            visible: hiddenText.width > 982
            font.pointSize: 44
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }
        */

        MButton {
            id: idListButton1
            x: 26
            y: 69
            width: 740
            height: 82

            bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
            bgImageX: 5
            bgImageY: 0
            bgImageWidth: 740
            bgImageHeight: 85

            lineImage: ImagePath.imgFolderPopup + "list_line.png"
            lineImageX: 0
            lineImageY: 82

            firstText: stringInfo.view_phonebook
            firstTextX: 43
            firstTextY: 27
            firstTextWidth: 677 //654 가이드 상의 넓이 임의의 넓이 677
            firstTextHeight: 32
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextSize: 32
            firstTextAlies: "Left"
            firstTextColor: colorInfo.subTextGrey

            onClickOrKeySelected: {
                if(downloadContact == true) {
                    MOp.showPopup("popup_Bt_Downloading_Phonebook");
                } else {
                    MOp.hidePopup();
                    //DEPRECATED BtCoreCtrl.invokeTrackerSearchPhonebookIndex(select_recent_call_type, callhistory_add_favorite_index)
                    BtCoreCtrl.invokeTrackerSearchPhonebookIndex(select_recent_call_type, gRecentsInfo.index);
                }
            }

            KeyNavigation.right: idButton1
            onWheelRightKeyPressed: idListButton2.forceActiveFocus()
        }

        MButton {
            id: idListButton2
            x: 26
            y: 151
            width: 740
            height: 85

            bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
            bgImageX: 5
            bgImageY: 0
            bgImageWidth: 740
            bgImageHeight: 85

            firstText: stringInfo.str_Bt_Menu_Add_Favorite
            firstTextX: 43
            firstTextY: 27
            firstTextWidth: 677 //654 가이드 상의 넓이 임의의 넓이 677
            firstTextHeight: 32
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextSize: 32
            firstTextAlies: "Left"
            firstTextColor: colorInfo.subTextGrey

            onClickOrKeySelected: {
                if(true == downloadContact) {
                    MOp.showPopup("popup_Bt_Downloading_Phonebook");
                } else if(BtCoreCtrl.m_nCountFavoriteContactsList > 9) {
                    MOp.showPopup("popup_Bt_Favorite_Max");
                } else {
                    BtCoreCtrl.invokeTrackerAddFavoriteFromCallHistory(select_recent_call_type, gRecentsInfo.index)
                }
            }

            KeyNavigation.right: idButton1
            onWheelLeftKeyPressed: idListButton1.forceActiveFocus()
        }

        MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: 268

            bgImage: (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -2
            fgImageY: 99
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            firstText: stringInfo.str_Bt_Cancel
            firstTextX: 52
            firstTextY: 116
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextAlies: "Center"
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                MOp.hidePopup();
            }

            KeyNavigation.left: idListButton1
        }
    }

    onBackKeyPressed: {
        MOp.hidePopup();
    }
}
/* EOF */
