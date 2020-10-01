import QtQuick 1.1

Loader{
    id: root

    property bool is_focusable: true
    property bool is_focusMovable: true
    property bool focus_visible: false
    property bool is_base_item: true

    property string name: "FocusedLoader"
    property int focus_x: -1
    property int focus_y: -1
    property int default_x: -1
    property int default_y: -1
    property int focus_z: 0

    signal lostFocus( int direction, int focusID )
    signal setFocus(int fx, int fy)
    signal recheckFocus()
    signal moveFocus( int delta_x, int delta_y )

    /**************************************************************************/
    //    function resetData()
    //    {
    //        if ( root.status == Loader.Ready && root.item.is_focusable )
    //        {
    //            root.item.resetData()
    //        }
    //    }

    /**************************************************************************/

    function setDefaultFocus( arrow )
    {
        var result = -1

        if ( root.status == Loader.Ready &&
                root.item.is_focusable && root.item.is_focusMovable)
        {
            result = root.item.setDefaultFocus( arrow )
        }

        return result
    }


    /**************************************************************************/
    function hideFocus()
    {
        root.focus_visible = false

        if ( root.status == Loader.Ready &&
                root.item.is_focusable && root.item.is_focusMovable)
        {
            root.item.hideFocus()
        }
    }

    /**************************************************************************/
    function showFocus()
    {
        root.focus_visible = true

        if ( root.status == Loader.Ready &&
                root.item.is_focusable && root.item.is_focusMovable)
        {
            root.item.showFocus()
        }
    }

    /**************************************************************************/
    function handleJogEvent( event, status, bRRC )
    {
        if ( root.status == Loader.Ready &&
                root.item.is_focusable && root.item.is_focusMovable)
        {
            root.item.handleJogEvent( event, status, bRRC )
        }
    }

    function lostFocusHandle(event, focusID)
    {
        if ( root.status == Loader.Ready )
        {
            root.lostFocus(event, focusID)
        }
    }

    function moveFocusHandle(delta_x, delta_y)
    {
        if ( root.status == Loader.Ready )
        {
            root.moveFocus(delta_x, delta_y)
        }
    }

    function recheckFocusHandle()
    {
        if ( root.status == Loader.Ready )
        {
            root.recheckFocus()
        }
    }

    function setFocusHandle(fx, fy) {
        root.focus_visible = true

        if ( root.status == Loader.Ready )
        {
            root.setFocus(focus_x, focus_y)
        }
    }

    function connectSignalSetFocus()
    {
        if ( root.status == Loader.Ready )
        {
            root.item.connectSignalSetFocus()
        }
    }

    /**************************************************************************/
    function canTakeOldFocus()
    {
        var result = false

        if ( root.status == Loader.Ready &&
                root.item.is_focusable && root.item.is_focusMovable)
        {
            if ( root.item.canTakeOldFocus == null )
            {
                if ( root.item.canTakeFocus == null )
                {
                    result = true
                }
                else
                {
                    result = root.item.canTakeFocus()
                }
            }
            else
            {
                result = root.item.canTakeOldFocus()
            }
        }

        return result
    }


    /**************************************************************************/
    function canTakeFocus()
    {
        var result = false

        if ( root.status == Loader.Ready &&
                root.item.is_focusable && root.item.is_focusMovable)
        {
            if ( root.item.canTakeFocus == null )
            {
                result = true
            }
            else
            {
                result = root.item.canTakeFocus()
            }
        }

        return result
    }


    /**************************************************************************/

    onStatusChanged:
    {
        if ( root.status == Loader.Ready )
        {
            if( root.item.is_focusable )
            {
                root.item.lostFocus.connect   ( root.lostFocusHandle    )
                root.item.moveFocus.connect   ( root.moveFocusHandle    )
                root.item.setFocus.connect    ( root.setFocusHandle     )
                root.item.recheckFocus.connect( root.recheckFocusHandle )
                root.connectSignalSetFocus()
                root.recheckFocus()
            }
        }
    }
}
