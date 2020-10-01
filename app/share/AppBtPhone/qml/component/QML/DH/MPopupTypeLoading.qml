/**
 * MPopupTypeLoading.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


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

    property int popupTextX: 57
    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 1     //# 0 or 1
    property int popupLineCnt: 2    //# 1 or 2

    property bool black_opacity: true
    property bool clickCheck: false

    // SIGNALS
    signal popupFirstBtnClicked()
    signal popupSecondBtnClicked()
    signal hardBackKeyClicked()


    /* EVENT handlers */
    Component.onCompleted:{
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus()
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus()
            popupBackGroundBlack = black_opacity
        }
    }

    onPopupBtnCntChanged: {
        idButton1.forceActiveFocus();
    }


    /* WIDGETS */
    Rectangle {
        width: parent.width;
        height: parent.height
        color: colorInfo.black;
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 208 - systemInfo.statusBarHeight
        width: 1093
        height: 304

        DDLoadingAnimation {
            x: popupBtnCnt == 0 ? 57 + 439 : 57 + 309
            y: 50
        }

        MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: popupBtnCnt == 1 ? 268 : 127
            visible: popupBtnCnt == 1 || popupBtnCnt == 2;
            focus: true;

            bgImage: popupBtnCnt == 1 ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_02_n.png";
            bgImagePress: popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_p.png" : ImagePath.imgFolderPopup + "btn_type_a_02_p.png";
            bgImageFocus: popupBtnCnt == 1 ? ImagePath.imgFolderPopup + "btn_type_a_01_f.png" : ImagePath.imgFolderPopup + "btn_type_a_02_f.png";

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: popupBtnCnt == 1 ? -2 : -6
            fgImageY: popupBtnCnt == 1 ? 99 : 32
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.forceActiveFocus() : idButton2.forceActiveFocus()

            firstText: popupFirstBtnText
            firstTextX: 52
            firstTextY: popupBtnCnt == 1 ? 118 : 67
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupFirstBtnClicked();
            }
        }

        MButton {
            id: idButton2
            x: 780
            y: 152
            width: 295
            height: 134
            bgImage: (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_a_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_03_n.png"
            bgImagePress: ImagePath.imgFolderPopup + "btn_type_a_03_p.png"
            bgImageFocus: ImagePath.imgFolderPopup + "btn_type_a_03_f.png"
            visible: popupBtnCnt == 2

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -6
            fgImageY: 32
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton2.activeFocus

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();

            firstText: popupSecondBtnText
            firstTextX: 52
            firstTextY: 67
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }
        }

        Text{
            id: idText1
            text: popupFirstText
            x: 57
            y: popupLineCnt == 1 ? 50 + 170 - 32/2 : 50 + 148 - 32/2
            width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
        }

        Text{
            id: idText2
            text: popupSecondText
            x: 57
            y: 50 + 148 + 44 - 32/2
            width: 309 + 401
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            visible: popupLineCnt > 1
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }
}
/* EOF */
