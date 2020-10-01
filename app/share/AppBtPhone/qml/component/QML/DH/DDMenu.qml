/**
 * DDLoader.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH" as MSystem


Loader
{
    id: idLoader
    visible: false
    focus: false

    // PROPERTIES
    property string sourcePath: "";
    property string arabicSourcePath: "";

    property bool languageChanged: false

    property QtObject naviLeft
    property QtObject naviRight

    // SIGNALS
    signal sigReloaded();


    /* INTERNAL functions */
    function load() {
        if("" == sourcePath) {
            console.log("# [LOADER] sourcePath is EMPTY!");
            return;
        }

        if(20 != gLanguage) {
            source = sourcePath;
        } else {
            source = arabicSourcePath;
        }
    }

    function unload() {
        //console.log("# [LOADER] unload() " + source);
        if(Loader.Ready == status) {
            // source = "";
        }

        // 화면잔상 문제로 hide() 함수를 사용하지 않고 직접 visible = false로 설정함
        //DEPRECATED idLoader.hide();
        idLoader.visible = false;
        idLoader.focus = false;
    }

    function reload() {
        if(20 != gLanguage) {
            idLoader.source = sourcePath;
        } else {
            idLoader.source = arabicSourcePath;
        }

        sigReloaded();

        //console.log("# [LOADER] reloaded = " + source);
    }

    function show() {
        if(false == idLoader.visible) {
            idLoader.visible = true;
            idLoader.focus = true;
        }

        //console.log("# [LOADER] show() " + source + ", " + idLoader.visible);
    }

    function hide() {
        if(true == idLoader.visible) {
            idLoader.visible = false;
            idLoader.focus = false;
        }

        //console.log("# [LOADER] hide() " + source + ", " + idLoader.visible);
    }

    function setFocus() {
        idLoader.forceActiveFocus();
    }


    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onSigUpdateUI: {
            if(Loader.Ready != status) {
                // 아직 Loading되지 않은 상태 do nothing
                return;
            }

            if(true == idLoader.visible) {
                // 현재 보여지고 있다면 바로 Reload
                idLoader.reload();
            } else {
                // 현재 보여지지 않는다면 다음번 visible change될 때 reload될 수 있도록 마킹
                languageChanged = true;
            }
        }
    }


    /* EVENT handlers */
    onVisibleChanged: {
        if(true == idLoader.visible) {
            if(Loader.Ready != status) {
                idLoader.load();
            } else if(true == languageChanged) {
                if(20 != gLanguage) {
                    idLoader.source = sourcePath;
                } else {
                    idLoader.source = arabicSourcePath;
                }
                //idLoader.reload();
            }

            languageChanged = false;
        } else {
            // do something?
        }
    }

    KeyNavigation.left: (20 != gLanguage) ? naviLeft : naviRight
    KeyNavigation.right: (20 != gLanguage) ? naviRight : naviLeft
}
/* EOF */
