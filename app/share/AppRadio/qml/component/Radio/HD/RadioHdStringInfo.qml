/**
 * FileName: RadioHdStringInfo.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 * - 2012-09 Modified stringInfo file by HYANG
 */

import QtQuick 1.0

Item {
    id:stringInfo
    //************************ Strings ***//
    property string strHDBandFm: qsTr("STR_HD_BAND_FM");
    property string strHDBandAm: qsTr("STR_HD_BAND_AM");
    property string strHDBandSXm: qsTr("STR_HD_BAND_SIRIUSXM");
    property string strHDBandMenu: qsTr("STR_HD_BAND_MENU");

    property string strHDMsgAcquiring: qsTr("STR_HD_MSG_ACQUIRING_SIGNAL");     // not used
    property string strHDMsgNoInformation: qsTr("STR_HD_MSG_NO_INFORMATION");
    property string strHDMsgWeakSignal: qsTr("STR_HD_MSG_WEAK_SIGNAL");         // not used
    property string strHDMstNoSignal: qsTr("STR_HD_MSG_NO_SIGNAL");
    property string strHDMsgIpodTagTransferred: qsTr("STR_HD_MSG_SONG_TAGS_TRANSFERRED_TO_IPOD");
    property string strHDMsgIpodReading: qsTr("STR_HD_MSG_IPOD_READING");        // not used
    property string strHDMsgAvOff: qsTr("STR_HD_OSD_AV_OFF");                     // not used

    property string strHDMenuTagSong: qsTr("STR_HD_MENU_TAG_SONG");
    property string strHDMenuHdRadio: qsTr("STR_HD_MENU_HD_RADIO");
    property string strHDMenuScan: qsTr("STR_HD_MENU_ALL_CHANNEL_SCAN");//qsTr("Scan");
    property string strHDMenuSaveAsPreset: qsTr("STR_HD_MENU_SAVE_AS_PRESET");
    property string strHDMenuPresetScan: qsTr("STR_HD_MENU_PRESET_SCAN");
    property string strHDMenuAutoStore: qsTr("STR_HD_MENU_AUTO_STORE");
    property string strHDMenuInfo: qsTr("STR_HD_MENU_INFO");
    property string strHDMenuSoundSetting: qsTr("STR_HD_MENU_SOUND_SETTINGS");
    property string strHDMenuEditPresetOrder:qsTr("STR_HD_MENU_EDIT_PRESET_ORDER");

    property string strHDPopupLinking: qsTr("STR_HD_POPUP_LINKING");            // not used
    property string strHDPopupAcquiring: qsTr("STR_HD_POPUP_ACQUIRING_SIGNAL");  // not used
    property string strHDPopupTagCaptured: qsTr("STR_HD_POPUP_TAG_CAPTURED");
    property string strHDPopupOk: qsTr("STR_HD_POPUP_OK");
    property string strHDPopupPresetTitle1: qsTr("STR_HD_POPUP_PRESET_TITLE1");
    property string strHDPopupPresetTitle2: qsTr("STR_HD_POPUP_PRESET_TITLE2");
    //property string strHDPopupPresetAlreadySave: qsTr("STR_HD_POPUP_PRESET_ALREADY_SAVE");  // not used
    property string strHDPopupCancel: qsTr("STR_HD_POPUP_CANCEL");
    property string strHDPopupWarning: qsTr("STR_HD_POPUP_WARNING");
    property string strHDPopupIpodMemoryFull1: qsTr("STR_HD_POPUP_MEMORY_FULL");
    property string strHDPopupIpodMemoryFull2: qsTr("STR_HD_POPUP_SONG_TAGS_IS_UP_TO_300");
    property string strHDPopupIpodMemoryFull3: qsTr("STR_HD_POPUP_PLEASE_CONNECT_IPOD_TO_TRANSFER_SONG_TAGS");
    property string strHDPopupTaggingFailed : qsTr("STR_HD_POPUP_TAGGING_FAILED");
    //property string strHDPopupIpodTagFail: qsTr("STR_HD_POPUP_SONG_TAGGING_FAILED");
    property string strHDPopupIpodTagAlreadyTaggingged: qsTr("STR_HD_POPUP_SONG_ALREADY_TAGGED");
    property string strHDPopupIpodTagAlreadyTagged: qsTr("STR_HD_POPUP_Song Already Tagged"); //HWS 130127 , // not used
    property string strHDPopupPresetSaveSuccessfully: qsTr("STR_HD_POPUP_SAVED_AS_PRESET_SUCCESSFULLY");
    property string strHDMenuSubDepthScan : qsTr("STR_HD_MENU_SUBDEPTH_SCAN");
    property string strHDPopupTagStoring  : qsTr("STR_HD_POPUP_TAG_STORINGTAG");
    property string strHDPopupTagPleaseWait : qsTr("STR_HD_POPUP_TAG_PLEASEWAIT");
    property string strHDPopupTagAmbiguous  : qsTr("STR_HD_POPUP_TAG_AMBIGUOUS");
    property string strHDRadioSave          : qsTr("STR_HDRADIO_SAVE");         // JSH 131018
    property string strHDRadioMenuStopScan  : qsTr("STR_RADIO_MENU_STOP_SCAN");  // JSH 131020
    property string strRadioPreventSave    : qsTr("STR_RADIO_PREVENT_SAVE"); //2013.11.21 added by qutiguy

    //************************ Translate Strings ***//
    function retranslateUi(languageId)
    {
        //************************ Strings ***//
        strHDBandFm = qsTr("STR_HD_BAND_FM");
        strHDBandAm = qsTr("STR_HD_BAND_AM");
        strHDBandSXm = qsTr("STR_HD_BAND_SIRIUSXM");//qsTr("SXM");
        strHDBandMenu = qsTr("STR_HD_BAND_MENU");

        strHDMsgAcquiring = qsTr("STR_HD_MSG_ACQUIRING_SIGNAL");
        strHDMsgNoInformation = qsTr("STR_HD_MSG_NO_INFORMATION");
        strHDMsgWeakSignal = qsTr("STR_HD_MSG_WEAK_SIGNAL");
        strHDMstNoSignal = qsTr("STR_HD_MSG_NO_SIGNAL");
        strHDMsgIpodTagTransferred = qsTr("STR_HD_MSG_SONG_TAGS_TRANSFERRED_TO_IPOD");
        strHDMsgIpodReading = qsTr("STR_HD_MSG_IPOD_READING");
        strHDMsgAvOff= qsTr("STR_HD_OSD_AV_OFF");

        strHDMenuTagSong= qsTr("STR_HD_MENU_TAG_SONG");
        strHDMenuHdRadio= qsTr("STR_HD_MENU_HD_RADIO");
        strHDMenuScan= qsTr("STR_HD_MENU_ALL_CHANNEL_SCAN");//qsTr("Scan");
        strHDMenuSaveAsPreset= qsTr("STR_HD_MENU_SAVE_AS_PRESET");
        strHDMenuPresetScan= qsTr("STR_HD_MENU_PRESET_SCAN");
        strHDMenuAutoStore= qsTr("STR_HD_MENU_AUTO_STORE");
        strHDMenuInfo= qsTr("STR_HD_MENU_INFO");
        strHDMenuSoundSetting= qsTr("STR_HD_MENU_SOUND_SETTINGS");
        strHDMenuEditPresetOrder = qsTr("STR_HD_MENU_EDIT_PRESET_ORDER");

        strHDPopupLinking = qsTr("STR_HD_POPUP_LINKING");
        strHDPopupAcquiring = qsTr("STR_HD_POPUP_ACQUIRING_SIGNAL");
        strHDPopupTagCaptured = qsTr("STR_HD_POPUP_TAG_CAPTURED");
        strHDPopupOk = qsTr("STR_HD_POPUP_OK");
        strHDPopupPresetTitle1 = qsTr("STR_HD_POPUP_PRESET_TITLE1");
        strHDPopupPresetTitle2 = qsTr("STR_HD_POPUP_PRESET_TITLE2");
        //strHDPopupPresetAlreadySave = qsTr("STR_HD_POPUP_PRESET_ALREADY_SAVE");
        strHDPopupCancel = qsTr("STR_HD_POPUP_CANCEL");
        strHDPopupWarning = qsTr("STR_HD_POPUP_WARNING");
        strHDPopupIpodMemoryFull1 = qsTr("STR_HD_POPUP_MEMORY_FULL");
        strHDPopupIpodMemoryFull2 = qsTr("STR_HD_POPUP_SONG_TAGS_IS_UP_TO_300");
        strHDPopupIpodMemoryFull3 = qsTr("STR_HD_POPUP_PLEASE_CONNECT_IPOD_TO_TRANSFER_SONG_TAGS");
        strHDPopupTaggingFailed = qsTr("STR_HD_POPUP_TAGGING_FAILED");
        //strHDPopupIpodTagFail = qsTr("STR_HD_POPUP_SONG_TAGGING_FAILED");
        strHDPopupIpodTagAlreadyTagged = qsTr("STR_HD_POPUP_SONG_ALREADY_TAGGED");
        strHDPopupPresetSaveSuccessfully = qsTr("STR_HD_POPUP_SAVED_AS_PRESET_SUCCESSFULLY");
        strHDMenuSubDepthScan = qsTr("STR_HD_MENU_SUBDEPTH_SCAN");
        strHDPopupIpodTagAlreadyTaggingged = qsTr("STR_HD_POPUP_SONG_ALREADY_TAGGED");
        strHDPopupTagStoring  = qsTr("STR_HD_POPUP_TAG_STORINGTAG");
        strHDPopupTagPleaseWait = qsTr("STR_HD_POPUP_TAG_PLEASEWAIT");
        strHDPopupTagAmbiguous  = qsTr("STR_HD_POPUP_TAG_AMBIGUOUS");
        strHDRadioSave          = qsTr("STR_HDRADIO_SAVE");         // JSH 131018
        strHDRadioMenuStopScan  = qsTr("STR_RADIO_MENU_STOP_SCAN");  // JSH 131020
        strRadioPreventSave                 = qsTr("STR_RADIO_PREVENT_SAVE"); //2013.11.21 added by qutiguy
    }

    //************************ Language Changed ***//
    Connections {
        target: UIListener
        onRetranslateUi: {
            //console.log("DHHDMain: retranslateUi : " + languageId);
            stringInfo.retranslateUi(languageId);
        }
    }
}
