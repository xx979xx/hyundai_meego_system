/**
 * MPopupTypeBluetoothCall.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MPopup
{
    id: idMPopupTypeBluetoothCall
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupName

    property string popupBgImage: (popupBtnCnt < 3) ? ImagePath.imgFolderPopup + "bg_type_a.png" : ImagePath.imgFolderPopup + "bg_type_b.png"
    property int popupBgImageY: (popupBtnCnt < 3) ? 208 - systemInfo.statusBarHeight : 171 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupBtnCnt < 3) ? 304 : 379

    property string popupFirstText: ""
    property string popupSecondText: ""
    property bool secondTextVisible: false

    property string popupFirstBtnText: ""
    property string popupFirstBtnSubText: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnSubText: ""
    property string popupThirdBtnText: ""

    property int popupBtnCnt: 1     //# 1 or 2 or 3

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeBluetoothCall.visible) {
            idButton1.forceActiveFocus();
            idText1.font.pointSize = 60;
        }
        popupBackGround = false
    }

    onVisibleChanged: {
        if(true == idMPopupTypeBluetoothCall.visible) {
            idButton1.forceActiveFocus();
            idText1.font.pointSize = 60;
        }
        popupBackGround = false
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: 1      //0.6
    }

    Image {
        source: popupBgImage
        x: 93
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight


        MCallPopupButton {
            id: idButton1
            x: 18
            y: 18
            width: 295;
            height: popupBtnCnt == 2 ? 134 : 116
            focus: true

            bgImage: popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png"
            bgImagePress: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_02_p.png" : ImagePath.imgFolderPopup+"btn_type_b_04_p.png"
            bgImageFocus: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_02_f.png" : ImagePath.imgFolderPopup+"btn_type_b_04_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: popupBtnCnt == 2 ? 233 : 240
            fgImageY: popupBtnCnt == 2 ? 32 : 26
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            onWheelLeftKeyPressed: {
                if(true == idButton2.visible) {
                    idButton2.forceActiveFocus();
                } else {
                    idButton1.forceActiveFocus();
                }
            }

            firstText: popupFirstBtnText
            firstTextX: 33
            firstTextY: popupBtnCnt == 2 ? 42 : 37
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }
        }

        MCallPopupButton {
            id: idButton2
            x: 18
            y: popupBtnCnt == 2 ? 152 : 134
            width: 295
            height: popupBtnCnt == 2 ? 134 : 110

            bgImage: popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png"
            bgImagePress: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_p.png" : ImagePath.imgFolderPopup + "btn_type_b_05_p.png"
            bgImageFocus: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_f.png" : ImagePath.imgFolderPopup + "btn_type_b_05_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: popupBtnCnt == 2 ? 228 : 233
            fgImageY: popupBtnCnt == 2 ? 32 : 26
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            onWheelRightKeyPressed: idButton1.focus = true
            onWheelLeftKeyPressed:{
                if(true == idButton3.visible) {
                    idButton3.forceActiveFocus();
                } else {
                    idButton2.forceActiveFocus();
                }
            }

            firstText: popupSecondBtnText
            firstTextX: 33
            firstTextY: popupBtnCnt == 2 ? 42 : 37
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }
        }

        MButton {
            id: idButton3
            x: 18
            y: 244
            width: 295
            height: 117
            visible: popupBtnCnt > 2

            bgImage:  (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_06_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_06_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_b_06_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_b_06_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 240
            fgImageY: popupBtnCnt == 3 ? 44 + 110 + 110 - 25 - 110 - 110 : 31 + 82 + 82 - 25 - 82 - 82
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton3.activeFocus

            onWheelRightKeyPressed: idButton2.focus = true

            firstText: popupThirdBtnText
            firstTextX: 33
            firstTextY: 37
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupThirdBtnClicked();
                // 3자통화에서 거절 선택 시 팝업이 먼저 사라지고 CallState가 변경되어 발생한 문제 수정
                //DEPRECATED MOp.hidePopup();
            }
        }

        Image {
            source: ImagePath.imgFolderPopup + "ico_receive.png"
            x: 924;
            y: (popupBtnCnt < 3) ? 75 : 99
            width: 113
            height: 135
        }

        Text {
            id: idText1
            text: popupFirstText
            x: 361
            y: if(popupBtnCnt < 3) {
                /* 버튼이 2개인 경우 조건문 (단일 통화)
                 */
                if("" != BtCoreCtrl.m_strPhoneName0) {
                    /* 전화번호부에 저장되어 있지 않은 경우
                     */
                    75 + 45 - 35
                } else {
                    75 + 74 - 35
                }
            } else {
                /* 버튼이 3개인 경우 조건문 (3자 통화)
                 */
                if("" != BtCoreCtrl.m_strPhoneName1) {
                    /* 전화번호부에 저장되어 있지 않은 경우
                     */
                    112 + 45 - 35
                } else {
                    112 + 74 - 35
                }
            }

            width: 499
            height: "" != BtCoreCtrl.m_strPhoneName1 ? 70 : 60
            font.pointSize: "" != BtCoreCtrl.m_strPhoneName1 ? 70 : 60
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            //elide: MOp.checkArab(popupFirstText) ? Text.ElideRight : Text.ElideLeft
            elide: Text.ElideRight

            onTextChanged: {
                console.log("idText1.paintSizeWidth = " + idText1.paintedWidth)
                console.log("idText1.pointSize = " + idText1.font.pointSize)

                if(499 > idText1.paintedWidth) {
                    idText1.font.pointSize = 60
                } else {
                    idText1.font.pointSize = 49
                }
            }
        }

        Text{
            id: idText2
            text: popupSecondText
            x: 361
            y: (popupBtnCnt < 3) ? 75 + 45 + 65 - 32 / 2 : 112 + 45 + 65 - 32 / 2
            width: 499
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            elide: Text.ElideRight
            visible: secondTextVisible
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }
}
/* EOF */
