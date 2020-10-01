import QtQuick 1.0
import Qt 4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0

import "../DHAVN_VP_CONSTANTS.js" as CONST


Item
{
  id: modeAreaWrapper
  property string modeAreaText: ""
  property bool focus_visible: false

  signal lostFocus( int arrow, int focusID );

  function setDefaultFocus( arrow )
  {
     mode_bar.setDefaultFocus( arrow )
  }


  QmlModeAreaWidget
  {
     id: mode_bar
     anchors.bottom: parent.top
     anchors.left: parent.left
     modeAreaModel: mode_area_model
     focus_id: 2
     focus_visible: modeAreaWrapper.focus_visible
     isAVPMode: true // DUAL_KEY
     mirrored_layout: EngineListenerMain.middleEast         // modified by aettie 20130514 for mode area layout mirroring
     onModeArea_BackBtn:{
     //modified by aettie 20130620 for back key event
        EngineListenerMain.qmlLog("[MP][VP][QML] SimpleModeArea::Back_key : isJogDial="+isJogDial);
        EngineListenerMain.qmlLog("[MP][VP][QML] SimpleModeArea::Back_key : bRRC="+bRRC);
        VideoEngine.setIsBackPressByJog(isJogDial);
        VideoEngine.setIsBackRRC(bRRC);
        controller.onSoftkeyBack();
     }

     onLostFocus:
     {
        modeAreaWrapper.lostFocus( arrow,focusID );
     }
  }

  ListModel
  {
     id: mode_area_model
     property string text: modeAreaText
     //property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST");
     property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST_MENU")		//modified by aettie.ji 2012.11.22 for New UX
  }

  Rectangle
  {
     color: "black"
     width: mode_bar.width
     height: mode_bar.height
     anchors.horizontalCenter: mode_bar.horizontalCenter
     anchors.verticalCenter: mode_bar.verticalCenter
     z: mode_bar.x - 1
  }
}

