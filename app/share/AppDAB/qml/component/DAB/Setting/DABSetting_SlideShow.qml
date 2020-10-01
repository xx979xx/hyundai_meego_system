/**
 * FileName: DABSetting_SlideShow.qml
 * Author: HYANG
 * Time: 2013-01-15
 *
 * - 2013-01-15 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp

MComp.MComponent {
    id: idDabSetting_SlideShow

    Text{
        id: idTextSlideShow
        x: 710 - settingViewAreaX; y: 413 - systemInfo.headlineHeight - 32/2
        width: 510; height: 82
        text: stringInfo.strSettingSliceShow_Description
        color: colorInfo.brightGrey  //colorInfo.dimmedGrey
        font.family: idAppMain.fonts_HDR
        font.pixelSize: 32
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
    }
}
