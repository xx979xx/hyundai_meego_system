import Qt 4.7
import QtQuick 1.1
import "DHAVN_OptionMenu.js" as CONST

Image
   {
   id: root_menu
   source: CONST.const_OPTION_MENU
   property QtObject menumodel
   property bool scrollingTicker: optionmenubase.scrollingTicker //[ISV][64532][C](aettie.ji)

// don't touch START

   property int previousFocusIndex: -1 // added by Dmitry 19.05.13

   // property to disable handling in current layer
   property bool disabled: false
   property bool focus_visible: optionmenubase.focus_visible
   property bool pendingDestroy: false

// added by Dmitry 03.05.13
   mirror: optionmenubase.middleEast
   LayoutMirroring.enabled: optionmenubase.middleEast
   LayoutMirroring.childrenInherit: true
// added by Dmitry 03.05.13

   state: "init"

   anchors.right: parent.right
   anchors.rightMargin: -width

   y: CONST.const_OPTION_MENU_LIST_TOP_MARGIN

   signal destroyed();
   signal created();

   states: [
      State
      {
          name: "init"
      },
      State
      {
         name: "in"
         PropertyChanges { target: root_menu; anchors.rightMargin: 0 }
      },
      State
      {
         name: "out"
         PropertyChanges { target: root_menu; anchors.rightMargin: -width }
         PropertyChanges { target: root_menu; pendingDestroy: true }
      }
   ]

   Behavior on anchors.rightMargin
   {
       PropertyAnimation
       {
           duration: 200
           onRunningChanged:
           {
               if (!running && state == "out")
               {
                  // layer is about to be destroyed
                  root_menu.destroyed()
                  // destroy object, free memory
                  root_menu.destroy()
               }
           }
       }
   }

// added by Dmitry 19.05.13
   onDisabledChanged:
   {
      if (disabled)
        previousFocusIndex = itemList.currentIndex
   }
// added by Dmitry 19.05.13
// don't touch END

   function setDefaultFocus(arrow)
   {
      itemList.setDefaultFocus(arrow)
   }

   function setDefaultFocusbyLevelMenu()
   {
      itemList.setDefaultFocusbyLevelMenu()
   }

   function setFG()
   {
       itemList.setFG()
   }

   DHAVN_OptionMenu_Item_List
   {
       id: itemList

       scrollingTicker: root_menu.scrollingTicker //[ISV][64532][C](aettie.ji)
       model: root_menu.menumodel
       anchors.rightMargin: CONST.const_OPTION_MENU_LIST_RIGHT_MARGIN
       anchors.fill: root_menu

       onTextItemSelect:
       {
          if (autoHiding) disappearTimer.restart()
          optionmenubase.textItemSelect( itemId )
       }

       onCheckBoxSelect:
       {
          if (autoHiding) disappearTimer.restart()
          optionmenubase.checkBoxSelect( itemId, flag )
       }

       onRadioBtnSelect:
       {
          if (autoHiding) disappearTimer.restart()
          optionmenubase.radioBtnSelect( itemId )
       }

       onNextMenuSelect:
       {
          if (autoHiding) disappearTimer.restart()
          optionmenubase.onNextMenuSelect( itemId, itemIndex )
       }
   }

   Component.onCompleted:
   {
      root_menu.state = visible ? "in" : "out"
   }
}
