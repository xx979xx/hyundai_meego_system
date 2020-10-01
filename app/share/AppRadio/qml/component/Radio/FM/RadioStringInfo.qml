/**
 * FileName: RadioStringInfo.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 * - 2012-09 Modified stringInfo file by HYANG
 */

import QtQuick 1.0

Item {
    id:stringInfo

    //************************ Strings ***//
    property string strRadioBandFm1: qsTr("STR_RADIO_BAND_FM1");
    property string strRadioBandFm2: qsTr("STR_RADIO_BAND_FM2");
    property string strRadioBandAm: qsTr("STR_RADIO_BAND_AM");
    property string strRadioBandMenu: qsTr("STR_RADIO_BAND_MENU");

    property string strRadioMenuScan: qsTr("STR_RADIO_MENU_ALL_CHANNEL_SCAN"); // qsTr("Scan"); //JSH 121121 Text changed
    property string strRadioMenuEditPresetOrder : qsTr("STR_RADIO_MENU_EDIT_PRESET_ORDER");     //JSH 121121 string added
    property string strRadioMenuSaveAsPreset: qsTr("STR_RADIO_MENU_SAVE_AS_PRESET");
    property string strRadioMenuPresetScan: qsTr("STR_RADIO_MENU_PRESET_SCAN");
    property string strRadioMenuAutoStore: qsTr("STR_RADIO_MENU_AUTO_STORE");
    property string strRadioMenuSoundSetting: qsTr("STR_RADIO_MENU_SOUND_SETTINGS");

    property string strRadioPopupPresetSaveSuccessfully: qsTr("STR_RADIO_POPUP_PRESET_SAVE_SUCCESSFULLY");

    property string strRadioMsgAvOff: qsTr("STR_RADIO_MSG_AV_OFF");
    property string strRadioSave    : qsTr("STR_RADIO_SAVE");       // JSH 131018
    property string strRadioMenuStopScan: qsTr("STR_RADIO_MENU_STOP_SCAN");  // JSH 131020
    property string strRadioPreventSave    : qsTr("STR_RADIO_PREVENT_SAVE"); //2013.11.21 added by qutiguy
    property int langId


    //************************ Translate Strings ***//
    function retranslateUi(languageId)
    {
        console.log("RadioFM retranslateUi")

        //************************ Strings ***//
        strRadioBandFm1                     = qsTr("STR_RADIO_BAND_FM1");
        strRadioBandFm2                     = qsTr("STR_RADIO_BAND_FM2");
        strRadioBandAm                      = qsTr("STR_RADIO_BAND_AM");
        strRadioBandMenu                    = qsTr("STR_RADIO_BAND_MENU");

        strRadioMenuScan                    = qsTr("STR_RADIO_MENU_ALL_CHANNEL_SCAN"); // qsTr("Scan"); //JSH 121121 Text changed
        strRadioMenuEditPresetOrder         = qsTr("STR_RADIO_MENU_EDIT_PRESET_ORDER");     //JSH 121121 string added
        strRadioMenuSaveAsPreset            = qsTr("STR_RADIO_MENU_SAVE_AS_PRESET");
        strRadioMenuPresetScan              = qsTr("STR_RADIO_MENU_PRESET_SCAN");
        strRadioMenuAutoStore               = qsTr("STR_RADIO_MENU_AUTO_STORE");
        strRadioMenuSoundSetting            = qsTr("STR_RADIO_MENU_SOUND_SETTINGS");

        strRadioPopupPresetSaveSuccessfully = qsTr("STR_RADIO_POPUP_PRESET_SAVE_SUCCESSFULLY");
        strRadioSave                        = qsTr("STR_RADIO_SAVE");       // JSH 131018
        strRadioMenuStopScan                = qsTr("STR_RADIO_MENU_STOP_SCAN");  // JSH 131020
        strRadioPreventSave                 = qsTr("STR_RADIO_PREVENT_SAVE"); //2013.11.21 added by qutiguy

        strRadioMsgAvOff= qsTr("STR_RADIO_MSG_AV_OFF");
    }

    //************************ Language Changed ***//
    Connections {
        target: UIListener
        onRetranslateUi: {
            stringInfo.langId = languageId;
            console.log("DHRadioFMMain: retranslateUi : " + languageId);
            stringInfo.retranslateUi(languageId);
        }
    }
}
