/**
 * BtContactSearchDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MFavoriteDelegate
{
    id: idBtContactShearchDelegate
    x: 15
    width: 1238
    height: 90

    focus: (index == idBtContactSearchListView.currentIndex) ? true : false
    active: (index == idBtContactSearchListView.currentIndex) ? true : false

    function checkNumberType() {
        var NumType = 1;

        if(0 > matchNumber){
            if(number1 != "")
                NumType = type1;
            else if(number2 != "")
                NumType = type2;
            else if(number3 != "")
                NumType = type3;
            else if(number4 != "")
                NumType = type4;
            else
                NumType = type5;
        }else{
            if(matchNumber == 0)
                NumType = type1;
            else if(matchNumber == 1)
                NumType = type2;
            else if(matchNumber == 2)
                NumType = type3;
            else if(matchNumber == 3)
                NumType = type4;
            else
                NumType = type5;
        }

        switch(NumType)
        {
        case 1:
            if(storageType == 1) {
                return ImagePath.imgFolderBt_phone + "ico_fav_mobile_sim_n.png"
            }else{
                return ImagePath.imgFolderBt_phone + "ico_fav_mobile_n.png"
            }
            break;
        case 2:
            if(storageType == 1) {
                return ImagePath.imgFolderBt_phone + "ico_fav_home_sim_n.png"
            }else{
                return ImagePath.imgFolderBt_phone + "ico_fav_home_n.png"
            }
            break;
        case 3:
            if(storageType == 1) {
                return ImagePath.imgFolderBt_phone + "ico_fav_office_sim_n.png"
            }else{
                return ImagePath.imgFolderBt_phone + "ico_fav_office_n.png"
            }
            break;
        default:
            if(storageType == 1) {
                return ImagePath.imgFolderBt_phone + "ico_fav_other_sim_n.png"
            }else{
                return ImagePath.imgFolderBt_phone + "ico_fav_other_n.png"
            }
            break;
        }
    }

    /* Ticker Enable! */
    tickerEnable: true


    bgImage: ""
    bgImagePress: ImagePath.imgFolderGeneral + "list_p.png"
    bgImageFocus: ImagePath.imgFolderGeneral + "list_f.png"
    bgImageX: 15
    bgImageY: -2
    bgImageWidth: 1238
    bgImageHeight: 97

    lineImage: ImagePath.imgFolderGeneral + "list_line.png"
    lineImageX: 0
    lineImageY: 90

    firstText: {
        if(true == replacedName) {
            // 전화번호가 이름으로 대체된 경우
            if(0 > matchNumber) {
                // 이름에(이름 대신 전화번호가 저장되어 있는 상태) Matching 된 경우
                if(number1 != "") {
                    MOp.checkPhoneNumber(number1);
                } else if(number2 != "") {
                    MOp.checkPhoneNumber(number2);
                } else if(number3 != "") {
                    MOp.checkPhoneNumber(number3);
                } else if(number4 != "") {
                    MOp.checkPhoneNumber(number4);
                } else {
                    MOp.checkPhoneNumber(number5);
                }
            } else {
                // Matching된 번호를 대표번호로 삼아 이름대신 출력함
                if(0 == matchNumber) {
                    MOp.checkPhoneNumber(number1);
                } else if(1 == matchNumber) {
                    MOp.checkPhoneNumber(number2);
                } else if(2 == matchNumber) {
                    MOp.checkPhoneNumber(number3);
                } else if(3 == matchNumber) {
                    MOp.checkPhoneNumber(number4);
                } else {
                    MOp.checkPhoneNumber(number5);
                }
            }
       } else {
           contactName
       }
    }

    firstTextX: 512
    firstTextY: 28
    firstTextSize: 40
    firstTextWidth: 652
    firstTextHeight: 40
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextColor: colorInfo.brightGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextAlies: "Right"

    secondText: {
        if(true == replacedName) {
            // 전화번호가 이름으로 대체된 경우라면 전화번호를 출력하지 않음
        } else {
            if(0 > matchNumber) {
                if(number1 != "") {
                    MOp.checkPhoneNumber(number1);
                } else if(number2 != "") {
                    MOp.checkPhoneNumber(number2);
                } else if(number3 != "") {
                    MOp.checkPhoneNumber(number3);
                } else if(number4 != "") {
                    MOp.checkPhoneNumber(number4);
                } else {
                    MOp.checkPhoneNumber(number5);
                }
            } else {
                /* matchNumber가 0 이상인경우(-1 보다 큰 경우) 검색에서 전화번호가 매칭된 것으로 간주하고
                 * 해당 전화번호를 화면에 표시함
                 */
                if(0 == matchNumber) {
                    MOp.checkPhoneNumber(number1);
                } else if(1 == matchNumber) {
                    MOp.checkPhoneNumber(number2);
                } else if(2 == matchNumber) {
                    MOp.checkPhoneNumber(number3);
                } else if(3 == matchNumber) {
                    MOp.checkPhoneNumber(number4);
                } else {
                    MOp.checkPhoneNumber(number5);
                }
            }
        }
    }

    secondTextX: 119
    secondTextY: 28
    secondTextSize: 40
    secondTextWidth: 363
    secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    secondTextColor: colorInfo.brightGrey
    secondTextPressColor: colorInfo.brightGrey
    secondTextAlies: "Left"
    secondTextElide: "Left"

    onClickOrKeySelected: {
        if(idQwertyKeypad.isHide() == false) {
            idQwertyKeypad.hideQwertyKeypad();
        }

        delegate_count  = count;
        phoneName       = contactName;
        phoneNum        = number1;
        homeNum         = number2;
        officeNum       = number3;
        otherNum        = number4;
        other2Num       = number5;
        contact_type_1  = type1;
        contact_type_2  = type2;
        contact_type_3  = type3;
        contact_type_4  = type4;
        contact_type_5  = type5;

        if("" == favoriteAdd) {
            //__IQS_15MY_ Call End Modify
            if(BtCoreCtrl.m_ncallState > 9 || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                /* 통화중일 경우 진입 막음
                 */
                MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
            } else {
                /* Count의 개수에 따라 1개 일때 통화 동작 수행
                 * 2~3개 인 경우화 4개 이상 일 때 팝업의 모양이 달라 개수에 따라 다르게 처리되도록 적용
                 */
                if(2 > count) {
                    if("" != phoneNum) {
                        BtCoreCtrl.HandleCallStart(phoneNum);
                    } else if("" != homeNum) {
                        BtCoreCtrl.HandleCallStart(homeNum);
                    } else if("" != officeNum) {
                        BtCoreCtrl.HandleCallStart(officeNum);
                    } else if("" != otherNum){
                        BtCoreCtrl.HandleCallStart(otherNum);
                    } else {
                        BtCoreCtrl.HandleCallStart(other2Num);
                    }
                } else if(4 > count) {
                    MOp.showPopup("popup_phonebook_search_add");
                } else {
                    MOp.showPopup("popup_phonebook_search");
                }
            }
        } else {
            // 즐겨찾기 추가 상태인 경우
            first_name      = firstName;
            last_name       = lastName;
            formatted_name  = formattedName;

            if(2 > count) {
                BtCoreCtrl.invokeTrackerAddFavoriteFromSearch(first_name, last_name, formatted_name, contact_type_1, phoneNum )
            } else if(4 > count) {
                MOp.showPopup("popup_phonebook_search_add");
            } else {
                MOp.showPopup("popup_phonebook_search");
            }
        }

        idBtContactSearchListView.currentIndex = index;
    }

    Image {
        id: phoneImage
        source: checkNumberType()
        x: 1186
        y: 29
        width: 40
        height: 40
    }

    Image {
        source: ImagePath.imgFolderBt_phone + "ico_add_l.png"
        x: 40
        y: 22
        width: 50
        height: 50
        visible: "" != favoriteAdd
    }
}
/* EOF */
