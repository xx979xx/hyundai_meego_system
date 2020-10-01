/**
 * /QML/DH_arabic/MPopupTypeLoading3Line.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MPopup
{
    id: idMPopupTypeLoading
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    // PROPERTIES
    property int imageTimer: 1
    property string popupFirstText: ""
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property int popupBtnCnt: 1     //# 0 or 1
    property int popupLineCnt: 2    //# 1 or 2
    property bool black_opacity: true

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus()
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(idMPopupTypeLoading.visible == true) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

    onPopupBtnCntChanged: {
        idButton1.forceActiveFocus();
    }

    Rectangle {
        width: parent.width;
        height: parent.height;
        color: colorInfo.black;
        opacity: black_opacity ? 0.6 : 1
    }


    Image {
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93;
        y: 171 - systemInfo.statusBarHeight;
        width: 1093;
        height: 379;

        DDLoadingPopupAnimation {
            x: popupBtnCnt == 0 ?  496 : 662
            y: 60
        }

        MButton {
            id: idButton1
            x: 25
            y: 25
            width: 288
            height: popupBtnCnt == 1 ? 329 : 165
            bgImage: popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png"
            bgImagePress: popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_p.png" : ImagePath.imgFolderPopup + "btn_type_b_02_p.png"
            bgImageFocus: popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_f.png" : ImagePath.imgFolderPopup + "btn_type_b_02_f.png"
            visible: popupBtnCnt == 1 || popupBtnCnt == 2
            focus: true

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 226
            fgImageY: popupBtnCnt == 1 ? 129 : 47
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton1.activeFocus == true

            firstText: popupFirstBtnText
            firstTextX: 52
            firstTextY: popupBtnCnt == 1 ? 189 - 25 - 36 / 2 : 107 - 25 - 36 / 2
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextElide: "Right"

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }

            onWheelRightKeyPressed: idButton2.visible ? idButton2.forceActiveFocus() : idButton1.forceActiveFocus()
        }

        MButton {
            id: idButton2
            x: 25
            y: 25 + 164;
            width: 288;
            height: 165;
            visible: popupBtnCnt == 2

            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_b_03_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_b_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 226
            fgImageY: 47
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton2.activeFocus == true

            firstText: popupSecondBtnText
            firstTextX: 52
            firstTextY: 64
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();
        }

        Text{
            id: idText1
            text: popupFirstText
            x: popupBtnCnt == 0 ? 52 : 326
            y: 171 - systemInfo.statusBarHeight + 160
            width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
/* EOF */
