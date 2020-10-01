/**
 * MPopupTypeList.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../Common/Javascript/operation.js" as MOp


MComp.MPopup
{
    id: idMPopupTypeList
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    property alias button1Enabled: idButton1.mEnabled

    // SIGNALS
    //DEPRECATED signal popupBgClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();


    /* EVENT handlers */
    Component.onCompleted:{
        if(0 == chineseKeypadTypeDeviceName) {
            idBtn3.forceActiveFocus();
        } else {
            idBtn1.forceActiveFocus();
        }
    }


    onVisibleChanged: {
        if(0 == chineseKeypadTypeDeviceName) {
            idBtn3.forceActiveFocus();
        } else {
            idBtn1.forceActiveFocus();
        }
    }

    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: "Black"
        opacity: 0.6
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_a.png"
        x: 93
        y: 208 - systemInfo.statusBarHeight
        width: 1093
        height: 304
        focus: true

            MComp.MButtonHaveTicker {
                id: idBtn1
                x: 26
                y: 69
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"
                focus: true

                firstText: stringInfo.str_Keypad_Pinyin//"全拼"//"병음" "Pinyin input"
                firstTextX: 43
                firstTextY: 26
                firstTextWidth: 610
                firstTextHeight: 32
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                tickerEnable: true

                lineImage: ImagePath.imgFolderPopup + "list_line.png"
                lineImageX: 10
                lineImageY: 82

                onClickOrKeySelected: {
                    if(false == keypadPress || inputMode != "jog") {
                        chineseKeypadTypeDeviceName = 0
                        MOp.hidePopup();
                        keypadPress = false
                    } else {
                        keypadPress = false
                    }
                }


                Image {
                    source: 0 == chineseKeypadTypeDeviceName ? ImagePath.imgFolderSettings + "btn_radio_s.png" : ImagePath.imgFolderSettings + "btn_radio_n.png"
                    x: 671
                    y: 15
                    z: 1
                    width: 51
                    height: 52
                }

                onWheelRightKeyPressed: {
                    idBtn3.forceActiveFocus();
                }
                KeyNavigation.right: idButton1
            }

            MComp.MButtonHaveTicker {
                id: idBtn3
                x: 26
                y: 69 + 85
                width: 740
                height: 85
                bgImagePress: ImagePath.imgFolderPopup + "list_p.png"
                bgImageFocus: ImagePath.imgFolderPopup + "list_f.png"

                firstText: stringInfo.str_Keypad_Hand//"手写"//"필기인식" "Handwritten input"
                firstTextX: 43
                firstTextY: 26
                firstTextWidth: 610
                firstTextHeight: 32
                firstTextSize: 32
                firstTextColor: colorInfo.brightGrey

                tickerEnable: true

                onClickOrKeySelected: {
                    if(false == keypadPress || inputMode != "jog") {
                        chineseKeypadTypeDeviceName = 2
                        MOp.hidePopup();
                        keypadPress = false
                    } else {
                        keypadPress = false
                    }
                }


                Image {
                    source: 2 == chineseKeypadTypeDeviceName ? ImagePath.imgFolderSettings + "btn_radio_s.png" : ImagePath.imgFolderSettings + "btn_radio_n.png"
                    x: 671
                    y: 15
                    z: 1
                    width: 51
                    height: 52
                }

                onWheelLeftKeyPressed: {
                    idBtn1.forceActiveFocus();
                }
                KeyNavigation.right: idButton1
            }

        MComp.MButton {
            id: idButton1
            x: 780
            y: 18
            width: 295
            height: 268
            focus: mEnabled
            visible: true

            bgImage:        (1 == UIListener.invokeGetVehicleVariant() && true == idButton1.activeFocus) ? ImagePath.imgFolderPopup + "btn_type_a_01_nf.png" : ImagePath.imgFolderPopup + "btn_type_a_01_n.png"
            bgImagePress:   ImagePath.imgFolderPopup + "btn_type_a_01_p.png"
            bgImageFocus:   ImagePath.imgFolderPopup + "btn_type_a_01_f.png"

            fgImage: ImagePath.imgFolderPopup + "light.png"
            fgImageX: -2
            fgImageY: 99
            fgImageWidth: 69
            fgImageHeight: 69
            fgImageVisible: true == idButton1.activeFocus

            firstText: stringInfo.str_Bt_Cancel
            firstTextX: 52
            firstTextY: 116
            firstTextWidth: 210
            firstTextHeight: 36
            firstTextSize: 36
            firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey

            onClickOrKeySelected: {
                MOp.hidePopup();
            }

            KeyNavigation.left: 0 == chineseKeypadTypeDeviceName ? idBtn1 : idBtn3
        }
    }
    onBackKeyPressed: {MOp.hidePopup();}
}
/* EOF */
