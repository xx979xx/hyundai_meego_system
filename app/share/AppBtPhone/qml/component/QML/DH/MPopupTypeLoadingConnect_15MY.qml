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
    property string popupThirdBtnText: ""
    property int popupBtnCnt: 3     //# 0 or 1
    property int popupLineCnt: 2    //# 1 or 2
    property bool black_opacity: true
    property string deviceName: ""

    // SIGNALS
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
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
            height: popupBtnCnt == 1 ? 343 : popupBtnCnt == 2 ? 171 : 116
            bgImage: popupBtnCnt == 1 ?
                      20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePathArab.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_a_01_n.png" : (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png" :
                            popupBtnCnt == 2 ?
                            20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_02_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_02_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_02_n.png" :
                            20 == gLanguage ? (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_04_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_04_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_04_n.png"
            bgImagePress: popupBtnCnt == 1 ?
                      20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_a_01_p.png" : ImagePath.imgFolderPopup + "btn_type_a_01_p.png" :
                            popupBtnCnt == 2 ?
                            20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_02_p.png" : ImagePath.imgFolderPopup + "btn_type_b_02_p.png" :
                            20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_04_p.png" : ImagePath.imgFolderPopup + "btn_type_b_04_p.png"
            bgImageFocus: popupBtnCnt == 1 ?
                      20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_a_01_f.png" : ImagePath.imgFolderPopup + "btn_type_a_01_f.png" :
                            popupBtnCnt == 2 ?
                            20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_02_f.png" : ImagePath.imgFolderPopup + "btn_type_b_02_f.png" :
                            20 == gLanguage ? ImagePathArab.imgFolderPopup + "btn_type_b_04_f.png" : ImagePath.imgFolderPopup + "btn_type_b_04_f.png"

            visible: popupBtnCnt > 0
            focus: true

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 20 == gLanguage ? popupBtnCnt == 2 ? 232 : 240 : popupBtnCnt == 2 ? -7 : -14
            fgImageY: popupBtnCnt == 2 ? 54 : 26
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton1.activeFocus == true

            firstText: popupFirstBtnText
            firstTextX: 20 == gLanguage ? 26 : 52
            firstTextY: popupBtnCnt == 1 ? 153 : popupBtnCnt == 2 ? 71 : 41
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
            y: popupBtnCnt == 2 ? 189 : 134;
            width: 295;
            height: popupBtnCnt == 2 ? 171 : 110 ;
            visible: popupBtnCnt >= 2

            bgImage:        popupBtnCnt == 2 ?
                                20 == gLanguage ?  (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_03_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_03_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_03_n.png" :
                                20 == gLanguage ?  (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_05_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_05_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_05_n.png"
            bgImagePress:   popupBtnCnt == 2 ?
                                20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_03_p.png" : ImagePath.imgFolderPopup + "btn_type_b_03_p.png" :
                                20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_05_p.png" : ImagePath.imgFolderPopup + "btn_type_b_05_p.png"
            bgImageFocus:   popupBtnCnt == 2 ?
                                20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_03_f.png" : ImagePath.imgFolderPopup + "btn_type_b_03_f.png" :
                                20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_05_f.png" : ImagePath.imgFolderPopup + "btn_type_b_05_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 20 == gLanguage ? popupBtnCnt == 2 ? 233 : 230 : popupBtnCnt == 2 ? -7 : -2
            fgImageY: popupBtnCnt == 2 ? 54 : 26
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton2.activeFocus == true
            
            // 2줄로 임의 문구 수정
            Text {
                id: idButtonText2
                text: popupSecondBtnText
                x: 52
                y: popupBtnCnt == 2 ? 71 : 35
                height: (8 == gLanguage || 11 == gLanguage || 12 == gLanguage || 20 == gLanguage || 21 == gLanguage || 22 == gLanguage) ? 32 : 36
                width: 210
                font.pointSize: (8 == gLanguage || 11 == gLanguage || 12 == gLanguage || 20 == gLanguage || 21 == gLanguage || 22 == gLanguage) ? 32 : 36
                font.family: stringInfo.fontFamilyBold    //"HDB"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                lineHeight: 0.8
                //elide: Text.ElideRight
                color: colorInfo.brightGrey
            }
            // 2줄로 임의 문구 수정

            onClickOrKeySelected: {
                popupSecondBtnClicked();
            }

            onWheelLeftKeyPressed: idButton1.forceActiveFocus();
            onWheelRightKeyPressed: (true == idButton3.visible) ? idButton3.forceActiveFocus() : idButton2.forceActiveFocus()
        }

        MButton {
            id: idButton3
            x: 20 == gLanguage ? 18 : 780
            y: 244;
            width: 295;
            height: 117;
            visible: popupBtnCnt == 3

            bgImage:        20 == gLanguage ?  (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePathArab.imgFolderPopup + "btn_type_b_06_nf.png" : ImagePathArab.imgFolderPopup + "btn_type_b_06_n.png" : (1 == UIListener.invokeGetVehicleVariant() && (true == idButton1.activeFocus || true == idButton2.activeFocus || true == idButton3.activeFocus)) ? ImagePath.imgFolderPopup + "btn_type_b_06_nf.png" : ImagePath.imgFolderPopup + "btn_type_b_06_n.png"
            bgImagePress:   20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_06_p.png" : ImagePath.imgFolderPopup + "btn_type_b_06_p.png"
            bgImageFocus:   20 == gLanguage ?  ImagePathArab.imgFolderPopup + "btn_type_b_06_f.png" : ImagePath.imgFolderPopup + "btn_type_b_06_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: 20 == gLanguage ? 240 : -14
            fgImageY: 26
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: idButton3.activeFocus == true

            firstText: popupThirdBtnText
            firstTextX: 52
            firstTextY: 41
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                popupThirdBtnClicked();
            }

            onWheelLeftKeyPressed: idButton2.forceActiveFocus();
        }

        Text{
            id: idText1
            text: popupFirstText
            x: 20 == gLanguage ? popupBtnCnt == 0 ? 57 : 326 : 57
            y: 208
            width: (popupBtnCnt == 0) ? 439 + 541 : 309 + 401;
            height: 48
            font.pointSize: (6 == gLanguage || 7 == gLanguage || 2 == gLanguage || 3 == gLanguage)? 32 : 30
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
            y: (6 == gLanguage || 7 == gLanguage || 2 == gLanguage || 3 == gLanguage)? 295 : 313
            width: (0 == popupBtnCnt) ? 439 + 541 : 309 + 401;
            height: (6 == gLanguage || 7 == gLanguage || 2 == gLanguage || 3 == gLanguage)? 32 : 30
            font.pointSize: (6 == gLanguage || 7 == gLanguage || 2 == gLanguage || 3 == gLanguage)? 32 : 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: (true == BtCoreCtrl.m_bDisplayWaitInDeviceName)? colorInfo.subTextGrey : colorInfo.brightGrey
            font.family: (true == BtCoreCtrl.m_bDisplayWaitInDeviceName)? stringInfo.fontFamilyRegular : stringInfo.fontFamilyBold
            elide: Text.ElideRight
        }
    }
}
/* EOF */
