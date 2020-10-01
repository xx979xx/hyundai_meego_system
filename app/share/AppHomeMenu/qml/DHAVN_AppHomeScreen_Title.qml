import QtQuick 1.1
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0

Item {
    id: title

    //property string sSuffix: backBTNMA.pressed ? "_p.png" : "_n.png"
    property bool backBtnFocused : false
    property bool bPressedByJog: title.backBtnFocused && title.bJogPressed
    property bool bJogPressed: false


    function setFocus(value) {
        title.backBtnFocused = value;
    }

    function getFocus() {
        return title.backBtnFocused;
    }

    function backButtonClicked() {
        EngineListener.BackKeyHandler(UIListener.getCurrentScreen());
        title.backBtnFocused = false;
    }

    y: 93

    width: 1280; height: 72

    Image {
        id: backBtnImage

        anchors.top: parent.top
        x : ( LocTrigger.arab  ) ? 3 : 1136
        //anchors.horizontalCenter: ( LocTrigger.arab  ) ? parent.left : parent.right
        anchors.horizontalCenterOffset: sourceSize.width/2 * ( (LocTrigger.arab ) ? 1 : -1 )
        mirror: ( LocTrigger.arab  ) ? true : false



        source: InitData.GetImage( EHSDefP.IMG_TITLE_BTN ) + "_n.png"

        onStatusChanged: {
            if (status == Image.Error)
            {
                EngineListener.logForQML("Image.Error, [Title QML] file name = " + backBtnImage.source);
            }
        }

        MouseArea {
            id: backBTNMA
            anchors.fill: parent
            beepEnabled: false

            onPressed: backBtnFocusPressed.visible = true

            onReleased:
            {
                if (backBtnFocusPressed.visible)
                {
                    EngineListener.playBeep()
                    title.backButtonClicked();
                    backBtnFocusPressed.visible = false
                }
            }

            onExited: backBtnFocusPressed.visible = false
        }
    }

    Image {
        id: backBtnFocus

        visible: false

        anchors.top: parent.top
        x : ( LocTrigger.arab  ) ? 3 : 1136
        //anchors.horizontalCenter: ( LocTrigger.arab  ) ? parent.left : parent.right
        anchors.horizontalCenterOffset: sourceSize.width/2 * ( (LocTrigger.arab ) ? 1 : -1 )
        mirror: ( LocTrigger.arab  ) ? true : false

        source : "/app/share/images/AppHome/btn_title_back_f.png"

        onStatusChanged: {
            if (status == Image.Error)
            {
                EngineListener.logForQML("Image.Error, [Title QML] file name = " + backBtnFocus.source);
            }
        }

    }


    Image {
        id: backBtnFocusPressed

        visible: false

        anchors.top: parent.top
        x : ( LocTrigger.arab  ) ? 3 : 1136
        //anchors.horizontalCenter: ( LocTrigger.arab  ) ? parent.left : parent.right
        anchors.horizontalCenterOffset: sourceSize.width/2 * ( (LocTrigger.arab ) ? 1 : -1 )
        mirror: ( LocTrigger.arab  ) ? true : false

        source : "/app/share/images/AppHome/btn_title_back_p.png"

        onStatusChanged: {
            if (status == Image.Error)
            {
                EngineListener.logForQML("Image.Error, [Title QML] file name = " + backBtnFocusPressed.source);
            }
        }
    }


    states:
        [
        State {
            name: "NORMAL"
            when: ( !title.backBtnFocused )
            PropertyChanges{ target: backBtnFocusPressed; visible: false }
            PropertyChanges{ target: backBtnFocus; visible: false }
        },

        State {
            name: "FOCUSED"
            when: ( title.backBtnFocused )
            PropertyChanges{ target: backBtnFocus; visible: true }
        },

        State {
            name: "FOCUS_PRESSED"
            when: ( title.backBtnFocused && title.bJogPressed )
            PropertyChanges{ target: backBtnFocusPressed; visible: true }
        }
    ]

    Connections {
        target: title.backBtnFocused ? UIListener : null

        onSignalJogNavigation: {
            if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                backBtnFocusPressed.visible = true
            }

            if( ( status == UIListenerEnum.KEY_STATUS_RELEASED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                backBtnFocusPressed.visible = false
                title.backButtonClicked()
            }

            if( ( status == UIListenerEnum.KEY_STATUS_CANCELED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                backBtnFocusPressed.visible = false
                ViewControll.bJogPressed = false
            }
        }
    }

    Connections {
        target: UIListener
        onSignalShowSystemPopup: {
            //console.log("onSignalShowSystemPopup")
            backBtnFocused = false
        }
        onSignalHideSystemPopup: {
            //console.log("onSignalHideSystemPopup")
            backBtnFocused = false
        }
    }

    Connections {
        target: EngineListener

        onGoMainMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                title.backBtnFocused = false
            }
        }

        onGoSubMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                title.backBtnFocused = false
            }
        }

        onGoHelpMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                title.backBtnFocused = false
            }
        }
    }
}
