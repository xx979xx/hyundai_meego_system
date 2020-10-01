import QtQuick 1.1
import "DHAVN_AppPandoraConst.js" as PR
import QmlQwertyKeypadWidget 1.0
import AppEngineQMLConstants 1.0
import CQMLLogUtil 1.0

Item {
    id: keypad

    property string outputText: ""
    property int outputCursor: 0
    property int currentCursor: 0
/////PINYIN
    property string pinyin: "NONE"              // "NONE", "PINYIN", "SOUND", "HANDWRITING"
    property bool pinyinComplete: false
    property int lastPinYinPosition: 0
/////PINYIN
    property string doneType: "Search"
    property bool useVocalSound: false
    x: 0
    y: 0
    z: 1000
    property alias isHide: idQmlQwertyKeypadWidget.isHide
    property alias focus_visible: idQmlQwertyKeypadWidget.focus_visible
    property int currentFocusIndex: 0
    property string logString :""

    signal manageFocus();
    signal startSearch();
    signal focusLost();
    signal updateString(); //{ modified by yongkyun.lee 2014-03-04 for : ITS 226613
    signal keyCallPopup(); //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280

    function __LOG( textLog , level)
    {
       logString = "KeyPad.qml::" + textLog ;
       logUtil.log(logString , level);
    }
    
    Component.onCompleted: {
        isFirstLoad = false; // added by cheolhwan 2014-01-27. ITS 222951.
//        keypadWidget = keypad ; //removed by jyjeon 2014-04-22 for ITS 227698
        if("Done" == doneType) {
            idQmlQwertyKeypadWidget.setDisableButton("hide");
        }
    }

    onCurrentFocusIndexChanged:{
        idQmlQwertyKeypadWidget.currentFocusIndex = currentFocusIndex;
    }


    /* INTERNAL functions */
    //{ modified by yongkyun.lee 2014-09-03 for : 
    function keyDeleteRunning()
    {
        return keyDeleteTimer.running;
    }
    //} modified by yongkyun.lee 2014-09-03 
    
    function disableSearchButton(){
        idQmlQwertyKeypadWidget.setDisableButton("Search")
    }

    function enableSearchButton(){
        idQmlQwertyKeypadWidget.setEnableButton("Search")
    }
    // { modified by wonseok.heo for ITS 255426
       function disableHideButton(){
           idQmlQwertyKeypadWidget.setDisableButton("hide")
       }

       function enableHideButton(){
           idQmlQwertyKeypadWidget.setEnableButton("hide")
       }
       // } modified by wonseok.heo for ITS 255426

    function disableDeleteButton(){
        idQmlQwertyKeypadWidget.setDisableButton("delete")
    }

    function enableDeleteButton(){
        idQmlQwertyKeypadWidget.setEnableButton("delete")
    }
    function disableDone_DeleteButton(){
        idQmlQwertyKeypadWidget.setDisableButton("done delete")
    }
    function enableDone_DeleteButton(){
        idQmlQwertyKeypadWidget.setEnableButton("done delete")
    }

    function isHide() {
        return idQmlQwertyKeypadWidget.isHide;
    }
    // { added by wonseok.heo for ITS  257323
    function setDefaultKeyPad(){

        idQmlQwertyKeypadWidget.defaultKeyboardPage();

    }
    // } added by wonseok.heo for ITS  257323
    function setDefaultFocus(arrow)
    {
        idQmlQwertyKeypadWidget.setDefaultFocus(arrow)
    }
    function hideQwertyKeypad()
    {
        idQmlQwertyKeypadWidget.hideQwertyKeypad();
    }
    function showQwertyKeypad()
    {
        if(true == idQmlQwertyKeypadWidget.isHide) {
            idQmlQwertyKeypadWidget.showQwertyKeypad()
        }
    }
    function clearAutomata()
    {
        idQmlQwertyKeypadWidget.clearBuffer();

        if("PINYIN" == pinyin) {
            keypadWidget.lastPinYinPosition = 0;
        } else if("SOUND" == pinyin) {
            idQmlQwertyKeypadWidget.clearState();
            keypadWidget.lastPinYinPosition = 0;
        }
    }


    function hideFocus()
    {
        idQmlQwertyKeypadWidget.hideFocus();
    }
    function showFocus()
    {
        idQmlQwertyKeypadWidget.showFocus()
    }

    //added jyjeon 2014-05-21 for ITS 237937
    function sendJogCanceled()
    {
        idQmlQwertyKeypadWidget.sendJogCanceled()
    }
    //added jyjeon 2014-05-21 for ITS 237937

    function setUpdate()
    {
        idQmlQwertyKeypadWidget.update();
    }

/* WIDGETS */
    QmlQwertyKeypadWidget 
    {
    id: idQmlQwertyKeypadWidget
    x: 0
    y: -92 // modified by esjang 2013.11.12 for Keypad position changing.

    //y: 243
    z: 1000
    focus: true

    //countryVariant: UIListener.GetCountryVariant()
    onLaunchSettingApp:UIListener.LaunchKeypadSettings();
    focus_visible: !popupVisible;
    doneButtonType: keypad.doneType

    onKeyReleased:
    {
        //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
        if(UIListener.IsCalling())
        {
            keyCallPopup();
            return;
        }
        //} modified by yongkyun.lee 2014-12-30 
            if(keyDeleteTimer.running)
                keyDeleteTimer.stop();

        //DONE key in Search View
        if( ( Qt.Key_Return === key ) ||( Qt.Key_Home === key ) )
        {
            startSearch();
        }
        else if(Qt.Key_Launch0 === key)
        {
            manageFocus();
        }
        else
        {
            pndrSearchView.textToDisplayOnsearchBox(key, label, state)
        }
    }
    onIsHideChanged:
    {
        if(isHide === true)
        {
            idQmlQwertyKeypadWidget.hideFocus();
            idQmlQwertyKeypadWidget.focus_visible = false;

            focusLost();
        }
        keypad.clearAutomata();
    }

    onKeyPressAndHold:
    {
        var tmpText= ""
        var curpos=pndrSearchView.currentPos()
        //{ modified by yongkyun.lee 2014-12-30 for : ITS 255280
        if(UIListener.IsCalling())
        {
            keyCallPopup();
            return;
        }
        //} modified by yongkyun.lee 2014-12-30 

        if( Qt.Key_Back === key )
        {
            keyDeleteTimer.start();
        }
    }
    onLostFocus:
    {
        switch(arrow)
        {
            case UIListenerEnum.JOG_UP:
            {
             idQmlQwertyKeypadWidget.focus_visible = false;
            break;
            }
        }
    }
    
        Timer{
            id: keyDeleteTimer
            running: false
            repeat: true
            interval: 150
            onTriggered:{
                pndrSearchView.textToDisplayOnsearchBox(Qt.Key_Back, "", false );
            }
        }
        
    }
}
