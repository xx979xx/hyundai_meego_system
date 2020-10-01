import Qt 4.7
import AppEngineQMLConstants 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST

ListView
{
    id: root
    focus:focus_visible//Added by Alexey Edelev 2012.10.15

    property bool is_focusable: true
    property bool focus_visible: false
    property bool is_base_item: true

    property string name: "FocusedList"
    property int focus_x: -1
    property int focus_y: -1

    property int defaultFocusIndex: -1 // { addedby Sergey for CR#13466

    property int __current_index: -1
    property bool __is_initialized: false
    property bool isJogSelected: false // added by wspark 2013.04.08
    property real contentBottom: contentY + height // added by yungi 2013.12.12 for NoCR DVD-SearchCaption TopFocus Not visible

    property real currentPage: 0 //added by Michael.Kim 2013.07.23 for New U
    signal lostFocus( int direction )
    signal jogSelected(int status)
    signal jogPressed()
    signal jogReleased()
    signal jogLongPressed()
    signal jogCriticalPressed()
    signal recheckFocus()
    signal moveFocus( int delta_x, int delta_y )
    //signal playChapterPreview(int status, int event) // added by wspark 2013.03.09 for ISV 65056
    signal noFocusFlickingEnded(int moveIndex) // added by yungi 2013.12.12 for NoCR DVD-SearchCaption TopFocus Not visible
        /**************************************************************************/
    function setDefaultFocus( event )
    {
        var direction = 1
        //root.__current_index = 0
        root.log("setDefaultFocus "+ event )

        // { modified by Sergey for CR#13466
        if(defaultFocusIndex != -1)
            root.__current_index = defaultFocusIndex
        else
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_UP:
            {
                root.__current_index = root.findNearestApprIndex(root.count - 1,event)
                direction = -1
            }
            break

            case UIListenerEnum.JOG_RIGHT:
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_LEFT:
            {
                //root.__current_index = root.findNearestApprIndex(0 ,UIListenerEnum.JOG_DOWN)
               root.__current_index = 0
               root.currentIndex = 0
            }
            break


            default:
            {
                //root.__current_index = root.findNearestApprIndex(0 ,UIListenerEnum.JOG_DOWN)
               root.__current_index = 0
               root.currentIndex = 0
            }
            }
        }
        // } modified by Sergey for CR#13466

        if (root.__current_index == -1)
        {
            root.log("setDefaultFocus return -1")
            return -1
        }

        root.currentIndex = root.__current_index


        if ( root.currentItem.is_focusable &&
                root.highlight == null )
        {
            for ( ; root.currentIndex < root.count && root.currentIndex > -1;
                 root.currentIndex = root.currentIndex + direction )
            {
                if ( root.currentItem.is_focusable )
                {
                    if ( root.itemSetDefFocus( event ) != -1 )
                    {
                        root.__current_index = root.currentIndex
                        root.log("setDefaultFocus return 0")
                        return 0

                    }
                }
            }
            root.log("setDefaultFocus return -1")
            return -1

        }
        root.log("setDefaultFocus return  0")
        return 0
    }


    /**************************************************************************/
    function hideFocus()
    {
        root.log("hideFocus() ")
        root.focus_visible = false
        if ( root.currentIndex != -1 && root.currentItem.is_focusable )
        {
            var index = root.currentIndex
            root.currentIndex = root.__current_index
            root.currentItem.hideFocus()
            root.currentIndex = index
        }

        root.__current_index = root.currentIndex
        root.currentIndex = -1
    }


    /**************************************************************************/
    function showFocus()
    {
        root.log("showFocus() ")
        root.focus_visible = true
        root.currentIndex = root.__current_index

        if ( root.currentItem.is_focusable )
        {
            root.currentItem.showFocus()
        }
    }


    function findNearestApprIndex(startIndex,status)
    {
        if(startIndex > root.model.count - 1 || startIndex < 0)
        {
            return -1
        }
        // { added by cychoi 2014.03.28 for ITS 232216 UX fix
        else if(startIndex == root.model.count - 1 || startIndex == 0)
        {
            return startIndex
        }
        // } added by cychoi 2014.03.28
	//modified by aettie CCP wheel direction for ME 20131014
        if(EngineListenerMain.middleEast)
        {
            EngineListenerMain.qmlLog("ZZZ root.model " + root.model.count)
            if (status == UIListenerEnum.JOG_UP
                    || status == UIListenerEnum.JOG_WHEEL_RIGHT) // modified by ravikanth 21-03-13
            {
                if (startIndex > 0)
                   return (startIndex - 1)
            }
            else if (status == UIListenerEnum.JOG_DOWN
                     || status == UIListenerEnum.JOG_WHEEL_LEFT) // modified by ravikanth 21-03-13
            {
               if (startIndex < root.model.count - 1)
                  return (startIndex + 1)
            }
            EngineListenerMain.qmlLog("findNearestApprIndex not found")
        }
        else
        {
            EngineListenerMain.qmlLog("ZZZ root.model " + root.model.count)
            if (status == UIListenerEnum.JOG_UP
                    || status == UIListenerEnum.JOG_WHEEL_LEFT) // modified by ravikanth 21-03-13
            {
                if (startIndex > 0)
                   return (startIndex - 1)
            }
            else if (status == UIListenerEnum.JOG_DOWN
                     || status == UIListenerEnum.JOG_WHEEL_RIGHT) // modified by ravikanth 21-03-13
            {
               if (startIndex < root.model.count - 1)
                  return (startIndex + 1)
            }
            EngineListenerMain.qmlLog("findNearestApprIndex not found")
        }
        return -1
    }

    /**************************************************************************/
    // modified by Dmitry 15.05.13
    function handleJogEvent( event, status )
    {
        root.log("[Mike]handleJogEvent  event= "+event + "status =" + status)

        if (status == UIListenerEnum.KEY_STATUS_PRESSED)
        {
            switch (event)
            {
                case UIListenerEnum.JOG_CENTER:
                {
                    root.jogPressed();
                    root.jogSelected(status)
                    break;
                }
		//moved by aettie Focus moves when pressed 20131015
                // { modified by cychoi 2013.06.28 for wrapping around in the list view
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    EngineListenerMain.qmlLog("[Mike]current page = " + root.currentPage)
    		//{modified by aettie CCP wheel direction for ME 20131014
                    if(EngineListenerMain.middleEast)
                    {
                        root.currentIndex--
                        if(root.currentIndex < 0) {
                            if(root.currentPage < 1) 
                                root.currentIndex = root.model.count -1 //added by Michael.Kim 2013.07.23 for New UX
                            else
                                root.currentIndex = 0 //added by Michael.Kim 2013.07.23 for New UX
                        }
                    }
                    else
                    {
                        root.currentIndex++
                        if(root.currentIndex >= root.model.count) {
                            if(root.currentPage < 1)
                               root.currentIndex = 0 //added by Michael.Kim 2013.07.23 for New UX
                            else
                               root.currentIndex = root.model.count -1 //added by Michael.Kim 2013.07.23 for New UX
                        }
                    }
                    EngineListenerMain.qmlLog("[Mike]current index = " + root.currentIndex)

                    isJogSelected = true
                    //playChapterViewTimer.restart()
                    break
                }

                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    EngineListenerMain.qmlLog("[Mike]current page = " + root.currentPage)
                    if(EngineListenerMain.middleEast)
                    {
                        root.currentIndex++
                        if(root.currentIndex >= root.model.count) {
                            if(root.currentPage < 1)
                               root.currentIndex = 0 //added by Michael.Kim 2013.07.23 for New UX
                            else
                               root.currentIndex = root.model.count -1 //added by Michael.Kim 2013.07.23 for New UX
                        }
                    }
                    else
                    {
                        root.currentIndex--
                        if(root.currentIndex < 0) {
                            if(root.currentPage < 1) 
                                root.currentIndex = root.model.count -1 //added by Michael.Kim 2013.07.23 for New UX
                            else
                                root.currentIndex = 0 //added by Michael.Kim 2013.07.23 for New UX
                        }
                    }
    		//}modified by aettie CCP wheel direction for ME 20131014
                    EngineListenerMain.qmlLog("[Mike]current index = " + root.currentIndex)

                    isJogSelected = true
                    //playChapterViewTimer.restart()
                    break
                }
            // } modified by cychoi 2013.06.28
	    //modified by aettie Focus moves when pressed 20131015
                case UIListenerEnum.JOG_RIGHT:
                case UIListenerEnum.JOG_LEFT:
                {
                    if (jogPressTimer.lastPressed == -1)
                    {
                        isJogSelected = false
                        root.lostFocus( event )
                    }
                    break
                }

                // { commented by cychoi 2014.03.28 for ITS 232216 UX fix
                //case UIListenerEnum.JOG_DOWN:
                //case UIListenerEnum.JOG_UP:
                //{
                    // { added by Michael.Kim 2013.06.07 for current focus index change
                //    if (jogPressTimer.lastPressed == -1)
                //    {
                //        if (UIListenerEnum.JOG_UP == event) root.lostFocus(UIListenerEnum.JOG_UP);
                //    }
                //    break;
                //}
                // } commented by cychoi 2014.03.28
                default:
                    break;

            }
        }
        else if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
        {
            switch ( event )
            {

                case UIListenerEnum.JOG_RIGHT:
                case UIListenerEnum.JOG_LEFT:
                {
		//modified by aettie Focus moves when pressed 20131015
                    if (jogPressTimer.lastPressed != -1)
                    {
                        EventsEmulator.lockScrolling(root, true);
                        jogPressTimer.stop();
                        if(currentIndex >=0 && !atYEnd && !atYBeginning)
                            root.positionViewAtIndex(root.currentIndex, event === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                        jogPressTimer.iterations = 0;
                        //playChapterPreview(status, jogPressTimer.lastPressed) // added by wspark 2013.03.09 for ISV 65056
                        jogPressTimer.lastPressed = -1;
                    }
                    break
                }

                case UIListenerEnum.JOG_DOWN:
                case UIListenerEnum.JOG_UP:
                {
		//modified by aettie Focus moves when pressed 20131015
                    // { added by Michael.Kim 2013.06.07 for current focus index change
                    // { modified by cychoi 2014.03.28 for ITS 232216 UX fix
                    if (jogPressTimer.lastPressed == -1)
                    {
                        if (UIListenerEnum.JOG_UP == event) root.lostFocus(UIListenerEnum.JOG_UP);
                    }
                    else //if (jogPressTimer.lastPressed != -1)
                    // } modified by cychoi 2014.03.28
                    {
                        jogPressTimer.stop();
                        if(root.currentIndex >=0 && root.currentIndex < root.count)
                            root.positionViewAtIndex(root.currentIndex, event == UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                        jogPressTimer.iterations = 0;
                        jogPressTimer.lastPressed = -1;
                    }
                    break;
                }

                case UIListenerEnum.JOG_CENTER:
                {
                    root.jogReleased();
                    root.jogSelected(status)
                    break;
                }
                default:
                {
                    root.log( "handleJogEvent  incorrect event" )
                }
            }
        }
        else if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED )
        {
            //{Changed by Alexey Edelev 2012.10.15
            switch ( event )
            {
            case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_DOWN:
            {
                EventsEmulator.lockScrolling(root, false);
                jogPressTimer.lastPressed = event;
                jogPressTimer.start();
                break;

            }

            case UIListenerEnum.JOG_CENTER:
            {
                root.jogLongPressed();
                break;
            }

            default:
                break;
            }
        }
        else if ( status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED )
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_CENTER:
            {
                root.jogCriticalPressed();
                break;
            }

            default:
                break;

            }
        }
        // { added by cychoi 2014.10.06 for ITS 249690, ITS 249692 Key Cancel on SearchCaption
        else if ( status == UIListenerEnum.KEY_STATUS_CANCELED )
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_CENTER:
            {
                root.jogSelected(status)
                break;
            }

            case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_DOWN:
            {
                jogPressTimer.stop();
                jogPressTimer.iterations = 0;
                jogPressTimer.lastPressed = -1;
                break;
            }
        
            default:
                break;
            }
        }
        // } added by cychoi 2014.10.06
    }
    // modified by Dmitry 15.05.13
    // { added by wspark 2013.04.03 for ISV 78422
    function handleTouchEvent( index )
    {
        if(focus_visible)
        {
            if(index > root.model.count - 1 || index < 0)
            {
                EngineListenerMain.qmlLog("handleTouchEvent invalid index return.")
                return -1
            }
            root.currentIndex = index
        }
        else
        {
            root.lostFocus( event )
            root.currentIndex = index
        }
    }
    // } added by wspark

    /**************************************************************************/
    function lostFocusHandle( event, focusID )
    {
        root.log( "lostFocusHandle "+ event )
        var prev_index
        var index

        switch ( event )
        {
        case UIListenerEnum.JOG_UP:
        {
            if ( root.currentIndex > 0 )
            {
                prev_index = root.currentIndex
                for ( root.currentIndex--; root.currentIndex >= 0; root.currentIndex-- )
                {
                    if ( root.currentItem.is_focusable &&
                            root.itemSetDefFocus( event ) != -1 )
                    {
                        index = root.currentIndex
                        root.__current_index = prev_index
                        root.hideFocus()
                        root.__current_index = index
                        root.showFocus()
                        return
                    }
                }

                root.lostFocus( event )
            }
            else
            {
                root.lostFocus( event )
            }
        }
        break

        case UIListenerEnum.JOG_RIGHT:
        {
            root.lostFocus( event )
        }
        break

        case UIListenerEnum.JOG_DOWN:
        {
            if ( root.currentIndex < ( root.count - 1 ) )
            {
                prev_index = root.currentIndex
                for ( root.currentIndex++;
                     root.currentIndex < root.count;
                     root.currentIndex++)
                {
                    if ( root.currentItem.is_focusable &&
                            root.itemSetDefFocus( event ) != -1 )
                    {
                        index = root.currentIndex
                        root.__current_index = prev_index
                        root.hideFocus()
                        root.__current_index = index
                        root.showFocus()
                        return
                    }
                }
            }
            else
            {
                root.lostFocus( event )
            }
        }
        break

        case UIListenerEnum.JOG_LEFT:
        {
            root.lostFocus( event )
        }
        break

        case UIListenerEnum.JOG_WHEEL_RIGHT:
        {

        }
        break

        case UIListenerEnum.JOG_WHEEL_LEFT:
        {

        }
        break
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
    function log( str )
    {
        EngineListenerMain.qmlLog( "FocusedList [" + root.name + "]: " + str )
    }

    // { added by wspark 2013.03.09 for ISV 65056
    //Timer
    //{
    //    id: playChapterViewTimer
    //    // { modified by wspark 2013.04.05
    //    interval: 300 //modified by Michael.Kim 2013.06.21 for ISV Issue #85257
    //    //interval: 200
    //    // } modified by wspark
    //    repeat: false
    //    running: false
    //    triggeredOnStart: false

    //    onTriggered:
    //    {
    //        playChapterPreview(UIListenerEnum.KEY_STATUS_RELEASED, UIListenerEnum.JOG_WHEEL_RIGHT) // modified by Dmitry 15.05.13
    //    }
    //}
    // } added by wspark


    // { modified by ravikanth 12-10-06
    Timer
    {
        id: jogPressTimer
        interval: 30
        repeat: true
        running: false
        triggeredOnStart: true//Added by Alexey Edelev 2012.10.15
        property int iterations: 0//Added by Alexey Edelev 2012.10.15
        property int lastPressed: -1//Changed by Alexey Edelev 2012.10.15

        onTriggered:
        {
            //{Changed by Alexey Edelev 2012.10.15
            if(lastPressed == UIListenerEnum.JOG_UP
                    && (root.contentY + 10) >= root.currentItem.y) {
                if(iterations < 30) {
                    iterations++
                }
                root.log("ruinaede --> jogPressTimer UP")
                EventsEmulator.sendWheel(UIListenerEnum.JOG_UP, (120 + 120 * Math.floor(iterations / 10)), root);
                return;
            }

            if(lastPressed == UIListenerEnum.JOG_DOWN
                    && (root.contentY + root.height - 10) <= (root.currentItem.y + root.currentItem.height)) {
                if(iterations < 30) {
                    iterations++
                }
                root.log("ruinaede --> jogPressTimer DOWN")
                EventsEmulator.sendWheel(UIListenerEnum.JOG_DOWN, (120 + 120 * Math.floor(iterations / 10)), root);
                return;
            }

            var startIndex = (lastPressed == UIListenerEnum.JOG_DOWN )? root.currentIndex + 1 :root.currentIndex - 1
            var nextIndex = root.findNearestApprIndex(startIndex,lastPressed)
            if ( ( nextIndex != -1 ) && ( lastPressed >= 0 ) )
            {
                root.currentIndex = nextIndex
                //playChapterViewTimer.restart()
            }
            else
            {
                root.log("handleJogEvent  UIListenerEnum.JOG_DOWN/JOG_UP lostFocus")
            }
            //}Changed by Alexey Edelev 2012.10.15
        }
    }
    // } modified by ravikanth 12-10-06

    //{Added by Alexey Edelev 2012.10.15
    onContentYChanged: {
        var tmpIndex = -1;
        switch(jogPressTimer.lastPressed)
        {
        case UIListenerEnum.JOG_UP:
            tmpIndex = indexAt ( 10, Math.floor(contentY + 10) );
            break;
        case UIListenerEnum.JOG_DOWN:
            tmpIndex = indexAt ( 10, Math.floor(contentY + height - 10) );
            break;
        }
        if(tmpIndex >= 0 ) {
            currentIndex = tmpIndex;
        }
    }
    //}Added by Alexey Edelev 2012.10.15
    onLostFocus:
    {
        root.log( "onLostFocus "+ direction )
    }

    highlightMoveDuration: 1 //Changed by Alexey Edelev 2012.10.15

    onMoveFocus:
    {
        root.log( "onMoveFocus" )
    }

    // { added by yungi 2013.12.12 for NoCR DVD-SearchCaption TopFocus Not visible
    onMovementEnded:
    {
        // { modified by cychoi 2014.04.02 for ITS 232218 GUI fix
        var tmp_start_index = indexAt(43, contentY + 10)
        if (tmp_start_index == -1)
            tmp_start_index = indexAt(43, contentY + CONST.const_SEARCHCAPTION_LIST_SECTION_HEIGHT + 10)

        var tmp_end_index = indexAt(43, contentBottom - 10)
        if (tmp_end_index == -1)
            tmp_end_index = indexAt(43, contentBottom - ( CONST.const_SEARCHCAPTION_LIST_SECTION_HEIGHT + 10 ))
        // } modified by cychoi 2014.04.02

        if(tmp_end_index < 0)
        {
            root.log( "[SearchCaptionList]item count is smaller than screen")
        }
        else if(!((root.currentIndex >= tmp_start_index) && (root.currentIndex <= tmp_end_index)))
        {
            root.currentIndex = tmp_start_index

            if (root.currentIndex == -1)
            {
                root.currentIndex = indexAt(10, contentY + CONST.const_SEARCHCAPTION_LIST_SECTION_HEIGHT + 10)
            }
            if(focus_visible == false) noFocusFlickingEnded(root.currentIndex)
        }
        if(focus_visible == false) noFocusFlickingEnded(0) // added by cychoi 2014.03.28 for ITS 232218 GUI fix
    }
    // } added by yungi 2013.12.12
}
