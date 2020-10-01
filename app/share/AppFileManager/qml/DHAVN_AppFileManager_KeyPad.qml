import QtQuick 1.0
import QmlQwertyKeypadWidget 1.0
import com.filemanager.uicontrol 1.0
import AppEngineQMLConstants 1.0

import "DHAVN_AppFileManager_Resources.js" as RES
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   signal textEntered( string str )

   width: FM.const_APP_FILE_MANAGER_SCREEN_WIDTH
   height:
   {
      var value = FM.const_APP_FILE_MANAGER_SCREEN_HEIGHT - FM.const_APP_FILE_MANAGER_CONTENT_AREA_TOP_MARGIN
      return value
   }

   function clearText()
   {
       text_input.text = ""
       text_input.cursorPosition = 0
   }

   Rectangle
   {
      anchors.fill: parent
      color: "black"
   }

//{modified by aettie.ji 2012.12.03 for New UX
   Rectangle
   {
       id: text_input_bg
       //anchors { left: parent.left; top: parent.top; bottom: key_pad.top }
       //width: parent.width

       //color: "grey"
       anchors
       {
            horizontalCenter:parent.horizontalCenter
            top: parent.top
            topMargin: 9
       }

       width: 1266
       height: 136
       color: "transparent"

       Image
       {
           source: "/app/share/images/photo/bg_edit_new_inputbox.png"
           width: parent.width
           height: parent.height
       }
   }
   //}modified by aettie.ji 2012.12.03 for New UX

   DHAVN_AppFileManager_FocusedTextInput
   {
      id: text_input

      //{ modified by aettie.ji 2012.12.03 for New UX
      //anchors { left: parent.left; top: parent.top; bottom: key_pad.top }
      //width: parent.width
      anchors { horizontalCenter:parent.horizontalCenter
                top: parent.top
                topMargin: 9 + 34
                }
      width: text_input_bg.width - 68
      height: text_input_bg.height - 68
      //}modified by aettie.ji 2012.12.03 for New UX
      focus_x: 0
      focus_y: 0
      // { modified by edo.lee 2012.11.29 New UX
      //font.pixelSize: 40
      //font.pointSize: 40
      cursorDelegate: Image { source: "/app/share/images/keypad/cursor.png"}
      font.pointSize: 32
      //} modified by aettie.ji 2012.12.03 for New UX
      //font.family: "HDB"      //added by aettie.ji 2012.12.04 for ISV 59871
      font.family:  FM.const_APP_FILE_MANAGER_FONT_NEW_HDB

      // { modified by edo.lee
      // modified by minho 20121218 for CR16461 Input limit overflow pop-up doesn't appear
      // maximumLength: 240
      maximumLength: 128
      // modified by minho 20121218
      selectedTextColor: "white"
      selectionColor: "blue"
      selectByMouse: true
      cursorVisible: true
      cursorPosition: 0
      horizontalAlignment: ( EngineListener.variantCountry == 4 ) ?
                              TextInput.AlignRight :
      TextInput.AlignLeft

      Component.onCompleted: { text_input.text = UIControl.keyPadText }

      DHAVN_AppFileManager_Border
      {
         visible: text_input.border_is_visible
      }
   }

   QmlQwertyKeypadWidget
   {
      id: key_pad

      property int focus_x: 0
      property int focus_y: 1
      property string name: "QmlQwertyKeypadWidget"
      focus_id: 0

      countryVariant: EngineListener.variantCountry

      onLaunchSettingApp:
      {
         EngineListener.LaunchSettingsKeypad(UIListener.getCurrentScreen() ==
                                             UIListenerEnum.SCREEN_FRONT)
      }

      anchors { left: parent.left; bottom: parent.bottom }
      searchString: text_input.text

      onKeyReleased:
      {
         EngineListener.qmlLog( "TextInput key: " + key )
         EngineListener.qmlLog( "TextInput label: " + label )
         EngineListener.qmlLog( "TextInput state: " + state )

          if( label.charAt(0) == '\\' ||
              label.charAt(0) == '/' ||
              label.charAt(0) == ':' ||
              label.charAt(0) == '*' ||
              label.charAt(0) == '?' ||
              label.charAt(0) == '<' ||
              label.charAt(0) == '>' ||
              label.charAt(0) == '|'  ||
              label.charAt(0) == '"' ||
              ((label.charAt(0) != '_') && (key == Qt.Key_Underscore) ) )
         {
            UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_INCORRECT_CHARACTER );
            return;
         }

         // { modified by changjin 2012.09.21 for CR 13617 and 13875
         if ( key < 0xFF )
         {
            var nPos = text_input.cursorPosition;
            var TextForAdding = label;
            var offset = 0;
            if(state) offset = 1;

            // modified by minho 20121203 for Deleted remain word when entered word after moved the cursor to middle position on rename screen.
            // text_input.text = text_input.text.substring( 0, nPos-offset ) + TextForAdding + text_input.text.substring( nPos );
            // added by minho 20121218 for CR16461 Input limit overflow pop-up doesn't appear
            if (text_input.text.length >= 128)
            {
                UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_NAME_IS_TOO_LONG );
                return;
            }
            // added by minho 20121218
            // { modified by eugene.seo 2013.01.09 for keypad error
            //text_input.text = text_input.text.substring( 0, nPos ) + TextForAdding + text_input.text.substring( nPos );
            text_input.text = text_input.text.substring( 0, nPos - offset) + TextForAdding + text_input.text.substring( nPos ); 
            // } modified by eugene.seo 2013.01.09 for keypad error
            // modified by minho
            text_input.cursorPosition = nPos+TextForAdding.length;
         }
         else if ( key == Qt.Key_Back )
         {
            var nPos = text_input.cursorPosition-1;
            text_input.text = text_input.text.substring( 0, nPos ) + text_input.text.substring( nPos+1 );
            text_input.cursorPosition = nPos;
            clearState();
         }
         else if ( key == Qt.Key_Return || key == Qt.Key_Home )
         {
            if ( text_input.text.length == 0 )
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_EMPTY_NAME );
            }
            // deleted by minho 20121218 for CR16461 Input limit overflow pop-up doesn't appear
            // else if ( text_input.text.length >= 128 )
            // {
            //    UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_NAME_IS_TOO_LONG );
            // }
            // deleted by minho 20121218
            else
            {
            //{Changed by Alexey Edelev 2012.10.09 CRs 13968, 13996
               if(UIControl.keyPadText == text_input.text)
               {
                   UIControl.modeAreaEventHandler( UIDef.MODE_AREA_EVENT_BACK_PRESSED )
               }
               else if ( StateManager.CheckFolder( text_input.text ) )
               {
                  UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_FOLDER_ALREADY_EXIST )
               }
               else
               {
                  textEntered( text_input.text );
               }
            //}Changed by Alexey Edelev 2012.10.09 CRs 13968, 13996
            }
			clearState();
         }
         /*
         var selectEnd = text_input.cursorPosition;
         var selectStart = state ? selectEnd - 1 : selectEnd;
         var sym = "";

         if ( Qt.Key_Back == key )
         {
            selectStart = text_input.cursorPosition - 1;
         }
         else if ( key <= 0xFF )
         {
            sym = label;
         }

         if ( text_input.selectedText )
         {
            selectEnd = text_input.selectionEnd;
            selectStart = text_input.selectionStart;
            text_input.select(0, 0);
         }

         if ( selectStart < 0 ) selectStart = 0;

         var tmp_text = text_input.text;
         tmp_text = text_input.text.substring( 0, selectStart ) +
                    sym +
                    text_input.text.substring( selectEnd );
         text_input.text = tmp_text;
         text_input.cursorPosition = selectStart + sym.length;

         if ( Qt.Key_Return == key || Qt.Key_Home == key )
         {
            if ( tmp_text.length == 0 )
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_EMPTY_NAME );
            }
            else if ( tmp_text.length >= 128 )
            {
               UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_NAME_IS_TOO_LONG );
            }
            else
            {
               if ( StateManager.CheckFolder( tmp_text ) )
               {
                   // modified by minho 20120919
                   // { for CR11197 Popup "Entered folder name..." is displayed while change folder name in Jukebox Image list screen
                   // UIControl.popupEventHandler( UIDef.POPUP_EVENT_CREATE_FOLDER_FOLDER_ALREADY_EXIST );
                   UIControl.modeAreaEventHandler( UIDef.MODE_AREA_EVENT_BACK_PRESSED )
                   // } modified by minho
               }
               else
               {
                  textEntered( tmp_text );
               }
            }
         }
         */
         // } modified by changjin 2012.09.21
      }
      // added by minho 20121121 for Delete all the inputted text on keypad by press and hold the back key.
      onKeyPressAndHold:
      {
          if (Qt.Key_Back == key)
          {
            root.clearText();
          }
      }
      // added by minho
   }
}
