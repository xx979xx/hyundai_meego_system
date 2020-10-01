import QtQuick 1.1
import AppEngineQMLConstants 1.0

ListView
{
    id: node

    currentIndex: -1

    snapMode: moving ? ListView.SnapToItem : ListView.NoSnap // added by Dmitry 01.08.2013 for ITS0175300
    property int node_id: -1
    property bool focusable: true
    property bool focus_visible: false
    property int focus_default: -1
    property bool focus_change_in_moving: false // added by Dmitry 11.09.13 for ITS0183775
    property string name: "FocusedList"
    property bool scrollVisible: false

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

    function handleJogEvent(arrow, status)
    {
       log("handleJogEvent node id = [" + node_id + "]")
       if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
       {
          switch ( arrow )
          {
	  //modified by aettie Focus moves when pressed 20131015
             case UIListenerEnum.JOG_RIGHT:
             case UIListenerEnum.JOG_LEFT:
             {
                lostFocus(arrow)
                break
             }
             case UIListenerEnum.JOG_WHEEL_RIGHT:
             {
                 if (moving || flicking) return // added by Dmitry 31.10.13
                 //added by suilyou 20131010 ITS 0194943
                 if(EngineListener.getJogKeyPressed()!=0)
                 {
                     EngineListener.qmlLog("ignore JOG WHEEL because other HardKey pressing")
                     return;
                 }
// modified by Dmitry 02.08.13 for ITS0181739
                 keyNavigationWraps = scrollVisible ? true: false
		 //{modified by aettie CCP wheel direction for ME 20131014
                if(EngineListener.middleEast)
                {
                     if (currentIndex == indexAt(width / 2, contentY + 10))
                     {
                        decrementCurrentIndex()
                        positionViewAtIndex(currentIndex, ListView.End)
                     }
                     else
                        decrementCurrentIndex()
                }
                else
                {
                     if (currentIndex == indexAt(width / 2, contentY + height - 10))
                     {
                        incrementCurrentIndex()
                        positionViewAtIndex(currentIndex, ListView.Beginning)
                     }
                     else
                        incrementCurrentIndex()
                }
		//}modified by aettie CCP wheel direction for ME 20131014
                 break
             }

             case UIListenerEnum.JOG_WHEEL_LEFT:
             {
                 if (moving || flicking) return // added by Dmitry 31.10.13
                 //added by suilyou 20131010 ITS 0194943
                 if(EngineListener.getJogKeyPressed()!=0)
                 {
                     EngineListener.qmlLog("ignore JOG WHEEL because other HardKey pressing")
                     return;
                 }
                 keyNavigationWraps = scrollVisible ? true: false
		 //{modified by aettie CCP wheel direction for ME 20131014
                if(EngineListener.middleEast)
                 {
                     if (currentIndex == indexAt(width / 2, contentY + height - 10))
                     {
                        incrementCurrentIndex()
                        positionViewAtIndex(currentIndex, ListView.Beginning)
                     }
                     else
                        incrementCurrentIndex()
                 }
                 else
                 {
                     if (currentIndex == indexAt(width / 2, contentY + 10))
                     {
                        decrementCurrentIndex()
                        positionViewAtIndex(currentIndex, ListView.End)
                     }
                     else
                        decrementCurrentIndex()
                 }
		 //}modified by aettie CCP wheel direction for ME 20131014
                 break
             }
// modified by Dmitry 02.08.13 for ITS0181739

             case UIListenerEnum.JOG_CENTER:
             {
                 jogPressed()
                 break
             }

             default:
                 break;
          }
       }
       else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
       {
          switch (arrow)
          {
             case UIListenerEnum.JOG_UP:
             case UIListenerEnum.JOG_DOWN:
             {
                if (timerPressedAndHold.lastPressed == -1)
                {
                    lostFocus(arrow)
                }
                else
                {
                   //EventsEmulator.lockScrolling(node, true);
                   timerPressedAndHold.stop();
                   //if (currentIndex >= 0)
                   //    positionViewAtIndex(currentIndex, arrow === UIListenerEnum.JOG_UP ? ListView.Beginning : ListView.End)
                   timerPressedAndHold.iterations = 0;
                   timerPressedAndHold.lastPressed = -1;
                }
                break
             }
		//moved
             case UIListenerEnum.JOG_CENTER:
             {
                jogSelected();
                break;
             }

             default:
                break;

          }
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
                   timerPressedAndHold.stop();
                   timerPressedAndHold.iterations = 0;
                   timerPressedAndHold.lastPressed = -1;
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
       else if(status ==  UIListenerEnum.KEY_STATUS_LONG_PRESSED)
       {
           switch ( arrow )
           {
              case UIListenerEnum.JOG_CENTER:
              {
                  jogLongPressed();
                  break;
              }

              case UIListenerEnum.JOG_UP:
              case UIListenerEnum.JOG_DOWN:
              {
                  //EventsEmulator.lockScrolling(node, false);
                  timerPressedAndHold.lastPressed = arrow;
                  timerPressedAndHold.start();
                  break;
              }

              default:
                 break;
           }
       }
       else if (status == UIListenerEnum.KEY_STATUS_CRITICAL_PRESSED)
       {
           switch ( timerPressedAndHold.lastPressed )
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
       property int iterations: 0
       property int lastPressed: -1

       onTriggered:
       {
//           if(lastPressed == UIListenerEnum.JOG_UP && (contentY + 10) >= currentItem.y)
//           {
//               if (iterations < 30) iterations++
//               EventsEmulator.sendWheel(UIListenerEnum.JOG_UP, (120 + 120 * Math.floor(iterations / 10)), node);
//               return;
//           }

//           if(lastPressed == UIListenerEnum.JOG_DOWN && (contentY + height - 10) <= (currentItem.y + currentItem.height))
//           {
//               if (iterations < 30) iterations++
//               EventsEmulator.sendWheel(UIListenerEnum.JOG_DOWN, (120 + 120 * Math.floor(iterations / 10)), node);
//               return;
//           }

           if (lastPressed == UIListenerEnum.JOG_UP)
           {
               if (currentIndex > 0)
                   decrementCurrentIndex()
           }
           else if (lastPressed == UIListenerEnum.JOG_DOWN)
           {
               if (currentIndex < (count - 1))
                   incrementCurrentIndex()
           }
       }
    }

// modified by ravikanth 29-09-13 for ITS 0184780
// modified by Dmitry 11.09.13 for ITS0183775
    onMovementStarted:
    {
        if(visibleArea.heightRatio < 1 || !focus_visible) // modified by Michael.Kim 2014.02.03 for ITS 223051
        {
            if (!focus_visible && !focus_change_in_moving) grabFocus(node_id)
        }
    }

    onMovementEnded:
    {
        // modified by raviknath 03-10-13 for ITS 0191657
        if(visibleArea.heightRatio >= 1) return; // modified by ravikanth 09-09-13 for ITS 0185395
        var tmp_start_index = indexAt(10, contentY + 10)
        var tmp_end_index = indexAt(10, contentY + node.height - 10)
        if(!((currentIndex >= tmp_start_index) && (currentIndex <= tmp_end_index)))
        {
            //if (!focus_visible && !focus_change_in_moving) grabFocus(node_id)
            currentIndex = tmp_start_index
        }
        // { added by sangmin.seol 2014.03.27 for ITS_NA_0231339 Move focus to the first item when it is not possible to display the current focused item entire
        else if(currentIndex == tmp_end_index)
        {
            if((height - (currentItem.y - contentY)) < currentItem.height)
                currentIndex = tmp_start_index
        }
        // } added by sangmin.seol 2014.03.27 for ITS_NA_0231339 Move focus to the first item when it is not possible to display the current focused item entire
    }

//    onContentYChanged:
//    {
//        var tmpIndex = -1;
//        switch(timerPressedAndHold.lastPressed)
//        {
//           case UIListenerEnum.JOG_UP:
//               tmpIndex = indexAt ( 10, Math.floor(contentY + 10) );
//               break;
//           case UIListenerEnum.JOG_DOWN:
//               tmpIndex = indexAt ( 10, Math.floor(contentY + height - 10) );
//               break;
//        }
//        if(tmpIndex >= 0 )
//            currentIndex = tmpIndex;
//    }

    function setDefaultFocus()
    {
        log("setDefaultFocus node id = [" + node_id + "]")
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
        log("onShowFocus")
        focus_change_in_moving = false
        focus_visible = true
    }
// modified by Dmitry 11.09.13 for ITS0183775

    function log(str)
    {
        //EngineListener.qmlLog("[" + name + "] " + str)
    }
}
