/**
 * /QML/DH_arabic/MPopupTypeDisconByPhone.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


// TODO: 정원 /QML/DH와 SYNC 필요
// 적용 이후 새로 작성 하도록 변경량 많음

MPopup
{
    id: idMPopupTypeText
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property bool black_opacity: true
    property alias popupFirstText: idText1.text
    property alias popupSecondText: idText2.text
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property string popupBgImage: (popupBtnCnt < 3) ? ImagePath.imgFolderPopup+"bg_type_a.png" : ImagePath.imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: (popupBtnCnt < 3) ? 208 - systemInfo.statusBarHeight : 171 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupBtnCnt < 3) ? 304 : 379

    property int popupBtnCnt: 2     //# 1 or 2 or 3 or 4
    property int popupLineCnt: 2    //# 1 or 2 or 3 or 4

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeText.visible) {
            idButton1.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeText.visible) {
            idButton1.forceActiveFocus();
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }


    /* Widgets */
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

        MButton {
            id: idButton1
            x: 18
            y: 18
            width: 295;
            height: popupBtnCnt == 1 ? 254 : popupBtnCnt == 2 ? 134 : popupBtnCnt == 3 ? 109 : 82
            bgImage: popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png" : popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_07_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_07_n.png" : ""
            bgImagePress: popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_a_01_p.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_07_p.png" : ""
            bgImageFocus: popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_a_01_f.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_07_f.png" : ""
            focus: true

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: popupBtnCnt == 1 ? 251 - 25 : popupBtnCnt == 2 ? 257 - 25 : popupBtnCnt == 3 ? 246 + 12 - 25 : 248 + 13 - 25
            fgImageY: popupBtnCnt == 1 ? 117 - 25 : popupBtnCnt == 2 ? 32 : popupBtnCnt == 3 ? 44 - 25 : 31 - 25
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            onWheelLeftKeyPressed: idButton2.focus = true

            firstText: popupFirstBtnText
            firstTextX: 26
            firstTextY: popupBtnCnt == 1 ? 152 - 25 - 18 : popupBtnCnt == 2 ? 85 - 25 - 18 : popupBtnCnt == 3 ? 77 - 25 - 18 : 66 - 25 - 18
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                idButton1.forceActiveFocus();
                popupFirstBtnClicked();
            }
        }

        MButton {
            id: idButton2
            x: 18
            y: popupBtnCnt == 2 ? 25 + 127 : popupBtnCnt == 3 ? 25 + 109 : 25 + 82
            width: 295;
            height: popupBtnCnt == 2 ? 134 : popupBtnCnt == 3 ? 109 : 82
            bgImage: popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png" : popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png" : popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus || true == idButton4.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_08_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_08_n.png" : ""
            bgImagePress: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_p.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup + "btn_type_b_05_p.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup + "btn_type_b_08_p.png" : ""
            bgImageFocus: popupBtnCnt == 2 ? ImagePath.imgFolderPopup + "btn_type_a_03_f.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup + "btn_type_b_05_f.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup + "btn_type_b_08_f.png" : ""
            visible: popupBtnCnt > 1

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: popupBtnCnt == 2 ? 257 - 25 : popupBtnCnt == 3 ? 257 - 25 : 248 - 25
            fgImageY: popupBtnCnt == 2 ? 50 + 134 - 25 - 127 : popupBtnCnt == 3 ? 44 + 110 - 25 - 110 : 31 + 82 - 25 - 82
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            onWheelRightKeyPressed: idButton1.focus = true

            firstText: popupSecondBtnText
            firstTextX: 26
            firstTextY: popupBtnCnt == 2 ? 85 + 134 - 25 - 127 - 18 : popupBtnCnt == 3 ? 77 + 110 - 25 - 109 - 18 : 66 + 82 - 25 - 82 - 18
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                idButton2.forceActiveFocus()
                popupSecondBtnClicked()
            }
        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            x: 361
            width: 644
            height: idText1.paintedHeight + idText2.paintedHeight + 10

            Text {
                id: idText1
                width: 654
                font.pointSize: 32
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
                elide: Text.ElideRight
            }

            Text {
                id: idText2
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                width: 654;
                font.pointSize: 32
                font.family: stringInfo.fontFamilyRegular    //"HDR"
                horizontalAlignment: Text.AlignRight
                color: colorInfo.subTextGrey
                wrapMode: Text.WordWrap
                lineHeight: 0.9
           }
        }
    }
}
/* EOF */
