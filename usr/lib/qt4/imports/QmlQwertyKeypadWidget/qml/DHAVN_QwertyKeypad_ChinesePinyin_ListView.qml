import QtQuick 1.1
import AppEngineQMLConstants 1.0

ListView{
    id: root

    property int focusID: -1
    property bool is_focusable: true
    property bool is_focusMovable: true
    property bool focus_visible: false

    property int currentTotalCharacter: 0
    property int prevIndex: -1

    signal lostFocus( int arrow, int focusID )

    /**************************************************************************/
    function handleJogEvent( event, status )
    {
        switch ( event )
        {
        case UIListenerEnum.JOG_UP: //UP
        case UIListenerEnum.JOG_DOWN: //DOWN
        case UIListenerEnum.JOG_BOTTOM_LEFT:
        case UIListenerEnum.JOG_BOTTOM_RIGHT:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                root.lostFocus( event, 0 )
            }
        }
        break

        case UIListenerEnum.JOG_RIGHT: //RIGHT
        case UIListenerEnum.JOG_WHEEL_RIGHT:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if( currentIndex  == (count -1) )
                {
                    root.lostFocus( event, 0 )
                }
                else
                {
                    root.incrementCurrentIndex()
                }
            }
        }
        break

        case UIListenerEnum.JOG_LEFT: //LEFT
        case UIListenerEnum.JOG_WHEEL_LEFT:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if(currentIndex == 0)
                {
                    root.lostFocus( event, 0 )
                }
                else
                {
                    root.decrementCurrentIndex()
                }
            }
        }
        break

        case UIListenerEnum.JOG_CENTER:
        {
            root.currentItem.jogSelected( status )
        }
        break

        }
    }

    Connections{
        target: focus_visible ? UIListener: null

        onSignalJogNavigation:
        {
            switch(arrow)
            {
            case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_LEFT:
            case UIListenerEnum.JOG_RIGHT:
            case UIListenerEnum.JOG_WHEEL_LEFT:
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            case UIListenerEnum.JOG_BOTTOM_LEFT:
            case UIListenerEnum.JOG_BOTTOM_RIGHT:
            case UIListenerEnum.JOG_CENTER:
            {
                handleJogEvent(arrow, status)
            }
            break
            }
        }
    }
}
