/**
 * /BT/Setting/BtRightView/SettingsBtCustomer/BtSettingsCustomer.qml
 *
 */
import QtQuick 1.1


Item
{
    id: idCustomerMain
    x: 0
    y: 0
    width: 547
    height: systemInfo.lcdHeight - systemInfo.statusBarHeight
    clip: true
    focus: true

    Text {
        text: {
            switch(UIListener.invokeGetCountryVariant()) {
                case 0: // Korea
                    //(내수 HMC) stringInfo.str_Web_Korea
                    stringInfo.str_Center
                    break;

                case 1: // NorthAmerica
                    //(북미) stringInfo.str_Web_USA
                    stringInfo.str_Customer_USA + "\n" + stringInfo.url_USA_short
                    break;

                default:
                    stringInfo.str_Center
                    break;
            }
        }

        x: 3
        y: 247
        width: 510
        height: 32
        font.pointSize: 32
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        color: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
}
/* EOF */
