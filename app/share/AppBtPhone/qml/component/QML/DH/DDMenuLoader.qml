/**
 * DDLoader.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH" as MSystem
import "../../BT/Common/Javascript/operation.js" as MOp


MComponent
{
    id: idMenuContainer
    visible: true
    focus: true
    state: "STATE_OFF"

    // PROPERTIES
    property bool loaded: ("" != idMenuLoader.sourcePath) ? true : false
    property string currentMenu: ""


    /* INTERNAL functions */
    function show() {
        idMenuContainer.load()
        console.log("# [MENU] show");
        if("STATE_SHOW" == idMenuContainer.state) {
            // 이미 메뉴가 화면에 보여지는 상태, do nothing
            return;
        }

        if("" != popupState) {
            // 팝업이 보여지는 상태, do nothing
            return;
        }

        if(false == loaded) {
            // do nothing
            console.log("# [MENU] NO Menu!!!");
            return;
        }

        idMenuContainer.state = "STATE_SHOW";
        menuOn = true

        //DEPRECATED idMenuLoader.visible = true;

        // SET FOCUS
        idMenuContainer.forceActiveFocus();
    }

    function hide() {
        menuOn = false
        console.log("# [MENU] hide");
        if("STATE_HIDE" == idMenuContainer.state || "STATE_OFF" == idMenuContainer.state) {
            return;
        }

        state = "STATE_HIDE";
        beforeFocus = "MAINVIEW";
        menuOffFocus();
        //DEPRECATED idMenuLoader.visible = false;
        //idMenuContainer.unload();

        MOp.returnFocus();
    }

    function off() {
        menuOn = false
        console.log("# [MENU] off");
        if("STATE_OFF" == idMenuContainer.state) {
            return;
        }

        idMenuContainer.state = "STATE_OFF";
        beforeFocus = "MAINVIEW";
        //menuOffFocus();
        //DEPRECATED idMenuLoader.visible = false;
        //idMenuContainer.unload();

        MOp.returnFocus();
    }

    function load(screen) {
        console.log("# [MENU] load() = " + screen);
        idMenuLoader.load();
    }

    /* CONNECTIONS */
    Connections {
        target: idAppMain

        onSigUpdateUI: {
            idMenuContainer.load();
        }
    }


    /* EVENT handlers */
    onClickMenuKey: {
        idMenuContainer.hide();
    }

    onBackKeyPressed: {
        idMenuContainer.hide();
    }

    /* WIDGETS */
    Rectangle {
        id: idMenuBackground
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        opacity: 0
        color: "Black"
    }

    DDMenu {
        id: idMenuLoader
        x: 0
        width: systemInfo.lcdWidth

        // 사라지는 시점은 메뉴가 오른편(또는 왼편)으로 완전히 사라진 뒤
        visible: 20 != gLanguage ? 513 != idMenuLoader.x : -513 != idMenuLoader.x
        focus: true

        // 현재 화면에 따라 동적으로 로딩함
        sourcePath: menuSourcePath
        arabicSourcePath: menuSourcePathArab
    }


    /* STATES */
    states: [
        State {
            // 메뉴 나타나는 State
            name: "STATE_SHOW";
            PropertyChanges {
                target: idMenuLoader;
                x: {
                    if(20 != gLanguage) {
                        0
                    } else {
                        0
                    }
                }
            }
        }
        , State {
            // 메뉴 서서히 사라지는 State
            name: "STATE_HIDE";
            PropertyChanges {
                target: idMenuLoader
                x: {
                    if(20 != gLanguage) {
                        513//systemInfo.lcdWidth
                    } else {
                        -513//-systemInfo.lcdWidth
                    }
                }
            }
        }
        , State {
            // 다른 화면 전환시 바로 사라지는 State
            name: "STATE_OFF";
            PropertyChanges {
                target: idMenuLoader;
                x: {
                    if(20 != gLanguage) {
                        513//systemInfo.lcdWidth
                    } else {
                        -513//-systemInfo.lcdWidth
                    }
                }
            }
            //PropertyChanges { target: idMenuLoader;    focus: false; }
        }
    ]

    /* TRANSITIONS */
    transitions:[
        Transition {
            from: "STATE_SHOW"
            to: "STATE_HIDE"
            NumberAnimation { target: idMenuLoader;     properties: "x";        duration: 200 }
        }
        , Transition {
            from: "STATE_SHOW"
            to: "STATE_OFF"
            NumberAnimation { target: idMenuLoader;     properties: "x";        duration: 0 }
        }
        , Transition {
            from: "STATE_HIDE"
            to: "STATE_SHOW"
            NumberAnimation { target: idMenuLoader;     properties: "x";        duration: 200 }
        }
        , Transition {
            from: "STATE_OFF"
            to: "STATE_SHOW"
            NumberAnimation { target: idMenuLoader;     properties: "x";        duration: 200 }
        }
    ]
}
/* EOF*/
