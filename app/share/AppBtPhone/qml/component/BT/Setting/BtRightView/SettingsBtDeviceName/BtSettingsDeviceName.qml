/**
 * BtSettingsDeviceName.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH" as MComp
import "../../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: id_device_info
    x: -9
    y: 3
    width: 577
    height: 534 - 3
    clip: true
    focus: true

    onVisibleChanged: {
        if(true == id_device_info.visible) {
            checkedCallViewStateChange = 0;
            btn_bt_ini.focus = false
            btn_bt_pincode.focus = false
            btn_bt_devicename.focus = true
        }
    }

    onActiveFocusChanged: {
        if(true == id_device_info.activeFocus) {
            visualCueDownActive = false
        } else {
            visualCueDownActive = true
        }
    }

    Flickable {
        width: 567
        height: 534
        focus: true
        flickableDirection: Flickable.VerticalFlick
        /* WIDGETS */

        onFlickEnded: {
            btn_bt_devicename.forceActiveFocus();
            MOp.returnFocus();
        }

        MComp.MButtonHaveTicker {
            id: btn_bt_devicename
            width: 567
            height: 148
            focus: true

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_2line_02_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_2line_02_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 567
            bgImageHeight: 148

            /* Ticker Enable! */
            tickerEnable: true

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: -1
            lineImageY: 142

            firstText: stringInfo.str_Device_Name_Setting
            firstTextX: 23
            firstTextY: 33      //148 - 47 - 48 - 20
            firstTextWidth: 524
            firstTextHeight: 40
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextFocusColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextAlies: "Left"
            firstTextElide: "Right"

            secondText: BtCoreCtrl.m_strBtLocalDeviceName
            secondTextX: 23
            secondTextY: 148 - 47 - 20
            secondTextWidth: 534
            secondTextHeight: 40
            secondTextSize: 40
            secondTextColor: colorInfo.dimmedGrey
            secondTextFocusColor: colorInfo.brightGrey
            secondTextPressColor: secondTextColor
            secondTextAlies: seccondtickerAvailable? "Left" : "Right"
            secondTextElide: "Right"

            secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"

            onClickOrKeySelected: {
                btn_bt_devicename.forceActiveFocus();

                console.log("[QML]BtSettingsDeviceName.qml - Line:89 = onClickOrKeySelected")

                if(false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                    MOp.showPopup("popup_search_while_driving");
                } else {
                    keypadChange();
                    pushScreen("SettingsBtNameChange", 519);
                }
            }

            onWheelLeftKeyPressed: {
                //btn_bt_ini.forceActiveFocus()
            }

            onWheelRightKeyPressed: btn_bt_pincode.forceActiveFocus()

            onActiveFocusChanged: {
                if(true == btn_bt_devicename.activeFocus) {
                    idVisualCue.setVisualCue(true, false, false, true);
                }
            }
        }

        MComp.MButtonHaveTicker {
            id: btn_bt_pincode
            y: 142
            width: 567
            height: 148

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_2line_02_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_2line_02_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 567
            bgImageHeight: 148

            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: -1
            lineImageY: 142

            firstText: stringInfo.str_Passkey_Btn
            firstTextX: 23      //14 + 9
            firstTextY: 148 - 47 - 48 - 20  //90 - 45 - 20
            firstTextWidth: 524
            firstTextHeight: 40
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextFocusColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextAlies: "Left"
            firstTextElide: "Right"

            secondText: BtCoreCtrl.m_strPINcode
            secondTextX: 14
            secondTextY: 148 - 47 - 20
            secondTextWidth: 534
            secondTextHeight: 40
            secondTextSize: 40
            secondTextColor: colorInfo.dimmedGrey
            secondTextFocusColor: colorInfo.brightGrey
            secondTextPressColor: secondTextColor
            secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            secondTextAlies: "Right"
            secondTextElide: "Right"

            onClickOrKeySelected: {
                btn_bt_pincode.forceActiveFocus();

                if(false == parking && (1 == UIListener.invokeGetCountryVariant() || 6 == UIListener.invokeGetCountryVariant())) {
                    MOp.showPopup("popup_search_while_driving");
                } else {
                    //setMainAppScreen("SettingsBtPINCodeChange", true)
                    pushScreen("SettingsBtPINCodeChange", 520);
                }
            }

            onWheelLeftKeyPressed:  btn_bt_devicename.forceActiveFocus()
            onWheelRightKeyPressed: btn_bt_ini.forceActiveFocus()

            onActiveFocusChanged: {
                if(true == btn_bt_pincode.activeFocus) {
                    idVisualCue.setVisualCue(true, false, false, true);
                }
            }
        }

        MComp.MButtonHaveTicker {
            id: btn_bt_ini
            y: 142 + 142  //89 + 89
            width: 567
            height: 89

            bgImage: ""
            bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_p.png"
            bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_f.png"
            bgImageX: 0
            bgImageY: -1
            bgImageWidth: 567
            bgImageHeight: 95


            /* Ticker Enable! */
            tickerEnable: true


            lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
            lineImageX: 9
            lineImageY: 89

            firstText: stringInfo.str_Bt_Ini
            firstTextX: 25
            firstTextY: 25  //90 - 45 - 20
            firstTextWidth: 524
            firstTextHeight: 40
            firstTextSize: 40
            firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
            firstTextFocusColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
            firstTextAlies: "Left"
            firstTextElide: "Right"

            onClickOrKeySelected: {
                btn_bt_ini.forceActiveFocus();

                //BtCoreCtrl.invokeCheckResetSettings()
                MOp.showPopup("popup_bt_checkbox_ini");
            }

            onWheelLeftKeyPressed:  btn_bt_pincode.forceActiveFocus()
            onWheelRightKeyPressed: {
                //btn_bt_devicename.forceActiveFocus();
            }

            onActiveFocusChanged: {
                if(true == btn_bt_ini.activeFocus) {
                    idVisualCue.setVisualCue(true, false, false, true);
                }
            }
        }
    }
    //DEPRECATED KeyNavigation.up: idSettingsBand
}
/* EOF */

