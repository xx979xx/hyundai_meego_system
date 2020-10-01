/**
 * MPopupTypeTextTitle.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: idMPopupTypeTextTitle
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupBgImage: (popupBtnCnt < 3) ? ImagePath.imgFolderPopup+"bg_type_d.png" :  ImagePath.imgFolderPopup+"bg_type_e.png"
    property int popupBgImageX: 93
    property int popupBgImageY:  (popupBtnCnt < 3) ? 168 - systemInfo.statusBarHeight : 131 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupBtnCnt < 3) ? 384 : 459

    property int popupTextX: popupBgImageX + 78
    property int popupTextSpacing: 44
    property string popupTitleText: ""
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1     //# 1 or 2 or 3 or 4
    property int popupLineCnt: 2    //# 1 or 2 or 3 or 4

    // SIGNALS
    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeTextTitle.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = true
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeTextTitle.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = true
        }
    }

    onClickOrKeySelected: {
        popupBgClicked();
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    Image {
        source: popupBgImage
        x: popupBgImageX
        y: popupBgImageY
        width: popupBgImageWidth
        height: popupBgImageHeight
    }

    Text {
        id: idTitle
        text: popupTitleText
        x: popupBgImageX + 55
        y: popupBgImageY + 59 - 44/2
        width: 983; height: 44
        font.pointSize: 44
        font.family: stringInfo.fontFamilyBold    //"HDB"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        elide: Text.ElideRight
    }

    MButton {
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 105
        width: 288;
        height: popupBtnCnt == 1 ? 254 : popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        bgImage: popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png" : popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png" : popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus || true == idButton4.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_07_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_07_n.png" : ""
        bgImagePress: popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_a_01_p.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_07_p.png" : ""
        bgImageFocus: popupBtnCnt == 1 ? ImagePath.imgFolderPopup+"btn_type_a_01_f.png" : popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_07_f.png" : ""
        focus: true

        fgImageX: popupBtnCnt == 1 ? 773 - 780 : popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 - 780 : 763 - 780
        fgImageY: popupBtnCnt == 1 ? 117 - 25 : popupBtnCnt == 2 ? 50 - 25 : popupBtnCnt == 3 ? 44 - 25 : 31 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: ImagePath.imgFolderPopup + "light.png"
        fgImageVisible: true == idButton1.activeFocus

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 1 ? 152 - 25 : popupBtnCnt == 2 ? 85 - 25 : popupBtnCnt == 3 ? 77 - 25 : 66 - 25
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

    MButton {
        id: idButton2
        x: popupBgImageX + 780
        y: popupBtnCnt == 2 ? popupBgImageY + 105 + 127 : popupBtnCnt == 3 ? popupBgImageY + 105 + 109 : popupBgImageY + 105 + 82
        width: 288;
        height: popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        bgImage: popupBtnCnt == 2 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png" : popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png" : popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus || true == idButton4.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_08_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_08_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_03_p.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_05_p.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_08_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? ImagePath.imgFolderPopup+"btn_type_a_03_f.png" : popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_05_f.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_08_f.png" : ""
        visible: popupBtnCnt > 1

        fgImageX: popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 + 12 - 780 : 763 + 13 - 780
        fgImageY: popupBtnCnt == 2 ? 50 + 134 - 25 - 127 : popupBtnCnt == 3 ? 44 + 110 - 25 - 110 : 31 + 82 - 25 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: ImagePath.imgFolderPopup + "light.png"
        fgImageVisible: true == idButton2.activeFocus

        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: popupBtnCnt > 2 ? idButton3.focus = true : idButton2.focus = true

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 2 ? 85 + 134 - 25 - 127 : popupBtnCnt == 3 ? 77 + 110 - 25 - 109 : 66 + 82 - 25 - 82
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
        x: popupBgImageX + 780
        y: popupBtnCnt == 3 ? popupBgImageY + 105 + 109 + 110 : popupBgImageY + 105 + 82 + 82;
        width: 288;
        height: popupBtnCnt == 3 ? 110 : 82;
        bgImage: popupBtnCnt == 3 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_06_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_06_n.png" : popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus || true == idButton4.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_09_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_09_n.png" : ""
        bgImagePress: popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_06_p.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_09_p.png" : ""
        bgImageFocus: popupBtnCnt == 3 ? ImagePath.imgFolderPopup+"btn_type_b_06_f.png" : popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_09_f.png" : ""
        visible: popupBtnCnt > 2

        fgImageX: popupBtnCnt == 3 ? 766 - 780 : 763 + 13 - 780
        fgImageY: popupBtnCnt == 3 ? 44 + 110 + 110 - 25 - 110 - 110 : 31 + 82 + 82 - 25 - 82 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: ImagePath.imgFolderPopup + "light.png"
        fgImageVisible: true == idButton3.activeFocus

        onWheelLeftKeyPressed: idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt > 3 ? idButton4.focus = true : idButton3.focus = true

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 3 ? 77 + 110 - 25 - 110 : 66 + 82 + 82 - 25 - 82 - 82
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
        id: idButton4
        x: popupBgImageX + 780
        y: popupBgImageY + 105 + 82 + 82 + 82;
        width: 288;
        height: 82;
        bgImage: popupBtnCnt == 4 ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus || true == idButton4.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_10_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_10_n.png" : ""
        bgImagePress: popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_10_p.png" : ""
        bgImageFocus: popupBtnCnt == 4 ? ImagePath.imgFolderPopup+"btn_type_b_10_f.png" : ""
        visible: popupBtnCnt > 3

        fgImageX: 763 - 780
        fgImageY: 31 + 82 + 82 + 82 - 25 - 82 - 82 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: ImagePath.imgFolderPopup + "light.png"
        fgImageVisible: true == idButton4.activeFocus

        onWheelLeftKeyPressed: idButton3.focus = true

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: 66 + 82 + 82 + 82 - 25 - 82 - 82 - 82
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

    Text {
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupLineCnt == 1 ? popupBtnCnt < 3 ? popupBgImageY + 232 - 32/2 : popupBgImageY + 269 - 32/2 : popupLineCnt == 2 ? popupBtnCnt < 3 ? popupBgImageY + 210 - 32/2 : popupBgImageY + 247 - 32/2 : popupLineCnt == 3 ? popupBtnCnt < 3 ? popupBgImageY + 188 - 32/2 : popupBgImageY + 225 - 32/2 : popupBtnCnt < 3 ? popupBgImageY + 166 - 32/2 : popupBgImageY + 203 - 32/2
        width: 654; height: 32
        font.pointSize: 32
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }

    Text {
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupLineCnt == 2 ? popupBtnCnt < 3 ? popupBgImageY + 210 + popupTextSpacing - 32/2 : popupBgImageY + 247 + popupTextSpacing - 32/2 : popupLineCnt == 3 ? popupBtnCnt < 3 ? popupBgImageY + 188 + popupTextSpacing - 32/2 : popupBgImageY + 225 + popupTextSpacing - 32/2 : popupBtnCnt < 3 ? popupBgImageY + 166 + popupTextSpacing - 32/2 : popupBgImageY + 203 + popupTextSpacing - 32/2
        width: 654; height: 32
        font.pointSize: 32
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
    }

    Text {
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupLineCnt == 3 ? popupBtnCnt < 3 ? popupBgImageY + 188 + popupTextSpacing + popupTextSpacing - 32/2 : popupBgImageY + 225 + popupTextSpacing + popupTextSpacing - 32/2 : popupBtnCnt < 3 ? popupBgImageY + 166 + popupTextSpacing + popupTextSpacing - 32/2 : popupBgImageY + 203 + popupTextSpacing + popupTextSpacing - 32/2
        width: 654; height: 32
        font.pointSize: 32
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 2
    }
}
/* EOF */
