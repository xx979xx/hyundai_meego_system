/**
 * BTSettingsDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH_arabic" as MComp
import "../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MButtonHaveTickerDelegate
{
    id: deviceConnectDelegate
    width: 547
    height: 89
    focus: true

    /* Ticker Enable! */
    tickerEnable: true


    bgImage: ""
    bgImagePress:   ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_p.png"
    bgImageFocus:   ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_f.png"
    bgImageX: 0
    bgImageY: -1
    bgImageWidth: 547
    bgImageHeight: 95

    lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
    lineImageX: 9
    lineImageY: 89

    firstText: deviceName
    firstTextWidth: 403
    firstTextX: 127
    firstTextY: 20
    firstTextHeight: 46
    firstTextSize: 40
    firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextAlies: "Right"
    firstTextElide: "Left"

    //[ITS 0269699] hidden divice포함 6개일때 hidden device 정보 노출되는 이슈수정
    visible: index>4 ? false : true

    onClickOrKeySelected: {
        id_paired_device.currentIndex = index;
        deviceConnectDelegate.forceActiveFocus();
        selectDevice = deviceId

        qml_debug("1. deviceName = " + deviceName);
        qml_debug("2. selectDevice = " + selectDevice);
        qml_debug("3. invokeGetConnectedDeviceID() = " + BtCoreCtrl.invokeGetConnectedDeviceID())
        qml_debug("4. invokeGetConnectingDeviceID() = " + BtCoreCtrl.invokeGetConnectingDeviceID())
        qml_debug("autoConnectStart = " + autoConnectStart);

        if(true == autoConnectStart) {
            // Auto connect start
            BtCoreCtrl.invokeSetConnectingDeviceName(deviceName);
            MOp.showPopup("popup_Bt_Connecting");
        } else {
            qml_debug("5. BtCoreCtrl.invokeGetConnectState() = " + BtCoreCtrl.invokeGetConnectState())
            if((4 /* CONNECT_STATE_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                || 10 /* CONNECT_STATE_PBAP_CONNECTED */ == BtCoreCtrl.invokeGetConnectState()
                || 11 /* CONNECT_STATE_PBAP_CONNECTING */ == BtCoreCtrl.invokeGetConnectState())
                    && selectDevice == BtCoreCtrl.invokeGetConnectedDeviceID()) {
                if(true == downloadContact) {
                    MOp.showPopup("popup_Bt_Phonebook_Downloading_Dis_Connect");
                } else if(true == downloadCallHistory) {
                    MOp.showPopup("popup_Bt_Callhistory_Downloading_Dis_Connect");
                } else {
                    MOp.showPopup("popup_Bt_Dis_Connection");
                }
            } else {
                // Connect start
                BtCoreCtrl.invokeSetStartConnectingFromHU(true);

                qml_debug("6. BtCoreCtrl.invokeIsAnyConnected() = " + BtCoreCtrl.invokeIsAnyConnected())
                if(true == BtCoreCtrl.invokeIsAnyConnected()) {
                    qml_debug("BtCoreCtrl.invokeSetConnectingDeviceID(selectDevice), selectDevice:" + selectDevice);
                    BtCoreCtrl.invokeSetConnectingDeviceID(selectDevice);
                    MOp.showPopup("popup_Bt_Other_Device_Connect");
                } else {
                    BtCoreCtrl.invokeSetConnectingDeviceName(deviceName);
                    BtCoreCtrl.invokeStartConnect(deviceId);
                    MOp.showPopup("popup_Bt_Connecting");
                }
            }
        }
    }

    onActiveFocusChanged: {
        if(true == deviceConnectDelegate.activeFocus) {
            idVisualCue.setVisualCue(true, true, true, false);
        } else if(false == parking) {
            idVisualCue.setVisualCue(true, true, false, false);
        }
    }


    Image {
        id: iconSlot1
        x: 10
        y: 18
        width: 58
        height: 56
        source: (deviceIsA2DPConnected) ? ImagePath.imgFolderBt_phone + "ico_music_n.png" : ImagePath.imgFolderBt_phone + "ico_music_d.png"

        onSourceChanged: {
            if(deviceIsA2DPConnected) {
                btA2DPConnect = true;
            } else {
                btA2DPConnect = false;
            }
        }
    }

    Image {
        id: iconSlot2
        x: 74
        y: 18
        width: 58
        height: 56
        source: (deviceIsHFPConnected) ? ImagePath.imgFolderBt_phone + "ico_handsfree_n.png" : ImagePath.imgFolderBt_phone + "ico_handsfree_d.png"

        onSourceChanged: {
            if(deviceIsHFPConnected) {
                btHFPConnect = true;
            } else {
                btHFPConnect = false;
            }
        }
    }
}
/* EOF */
