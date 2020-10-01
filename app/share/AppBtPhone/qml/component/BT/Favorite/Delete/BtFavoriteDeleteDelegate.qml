/**
 * BtFavoriteDeleteDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MButtonHaveTicker
{
    id: idBtFavoriteDelegate
    x: 0
    width: 992
    height: 90

    /* Ticker Enable! */
    tickerEnable: true


    // 터치 시 포커스 사라지던 부분 > 사양 변경으로 코드 변경
    // buttonFocus: index == idBtFavoriteDelListView.currentIndex && idBtFavoriteDelegate.activeFocus

    Component.onCompleted: {
        // 저장된 정보가 Sim Card에 있는 경우 Icon 변경 하게 되는 부분
        if(storageType == 1){
            if(1 == type1) {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_mobile_sim_n.png"
            } else if(2 == type1) {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_home_sim_n.png"
            } else if(3 == type1) {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_office_sim_n.png"
            } else {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_other_sim_n.png"
            }
        } else {
            if(1 == type1) {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_mobile_n.png"
            } else if(2 == type1) {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_home_n.png"
            } else if(3 == type1) {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_office_n.png"
            } else {
                idBtFavoriteDelegate.fgImage = ImagePath.imgFolderBt_phone + "ico_fav_other_n.png"
            }
        }
    }

    bgImage: ""
    bgImagePress:   ImagePath.imgFolderGeneral + "edit_list_01_p.png"
    bgImageFocus:   ImagePath.imgFolderGeneral + "edit_list_01_f.png"
    bgImageX: 14
    bgImageY: -2
    bgImageWidth: 992
    bgImageHeight: 97

    lineImage: ImagePath.imgFolderGeneral + "edit_list_line.png"
    lineImageX: 9
    lineImageY: 90

    fgImage: ImagePath.imgFolderBt_phone + "ico_fav_mobile_n.png"
    fgImageX: 56
    fgImageY: 26
    fgImageWidth: 40
    fgImageHeight: 40

    /* 전화번호부에서 이름이 없는 경우 번호 출력하도록 수정
     */
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

    firstTextX: 118
    firstTextY: 25
    firstTextSize: 40
    firstTextWidth: 376
    firstTextHeight: 40
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextColor: colorInfo.brightGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusColor: colorInfo.brightGrey
    firstTextClip: false
    firstTextAlies: "Left"
    firstTextElide: "Right"

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

    secondTextX: 514
    secondTextY: 25
    secondTextSize: 40
    secondTextWidth: 374
    secondTextHeight: 40
    secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    secondTextColor: colorInfo.brightGrey
    secondTextPressColor: colorInfo.brightGrey
    secondTextFocusColor: colorInfo.brightGrey
    secondTextClip: false
    secondTextAlies: "Right"
    secondTextElide: "Right"
    secondTextFocusVisible: idBtFavoriteDelegate.activeFocus == true

    Image{
        source: selected ? ImagePath.imgFolderGeneral + "checkbox_check.png" : ImagePath.imgFolderGeneral + "checkbox_uncheck.png"
        x: 939 - 25
        y: 90 - 66
        width: 44
        height: 44
        MouseArea {
            anchors.fill: parent;
            onReleased: {
                if(false == menuOn){
                    if(true == selected) {
                        favoriteSelectInt = favoriteSelectInt - 1;
                        BtCoreCtrl.invokeSetFavoriteSelect(index, false);
                    } else {
                        favoriteSelectInt = favoriteSelectInt + 1;
                        BtCoreCtrl.invokeSetFavoriteSelect(index, true);
                    }

                    idBtFavoriteDelegate.forceActiveFocus();
                    idBtFavoriteDelListView.currentIndex = index;

                    if(true == idBtFavoriteDelegate.mEnabled) {
                        if(false == idBtFavoriteDelegate.active){
                            idBtFavoriteDelegate.state = "STATE_RELEASED"
                        }
                    }
                }
            }

            onPressed: {
                if(true == idBtFavoriteDelegate.mEnabled) {
                    idBtFavoriteDelegate.state = "STATE_PRESSED"
                }
            }
        }
    }

    Image {
        source: ImagePath.imgFolderGeneral + "checkbox_check.png"
        x: 939 - 25
        y: 90 - 66
        width: 44
        height: 44
        visible: ("popup_delete_all" == popupState) ? true : false
    }

    onClickOrKeySelected: {
        // true --> false(or false --> true)
        if(true == selected) {
            favoriteSelectInt = favoriteSelectInt - 1;
            BtCoreCtrl.invokeSetFavoriteSelect(index, false);
        } else {
            favoriteSelectInt = favoriteSelectInt + 1;
            BtCoreCtrl.invokeSetFavoriteSelect(index, true);
        }

        idBtFavoriteDelegate.forceActiveFocus();
        idBtFavoriteDelListView.currentIndex = index;
    }
}
/* EOF */
