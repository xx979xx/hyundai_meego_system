/**
 * DDPopupLoader.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH" as MSystem


Loader
{
    id: idPopupLoader

    // PROPERTIES
    property string popupName: ""

    property string sourcePath: "";
    property string arabicSourcePath: "";

    property bool languageChanged: false

    property QtObject naviLeft
    property QtObject naviRight

    // SIGNALS
    x:(popupState == popupName)
      && ((false == systemPopupOn)
      || (popupState == "popup_toast")
      || (popupState == "Call_popup")
      || (popupState == "Call_3way_popup")
      || (popupState == "popup_Bt_Add_Favorite")
      || (popupState == "popup_Bt_Deleted")
      || (popupState == "connectSuccessPopup")
      || (popupState == "popup_Bt_Connect_Canceled")
      || (popupState == "connectSuccessA2DPOnlyPopup")
      || (popupState == "popup_Bt_Initialized")
      || (popupState == "popup_device_name_empty")
      || (popupState == "disconnectSuccessPopup")
      || (popupState == "popup_Bt_Contact_Update_Completed")
      || (popupState == "popup_enter_setting_during_call"))
      && (false == siriViewState)
      ? 0 : -systemInfo.lcdWidth

    visible: (popupState == popupName) ? true : false
    focus: (popupState == popupName) ? true : false

    function load() {
        if("" == sourcePath) {
            console.log("# [LOADER] sourcePath is EMPTY!");
            return;
        }

        if(Loader.Ready != status) {
            if(20 != gLanguage) {
                //console.log("# [LOADER] load() " + sourcePath);
                source = sourcePath;
            } else {
                //console.log("# [LOADER] load() " + arabicSourcePath);
                //TEMP source = ("" != arabicSourcePath) ? arabicSourcePath : sourcePath
                source = arabicSourcePath;
            }
        } else {
            console.log("# [LOADER] already load() " + source);
        }
    }

    function unload() {
        //console.log("# [LOADER] unload() " + source);
        if(Loader.Ready == status) {
            source = "";
        }

        // 화면잔상 문제로 hide() 함수를 사용하지 않고 직접 visible = false로 설정함
        //DEPRECATED idLoader.hide();
        idPopupLoader.visible = (popupState == popupName) ? true : false;
        idPopupLoader.focus = (popupState == popupName) ? true : false;
    }

    function reload() {
        if(arabicSourcePath == sourcePath) {
            console.log("# [LOADER] Same Popup");
            return;
        }

        if(20 != gLanguage) {
            idPopupLoader.source = sourcePath;
        } else {
            idPopupLoader.source = arabicSourcePath;
        }

        //console.log("# [LOADER] reloaded = " + source);
    }

    Connections {
        target: idAppMain

        onSigUpdateUI: {
            if(arabicSourcePath == sourcePath) {
                console.log("# [LOADER] Same Popup");
                return;
            }

            if(Loader.Ready != status) {
                // 아직 Loading되지 않은 상태 do nothing
                return;
            }

            if(true == idPopupLoader.visible) {
                // 현재 보여지고 있다면 바로 Reload
                idPopupLoader.reload();
            } else {
                // 현재 보여지지 않는다면 다음번 visible change될 때 reload될 수 있도록 마킹
                languageChanged = true;
            }
        }
    }


    /* EVENT handlers */
    onVisibleChanged: {
        if(true == idPopupLoader.visible) {
            console.log("################################ " + popupName + " loader!!!!!!! true");
            if(Loader.Ready != status) {
                idPopupLoader.load();
            } else if(true == languageChanged) {
                idPopupLoader.reload();
            }

            languageChanged = false;
        } else {
            // do something?
            console.log("################################ " + popupName + " loader!!!!!!! false");
        }
    }

}
/* EOF */
