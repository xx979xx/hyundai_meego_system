import Qt 4.7
import qwertyKeypadUtility 1.0
//import AppEngineQMLConstants 1.0


Item
{
    id: qwerty_keypad

    /**Public area: Props, signals and interfaces for external usage*/

    signal keyPress( int key, string label )
    signal keyPressAndHold( int key, string label )
    signal keyReleased( int key, string label, bool state )
    signal launchSettingApp()

    signal pressedOneShift( bool isPress );
    signal pressedTwoShifts( bool isPress );
    signal resetShiftsPress( bool isPress );
    signal updateButton(string button_text);

    signal lostFocus( int arrow );
    property bool focus_visible:   false
    property int focus_id: -1
    property bool is_focusable: true
    property bool is_DeleteLongKeyTime: false

    signal doUpdateIntelliKeyboard();
    signal doDeleteUpdateIntelliKeyboard(bool state);

    function showQwertyKeypad()
    {
        //isHide ? qwerty_keypad.y = remYPos: null;
        hideAni.stop();
        showAni.start();
        isHide = false;
    }

    function hideQwertyKeypad()
    {
        showAni.stop();
        hideAni.start();
        isHide = true;
        idDeleteLongTime.stop();
        is_DeleteLongKeyTime = false;
        deletePressLong = false;
        //isHide ? qwerty_keypad.y = qwerty_keypad.y + 600 : null
    }

    function hideFocus() { focus_visible = false }

    function showFocus() { focus_visible = true }

    function setDefaultFocus(arrow)
    {
        currentFocusIndex = 0
        return focus_id;
    }

    function handleJogEvent(key) {
        prevFocusIndex = currentFocusIndex
        switch(key)
        {
        case Qt.Key_Right:
            screenRepeater.children[screenRepeater.index].item.transitDirection = 7;
            break;
        case Qt.Key_Left:
            screenRepeater.children[screenRepeater.index].item.transitDirection = 6;
            break;
        case Qt.Key_Up:
            screenRepeater.children[screenRepeater.index].item.transitDirection = 1;
            break;
        case Qt.Key_Down:
            screenRepeater.children[screenRepeater.index].item.transitDirection = 4;
            break;
        }
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
        if(prevFocusIndex == currentFocusIndex)
            lostFocus(key);
        //           lostFocus( arrow, focus_id )
    }

    function handleUpLeftEvent(){
        screenRepeater.children[screenRepeater.index].item.transitDirection = 0
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
        if(prevFocusIndex == currentFocusIndex)
            lostFocus( Qt.Key_Up )
    }
    function handleUpRightEvent(){
        screenRepeater.children[screenRepeater.index].item.transitDirection = 2
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
        if(prevFocusIndex == currentFocusIndex)
            lostFocus( Qt.Key_Up )
    }
    function handleDownLeftEvent(){
        screenRepeater.children[screenRepeater.index].item.transitDirection = 3
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
        if(prevFocusIndex == currentFocusIndex)
            lostFocus( Qt.Key_DOWN )
    }
    function handleDownRightEvent(){
        screenRepeater.children[screenRepeater.index].item.transitDirection = 5
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
        if(prevFocusIndex == currentFocusIndex)
            lostFocus( Qt.Key_DOWN )
    }

    function handelJogWheelEventLeft()
    {
        prevFocusIndex = currentFocusIndex
        screenRepeater.children[screenRepeater.index].item.transitDirection = 8
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
    }

    function handleJogWheelEventRight()
    {
        prevFocusIndex = currentFocusIndex
        screenRepeater.children[screenRepeater.index].item.transitDirection = 9
        screenRepeater.children[screenRepeater.index].item.transitDirection = -1
    }

    function __handleJogEvent(arrow, status)
    {
        if(status == UIListenerEnum.KEY_STATUS_CLICKED)
        {
            prevFocusIndex = currentFocusIndex
            switch(arrow)
            {
            case UIListenerEnum.JOG_UP: //Up
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 1
                break;
            }
            case UIListenerEnum.JOG_TOP_RIGHT: //Right Up
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 2
                break;
            }
            case UIListenerEnum.JOG_RIGHT: //Right
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 7
                break;
            }
            case UIListenerEnum.JOG_BOTTOM_RIGHT: //Right Down
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 5
                break;
            }
            case UIListenerEnum.JOG_DOWN: //Down
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 4
                break;
            }
            case UIListenerEnum.JOG_BOTTOM_LEFT: //Left Down
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 3
                break;
            }
            case UIListenerEnum.JOG_LEFT: //Left
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 6
                break;
            }
            case UIListenerEnum.JOG_TOP_LEFT: //Left up
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 0
                break
            }
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 9
                break;
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = 8
                break;
            }
            default:
            {
                console.log("Unknow key "+ arrow)
                return;
            }
            }
            screenRepeater.children[screenRepeater.index].item.transitDirection = -1
            if(prevFocusIndex == currentFocusIndex)
                lostFocus( arrow, focus_id )
        }
    }

    function onJDEventSelectLongPressed()
    {
        console.log("onJDEventSelectLongPressed Event from JD = " + currentFocusIndex)
        UIListener.consolMSG("onJDEventSelectLongPressed Event from JD = " + deletePressLong);
        if(deletePressLong == true){
            idDeleteLongTime.start();
            doDeleteUpdateIntelliKeyboard(true);
            // Key_Back longpress delete scenario time 100ms
//            onJDEventSelectRelease()
//            screenRepeater.clearKeyLongPressed(Qt.Key_Back, "")
        }
    }

    function onJDEventSelectRelease()
    {
        deletePressLong = false;
        prevFocusIndex = currentFocusIndex;
        screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = false;

        if(idAppMain.isKeyCanceled)
        {
            idDeleteLongTime.stop();
            idAppMain.isKeyCanceled = false;
        }
        else
        {
            idDeleteLongTime.stop();

            if(is_DeleteLongKeyTime)
            {
                doDeleteUpdateIntelliKeyboard(false);
                is_DeleteLongKeyTime = false;
            }
        }
    }

    function onJDEventSelectPressed()
    {
        prevFocusIndex = currentFocusIndex
        screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = true
    }

    function update()
    {
        var oldKeypadDefaultType = translate.keypadDefaultType;
        translate.clearAutomata()
        translate.loadSettings();

        var i;
        for( i = 0; i< countryModel.get(countryVariant).line.count; i++){
            screenRepeater.children[screenRepeater.index].source = "";
        }

        if( translate.isFirstCapital && outputText.length == 0)
        {
            shiftMode = e_SHIFT_ONCE;
        }
        else
        {
            shiftMode = e_SHIFT_NONE;
        }
        if(oldKeypadDefaultType != translate.keypadDefaultType)
        {
            if(translate.keypadDefaultType == 0 && screenRepeater.index == 1)
                screenRepeater.index = 2;
            if(translate.keypadDefaultType == 1 && screenRepeater.index == 2)
                screenRepeater.index = 1;
        }

        screenRepeater.children[screenRepeater.index].loadSource()
    }

    function clearState()
    {
        translate.clearAutomata()
    }

    function shiftProcessing ()
    {
        console.log( "shiftProcessing....")

        if(shiftMode == e_SHIFT_ALWAYS)
        {
            shiftMode = e_SHIFT_NONE;
            resetShiftsPress(true);
        }else if(shiftMode == e_SHIFT_ONCE)
        {
            shiftMode = e_SHIFT_ALWAYS;
            pressedTwoShifts(true);
        }else
        {
            shiftMode = e_SHIFT_ONCE;
            pressedOneShift(true);
        }
    }


    function numberToggleProcessing()
    {
        if (isNumber2Mode)
            isNumber2Mode = false;
        else
            isNumber2Mode = true;
    }

    function latinExtendedToggleProcessing()
    {
        if ( latinExtendedMode == 0)
            latinExtendedMode = 1;
        else if ( latinExtendedMode == 1)
            latinExtendedMode = 2;
        else
            latinExtendedMode = 0;
    }

    function defaultKey()
    {
        comma_timer.running = false;
        comma_timer.type = 0;

        if(screenRepeater.children[screenRepeater.index].item.is_Shift &&
                !screenRepeater.children[screenRepeater.index].item.is_DoubleShift)
        {
            screenRepeater.children[screenRepeater.index].item.is_Shift = false;
            resetShiftsPress(true);
            screenRepeater.children[screenRepeater.index].item.retranslateUi();
        }

        if(shiftMode == e_SHIFT_ONCE)
        {
            shiftMode = e_SHIFT_NONE;
            resetShiftsPress(true);
            screenRepeater.children[screenRepeater.index].item.retranslateUi();
        }
    }

    function processNewSentence(onkey)
    {
        var ccn = (onkey ? 1 : 0);
        if(translate.isFirstCapital && (shiftMode != e_SHIFT_ALWAYS))
        {
            if(searchString.length <= ccn ||
                    (searchString.length >(1 + ccn) && searchString.charCodeAt(searchString.length-1-ccn) == Qt.Key_Space &&
                     (searchString.charCodeAt(searchString.length - 2 - ccn) == Qt.Key_Period ||
                      searchString.charCodeAt(searchString.length - 2 - ccn) == Qt.Key_Question ||
                      searchString.charCodeAt(searchString.length - 2 - ccn) == Qt.Key_Exclam)))
            {
                shiftMode = e_SHIFT_NONE;
                pressedOneShift(true);
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                return true;
            }
            else if(searchString.length > ccn &&
                    (searchString.charCodeAt(searchString.length - 1 - ccn) == Qt.Key_Period ||
                     searchString.charCodeAt(searchString.length - 1 - ccn) == Qt.Key_Question ||
                     searchString.charCodeAt(searchString.length - 1 - ccn) == Qt.Key_Exclam))
            {
                newSentence = true;
                defaultKey();
                return true;
            }
        }
        return false;
    }

    function updateShiftButton()
    {
        if(shiftMode == e_SHIFT_ALWAYS)
            pressedTwoShifts(true);
        else if(shiftMode == e_SHIFT_ONCE)
            pressedOneShift(true);
        else
            resetShiftsPress(true);
    }


    /**Private area*/
    y:  298-131

    width:  1280
    height:  400//[ITS 218517]

    Image
    {
        y : 0
        //__INTELLIKEYPAD_FOR_XMDATA__
        //       source: translate.getResourcePath() + "home/bg_2_1.png"
        source: imageInfo.imgFolderKeypad + "bg_keypad.png"
    }

    MouseArea
    {
        anchors.fill: parent
    }

    property int e_SHIFT_NONE: 0
    property int e_SHIFT_ONCE: 1
    property int e_SHIFT_ALWAYS: 2

    property bool isSwitch:      false
    property bool isHide:        false
    property bool newSentence:   true
    property int shiftMode: e_SHIFT_NONE
    property bool isNumber2Mode: false
    property int latinExtendedMode: 0

    property string searchString: ""         //read only!

    property int remYPos
    property variant comma: [".", "-", "@"]

    property int currentFocusIndex: 0
    property int prevFocusIndex:  0

    property int countryVariant : translate.keypadDefaultType                  // korean? latinExt?
    property int chineseKeypadType: 0

    property double disableKeyForIntelliKeyboard: 0xffffffff
    // 0000 0000 0000 0000 0000 0000 0000 0000  // true: enable, false: disable
    // 0000 0000 0000 0000 0000 0011 1111 1111 // A09 ~ A00
    // 0000 0000 0000 0111 1111 1100 0000 0000 // B08 ~ B00
    // 0000 0011 1111 1000 0000 0000 0000 0000 // C06 ~ C00


    function checkDisableKeyForIntelliKeyboard(){
        if(screenRepeater.children[screenRepeater.index] && !idDeleteLongTime.running)
            screenRepeater.children[screenRepeater.index].item.checkIntelliKeyboard(disableKeyForIntelliKeyboard);
    }

    DHAVN_QwertyKeypad_CountryModel{ id: countryModel }

    QwertyKeypadUtility{
        id: translate
//        country : countryVariant

        Component.onCompleted: {
            if(translate.isFirstCapital)
                shiftMode = e_SHIFT_NONE;
            processNewSentence(false);
        }
    }
    function getChineseType()
    {
        return translate.keypadTypeCh;
    }

    function getChineseCountryModel()
    {
        chineseKeypadType = getChineseType();

        if(chineseKeypadType == 0)
        {
            return 2;
        }
        else if(chineseKeypadType == 1)
        {
            return 2;    // TODO - Vocal Input as 8
        }
        else if(chineseKeypadType == 2)
        {
            return 7;
        }
        else
        {
            return 2;
        }

    }

    Item {
        id : screenRepeater
        property int index : -1
        property int currIndex : 0
        y: 15

        Repeater {
            model: (countryVariant != 2)? countryModel.get(countryVariant).line : countryModel.get(getChineseCountryModel()).line
            Loader
            {
                signal loadSource();
                id: screenLoader
                Connections
                {
                    target: screenLoader.item
                    onKeyPress:
                    {
                        if(keycode_s < 0xFF || keycode_s == Qt.Key_Back || keycode_s == Qt.Key_Return || keycode_s == Qt.Key_Home)
                            qwerty_keypad.keyPress( keycode_s, keytext_s )
                    }
                    onKeyPressAndHold:
                    {
                        if( Qt.Key_Back == keycode_s && outputText.length == 0)
                            return;
			// Key_Back longpress scenario time 100ms
//                        if( Qt.Key_Back == keycode_s )
//                            translate.clearAutomata()
                        if(keycode_s < 0xFF || keycode_s == Qt.Key_Back || keycode_s == Qt.Key_Return || keycode_s == Qt.Key_Home)
                        {
                            qwerty_keypad.keyPressAndHold(keycode_s, keytext_s)
                            if( Qt.Key_Back == keycode_s )
                            {
                                idDeleteLongTime.start()
                                doDeleteUpdateIntelliKeyboard(true);
                            }
                        }
                        // Key_Back longpress scenario time 100ms
//                        if( Qt.Key_Back == keycode_s && outputText.length == 0){
//                            screenRepeater.children[index].loadSource();
//                        }
                    }
                    onKeyReleased:{

                        if(idAppMain.isKeyCanceled)
                        {
                            idDeleteLongTime.stop();
                            if(is_DeleteLongKeyTime)
                            {
                                doDeleteUpdateIntelliKeyboard(false);
                                is_DeleteLongKeyTime = false;
                            }
                            if(deletePressLong)
                                deletePressLong = false;
                            idAppMain.isKeyCanceled = false;
                            return;
                        }
                        else
                        {
                            if(!idDeleteLongTime.running)
                                screenRepeater.onKeyRelease(keycode_s, keytext_s, keystate_s);

                            idDeleteLongTime.stop();
                            if(is_DeleteLongKeyTime)
                            {
                                doDeleteUpdateIntelliKeyboard(false);
                                is_DeleteLongKeyTime = false;
                            }
                        }
                        if( Qt.Key_Back == keycode_s)
                        {
                            if(outputText.length == 0)
                            {
                                translate.clearAutomata();
                                currentFocusIndex = 0;
                                screenRepeater.children[index].loadSource();
                            }
                            if(screenRepeater.children[screenRepeater.index])
                            {
                                screenRepeater.children[screenRepeater.index].item.checkIntelliKeyboard(disableKeyForIntelliKeyboard);
                            }
                            screenRepeater.children[screenRepeater.index].item.updateTransitionIndex();
                        }
                    }
                }
                onLoadSource:{
                    console.log("screen changed = "+url+","+countryVariant+",")

                    currentFocusIndex = 0
                    if( status != Loader.Ready )
                        source = url
                    processNewSentence(false);
                    item.retranslateUi();
                    item.y = 375 - item.height
                    doUpdateIntelliKeyboard();
                }
            }
        }
        onIndexChanged:{
            children[index].loadSource()
        }

        function changeScreen(){
            if(index<0){
                currIndex = 1;
                index = 1;
            }
            else{
                screenRepeater.children[index].visible = 0;
                currIndex = index+1;
                if( currIndex+1 >= countryModel.get(countryVariant).line.count)
                    currIndex=1;
            }
            index = currIndex;
            screenRepeater.children[index].visible = 1;
        }

        function onKeyRelease(keycode, keytext, keystate){
            console.log("--onKeyRelease--"+keycode + ","+keytext+","+keystate)
            switch ( keycode )
            {
            case Qt.Key_CapsLock:
            {
                console.log("1")
                isSwitch = !isSwitch;
                break;
            }
            case Qt.Key_Control:
            {
                console.log("2")
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }
            case Qt.Key_Home:
            case Qt.Key_Launch0:
            {
                console.log("3")
                hideQwertyKeypad();
                break;
            }
            case Qt.Key_Shift:
            {
                console.log("4")
                shiftProcessing();
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }
            case Qt.Key_Launch1:
            {
                console.log("5")
                screenRepeater.children[index].visible = 0;
                if(index == 0)
                    index = currIndex;
                else
                    index = 0;
                screenRepeater.children[index].visible = 1;
                checkDisableKeyForIntelliKeyboard();
                break;
            }
            case Qt.Key_Launch2:
            {
                console.log("6")
                screenRepeater.children[index].visible = 0;
                /*
                   if( currIndex+1 >= countryModel.get(countryVariant).line.count)
                       currIndex=1;
                   else
                       currIndex++;
                   index = currIndex;
                   */
                index = 1;
                screenRepeater.children[index].visible = 1;
                checkDisableKeyForIntelliKeyboard();
                break;
            }
            case Qt.Key_Launch3:
            {
                console.log("7")
                screenRepeater.children[index].visible = 0;
                /*
                   if( currIndex+1 >= countryModel.get(countryVariant).line.count)
                       currIndex=1;
                   else
                       currIndex++;
                   index = currIndex;
                   */
                index = 2;
                screenRepeater.children[index].visible = 1;
                checkDisableKeyForIntelliKeyboard();
                break;
            }
            case Qt.Key_Launch4:
            {
                console.log("8")
                if (comma_timer.type!=1)
                    newSentence = true;
                comma_timer.isPressed = false;
                if(comma_timer.running)
                    qwerty_keypad.keyReleased( Qt.Key_Back, translate.makeWord(Qt.Key_Back,""), false );

                comma_timer.running = true;
                comma_timer.time = 0;

                if(comma_timer.type == 0)
                    qwerty_keypad.keyReleased(Qt.Key_Period, translate.makeWord( Qt.Key_Period, "." ), false);
                else if(comma_timer.type == 1)
                    qwerty_keypad.keyReleased(Qt.Key_Period, translate.makeWord( Qt.Key_At, "-"), false);
                else
                    qwerty_keypad.keyReleased(Qt.Key_Period, translate.makeWord( Qt.Key_Slash, "@"), false);

                if(comma_timer.type > 1){
                    comma_timer.type = 0;
                } else {
                    comma_timer.type++;
                }
                break;
            }
            case Qt.Key_Launch5:
            {
                console.log("9")
                qwerty_keypad.launchSettingApp();
                break;
            }

            case Qt.Key_Launch6:
            {
                console.log("10")
                screenRepeater.children[index].visible = 0;
                index = 3;
                screenRepeater.children[index].visible = 1;
                break;
            }

            case Qt.Key_Launch7:
            {
                console.log("11")
                numberToggleProcessing();
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                doUpdateIntelliKeyboard();
                break;
            }

            case Qt.Key_Launch8:
            {
                console.log("12")
                latinExtendedToggleProcessing();
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }

            case Qt.Key_Back:
            {
                console.log("13")
                if(!processNewSentence(true))
                {
                    newSentence = false;
                    defaultKey();
                }
                break;
            }
            case Qt.Key_Space:
            {
                console.log("14")
                if(translate.isFirstCapital && newSentence && shiftMode != e_SHIFT_ALWAYS)
                {
                    newSentence = false;
                    shiftMode = e_SHIFT_ONCE;
                    pressedOneShift(true);
                    screenRepeater.children[screenRepeater.index].item.retranslateUi();
                    comma_timer.running = false;
                    comma_timer.type = 0;
                    break;
                } // else goto default!
            }
            default:
            {
                newSentence = false;
                defaultKey();
                break;
            }
            }

            qwerty_keypad.forceActiveFocus();
            if(keycode < 0xFF || keycode == Qt.Key_Back || keycode == Qt.Key_Return || keycode == Qt.Key_Home || keycode == Qt.Key_Launch0)//[ITS 181041]
                qwerty_keypad.keyReleased(keycode, keytext, keystate);
        }

        function getLaunchText1()
        {
            /*
           if(index)
               return countryModel.get(countryVariant).line.get(0).name
           return countryModel.get(countryVariant).line.get(currIndex).name
           */
            return countryModel.get(countryVariant).line.get(0).name
        }

        function getLaunchText2()
        {
            /*if(currIndex + 1 >= countryModel.get(countryVariant).line.count)
               return countryModel.get(countryVariant).line.get(1).name
           return countryModel.get(countryVariant).line.get(currIndex+1).name
           */
            return countryModel.get(countryVariant).line.get(1).name
        }

        function getLaunchText3()
        {
            /*if(currIndex + 1 >= countryModel.get(countryVariant).line.count)
               return countryModel.get(countryVariant).line.get(1).name
           return countryModel.get(countryVariant).line.get(currIndex+1).name
           */
            return countryModel.get(countryVariant).line.get(2).name
        }

        function getLaunchText4()
        {
            /*if(currIndex + 1 >= countryModel.get(countryVariant).line.count)
               return countryModel.get(countryVariant).line.get(1).name
           return countryModel.get(countryVariant).line.get(currIndex+1).name
           */
            return ""//countryModel.get(countryVariant).line.get(3).name
        }

        function clearKeyLongPressed(keycode_s, keytext_s)
        {
            translate.clearAutomata()
            if(keycode_s == Qt.Key_Back)
                qwerty_keypad.keyPressAndHold(keycode_s, keytext_s)
            if( Qt.Key_Back == keycode_s && outputText.length == 0){
                screenRepeater.children[index].loadSource();
            }
        }
    }

    Component.onCompleted:
    {
        remYPos=qwerty_keypad.y
        screenRepeater.currIndex = getLanguageScreen(countryModel.get(countryVariant).line, /*translate.language_type*/2)
        screenRepeater.index = screenRepeater.currIndex;
//        checkDisableKeyForIntelliKeyboard();

    }

    function getLanguageScreen(line, language){
        var i,j;
        for( i = 0; i< line.count; i++){
            if(line.get(i).type == language)
                return i;
//            for( j = 0; j < line.get(i).init.count; j++){
//                if(line.get(i).init.get(j).language == language)
//                    return i;
//            }
        }
        return 1;
    }

//    Behavior on y
//    {
//        PropertyAnimation
//        {
//            duration: 1000
//        }
//    }

    ParallelAnimation {
            id: hideAni

            running: false
            loops: 1

            NumberAnimation { target: qwerty_keypad; property: "y"; easing.type: Easing.OutQuart; to: qwerty_keypad.y + 600; duration: 320 }
            NumberAnimation { target: qwerty_keypad; property: "opacity"; easing.type: Easing.OutQuart; to: 0.1; duration: 150 }
        }

        ParallelAnimation {
            id: showAni

            running: false
            loops: 1

            NumberAnimation { target: qwerty_keypad; property: "y"; easing.type: Easing.InQuart; to: remYPos; duration: 300 }
            NumberAnimation { target: qwerty_keypad; property: "opacity"; easing.type: Easing.InQuart; to: 1; duration: 400 }
        }

    Timer{
        id: comma_timer

        interval: 100
        property int type: 0
        property int time: 0
        property int limit: 10
        property bool isPressed: false
        repeat: true
        running: false

        onTriggered: {
            if(!isPressed)comma_timer.time++;
            if(comma_timer.time > comma_timer.limit){
                comma_timer.running = false;
                comma_timer.type = 0;
                comma_timer.time = 0;
            }
        }
    }

    Timer{
        id: idDeleteLongTime
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            if(outputText.length == 0)
            {
                idDeleteLongTime.stop();
                deletePressLong = false;
                return;
            }
            else
            {
                is_DeleteLongKeyTime = true;
            }
            var nPos = 0;
            nPos = currentCursor - 1;
            outputText = outputText.substring( 0, nPos ) + outputText.substring( nPos + 1 );
            outputCursor = nPos;
        }
    }

    function focusExitDeleteLongRelease()
    {
        if(is_DeleteLongKeyTime)
        {
            idDeleteLongTime.stop();
            newSentence = false;
            defaultKey();
            doDeleteUpdateIntelliKeyboard(false);
            is_DeleteLongKeyTime = false;
            if(outputText.length == 0)
            {
                translate.clearAutomata();
                currentFocusIndex = 0;
                screenRepeater.children[screenRepeater.index].loadSource();
            }
        }
    }

    Connections{ target: UIListener; onKeypadUpdate: update() }
    Connections{ target: UIListener; onUpdateIntelliKeypad: checkDisableKeyForIntelliKeyboard() }

    //   Connections
    //   {
    //       target: focus_visible ? UIListener : null;
    //       onSignalJogCenterPressed:
    //       {
    //           prevFocusIndex = currentFocusIndex
    //           screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = true
    //       }
    //       onSignalJogCenterReleased:
    //       {
    //            prevFocusIndex = currentFocusIndex
    //            screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = false
    //       }
    //       onSignalJogNavigation:
    //       {
    //            __handleJogEvent(arrow, status);
    //       }
    //   }
}
