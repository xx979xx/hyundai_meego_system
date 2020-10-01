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
    property bool currentPageLoop: true //added by Michael.Kim 2013.08.22 for ITS 185733
    signal lostFocus( int direction )
    signal jogSelected(int status)
    signal jogPressed()
    signal jogReleased()
    signal jogLongPressed()
    signal jogCriticalPressed()
    signal recheckFocus()
    signal moveFocus( int delta_x, int delta_y )
    signal focusElement(int index)
    //signal currentIndexInfo (int index) //added by Michael.Kim 2013.06.07 for current focus index change
    //signal playChapterPreview(int status, int event) // added by wspark 2013.03.09 for ISV 65056
    signal indexFlickSelected(int index) // added by yungi 2014.02.03 for ITS 223313

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
                root.__current_index = root.findNearestApprIndex(0 ,UIListenerEnum.JOG_DOWN)
            }
            break


            default:
            {
                root.__current_index = root.findNearestApprIndex(0 ,UIListenerEnum.JOG_DOWN)
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
    //modified by aettie CCP wheel direction for ME 20131014
        if(startIndex > root.model.count - 1 || startIndex < 0)
        {
            return -1
        }
        if (EngineListenerMain.middleEast)
        {
            if (status == UIListenerEnum.JOG_UP
                    || status == UIListenerEnum.JOG_WHEEL_RIGHT) // modified by ravikanth 21-03-13
            {
                for(var i = startIndex; i >= 0 ; --i )
                {
                    if(root.model.get(i).isDimmed === null ||
                            root.model.get(i).isDimmed === undefined ||
                            root.model.get(i).isDimmed === false)
                    {
                        return i
                    }
                }
            }
            else if (status == UIListenerEnum.JOG_DOWN
                     || status == UIListenerEnum.JOG_WHEEL_LEFT) // modified by ravikanth 21-03-13
            {
                for(var i = startIndex; i < root.model.count  ; ++i )
                {
                    if(root.model.get(i).isDimmed === null ||
                            root.model.get(i).isDimmed === undefined ||
                            root.model.get(i).isDimmed === false)
                    {
                        return i
                    }
                }

            }
        }
        else
        {
            if (status == UIListenerEnum.JOG_UP
                    || status == UIListenerEnum.JOG_WHEEL_LEFT) // modified by ravikanth 21-03-13
            {
                for(var i = startIndex; i >= 0 ; --i )
                {
                    if(root.model.get(i).isDimmed === null ||
                            root.model.get(i).isDimmed === undefined ||
                            root.model.get(i).isDimmed === false)
                    {
                        return i
                    }
                }
            }
            else if (status == UIListenerEnum.JOG_DOWN
                     || status == UIListenerEnum.JOG_WHEEL_RIGHT) // modified by ravikanth 21-03-13
            {
                for(var i = startIndex; i < root.model.count  ; ++i )
                {
                    if(root.model.get(i).isDimmed === null ||
                            root.model.get(i).isDimmed === undefined ||
                            root.model.get(i).isDimmed === false)
                    {
                        return i
                    }
                }

            }
        }
        root.log("findNearestApprIndex not found")
        return -1
    }

    function findFarthestApprIndex(status)
    {
        if (root.currentIndex < 0 || root.currentIndex >= root.model.count)
        {
            root.log("findFarthestApprIndex not found")
            return -1
        }

        if (status == UIListenerEnum.JOG_UP)
        {
            for(var i = 0; i <= root.currentIndex  ; ++i )
            {
                if(root.model.get(i).isDimmed === null ||
                        root.model.get(i).isDimmed === undefined ||
                        root.model.get(i).isDimmed === false)
                {
                    return i
                }
            }
        }
        else if (status == UIListenerEnum.JOG_DOWN)
        {
            for(var i = root.model.count -1 ; i >=  root.currentIndex  ; --i )
            {
                if(root.model.get(i).isDimmed === null ||
                        root.model.get(i).isDimmed === undefined ||
                        root.model.get(i).isDimmed === false)
                {
                    return i
                }
            }

        }
        root.log("findFarthestApprIndex not found")
        return -1
    }


    /**************************************************************************/
    // modified by Dmitry 15.05.13
    function handleJogEvent( event, status )
    {
        root.log("handleJogEvent  event= "+event + "status =" + status)
        if ( root.highlight == null &&
                root.currentItem.is_focusable )
        {
            root.currentItem.handleJogEvent( event, status )
            return
        }


        if (status == UIListenerEnum.KEY_STATUS_PRESSED)
        {
            switch (event)
            {
	    //{modified by aettie Focus moves when pressed 20131015
                case UIListenerEnum.JOG_CENTER:
                {
                    root.jogPressed();
                    root.jogSelected(status)
                    break;
                }
            	case UIListenerEnum.JOG_RIGHT:
            	case UIListenerEnum.JOG_LEFT:
            	{
                     if (jogPressTimer.lastPressed == -1)
                     {
                    	isJogSelected = false
                    	root.lostFocus( event )
                     }
                     else
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

                // { modified by cychoi 2013.06.28 for wrapping around in the list view
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
    		//{modified by aettie CCP wheel direction for ME 20131014
                    var startIndex
                    if (EngineListenerMain.middleEast)
                    {
                        startIndex =  root.currentIndex - 1
                        root.log("UIListenerEnum.JOG_WHEEL_RIGHT middleEast:currentPageLoop = " +  root.currentPageLoop)
                        
                        if(startIndex <  0 && root.currentPageLoop == true) //modified  by Michael.Kim 2013.08.22 for ITS 185733
                            startIndex = root.model.count -1
                        var nextIndex = root.findNearestApprIndex(startIndex,event)
                        if (nextIndex != -1)
                        {
                            root.currentIndex = nextIndex
                            root.log("UIListenerEnum.JOG_WHEEL_RIGHT middleEast:nextIndex = " +  root.currentIndex)
                            //currentIndexInfo (root.currentIndex); //added by Michael.Kim 2013.06.07 for current focus index change
                        }
                        else
                        {
                            root.lostFocus( event )
                        }
                    }
                    else
                    {
                        startIndex = root.currentIndex + 1 
                        root.log("UIListenerEnum.JOG_WHEEL_RIGHT:currentPageLoop = " +  root.currentPageLoop)

                        
                        if(startIndex >= root.model.count && root.currentPageLoop == true) //modified by Michael.Kim 2013.08.22 for ITS 185733
                            startIndex = 0
                        var nextIndex = root.findNearestApprIndex(startIndex,event)
                        if (nextIndex != -1)
                        {
                            root.currentIndex = nextIndex
                            root.log("UIListenerEnum.JOG_WHEEL_RIGHT:nextIndex = " +  root.currentIndex)
                            //currentIndexInfo (root.currentIndex); 
                        }
                        else
                        {
                            root.lostFocus( event )
                        }
                    }
    		    //}modified by aettie CCP wheel direction for ME 20131014
                    isJogSelected = true
                    //playChapterViewTimer.stop()
                    //playChapterViewTimer.start()
                
                    break
                }
                    
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    var startIndex
    		//{modified by aettie CCP wheel direction for ME 20131014
                    if (EngineListenerMain.middleEast)
                    {
                        startIndex = root.currentIndex + 1 
                        root.log("UIListenerEnum.JOG_WHEEL_LEFT middleEast:currentPageLoop = " +  root.currentPageLoop)

                        
                        if(startIndex >= root.model.count && root.currentPageLoop == true) //modified by Michael.Kim 2013.08.22 for ITS 185733
                            startIndex = 0
                        var nextIndex = root.findNearestApprIndex(startIndex,event)
                        if (nextIndex != -1)
                        {
                            root.currentIndex = nextIndex
                            root.log("UIListenerEnum.JOG_WHEEL_LEFT middleEast:nextIndex = " +  root.currentIndex)
                            //currentIndexInfo (root.currentIndex); 
                        }
                        else
                        {
                            root.lostFocus( event )
                        }
                    }
                    else
                    {
                        startIndex =  root.currentIndex - 1
                        root.log("UIListenerEnum.JOG_WHEEL_LEFT:currentPageLoop = " +  root.currentPageLoop)
                        
                        if(startIndex <  0 && root.currentPageLoop == true) //modified  by Michael.Kim 2013.08.22 for ITS 185733
                            startIndex = root.model.count -1
                        var nextIndex = root.findNearestApprIndex(startIndex,event)
                        if (nextIndex != -1)
                        {
                            root.currentIndex = nextIndex
                            root.log("UIListenerEnum.JOG_WHEEL_LEFT:nextIndex = " +  root.currentIndex)
                            //currentIndexInfo (root.currentIndex); //added by Michael.Kim 2013.06.07 for current focus index change
                        }
                        else
                        {
                            root.lostFocus( event )
                        }
                    }
    		//}modified by aettie CCP wheel direction for ME 20131014
                    isJogSelected = true // added by wspark 2013.04.08
                    // { added by wspark 2013.03.09 for ISV 65056
                    //playChapterViewTimer.stop()
                    //playChapterViewTimer.start()
                    // } added by wspark

                    break
                }
                // } modified by cychoi 2013.06.28
                default:
                    break;
            }
        }
        else if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
        {
            switch ( event )
            {

	    //}modified by aettie Focus moves when pressed 20131015
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_UP:
            {
                // { added by Michael.Kim 2013.06.07 for current focus index change
                if (jogPressTimer.lastPressed == -1)
                {
                    if (UIListenerEnum.JOG_UP == event) root.lostFocus(UIListenerEnum.JOG_UP);
                }
                else
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
        else if ( status == UIListenerEnum.KEY_STATUS_CANCELED )
        {
            switch ( event )
            {
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
    }
    // modified by Dmitry 15.05.13
    // { added by wspark 2013.04.03 for ISV 78422
    function handleTouchEvent( index, is_focus_visible, event )
    {
        if(is_focus_visible)
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
                //currentIndexInfo (root.currentIndex); //added by Michael.Kim 2013.06.07 for current focus index change
                //playChapterViewTimer.stop() //added by Michael.Kim 2013.06.08 for current playChapterViewTimer index change
                //playChapterViewTimer.start() //added by Michael.Kim 2013.06.08 for current playChapterViewTimer index change
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
            //currentIndexInfo (root.currentIndex); //added by Michael.Kim 2013.06.07 for current focus index change
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

    Component.onCompleted:
    {
        root.currentIndex = -1
    }

    onCurrentIndexChanged:
    {
        focusElement(currentIndex)
    }

    // { added by yungi 2014.02.03 for ITS 223313
    onMovementEnded:
    {
        indexFlickSelected(root.currentIndex)
    }
    // } added by yungi 2014.02.03
}
