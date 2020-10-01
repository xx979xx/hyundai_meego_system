/**
 * BtFavoriteDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MButtonHaveTicker
{
    id: idBtFavoriteDelegateButton

    /* Ticker Enable! */
    tickerEnable: true


    // PROPERTIES
    property string list_bg_image
    property string list_press_image


    /* EVENT handlers */
    Component.onCompleted:{
        // 저장된 정보가 Sim Card에 있는 경우 Icon 변경 하게 되는 부분
        if(storageType == 1){
            if(1 == type1) {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_mobile_sim_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_mobile_sim_p.png"
            } else if(2 == type1) {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_home_sim_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_home_sim_p.png"
            } else if(3 == type1) {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_office_sim_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_office_sim_p.png"
            } else {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_other_sim_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_other_sim_p.png"
            }
        } else {
            if(1 == type1) {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_mobile_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_mobile_p.png"
            } else if(2 == type1) {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_home_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_home_p.png"
            } else if(3 == type1) {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_office_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_office_p.png"
            } else {
                list_bg_image = ImagePath.imgFolderBt_phone + "ico_fav_other_n.png"
                list_press_image = ImagePath.imgFolderBt_phone + "ico_fav_other_p.png"
            }
        }
    }

    x: 0
    width: 1238
    height: 90

    //focus: (index == idBtFavoriteListView.currentIndex) ? true : false
    active: (index == idBtFavoriteListView.currentIndex) ? true : false

    bgImage: ""
    bgImagePress:   ImagePath.imgFolderGeneral + "list_p.png"
    bgImageFocus:   ImagePath.imgFolderGeneral + "list_f.png"
    bgImageX: 14
    bgImageY: 0
    bgImageWidth: 1238
    bgImageHeight: 93

    lineImage: ImagePath.imgFolderGeneral + "list_line.png"
    lineImageX: 9
    lineImageY: 90

    fgImage: list_bg_image
    fgImagePress: list_press_image
    fgImageX: 54
    fgImageY: 26
    fgImageWidth: 40
    fgImageHeight: 40

    // 전화번호부에서 이름이 없는 경우 번호 출력하도록 수정
    firstText: {
        if(true == replacedName) {
            // 전화번호가 이름으로 대체된 경우라면 - 삽입
            MOp.checkPhoneNumber(contactName);
        } else {
            contactName
        }

/*DEPRECATED
        if("" != contactName) {
            contactName
        } else if(number1 != "") {
            MOp.checkPhoneNumber(number1)
        } else if(number2 != "") {
            MOp.checkPhoneNumber(number2)
        } else if(number3 != "") {
            MOp.checkPhoneNumber(number3)
        } else if(number4 != "") {
            MOp.checkPhoneNumber(number4)
        } else if(number5 != "") {
            MOp.checkPhoneNumber(number5)
        }
DEPRECATED*/
    }

    firstTextX: 115
    firstTextY: 26
    firstTextSize: 40
    firstTextWidth: 640
    firstTextHeight: 40
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextColor: colorInfo.brightGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusColor: colorInfo.brightGrey
    firstTextClip: false
    firstTextAlies: "Left"
    firstTextElide: "Right"
    firstTextBold: false //[ITS 0271270]

    secondText: {
        if(number1 != "") {
            MOp.checkPhoneNumber(number1)
        } else if(number2 != "") {
            MOp.checkPhoneNumber(number2)
        } else if(number3 != "") {
            MOp.checkPhoneNumber(number3)
        } else if(number4 != "") {
            MOp.checkPhoneNumber(number4)
        } else {
            MOp.checkPhoneNumber(number5)
        }
    }

    secondTextX: 777
    secondTextY: 26
    secondTextSize: 40
    secondTextWidth: 434
    secondTextHeight: 40
    secondTextAlies: "Right"
    secondTextElide: "Right"
    secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    secondTextPressColor: colorInfo.brightGrey
    secondTextColor: colorInfo.brightGrey
    secondTextFocusColor: colorInfo.brightGrey
    secondTextClip: false

    // buttonFocus: (true == idBtFavoriteDelegateButton.activeFocus) ? true : false

    onClickOrKeySelected: {
        idBtFavoriteListView.currentIndex = index;
        //__IQS_15MY_ Call End Modify
        if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
            /* 통화중일 경우 진입 막음
                 */
            MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
        } else {
            if(number1 != "") {
                BtCoreCtrl.HandleCallStart(number1);
            } else if(number2 != "") {
                BtCoreCtrl.HandleCallStart(number2);
            } else if(number3 != "") {
                BtCoreCtrl.HandleCallStart(number3);
            } else if(number4 != "") {
                BtCoreCtrl.HandleCallStart(number4);
            } else if(number5 != "") {
                BtCoreCtrl.HandleCallStart(number5);
            } else {
                qml_debug("all numbers are empty")
            }
        }
    }
}
/* EOF */
