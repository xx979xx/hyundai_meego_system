/**
 * FileName: DABSettingBand.qml
 * Author: HYANG
 * Time: 2013-01-14
 *
 * - 2013-01-14 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MBand {
    id : idDabSettingBand

    titleText: stringInfo.strPlayerMenu_DabSettings

    onBackBtnClicked: {
        console.log("[QML] DABSettingBand.qml : onBackBtnClicked")
        MDabOperation.settingSaveData();
    }
}

