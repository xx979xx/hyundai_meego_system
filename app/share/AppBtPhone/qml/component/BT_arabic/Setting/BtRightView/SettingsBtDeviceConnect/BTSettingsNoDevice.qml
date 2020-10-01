/**
 * BTSettingsNoDevice.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH_arabic" as MComp
import "../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    x: 0
    y: 0
    width: 547
    height: systemInfo.lcdHeight - systemInfo.statusBarHeight
    clip: true
    focus: true

    Text {
        text: stringInfo.str_No_Paired_Device
        x: 42
        y: 221      //449 - 228
        width: 510  //64 + 446
        height: 32
        font.pointSize: 32
        color: (1 == UIListener.invokeGetVehicleVariant()) ? colorInfo.commonGrey : colorInfo.brightGrey
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    MComp.MButton2 {
        id: btn_bt_no_paired_device
        x: 116
        y: 449
        width: 372
        height: 71
        focus: true

        // 주행 중 버튼 비활성화 삭제 버튼 활성화 되고 버튼 선택 시 팝업 출력
        // mEnabled: (true == parking) ? true : false

        bgImage:        ImagePath.imgFolderSettings + "btn_ini_l_n.png"
        bgImagePress:   ImagePath.imgFolderSettings + "btn_ini_l_p.png"
        bgImageFocus:   ImagePath.imgFolderSettings + "btn_ini_l_f.png"

        firstText: stringInfo.str_New_Registration_Btn
        firstTextX: 14
        firstTextY: 17      //33 - 16
        firstTextWidth: 344
        firstTextSize: 32
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextColor: colorInfo.brightGrey
        firstTextAlies: "Center"

        onClickOrKeySelected: {
            if(true == parking) {
                BtCoreCtrl.invokeSetDiscoverableMode(true)
                MOp.showPopup("popup_Bt_SSP_Add");
            } else {
                // 주행 상태에서 발생되는 팝업
                MOp.showPopup("popup_restrict_while_driving");
            }
        }

        onActiveFocusChanged: {
            if(btn_bt_no_paired_device.activeFocus == true) {
                idVisualCue.setVisualCue(true, true, false, false);
            }
        }

        onMEnabledChanged: {
            if(false == btn_bt_no_paired_device.mEnabled && true == btn_bt_no_paired_device.activeFocus) {
                idLoaderSettingsLeft.forceActiveFocus();
            }
        }
    }
}
/* EOF */
