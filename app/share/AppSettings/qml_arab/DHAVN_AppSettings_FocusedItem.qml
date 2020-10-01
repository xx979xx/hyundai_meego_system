import QtQuick 1.1
import AppEngineQMLConstants 1.0

Item{
    id: root

    property bool bExecuteMoveJogLeft: true
    property bool is_focusable: true
    property bool is_focusMovable: true
    property bool focus_visible: false
    property bool is_base_item: true
    property bool container_is_widget: false
    property bool __container_is_focused: false
    property bool container_is_focused: false

    property bool is_connected: false

    property string name: "FocusedItem"
    property int focus_x: -1
    property int focus_y: -1
    property int default_x: -1
    property int default_y: -1
    property int focus_z: 0

    property int __current_index: -1
    property int __prev_index: -1
    property bool __is_initialized: false
    property int __horizontal_size: 0
    property int __vertical_size: 0
    property int __current_x: -1
    property int __current_y: -1

    signal lostFocus( int direction, int focusID )
    signal jogSelected( int status, bool rrc )
    signal widgetJogPressed( int status )
    signal recheckFocus()
    signal moveFocus( int delta_x, int delta_y )
    signal setFocus(int x, int y)

    signal jogUp()
    signal jogDown()
    signal jogLeft()
    signal jogRight()
    signal jogWheelRight()
    signal jogWheelLeft()
    signal jogCenter()

    /**************************************************************************/
    //    function resetData()
    //    {
    //        if ( !(root.container_is_widget && root.__container_is_focused) )
    //        {
    //            if ( root.__current_index != -1 )
    //                root.children[root.__current_index].resetData()
    //        }
    //        root.__prev_index    = -1
    //        root.__current_index = -1
    //    }

    /**************************************************************************/
    function __init()
    {
        var i = 0

        root.__is_initialized = true

        for ( i = 0; i < root.children.length; i++ )
        {
            if ( root.children[i].is_focusable )
            {
                if ( root.children[i].focus_x + 1 > root.__horizontal_size )
                {
                    root.__horizontal_size = root.children[i].focus_x + 1
                }

                if ( root.children[i].focus_y + 1 > root.__vertical_size )
                {
                    root.__vertical_size = root.children[i].focus_y + 1
                }

                if ( root.children[i].lostFocus != null )
                {
                    root.children[i].lostFocus.connect( root.lostFocusHandle )
                }

                if ( root.children[i].setFocus != null )
                {
                    root.children[i].setFocus.connect( root.setFocusHandle)
                }

                if ( root.children[i].recheckFocus != null )
                {
                    root.children[i].recheckFocus.connect( root.recheckFocusHandle )
                }

                if ( root.children[i].moveFocus != null )
                {
                    root.children[i].moveFocus.connect( root.moveFocusHandle )
                }
            }
        }
    }

    /**************************************************************************/
    function setDefaultFocus( arrow )
    {
        var result = -1

        if ( root.visible )
        {
            if ( root.container_is_widget )
            {
                root.__container_is_focused = true
                root.__current_index = -1
                root.__current_x = -1
                root.__current_y = -1

                result = 0
            }
            else
            {
                result = root.setDefaultFocusInContainer( arrow )
            }
        }
        return result
    }


    /**************************************************************************/
    function setDefaultFocusInContainer( arrow )
    {
        var i
        var index = -1
        var max_z = 0;
        var result = -1

        if ( !root.__is_initialized )
        {
            root.__init()
        }

        if ( root.visible )
        {
            if ( root.default_x == -1 && root.default_y == -1 )
            {
                result = 0
            }
            else
            {
                root.__current_index = -1
                root.__current_x = -1
                root.__current_y = -1

                for ( i = 0; i < root.children.length; i++ )
                {
                    if ( root.children[i].is_focusable && root.children[i].is_focusMovable &&
                            root.children[i].focus_x == root.default_x &&
                            root.children[i].focus_y == root.default_y &&
                            root.children[i].visible )
                    {
                        if ( index == -1 )
                        {
                            index = i
                        }
                        else
                        {
                            if ( root.children[i].focus_z > max_z )
                            {
                                max_z = root.children[i].focus_z
                            }
                        }
                    }
                }

                if ( index != -1 )
                {
                    root.__current_index = index
                    root.__current_x = root.default_x
                    root.__current_y = root.default_y
                    if ( root.children[index].setDefaultFocus( arrow ) == -1 )
                    {
                        root.__current_index = -1
                    }
                    else
                    {
                        result = 0
                    }
                }
            }
        }

        return result
    }


    /**************************************************************************/
    function hideFocus()
    {
        root.__prev_index = root.__current_index;

        if ( root.container_is_widget && root.__container_is_focused )
        {
            root.container_is_focused = false
        }
        else
        {
            if ( root.__current_index != -1 && root.focus_visible )
            {
                root.children[root.__current_index].hideFocus()
            }
        }

        root.focus_visible = false
    }


    /**************************************************************************/
    function showFocus()
    {
        root.focus_visible = true

        if ( !root.__is_initialized )
        {
            root.__init()
        }

        if ( root.__current_index == -1 )
        {
            root.setDefaultFocus( UIListenerEnum.JOG_DOWN )
        }

        if ( root.container_is_widget && root.__container_is_focused )
        {
            root.container_is_focused = true
        }
        else
        {
            var new_index = 0

            new_index = root.searchIndex( root.__current_x, root.__current_y )

            if ( root.__current_index != -1 )
            {
                if ( root.children[root.__current_index].visible &&
                        root.__current_index == new_index )
                {
                    root.children[root.__current_index].showFocus()
                }
                else
                {
                    var index = root.searchIndex( root.__current_x, root.__current_y )

                    if ( new_index != -1 )
                    {
                        if ( root.children[new_index].setDefaultFocus( UIListenerEnum.JOG_DOWN ) != -1 )
                        {
                            root.__current_index = new_index
                            root.children[root.__current_index].showFocus()
                        }
                    }
                }
            }
        }
    }


    /**************************************************************************/
    function handleJogEvent( event, status, bRRC )
    {
        if ( !root.focus_visible )
        {
            if ( status == UIListenerEnum.KEY_STATUS_RELEASED ||
                    event == UIListenerEnum.JOG_WHEEL_RIGHT ||
                    event == UIListenerEnum.JOG_WHEEL_LEFT )
            {
                root.showFocus()
            }
            return
        }

        if ( root.container_is_widget && root.__container_is_focused )
        {

            if ( event == UIListenerEnum.JOG_CENTER &&
                    status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                root.widgetJogPressed( status )
                return
            }
        }

        if ( root.__current_index != -1 )
        {
            root.children[root.__current_index].handleJogEvent( event, status, bRRC )
        }
        else
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_UP: //UP
            case UIListenerEnum.JOG_DOWN: //DOWN
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    root.lostFocus( event, 0 )
                }
            }
            break

            case UIListenerEnum.JOG_LEFT:
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    root.jogLeft()

                    if(bExecuteMoveJogLeft)
                        root.lostFocus( event, 0 )
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
            break;

            case UIListenerEnum.JOG_WHEEL_RIGHT: //CLOCK_WISE
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    root.jogWheelRight()
                    root.lostFocus( event, 0 )
                }
            }
            break

            case UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    root.jogWheelLeft()
                    root.lostFocus( event, 0 )
                }
            }
            break

            case UIListenerEnum.JOG_CENTER: //SELECT
            {
                root.jogSelected( status, bRRC )
            }
            break

            }
        }
    }

    /**************************************************************************/
    function lostFocusHandle( event, focusID )
    {
        var next_x = -1
        var next_y = -1

        switch ( event )
        {
        case UIListenerEnum.JOG_UP: //UP
        {
            next_x = root.__current_x
            next_y = root.__current_y - 1
            root.jogUp()
        }
        break

        case UIListenerEnum.JOG_RIGHT: //RIGHT
        {
            next_x = root.__current_x - 1
            next_y = root.__current_y
            root.jogRight()
        }
        break

        case UIListenerEnum.JOG_DOWN: //DOWN
        {
            next_x = root.__current_x
            next_y = root.__current_y + 1
            root.jogDown()
        }
        break

        case UIListenerEnum.JOG_LEFT: //LEFT
        {
            next_x = root.__current_x + 1
            next_y = root.__current_y
            root.jogLeft()
        }
        break

        case UIListenerEnum.JOG_WHEEL_RIGHT: //CLOCK_WISE
        case UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
        {
            root.lostFocus( event, 0 )
            return 0
        }
        break

        default:
        {
            return -1
        }
        }

        if ( next_x < 0 || next_x >= root.__horizontal_size ||
                next_y < 0 || next_y >= root.__vertical_size )
        {
            root.lostFocus( event, 0 )
            return 0
        }

        var item_index = root.searchIndex( next_x, next_y )

        if ( item_index == -1 )
        {
            return -1
        }

        if ( root.children[item_index].setDefaultFocus( event ) != -1 )
        {
            root.hideFocus()
            root.__current_index = item_index
            root.__current_x = next_x
            root.__current_y = next_y
            root.showFocus()
        }

        return 0
    }


    /**************************************************************************/
    function searchIndex( pos_x, pos_y )
    {
        var index = -1
        var max_z = 0

        for ( var i = 0; i < root.children.length; i++ )
        {
            if ( root.children[i].is_focusable &&
                    root.children[i].is_focusMovable &&
                    root.children[i].focus_x == pos_x &&
                    root.children[i].focus_y == pos_y &&
                    root.children[i].visible)
            {
                if ( index == -1 )
                {
                    index = i
                }
                else
                {
                    if ( root.children[i].focus_z > max_z )
                    {
                        max_z = root.children[i].focus_z
                        index = i
                    }
                }
            }
        }

        return index
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
            if ( root.container_is_widget )
            {
                root.setDefaultFocus()
            }

            root.hideFocus()
            if ( root.__current_index == -1 )
            {
                root.setDefaultFocus(UIListenerEnum.JOG_DOWN)
            }

            if(isShowSystemPopup == false)
            {
                root.showFocus()
            }
        }
    }


    /**************************************************************************/
    function moveFocusHandle( delta_x, delta_y )
    {
        if ( delta_x || delta_y )
        {
            var index = searchIndex( root.__current_x + delta_x, root.__current_y + delta_y )

            if ( index != -1 )
            {
                if ( root.children[index].setDefaultFocus( UIListenerEnum.JOG_DOWN ) != -1 )
                {
                    root.hideFocus()
                    root.__current_index = index
                    root.__current_x = root.__current_x + delta_x
                    root.__current_y = root.__current_y + delta_y

                    if ( !( rootToastPopUpLoader.visible || rootPopUpLoader.visible) )
                        root.showFocus()
                }
            }
        }
    }


    /**************************************************************************/
    function canTakeOldFocus()
    {
        var result = false

        if ( root.visible )
        {
            if ( root.default_x == -1 && root.default_y == -1 )
            {
                result = true
            }
            else if ( root.__current_index != -1 )
            {
                var index = root.searchIndex(root.__current_x, root.__current_y)

                if ( index != -1 )
                {
                    if ( root.children[index].canTakeOldFocus == null )
                    {
                        if ( root.children[index].canTakeFocus == null )
                        {
                            result = true
                        }
                        else
                        {
                            result = root.children[index].canTakeFocus()
                        }
                    }
                    else
                    {
                        result = root.children[index].canTakeOldFocus()
                    }
                }
            }
        }

        return result
    }


    /**************************************************************************/
    function canTakeFocus()
    {
        var i = 0
        var result = false

        if ( root.visible )
        {
            if ( root.default_x == -1 && root.default_y == -1 )
            {
                result = true
            }
            else
            {
                if ( !root.__is_initialized )
                {
                    root.__init()
                }

                for ( i = 0; i < root.children.length; i++ )
                {
                    if ( root.children[i].is_focusable &&
                            root.children[i].visible   &&
                            root.children[i].is_focusMovable )
                    {
                        if ( root.children[i].canTakeFocus == null )
                        {
                            //return true for elements that does not support function canTakeFocus
                            //all focused elements should support this function
                            result = true
                            break
                        }
                        else if ( root.children[i].canTakeFocus() )
                        {
                            result = true
                            break
                        }
                    }
                }
            }
        }

        return result
    }

    function connectSignalSetFocus()
    {
        for (var i = 0; i < root.children.length; i++)
        {
            if ( root.children[i].setFocus != null )
            {
                root.children[i].setFocus.connect( root.setFocusHandle )
                root.children[i].connectSignalSetFocus()
            }
        }
    }

    function setFocusHandle(fx, fy) {
        root.focus_visible = true

        root.__current_x = fx
        root.__current_y = fy

        var index = root.searchIndex( root.__current_x, root.__current_y)
        root.__current_index = index

        root.setFocus(root.focus_x, root.focus_y)
    }
}
