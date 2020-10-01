import QtQuick 1.1
import AppEngineQMLConstants 1.0
import Transparency 1.0

TransparencyPainter{
    id: root

    property bool is_focusable: true
    property bool is_focusMovable: true
    property bool focus_visible: false
    property bool is_base_item: true

    property bool is_connected: false

    property string name: "FocusedItem"
    property int focus_x: -1
    property int focus_y: -1
    property int default_x: -1
    property int default_y: -1
    property int focus_z: 0

    property int __current_index: -1
    property bool __is_initialized: false
    property int __horizontal_size: 0
    property int __vertical_size: 0
    property int __current_x: -1
    property int __current_y: -1

    signal lostFocus( int direction, int focusID )
    signal jogSelected( int status )
    signal recheckFocus()
    signal moveFocus( int delta_x, int delta_y )

    /**************************************************************************/
//    function resetData()
//    {
//        if ( root.__current_index != -1 )
//            root.children[root.__current_index].resetData();
//        root.__current_index = -1;
//        root.__current_x = -1;
//        root.__current_y = -1;
//    }

    /**************************************************************************/
    function setDefaultFocus( arrow )
    {
        var i
        var index = -1
        var max_z = 0;

        if ( !root.__is_initialized )
        {
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

                    root.children[i].lostFocus.connect( root.lostFocusHandle )
                    if ( root.children[i].is_base_item )
                    {
                        root.children[i].recheckFocus.connect( root.recheckFocusHandle )
                        root.children[i].moveFocus.connect( root.moveFocusHandle )
                    }
                }
            }
        }

        if ( root.default_x == -1 && root.default_y == -1 )
        {
            return 0
        }

        if ( !root.visible )
        {
            return -1
        }

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
            return root.children[index].setDefaultFocus( arrow )
        }

        return -1
    }


    /**************************************************************************/
    function hideFocus()
    {
        if ( root.__current_index != -1 && root.focus_visible )
        {
            //added for ITS 218952 First Map/Voice Key input and Settings Focus not hide
            if(root.children[root.__current_index].hideFocus() != null){
                root.children[root.__current_index].hideFocus()
            }
            else
            {
               console.log("[QML]children.hideFocus is Not Connected -----")
            }
            //added for ITS 218952 First Map/Voice Key input and Settings Focus not hide

        }

        root.focus_visible = false
    }


    /**************************************************************************/
    function showFocus()
    {
        var new_index = 0

        if ( !root.__is_initialized )
        {
            root.setDefaultFocus( UIListenerEnum.JOG_DOWN )
        }

        root.focus_visible = true

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

        if ( root.__current_index != -1 )
        {
            root.children[root.__current_index].handleJogEvent( event, status, bRRC )
        }
        else
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_UP: //UP
            case UIListenerEnum.JOG_RIGHT: //RIGHT
            case UIListenerEnum.JOG_DOWN: //DOWN
            case UIListenerEnum.JOG_LEFT: //LEFT
            case UIListenerEnum.JOG_WHEEL_RIGHT: //CLOCK_WISE
            case UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
            {
                if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                {
                    root.lostFocus( event, 0 )
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
        }
        break

        case UIListenerEnum.JOG_RIGHT: //RIGHT
        {
            next_x = root.__current_x + 1
            next_y = root.__current_y
        }
        break

        case UIListenerEnum.JOG_DOWN: //DOWN
        {
            next_x = root.__current_x
            next_y = root.__current_y + 1
        }
        break

        case UIListenerEnum.JOG_LEFT: //LEFT
        {
            next_x = root.__current_x - 1
            next_y = root.__current_y
        }
        break

        case UIListenerEnum.JOG_WHEEL_RIGHT: //CLOCK_WISE
        case UIListenerEnum.JOG_WHEEL_LEFT: //ANTI_CLOCK_WISE
        {
            return -1
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
            if ( root.children[i].is_focusable && root.children[i].is_focusMovable &&
                    root.children[i].focus_x == pos_x &&
                    root.children[i].focus_y == pos_y &&
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
        if ( root.focus_visible )
        {
            root.hideFocus()
            root.showFocus()
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
                    root.showFocus()
                }
            }
        }
    }

    /**************************************************************************/

//    onVisibleChanged:
//    {
//        root.recheckFocus()
//    }

}
