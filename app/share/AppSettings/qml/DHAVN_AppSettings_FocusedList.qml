import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as DEFINE
import AppEngineQMLConstants 1.0

ListView{
    id: root

    property bool is_focusable: true
    property bool is_focusMovable: true
    property bool focus_visible: false
    property bool is_base_item: true
    property bool isMenuListView: true

    property string name: "FocusedList"
    property int focus_x: -1
    property int focus_y: -1

    property bool isCheckJogPressed: false
    property bool isCheckJogLongPressed: false
    property int __current_index: -1
    property bool __is_initialized: false
    property int currentTopIndex: 0

    signal lostFocus( int direction, int focusID )
    signal jogSelected( int status )
    signal jogLeft()
    signal jogRight()
    signal recheckFocus()
    signal setFocus(int x, int y)
    signal moveFocus( int delta_x, int delta_y )
    signal setDefaultIndex()

    /**************************************************************************/
//    function resetData()
//    {
//        if ( root.currentIndex != -1 )
//            root.currentItem.resetData();
//        root.__current_index = -1;
//    }

    /**************************************************************************/

    Timer {
        id: up_long_press_timer

        repeat: true
        interval: 100

        onTriggered: lostFocusHandle(UIListenerEnum.JOG_WHEEL_LEFT, DEFINE.DO_NOT_WRAPPING_AROUND)
    }

    Timer {
        id: down_long_press_timer

        repeat: true
        interval: 100

        onTriggered: lostFocusHandle(UIListenerEnum.JOG_WHEEL_RIGHT, DEFINE.DO_NOT_WRAPPING_AROUND)
    }

    function setDefaultFocus( event )
    {
        var result = -1
        var direction = 1

        if ( !root.__is_initialized )
        {
            var i
            var prevIndex = root.currentIndex

            root.__is_initialized = true

            /*
            for ( i = 0; i < root.count; i++ )
            {
                //root.currentIndex = i
                if ( root.currentItem.recheckFocus != null )
                {
                    root.currentItem.recheckFocus.connect(root.recheckFocusHandle)
                }

                if ( root.currentItem.lostFocus != null && (( !root.currentItem.is_connected )))
                {
                    root.currentItem.is_connected = true
                    root.currentItem.lostFocus.connect(root.lostFocusHandle)
                }
            }
            */

            //root.currentIndex = prevIndex
        }

        if( root.__current_index == -1 )
        {
            switch ( event )
            {
                case UIListenerEnum.JOG_UP:
                {
                    root.__current_index = root.count - 1;
                    direction = -1;
                    break;
                }

                default :
                {
                    root.__current_index = 0;
                    break;
                }
            }
        }

        //root.currentIndex = root.__current_index

        if ( root.currentItem != null )
        {
            if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable )
            {
                for ( ; root.currentIndex < root.count && root.currentIndex > -1;
                     root.currentIndex = root.currentIndex + direction )
                {
                    if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable)
                    {
                        if ( root.itemSetDefFocus( event ) != -1 )
                        {
                            root.__current_index = root.currentIndex
                            result = 0
                            break
                        }
                    }
                }
            }
            else
            {
                result = 0
            }
        }

        //root.currentIndex = -1

        return result
    }


    /**************************************************************************/
    function hideFocus()
    {
        if ( root.currentIndex != -1 && root.currentItem.is_focusable && root.currentItem.is_focusMovable)
        {
            root.currentItem.hideFocus()
        }

        root.__current_index = root.currentIndex
        //root.currentIndex = -1
        root.focus_visible = false
    }


    /**************************************************************************/
    function showFocus()
    {
        root.focus_visible = true
        root.currentIndex = root.__current_index

        if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable)
        {
            root.currentItem.showFocus()
        }
    }


    /**************************************************************************/
    function handleJogEvent( event, status, bRRC )
    {
        /*
        if ( root.currentItem.is_focusable &&
                root.currentItem.is_focusMovable &&
                ( status != UIListenerEnum.KEY_STATUS_LONG_PRESSED) &&
                ( status != UIListenerEnum.KEY_STATUS_RELEASED))
        {
            root.currentItem.handleJogEvent( event, status )
            return
        }
        */

        if(root.flicking || root.moving)
            return;
        //added for ITS 217683 List stuck in time zone
        console.log("[QML] Main Menu State : " + mainMenuState);
        if(mainMenuState == "clock")
        {

            if(isMovementOn == true)
            {
                console.log("[QML]Clock :: Left Radio List Current Movement On !!!!")
                return;
            }
        }

        else if(mainMenuState == "general")
        {
            if(isMovementOn == true)
            {
                console.log("[QML]General:: Left Radio List Current Movement On !!!!")
                return;
            }

        }
        //added for ITS 217683 List stuck in time zone



        if ( event == UIListenerEnum.JOG_CENTER )
        {
            root.currentItem.handleJogEvent( event, status, bRRC )
            return
        }

        switch ( event )
        {
        case UIListenerEnum.JOG_UP: //UP
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                var prev_index

                if(root.currentIndex == 0)
                {
                    root.lostFocus( event, 0 )
                }
                else
                {
                    prev_index = root.currentIndex

                    root.currentIndex--

                    if ( !( root.currentItem.is_focusable && root.currentItem.is_focusMovable &&
                            root.itemSetDefFocus( event ) != -1 ) )
                    {
                        root.currentIndex = prev_index
                        root.lostFocus( event, 0 )
                    }
                    else
                    {
                        root.currentIndex = prev_index
                        isCheckJogPressed = true
                    }
                }
            }

            if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                isCheckJogLongPressed = true
                up_long_press_timer.restart()
            }

            if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                if(isCheckJogLongPressed)
                {
                    up_long_press_timer.stop()
                }
                else
                {
                    if(isCheckJogPressed)
                    {
                        root.lostFocus( event, 0 )
                    }
                }

                isCheckJogPressed = false
                isCheckJogLongPressed = false
            }

            if(status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
                if(isCheckJogLongPressed)
                {
                    up_long_press_timer.stop()
                }

                isCheckJogPressed = false
                isCheckJogLongPressed = false
            }
        }
        break

        case UIListenerEnum.JOG_RIGHT: //RIGHT
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                root.jogRight()

                if(isMenuListView)
                {
                    if (!menuSelectTimer.running)
                        root.lostFocus( event, 0 )
                }
                else
                {
                    root.lostFocus( event, 0 )
                }
            }
        }
        break

        case UIListenerEnum.JOG_DOWN: //DOWN
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                root.lostFocus( event, 0 )
            }

            if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                down_long_press_timer.restart()
            }

            if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                down_long_press_timer.stop()
            }

            if(status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
                down_long_press_timer.stop()
            }
        }
        break

        case UIListenerEnum.JOG_LEFT: //LEFT
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if(isMenuListView)
                {
                    if (!menuSelectTimer.running)
                        root.lostFocus( event, 0 )
                }
                else
                {
                    root.lostFocus( event, 0 )
                }
            }
        }
        break

        case UIListenerEnum.JOG_WHEEL_LEFT:
        case UIListenerEnum.JOG_WHEEL_RIGHT:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                root.lostFocusHandle( event, 0 )
            }
        }
        break

        case UIListenerEnum.JOG_CENTER: //SELECT
        {
            root.jogSelected( status )
        }
        break

        }
    }

    /**************************************************************************/
    function lostFocusHandle( event, focusID )
    {
        var prev_index
        var index

        switch ( event )
        {
        case UIListenerEnum.JOG_UP:
        {
            root.lostFocus( event, 0 )
        }
        break

        case UIListenerEnum.JOG_WHEEL_LEFT:
        {
            if (root.count > 6 && focusID != DEFINE.DO_NOT_WRAPPING_AROUND)
            {
                prev_index = root.currentIndex
                while(1)
                {
                    if (root.currentIndex == 0)
                        root.currentIndex = root.count-1
                    else
                        root.currentIndex--

                    if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable &&
                            root.itemSetDefFocus( event ) != -1 )
                    {
                        index = root.currentIndex
                        root.currentIndex = prev_index
                        root.hideFocus()
                        root.__current_index = index
                        root.showFocus()

                        root.positionViewAtPageUpDown(false)

                        return
                    }
                }
            }
            else
            {
                if ( root.currentIndex > 0 )
                {
                    prev_index = root.currentIndex
                    for ( root.currentIndex--; root.currentIndex >= 0; root.currentIndex-- )
                    {
                        if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable &&
                                root.itemSetDefFocus( event ) != -1 )
                        {
                            index = root.currentIndex
                            root.currentIndex = prev_index
                            root.hideFocus()
                            root.__current_index = index
                            root.showFocus()
                            return
                        }
                    }

                    root.currentIndex = prev_index
                    root.lostFocus( event, 0 )
                }
                else
                {
                    root.lostFocus( event, 0 )
                }
            }
        }
        break

        case UIListenerEnum.JOG_RIGHT:
        {
            root.lostFocus( event, 0 )
        }
        break

        case UIListenerEnum.JOG_DOWN: {}
        break

        case UIListenerEnum.JOG_WHEEL_RIGHT:
        {
            if (root.count > 6 && focusID != DEFINE.DO_NOT_WRAPPING_AROUND)
            {
                prev_index = root.currentIndex
                while(1)
                {
                    if (root.currentIndex == root.count-1)
                        root.currentIndex = 0
                    else
                        root.currentIndex++

                    if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable &&
                            root.itemSetDefFocus( event ) != -1 )
                    {
                        index = root.currentIndex
                        root.currentIndex = prev_index
                        root.hideFocus()
                        root.__current_index = index
                        root.showFocus()

                        root.positionViewAtPageUpDown(true)

                        return
                    }
                }
            }
            else
            {
                if ( root.currentIndex < ( root.count - 1 ) )
                {
                    prev_index = root.currentIndex
                    for ( root.currentIndex++;
                         root.currentIndex < root.count;
                         root.currentIndex++)
                    {
                        if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable &&
                                root.itemSetDefFocus( event ) != -1 )
                        {
                            index = root.currentIndex
                            root.currentIndex = prev_index
                            root.hideFocus()
                            root.__current_index = index
                            root.showFocus()
                            return
                        }
                    }

                    if ( root.currentIndex == root.count )
                    {
                        root.currentIndex = prev_index
                        root.lostFocus( event, 0 )
                    }
                }
                else
                {
                    root.lostFocus( event, 0 )
                }
            }
        }
        break

        case UIListenerEnum.JOG_LEFT:
        {
            root.lostFocus( event, 0 )
        }
        break
        }
    }

    function positionViewAtPageUpDown(is_Down)
    {
        var changeTopIndex = -1

        if(is_Down) // Down
        {
            if(root.currentIndex == 0)
            {
                changeTopIndex = 0
                root.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                root.currentTopIndex = changeTopIndex

                return
            }

            if(root.currentIndex >= root.currentTopIndex && root.currentIndex < root.currentTopIndex+6)
                return
            else
            {
                if( (root.currentTopIndex+11) < root.count )
                {
                    changeTopIndex = root.currentTopIndex+6
                    root.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    root.currentTopIndex = changeTopIndex
                }
                else
                {
                    changeTopIndex = root.count-6
                    root.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    root.currentTopIndex = changeTopIndex
                }
            }
        }
        else        // Up
        {
            if( root.currentIndex == root.count-1 )
            {
                changeTopIndex = root.count-6
                root.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                root.currentTopIndex = changeTopIndex

                return
            }

            if(root.currentIndex >= root.currentTopIndex && root.currentIndex < root.currentTopIndex+6)
                return
            else
            {
                if( root.currentTopIndex-6 <= 0 )
                {
                    changeTopIndex = 0
                    root.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    root.currentTopIndex = changeTopIndex
                }
                else
                {
                    changeTopIndex = root.currentTopIndex-6
                    root.positionViewAtIndex(changeTopIndex, ListView.Beginning)
                    root.currentTopIndex = changeTopIndex
                }
            }
        }
    }

    /**************************************************************************/
    function itemSetDefFocus( event )
    {
        if ( !root.currentItem.is_connected )
        {
            root.currentItem.is_connected = true
            root.currentItem.lostFocus.connect( root.lostFocusHandle )
        }

        if ( root.currentItem.setDefaultFocus( event ) != -1 )
        {
            return 0
        }

        return -1
    }


    /**************************************************************************/
    function recheckFocusHandle()
    {

        if ( !root.canTakeOldFocus() )
        {
            if ( root.canTakeFocus() )
            {
                root.__current_index = -1
                root.setDefaultFocus(UIListenerEnum.JOG_DOWN)
            }
            else
            {
                root.recheckFocus()
            }
        }

        if ( root.focus_visible )
        {
            root.hideFocus()
            root.showFocus()
        }
    }


    /**************************************************************************/
    function canTakeOldFocus()
    {
        var result = false
//        var prevIndex = root.currentIndex

//        root.currentIndex = 0

//        if ( model != null &&
//                root.count > 0 )
//        {
//            if ( root.currentItem.is_focusable )
//            {
//                root.currentIndex = root.__current_index

//                if ( root.__current_index != -1 )
//                {
//                    if ( root.currentItem.canTakeOldFocus == null )
//                    {
//                        if ( root.currentItem.canTakeFocus == null )
//                        {
//                            result = true
//                        }
//                        else
//                        {
//                            result = root.currentItem.canTakeFocus()
//                        }
//                    }
//                    else
//                    {
//                        result = root.currentItem.canTakeOldFocus()
//                    }
//                }
//            }
//            else
//            {
//                result = true
//            }
//        }

//        root.currentIndex = prevIndex

        return result
    }


//    /**************************************************************************/
    function canTakeFocus()
    {
        var result = false
//        var prevIndex = root.currentIndex

//        root.currentIndex = 0

//        if ( model != null &&
//                root.count > 0 )
//        {
//            if ( root.currentItem.is_focusable )
//            {
//                for ( root.currentIndex = 0; root.currentIndex < root.count; root.currentIndex++ )
//                {
//                    if ( root.currentItem.canTakeFocus == null )
//                    {
//                        //workaround. all focused elements should have method for check ability to take focus
//                        result = true
//                        break
//                    }
//                    else if ( root.currentItem.canTakeFocus() )
//                    {
//                        result = true
//                        break
//                    }
//                }
//            }
//            else
//            {
//                result = true
//            }
//        }

//        root.currentIndex = prevIndex

        return result
    }

    function connectSignalSetFocus()
    {

    }

    /**************************************************************************/
    function addedElement( index )
    {
        var prev_index = root.currentIndex

        root.currentIndex = index

        if ( root.currentItem.is_focusable && root.currentItem.is_focusMovable && !root.currentItem.is_connected )
        {
            if ( root.currentItem.lostFocus != null )
            {
                root.currentItem.is_connected = true
                root.currentItem.lostFocus.connect(root.lostFocusHandle)
            }
        }

        root.currentIndex = prev_index
    }


    /**************************************************************************/

    highlightMoveDuration: 1

    //added for ITS 217683 List stuck in time zone
    onMovementStarted:
    {
        isMovementOn = true
        console.log("[QML] Left List Focus Movement Start -------------->")
    }
    onMovementEnded:
    {
        isMovementOn = false
        console.log("[QML] Left List Focus Movement End -------------->")
    }
    //added for ITS 217683 List stuck in time zone

/*
    Component.onCompleted:
    {
        root.currentIndex = 0
    }

    onVisibleChanged:
    {
        root.currentIndex = 0
        root.setDefaultIndex()
    }
    */
}
