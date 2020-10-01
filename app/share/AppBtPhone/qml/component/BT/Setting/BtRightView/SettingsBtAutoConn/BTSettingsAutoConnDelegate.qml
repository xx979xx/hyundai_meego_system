/**
 * /BT/Setting/BtRightView/SettingsBtAutoConn/BTSettingsAutoConnDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../../QML" as DDComp
import "../../../../QML/DH" as MComp
import "../../../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MButtonHaveTickerDelegate
{
    id:deviceConnectDelegate
    width: 547
    height: 89
    //focus: (id_auto_device_connect_list.currentIndex - 1 == index) ? true : false

    /* Ticker Enable! */
    tickerEnable: true


    //active: BtCoreCtrl.m_autoConnectMode == index + 1 ? true : false

    bgImage: ""
    bgImagePress: ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_p.png"
    bgImageFocus: ImagePath.imgFolderGeneral + "bg_menu_tab_r_02_f.png"
    bgImageX: 0
    bgImageY: -1
    bgImageWidth: 547
    bgImageHeight: 95

    lineImage: ImagePath.imgFolderGeneral + "line_menu_list.png"
    lineImageX: 9
    lineImageY: 89

//    fgImage:        ImagePath.imgFolderSettings + "btn_radio_n.png"
//    fgImagePress:   deviceConnectDelegate.active ? ImagePath.imgFolderSettings + "btn_radio_s.png" : ImagePath.imgFolderSettings + "btn_radio_n.png"
//    fgImageActive:  ImagePath.imgFolderSettings + "btn_radio_s.png"
//    fgImageFocus:   deviceConnectDelegate.active ? ImagePath.imgFolderSettings + "btn_radio_s.png" : ImagePath.imgFolderSettings + "btn_radio_n.png"
//    fgImageX: 473
//    fgImageY: 21        //89 - 45 - 23
//    fgImageWidth: 51
//    fgImageHeight: 52
//    fgImageFocusVisible: false


    DDComp.DDRadioBox {
        id: idNoSelectedRadioBox
        x: 473
        width: 51
        height: parent.height
        checkCondition: (BtCoreCtrl.m_autoConnectMode == index + 1)
    }

    firstText: deviceName
    firstTextWidth: 443
    firstTextX: 14
    firstTextY: 22      //90 - 45 - 20
    firstTextHeight: 46
    firstTextSize: 40
    firstTextColor: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey
    firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    firstTextElide: "Right"
    firstTextAlies: "Left"

    onActiveFocusChanged: {
        if(true == deviceConnectDelegate.activeFocus) {
            // focus -> in the listview
            if(0 == id_auto_device_connect_list.count || (id_auto_device_connect_list.count == id_auto_device_connect_list.currentIndex + 1)) {
                visualCueDownActive = false
            }
            idVisualCue.setVisualCue(true, false, false, true);
        } else {
            visualCueDownActive = true
        }
    }

    onClickOrKeySelected: {
        deviceConnectDelegate.forceActiveFocus();
        id_auto_device_connect_list.currentIndex = index

        // index + 1 becase index 0 is "No select"
        BtCoreCtrl.invokeSetAutoConnectMode(index + 1)
    }
}
/* EOF */
