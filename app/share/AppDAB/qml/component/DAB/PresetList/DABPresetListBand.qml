/**
 * FileName: DABPresetListBand.qml
 * Author: DaeHyungE
 * Time: 2012-07-19
 *
 * - 2012-07-19 Initial Crated by HyungE
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MBand {
    id : idDabPresetListBand

    titleText : (m_bIsSaveAsPreset==true)?stringInfo.strPreset_SelectNumberToSave : stringInfo.strPreset_Preset

    onBackBtnPressAndHold: { idPresetTimer.stop(); }
    onBackBtnClicked : {
        console.log("[QML] DABPresetListBand.qml : onBackBtnClicked")
        gotoBackScreen();
    }
}

