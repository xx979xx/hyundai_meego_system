import QtQuick 1.1

import QmlHomeScreenDef 1.0
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0
import QmlStatusBar 1.0

Item {
    id: root
    y:0

    property bool firstWheel: false
    property bool isMainMenu: true
    property bool animation: false
    property int subMenuFocusIndex: 0

    Image {
        id: bg_image

        source: (LocTrigger.arab) ? "/app/share/images/AppHome/arab/bg_home.png" : View.sBG

        onStatusChanged: {
            if (status == Image.Error)
            {
                EngineListener.logForQML("Image.Error, [Main QML] file name = " + bg_image.source);
            }
        }
    }

    Connections {
        target: LocTrigger

        onArabChanged: {
            if (isMainMenu) goMainMenuNoAni()
            else goSubMenuNoAni()
        }
    }

    SequentialAnimation {
        id: goSubMenuAni
        running: false

        PauseAnimation { duration: 60 }

        ParallelAnimation {
            PropertyAnimation {
                target: bg_image
                property: "x"
                from: (LocTrigger.arab) ? -778 : 0
                to: (LocTrigger.arab) ? 0 : -778
                duration: 180
            }

            PropertyAnimation {
                target: subMenuListLoader
                property: "x"
                from: (LocTrigger.arab) ? -778 : 778
                to: 0
                duration: 180
            }

            PropertyAnimation { target: mainMenuItems; property: "opacity"; from: 1; to: 0; duration: 60 }
            PropertyAnimation { target: subMenuLoader; property: "opacity"; from: 0; to: 1; duration: 180 }
            PropertyAnimation { target: subMenuListLoader; property: "opacity"; from: 0; to: 1; duration: 60 }
        }
    }

    SequentialAnimation {
        id: goMainMenuAni
        running: false

        PauseAnimation { duration: 60 }

        ParallelAnimation {
            PropertyAnimation {
                target: bg_image
                property: "x"
                from:  (LocTrigger.arab) ? 0 : -778
                to: (LocTrigger.arab) ? -778 : 0
                duration: 180
            }

            PropertyAnimation {
                target: subMenuListLoader
                property: "x"
                from: 0
                to: (LocTrigger.arab) ? -778 : 778
                duration: 180
            }

            SequentialAnimation {
                PauseAnimation { duration: 120 }
                PropertyAnimation { target: mainMenuItems; property: "opacity"; from:0; to: 1; duration: 60 }
            }

            PropertyAnimation { target: subMenuLoader; property: "opacity"; from:1; to: 0; duration: 180 }
            PropertyAnimation { target: subMenuListLoader; property: "opacity"; from:1; to: 0; duration: 120 }
            //PropertyAction { target: root; property: "isMainMenu"; value: "true" }

        }
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0; z:0; width: 1280; height: 93
        homeType: "text"
        middleEast: (LocTrigger.arab) ? true : false
    }

    Connections {
        target: UIListener
        onSignalShowSystemPopup: {
            //console.log("onSignalShowSystemPopup")
            ViewControll.bFocusEnabled = false
        }
        onSignalHideSystemPopup: {
            //console.log("onSignalHideSystemPopup")
            ViewControll.bFocusEnabled = true
        }
    }

    Item {
        id: mainMenuItems

        x:0; y:0; width: 1280; height: 720

        Repeater {
            id: iconsRepeater

            property bool bFocused: ( ViewControll.bFocusEnabled && ( EHSDefP.FOCUS_INDEX_ICONS_MENU == View.nFocusIndex ) )

            model: IconsModel
            delegate: DHAVN_AppHomeScreen_IconItem{}
        }
    }



    Loader {
        id: subMenuLoader
        //source: isMainMenu ? "" : "DHAVN_AppHomeScreen_SubMenu.qml"

        opacity: 0
    }

    Loader {
        id: subMenuListLoader
        //x: 778
        source: isMainMenu ? "" : "DHAVN_AppHomeScreen_SubMenuList.qml"

        onStatusChanged: {
            if(status == Loader.Ready)
            {
                if (root.subMenuFocusIndex != -1)
                    subMenuListLoader.item.setFocusIndex(root.subMenuFocusIndex)
                else
                    subMenuListLoader.item.setDefaultFocusIndex()

                if (root.animation)
                {
                    goMainMenuAni.stop()
                    goSubMenuAni.running = true
                }
            }
        }
    }

    Loader {
        id: helpMenuLoader

        //source: "HelpMenu.qml"
    }

    MouseArea {
        id: appLaunching

        x:0; y: 93; width: 1280; height: 720 - 93

        beepEnabled: false

        visible: false
    }

    // popup -->
    Loader {
        id: popUpLoader
        source: ( EHSDefP.POPUP_INVALID != ViewControll.nPopUpType ) ? "DHAVN_AppHomeScreen_PopUp.qml" : ""

        visible: false

        onStatusChanged: {
            if( Loader.Ready == status ) {
                View.nFocusIndex = EHSDefP.FOCUS_INDEX_POPUP
                visible = true
            }
            else {
                View.nFocusIndex = EHSDefP.FOCUS_INDEX_ICONS_MENU
                visible = false
            }
        }

        Connections {
            target: popUpLoader.item
            onPopUpClosed: popUpLoader.unload()
        }
    }

    Connections {
        target: UIListener

        onSignalShowSystemPopup: {
            EngineListener.hideLocalPopup(UIListener.getCurrentScreen())
        }
    }
    // <-- popup

    Connections {
        target: EngineListener

        onGoMainMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                root.animation = animation

                helpMenuLoader.source = ""

                if (!animation)
                {
                    goSubMenuAni.stop()
                    goMainMenuAni.stop()

                    bg_image.x = (LocTrigger.arab) ? -778 : 0
                    subMenuListLoader.x = (LocTrigger.arab) ? -778 : 778
                    subMenuListLoader.opacity = 0
                    subMenuLoader.opacity = 0
                    mainMenuItems.opacity = 1

                    isMainMenu = true
                }
                else
                {
                    if (!isMainMenu)
                    {
                        goSubMenuAni.stop()
                        goMainMenuAni.running = true
                        isMainMenu = true
                    }
                }

                statusBar.homeType = "text"
                ViewControll.bJogPressed = false
            }
        }

        onGoSubMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                root.subMenuFocusIndex = focusIndex

                //reload sub menu icon & title
                subMenuLoader.source = ""
                subMenuLoader.source = "DHAVN_AppHomeScreen_SubMenu.qml"

                if(subMenuListLoader.status == Loader.Ready)
                {
                    if (root.subMenuFocusIndex != -1)
                        subMenuListLoader.item.setFocusIndex(root.subMenuFocusIndex)

                    else
                        subMenuListLoader.item.setDefaultFocusIndex()
                }

                //root.subMenuId = subMenuId
                root.animation = animation

                helpMenuLoader.source = ""

                if (!animation)
                {
                    goSubMenuAni.stop()
                    goMainMenuAni.stop()

                    bg_image.x = (LocTrigger.arab) ? 0 : -778
                    subMenuListLoader.x = 0
                    subMenuListLoader.opacity = 1
                    subMenuLoader.opacity = 1
                    mainMenuItems.opacity = 0

                }

                isMainMenu = false

                statusBar.homeType = "home-button"
            }
        }

        onGoHelpMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                statusBar.homeType = "button"
                helpMenuLoader.source = "HelpMenu.qml"
            }
        }

        onSigAppLaunching: {
            if (screen == UIListener.getCurrentScreen())
            {
                appLaunching.visible = bLaunching
            }
        }

    }

    Connections {
        target: UIListener

        onSignalJogNavigation:
        {
            if (popUpLoader.status != Loader.Ready && isMainMenu)
            {
                //console.log("DHAVN_AppHomeScreen_Main.qml::JogNavigation: arrow = " + " arrow, status = " + status );

                /*
                            if( status == UIListenerEnum.KEY_STATUS_PRESSED )
                            {
                                switch( arrow )
                                {
                                case UIListenerEnum.JOG_UP:
                                case UIListenerEnum.JOG_DOWN:
                                {
                                    changeFocus(arrow)
                                    break
                                }
                                }
                            }
                            */

                if( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {

                    switch( arrow )
                    {
                    case UIListenerEnum.JOG_WHEEL_LEFT: {
                        if (firstWheel)
                            firstWheel = false
                        else
                            wheelLeft()

                        break
                    }
                    case UIListenerEnum.JOG_WHEEL_RIGHT: {
                        if (firstWheel)
                            firstWheel = false
                        else
                            wheelRight()

                        break
                    }

                    default: break
                    }
                }
            }
        }
    }

    Connections {
        target: UIListener

        onSignalJogCenterPressed: ViewControll.bJogPressed = true;
        onSignalJogCenterReleased: ViewControll.bJogPressed = false;
        onSignalJogNavigation: {
            if( status == UIListenerEnum.KEY_STATUS_PRESSED ) {
                if (!ViewControll.bFocusEnabled &&(titleLoader.status != Loader.Ready ||(titleLoader.item.getFocus() == false))) {
                    ViewControll.bFocusEnabled = true
                    firstWheel = true
                }
            }
        }
    }

    function goMainMenuNoAni()
    {
        goSubMenuAni.stop()
        goMainMenuAni.stop()

        bg_image.x = (LocTrigger.arab) ? -778 : 0
        subMenuListLoader.x = (LocTrigger.arab) ? -778 : 778
        subMenuListLoader.opacity = 0
        subMenuLoader.opacity = 0
        mainMenuItems.opacity = 1
    }

    function goSubMenuNoAni()
    {
        goSubMenuAni.stop()
        goMainMenuAni.stop()

        bg_image.x = (LocTrigger.arab) ? 0 : -778
        subMenuListLoader.x = 0
        subMenuListLoader.opacity = 1
        subMenuLoader.opacity = 1
        mainMenuItems.opacity = 0
    }

    function wheelLeft () {
        if (View.bTitleAvailable == true) {

            if (titleLoader.item.getFocus() == false) {
                if(IconsModel.nFocusIndex == 0)
                {
                    IconsModel.nFocusIndex = IconsModel.nCountItems -1;
                    ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
                }
                else
                {
                    IconsModel.nFocusIndex--;
                    ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
                }
            } else {

                titleLoader.item.setFocus(true);
                ViewControll.SetFocusEnabled(false);
            }

        } else {

            if(IconsModel.nFocusIndex == 0)
            {
                IconsModel.nFocusIndex = IconsModel.nCountItems -1;
                ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
            }
            else
            {
                IconsModel.nFocusIndex--;
                ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
            }
        }
    }

    function wheelRight () {
        if (View.bTitleAvailable == true) {
            if (titleLoader.item.getFocus() == false) {
                if(IconsModel.nFocusIndex == IconsModel.nCountItems - 1 )
                {
                    IconsModel.nFocusIndex = 0;
                    ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
                }
                else
                {
                    IconsModel.nFocusIndex++;
                    ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
                }
            } else {
                titleLoader.item.setFocus(true);
                ViewControll.SetFocusEnabled(false);
            }
        } else {
            if(IconsModel.nFocusIndex == IconsModel.nCountItems - 1 )
            {
                IconsModel.nFocusIndex = 0;
                ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
            }
            else
            {
                IconsModel.nFocusIndex++;
                ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
            }
        }
    }

    function changeFocus( arrow )
    {
        if(arrow == UIListenerEnum.JOG_UP )
        {
            if (View.bTitleAvailable == true) {
                if (titleLoader.item.getFocus() == true) {
                    titleLoader.item.setFocus(true);
                    ViewControll.SetFocusEnabled(false);
                }
                else {
                    titleLoader.item.setFocus(true);
                    ViewControll.SetFocusEnabled(false)
                }
            }
        }

        else if(arrow == UIListenerEnum.JOG_DOWN)
        {
            if (View.bTitleAvailable == true) {
                if (titleLoader.item.getFocus() == true) {

                    titleLoader.item.setFocus(false);
                    ViewControll.SetFocusEnabled(true);

                    if (ViewControll.nTitleAlign == Qt.AlignLeft) {
                        switch (IconsModel.nCountItems ){
                        case 1:
                        case 2:
                        case 3: IconsModel.nFocusIndex = 0; break;
                        case 4:
                        case 5: IconsModel.nFocusIndex = 1; break;
                        case 6:
                        case 7: IconsModel.nFocusIndex = 2; break;
                        case 8:
                        case 9: IconsModel.nFocusIndex = 3; break;
                        case 10: IconsModel.nFocusIndex = 4; break;
                        }
                    } else {
                        IconsModel.nFocusIndex = 0;
                    }
                }
                ViewControll.SetFocusIconIndex( View.nViewId, IconsModel.nFocusIndex )
            }
        }
    }
}
