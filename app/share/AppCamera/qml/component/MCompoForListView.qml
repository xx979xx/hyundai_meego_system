import QtQuick 1.0

import QmlStatusBar 1.0
import AppEngineQMLConstants 1.0

MComponent {
    property bool upKeyLongPressed : false
    property bool downKeyLongPressed : false
    property int lCount: listView.count
    property bool enableQuickScroll: true

    Connections {
        target: UIListener

        onSignalJogNavigation:
        {
            //console.log("onSignalJogNavigation -> arrow:"+ arrow);
            switch( arrow )
            {
                case UIListenerEnum.JOG_UP:
                {
                    //console.log("JOG_UP, status:"+ status);
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED) {
                        //console.log("JOG_UP, KEY_STATUS_PRESSED:");

                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED) {
                        //console.log("JOG_UP, KEY_STATUS_LONG_PRESSED:");
                        upKeyLongPressed = true;
                        if (enableQuickScroll) idUpLongKeyTimer.start();
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED) {
                        //console.log("JOG_UP, KEY_STATUS_RELEASED:");
                        if (upKeyLongPressed) {
                            idUpLongKeyTimer.stop();
                            upKeyLongPressed = false;
                        }
                        else {
                            backFocus.forceActiveFocus();
                            idModeArea
                        }
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        if (upKeyLongPressed) {
                            idUpLongKeyTimer.stop();
                            upKeyLongPressed = false;
                        }
                    }
                }
                break;
                case UIListenerEnum.JOG_DOWN:
                {
                    //console.log("JOG_DOWN, status:"+ status);
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED) {
                        //console.log("JOG_DOWN, KEY_STATUS_PRESSED:");
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED) {
                        //console.log("JOG_DOWN, KEY_STATUS_LONG_PRESSED:");
                        downKeyLongPressed = true;
                        if (enableQuickScroll) idDownLongKeyTimer.start();
                    }
                    else if ( status == UIListenerEnum.KEY_STATUS_RELEASED) {
                        //console.log("JOG_DOWN, KEY_STATUS_RELEASED:");
                        if (downKeyLongPressed) {
                            idDownLongKeyTimer.stop();
                            downKeyLongPressed = false;
                        }
                    }
                    else if ( status ==  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        if (downKeyLongPressed) {
                            idDownLongKeyTimer.stop();
                            downKeyLongPressed = false;
                        }
                    }
                }
                break;
            }
        }
    } // End Connections

    Timer {
        id: idUpLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            if (!enableQuickScroll) return;
            //console.debug("---------- idUpLongKeyTimer onTriggered, listView.currentIndex:" + listView.currentIndex)
             if(listView.currentIndex != 0) listView.currentIndex--;
             else idUpLongKeyTimer.stop;
        }
        //triggeredOnStart: true
    }
    Timer {
        id: idDownLongKeyTimer
        interval: 100
        repeat: true
        running: false
        onTriggered:
        {
            if (!enableQuickScroll) return;
            ///console.debug("---------- idDownLongKeyTimer onTriggered, listView.currentIndex:" + listView.currentIndex)
             if(listView.currentIndex != lCount-1) listView.currentIndex++;
             else idDownLongKeyTimer.stop;
        }
        //triggeredOnStart: true
    }
}
