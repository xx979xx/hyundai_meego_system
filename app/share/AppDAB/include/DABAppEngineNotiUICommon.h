#ifndef DABAPPENGINENOTIUICOMMON_H
#define DABAPPENGINENOTIUICOMMON_H

#include "DABProtocol.h"
#include <DHAVN_AppFramework_Event_Def.h>

class DABAppEngine;
class DABAppEngineNotiUICommon : public QObject
{
    Q_OBJECT
public:
    explicit DABAppEngineNotiUICommon(DABAppEngine &aDABAppEngine, QObject* parent = 0);
    ~DABAppEngineNotiUICommon();

    void ConnectionCreate();
    void NotifyFromUIStateManagerCommon ( Event aEvent );

    void UI_EVT_LANGUAGE_CHANGED(Event aEvent);
    void UI_EVT_AV_MODE_CHANGE(Event aEvent);
    void UI_EVT_NOTIFY_AV_MODE(Event aEvent);
    void UI_EVT_DRS_SHOW(Event aEvent);
    void UI_EVT_DRS_HIDE(Event aEvent);
    void UI_EVT_UPDATE_CLUSTER(Event aEvent);
    void UI_EVT_TA_DAB_END(Event aEvent);
    void UI_EVT_DISPLAY_OFF(Event aEvent);
    void UI_EVT_AGREE_SHOW_OSD(Event aEvent);
    void UI_EVT_AGREE_CLICK_STATUS(Event aEvent);
    void UI_EVT_CAMERA_ENABLE(Event aEvent);
    void UI_EVT_CAMERA_DISABLE(Event aEvent);
    void UI_SEEK_NEXT(Event aEvent);
    void seek_next(KEY_STATUS_T keyStatus, EVT_ID_T eventId, bool isDABPlayerMain);
    void UI_SEEK_PREV(Event aEvent);
    void seek_prev(KEY_STATUS_T keyStatus, EVT_ID_T eventId, bool isDABPlayerMain);
    void UI_EVT_KEY_CCP_JOG_DIAL_ENCODER(Event aEvent);
    void UI_EVT_KEY_RRC_JOG_DIAL_ENCODER(Event aEvent);
    void UI_BACK_KEY(Event aEvent);
    void UI_EVT_CALL_START(Event aEvent);
    void UI_EVT_CALL_END(Event aEvent);
    void UI_EVT_MIX_PLAY_START(Event aEvent);
    void UI_EVT_MIX_PLAY_END(Event aEvent);
    void UI_EVT_KEY_SOFT_MENU(Event aEvent);
    void UI_MENU_KEY(Event aEvent);
    void UI_EVT_KEY_JOG_DIAL_UP(Event aEvent);
    void UI_EVT_KEY_JOG_DIAL_DOWN(Event aEvent);
    void UI_EVT_KEY_JOG_DIAL_LEFT(Event aEvent);
    void UI_EVT_KEY_JOG_DIAL_RIGHT(Event aEvent);
    void UI_EVT_KEY_JOG_DIAL_CENTER(Event aEvent);
    void UI_EVT_REQUEST_SAVE_UNSAVED_DATA(Event aEvent);
    void UI_EVT_RESTORE_LAST_AV_MODE(Event aEvent);
    void UI_EVT_ALL_SLEEP_CANCEL_ACTIVATE(Event aEvent);
    void UI_EVT_KEY_HU_JOG_DIAL_ENCODER(Event aEvent);
    void UI_EVT_DIAGNOSTIC_TEST_START(Event aEvent);
    void UI_EVT_VR_COMMAND(Event aEvent);
    void UI_EVT_KEY_HU_TUNE_PRESSED(Event aEvent);
    void UI_EVT_FACTORY_RESET_REQUEST(Event aEvent);
    void UI_EVT_POST_EVENT(Event aEvent);
    void UI_EVT_REQEUST_MUTE(Event aEvent);
    void UI_EVT_REQEUST_UNMUTE(Event aEvent);
    void UI_EVT_POWER_STATE_LOGIC_OFF(Event aEvent);
    void UI_EVT_POWER_STATE_NORMAL_ON(Event aEvent);
    void UI_EVT_NOTIFY_VR_STATUS(Event aEvent);
    void UI_EVT_AV_MODE_NOTIFY_FROM_VR(Event aEvent);
    void UI_EVT_CONNECTED_CAR_ENABLED(Event aEvent);
    void UI_EVT_CONNECTED_CAR_REMOVED(Event aEvent);
    void UI_EVT_NOTIFY_TRANSIT_APP(Event aEvent);

signals:
    void retranslateUi(int languageId);
    void cmdLanguageChange(int languageID);
    void cmdSetCurrentInfoToHomeMedia(void);
    void cmdEventExceptionHandler(eDAB_EVENT_TYPE event);
    void changeDABtoFM(void);
    void drivingRegulation(bool onOff);
    void cmdSendClusterUpdate(void);
    void cmdReqCancelAlarmAnnouncement(void);
    void cmdReqCancelTrafficAnnouncement(bool onOff);
    void displayTAPopup(QString serviceName, quint16 flags, bool onOff);
    void cmdExceptionTACancel(bool);
    void cmdReqLongSeekNextFromUISH(void);
    void cmdReqSeekNextPresetList(void);
    void cmdReqSeekNextFromUISH(void);
    void cmdReqLongSeekPrevFromUISH(void);
    void cmdReqSeekPrevPresetList(void);
    void cmdReqSeekPrevFromUISH(void);
    void cmdReqSaveData(bool unsaved);
    void cmdReqTuneRight(void);
    void cmdReqTuneLeft(void);
#ifdef __VR_COMMAND__
    void cmdReqPresetSelected(int index);
#endif
    void reqStationListFromVR();
    void cmdReqTunePressed(void);
    void cmdFactoryResetRemoveData(QString path);

private:
    DABAppEngine &m_DABAppEngine;
};

#endif // DABAPPENGINENOTIUICOMMON_H
