/**
 * FileName: DABSetting_ServiceFollowing.qml
 * Author: DaeHyungE
 * Time: 2012-07-17
 *
 * - 2012-07-17 Initial Crated by HyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation


MComp.MComponent {
    id: idDabSetting_ServiceFollowing

//    Text{
//        id: idTextServiceFollowing
//        x: 710 - settingViewAreaX; y: 295 - systemInfo.headlineHeight - 32
//        width: 510; height: 32
//        text: stringInfo.strSettingServiceFollowing_Title
//        color: colorInfo.brightGrey
//        font.family: idAppMain.fonts_HDR
//        font.pixelSize: 32
//        verticalAlignment: Text.AlignVCenter
//        horizontalAlignment: Text.AlignHCenter
//    }

    Text{
        id: idTextServiceFollowingDescription
        x: 710 - settingViewAreaX; y: 295 + 50 - 50 - systemInfo.headlineHeight - 32/2
        width: 510; height: 282
        text: stringInfo.strSettingServiceFollowing_Description
        color: colorInfo.brightGrey  //colorInfo.dimmedGrey
        font.family: idAppMain.fonts_HDR
        font.pixelSize: 32
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
    }
}
