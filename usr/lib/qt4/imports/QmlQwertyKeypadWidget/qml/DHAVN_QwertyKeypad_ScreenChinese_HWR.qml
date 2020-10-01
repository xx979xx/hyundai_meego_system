import QtQuick 1.1
import qwertyKeypadUtility 1.0
import qwertyKeypadChineseHWRCanvas 1.0

Item{
    id: scrTop
    width:  1280
    height: 554
    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property bool isFocusedBtnLongPressed: false
    property int  nCurrentPage: 0
    property int  nTotalPage: 0

    property bool bEnableResetFocus: true
    /**
      * 후보군이 표시되는 경우(Canvas에서 필기 입력 시, 현재 입력된 글자 다음에 올수 있는 Prediction 표시할 시)
      * Canvas에서 필기 입력을 하였을 경우에만, 후보군 첫 글자를 입력창에 미리 보여지도록 Signal 발생.
      */
    property bool isPredictionMode: false // (false: Normal Candidate Mode) (true: Prediction Mode)

    /**
      *
      * 중국향 키보드에서는 초기 화면 진입 시 retranslateUi() 호출 이후, 현재 입력된 글자 다음에 올 수 있는 Prediction 글자 표시를 위해 App에서
      * searchChinesePrediction() 함수를 호출. 초기 진입 시에는, 입력되어 있는 후보군 글자가 없기 때문에 포커스가 이동 가능한 버튼으로 설정되어 있음.
      * Prediction 글자 후보군이 존재하면, 첫 후보군 문자 버튼으로 포커스 이동하도록 하기 위해 사용됨(진입시에만)
      */
    property bool bInitFocus: false
    property bool focus_visible: false

    /**Private area*/

    Image{
        source: "/app/share/images/Qwertykeypad/bg_chn_keypad.png"

        MouseArea{
            anchors.fill: parent
            beepEnabled: false
        }
    }

    Image{
        x: 712; y: 11
        source: "/app/share/images/Qwertykeypad/bg_chn_character.png"

        MouseArea{
            anchors.fill: parent
            beepEnabled: false
        }
    }

    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )

    function showFocus()
    {
        focus_visible = true
    }

    function hideFocus()
    {
        focus_visible = false
    }

    //added for ITS 229467 for BT Keypad HWR Engine Init Issue
    function initHWREngineForBT()
    {
        console.log("[QML] initHWREngineForBT:: ->")
        hwrCanvas.initBtHWR();
    }

    Binding{
        target: scrTop
        property: "focus_visible"
        value: qwerty_keypad.focus_visible
    }

    Binding{
        target: qwerty_keypad
        property: "isKeypadButtonFocused"
        value: focus_visible
    }

    DHAVN_QwertyKeypad_ModelChineseHWR{
        id: chinese_handwriting_keypad_model
    }

    Item{
        id: column
        anchors.top: parent.top
        anchors.topMargin: 11
        anchors.left : parent.left
        anchors.leftMargin: 712

        Repeater{
            model: chinese_handwriting_keypad_model.keypad
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id; width: btn_width; height: btn_height
                keytext: btn_text
                keycode: btn_keycode
                suffix: btn_suffix
                btnEnabled: btn_Enabled
                transitionIndex: trn_index
                fontSize: btn_fontSize
                x: btnXpos
                y: btnYpos

                textVerticalOffSet: textOffSet
                signal updateButton( string button_text )

                onJogDialSelectPressed: onJogCenterPressed()
                onJogDialSelectLongPressed:
                {
                    //added(modified) for ITS 223849 Beep sound twice issue
                    if(btn_keycode == Qt.Key_Back)
                    {
                        if(isPress)
                        {
                            scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext ) )
                        }

                    }
                    else
                    {
                        scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    }
                    //scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    //added(modified) for ITS 223849 Beep sound twice issue

                }
                onJogDialSelectReleased:
                {
                    onJogCenterReleased()
                }


                onKeytextChanged:
                {
                    if( suffix == "chn_charater_01" ||
                            suffix == "chn_charater_02" ||
                            suffix == "chn_charater_03" ||
                            suffix == "chn_charater_04" ||
                            suffix == "chn_charater_05" ||
                            suffix == "chn_charater_06" ||
                            suffix == "chn_charater_07" ||
                            suffix == "chn_charater_08" ||
                            suffix == "chn_charater_09")
                    {
                        if(keytext == "")
                        {
                            btnEnabled = false
                            fontColor = "#5B5B5B"
                        }
                        else
                        {
                            btnEnabled = true
                            fontColor = "#FAFAFA"
                        }
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    //beepEnabled: btnEnabled
                    beepEnabled: false
                    noClickAfterExited: true
                    onPressed:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonPressed()
                    }
                    onClicked:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonClicked()
                    }
                    onPressAndHold:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        if( !btnEnabled )
                            return;

                        if(btn_keycode == Qt.Key_Back)
                        {
                            //currentFocusIndex = btnid //added for Delete Long Press Spec Modify
                            //prevFocusIndex = currentFocusIndex //added for Delete Long Press Spec Modify

                            scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext) )
                            longPressFlag = true //added for Delete Long Press Spec Modify
                        }
                        else
                            longPressFlag = true
                    }

                    onReleased:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        if (longPressFlag)
                        {
                            onSelectedButtonClicked()
                            longPressFlag = false

                        }

                        onSelectedButtonReleased()
                        //added for ITS 225692 beep issue
                        if(btnEnabled)
                            UIListener.ManualBeep();
                        //added for ITS 225692 beep issue
                    }

                    onExited:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return
                        //added for ITS 245874 delete long key press Issue
                        if(btn_keycode == Qt.Key_Back)
                        {
                            if (longPressFlag)
                            {
                                //console.log("[QML]screenKorean : longPressFlag : ")
                                onSelectedButtonClicked()
                                longPressFlag = false
                            }
                        }
                        //added for ITS 245874 delete long key press Issue
                        longPressFlag = false
                        onSelectedButtonReleased()
                    }
                }

                function onJogCenterPressed()
                {
                    if( !btnEnabled )
                        return;

                    redrawJogCenterPress()
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext) )
                }

                function onJogCenterReleased()
                {
                    if( !btnEnabled )
                        return;
                    //added(modify) for ITS 223743 for < > Focus issue
                    //modified for ITS 228423 < > Focus Issue 03/07
                    if ( btn_id == 20 || btn_id == 21 || btn_keycode == Qt.Key_Back )
                        bEnableResetFocus = false
                    else
                        bEnableResetFocus = true
                    //modified for ITS 228423 < > Focus Issue 03/07
                    //added(modify) for ITS 223743 for < > Focus issue


                    // Prev/Next button
                    if ( btn_id == 20)
                        hwrCanvas.decrementCurrentPage(isPredictionMode)
                    else if(btn_id == 21 )
                        hwrCanvas.incrementCurrentPage(isPredictionMode)

                    redrawJogCenterRelease(false)

                    if(prevFocusIndex != currentFocusIndex)
                        return
                    //modify for HWR input space next show Next Candidate
                    if ( btn_keycode != Qt.Key_Shift )
                    {
                        console.log("[QML]KeypadWidget:HWR: btn_keycode ::  " + btn_keycode);
                        console.log("[QML]KeypadWidget:HWR: btn_id ::  " + btn_id);
                        console.log("[QML]KeypadWidget:HWR: translate.makeWord ::  " + translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext)));
                        console.log("[QML]KeypadWidget:HWR: column.children[0].keytext - " + column.children[0].keytext)
                        console.log("[QML]KeypadWidget:HWR: isPredictionMode - " + isPredictionMode)
                        if(column.children[0].keytext == "")
                            console.log("[QML]KeypadWidget:HWR: column.children[0].keytext == NULL " )
                        else if(column.children[0].keytext != "")
                            console.log("[QML]KeypadWidget:HWR: column.children[0].keytext != NULL " )
                        if(btn_id == 23 && column.children[0].keytext != "")
                        {

                            scrTop.keyReleased( 0x41,
                                               translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[0].keytext)), translate.isComposing() )
                        }
                        else
                        {                            
                            scrTop.keyReleased( btn_keycode,
                                           translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext)), translate.isComposing() )
                        }
                    }
                    //modify for HWR input space next show Next Candidate
                }

                function onSelectedButtonPressed()
                {
                    if( !btnEnabled )
                        return;

                    redrawButtonOnKeyPress()
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext) )
                }

                function onSelectedButtonClicked()
                {
                    console.log("[QML] KeypadWidget:HWR: onSelectedButtonClicked() ------------->");
                    if( !btnEnabled )
                        return;

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    //added(modify) for ITS 223743 for < > Focus issue
                    //modified for ITS 228423 < > Focus Issue 03/07
                    if ( btn_id == 20 || btn_id == 21 || btn_keycode == Qt.Key_Back )
                        bEnableResetFocus = false
                    else
                        bEnableResetFocus = true
                    //modified for ITS 228423 < > Focus Issue 03/07
                    //added(modify) for ITS 223743 for < > Focus issue

                    // Prev/Next button
                    if ( btn_id == 20)
                        hwrCanvas.decrementCurrentPage(isPredictionMode)
                    else if(btn_id == 21 )
                        hwrCanvas.incrementCurrentPage(isPredictionMode)

                    if (btn_keycode == Qt.Key_Launch2)
                        return

                    redrawButtonOnKeyRelease(false)
					//modify for HWR input space next show Next Candidate
                    if ( btn_keycode != Qt.Key_Shift )
                    {
                        console.log("[QML]KeypadWidget:HWR: btn_keycode ::  " + btn_keycode);
                        console.log("[QML]KeypadWidget:HWR: btn_id ::  " + btn_id);
                        console.log("[QML]KeypadWidget:HWR: translate.makeWord ::  " + translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext)));
                        console.log("[QML]KeypadWidget:HWR: column.children[0].keytext - " + column.children[0].keytext)

                        console.log("[QML]KeypadWidget:HWR: isPredictionMode - " + isPredictionMode)

                        if(column.children[0].keytext == "")
                            console.log("[QML]KeypadWidget:HWR: column.children[0].keytext == NULL " )
                        else if(column.children[0].keytext != "")
                            console.log("[QML]KeypadWidget:HWR: column.children[0].keytext != NULL " )

                        if(btn_id == 23 && column.children[0].keytext != "" )
                        {

                            scrTop.keyReleased( 0x41,
                                               translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[0].keytext)), translate.isComposing() )
                        }
                        else
                            scrTop.keyReleased( btn_keycode,
                                           translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext)), translate.isComposing() )
                    }
					//modify for HWR input space next show Next Candidate	
                }

                function onSelectedButtonReleased()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return

                    redrawButtonOnKeyRelease(false)
                }

                Component.onCompleted:
                {
                    if( suffix == "chn_charater_01" ||
                            suffix == "chn_charater_02" ||
                            suffix == "chn_charater_03" ||
                            suffix == "chn_charater_04" ||
                            suffix == "chn_charater_05" ||
                            suffix == "chn_charater_06" ||
                            suffix == "chn_charater_07" ||
                            suffix == "chn_charater_08" ||
                            suffix == "chn_charater_09")
                    {
                        if(keytext == "")
                            btnEnabled = false
                        else
                            btnEnabled = true
                    }

                    if( btn_id == 20 || btn_id == 21 )
                    {
                        btnEnabled = false
                    }
                }
            }
        }
    }

    // HWR Area


    Image{
        id: hwrCanvasBG
        x: 10; y:12
        source: "/app/share/images/Qwertykeypad/bg_chn_inputbox.png"

        Item{
            id: hwrCanvasArea
            x:9; y:6
            width: 677; height: 516

            MouseArea{
                anchors.fill: parent
                beepEnabled: false

                onPressed:
                {

                    //translate.HWRCurrentTime(true);
                    if(isFocusedBtnSelected)
                        return

                    if(enableChineseHWRInput)
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        bEnableResetFocus = true
                        hwrCanvas.sendLastPoint(mouseX, mouseY)
                        hwrCanvas.getDrawingPoints(mouseX, mouseY)
                    }
                }
                onReleased:
                {
                    //translate.HWRCurrentTime(false);
                    if(isFocusedBtnSelected)
                        return

                    if(enableChineseHWRInput)
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        hwrCanvas.drawLineTo(mouseX, mouseY)
                        hwrCanvas.getDrawingPoints(mouseX, mouseY)
                        hwrCanvas.startHWR()
                    }
                    else
                    {
                        enableChineseHWRInput = true
                    }
                }
                onPositionChanged:
                {
                    // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                    if(isFocusedBtnSelected)
                        return

                    if(enableChineseHWRInput)
                    {
                        hwrCanvas.drawLineTo(mouseX, mouseY)
                        hwrCanvas.getDrawingPoints(mouseX, mouseY)
                    }
                }
            }
        }

        QwertyKeypadChineseHWRCanvas{
            id: hwrCanvas
            x: 9
            y: 6
            width: 677
            height: 516

            // Candidate
            onCandidateUpdated:
            {
                if(isPrediction)
                {
                    isPredictionMode = true
                    for (var i = 0;  i < 20; i++)
                    {
                        column.children[i].keytext = hwrCanvas.getCandidate(i)
                        if(column.children[i].keytext == "")
                        {
                            column.children[i].btnEnabled = false
                            column.children[i].fontColor = "#5B5B5B"
                        }
                        else
                        {
                            column.children[i].btnEnabled = true
                            column.children[i].fontColor = "#FAFAFA"
                        }
                    }

                    if(hwrCanvas.getTotalPageSize() >= 0)
                    {
                        if( (hwrCanvas.getTotalPageSize() - 1) <= 0)
                        {
                            nTotalPage = 0
                            column.children[20].btnEnabled = false
                            column.children[21].btnEnabled = false
                        }
                        else
                        {
                            nTotalPage = hwrCanvas.getTotalPageSize() - 1
                            column.children[20].btnEnabled = true
                            column.children[21].btnEnabled = true
                        }
                    }

                    nCurrentPage = hwrCanvas.getCurrentPageNum()
                    updateButton("")

                    // 화면 초기 진입 시, 다음에 올 글자 후보군이 출력될 경우, 첫 번째 후보군으로 포커스.
                    if(!bInitFocus)
                    {
                        if(hwrCanvas.getCandidateSize() > 0)
                        {
                            currentFocusIndex = 0
                        }

                        bInitFocus = true
                    }
                }
                else
                {
                    isPredictionMode = false
                    redrawCandidate(false, 0)

                    // Total Page & Current Page
                    if(hwrCanvas.getTotalPageSize() >= 0)
                    {
                        if( (hwrCanvas.getTotalPageSize() - 1) <= 0)
                        {
                            nTotalPage = 0
                            column.children[20].btnEnabled = false
                            column.children[21].btnEnabled = false
                        }
                        else
                        {
                            nTotalPage = hwrCanvas.getTotalPageSize() - 1
                            column.children[20].btnEnabled = true
                            column.children[21].btnEnabled = true
                        }
                    }

                    nCurrentPage = hwrCanvas.getCurrentPageNum()

                    // Preview(Input Text)
                    qwerty_keypad.previewCandidate(Qt.Key_A, column.children[0].keytext, false)
                }

                if(bEnableResetFocus)
                    currentFocusIndex = getDefaultFocusIndex()
            }

            onVisibleChanged: {
                //console.log("[QML] ScreenChinese_HWR:: onVisibleChanged: " + visible)
                if (visible)
                {
                    hwrCanvas.initHWR()
                    redrawCandidate(true, 0)
                }
                else
                {
                    nTotalPage = 0
                    nCurrentPage = 0
                    hwrCanvas.clearImage()
                    hwrCanvas.deleteCandidate()
                    hwrCanvas.releaseHWR() // added for ITS 224054 HWR Init issue
                }
            }
        }

        Image{
            id: hwrDeleteBtn
            source: "/app/share/images/Qwertykeypad/btn_del_n.png"
            Image{
                id: hwrDeleteBtnPressed
                visible:  false
                source: "/app/share/images/Qwertykeypad/btn_del_p.png"
            }
            anchors.left: hwrCanvasBG.left
            anchors.leftMargin: 23
            anchors.top: hwrCanvasBG.top
            anchors.topMargin: 16

            MouseArea{
                anchors.fill: parent
                onPressed:
                {
                    // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                    if(isFocusedBtnSelected)
                        return

                    hwrDeleteBtnPressed.visible = true
                }
                onReleased:
                {
                    // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                    if(isFocusedBtnSelected)
                        return

                    hwrDeleteBtnPressed.visible = false

                    hwrCanvas.clearImage()
                    bEnableResetFocus = true
                    if(!isPredictionMode)
                    {
                        hwrCanvas.deleteCandidate()
                        redrawCandidate(true, 0)
                        qwerty_keypad.previewCandidate(Qt.Key_A, "", false)
                    }
                    else
                    {
                        currentFocusIndex = getDefaultFocusIndex()
                    }
                }
            }
        }
    }

    /**
      * function searchChinesePrediction(inputWord)
      * 입력창에 입력되어 있는 문자 다음에 올 수 있는 문자를 검색
      */
    function searchChinesePrediction(inputWord)
    {
        if(inputWord == "")
        {
            clearBuffer()

            if(!getIsCurrentItemEnabled())
                currentFocusIndex = getDefaultFocusIndex()

            if(!bInitFocus)
                bInitFocus = true

            return;
        }

        hwrCanvas.getDKBDPrediction(inputWord)
    }

    /**
      * function redrawCandidate(isClear, pageOffset)
      * 버튼의 문자열에 후보군 문자를 입력. isClear에 따라 버튼 문자열 초기화.
      */
    function redrawCandidate(isClear, pageOffset)
    {
        for (var i = 0;  i < 20; i++)
        {
            if(isClear)
            {
                column.children[i].keytext = ""
                column.children[i].btnEnabled = false
                column.children[i].fontColor = "#5B5B5B"
            }
            else
            {
                column.children[i].keytext = hwrCanvas.getCandidate(i + pageOffset)
            }
        }

        updateButton("")
    }

    function getDefaultFocusIndex()
    {
        for(var i=0; i<chinese_handwriting_keypad_model.keypad.length; i++)
        {
            if(column.children[i].btnEnabled)
                return column.children[i].btnid
        }
    }

    function getIsCurrentItemEnabled()
    {
        if( currentFocusIndex >=0 &&
                currentFocusIndex < chinese_handwriting_keypad_model.keypad.length)
        {
            return column.children[currentFocusIndex].btnEnabled
        }
        else
        {
            currentFocusIndex = 0
            return column.children[currentFocusIndex].btnEnabled
        }
    }

    function retranslateUi()
    {
        isChinesePinyinListView = false
        isPredictionMode = false
        bEnableResetFocus = true

        translate.changeLang( "Chinese", 0,  0)

        checkDisableButton()

        updateButton("")

        // 현재 포커스된 버튼이 비활성화 될 경우, 포커스 가능한 버튼으로 포커스 이동.
        if(!getIsCurrentItemEnabled())
        {
            currentFocusIndex = getDefaultFocusIndex()
        }
    }

    function disableButton(nKeycode)
    {
        for(var i=0; i<chinese_handwriting_keypad_model.keypad.length; i++)
        {
            if(nKeycode == column.children[i].keycode
                    || nKeycode == qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ))
            {
                column.children[i].btnEnabled = false
                column.children[i].fontColor = "#5B5B5B"
            }
        }

        updateButton("")

        if(!getIsCurrentItemEnabled())
        {
            currentFocusIndex = getDefaultFocusIndex()
        }
    }

    function enableButton(nKeycode)
    {
        for(var i=0; i<chinese_handwriting_keypad_model.keypad.length; i++)
        {
            if(nKeycode == column.children[i].keycode
                    || nKeycode == qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ))
            {
                column.children[i].btnEnabled = true
                column.children[i].fontColor = "#FAFAFA"
            }
        }

        updateButton("")
    }

    function checkDisableButton()
    {
        var bCheckDisableItem = false

        for(var i=0; i<chinese_handwriting_keypad_model.keypad.length; i++)
        {
            for(var m=0; m< disableList.count; m++)
            {
                if(disableList.get(m).keytext ==
                        (disableList.get(m).keytype == 0 ? qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ) : column.children[i].keycode))
                {
                    bCheckDisableItem = true
                    break
                }
            }

            if(bCheckDisableItem)
            {
                column.children[i].btnEnabled = false
                column.children[i].fontColor = "#5B5B5B"
            }
            else
            {
                if(column.children[i].keytext == ""
                        && ( column.children[i].suffix == "chn_charater_01" ||
                            column.children[i].suffix == "chn_charater_02" ||
                            column.children[i].suffix == "chn_charater_03" ||
                            column.children[i].suffix == "chn_charater_04" ||
                            column.children[i].suffix == "chn_charater_05" ||
                            column.children[i].suffix == "chn_charater_06" ||
                            column.children[i].suffix == "chn_charater_07" ||
                            column.children[i].suffix == "chn_charater_08" ||
                            column.children[i].suffix == "chn_charater_09" ) )
                {
                    column.children[i].btnEnabled = false
                    column.children[i].fontColor = "#5B5B5B"
                }
                else
                {
                    column.children[i].btnEnabled = true
                    column.children[i].fontColor = "#FAFAFA"
                }
            }

            bCheckDisableItem = false
        }

        if(nTotalPage == 0)
        {
            column.children[20].btnEnabled = false
            column.children[21].btnEnabled = false
        }
        else
        {
            column.children[20].btnEnabled = true
            column.children[21].btnEnabled = true
        }
    }

    function getNextItemEnabled(nNextIndex, nDirectionIndex)
    {
        if(column.children[nNextIndex].btnEnabled) // enabled button
            return nNextIndex
        else                                          // disabled button
        {
            if(nNextIndex == column.children[nNextIndex].transitionIndex[nDirectionIndex])
                return currentFocusIndex

            return getNextItemEnabled(column.children[nNextIndex].transitionIndex[nDirectionIndex], nDirectionIndex)
        }
    }

    function clearBuffer()
    {
        nTotalPage = 0
        nCurrentPage = 0

        hwrCanvas.clearImage()
        hwrCanvas.deleteCandidate()
        redrawCandidate(true, 0)
    }

    onNTotalPageChanged:
    {
        if(nTotalPage == 0)
        {
            column.children[20].btnEnabled = false
            column.children[21].btnEnabled = false
        }
        else
        {
            column.children[20].btnEnabled = true
            column.children[21].btnEnabled = true
        }
    }
}
