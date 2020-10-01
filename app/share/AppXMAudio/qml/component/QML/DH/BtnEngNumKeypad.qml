import Qt 4.7

import "../../QML/DH" as MComp

FocusScope {
    id:keypad_area

    property string value: ""

    Column {
        spacing: 7
        focus: true

        Row {
            spacing: 4

            MouseArea{
                id: numkeypad_1
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                // direction key
                KeyNavigation.right: num2_btn
                KeyNavigation.down: num4_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        //not used
                        break;
                    case Qt.Key_Equal: //right
                        num2_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num_btn
                    width: 171
                    height: 100
                    focus:true
                    bFocused: num_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_1.onclicked()}
                }
                MComp.BtnNum{setNum: 1}

                function onclicked()
                {
                    value += "1"
                    //onBeep()
                    onChangeValue(value)
                    //numkeypad_1.forceActiveFocus()
                }
            }
            MouseArea{
                id: numkeypad_2
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num_btn
                KeyNavigation.right: num3_btn
                KeyNavigation.down: num5_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num3_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num2_btn
                    width: 171
                    height: 100
                    bFocused: num2_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_2.onclicked()}
                }
                MComp.BtnNum {setNum: 2}

                function onclicked()
                {
                    value += "2"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_3
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num2_btn
                KeyNavigation.right: num4_btn
                KeyNavigation.down: num6_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num2_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num4_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num3_btn
                    width: 171
                    height: 100
                    bFocused: num3_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_3.onclicked()}
                }
                MComp.BtnNum {setNum: 3}

                function onclicked()
                {
                    value += "3"
                    //onBeep()
                    onChangeValue(value)
                }
            }
        }

        Row {
            spacing: 4

            MouseArea{
                id: numkeypad_4
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num3_btn
                KeyNavigation.right: num5_btn
                KeyNavigation.up: num_btn
                KeyNavigation.down: num7_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num3_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num5_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num4_btn
                    width: 171
                    height: 100
                    bFocused: num4_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_4.onclicked()}
                }
                MComp.BtnNum {setNum: 4}

                function onclicked()
                {
                    value += "4"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_5
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num4_btn
                KeyNavigation.right: num6_btn
                KeyNavigation.up: num2_btn
                KeyNavigation.down: num8_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num4_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num6_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num5_btn
                    width: 171
                    height: 100
                    bFocused: num5_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_5.onclicked()}
                }
                MComp.BtnNum {setNum: 5}


                function onclicked()
                {
                    value += "5"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_6
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num5_btn
                KeyNavigation.right: num7_btn
                KeyNavigation.up: num3_btn
                KeyNavigation.down: num9_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num5_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num7_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num6_btn
                    width: 171
                    height: 100
                    bFocused: num6_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_6.onclicked()}
                }
                MComp.BtnNum {setNum: 6}


                function onclicked()
                {
                    value += "6"
                    //onBeep()
                    onChangeValue(value)
                }
            }
        }

        Row {
            spacing: 4

            MouseArea{
                id: numkeypad_7
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                // direction key
                KeyNavigation.left: num6_btn
                KeyNavigation.right: num8_btn
                KeyNavigation.up: num4_btn
                KeyNavigation.down: num_btnl
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num6_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num8_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num7_btn
                    width: 171
                    height: 100
                    bFocused: num7_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_7.onclicked()}
                }
                MComp.BtnNum {setNum: 7}


                function onclicked()
                {
                    value += "7"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_8
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num7_btn
                KeyNavigation.right: num9_btn
                KeyNavigation.up: num5_btn
                KeyNavigation.down: num_btnl
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num7_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num9_btn.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num8_btn
                    width: 171
                    height: 100
                    bFocused: num8_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_8.onclicked()}
                }
                MComp.BtnNum {setNum: 8}


                function onclicked()
                {
                    value += "8"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_9
                width : num_btn.width
                height : num_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num8_btn
                KeyNavigation.right: num_btnl
                KeyNavigation.up: num6_btn
                KeyNavigation.down: num_del
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num8_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num_btnl.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id : num9_btn
                    width: 171
                    height: 100
                    bFocused: num9_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_9.onclicked()}
                }
                MComp.BtnNum {setNum: 9}

                function onclicked()
                {
                    value += "9"
                    //onBeep()
                    onChangeValue(value)
                }
            }
        }

        Row {
            spacing: 4

            MouseArea{
                id: numkeypad_minas
                width : numbar_btn.width
                height : numbar_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num9_btn
                KeyNavigation.right: num_del
                KeyNavigation.up: num7_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num9_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num_del.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBG
                {
                    id: numbar_btn
                    width: 171
                    height: 100
                    bFocused: numbar_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_0.onclicked()}
                }
                //MComp.BtnNum {setNum: 0}
                Text {
                    id: numminas_text
                    width: numbar_btn.width
                    height: numbar_btn.height
                    text:"-"
                    font.pixelSize: 54
                    font.family: systemInfo.font_NewHDR
                    color: colorInfo.brightGrey
                    style: Text.Raised
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                function onclicked()
                {
                    value += "-"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_0
                width : num_btnl.width
                height : num_btnl.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num9_btn
                KeyNavigation.right: num_del
                KeyNavigation.up: num7_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num9_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num_del.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBGL
                {
                    id: num_btnl
                    width: 171
                    height: 100
                    bFocused: num_btnl.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_0.onclicked()}
                }
                MComp.BtnNum {setNum: 0}

                function onclicked()
                {
                    value += "0"
                    //onBeep()
                    onChangeValue(value)
                }
            }
            MouseArea{
                id: numkeypad_Comma
                width : numcomma_btn.width
                height : numcomma_btn.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.left: num9_btn
                KeyNavigation.right: num_del
                KeyNavigation.up: num7_btn
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num9_btn.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        num_del.forceActiveFocus()
                        break;
                    }
                }

                MComp.BtnNumBGL
                {
                    id: numcomma_btn
                    width: 171
                    height: 100
                    bFocused: numcomma_btn.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_0.onclicked()}
                }
                //MComp.BtnNum {setNum: 0}
                Text {
                    id: numcomma_text
                    width: numcomma_btn.width
                    height: numcomma_btn.height
                    text:"."
                    font.pixelSize: 54
                    font.family: systemInfo.font_NewHDR
                    color: colorInfo.brightGrey
                    style: Text.Raised
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                function onclicked()
                {
                    value += "."
                    //onBeep()
                    onChangeValue(value)
                }
            }
        }

        Row {
            MouseArea{
                id: numkeypad_del
                width : num_del.width
                height : num_del.height
                onClicked: onclicked()

                //Keys.forwardTo: keyHandler
                Keys.onReturnPressed: onClicked()
                //direction key
                KeyNavigation.up: num9_btn
                KeyNavigation.left: num_btnl
                //wheel dial
                Keys.onPressed:
                {
                    switch(event.key)
                    {
                    case Qt.Key_Minus: //left
                        num_btnl.forceActiveFocus()
                        break;
                    case Qt.Key_Equal: //right
                        //not used
                        break;
                    }
                }

                MComp.BtnNumDel
                {
                    id: num_del
                    width: 521
                    height: 100
                    bFocused: num_del.activeFocus && showFocus
                    function onEnterKeyRelease(){numkeypad_del.onclicked()}
                }

                function onclicked()
                {
                    value=value.toString().slice(0, -1)
                    //onBeep()
                    onChangeValue(value)
                }
            }
        }
    }

    function resetValue()
    {
        value = ""
    }
}
