/**
 * /BT/Dial/Main/BtDialListDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MButtonHaveTicker
{
    id: idDelegate
    width: 524
    height: 110

    /* Ticker Enable! */
    tickerEnable: true

    bgImage: ""
    bgImagePress: ImagePath.imgFolderBt_phone + "dial_list_p.png"
    bgImageFocus: ImagePath.imgFolderBt_phone + "dial_list_f.png"
    bgImageX: 0
    bgImageY: 1
    bgImageWidth: 524
    bgImageHeight: 113

    lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
    lineImageX: 3
    lineImageY: 110

    firstText: {
        // 전화번호부에서 이름이 없는 경우 번호 출력하도록 수정
        if(true == replacedName) {
            // 전화번호가 이름으로 대체된 경우라면 - 삽입
            MOp.checkPhoneNumber(contactName);
        } else {
            contactName
        }
    }

    firstTextX: 23
    firstTextY: 17
    firstTextWidth: 470
    firstTextHeight: 40
    firstTextSize: 40
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextColor: colorInfo.brightGrey
    firstTextElide: "Right"
    firstTextAlies: "Left"

    // 하이라이팅 되는 텍스트
    Text {
        id: delegateSubText
        text: {
            if(true == MOp.containsNumber(number1, phoneNumInput)) {
                MOp.getHighlightNumber(MOp.checkPhoneNumber(number1), phoneNumInput);
            } else if(true == MOp.containsNumber(number2, phoneNumInput)) {
                MOp.getHighlightNumber(MOp.checkPhoneNumber(number2), phoneNumInput);
            } else if(true == MOp.containsNumber(number3, phoneNumInput)) {
                MOp.getHighlightNumber(MOp.checkPhoneNumber(number3), phoneNumInput);
            } else if(true == MOp.containsNumber(number4, phoneNumInput)) {
                MOp.getHighlightNumber(MOp.checkPhoneNumber(number4), phoneNumInput);
            } else {
                MOp.getHighlightNumber(MOp.checkPhoneNumber(number5), phoneNumInput);
            }
        }

        x: 23
        y: 69
        width: 470
        height: 30
        color: colorInfo.buttonGrey
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        font.pointSize: 30
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
    }

    // 포커스 텍스트
    Text {
        id: delegateSubFocusText
        text: {
            if(true == MOp.containsNumber(number1, phoneNumInput)) {
                MOp.checkPhoneNumber(number1)
            } else if(true == MOp.containsNumber(number2, phoneNumInput)) {
                MOp.checkPhoneNumber(number2)
            } else if(true == MOp.containsNumber(number3, phoneNumInput)) {
                MOp.checkPhoneNumber(number3)
            } else if(true == MOp.containsNumber(number4, phoneNumInput)) {
                MOp.checkPhoneNumber(number4)
            } else {
                MOp.checkPhoneNumber(number5)
            }
        }

        x: 23
        y: 69
        width: 470
        height: 30
        color: colorInfo.brightGrey
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        font.pointSize: 30
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        visible: (true == idDelegate.activeFocus) ? true : false
    }

    onClickOrKeySelected: {
        /* Dial 리스트에서 항목 선택 되는 동작은 입력 모드에 따라 다름 터치모드와 조그 모드가 다름
         */
        if(9 < BtCoreCtrl.m_ncallState) {
            // 통화중 다이얼화면 진입이 불가능해져 실행이 불가능한 코드
            MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
        } else {
            if("jog" == inputMode) {
                /* Jog 모드 > 선택된 번호를 입력창에 완성한 후 Call버튼으로 포커스 이동 */
                sigSetDialFocus();

                if(true == MOp.containsNumber(number1, phoneNumInput)) {
                    phoneNumInput = number1;
                } else if(true == MOp.containsNumber(number2, phoneNumInput)) {
                    phoneNumInput = number2;
                } else if(true == MOp.containsNumber(number3, phoneNumInput)) {
                    phoneNumInput = number3;
                } else if(true == MOp.containsNumber(number4, phoneNumInput)) {
                    phoneNumInput = number4;
                } else {
                    phoneNumInput = number5;
                }

                BtCoreCtrl.invokeTrackerSearchNominatedDial(phoneNumInput);
            } else {
                /* 터치 모드 > 통화 실행 */
                if(BtCoreCtrl.m_strConnectedDeviceName != "") {
                    if(BtCoreCtrl.m_ncallState > 9 ) {
                        /* 통화중일 경우 진입 막음
                        */
                        MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                    } else {
                        /*블루 링크 통화 중이지 않은 경우 일반 BT 통화 발생
                         */
                        if(true == MOp.containsNumber(number1, phoneNumInput)) {
                            phoneNumInput = number1;
                        } else if(true == MOp.containsNumber(number2, phoneNumInput)) {
                            phoneNumInput = number2;
                        } else if(true == MOp.containsNumber(number3, phoneNumInput)) {
                            phoneNumInput = number3;
                        } else if(true == MOp.containsNumber(number4, phoneNumInput)) {
                            phoneNumInput = number4;
                        } else {
                            phoneNumInput = number5;
                        }

                        BtCoreCtrl.HandleCallStart(phoneNumInput);
                    }
                }
            }
        }
    }
}
/* EOF */
