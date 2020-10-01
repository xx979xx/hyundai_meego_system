import Qt 4.7

//teleca import
import QmlQwertyKeypadWidget 1.0
import AppEngineQMLConstants 1.0// 2012-03-16 Problem Kang

MComponent {
    id: idContainer

    property alias qY: idQmlQwertyKeypadWidget.y
    property alias qX: idQmlQwertyKeypadWidget.x
    property string outputText: ""
    property int outputCursor: 0
    property int currentCursor: 0
    // [2011-12-21] 5.3.15 QmlQwertyKeypadWidget removed screenName property
    property string screenName: "HomeMenuKeypad"

    signal keyNaviUp();
    signal keyNaviDown();
    signal keyOKClicked();

    function showQwertyKeypad()
    {
        idQmlQwertyKeypadWidget.showQwertyKeypad();
    }

    function hideQwertyKeypad()
    {
        idQmlQwertyKeypadWidget.hideQwertyKeypad();
    }

    function isHide()
    {
        return idQmlQwertyKeypadWidget.isHide;
    }

    QmlQwertyKeypadWidget {
        id: idQmlQwertyKeypadWidget
        x: qX; y: qY
        focus_visible: showFocus && idContainer.activeFocus// 2012-03-16 Problem Kang
        // [2011-12-21] 5.3.15 QmlQwertyKeypadWidget removed screenName property
        //screenName: idContainer.screenName
        function input( key, label, state )
        {
            var nPos = 0;
            //console.log( key )
            //console.log(String.fromCharCode( key ))
            //console.log( label )
            //console.log( state )
            if ( 0xFF/* SEARCH_BOX_MAX_KEY_CODE */ > key )
            {
                nPos = currentCursor;
                var TextForAdding = label
               // var TextForAdding = fixedFromCharCode( key )
                var offset = 0
                if(state) offset = 1;

                outputText = outputText.substring( 0, nPos - offset ) +
                                             TextForAdding +
                                             outputText.substring( nPos );
                outputCursor = nPos + TextForAdding.length;

                console.log("outputText: " + outputText + " outputCursor: " + outputCursor);
            }
            else if ( Qt.Key_Back == key )
            {
                nPos = currentCursor - 1;
                outputText = outputText.substring( 0, nPos ) +
                                             outputText.substring( nPos + 1 );
                outputCursor = nPos;
            }
            else if ( Qt.Key_Home == key )
                keyOKClicked();

        }

        function fixedFromCharCode ( codePt )
        {
            var test = 0xFFFF;
            console.log( "test: " + test );
            if ( codePt > 0xFFFF/* SEARCH_BOX_MAX_SYMBOL_CODE */ )
            {
                codePt -= 0x10000/* SEARCH_BOX_SUB_VAL */;
                return String.fromCharCode( 0xD800/* SEARCH_BOX_MASK_1 */ + ( codePt >> 10), 0xDC00/* SEARCH_BOX_MASK_2 */ + ( codePt & 0x3FF /* SEARCH_BOX_MASK_3 */ ) );
            }
            else
            {
                return String.fromCharCode(codePt);
            }
        }

        onKeyReleased: {
            input( key, label, state );
        }

        onKeyPressAndHold:
        {
            if( Qt.Key_Back == key )
            {
                outputText = "";
                outputCursor = 0;
            }
        }

        onLostFocus:// 2012-03-16 Problem Kang
        {
            if ((Arrow == UIListenerEnum.JOG_UP)|| (Arrow == UIListenerEnum.JOG_TOP_RIGHT)||( Arrow == UIListenerEnum.JOG_TOP_LEFT))
                keyNaviUp();
            else
                keyNaviDown();
        }
    }

//    onEtcKeyPressed: {// 2012-03-16 Problem Kang
//        switch(key)
//        {
//        case Qt.Key_Right:
//            idQmlQwertyKeypadWidget.onJDEventRight();
//            break;
//        case Qt.Key_Left:
//            idQmlQwertyKeypadWidget.onJDEventLeft();
//            break;
//        case Qt.Key_Up:
//            idQmlQwertyKeypadWidget.onJDEventUp();
//            break;
//        case Qt.Key_Down:
//            idQmlQwertyKeypadWidget.onJDEventDown();
//            break;
//        }
//    }

    onSelectKeyPressed: {
        idQmlQwertyKeypadWidget.onJDEventSelect();
    }
    onWheelRightKeyPressed: {
        idQmlQwertyKeypadWidget.onJDEventRight();
    }
    onWheelLeftKeyPressed: {
        idQmlQwertyKeypadWidget.onJDEventLeft();
    }
}
