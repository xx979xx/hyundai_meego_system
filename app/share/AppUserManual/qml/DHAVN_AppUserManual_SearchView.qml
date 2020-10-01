import Qt 4.7
import QmlQwertyKeypadWidget 1.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    id: appUserManualSearchView

    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: Dimensions.const_AppUserManual_MainScreenHeight
    anchors.bottomMargin: Dimensions.const_AppUserManual_Search_BottomMargin

    property int focus_id: Dimensions.const_AppUserManual_Search_View_FocusIndex
    property bool focus_visible: ( appUserManual.focusIndex == focus_id && !disable_popup.visible && !systemPopupVisible )

    property int count: 0
    property bool keyPadFocussed: false
    property bool isFromErrorView: false
    property int listFocusId: 0
    property bool searchTextBoxFocused:  false
    property bool moveFocus: false
    property int focus_index: Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
    property int tmpFocusIndex: -1
    property bool searching: false
    property bool jogPressed: false
    property bool jogCenterPressed: false
    property bool systemPopupTmpVisible: false
    property string txt_notFound: qsTranslate( "main", "STR_MANUAL_OK" )
    property string txt_ok: qsTranslate( "main", "STR_MANUAL_OK" )
    property string pinyin: "NONE"              // "NONE", "PINYIN", "SOUND", "HANDWRITING"
    property int setChineseKeypadType: EngineListener.getChineseKeypadType()  // 기본값은 0 (병음) – 병음 : 0, 성음 : 1, 필기인식 : 2
    property bool isChinessKeypad: false
    property bool isKeypadJogCenter: false
    property bool pinyinComplete: false
    property int lastPinYinPosition: 0
    property bool enablePinyin: true
    property string doneType: "Search"
    property bool useVocalSound: false
    property string outputText: ""
    property int currentCursor: 0
    property int keypadType: -1     // 0. 한글 , 1. 영어-라틴 , 2. 중동 , 3. 유럽
    property bool isPressAndHold: false
    property bool isPinYinPressAndHold: false

    function setDRS()
    {
        console.log("SearchView.qml :: setDRS()")
        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
        keyPadWidget.sendJogCanceled()
        keyPadWidget.clearState();
        toast_searchview.visible = false
        warningPopUp.visible = false
        jogPressed = false
        appUserManualSearchBar.displayTextDeleteAll()
//        /* space */
//        keyPadWidget.initKeypad()                     // ITS 265601
//        keyPadWidget.setDisableButton("space");       // space 항상 활성화
//        keyPadWidget.setDisableButton("delete")       // ITS 265601
//        keyPadWidget.setDisableButton("done")
//        keyPadWidget.setDisableButton("hide");
        appUserManualSearchBar.clearSearchBar()
        lastPinYinPosition = 0
        pinyinComplete = false;
    }

    function clearLastPinYinPosition()
    {
        lastPinYinPosition = 0
    }

    // 언어 변경 return 팝업 출력 시
    function showDisablePopup()
    {
        console.log("SearchView.qml :: showDisablePopup()  ")

        // toast popup
        toast_searchview.visible = false

        // 검색 결과 팝업
        warningPopUp.visible = false
        clearSearchView()       // 검색 결과 없음 팝업 close 시 searchview clear
    }

    function setKeypadSettings(index)
    {
        console.log("SearchView.qml :: setKeypadSettings( index ) : ", index)
        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
        if ( index == -1 ) return;

        //***   select 문자열 > 알파벳 치환, 검색 enable   ***//
        appUserManualSearchBar.selectedTextToInputText()
        pinyinComplete = true
        if( appUserManual.searchText.length > 0 ) {
            keyPadWidget.setEnableButton("done")
            appUserManualSearchBar.setSearchIcon(true)
        }
        //********************************//

        setChineseKeypadType = index
        keyPadWidget.setChineseKeypadType = index
        keyPadWidget.chineseKeypadChanged( index )
        EngineListener.setChineseKeypadType(setChineseKeypadType)

    }

    function getKeypadType()
    {
        console.log("SearchView.qml :: getKeypadType( keypadType ) : ", keypadType)
        return keypadType;
    }

    function getPopupVisible()
    {
        console.log("SearchView.qml :: getPopupVisible() - " , chineseKeypadPopup.visible )
        return chineseKeypadPopup.visible
    }

    function hidePopup()
    {
        console.log("SearchView.qml :: hidePopup()")
        chineseKeypadPopup.item.hidePopUp()
    }

    function getChineseKeypadType()
    {
        console.log("SearchView.qml :: getChineseKeypadType() : ", setChineseKeypadType)
        return setChineseKeypadType == 0 ? 0 : 1
    }

    function toastPopupVisible( visible )
    {
        console.log("SearchView.qml :: toastPopupVisible( visible ) : ", visible)
        toast_searchview.visible = visible
        if ( visible ) focus_index = -1
    }

    function resetPress()
    {
        console.log("SearchView.qml :: resetPress()")
        jogPressed = false
        jogCenterPressed = false
    }

    function checkSearching()
    {
        console.log("SearchView.qml :: checkSearching()")
        return pdfScreen.item.checkSearching()
    }

    function startSearchTimer()
    {
        startSearch_timer.start()
    }

    function waitSearch()
    {
        console.log("SearchView.qml :: waitSearch()")
        waitingPopUp.visible = true;
        waitTimer.restart();
    }

    function searchTextBoxClicked()
    {
        console.log("SearchView.qml :: searchTextBoxClicked()")
        if( keyPadWidget.isHide )
        {
            keyPadWidget.showQwertyKeypad();
        }
        appUserManualSearchBar.showMarker()
    }

    // searchview launch 시 search bar clear
    function clearSearchView()
    {
        console.log("SearchView.qml :: clearSearchView()")
        var tmpKeypadType = EngineListener.getChineseKeypadType()
        if ( setChineseKeypadType != tmpKeypadType ) {
            setChineseKeypadType = tmpKeypadType
            keyPadWidget.setChineseKeypadType = setChineseKeypadType
            keyPadWidget.chineseKeypadChanged( setChineseKeypadType )
        }
        keyPadWidget_item.y = 0//Dimensions.const_AppUserManual_KeyPad_Y
        keyPadWidget.clearState();
        toast_searchview.visible = false
        warningPopUp.visible = false
        jogPressed = false
        appUserManualSearchBar.displayTextDeleteAll()
//        keyPadWidget.update()
//        keyPadWidget.showQwertyKeypad();
////        keyPadWidget.clearBuffer()
//
        /* space */
        keyPadWidget.initKeypad()
//        keyPadWidget.setDisableButton("space");       // space 항상 활성화
        keyPadWidget.setDisableButton("delete")
        keyPadWidget.setDisableButton("done")
        keyPadWidget.setDisableButton("hide");

        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
        appUserManualSearchBar.clearSearchBar()
        lastPinYinPosition = 0
        pinyinComplete = false;
        isPressAndHold = false;
        isPinYinPressAndHold = false;
    }

    function clearAutomata()
    {
        console.log("SearchView.qml :: clearAutomata()")
        keyPadWidget.clearBuffer()
    }

    function searchTextFound()
    {
        console.log("SearchView.qml :: searchTextFound()")
//       if ( appUserManual.tempState == "pdfScreenView" )
//            appUserManual.state = appUserManual.tempState
        if ( toast_searchview.visible )  appUserManual.setFullScreen(false)
        toastPopupVisible( false)
//        focus_visible = false
        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
    }

    function searchTextNotFound()
    {
        console.log("SearchView.qml :: searchTextNotFound() - tempState : ", appUserManual.tempState)

        if ( appUserManual.systemPopupVisible ) {
            systemPopupTmpVisible = true
            return;
        }
        if ( !appUserManual.lockoutMode ) {
            warningPopUp.visible = true
//            appUserManual.exitSearchNotFound()
            pdfScreen.item.stopTimer()
        }
        else {
//            tempPopup = true
        }

        focus_index = -1 // Dimensions.const_AppUserManual_Focus_SearchBar
//        clearSearchView()
    }

    function hideKeyPad()
    {
        console.log("SearchView.qml :: hideKeyPad()")
        keyPadWidget.hideQwertyKeypad()
        searchTextBoxFocused = true
//        keyPadWidget.hideFocus()
//        searchFocusIndex = Dimensions.const_AppUserManual_SearchBox_FocusIndex
        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
    }

    function searchPDFListReceived( searchPDFStringList )
    {
        console.log("SearchView.qml :: searchPDFListReceived()  searchPDFStringList : ", searchPDFStringList)
        searchPdfListModel.clear()

        var i = 0;

        for( ; i < searchPDFStringList.length; ++i )
        {
            searchPdfListModel.append( { "titleLabel" : searchPDFStringList[i] } )
        }
    }

    function setKeypadDisable( drs )
    {
        console.log("SearchView.qml :: setKeypadDisable()")
//        if ( drs ) keyPadWidget_item.y = Dimensions.const_AppUserManual_KeyPad_Y +700
//        else keyPadWidget_item.y = Dimensions.const_AppUserManual_KeyPad_Y
    }

    function showPDFEmptyPopUp()        // not used
    {
        console.log("SearchView.qml :: showPDFEmptyPopUp()")
    }

    DHAVN_AppUserManual_SearchBar
    {
        id: appUserManualSearchBar
        width: Dimensions.const_AppUserManual_MainScreenWidth
        height: Dimensions.const_AppUserManual_SearchBox_Height
        x: 0 //Dimensions.const_AppUserManual_Search_X
        y: Dimensions.const_AppUserManual_Search_Y //+ 8
        z: 10
    }
    Item
    {
        id: keyPadWidget_item
        width:  1280; height:  720
        x: 0; y: 0
//        x: Dimensions.const_AppUserManual_SearchBox_X
//        y: Dimensions.const_AppUserManual_KeyPad_Y
//        z: Dimensions.const_AppUserManual_SearchBox_Z
//        width: keyPadWidget.width
//        height: 334 + keyPadWidget.height
        clip: true
        QmlQwertyKeypadWidget
        {
            id: keyPadWidget

            focus_id: Dimensions.const_AppUserManual_KeyPad_FocusIndex
            focus_visible: focus_index == Dimensions.const_AppUserManual_Focus_SearchBar_Keypad && appUserManual.state == "pdfSearchView" && appUserManualSearchView.focus_visible
                && !appUserManual.lockoutMode // ( appUserManualSearchView.searchFocusIndex == focus_id && keyPadFocussed )
                && !disable_popup.visible

            doneButtonType: doneType

            function input(key, label, state)
            {
                console.log("SearchView.qml :: input() key : ", key , " , label: " , label )
                focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
                appUserManualSearchBar.hideMarker()
                if( ( Qt.Key_Return === key ) || ( Qt.Key_Home === key ) )
                {
                    console.log("SearchView.qml :: input() - Key_Return/Key_Home")
                    focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                    if( appUserManual.searchText.length != 0 )
                    {
                        if ( pdfScreen.item.checkSearching() ) {
                            waitSearch()
                        }
                        else {
                            toastPopupVisible(true)
                            startSearch_timer.start()
//                            appUserManual.searchString( true )
                        }
                    }
                }
                else
                {
                    console.log("SearchView.qml :: input() - else")
                    appUserManualSearchBar.displayText( key, label, state )
                    if ( Qt.Key_Launch4 != key && appUserManual.searchText.length == 0 && !isKeypadJogCenter ) EngineListener.playAudioBeep()
                }
                if ( UIListener.GetCountryVariantFromQML() == 2 ) appUserManualSearchBar.setPinyinColor( lastPinYinPosition )

                /* space */
                if ( appUserManual.searchText.length == 0 ) {
                    console.log("SearchView.qml :: setDisableButton - done, delete, search icon" )
//                    keyPadWidget.setDisableButton("space")       // space 항상 활성화
                    keyPadWidget.setDisableButton("done")
                    keyPadWidget.setDisableButton("delete")
                    appUserManualSearchBar.setSearchIcon(false)
                }
                else {
                    console.log("SearchView.qml :: setEnableButton - delete" )
//                    keyPadWidget.setEnableButton("space") // space 항상 활성(중국 키보드와 상관없음)
                    if ( pinyin == "NONE" || pinyin == "HANDWRITING" ) keyPadWidget.setEnableButton("done")     // 중국키보드가 아닐 경우, 필기인식이 아닐 경우 활성
                    keyPadWidget.setEnableButton("delete")
                    if ( pinyin == "NONE" || pinyin == "HANDWRITING" ) appUserManualSearchBar.setSearchIcon(true)

                }
            }

            function pinyinInput(key, label, state) {
                if(Qt.Key_Back == key) {
                    console.log("SearchView.qml :: pinyInput() Key_Back" )
                    if(0 < lastPinYinPosition) {
                        lastPinYinPosition--;
                    }
                    input(key, label, state);
                    if(lastPinYinPosition ==0) {
                        keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                        pinyinComplete = true;
                    }
                }
                else if(Qt.Key_Home == key) {
                    console.log("SearchView.qml :: pinyInput() Key_Home" )
                    if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                        // 완료를 눌렀을때 병음입력 중이었다면 삭제함
                        if(0 < lastPinYinPosition) {
                            var position =  lastPinYinPosition;

                            currentCursor = outputText.length - lastPinYinPosition
                            lastPinYinPosition = 0;
                            pinyinComplete = true;

                            outputText = outputText.substring(0, outputText.length - position)
                        }
                    }

                    input(key, label, state);
                }
                else {
                    var regexLetter = /[a-zA-Zʼ]/;
                    if( true == regexLetter.test(label) || label == "'" ) {     // 병음 알파벳 입력
                        console.log("SearchView.qml :: pinyInput() labe[a-Z]")
                        if ( !enablePinyin ) {
                            console.log("SearchView.qml :: pinyinInput() - disablePinyin! return!!")
                            return;
                        }
                        pinyinComplete = false;
                        lastPinYinPosition++;
                        input(key, label, state);
                    }
                    else {                  // 병음 후보군 입력
                        console.log("SearchView.qml :: pinyInput() else")
                        if ( lastPinYinPosition > 0 && key == 32 ) {      // 병음 후보군이 없는 알파벳인데, space 입력한 경우
                            appUserManualSearchBar.selectedTextToInputText()        // 입력 중이던 병음을 일반 알파벳으로 변환
                            lastPinYinPosition = 0
                            pinyinComplete = true
                        }
                        else {
                            var position =  lastPinYinPosition;

                            // 영어로 입력된 글자를 삭제(lastPinyinPosition까지)하고 한자로 대체함
                            if ( lastPinYinPosition == 1 ) {            // 알파벳 한 글자 -> 한자 변환 시 커서 위치 조절
                                appUserManualSearchBar.displayText( Qt.Key_Back, 0,0 )
                            }
                            appUserManualSearchBar.pinyInput( position, label )
                            appUserManualSearchBar.setSearchIcon(true)
                            keyPadWidget.setEnableButton("done")
                            clearAutomata();
                            appUserManualSearchBar.setPinyinColor( lastPinYinPosition )
                            if ( lastPinYinPosition ) {
                                console.log("SearchView.qml :: text_input.selectedText: ", text_input.selectedText )
                                appUserManualSearchBar.searchChinesePinyin()
                            }
                            else {
                                console.log("SearchView.qml :: appUserManual.searchText: ", appUserManual.searchText )
                                keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                            }
                        }
                    }
                    if ( focus_index != Dimensions.const_AppUserManual_Focus_SearchBar_Keypad ) {       // 검색 입력 창 포커스 있는 상태에서 space 입력 시 포커스 이중 표시 수정
                        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
                        appUserManualSearchBar.hideMarker()
                    }
                }
        }

        function previewHWRCandidate(key, label, state)
        {
            console.log("SearchView.qml :: previewHWRCandidate()" )
            if(label == "" && lastPinYinPosition == 0)
                return;

            if( lastPinYinPosition == 0) {
                pinyinComplete = false;
                lastPinYinPosition++;
                input(key, label, state);
                appUserManualSearchBar.setPinyinColor( lastPinYinPosition )
            }
            else {
                if(lastPinYinPosition == 1)
                {
                    appUserManualSearchBar.displayText( Qt.Key_Back, 0,0 )
                    lastPinYinPosition = 0
                    pinyinComplete = false;
                }

                if(label == "")
                {
                    pinyinComplete = true;

                    //현재 입력되어 있는 글자 다음에 올수 있는 후보군 표시한다.
                    keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                }
                else
                {
                    lastPinYinPosition++;
                    input( key, label, state)
                }
            }
            if ( appUserManual.searchText.length ==  0) keyPadWidget.setDisableButton("delete")
        }

        function hwrInput(key, label, state) {
            console.log("SearchView.qml :: hwrInput()" )
            if(Qt.Key_Back == key) {
                if(0 < lastPinYinPosition) {
                    lastPinYinPosition--;
                }
                input(key, label, state);

                // 수정필요.
                keyPadWidget.clearState();

                //수정필요. 삭제 버튼을 눌렀을 때, lastPinyinPosition이 없으면 글자 다음에 올수 있는 후보군 검색
                if(lastPinYinPosition == 0)
                    keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                    pinyinComplete = true;
            }
            else if(Qt.Key_Home == key) {
                if(0 < lastPinYinPosition) {
                    var position =  lastPinYinPosition;

                    currentCursor = outputText.length - lastPinYinPosition
                    lastPinYinPosition = 0;
                    pinyinComplete = true;

                    outputText = outputText.substring(0, outputText.length - position)
                }

                input(key, label, state);
            }
            else if(key==Qt.Key_A && label != "")
                {
                    // 영어로 입력된 글자를 삭제(lastPinyinPosition까지)하고 한자로 대체함
                    if ( lastPinYinPosition == 1 ) {            // 알파벳 한 글자 -> 한자 변환 시 커서 위치 조절
                        appUserManualSearchBar.displayText( Qt.Key_Back, 0,0 )
                        lastPinYinPosition = 0;
                        input( key, label, state)
                    }
                    else
                    {
                        console.log("SearchView.qml :: hwrInput(): lastPinYinPosition:"+lastPinYinPosition)
                        input( key, label, state)
                    }

                    lastPinYinPosition = 0;
                    pinyinComplete = true;
                    appUserManualSearchBar.setSearchIcon(true)
                    keyPadWidget.setEnableButton("done")
                    keyPadWidget.clearState();

                    //수정필요. 글자 다음에 올수 있는 후보군 검색
                    if(lastPinYinPosition == 0)
                        keyPadWidget.searchChinesePrediction(appUserManual.searchText)
            }
            else {
                if ( lastPinYinPosition == 0 ) {
                    console.log("SearchView.qml :: hwrInput(): key:" , key )
                    input( key, label, state)
                    pinyinComplete = true;
                }
            }
        }

            onNKeypadDefaultTypeChanged:
            {
                keypadType = nKeypadDefaultType
                appUserManualSearchBar.setKeypadType( keypadType )
                console.log("SearchView.qml :: onNKeypadDefaultTypeChanged - keypadType: " ,  keypadType )
            }

            onChineseKeypadChanged:                                // 1. Signal 발생시 (QML)
            {
                for ( var i = 0; i < lastPinYinPosition; i++)               // 입력 중이던 병음 삭제
                    appUserManualSearchBar.displayText( Qt.Key_Back, 0, 0 )
                lastPinYinPosition = 0;
                pinyinComplete = true;
                EngineListener.sendChineseKeypad(keypadType)       // 2. 하단 함수 호출
            }
            onLaunchChineseKeypadPopup:
            {
                console.log("SearchView.qml :: onLaunchChineseKeypadPopup" )
                focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad     // focus_index = -1
                appUserManualSearchBar.hideMarker_chinesePopup()
                chineseKeypadPopup.showPopupDirectly("DHAVN_ChineseKeypadPopup.qml");
                chineseKeypadPopup.item.showPopUp()
            }

            onPreviewCandidate:
            {
                previewHWRCandidate(key, label, state)
                if ( pinyinComplete && appUserManual.searchText.length != 0) {
                    console.log("SearchView.qml :: onPreviewCandidate - pinyinComplete")
                    keyPadWidget.setEnableButton("done")
                    appUserManualSearchBar.setSearchIcon(true)
                }
                else {
                    console.log("SearchView.qml :: onPreviewCandidate - !pinyinComplete")
                    keyPadWidget.setDisableButton("done")
                    appUserManualSearchBar.setSearchIcon(false)
                }
            }

            onLaunchSettingApp:
            {
                console.log("SearchView.qml :: onLaunchSettingApp -> focusIndex : ", appUserManual.focusIndex )
                EngineListener.launchKeypadSettings( UIListener.getCurrentScreen() )
            }
            onChinessKeypad: {
                //console.log("######################################");
                console.log("SearchView.qml :: onChinessKeypad: chiness = " + isChiness + ", type = " + keypadType);
                isChinessKeypad = isChiness
                //console.log("######################################");
//                if ( appUserManual.searchText.length != 0 ) keyPadWidget.setEnableButton("space")     // space 항상 활성
                appUserManualSearchBar.selectedTextToInputText()        // 입력 중이던 병음을 삭제하는 대신 일반 알파벳으로 변환
//                for ( var i = 0; i < lastPinYinPosition; i++)               // 입력 중이던 병음 삭제
//                    appUserManualSearchBar.displayText( Qt.Key_Back, 0, 0 )
                lastPinYinPosition = 0;
                pinyinComplete = true;

                var newPinyin = "";
                if(true == isChiness) {
                    switch(keypadType) {
                        case 0: /* 병음 */
                            newPinyin = "PINYIN";
                            keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                            break;
                        case 1: /* 성음 */
                            newPinyin = "SOUND";
                            keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                            break;
                        case 2: /* 필기 */
                            newPinyin = "HANDWRITING";
                            keyPadWidget.searchChinesePrediction(appUserManual.searchText)
                            break;
                        default:
                            newPinyin = "NONE";
                            break;
                    }
                } else {
                    newPinyin = "NONE";
//                    for ( var i = 0; i < lastPinYinPosition; i++)               // 입력 중이던 병음 삭제
//                        appUserManualSearchBar.displayText( Qt.Key_Back, 0, 0 )
//                    lastPinYinPosition = 0;
//                    pinyinComplete = true;
                }

                if( isChiness && ("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) ) {
                    // 이전에 병음입력이었다면 반전된(완성되기 전) 입력분을 삭제함
                    var position = lastPinYinPosition;

                    lastPinYinPosition = 0;
                    clearAutomata();

                    currentCursor = outputText.length - position;
                    outputText = outputText.substring(0, outputText.length - position);
                } else if("SOUND" == pinyin) {
                    // 이전에 성음입력이었다면 모두 삭제함
                    //clearAutomata();

    /*DEPRECATED
                    lastPinYinPosition = 0;
                    currentCursor = 0;
                    outputText = "";
    DEPRECATED*/
                }

                if(newPinyin == "HANDWRITING")
                    keyPadWidget.searchChinesePrediction(appUserManual.searchText)

                pinyin = newPinyin;
                appUserManualSearchBar.setChineseKeypad(pinyin)
            }

            onKeyReleased: {
                if ( isPressAndHold ) {
                    if( isPinYinPressAndHold )
                    {
                        console.log("SearchView.qml :: isPinYinPressAndHold: true ")
                    }
                    else{
                        isPressAndHold = false
                        pressAndHold_timer.stop()
                    }
                    //return
                }
                if ( appUserManual.state != "pdfSearchView" ) {
                    if ( appUserManual.countryVariant != 2 ) clearAutomata();
                    isKeypadJogCenter = false;
                    return;
                }
                console.log("SearchView.qml :: onKeyReleased - key: ", key , " , label: " , label )
                if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                    pinyinInput(key, label, state);
                    // 병음 후보군 40글자로 입력 제한
                    if  ( appUserManualSearchBar.getSelectTextLength() > 39 ) enablePinyin = false
                    else enablePinyin = true
                }
                else if("HANDWRITING" == pinyin)
                {
                    hwrInput(key, label, state);
                    enablePinyin = true
                }
                else {
                    input(key, label, state);
                    enablePinyin = true
                }
                if ( appUserManual.countryVariant != 2 || !isChinessKeypad ) {
                    if ( appUserManual.searchText.length == 0 ) {
                        keyPadWidget.setDisableButton("done")
                        keyPadWidget.setDisableButton("delete")
                        appUserManualSearchBar.setSearchIcon(false)
                    }
                    else {
                        keyPadWidget.setEnableButton("delete")
                        keyPadWidget.setEnableButton("done")
                        appUserManualSearchBar.setSearchIcon(true)
                    }
                }
                else if ( !pinyinComplete ) {
                    console.log("SearchView.qml :: onKeyReleased - !pinyinComplete")
                    keyPadWidget.setDisableButton("done")
                    appUserManualSearchBar.setSearchIcon(false)
                }
                else if ( appUserManual.searchText.length == 0 ) {
                    keyPadWidget.setDisableButton("delete")
                    keyPadWidget.setDisableButton("done")
                    appUserManualSearchBar.setSearchIcon(false)
                }
                else {
                    keyPadWidget.setEnableButton("delete")
                    keyPadWidget.setEnableButton("done")
                    appUserManualSearchBar.setSearchIcon(true)
                }
                isKeypadJogCenter = false;
            }

            onReleaseAtPressAndHold:
            {
                console.log("SearchView.qml :: onReleaseAtPressAndHold"  );
                if ( isPressAndHold ) {
                    isPinYinPressAndHold = false
                }
            }

            onKeyPressAndHold:
            {
                if( Qt.Key_Back === key )
                {
                    //appUserManualSearchBar.displayTextDeleteAll( key, label, state )
                    console.log("SearchView.qml :: onKeyPressAndHold()")
                    isPressAndHold = true
                    pressAndHold_timer.start()
                    if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                        if ( !enablePinyin ) {
                            console.log("SearchView.qml :: onKeyReleased - disablePinyin! return!!")
                            return;
                        }
                        isPinYinPressAndHold = true
                        console.log("SearchView.qml :: PINYIN == pinyin")
                        //pinyinInput(key, label, state);

                        // 병음 후보군 12글자로 입력 제한
//                        if  ( appUserManualSearchBar.getSelectTextLength() > 11 ) enablePinyin = false
//                        else enablePinyin = true

                        //keyPadWidget.deleteLongPressInPinYin()
                    }
                    else if("HANDWRITING" == pinyin)
                    {
                        hwrInput(key, label, state);
                        enablePinyin = true
                    }
                    else {
                        input(key, label, state);
                        enablePinyin = true
                    }

                    /*
                      /// delete all ///
                    appUserManualSearchBar.displayTextDeleteAll()
                    lastPinYinPosition = 0
                    pinyinComplete = false;
                    keyPadWidget.setDisableButton("space")
                    keyPadWidget.setDisableButton("done")
                    keyPadWidget.setDisableButton("delete")
                    appUserManualSearchBar.setSearchIcon(false)
                    EngineListener.playAudioBeep()
                    //search string should be erased.

                    // 수정필요.
                    keyPadWidget.clearState();
                    */
                }
            }

            onLostFocus:
            {
                console.log("SearchView.qml :: QwertyKeyPad - onLostFocus")
                //arrow for the jog event should be checked and the keypad should be hidden.
                if( arrow === UIListenerEnum.JOG_UP )
                {
                    console.log("SearchView.qml :: onLostFocus - UIListenerEnum.JgOG_UP")
//                    searchFocusIndex = Dimensions.const_AppUserManual_SearchBox_FocusIndex
                    appUserManualSearchBar.selectedTextToInputText()
                    lastPinYinPosition = 0
                    pinyinComplete = true;
                    focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                    appUserManualSearchBar.showMarker()
                    /* 중국향 searchbar focus 불가일 경우
                    if ( UIListener.GetCountryVariantFromQML() != 2 ) {
                        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                        appUserManualSearchBar.showMarker()
                    }
                    else {              // 중국향일 경우 jog_up 시 searchbar로 focus 가지 않음
                        if ( appUserManualSearchBar.getSearchIcon() ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search
                        else focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Back
                    }
                    */
                    console.log("SearchView.qml :: onLostFocus - focus_index : ", focus_index)
                }
            }
        }
    }

    function pressAndHoldTrigger()
    {
        console.log("SearchView.qml ::  pressAndHoldTrigger() ")
        if ( !isPressAndHold ) return
        if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
            if ( !enablePinyin ) {
                console.log("SearchView.qml :: onKeyReleased - disablePinyin! return!!")
                return;
            }
            //keyPadWidget.pinyinInput(Qt.Key_Back, 0, false);

//            // 병음 후보군 40글자로 입력 제한
//            if  ( appUserManualSearchBar.getSelectTextLength() > 39 ) enablePinyin = false
//            else enablePinyin = true
            keyPadWidget.deleteLongPressInPinYin()
        }
        else if("HANDWRITING" == pinyin)
        {
            keyPadWidget.hwrInput(Qt.Key_Back, 0, false);
            enablePinyin = true
        }
        else {
            keyPadWidget.input(Qt.Key_Back, 0, false);
            enablePinyin = true
        }
        if ( appUserManual.searchText.length == 0 ) {
            isPressAndHold = false
            isPinYinPressAndHold = false
//            keyPadWidget.setDisableButton("space");       // space 항상 활성화
            keyPadWidget.setDisableButton("delete")
            keyPadWidget.setDisableButton("done")
            pressAndHold_timer.stop()
        }
    }

    Timer
    {
        id: pressAndHold_timer
        interval: 150
        repeat: true
        onTriggered:
        {
            console.log("SearchView.qml :: pressAndHold_timer onTriggered")
            pressAndHoldTrigger()
        }
    }

    Timer
    {
        id: waitTimer

        interval: 3000
        running: false
        repeat: false

        onTriggered:
        {
            console.log("SearchView.qml :: waitTimer onTriggered")
            waitingPopUp.visible = false;
        }
    }

    Timer
    {
        id: startSearch_timer

        interval: 300
        running: false
        repeat: false

        onTriggered:
        {
            console.log("SearchView.qml :: startSearch_timer onTriggered")
            if ( appUserManual.state == "pdfSearchView" ) appUserManual.searchString( true )
        }
    }

    Loader {
        id: chineseKeypadPopup;
        anchors.fill: parent
        visible: false
        source: ""
        z: 10
        Binding{
            id: visibleBinding
            target: chineseKeypadPopup
            property: "visible"
            value: (chineseKeypadPopup.item == null) ? false : chineseKeypadPopup.item.visible
        }

        function showPopupDirectly(sourcePath)
        {
            source = sourcePath
            visible = true
        }

        onVisibleChanged:
        {
            if (visible)
            {
                focus_index = -1
            }
            else
            {
                source = ""
                focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
            }
        }
    }
//    POPUPWIDGET.PopUpText
//    {
//        id: waitingPopUp
//        z: Dimensions.const_AppUserManual_Z_1000
//        visible: false
//        icon_title: EPopUp.WARNING_ICON
//       message: ListModel {
//           ListElement { msg: QT_TR_NOOP("STR_MANUAL_SEARCH_WAITING") }
//       }
//    }


   Connections
   {
       target: EngineListener

       onUpdateKeypad:
       {
           if (  UIListener.getCurrentScreen() != screenId ) return;
           console.log("SearchView.qml :: updateKeypad() ")
           keyPadWidget.update();
       }
   }

    Connections
    {
        target: ( appUserManual.state == "pdfSearchView" && !optionMenu.focus_visible ) ? UIListener : null
//        target: ( appUserManualSearchView.focus_visible && !optionMenu.focus_visible ) ? UIListener : null

        onSignalShowSystemPopup:
        {
            console.log("SearchView.qml :: onSignalShowSystemPopup")
            toast_searchview.visible = false
            keyPadWidget.enableChineseHWRInput = false
            if ( warningPopUp.visible ) {
                systemPopupTmpVisible = true
                warningPopUp.visible = false
            }
        }
        onSignalHideSystemPopup:
        {
            console.log("SearchView.qml :: onSignalHideSystemPopup")
            keyPadWidget.enableChineseHWRInput = true
            if ( pdfScreen.item.checkSearching() ) {
                console.log("SearchView.qml :: onSignalHideSystemPopup - checkSearching")
                toastPopupVisible(true)
            }
            else if ( systemPopupTmpVisible ) {
                console.log("SearchView.qml :: onSignalHideSystemPopup - search not found")
                systemPopupTmpVisible = false
                searchTextNotFound()
            }
//            focus_index = tmpFocusIndex
//            tmpFocusIndex = -1
        }

        onSignalJogNavigation:
        {
            if ( disable_popup.visible ) return;
            if ( focus_index == -1 ) return;
            if ( appUserManual.lockoutMode ) return
            if ( appUserManual.state != "pdfSearchView" ) return
            if ( appUserManual.lockoutMode ) return
            console.log("SearchView.qml :: onSignalJogNavigation")
            if ( toast_searchview.visible || warningPopUp.visible ) return;
            if( status === UIListenerEnum.KEY_STATUS_PRESSED ) {
//                jogPressed = true
                switch ( focus_index )
                {
                    case -1 :
                        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar:
                    {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_WHEEL_RIGHT:
                            {
                                appUserManualSearchBar.moveFocusF()
                                keyPadWidget.clearBuffer()
                            }
                                break;
                            case UIListenerEnum.JOG_WHEEL_LEFT:
                            {
                                appUserManualSearchBar.moveFocusB()
                                keyPadWidget.clearBuffer()
                            }
                            case UIListenerEnum.JOG_CENTER:
                            case UIListenerEnum.JOG_DOWN: {
                                focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
                                appUserManualSearchBar.hideMarker()
                            }
                            break;
                        }
                    }
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar_Search:
                    {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_WHEEL_RIGHT:
                                if ( appUserManual.langId != 20 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Back
                                break;
                            case UIListenerEnum.JOG_WHEEL_LEFT:
                                if ( appUserManual.langId == 20 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Back
                                break;
                            case UIListenerEnum.JOG_CENTER:
                                jogPressed = true
                                break;
                        }
                    }
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar_Back:
                    {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_WHEEL_LEFT: {
                                if ( appUserManual.langId != 20 ) {
                                    if ( appUserManual.searchText.length != 0 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search

//                                    if ( UIListener.GetCountryVariantFromQML() != 2 ) {
//                                        if ( appUserManual.searchText.length != 0 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search
//                                    }
//                                    else {
//                                        if ( appUserManualSearchBar.getSearchIcon() ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search
//                                    }
                                }
                            }
                                break;
                            case UIListenerEnum.JOG_WHEEL_RIGHT: {
                                    if ( appUserManual.langId == 20 ) {
                                        if ( appUserManual.searchText.length != 0 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search
                                    }
                            }
                            break;
                            case UIListenerEnum.JOG_CENTER:
                                jogPressed = true
                                break;
                        }
                    }
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar_Keypad: {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_CENTER: {
                                isKeypadJogCenter = true;
                            }
                            break;
                        }
                    }
                    break;
                }
            }
            else if( status === UIListenerEnum.KEY_STATUS_RELEASED )
            {
//                if ( !jogPressed ) return;
//                jogPressed = false
                if( keyPadWidget.isHide ) keyPadWidget.showQwertyKeypad();
                switch ( focus_index )
                {
                    case -1 :
                        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar:
                    {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_RIGHT:
                            {
                                if ( appUserManual.langId != 20 ) {
                                    if ( appUserManual.searchText.length == 0 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Back
                                    else focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search
                                    appUserManualSearchBar.hideMarker()
                                }
                            }
                            break;
                            case UIListenerEnum.JOG_LEFT:
                            {
                                if ( appUserManual.langId == 20 ){
                                    if ( appUserManual.searchText.length == 0 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Back
                                    else focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Search
                                    appUserManualSearchBar.hideMarker()
                                }
                            }
                            break;
                            case UIListenerEnum.JOG_UP:
                            {
                                appUserManualSearchBar.showMarker()
                            }
                        }
                    }
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar_Search:
                    {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_RIGHT:
                            {
                                if ( appUserManual.langId == 20 ) {
                                    focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                                    appUserManualSearchBar.showMarker()
                                }
                            }
                            break;
                            case UIListenerEnum.JOG_LEFT:
                            {
                                if ( appUserManual.langId != 20 ) {
                                    focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                                    appUserManualSearchBar.showMarker()
                                }
//                                if ( appUserManual.langId != 20 && UIListener.GetCountryVariantFromQML() != 2 ) focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                            }
                            break;
                            case UIListenerEnum.JOG_CENTER:
                            {
                                if( appUserManual.searchText.length != 0 )
                                {
                                    if ( pdfScreen.item.checkSearching() ) {
                                        waitSearch()
                                    }
                                    else {
                                        toastPopupVisible(true)
                                        startSearch_timer.start()
//                                        appUserManual.searchString( true )
                                        focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                                    }
                                }
                                break;
                            }
                            case UIListenerEnum.JOG_DOWN:
                                focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
                                break;
                        }
                    }
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar_Back:
                    {
                        switch( arrow )
                        {
                            case UIListenerEnum.JOG_LEFT:
                            {
                                if ( appUserManual.langId != 20 ) {
                                   /* if ( UIListener.GetCountryVariantFromQML() != 2 ) */focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                                   appUserManualSearchBar.showMarker()
                                }
                            }
                            break;
                            case UIListenerEnum.JOG_RIGHT:
                            {
                                if ( appUserManual.langId == 20 ) {
                                    /*if ( appUserManual.searchText.length == 0 ) */focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                                    appUserManualSearchBar.showMarker()
                                }
                            }
                            break;
                            case UIListenerEnum.JOG_CENTER:
                                appUserManual.handleBackKey( false , false , false )
                                break;
                            case UIListenerEnum.JOG_DOWN:
                                focus_index = Dimensions.const_AppUserManual_Focus_SearchBar_Keypad
                        }
                    }
                        break;
                    case Dimensions.const_AppUserManual_Focus_SearchBar_Keypad:
                    {
                        console.log("SearchView.qml :: keypad jog released")
    //                            searchFocusIndex = Dimensions.const_AppUserManual_KeyPad_FocusIndex
                        keyPadFocussed = true
                    }
                        break;
                }
              /*
                else
                {
                    if( keyPadWidget.isHide )
                    {
                        keyPadWidget.showQwertyKeypad();
                    }
                    if( !searchTextBoxFocused && !keyPadFocussed)
                    {
                        searchTextBoxFocused = true
                        searchFocusIndex = Dimensions.const_AppUserManual_SearchBox_FocusIndex
                    }
                    else
                    {
                            searchTextBoxFocused = false
                            searchFocusIndex = Dimensions.const_AppUserManual_KeyPad_FocusIndex
                            keyPadFocussed = true
                    }
                }
              */
            }
//            if ( focus_index == Dimensions.const_AppUserManual_Focus_SearchBar ) appUserManualSearchBar.showMarker()
//            else appUserManualSearchBar.hideMarker()
        }
    }
}

