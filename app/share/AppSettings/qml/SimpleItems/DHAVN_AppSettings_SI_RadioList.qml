import QtQuick 1.1
import "DHAVN_AppSettings_SI_RadioList.js" as HM
import "../DHAVN_AppSettings_Resources.js" as RES
import AppEngineQMLConstants 1.0

Item{
    id: radioList

    property int defaultValueIndex: 0
    property bool bInteractive: true
    property bool doLongKey: false
    property bool startOnPressed: false
    property bool isFocusedByFlicking: false

    /**radiomodel - model with input*/
    property variant radiomodel

    /**index of select radiobuton*/
    property int currentTopIndex: 0
    property int currentindex

    /** Focus image moving duration in msesc */
    property int focusMoveDuration: 1

    property int focus_id: -1//read_only
    property int focus_index: 0
    property bool focus_visible: false
    property bool is_focusable: true
    property bool is_focusMovable: true

    /**Number of items displayed at the same time */
    property int countDispalyedItems: 6

    /**Font color */
    property string font_color:HM.const_COLOR_BRIGHT_GREY

    /** If focus should check enabled elements */
    property bool bCheckEnable: true

    /**signal sends index (nIndex) of selected radiobutton*/
    signal indexSelected( int nIndex , bool isJog)
    signal radioList_lostFocus(variant direction )
    //should be deleted
    signal lostFocus ( int arrow, int focusID )
    signal movementEnded()

    property string __lang_context: HM.const_LANGCONTEXT

    function handleJogEvent(jogEvent){}//empty methodfs to avoid resets
    function focusUpper() {}
    function focusLower(){}
    function focusClear() {}

    property alias rListHeight: radioListView.height //added for AA/CP Setting

    Timer {
        id: up_long_press_timer

        repeat: true
        interval: 100

        onTriggered: focusUp(false)
    }

    Timer {
        id: down_long_press_timer

        repeat: true
        interval: 100

        onTriggered: focusDown(false)
    }

    function focusDown(is_wrapping)
    {
        if (!focus_visible)
            return

        var rem_focus = focus_index

        do{
            focus_index++

            if (focus_index > radioList.radiomodel.count-1)
            {
                if(radioList.radiomodel.count <= 6)
                    focus_index = rem_focus
                else
                {
                    if(is_wrapping)
                        focus_index = 0
                    else
                        focus_index = rem_focus
                }
            }
        }
        while ( radioList.radiomodel.get(focus_index).enable == false )

        /** pageDown */
        positionViewAtPageUpDown(true)
    }

    function focusUp(is_wrapping)
    {
        if (!focus_visible)
            return

        var rem_focus = focus_index

        do{
            focus_index--

            if (focus_index < 0)
            {
                if(radioList.radiomodel.count <= 6)
                    focus_index = rem_focus
                else
                {
                    if(is_wrapping)
                        focus_index = radioList.radiomodel.count-1
                    else
                        focus_index = rem_focus
                }
            }
        }
        while ( radioList.radiomodel.get(focus_index).enable == false )

        /** pageUp */
        positionViewAtPageUpDown(false)
    }

    function showFocus()
    {
        focus_visible = true
    }

    function hideFocus()
    {
        focus_visible = false
    }

    function checkModel()
    {
        if(!bCheckEnable)
            return true

        if ( radioList.radiomodel.get(currentindex).enable == true )
        {
            if(defaultValueIndex == currentindex)
            {
                var nCount = radioList.radiomodel.count
                if( nCount <= currentindex+1)
                    focus_index = currentindex - 1
                else
                    focus_index = currentindex + 1
            }
            else
                focus_index = defaultValueIndex

            return true
        }

        /*
        for( var i=0;i<radioList.radiomodel.count-1;i++)
        {
            if ( radioList.radiomodel.get(i).enable == true )
            {
                focus_index = i
                return true
            }
        }
        */
        return false
    }

    function setDefaultFocus(arrow)
    {
        if(!isFocusedByFlicking)
        {
            if (checkModel())
            {
                return focus_id
            }
            else
            {
                lostFocus( arrow, focus_id )
                return -1
            }
        }
    }

    function setFirstItemFocused()
    {
        if(focus_index >= currentTopIndex && focus_index < currentTopIndex+6)
            return
        else
        {
            focus_index = currentTopIndex
            radioListView.positionViewAtIndex(focus_index, ListView.Beginning)
        }
    }

    function positionViewAtPageUpDown(is_Down)
    {
        var changeTopIndex = -1

        if(is_Down) // Down
        {
            if(focus_index == 0)
            {
                changeTopIndex = 0
                radioListView.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                currentTopIndex = changeTopIndex

                return
            }

            if(focus_index >= currentTopIndex && focus_index < currentTopIndex+6)
                return
            else
            {
                if( (currentTopIndex+11) < radioListView.count )
                {
                    changeTopIndex = currentTopIndex+6
                    radioListView.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    currentTopIndex = changeTopIndex
                }
                else
                {
                    changeTopIndex = radioListView.count-6
                    radioListView.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    currentTopIndex = changeTopIndex
                }
            }
        }
        else        // Up
        {
            if(focus_index >= currentTopIndex && focus_index < currentTopIndex+6)
                return
            else
            {
                if( focus_index == radioListView.count-1 )
                {
                    changeTopIndex = radioListView.count-6
                    radioListView.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    currentTopIndex = changeTopIndex

                    return
                }

                if( currentTopIndex-6 <= 0 )
                {
                    changeTopIndex = 0
                    radioListView.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    currentTopIndex = changeTopIndex
                }
                else
                {
                    changeTopIndex = currentTopIndex-6
                    radioListView.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    currentTopIndex = changeTopIndex
                }
            }
        }
    }

    function setCurrentTopIndex()
    {
        if(radioListView.indexAt(0, radioListView.contentY) == -1)
        {
            if(radioListView.atYBeginning)
                currentTopIndex = 0

            if(radioListView.atYEnd)
            {
                if( radioListView.count > 6 )
                    currentTopIndex = radioListView.count-6
            }
        }
        else
            currentTopIndex = radioListView.indexAt(0, radioListView.contentY+10)
    }

    Connections{
        target: focus_visible ? UIListener: null

        onSignalJogNavigation:
        {
            if(radioListView.flicking || radioListView.moving)
                return;

            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                switch(arrow)
                {
                case UIListenerEnum.JOG_UP:
                {
                    if(radioListView.currentIndex == 0 )
                        lostFocus(arrow,focus_id)
                    else
                        startOnPressed = true
                }
                break

                case UIListenerEnum.JOG_DOWN:
                {
                    startOnPressed = true
                }
                break

                case UIListenerEnum.JOG_LEFT:
                case UIListenerEnum.JOG_RIGHT:
                {
                    lostFocus(arrow,focus_id)
                }
                break

                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    focusUp(true)
                }
                break

                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    focusDown(true)
                }
                break
                }
            }

            else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                if ( arrow == UIListenerEnum.JOG_DOWN )
                {
                    down_long_press_timer.restart()
                    doLongKey = true
                }

                if ( arrow == UIListenerEnum.JOG_UP )
                {
                    up_long_press_timer.restart()
                    doLongKey = true
                }
            }

            else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                if ( arrow == UIListenerEnum.JOG_DOWN )
                {
                    if (doLongKey)
                    {
                        down_long_press_timer.stop()
                    }
                    else
                    {
                        if (startOnPressed)
                            lostFocus(arrow,focus_id)
                    }

                    doLongKey = false
                    startOnPressed = false
                }

                if ( arrow == UIListenerEnum.JOG_UP )
                {
                    if (doLongKey)
                    {
                        up_long_press_timer.stop()
                    }
                    else
                    {
                        if (startOnPressed)
                            lostFocus(arrow,focus_id)
                    }

                    doLongKey = false
                    startOnPressed = false
                }
            }

            else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
                if ( arrow == UIListenerEnum.JOG_DOWN )
                {
                    if (doLongKey)
                    {
                        down_long_press_timer.stop()
                    }

                    doLongKey = false
                    startOnPressed = false
                }

                if ( arrow == UIListenerEnum.JOG_UP )
                {
                    if (doLongKey)
                    {
                        up_long_press_timer.stop()
                    }

                    doLongKey = false
                    startOnPressed = false
                }
            }
        }
    }

    onIndexSelected: radioList.currentindex = nIndex

    width: 581
    height: 554
    clip: true

    Component{
        id: listDelegate

        DHAVN_AppSettings_SI_RadioButton{
            id: radiobutton

            checked: ( radioList.currentindex == index )
            highlight: (focus_visible && ( focus_index == index ))
            focus_selected: ( focus_index == index )
        }
    }

    /** This rectangle should be removed after when resource will be provided */

    ListView{
        id:radioListView
        width: parent.width
        height: 540
        property bool isFlicking: false

        clip: true
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        snapMode: ListView.SnapToItem
        delegate: listDelegate
        model: radioList.radiomodel
        orientation: ListView.Vertical
        interactive:bInteractive
        currentIndex: focus_visible? radioList.focus_index : -1
        onMovementStarted:
        {


            if(!isFlicking){
                isFlicking = true
                isMovementOn = true //added for ITS 217683 List stuck in time zone
                console.log("[QML] Radio Button List Focus Movement Start -------------->")
                //added for ITS 217683 List stuck in time zone
            }
        }

        onMovementEnded:
        {


            if(radioListView.count > 6)
            {
                setCurrentTopIndex()
                setFirstItemFocused()
            }

            if(isFlicking){
                isFlicking = false
                isMovementOn = false//added for ITS 217683 List stuck in time zone
                console.log("[QML] Radio Button List Focus Movement End -------------->")
                //added for ITS 217683 List stuck in time zone
            }

            radioList.movementEnded()
        }

        onContentYChanged:
        {
            if(!isFlicking)
            {
                var nIndex = 0
                nIndex = contentY / radioListView.currentItem.height
                currentTopIndex = nIndex
            }
        }
    }

    DHAVN_AppSettings_SI_VerticalScrollBar{
        id: scrollbar
        anchors.top: parent.top
        anchors.topMargin: 33
        anchors.left: parent.left
        anchors.leftMargin: 553
        clip: true
        listViewHeight: radioListView.height
        position: radioListView.visibleArea.yPosition
        pageSize: radioListView.visibleArea.heightRatio
        visible: ( pageSize < 1 )
    }

    /** radioListView.count > 6 => Language-Setting */
    onFocus_visibleChanged:
    {
        if(focus_visible)
        {
            if(radioListView.count > 6)
            {
                if(focus_index >= currentTopIndex && focus_index < currentTopIndex+6)
                    return
                else
                {
                    if(currentindex+5 < radioListView.count)
                        currentTopIndex = currentindex
                    else
                        currentTopIndex = radioListView.count-6

                    radioListView.positionViewAtIndex(currentTopIndex, ListView.Beginning)
                }
            }
        }
    }
}

