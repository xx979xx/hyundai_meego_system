import Qt 4.7
import QmlStatusBar 1.0
import QmlModeAreaWidget 1.0
import POPUPEnums 1.0
import "General.js" as APC

Item
{
    id: projectionPopupCtrl
    width: APC.const_SCREEN_WIDTH
    height: APC.const_SCREEN_HEIGHT

    property int language: EngineListenerMain.languageId
    property int pMode : 0
    property bool isVisiblebackBtnFocus : true
    property bool middleEast : EngineListenerMain.middle

    Rectangle {
        color: "black"
        anchors.fill: parent

        Item {
            width: 980//APC.const_SCREEN_WIDTH
            height: 100//555
            x:150; y:413-20

            Text {
                id: controlNotAvailTxt
                text: ""
                visible: false;
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: APC.const_APP_PROJECTION_COLOR_TEXT_GREY
                font.family: APC.const_APP_PROJECTION_FONT_FAMILY_NEW_HDB
                font.pointSize: APC.const_APP_PROJECTION_FONT_SIZE_TEXT_HDB_40_FONT
            }
        }
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0;
        width: 1280;
        height: 93;
        homeType: "button"
        middleEast: EngineListenerMain.middle;
    }

    QmlModeAreaWidget
    {
        id: mode_area
        anchors.top: statusBar.bottom
        focus_id: PopupIDPjtn.FOCUS_MODE_AREA
        focus_visible: isVisiblebackBtnFocus
        focus_index: 3

        mirrored_layout: EngineListenerMain.middle;

        onModeArea_BackBtn:
        {
            if(root.state === "ProjectionPopupState")
            {
                EngineListenerMain.handleQmlOkPressed();
            }
        }
    }

    Connections {

        target: (root.state === "ProjectionPopupState")? EngineListenerMain: null

        onRetranslateUi:
        {
            language = languageId;
            LocTrigger.retrigger()
            changeText(pMode);
            statusBar.middleEast = middle;
            mode_area.mirrored_layout = middle;
        }

        onNotiProjectionPopup:
        {
            __LOG("onNotiProjectionPopup show:" + isShow + ", mode:" + projectionMode)
            pMode = projectionMode
            changeText(projectionMode);

            if (isShow == true)
                controlNotAvailTxt.visible = true
            else
                controlNotAvailTxt.visible = false

        }

        onChangePopUpText:
        {
           changeText(projectionMode);
        }

        onNotiSysPopupRear:
        {   //Fixed ITS issue 0268379
            //__LOG(" onNotiSysPopupRear " + isShow)
            isVisiblebackBtnFocus = !isShow;
        }
    }

    function changeText(mode) {
        if (mode==1) { //ANDROIDAUTO
            controlNotAvailTxt.text = qsTranslate("main","STR_AAP_CONTROL_NOT_AVAILABLE_REAR") + LocTrigger.empty;
        }
        else if (mode==5) { //PROJECTION_CALL
            controlNotAvailTxt.text = qsTranslate("main","STR_PROJECTION_NOT_AVAILABLE_REAR_WITH_CALL") + LocTrigger.empty;
        }
        else if (mode==6) { //PROJECTION_VR
            controlNotAvailTxt.text = qsTranslate("main","STR_CONTROL_NOT_AVAILABLE_VR") + LocTrigger.empty;
        }
        else if (mode==3) { //ANDROIDAUTO_VR
            controlNotAvailTxt.text = qsTranslate("main","STR_CONTROL_NOT_AVAILABLE_VR") + LocTrigger.empty;
        }
        else if (mode==4) { //ANDROIDAUTO_EMPTY
            controlNotAvailTxt.text = ""
        }
        else { //CARPLAY, CARPLAY_CALL_SIRI, or others
            controlNotAvailTxt.text = qsTranslate("main","STR_CARPLAY_CONTROL_NOT_AVAILABLE_REAR") + LocTrigger.empty;
        }
    }

}
