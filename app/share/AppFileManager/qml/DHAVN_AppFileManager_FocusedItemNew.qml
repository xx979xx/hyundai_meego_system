import QtQuick 1.1
import AppEngineQMLConstants 1.0


// modified by Dmitry 07.08.13 for ITS0180216 ITS017500

Item {
   id: node

   property int node_id: -1 // unique node id
   property bool focusable: true
   property bool focus_visible: false
   property int focus_default: -1 // default focused node should be set only in main parent
   property variant focus_node: undefined // current focused node
   property variant default_node: -1 // to store default node
   property string name: "FocusedItem"

   // numbers are node_ids to switch focus to when pressing jog up, down, left or right
   property variant links: [ /*up*/ -1, /*down*/ -1, /*left*/ -1, /*right*/ -1 ]

   signal hideFocus();
   signal showFocus();
   signal lostFocus(int arrow);
   signal grabFocus(int n_id)

   signal jogPressed();
   signal jogSelected();
   signal jogLongPressed();
   signal jogCriticalPressed();
   signal jogCancelled(); // added by Dmitry 16.08.13 for ITS0184683

// main function to switch focus inside focus item
   function switchFocus(arrow, new_node)
   {
      if (arrow != -1)
      {
         var idx = 0
         var next = null

         var cur_node = new_node === undefined ? focus_node : new_node

         for (idx; idx < node.children.length; idx++)
         {
            if (children[idx].focusable)
            {
               if (cur_node.links[arrow - 1] !== -1)
               {
                  if (children[idx].node_id === cur_node.links[arrow - 1])
                  {
                      if (!children[idx].visible)
                      {
                          switchFocus(arrow, children[idx])
                      }
                      else
                          next = children[idx]

                  }
               }
               if (next) break;
            }
         }

         if (next)
         {
             log("switchFocus to node_id = [" + next.node_id + "]")
             focus_node.hideFocus()
             next.setDefaultFocus()
             next.showFocus()
             focus_node = next
         }
      }else
         setDefaultFocus()
   }

   function handleJogEvent(arrow, status)
   {
       log("handleJogEvent node id = [" + node_id + "]")

       if (focus_node != undefined) // handle focus inside focused node if it's defined
       {
           focus_node.handleJogEvent(arrow, status)
       }
       else
       {
          if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
          {
             switch ( arrow )
             {
                case UIListenerEnum.JOG_CENTER:
                {
                   jogPressed();
                   break;
                }
		//modified by aettie Focus moves when pressed 20131015
                case UIListenerEnum.JOG_UP:
                case UIListenerEnum.JOG_RIGHT:
                case UIListenerEnum.JOG_DOWN:
                case UIListenerEnum.JOG_LEFT:
                {
                   lostFocus(arrow)
                   break;
                }
                default:
                   break;
             }
          }
          else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
          {
             switch (arrow)
             {
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
          else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
          {
             switch (arrow)
             {
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
   }

// when item loses focus
   onLostFocus:
   {
       switchFocus(arrow)
   }

   onHideFocus:
   {
       if (focus_node != undefined) // hide focus inside focused node if it's defined
           focus_node.hideFocus()
       focus_visible = false
   }

   onShowFocus:
   {
       if (focus_node != undefined) // show focus inside focused node if it's defined
           focus_node.showFocus()
       focus_visible = true
   }

   function setDefaultFocus()
   {
      if (default_node != focus_node)
     {
         log("setDefaultFocus inside node id = [" + node_id + "]")
         var idx = 0

         if (focus_node != undefined) // hide focus inside focused node if it's defined
             focus_node.hideFocus()
         // and set focus to default focus node
         for (idx; idx < node.children.length; idx++)
         {
            if (node.children[idx].focusable)
            {
               if (node.children[idx].node_id == focus_default)
               {
                  default_node = node.children[idx]
                  node.children[idx].setDefaultFocus()
                  node.children[idx].showFocus()
                  focus_node = node.children[idx]
                  break
               }
            }
         }
         return true
      }
      else
      {
          EngineListener.qmlLog("setDefaultFocus default_node : "+default_node)
      }

      return false
   }

   function handleGrabFocus(n_id)
   {
      log("focus grabbed by node id [" + n_id + "]")

      var idx = 0

      if (focus_node != undefined)
          focus_node.hideFocus()

      for (idx; idx < node.children.length; idx++)
      {
         if (node.children[idx].focusable)
         {
            if (node.children[idx].node_id == n_id)
            {
               node.children[idx].setDefaultFocus()
               node.children[idx].showFocus()
               focus_node = node.children[idx]
               break
            }
         }
      }
   }
   function log(str)
   {
       //EngineListener.qmlLog("[" + name + "] " + str)
   }

   onVisibleChanged:
   {

       log("onVisibleChanged node_id = " + node_id)
       if (!visible)
       {
           if(EngineListener.getIsFrontLCD())//added for ITS 241667 2014.07.03
           {
               lostFocus(-1) // when item becomes suddenly hidden just return focus to default item
           }
       }
   }

   onFocus_defaultChanged:
   {
      log("onFocus_defaultChanged " + focus_default)
      default_node = -1
      setDefaultFocus() // default focus changed, need to move focus on new focus_default item
   }

// connect lost focuses signal from childs
   Component.onCompleted:
   {
       var idx = 0

       for (idx; idx < node.children.length; idx++)
       {
           if (node.children[idx].focusable)
           {
               log("node.children[idx] = " + node.children[idx])
               node.children[idx].lostFocus.connect(lostFocus)
               node.children[idx].grabFocus.connect(handleGrabFocus)
           }
       }
   }
}
// modified by Dmitry 07.08.13 for ITS0180216 ITS015300

