/**
 * BtDeviceListDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MButtonHaveTicker
{
    id: btn_device_list_delete_delegate
    width: 992
    height: 90

    /* Ticker Enable! */
    tickerEnable: true

    bgImage:            ""
    bgImagePress :      ImagePath.imgFolderGeneral + "edit_list_01_p.png"
    bgImageFocus :      ImagePath.imgFolderGeneral + "edit_list_01_f.png"
    bgImageX: 0
    bgImageY: -2
    bgImageWidth: 992
    bgImageHeight: 97

    lineImage: ImagePath.imgFolderGeneral + "edit_list_line.png"
    lineImageX: 14
    lineImageY: 90

    firstText: deviceName
    firstTextX: 74
    firstTextY: 26
    firstTextWidth: 864
    firstTextHeight: 40
    firstTextSize: 40
    firstTextColor: colorInfo.brightGrey
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextAlies: "Right"

    /* Connections */
    Connections {
        target: idAppMain

        onSelectAll:   { BtCoreCtrl.invokePairedDeviceSelect(deviceAddr, true) }
        onDeviceSelectUnAll: { BtCoreCtrl.invokePairedDeviceSelect(deviceAddr, false) }
    }

    Image {
        source: (deviceIsDelSelected && true == idBtDeviceDelMain.visible) ? ImagePath.imgFolderGeneral + "checkbox_check.png" : ImagePath.imgFolderGeneral + "checkbox_uncheck.png"
        x: 16 + 7
        y: 90 - 66
        width: 44
        height: 44

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                if(false == menuOn){
                    if(false == deviceIsDelSelected) {
                        deviceSelectInt = deviceSelectInt + 1
                        BtCoreCtrl.invokePairedDeviceSelect(deviceAddr, true)
                    } else {
                        deviceSelectInt = deviceSelectInt - 1
                        BtCoreCtrl.invokePairedDeviceSelect(deviceAddr, false)
                    }
                    btn_device_list_delete_delegate.forceActiveFocus();
                    idBtConnectDelListView.currentIndex = index;

                    if(true == btn_device_list_delete_delegate.mEnabled) {
                        if(false == btn_device_list_delete_delegate.active){
                            btn_device_list_delete_delegate.state = "STATE_RELEASED"
                        } else {
                            btn_device_list_delete_delegate.state = "STATE_PRESSED"
                        }
                    }
                }
            }

            onExited: {
                mouseAreaExit();
            }
        }
    }

    Image {
        source: ImagePath.imgFolderGeneral + "checkbox_check.png"
        x: 16 + 7
        y: 90 - 66
        width: 44
        height: 44
        visible: ("popup_bt_paired_device_delete_all" == popupState
                  || "popup_bt_conn_paired_device_all" == popupState) ? true : false
    }

    onClickOrKeySelected: {
        if(deviceIsDelSelected == false) {
            deviceSelectInt = deviceSelectInt + 1
            BtCoreCtrl.invokePairedDeviceSelect(deviceAddr, true)
        } else {
            deviceSelectInt = deviceSelectInt - 1
            BtCoreCtrl.invokePairedDeviceSelect(deviceAddr, false)
        }

        btn_device_list_delete_delegate.forceActiveFocus();
        idBtConnectDelListView.currentIndex = index;
    }
}
/* EOF */
