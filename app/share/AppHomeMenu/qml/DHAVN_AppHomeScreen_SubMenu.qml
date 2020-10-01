import QtQuick 1.1

import QmlHomeScreenDef 1.0
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0

Item {
    id: subMenu

    x: 0; y:0; width: 1280; height: 720

    property bool focusOnList: true

    function setPageUpDownIcon(up, down) {
        image_list_arrow_up.visible = up
        image_list_arrow_down.visible = down
    }

    /*

    Image {
        id: image_top_mask

        y: 92; z:1

        source: "/app/share/images/AppHome/2dep_top_mask.png"
    }
    */


    Image {
        id: imagg_bg_glow

        y: 429; z:1

        source: (LocTrigger.arab) ? "/app/share/images/AppHome/arab/bg_2dep_glow.png" : "/app/share/images/AppHome/bg_2dep_glow.png"
    }

    Image {
        id: image_list_arrow_up

        x: 604; y: 93; z:1

        visible: false
        source: "/app/share/images/AppHome/2dep_list_arrow_up.png"
    }

    Image {
        id: image_list_arrow_down

        x: 604; y: 93+593; z:1

        visible: false
        source: "/app/share/images/AppHome/2dep_list_arrow_down.png"
    }


    Image {
        id: image_sub_menu_icon

        x: (LocTrigger.arab) ? 976 : 54
        y: 250
        source: ViewControll.sTitleText == "STR_HOME_MEDIA" ? "/app/share/images/AppHome/ico_home_media_s.png" :
                ViewControll.sTitleText == "STR_BLUELINK" ? "/app/share/images/AppHome/ico_home_bluelink_s.png" :
                ViewControll.sTitleText == "STR_HOME_SETTINGS" ? "/app/share/images/AppHome/ico_home_setting_s.png" : ""
    }

    Text {
        id: text_sub_menu_name_line1

        x: (LocTrigger.arab) ? 976 : 54
        width: 250

        color: "#ffffff"

        horizontalAlignment: Text.AlignHCenter

        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 454+24

        font.pointSize: 44
        font.family: EngineListener.getFont(true)

        text : qsTranslate( "main", ViewControll.sTitleText ) + LocTrigger.empty

        Component.onCompleted: {
            if (paintedWidth > 250) {
                splitString (text_sub_menu_name_line1.text)
                text_sub_menu_name_line2.visible = true
            }
            else {
                text_sub_menu_name_line2.visible = false
            }
        }
    }

    Text {
        id: text_sub_menu_name_line2

        x: (LocTrigger.arab) ? 976 : 54
        width: 250

        color: "#ffffff"

        visible: false

        horizontalAlignment: Text.AlignHCenter

        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 454+54+24

        font.pointSize: 44
        font.family: EngineListener.getFont(true)
    }



    Loader {
        id: titleLoader
        source: "DHAVN_AppHomeScreen_Title.qml"
    }

    function moveFocusToBackKey() {
        if (titleLoader.status == Loader.Ready)
            titleLoader.item.setFocus(true)

        if (subMenuListLoader.status == Loader.Ready)
            subMenuListLoader.item.setFocusVisible(false)

        focusOnList = false
    }

    function moveFocusToList() {
        if (titleLoader.status == Loader.Ready)
            titleLoader.item.setFocus(false)

        if (subMenuListLoader.status == Loader.Ready)
            subMenuListLoader.item.setFocusVisible(true)

        focusOnList = true
    }

    Connections {
        target: EngineListener

        onGoSubMenu: {
            if(screen == UIListener.getCurrentScreen())
            {
                moveFocusToList()
            }
        }
    }



    Connections {
        target: UIListener

        onSignalJogNavigation:
        {
            if (popUpLoader.status != Loader.Ready && subMenu.opacity == 1)
            {
                if( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    switch( arrow )
                    {
                    case UIListenerEnum.JOG_UP:
                    {
                        moveFocusToBackKey()
                        break
                    }

                    case UIListenerEnum.JOG_DOWN:
                    {
                        moveFocusToList()
                        break
                    }

                    case UIListenerEnum.JOG_WHEEL_LEFT: {
                        if (focusOnList && !appLaunching.visible && !goSubMenuAni.running && !goMainMenuAni.running )
                        {
                            if (LocTrigger.arab)
                            {
                                if (subMenuListLoader.status == Loader.Ready)
                                    subMenuListLoader.item.wheelRight()
                            }
                            else
                            {
                                if (subMenuListLoader.status == Loader.Ready)
                                    subMenuListLoader.item.wheelLeft()
                            }
                        }
                        break
                    }

                    case UIListenerEnum.JOG_WHEEL_RIGHT: {
                        if (focusOnList && !appLaunching.visible && !goSubMenuAni.running && !goMainMenuAni.running )
                        {
                            if (LocTrigger.arab)
                            {
                                if (subMenuListLoader.status == Loader.Ready)
                                    subMenuListLoader.item.wheelLeft()
                            }
                            else
                            {
                                if (subMenuListLoader.status == Loader.Ready)
                                    subMenuListLoader.item.wheelRight()
                            }
                        }
                        break
                    }
                    }
                }
            }
        }
    }

    Connections {
        target: LocTrigger

        onRetrigger: {
            //console.log("[SubMenu.qml] ViewControll.sTitleText = " + ViewControll.sTitleText)

            text_sub_menu_name_line1.text = qsTranslate( "main", ViewControll.sTitleText )

            if (text_sub_menu_name_line1.paintedWidth > 250) {
                splitString(text_sub_menu_name_line1.text)
                text_sub_menu_name_line2.visible = true

            } else {
                text_sub_menu_name_line2.visible = false
            }

        }
    }

    function splitString (str) {
        var words = str.split(" ");

        var i = 0;
        text_sub_menu_name_line1.text = "";
        text_sub_menu_name_line2.text = "";

        while (1) {
            text_sub_menu_name_line1.text += words[i];

            if ((text_sub_menu_name_line1.paintedWidth) > 250 && (i == 0)) {
                i++
                break
            }

            if (text_sub_menu_name_line1.paintedWidth > 250) {
                text_sub_menu_name_line1.text = "";
                for (var j = 0 ; j <= i-1 ; j ++) {
                    if ( j ==0 )
                        text_sub_menu_name_line1.text += words[j];
                    else {
                        text_sub_menu_name_line1.text += " ";
                        text_sub_menu_name_line1.text += words[j];
                    }
                }
                break;
            }

            text_sub_menu_name_line1.text += " "
            i++
        }

        while (i<words.length) {
            text_sub_menu_name_line2.text += words[i];
            i++;
            if (i < words.length ) text_sub_menu_name_line2.text += " "
        }
    }
}
