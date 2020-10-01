import QtQuick 1.1

import QmlHomeScreenDef 1.0
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0


Item {
    id: helpMenu

    width: 1280; height: 720

    property string image_path: "/app/share/images/AppHome/"
    property color  brighrGray: "#fafafa"
    property color  selectedColor: "#80bfff"
    property int    selected_index: 0
    property int    focused_index: 0
    property bool   focusVisible: true
    property bool   bJogControlled: true
    property bool   focused_pressed: false

    /*
    onFocusVisibleChanged: {
        if (focusVisible)
        {
            back_button.setFocused(false)
        }

        else
        {
            back_button.setFocused(true)
        }
    }
    */

    Rectangle {
        id: bg_image
        x:0; y:93; width: 1280; height: 720-93
        color: "#0F1318"

        MouseArea {
            anchors.fill: parent

            beepEnabled: false
        }

        //source: image_path + "bg_main.png"
    }



    // title bar
    Item {
        id: titleBar;

        y:93; width: image_titlebarBG.width; height: image_titlebarBG.height

        Image { id: image_titlebarBG; source: image_path + "bg_title.png" }

        Text {
            id: strTitle

            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 37

            //anchors.left: parent.left
            //anchors.leftMargin: 46

            font.family: EngineListener.getFont(true)
            font.pointSize: 40

            color: InitData.GetColor( EHSDefP.COLOR_BRIGHT_GREY )
            horizontalAlignment: (LocTrigger.arab) ? Qt.AlignRight : Qt.AlignLeft
            width: 830

            text: qsTranslate( "main", "STR_BT_HELP" ) + LocTrigger.empty //name

            Component.onCompleted: {
                if ( LocTrigger.arab ){
                    strTitle.x = 1280 - strTitle.width - 46
                }

                else {
                    strTitle.x = 46
                }
            }
        }

        PushButton {
            id: back_button

            width: 141; height: 72

            //anchors.right: parent.right

            image_path_normal: image_path + "btn_title_back_n.png"
            image_path_press: image_path + "btn_title_back_p.png"
            image_path_focus: image_path + "btn_title_back_f.png"

            onClicked: EngineListener.BackKeyHandler(UIListener.getCurrentScreen())

            imageMirror: LocTrigger.arab

            Component.onCompleted: {
                if ( LocTrigger.arab )
                {
                    //console.log("countryVariant = eCVMiddleEast")

                    back_button.x = 0
                }

                else
                {
                    back_button.x =  1280 - back_button.width
                }
            }
        }
    }

    Connections {
        target: LocTrigger

        onArabChanged: {
            if ( LocTrigger.arab ){
                strTitle.x = 1280 - strTitle.width - 46
                back_button.x = 0
            }

            else {
                strTitle.x = 46
                back_button.x =  1280 - back_button.width
            }
        }
    }

    ListView {
        id: listView

        anchors.top: parent.top
        anchors.topMargin: 166
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        interactive: true
        boundsBehavior: Flickable.DragAndOvershootBounds

        model: listModel
        delegate: listDelegate
        clip: true
    }

    Connections {
        target: UIListener
        onSignalShowSystemPopup: {
            //console.log("onSignalShowSystemPopup")
            back_button.setFocused(false)
            focusVisible = false
        }
        onSignalHideSystemPopup: {
            //console.log("onSignalHideSystemPopup")
            back_button.setFocused(false)
            focusVisible = true
        }
    }

    ListModel {
        id: listModel

        Component.onCompleted:{
            listModel.append({name: QT_TR_NOOP("STR_HOME_E_MANUAL"), nAppId: EHSDefP.APP_ID_E_MANUAL, nViewId: EHSDefP.VIEW_ID_INVALID})
            listModel.append({name: QT_TR_NOOP("STR_HOME_VIDEO_QUICK_GUIDE"), nAppId: EHSDefP.APP_ID_VIDEO_QUICK_GUIDE, nViewId: EHSDefP.VIEW_ID_INVALID})
        }
    }

    Component {
        id: listDelegate
        Item {
            id: item
            x: 15; y:0; width:1238 ; height: 90

            function itemClicked()
            {
                EngineListener.LaunchApplication( nAppId, nViewId, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , name );
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    image_pressed.visible = true
                }

                onClicked: {
                    image_pressed.visible = false
                    helpMenu.selected_index = index
                    helpMenu.focused_index = index
                    listView.currentIndex = index

                    item.itemClicked()
                }

                onCanceled: image_pressed.visible = false

                onReleased: {
                    image_pressed.visible = false
                }
            }

            Image {
                id: image_list_line

                y:90
                source: image_path + "list_line.png"
            }

            Image {
                id: image_focused
                source: image_path + "list_f.png"
                visible: ( helpMenu.focusVisible && (index == helpMenu.focused_index) ) ? true : false
            }

            Image {
                id: image_pressed
                source: image_path + "list_p.png"
                visible: ( image_focused.visible && focused_pressed ) ? true : false
            }

            Text {
                id: listBtnName

                text: qsTranslate( "main", listView.model.get(index).name ) + LocTrigger.empty //name
                anchors.verticalCenter: image_list_line.top
                anchors.verticalCenterOffset: -42

                width: 830

                //anchors.left: parent.left
                //anchors.leftMargin: 42

                font.family: EngineListener.getFont(false)
                font.pointSize: 40

                horizontalAlignment: (LocTrigger.arab) ? Qt.AlignRight : Qt.AlignLeft

                color: brighrGray

                Component.onCompleted: {
                    if ( LocTrigger.arab ){
                        listBtnName.x = 1238 - listBtnName.width - 87
                    }

                    else {
                        listBtnName.x = 87
                    }
                }
            }

            Connections {
                target: LocTrigger

                onArabChanged: {
                    if ( LocTrigger.arab ){
                        listBtnName.x = 1238 - listBtnName.width - 87
                    }

                    else {
                        listBtnName.x = 87
                    }
                }
            }
        }
    }

    Connections {
        target: UIListener

        onSignalJogNavigation: {

            switch( arrow ) {
            case UIListenerEnum.JOG_CENTER:{
                if (status == UIListenerEnum.KEY_STATUS_PRESSED){
                    if (helpMenu.focusVisible)
                    {
                        focused_pressed = true
                        selected_index = focused_index
                    }

                    else
                    {
                        back_button.setPressed()
                    }
                }

                if (status == UIListenerEnum.KEY_STATUS_RELEASED){

                    if (helpMenu.focusVisible)
                    {
                        focused_pressed = false

                        if (selected_index == 0)
                            EngineListener.LaunchApplication( EHSDefP.APP_ID_E_MANUAL, EHSDefP.VIEW_ID_INVALID, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , "STR_HOME_E_MANUAL" );

                        else if (selected_index == 1)
                            EngineListener.LaunchApplication( EHSDefP.APP_ID_VIDEO_QUICK_GUIDE, EHSDefP.VIEW_ID_INVALID, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , "STR_HOME_VIDEO_QUICK_GUIDE" );
                    }

                    else
                    {
                        back_button.setReleased()
                        EngineListener.BackKeyHandler(UIListener.getCurrentScreen());
                    }
                }

                if ( status == UIListenerEnum.KEY_STATUS_CANCELED )  {
                    ViewControll.bJogPressed = false
                    focused_pressed = false
                    back_button.setReleased()
                }
            }
                break

            case UIListenerEnum.JOG_UP: {
                if (status == UIListenerEnum.KEY_STATUS_PRESSED) {
                    //if (focused_index == 0)
                    //{
                        helpMenu.focusVisible = false
                    back_button.setFocused(true)
                    //}
                }

                /*
                else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED){
                    doLongPressKey = true
                    up_long_press_timer.restart()
                }
                */

                /*
                else if (status == UIListenerEnum.KEY_STATUS_RELEASED){
                    if (doLongPressKey)
                    {
                        doLongPressKey = false
                        up_long_press_timer.stop()
                    }
                    else
                    {

                    }
                }
                */
            }
                break


            case UIListenerEnum.JOG_DOWN: {
                if (status == UIListenerEnum.KEY_STATUS_PRESSED){
                    helpMenu.focusVisible = true
                    back_button.setFocused(false)
                }

                /*
                else if (status == UIListenerEnum.KEY_STATUS_RELEASED){
                    doLongPressKey = false
                    down_long_press_timer.stop()
                }
                */
            }
                break


            case UIListenerEnum.JOG_WHEEL_LEFT: {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    decreaseFocusIndex()
                }
            }
                break

            case UIListenerEnum.JOG_WHEEL_RIGHT: {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    increaseFocusIndex()
                }
            }
                break
            }
        }
    }

    function decreaseFocusIndex () {
        if (focused_index > 0) {
            focused_index--;
            listView.currentIndex = focused_index
        }
    }

    function increaseFocusIndex () {
        if (focused_index < listModel.count-1) {
            focused_index++;
            listView.currentIndex = focused_index
        }
    }
}
