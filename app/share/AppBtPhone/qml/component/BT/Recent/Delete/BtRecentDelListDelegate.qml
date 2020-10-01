/**
 * BtRecentDelListDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MButtonHaveTicker
{
    id: idBtRecentDeleteDelegate
    x: 0
    width: 992
    height: 90

    /* Ticker Enable! */
    tickerEnable: true

    bgImage: ""
    bgImagePress:   ImagePath.imgFolderGeneral + "edit_list_01_p.png"
    bgImageFocus:   ImagePath.imgFolderGeneral + "edit_list_01_f.png"
    bgImageX: 14
    bgImageY: -2
    bgImageWidth: 992
    bgImageHeight: 97

    lineImage: ImagePath.imgFolderGeneral + "edit_list_line.png"
    lineImageX: 0
    lineImageY: 90

    /* 터치 시 포커스 사라지던 부분 > 사양 변경으로 코드 변경
     */
    // buttonFocus: index == idBtRecentCallListView.currentIndex && idBtRecentDeleteDelegate.activeFocus

    firstText: {
        if("" != contactName) {
            contactName
        } else if(true == MOp.containsOnlyNumber(number)) {
            // 숫자(그리고 +, *)만 있는 경우에만 전화번호로 판단함
            MOp.checkPhoneNumber(number)
        } else {
            // 발신번호표시 제한 번호
            stringInfo.str_Spam
        }
    }
    firstTextX: 118
    firstTextY: 25
    firstTextWidth: 376
    firstTextHeight: 40
    firstTextColor: colorInfo.brightGrey
    firstTextSize: 40
    firstTextStyle: stringInfo.fontFamilyRegular
    firstTextAlies: "Left"
    firstTextElide: "Right"

    secondText: ("" != contactName) ? MOp.checkPhoneNumber(number) : ""
    secondTextX: 514
    secondTextY: 25
    secondTextWidth: 374
    secondTextHeight: 40
    secondTextSize: 40
    secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    secondTextColor: colorInfo.brightGrey
    secondTextPressColor: colorInfo.dimmedGrey
    secondTextFocusColor: firstTextColor
    // 최근 통화 목록 삭제 화면 번호 부분 우측 정렬
    secondTextAlies: "Right"
    secondTextElide: "Right"
    secondTextClip: false


    /* INTERNAL functions */
    function selectHandler() {
        if(true == selected) {
            recentSelectInt = recentSelectInt - 1;
            BtCoreCtrl.invokeSetCallHistorySelect(select_recent_call_type, index, false);
        } else {
            recentSelectInt = recentSelectInt + 1;
            BtCoreCtrl.invokeSetCallHistorySelect(select_recent_call_type, index, true);
        }

        idBtRecentDeleteDelegate.forceActiveFocus();
        idBtRecentCallListView.currentIndex = index;
    }


    /* EVENT handlers */
    Component.onCompleted : {
        switch(type) {
            case 1: imgCallType.source = ImagePath.imgFolderBt_phone + "ico_recent_sent.png";     break;
            case 3: imgCallType.source = ImagePath.imgFolderBt_phone + "ico_recent_missed.png";   break;

            case 2:
            default:
                imgCallType.source = ImagePath.imgFolderBt_phone + "ico_recent_recived.png";
                break;
        }
    }

    onClickOrKeySelected: {
        idBtRecentDeleteDelegate.selectHandler();
    }


    /* WIDGETS */
    Image {
        id: imgCallType
        source: ImagePath.imgFolderBt_phone + "ico_recent_sent.png"
        x: 40
        y: 11
        width: 71
        height: 71
    }

    Image{
        source: selected ? ImagePath.imgFolderGeneral + "checkbox_check.png" : ImagePath.imgFolderGeneral + "checkbox_uncheck.png"
        x: 939 - 25
        y: 90 - 66
        width: 44
        height: 44

        MouseArea {
            anchors.fill: parent;
            onClicked: idBtRecentDeleteDelegate.selectHandler();
        }
    }

    Image{
        source: ImagePath.imgFolderGeneral + "checkbox_check.png"
        x: 939 - 25
        y: 90 - 66
        width: 44
        height: 44
        visible: "popup_delete_all" == popupState
    }
}
/* EOF */