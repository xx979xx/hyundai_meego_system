/**
 * /QML/DH/MPopupTypeLoadingConnect.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePathArab


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
    property alias popupLineHeight: idText1.lineHeight
    property string popupSecondText: ""
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property int popupBtnCnt: 1     //# 0 or 1
    property int popupLineCnt: 2    //# 1 or 2
    property bool black_opacity: true
    property string deviceName: ""

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        } else {
            idButton2.focus = false
            idButton1.focus = true
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus();
            popupBackGroundBlack = black_opacity
        }
    }

//    onActiveFocusChanged: {
//        if(true == idMPopupTypeLoading.activeFocus) {
//            idButton1.forceActiveFocus();
//            popupBackGroundBlack = black_opacity
//        } else {
//            idButton2.focus = false
//            idButton1.focus = true
//        }
//    }

    onPopupBtnCntChanged: {
        idButton1.forceActiveFocus();
    }

    onBackKeyPressed: {
        hardBackKeyClicked();
    }

    /* Connections */
    Connections {
        target: idAppMain
        onSigshowPopup: {
            idButton2.focus = false
            idButton1.focus = true
        }
    }

    /* WIDGETS */
    Rectangle {
        width: parent.width;
        height: parent.height;
        color: colorInfo.black;
        opacity: black_opacity ? 0.6 : 1
    }

    Image {
        id: popup_bgImage
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93;
        y: 171 - systemInfo.statusBarHeight;
        width: 1093;
        height: 379;

        DDLoadingPopupAnimation {
            x: popupBtnCnt == 0 ?  496 : 20 == gLanguage ? 662 : 366
            y: 60
            z: 1
        }

        MButton {
            id: idButton1
            x: 20 == gLanguage ? 18 : 780
            y: 18
            width: 295
            height: popupBtnCnt == 1 ? 343 : 171
            bgImage: popupBtnCnt == 1 ?
                      20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePathArab.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_a_01_n.png" : (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" :
                      20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png"
            bgImagePress: popupBtnCnt == 1 ?
                      20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_a_01_p.png" : ImagePath.imgFolderPopup + "btn_type_a_01_p.png" :
                      20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_02_p.png" : ImagePath.imgFolderPopup + "btn_type_b_02_p.png"
            bgImageFocus: popupBtnCnt == 1 ?
                      20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_a_01_f.png" : ImagePath.imgFolderPopup + "btn_type_a_01_f.png" :
                      20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_02_f.png" : ImagePath.imgFolderPopup + "btn_type_b_02_f.png"

            visible: popupBtnCnt > 0
            focus: true

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 20 == gLanguage ? 232 : popupBtnCnt == 1 ? -2 : -7
            fgImageY: popupBtnCnt == 1 ? 136 : 54
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton1.activeFocus == true

            firstText: popupFirstBtnText
            firstTextX: 20 == gLanguage ? 26 : 52
            firstTextY: popupBtnCnt == 1 ? 153 : 71
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

            onWheelRightKeyPressed: (true == idButton2.visible) ? idButton2.forceActiveFocus() : idButton1.forceActiveFocus()
        }

        MButton {
            id: idButton2
            x: 20 == gLanguage ? 18 : 780
            y: 189;
            width: 295;
            height: 171;
            visible: popupBtnCnt == 2

            bgImage:        20 == gLanguage ?  (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png"
            bgImagePress:   20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_03_p.png" : ImagePath.imgFolderPopup + "btn_type_b_03_p.png"
            bgImageFocus:   20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_03_f.png" : ImagePath.imgFolderPopup + "btn_type_b_03_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 20 == gLanguage ? 232 : -7
            fgImageY: 54
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton2.activeFocus == true

            firstText: popupSecondBtnText
            firstTextX: 52
            firstTextY: 71
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();
        }

        Text{
            id: idText1
            text: popupFirstText
            x: 20 == gLanguage ? popupBtnCnt == 0 ? 57 : 326 : 57
            y: 208
            width: (popupBtnCnt == 0) ? 439 + 541 : 309 + 401;
            height:48
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
        }

        Text{
            id: idText2
            text: popupSecondText
            x: 20 == gLanguage ? popupBtnCnt == 0 ? 57 : 326 :57
            y: 295
            width: (0 == popupBtnCnt) ? 439 + 541 : 309 + 401;
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }
    }
}
/* EOF */
