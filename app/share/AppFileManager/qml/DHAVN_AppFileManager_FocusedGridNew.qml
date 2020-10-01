import QtQuick 1.1
import AppEngineQMLConstants 1.0

GridView
{
    id: node

    property int node_id: -1
    property bool focusable: true
    property bool focus_visible: false
    property int  focus_default: -1
    property bool focus_change_in_moving: false // added by Dmitry 11.09.13 for ITS0183775
    property bool scrollVisible: false
    property int movementIndex: -1
    property int preContentY: -1 // added by Michael.Kim 2014.03.25 for ITS 228014
    property int finalContentY: -1 // added by Michael.Kim 2014.03.25 for ITS 228014
    currentIndex: -1
    // modified for ISV 88609
    snapMode: GridView.SnapToRow //node.moving ? GridView.SnapToRow : GridView.NoSnap // added by Dmitry 01.08.2013 for ITS0175300

    property variant links: [ -1, -1, -1, -1 ]

    signal hideFocus();
    signal showFocus();
    signal lostFocus(int arrow)
    signal grabFocus(int n_id) // added by Dmitry 07.08.13 for ITS0175300

    signal jogSelected()
    signal jogPressed()
    signal jogReleased()
    signal jogCancelled() // added by Dmitry 16.08.13 for ITS0184683
    signal jogLongPressed()
    signal jogCriticalPressed()

    function handleJogEvent( arrow, status )
    {
       var cellCount = Math.floor( width / cellWidth );
       if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
       {
           // remap key for mirror layout
           // modified for ITS 0211325
           if(layoutDirection == Qt.RightToLeft)
           {
               if(arrow == UIListenerEnum.JOG_TOP_RIGHT)
                   arrow = UIListenerEnum.JOG_TOP_LEFT
               else if(arrow == UIListenerEnum.JOG_TOP_LEFT)
                   arrow = UIListenerEnum.JOG_TOP_RIGHT
               else if(arrow == UIListenerEnum.JOG_BOTTOM_RIGHT)
                   arrow = UIListenerEnum.JOG_BOTTOM_LEFT
               else if(arrow == UIListenerEnum.JOG_BOTTOM_LEFT)
                   arrow = UIListenerEnum.JOG_BOTTOM_RIGHT
           }

          switch ( arrow )
          {
// modified by Dmitry 02.08.13 for ITS0181739
             case UIListenerEnum.JOG_WHEEL_RIGHT:
             {
                if (moving || flicking) return // added by Dmitry 31.10.13
                keyNavigationWraps = scrollVisible ? true: false
                // modified for ISV 26-11-13, fix for empty items when in grid mirror layout
                if(layoutDirection != Qt.RightToLeft)
                {
                    if (currentIndex == indexAt(width - 10, contentY + height - 10))
                    {
                        moveCurrentIndexRight()
                        positionViewAtIndex(currentIndex, GridView.Beginning)
                    }
                    else // modified by Dmitry for ITS0205012
                    {
                        if (currentIndex == count - 1) positionViewAtIndex(0, GridView.Beginning)
                        moveCurrentIndexRight()
                    }
                }
                else
                {
                    if (currentIndex == indexAt(width - 10, contentY + 10))
                    {
                        moveCurrentIndexRight()
                        positionViewAtIndex(currentIndex, GridView.End)
                    }
                    else // modified by Dmitry for ITS0205012
                    {
                        if (currentIndex == 0) positionViewAtEnd()
                        moveCurrentIndexRight()
                    }
                }

                break
             }

             case UIListenerEnum.JOG_WHEEL_LEFT:
             {
                if (moving || flicking) return // added by Dmitry 31.10.13
                keyNavigationWraps = scrollVisible ? true: false
                if(layoutDirection != Qt.RightToLeft)
                {
                    if (currentIndex == indexAt(10, contentY + 10))
                    {
                        moveCurrentIndexLeft()
                        positionViewAtIndex(currentIndex, GridView.End)
                    }
                    else // modified by Dmitry for ITS0205012
                    {
                        if (currentIndex == 0) positionViewAtEnd()
                        moveCurrentIndexLeft()
                    }
                }
                else
                {
                    if (currentIndex == indexAt(10, contentY + height - 10))
                    {
                        moveCurrentIndexLeft()
                        positionViewAtIndex(currentIndex, GridView.Beginning)
                    }
                    else // modified by Dmitry for ITS0205012
                    {
                        if (currentIndex == count - 1) positionViewAtIndex(0, GridView.Beginning)
                        moveCurrentIndexLeft()
                    }
                }

                break
             }
//{modified by aettie Focus moves when pressed 20131015
             case UIListenerEnum.JOG_UP:
             case UIListenerEnum.JOG_DOWN:
             {
                 // {added by Michael.Kim 2014.07.29 for ITS 244032
                 if (moving || flicking) return
                 keyNavigationWraps = scrollVisible ? true: false
                 // }added by Michael.Kim 2014.07.29 for ITS 244032
                     if ( ( currentIndex - cellCount)% cellCount  >= 0 && arrow === UIListenerEnum.JOG_UP&& currentIndex != 0)
                     {
                         if (currentItem.y < contentY + 10)
                         {
                            moveCurrentIndexUp ()
                            positionViewAtIndex(currentIndex, GridView.End)
                         }
                         else
                            moveCurrentIndexUp()
                     }
                     else if (( currentIndex + cellCount ) % cellCount >= 0 && arrow === UIListenerEnum.JOG_DOWN){
                        if (currentItem.y + currentItem.height > contentY + height - currentItem.height / 2)
                        {
                           moveCurrentIndexDown()
                           positionViewAtIndex(currentIndex, GridView.Beginning)
                        }
                        else
                           moveCurrentIndexDown()
                     }
                     else
                     {
                         EngineListener.qmlLog("photo_jog : lostFocus");
                         lostFocus( arrow )
                     }
                break
             }
	     //}modified by aettie Focus moves when pressed 20131015
// modified by Dmitry 02.08.13 for ITS0181739

             case UIListenerEnum.JOG_RIGHT:
             {
                 if(layoutDirection != Qt.RightToLeft)
                 {
                     if ( ( currentIndex + 1 ) % cellCount &&
                             ( count - currentIndex - 1 ) != 0 )
                     {
                         moveCurrentIndexRight()
                     }
                     else
                     {
                         lostFocus( arrow )
                     }
                 }
                 else // modified for ITS 0211325
                 {
                     if ( currentIndex % cellCount != 0 )
                     {
                         moveCurrentIndexRight()
                     }
                     else
                     {
                         lostFocus( arrow )
                     }
                 }
                break
             }

             case UIListenerEnum.JOG_LEFT:
             {
                 if(layoutDirection != Qt.RightToLeft)
                 {
                     if ( currentIndex % cellCount != 0 )
                     {
                         moveCurrentIndexLeft()
                     }
                     else
                     {
                         lostFocus( arrow )
                     }
                 }
                 else // modified for ITS 0211325
                 {
                     if ( ( currentIndex + 1 ) % cellCount &&
                             ( count - currentIndex - 1 ) != 0 )
                     {
                         moveCurrentIndexLeft()
                     }
                     else
                     {
                         lostFocus( arrow )
                     }
                 }
                break
             }
               case UIListenerEnum.JOG_TOP_RIGHT:
               {
                 EngineListener.qmlLog("photo_jog : JOG_TOP_RIGHT =" + cellCount);
                     if ( cellCount >= 5 && ( ( currentIndex - 4 ) % cellCount )>=0 && ( ( currentIndex + 1 ) % cellCount ) )
                     {
                        currentIndex = currentIndex - 4;
                     }
                     else if  ( cellCount <= 4  && ( ( currentIndex - 3 ) % cellCount )>=0 && ( ( currentIndex + 1 ) % cellCount ) )
                     {
                        currentIndex = currentIndex - 3;
                     }
                    else
                    {
                       lostFocus( arrow )
                    }
                    EngineListener.qmlLog("photo_jog : JOG_TOP_RIGHT currentIndex=" +currentIndex);

                break
               }

               case UIListenerEnum.JOG_BOTTOM_RIGHT:
               {
                 EngineListener.qmlLog("photo_jog : JOG_BOTTOM_RIGHT =" +cellCount);
                     if ( cellCount >= 5 &&  ( currentIndex + 6 ) % cellCount >=0 && count - ( currentIndex + 6 + 1 ) >= 0 && ( ( currentIndex + 1 ) % cellCount ) )
                     {
                        currentIndex = currentIndex + 6;
                     }
                     else if  ( cellCount <= 4  &&  ( currentIndex + 5 ) % cellCount >= 0 && count - ( currentIndex + 5 + 1 ) >= 0 && ( ( currentIndex + 1 ) % cellCount ) )
                     {
                        currentIndex = currentIndex + 5;
                     }
                    else
                    {
                       lostFocus( arrow )
                    }
                         EngineListener.qmlLog("photo_jog : JOG_BOTTOM_RIGHT currentIndex=" +currentIndex);
                    break
               }

               case UIListenerEnum.JOG_TOP_LEFT:
               {
                 EngineListener.qmlLog("photo_jog : JOG_TOP_LEFT =" +cellCount);
                     if ( (cellCount >= 5) && (( ( currentIndex - 6 ) % cellCount )>=0) && ( currentIndex % cellCount ) && (currentIndex > 4) )
                     {
                         currentIndex = currentIndex - 6;
                     }
                     else if  ( (cellCount <= 4)  && (( ( currentIndex - 5 ) % cellCount )>=0) && ( currentIndex % cellCount ) && (currentIndex > 3) )
                     {
                         currentIndex = currentIndex - 5;
                     }
                    else
                    {
                       lostFocus( arrow )
                    }
                    EngineListener.qmlLog("photo_jog : JOG_TOP_LEFT currentIndex="+ currentIndex);
                    break
               }

               case UIListenerEnum.JOG_BOTTOM_LEFT:
               {
                 EngineListener.qmlLog("photo_jog : JOG_BOTTOM_LEFT =" +cellCount);
                     if ( (cellCount >= 5) &&  (( currentIndex + 4 ) % cellCount >=0) && (count - (currentIndex + 4 + 1)  >= 0) && ( currentIndex % cellCount ) )
                     {
                         currentIndex = currentIndex + 4;
                     }
                     else if  ( (cellCount <= 4)  &&  (( currentIndex + 3 ) % cellCount >=0) && (count - (currentIndex + 3 + 1) >= 0) && ( currentIndex % cellCount ) )
                     {
                         currentIndex = currentIndex + 3;
                     }
                    else
                    {
                       lostFocus( arrow )
                    }
                     EngineListener.qmlLog("photo_jog : JOG_BOTTOM_LEFT currentIndex="+ currentIndex);
                     break
               }
	//{modified by aettie Focus moves when pressed 20131015
             case UIListenerEnum.JOG_CENTER:
             {
                jogPressed();
                break
             }

             default:
             {
                // log( "handleJogarrow  incorrect arrow" )
             }
          }
       }
       else if(status == UIListenerEnum.KEY_STATUS_RELEASED) // modified by Dmitry 16.08.13 for ITS0184683
       {
         //[KOR][ITS][176623][minor](aettie.ji)
          switch (arrow)
          {
//moved
             case UIListenerEnum.JOG_CENTER:
             {
                jogSelected();
                break;
             }
             case UIListenerEnum.JOG_UP:
             case UIListenerEnum.JOG_DOWN:
             {
                if(timerPressedAndHold.lastPressed != -1)
                {
                   EventsEmulator.lockScrolling(node, true);
                   timerPressedAndHold.stop();
                   timerPressedAndHold.lastPressed = -1;
                   if(currentIndex >= 0  && !atYEnd && !atYBeginning)
                       positionViewAtIndex(currentIndex, arrow === UIListenerEnum.JOG_UP ? GridView.Beginning : GridView.End)
                   timerPressedAndHold.iterations = 0;
                }
                break
             }
             default:
                break;
          }
	  //}modified by aettie Focus moves when pressed 20131015
       }
// added by Dmitry 16.08.13 for ITS0184683
       else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
       {
          switch (arrow)
          {
             case UIListenerEnum.JOG_UP:
             case UIListenerEnum.JOG_DOWN:
             {
                if (timerPressedAndHold.lastPressed != -1)
                {
                   EventsEmulator.lockScrolling(node, true);
                   timerPressedAndHold.stop();
                   timerPressedAndHold.lastPressed = -1;
                   if(currentIndex >= 0  && !atYEnd && !atYBeginning)
                       positionViewAtIndex(currentIndex, arrow === UIListenerEnum.JOG_UP ? GridView.Beginning : GridView.End)
                   timerPressedAndHold.iterations = 0;
                }
                break
             }

             case UIListenerEnum.JOG_CENTER:
             {
                jogCancelled();
                break;
             }

             default:
                break;
          }
       }
// added by Dmitry 16.08.13 for ITS0184683
       else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
       {
           switch ( arrow )
           {
               case UIListenerEnum.JOG_UP:
               case UIListenerEnum.JOG_DOWN:
               {
                   if( ((contentY  == 0) && (arrow == UIListenerEnum.JOG_UP))
                           || ((contentHeight == (contentY + height)) && (arrow == UIListenerEnum.JOG_DOWN)) ) // Modified for ITS 0198550
                       break;
                   EventsEmulator.lockScrolling(node, false);
                   timerPressedAndHold.lastPressed = arrow;
                   timerPressedAndHold.start();
                   break;
               }

               case UIListenerEnum.JOG_CENTER:
               {
                  jogLongPressed();
                  break;
               }

               default:
                  break;
           }
       }
       else if (status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
       {
          switch (arrow)
          {
             case UIListenerEnum.JOG_CENTER:
             {
                jogCriticalPressed();
                break;
             }

             default:
                break;
          }
       }
    }

// removed by Dmitry 16.08.13 for ITS0184683

    Timer
    {
       id: timerPressedAndHold
       interval: 60
       running: false
       repeat: true
       triggeredOnStart: true
       property int lastPressed: -1
       property int iterations: 0

       onTriggered:
       {
           if(iterations++ == 0) {
               moveToNext_Prev(lastPressed);
               return;
           }

           if(lastPressed === UIListenerEnum.JOG_UP) {
               if(iterations < 30) {
                   iterations++
               }
               EventsEmulator.sendWheel(UIListenerEnum.JOG_UP, (60 + 60 * Math.floor(iterations / 10)), node);

               return;
           }

           if(lastPressed === UIListenerEnum.JOG_DOWN) {
               if(iterations < 30) {
                   iterations++
               }
               EventsEmulator.sendWheel(UIListenerEnum.JOG_DOWN, (60 + 60 * Math.floor(iterations / 10)), node);
               return;
           }
       }
    }

    onContentYChanged: {
        var tmpIndex = -1;
        finalContentY = contentY; // added by Michael.Kim 2014.03.25 for ITS 228014
        switch(timerPressedAndHold.lastPressed)
        {
        case UIListenerEnum.JOG_UP:
            tmpIndex = indexAt ( currentItem.x + 20, Math.floor(contentY + 10));
            break;
        case UIListenerEnum.JOG_DOWN:
            tmpIndex = indexAt ( currentItem.x + 20, Math.floor(contentY + height - currentItem.height) );
            break;
        }
        if(tmpIndex >= 0) {
            currentIndex = tmpIndex;
        }
    }
    
// modified by ravikanth on 16-09-13 for ITS 0187258, 0190690, 0187234
// modified by Dmitry 11.09.13 for ITS0183775
    onMovementStarted:
    {
        preContentY = contentY // added by Michael.Kim 2014.03.25 for ITS 228014
    	// modified by ravikanth 29-09-13 for ITS 0184780
        if(visibleArea.heightRatio < 1 || !focus_visible) // modified by Michael.Kim 2014.02.03 for ITS 223051
            if (!focus_visible && !focus_change_in_moving) grabFocus(node_id)
        movementIndex = currentIndex
    }

    onMovementEnded:
    {
       if(visibleArea.heightRatio >= 1) return; // dont change focus if its only one page
       //if (!focus_visible && !focus_change_in_moving) grabFocus(node_id)
       if(!focus_visible)
       {
           currentIndex = indexAt(10, contentY + 10)
       }
       else
       {
           if( movementIndex == currentIndex )
           {
               if(finalContentY - preContentY <= 200 && finalContentY - preContentY >= -200) return // added by Michael.Kim 2014.03.25 for ITS 228014
               currentIndex = indexAt(10, contentY + 10)
               movementIndex = -1
           }
       }
    }

    function moveToNext_Prev(lastPressed)
    {
        if (lastPressed == UIListenerEnum.JOG_UP)
        {
            if ( currentIndex > 0 )
            {
                moveCurrentIndexUp();
            }
        }
        else if (lastPressed == UIListenerEnum.JOG_DOWN)
        {
            if ( currentIndex < ( count - 1 ) )
            {
                moveCurrentIndexDown();
            }
        }
    }

    function setDefaultFocus()
    {
       log("setDefaultFocus currentIndex = " + currentIndex)
        if (currentIndex == -1)
            currentIndex = 0
       focus_change_in_moving = false
    }

    onHideFocus:
    {
        log("onHideFocus")
        focus_visible = false
        if (moving) focus_change_in_moving = true
        EventsEmulator.sendMouseRelease(node)
        returnToBounds()
    }

    onShowFocus:
    {
        log("onHideFocus")
        focus_change_in_moving = false
        focus_visible = true
    }
// modified by Dmitry 11.09.13 for ITS0183775

    function log(str)
    {
        //EngineListener.qmlLog("[" + name + "] " + str)
    }
}
