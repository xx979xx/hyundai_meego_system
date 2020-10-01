import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as DEFINE
import AppEngineQMLConstants 1.0

ListView{
    id: root

    property bool is_focusable: true
    property bool is_focusMovable: true
    property bool focus_visible: false
    property bool is_base_item: true

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
        if(root.flicking || root.moving)
            return;

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

                if(root.visibleArea.yPosition == 0)
                {
                    root.lostFocus( event, 0 )
                }
                else
                {
                    isCheckJogPressed = true
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

            if (status == UIListenerEnum.KEY_STATUS_CANCELED)
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
                root.lostFocus( event, 0 )
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

            if (status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
                down_long_press_timer.stop()
            }
        }
        break

        case UIListenerEnum.JOG_LEFT: //LEFT
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                root.lostFocus( event, 0 )
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
            //added for ITS 221845 systemInfo scroll issue
            if(SettingsStorage.currentRegion == 2)
                root.positionViewAtPageUpDownEx(false)
            else
                root.positionViewAtPageUpDown(false)
            //added for ITS 221845 systemInfo scroll issue

            //root.positionViewAtPageUpDown(false)
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
            //added for ITS 221845 systemInfo scroll issue
            if(SettingsStorage.currentRegion == 2)
                root.positionViewAtPageUpDownEx(true)
            else
                root.positionViewAtPageUpDown(true)
            //added for ITS 221845 systemInfo scroll issue

            //root.positionViewAtPageUpDown(true)
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
            root.positionViewAtIndex(root.count-1, ListView.End)
        }
        else        // Up
        {
            root.positionViewAtIndex(0, ListView.Beginning)
        }
    }

    //added for ITS 221845 systemInfo scroll issue
    function positionViewAtPageUpDownEx(is_Down)
    {
        var changeTopIndex = -1
        console.log("[QML]root.currentTopIndex:: " + root.currentTopIndex)


        if(is_Down) // Down
        {

            if(root.currentTopIndex < 5)
            {
                root.positionViewAtIndex(5, ListView.Beginning)
            }
            else if(root.currentTopIndex == 5)
            {
                root.positionViewAtIndex(root.count-1, ListView.End)
            }

        }
        else        // Up
        {

            if(root.currentTopIndex <=5)
            {
               root.positionViewAtIndex(0, ListView.Beginning)
            }
            else if(root.currentTopIndex > 5)
            {
                root.positionViewAtIndex(5, ListView.Beginning)
            }

        }
    }
    //added for ITS 221845 systemInfo scroll issue

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

        return result
    }


//    /**************************************************************************/
    function canTakeFocus()
    {
        var result = false

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
}
