/**
 * FileName: DmbStringInfo.qml
 * Author:jyjeon
 * Time: 2011-11-12 15:08
 *
 * - 2011-11-12 Initial Crated by jyjeon
 * -
 */

import Qt 4.7

Item {
    id:stringInfo

    // Player Title
    property string strAppName                            :qsTr("STR_DMB_TITLE")

    // Player OptionMenu
    property string strPlayer_Option_Search               :qsTr("STR_DMB_PLAYER_OPTION_CHSEARCH");
    property string strPlayer_Option_MoveChannel          :qsTr("STR_DMB_PLAYER_OPTION_MOVECH");
    property string strPlayer_Option_DeleteChannel        :qsTr("STR_DMB_PLAYER_OPTION_UNSETCH");
    property string strPlayer_Option_Fullscreen           :qsTr("STR_DMB_PLAYER_OPTION_FULLSCREEN");
    property string strPlayer_Option_DisasterInfo         :qsTr("STR_DMB_PLAYER_OPTION_DISINFO");
    property string strPlayer_Option_SoundSetting         :qsTr("STR_DMB_PLAYER_OPTION_SOUNDSETTING");
    property string strPlayer_Option_ScreenSetting        :qsTr("STR_DMB_PLAYER_OPTION_SCREENSETTING");

    // Signal
    property string strChSignal_NoCH                      :qsTr("STR_DMB_CHSIGNAL_NOCH")
    property string strChSignal_NoSignal                  :qsTr("STR_DMB_CHSIGNAL_NOSIGNAL");
    property string strChSignal_ChChanging                :qsTr("STR_DMB_CHSIGNAL_CHCHANGING");
    property string strChSignal_Restriction_Driving1      :qsTr("STR_DMB_CHSIGNAL_RESTRINCTION_DRIVING1");
    property string strChSignal_Restriction_Driving2      :qsTr("STR_DMB_CHSIGNAL_RESTRINCTION_DRIVING2");

    // Disaster
    property string strDmbDis_Title                       :qsTr("STR_DMB_DMBDIS_TITLE");
    property string strDmbDis_Title_Delete                :qsTr("STR_DMB_DMBDIS_TITLE_DELETE");
    property string strDmbDis_Tab_SortType_Time           :qsTr("STR_DMB_DMBDIS_SORTTYPE_TIME");
    property string strDmbDis_Tab_SortType_Area           :qsTr("STR_DMB_DMBDIS_SORTTYPE_AREA");
    property string strDmbDis_Tab_SortType_Priority       :qsTr("STR_DMB_DMBDIS_SORTTYPE_PRIORITY");
    property string strDmbDis_List_Priority_Unknown       :qsTr("STR_DMB_DMBDIS_PRIORITY_UNKNOWN");
    property string strDmbDis_List_Priority_Normal        :qsTr("STR_DMB_DMBDIS_PRIORITY_NORMAL");
    property string strDmbDis_List_Priority_High          :qsTr("STR_DMB_DMBDIS_PRIORITY_HIGH");
    property string strDmbDis_List_Priority_Urgent        :qsTr("STR_DMB_DMBDIS_PRIORITY_URGENT");
    property string strDmbDis_Edit_Delete                 :qsTr("STR_DMB_DMBDIS_EDIT_DELETE");
    property string strDmbDis_Edit_DeleteAll              :qsTr("STR_DMB_DMBDIS_EDIT_DELETEALL");
    property string strDmbDis_Edit_UnselectAll            :qsTr("STR_DMB_DMBDIS_EDIT_UNSELECTALL");
    property string strDmbDis_Edit_Cancel                 :qsTr("STR_DMB_DMBDIS_EDIT_CANCEL");

    // Disaster OptionMenu
    property string strDmbDis_Option_Delete               :qsTr("STR_DMB_DMBDIS_OPTION_DELETE");
    property string strDmbDis_Option_Cancel               :qsTr("STR_DMB_DMBDIS_OPTION_CANCEL");

    // Popup
    property string strPOPUP_Searching                    :qsTr("STR_DMB_POPUP_SEARCHING");
    property string strPOPUP_SearchTVChannel              :qsTr("STR_DMB_POPUP_SEARCHTVCH");
    property string strPOPUP_SearchChannelCount           :qsTr("STR_DMB_POPUP_SEARCHCHCOUNT");
    property string strPOPUP_SearchRadioChannel           :qsTr("STR_DMB_POPUP_SEARCHRADIOCH");
    property string strPOPUP_SearchAgain1                 :qsTr("STR_DMB_POPUP_SEARCHAGAIN1");
    property string strPOPUP_SearchAgain2                 :qsTr("STR_DMB_POPUP_SEARCHAGAIN2");
    property string strPOPUP_SearchComplete               :qsTr("STR_DMB_POPUP_SEARCHCOMPLETE");
    property string strPOPUP_ChannelDeletedConfrim        :qsTr("STR_DMB_POPUP_CHANNELDELETEDCONFRIM");
    property string strPOPUP_DisasterInfoDeleteConfirm    :qsTr("STR_DMB_POPUP_DELETECONFIRM");
    property string strPOPUP_DisasterInfoDeleteAllConfirm :qsTr("STR_DMB_POPUP_DELETEALLCONFIRM");
    property string strPOPUP_Deleting1                    :qsTr("STR_DMB_POPUP_DELETING1");
    property string strPOPUP_Deleting2                    :qsTr("STR_DMB_POPUP_DELETING2");
    property string strPOPUP_NoDisasterInfo               :qsTr("STR_DMB_POPUP_NODISINFO");
    property string strPOPUP_Deleted                      :qsTr("STR_DMB_POPUP_DELETED");
    property string strPOPUP_ChannelDeleted               :qsTr("STR_DMB_POPUP_CHANNELDELETED");
    property string strPOPUP_SetFullscreen                :qsTr("STR_DMB_POPUP_SETFULLSCREEN");
    property string strPOPUP_BUTTON_Cancel                :qsTr("STR_DMB_POPUP_CANCEL");
    property string strPOPUP_BUTTON_Stop                  :qsTr("STR_DMB_POPUP_STOP");
    property string strPOPUP_BUTTON_OK                    :qsTr("STR_DMB_POPUP_OK");
    property string strPOPUP_BUTTON_Delete                :qsTr("STR_DMB_POPUP_DELETE");
    property string strPOPUP_BUTTON_Yes                   :qsTr("STR_DMB_POPUP_YES");
    property string strPOPUP_BUTTON_No                    :qsTr("STR_DMB_POPUP_NO");

    // Band
    property string strDmbBand_Menu                    :qsTr("STR_DMB_BAND_MENU");


    function retranslateUi(languageId)
    {
        //console.log("DmbStringInfo: retranslateUi" + languageId);

        // Player Title
        strAppName                                       =qsTr("STR_DMB_TITLE")

        // Player OptionMenu
        strPlayer_Option_Search                          =qsTr("STR_DMB_PLAYER_OPTION_CHSEARCH");
        strPlayer_Option_MoveChannel                     =qsTr("STR_DMB_PLAYER_OPTION_MOVECH");
        strPlayer_Option_DeleteChannel                   =qsTr("STR_DMB_PLAYER_OPTION_UNSETCH");
        strPlayer_Option_Fullscreen                      =qsTr("STR_DMB_PLAYER_OPTION_FULLSCREEN");
        strPlayer_Option_DisasterInfo                    =qsTr("STR_DMB_PLAYER_OPTION_DISINFO");
        strPlayer_Option_SoundSetting                    =qsTr("STR_DMB_PLAYER_OPTION_SOUNDSETTING");
        strPlayer_Option_ScreenSetting                   =qsTr("STR_DMB_PLAYER_OPTION_SCREENSETTING");

        // CH Signal
        strChSignal_NoCH                                 =qsTr("STR_DMB_CHSIGNAL_NOCH")
        strChSignal_NoSignal                             =qsTr("STR_DMB_CHSIGNAL_NOSIGNAL");
        strChSignal_ChChanging                           =qsTr("STR_DMB_CHSIGNAL_CHCHANGING");
        strChSignal_Restriction_Driving1                 =qsTr("STR_DMB_CHSIGNAL_RESTRINCTION_DRIVING1");
        strChSignal_Restriction_Driving2                 =qsTr("STR_DMB_CHSIGNAL_RESTRINCTION_DRIVING2");

        // Disaster
        strDmbDis_Title                                  =qsTr("STR_DMB_DMBDIS_TITLE");
        strDmbDis_Title_Delete                           =qsTr("STR_DMB_DMBDIS_TITLE_DELETE");
        strDmbDis_Tab_SortType_Time                      =qsTr("STR_DMB_DMBDIS_SORTTYPE_TIME");
        strDmbDis_Tab_SortType_Area                      =qsTr("STR_DMB_DMBDIS_SORTTYPE_AREA");
        strDmbDis_Tab_SortType_Priority                  =qsTr("STR_DMB_DMBDIS_SORTTYPE_PRIORITY");
        strDmbDis_List_Priority_Unknown                  =qsTr("STR_DMB_DMBDIS_PRIORITY_UNKNOWN");
        strDmbDis_List_Priority_Normal                   =qsTr("STR_DMB_DMBDIS_PRIORITY_NORMAL");
        strDmbDis_List_Priority_High                     =qsTr("STR_DMB_DMBDIS_PRIORITY_HIGH");
        strDmbDis_List_Priority_Urgent                   =qsTr("STR_DMB_DMBDIS_PRIORITY_URGENT");
        strDmbDis_Edit_Delete                            =qsTr("STR_DMB_DMBDIS_EDIT_DELETE");
        strDmbDis_Edit_DeleteAll                         =qsTr("STR_DMB_DMBDIS_EDIT_DELETEALL");
        strDmbDis_Edit_UnselectAll                       =qsTr("STR_DMB_DMBDIS_EDIT_UNSELECTALL");
	strDmbDis_Edit_Cancel                            =qsTr("STR_DMB_DMBDIS_EDIT_CANCEL");

        // Disaster OptionMenu
        strDmbDis_Option_Delete                          =qsTr("STR_DMB_DMBDIS_OPTION_DELETE");
        strDmbDis_Option_Cancel                          =qsTr("STR_DMB_DMBDIS_OPTION_CANCEL");

        // Popup
        strPOPUP_Searching                               =qsTr("STR_DMB_POPUP_SEARCHING");
        strPOPUP_SearchTVChannel                         =qsTr("STR_DMB_POPUP_SEARCHTVCH");
        strPOPUP_SearchChannelCount                      =qsTr("STR_DMB_POPUP_SEARCHCHCOUNT");
        strPOPUP_SearchRadioChannel                      =qsTr("STR_DMB_POPUP_SEARCHRADIOCH");
        strPOPUP_SearchAgain1                            =qsTr("STR_DMB_POPUP_SEARCHAGAIN1");
        strPOPUP_SearchAgain2                            =qsTr("STR_DMB_POPUP_SEARCHAGAIN2");
        strPOPUP_SearchComplete                          =qsTr("STR_DMB_POPUP_SEARCHCOMPLETE");
        strPOPUP_ChannelDeletedConfrim                   =qsTr("STR_DMB_POPUP_CHANNELDELETEDCONFRIM");
        strPOPUP_DisasterInfoDeleteConfirm               =qsTr("STR_DMB_POPUP_DELETECONFIRM");
        strPOPUP_DisasterInfoDeleteAllConfirm            =qsTr("STR_DMB_POPUP_DELETEALLCONFIRM");
        strPOPUP_Deleting1                               =qsTr("STR_DMB_POPUP_DELETING1");
        strPOPUP_Deleting2                               =qsTr("STR_DMB_POPUP_DELETING2");
        strPOPUP_NoDisasterInfo                          =qsTr("STR_DMB_POPUP_NODISINFO");
        strPOPUP_Deleted                                 =qsTr("STR_DMB_POPUP_DELETED");
        strPOPUP_ChannelDeleted                          =qsTr("STR_DMB_POPUP_CHANNELDELETED");
        strPOPUP_SetFullscreen                           =qsTr("STR_DMB_POPUP_SETFULLSCREEN");
        strPOPUP_BUTTON_Cancel                           =qsTr("STR_DMB_POPUP_CANCEL");
        strPOPUP_BUTTON_Stop                             =qsTr("STR_DMB_POPUP_STOP");
        strPOPUP_BUTTON_OK                               =qsTr("STR_DMB_POPUP_OK");
        strPOPUP_BUTTON_Delete                           =qsTr("STR_DMB_POPUP_DELETE");
        strPOPUP_BUTTON_Yes                              =qsTr("STR_DMB_POPUP_YES");
        strPOPUP_BUTTON_No                               =qsTr("STR_DMB_POPUP_NO");

        // Band
        strDmbBand_Menu                               =qsTr("STR_DMB_BAND_MENU");
    }

    Connections{
        target: EngineListener
        onRetranslateUi:{
//            console.log("******************************DmbStringInfo: retranslateUi" + languageId);
            stringInfo.retranslateUi(languageId);
//            LocTrigger.retrigger();
        }
    }
}

