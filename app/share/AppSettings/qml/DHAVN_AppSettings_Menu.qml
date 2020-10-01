import QtQuick 1.0
import com.settings.variables 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import AppEngineQMLConstants 1.0
import "Components/ScrollingTicker"

DHAVN_AppSettings_FocusedItem{
    id: root

    property bool isFixedSelectedItem : false
    property ListModel menu_model: ListModel{}
    property int selected_item: 0
    property bool isMainRootFocused: false

    //By-Han
    property real listCount
    property real yPosition
    property real heightRatio

    property int listIndex: 0

    signal movementEnded()

    //property int currentTopIndex

    Binding {
        target:list_view
        property:"currentIndex"
        value: root.selected_item
    }

    Binding {
        target:list_view
        property:"__current_index"
        value: root.selected_item
    }

    Binding {
        target: root
        property: "listCount"
        value: list_view.count
    }

    Binding {
        target: root
        property: "yPosition"
        value: list_view.visibleArea.yPosition
    }

    Binding {
        target: root
        property: "heightRatio"
        value: list_view.visibleArea.heightRatio
    }

    function setCurrentIndex (index)
    {
        list_view.currentIndex = index
        selected_item = index
    }

    Timer {
        id:flickStartTimer
        interval: 500
        onTriggered: { changeListViewPosition(list_view.currentIndex) }
    }

    /** for Sound Setting */
    function changeListViewPosition(index)
    {
        EngineListener.printLogMessage("ChangeListViewPosition: index:  "+ index)
        EngineListener.printLogMessage("ChangeListViewPosition: currentTopIndex: "+ list_view.currentTopIndex)
        if(index < 6)
        {
            if(index >= list_view.currentTopIndex && index < list_view.currentTopIndex+6)
                return
            else if(index<list_view.currentTopIndex)
            {
                list_view.positionViewAtIndex(list_view.currentTopIndex,ListView.Beginning)
                root.selected_item = list_view.currentTopIndex
            }
            else
                list_view.positionViewAtIndex(0, ListView.Beginning)
        }
        else if(index > 5 && index < 12)
        {
            if(index >= list_view.currentTopIndex && index < list_view.currentTopIndex+6){
                return
            }
            else{
                list_view.positionViewAtIndex(list_view.currentTopIndex, ListView.Beginning)
                root.selected_item = list_view.currentTopIndex
            }
        }
    }

    signal selectItem( int item, bool bJog )
    signal currentIndexChanged(int currentIndex)

    width: APP.const_APP_SETTINGS_B_MENU_WIDTH + 30 //580
    height:  554

    name: "Menu"
    default_x: 0
    default_y: 0

    Component{
        id: item_delegate

        DHAVN_AppSettings_FocusedItem{
            id: item

            property bool __is_dimmed: isDimmed == null ? false : isDimmed

            name: "ItemDelegate_" + index
            focus_x: 0
            focus_y: 0
            default_x: 0
            default_y: 0

            DHAVN_AppSettings_FocusedItem{
                id: dim_indicator

                name: "DIM_INDICATOR"
                focus_x: 0
                focus_y: 0

                visible: !item.__is_dimmed

                onJogSelected:
                {
                    switch ( status )
                    {
                    case UIListenerEnum.KEY_STATUS_PRESSED:
                    {
                        item.pressed = true
                    }
                    break

                    case UIListenerEnum.KEY_STATUS_RELEASED:
                    {
                        item.pressed = false
                        item.jogSelect(true)
                        root.moveFocus( 1, 0 )
                    }
                    break

                    case UIListenerEnum.KEY_STATUS_CANCELED:
                    {
                        item.pressed = false
                    }
                    break
                    }
                }
            }

            function jogSelect( value )
            {
                root.selected_item = index
                selectItem( index, value )
            }

            property bool pressed: false
            property bool selected: index == selected_item

            height: 89
            width: 580
            z: selected ? 10 : 0

            // add for its 243405 -->
            Connections
            {
                target: SettingsStorage

                onResetSoundCompleted:
                {
                    list_view.currentItem.pressed = false
                }

                onResetScreenCompleted:
                {
                    list_view.currentItem.pressed = false
                }

                onResetGeneralCompleted:
                {
                    list_view.currentItem.pressed = false
                }

                onShowLanguageChangingToastPopup:
                {
                    list_view.currentItem.pressed = false
                }
            }
            // add for its 243405 <--


            Item{
                anchors.left: parent.left
                anchors.leftMargin: APP.const_APP_SETTINGS_B_MENU_ITEM_LINE_LEFT_MARGIN

                width: parent.width
                height: parent.height

                Image{
                    id: line_id
                    anchors.left: parent.left
                    y: 89
                    source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                }

                Image{
                    id: image_p_id

                    anchors.left: parent.left
                    anchors.leftMargin: -9
                    anchors.top: line_id.top
                    anchors.topMargin: -90
                    source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_L_PRESSED
                    visible: (mouse_area.pressed || item.pressed) && (!item.__is_dimmed) && !isFixedSelectedItem
                }

                Image {
                    id: image_f_id
                    anchors.left: parent.left
                    anchors.leftMargin: -9
                    anchors.top: line_id.top
                    anchors.topMargin: -90
                    source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_L_FOCUSED
                    visible: ( (index == list_view.currentIndex) && list_view.focus_visible && !(mouse_area.pressed || item.pressed))
                }

                ScrollingTicker {
                    id: scrollingTicker
                    height:parent.height
                    width: (isCheckNA || isPopupItem) ? 449 : 479
                    scrollingTextMargin: 120
                    anchors.left: parent.left
                    anchors.leftMargin: (isVideoMode) && (!isBrightEffectShow) ? 15 : 14
                    anchors.verticalCenter: parent.bottom
                    anchors.verticalCenterOffset: -42
                    isScrolling: ( isParkingMode && list_view.focus_visible && index == list_view.__current_index  )
                    fontBold: ( !list_view.focus_visible && index == list_view.__current_index  )
                    fontPointSize: 40
                    fontStyle: (isVideoMode) && (!isBrightEffectShow) ? Text.Outline : Text.Normal
                    clip: true
                    fontFamily: EngineListener.getFont(false)
                    text:qsTranslate( APP.const_APP_SETTINGS_LANGCONTEXT, list_view.model.get(index).name ) + LocTrigger.empty
                    fontColor: item.__is_dimmed ? APP.const_APP_SETTINGS_MENU_ITEM_DISABLE_TEXT_COLOR :
                                                  list_view.focus_visible ? APP.const_APP_SETTINGS_MENU_ITEM_NORMAL_TEXT_COLOR :
                                                                            index == list_view.currentIndex ? APP.const_APP_SETTINGS_MENU_ITEM_SELECTED_TEXT_COLOR :
                                                                                                              APP.const_APP_SETTINGS_MENU_ITEM_NORMAL_TEXT_COLOR
                }

                Image{
                    id: image_checkbox
                    anchors.left:parent.left
                    anchors.leftMargin: (item.__is_dimmed) ? 470 : 469
                    anchors.top: parent.bottom
                    anchors.topMargin: (item.__is_dimmed) ? -65 : -67
                    //modify for GPS checkBox 13/12/27
                    source: (item.__is_dimmed) ? ((isChekedState) ? RES.const_URL_IMG_SETTINGS_B_CHECKED_S_URL : RES.const_URL_IMG_SETTINGS_B_CHECKED_D_URL )  :
                                               ((isChekedState) ? RES.const_URL_IMG_SETTINGS_B_CHECKED_S_URL : RES.const_URL_IMG_SETTINGS_B_CHECKED_N_URL)
                    //modify for GPS checkBox 13/12/27
                    visible: isCheckNA
                    opacity: (item.__is_dimmed && isChekedState) ? 0.5 : 1.0 //modify for GPS checkBox 13/12/27
                }

                Image{
                    id: image_popup
                    anchors.left:parent.left
                    anchors.leftMargin:469
                    anchors.top: parent.bottom
                    anchors.topMargin: -67

                    source: item.__is_dimmed ? RES.const_URL_IMG_SETTINGS_B_KEYPAD_ARROW_DOWN_D : RES.const_URL_IMG_SETTINGS_B_KEYPAD_ARROW_DOWN_N
                    visible: isPopupItem
                }

                MouseArea{
                    id: mouse_area

                    anchors.fill: parent
                    beepEnabled: false

                    onClicked:
                    {
                        if ( !item.__is_dimmed )
                        {
                            if(list_view.count != 1) //added for ITS 255275 Voice Menu(1List) Beep Sound Issue
                                SettingsStorage.callAudioBeepCommand()

                            item.jogSelect(false)
                        }
                    }
                }
            }

            /*
            Component.onCompleted:
            {
                console.log("[QML][Menu]Component.onCompleted:")
            }
            */
        }
    }

    Connections{
        target: EngineListener

        onMainFocusStateChanged:
        {
            if ( targetScreen != UIListener.getCurrentScreen() )
                return;
            isMainRootFocused = focusPresent
        }
    }

    DHAVN_AppSettings_FocusedList {
        id: list_view
        name: "MenuList"
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 13
        cacheBuffer: 10000
        clip:true
        isMenuListView: true
        interactive:true
        onMovementEnded: { if(list_view.count > 6) flickStartTimer.restart(); root.movementEnded()}
        model: menu_model
        delegate: item_delegate
        snapMode: ListView.SnapToItem
        onContentYChanged: { if(list_view.count > 6) currentTopIndex = indexAt(0, contentY+2) }

        focus_x: 0
        focus_y: 0

        onJogSelected:
        {
            switch ( status )
            {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                list_view.currentItem.pressed = true
            }
            break

            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
                list_view.currentItem.pressed = false
                list_view.currentItem.jogSelect(true)
            }
            break

            case UIListenerEnum.KEY_STATUS_CANCELED:
            {
                list_view.currentItem.pressed = false
            }
            break
            }
        }

        onCurrentIndexChanged:
        {
            menuSelectTimer.restart();
        }
        onSetDefaultIndex: {
            root.currentIndexChanged(list_view.currentIndex)
        }

        Component.onCompleted:
        {
            for(var i=0; i<list_view.model.count; i++)
            {
                list_view.addedElement(i)
            }

            if(list_view.count == 1)
            {
                isFixedSelectedItem = true
            }
        }
    }

    Timer {
        id: menuSelectTimer

        repeat: false
        interval: 70
        onTriggered: root.currentIndexChanged(list_view.currentIndex)
    }
}
