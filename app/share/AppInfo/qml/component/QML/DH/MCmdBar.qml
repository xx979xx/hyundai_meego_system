import QtQuick 1.0
import "../../system/DH" as MSystem

FocusScope {
    id: idMCmdBar
    width : systemInfo.lcdWidth
    height: 81
    x:0
    y:639-166

    //1Button Image
    property string firstButtonImg: imgFolderGeneral+"btn_bottom_01_n.png"
    property string firstButtonImgPress: imgFolderGeneral+"btn_bottom_01_p.png"
    property string firstButtonImgFocusPress: imgFolderGeneral+"btn_bottom_01_fp.png"
    property string firstButtonImgFocus: imgFolderGeneral+"btn_bottom_01_f.png"

    //2Button Image
    property string secondButtonImg: imgFolderGeneral+"btn_bottom_02_n.png"
    property string secondButtonImgPress: imgFolderGeneral+"btn_bottom_02_p.png"
    property string secondButtonImgFocusPress: imgFolderGeneral+"btn_bottom_02_fp.png"
    property string secondButtonImgFocus: imgFolderGeneral+"btn_bottom_02_f.png"

    //3Button Image
    property string threeBtnfirstButtonImg: imgFolderGeneral+"btn_bottom_03_n.png"
    property string threeBtnfirstButtonImgPress: imgFolderGeneral+"btn_bottom_03_p.png"
    property string threeBtnfirstButtonImgFocusPress: imgFolderGeneral+"btn_bottom_03_fp.png"
    property string threeBtnfirstButtonImgFocus: imgFolderGeneral+"btn_bottom_03_f.png"

    //4Button Image
    property string threeBtnsecondButtonImg: imgFolderGeneral+"btn_bottom_04_n.png"
    property string threeBtnsecondButtonImgPress: imgFolderGeneral+"btn_bottom_04_p.png"
    property string threeBtnsecondButtonImgFocusPress: imgFolderGeneral+"btn_bottom_04_fp.png"
    property string threeBtnsecondButtonImgFocus: imgFolderGeneral+"btn_bottom_04_f.png"

    //5Button Image
    property string threeBtnthirdButtonImg: imgFolderGeneral+"btn_bottom_05_n.png"
    property string threeBtnthirdButtonImgPress: imgFolderGeneral+"btn_bottom_05_p.png"
    property string threeBtnthirdButtonImgFocusPress: imgFolderGeneral+"btn_bottom_05_fp.png"
    property string threeBtnthirdButtonImgFocus: imgFolderGeneral+"btn_bottom_05_f.png"

    //First Text
    property string firstButtonText:qsTr("Complete")
    property string secondButtonText:qsTr("Cancle")
    property string thirdButtonText: qsTr("Delete")


    property int buttonNum: 2

    signal button0Click()
    signal button1Click()
    signal button2Click()

    //jyjoen_20120227
    property bool button0dimmed: false
    property bool button1dimmed: false
    property bool button2dimmed: false


    function cmdButtonClickEvent(index){
        switch(index){
            case 0:{idMCmdBar.button0Click();break;} // End case
            case 1:{idMCmdBar.button1Click();break;} // End case
            case 2:{idMCmdBar.button2Click();break;} // End case
            } // End case
        }

    //2Button
    Item {
        visible: buttonNum==2
        MButton{
            focus:buttonNum==2
            id:cmdButton1
            x:0
            y:0
            width:640
            height:81
            dimmed: button0dimmed //jyjoen_20120227

            bgImage:firstButtonImg
            bgImagePress: firstButtonImgPress
            bgImageFocusPress: firstButtonImgFocusPress
            bgImageFocus: firstButtonImgFocus

            firstText:firstButtonText
            firstTextWidth: 563
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: "Black"
            firstTextX: 38
            firstTextY: 680-638

            secondText:firstButtonText
            secondTextWidth: 563
            secondTextAlies: "Center"
            secondTextSize: 36
            secondTextColor: colorInfo.buttonGrey
            secondTextFocusPressColor: colorInfo.brightGrey
            secondTextX: 37
            secondTextY: 680-639

            KeyNavigation.right:cmdButton2

            onClickOrKeySelected: {cmdButtonClickEvent(0)}
        }

        MButton{
            id:cmdButton2
            x:640
            y:0
            width:640
            height:81
            dimmed: button1dimmed //jyjoen_20120227

            bgImage:secondButtonImg
            bgImagePress: secondButtonImgPress
            bgImageFocusPress: secondButtonImgFocusPress
            bgImageFocus: secondButtonImgFocus

            firstText:secondButtonText
            firstTextWidth: 563
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: "Black"
            firstTextX: 38
            firstTextY: 680-638

            secondText:secondButtonText
            secondTextWidth: 563
            secondTextAlies: "Center"
            secondTextSize: 36
            secondTextColor: colorInfo.buttonGrey
            secondTextFocusPressColor: colorInfo.brightGrey
            secondTextX: 37
            secondTextY: 680-639
            KeyNavigation.left:cmdButton1

            onClickOrKeySelected: {cmdButtonClickEvent(1)}
        }

    }

    //3Button
    Item {
        visible: buttonNum==3
        MButton{
            focus:buttonNum==3
            id:cmdButton3
            x:0
            y:0
            width:427
            height:81
            dimmed: button0dimmed //jyjoen_20120227

            bgImage:threeBtnfirstButtonImg
            bgImagePress: threeBtnfirstButtonImgPress
            bgImageFocusPress: threeBtnfirstButtonImgFocusPress
            bgImageFocus: threeBtnfirstButtonImgFocus

            firstText:firstButtonText
            firstTextWidth: 350
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: "Black"
            firstTextX: 38
            firstTextY: 680-638

            secondText:firstButtonText
            secondTextWidth: 350
            secondTextAlies: "Center"
            secondTextSize: 36
            secondTextColor: colorInfo.buttonGrey
            secondTextFocusPressColor: colorInfo.brightGrey
            secondTextX: 37
            secondTextY: 680-639

            KeyNavigation.right:cmdButton4

            onClickOrKeySelected: {cmdButtonClickEvent(0)}
        }

        MButton{
            id:cmdButton4
            x:427
            y:0
            width:427
            height:81
            dimmed: button1dimmed //jyjoen_20120227

            bgImage:threeBtnsecondButtonImg
            bgImagePress: threeBtnsecondButtonImgPress
            bgImageFocusPress: threeBtnsecondButtonImgFocusPress
            bgImageFocus: threeBtnsecondButtonImgFocus

            firstText:secondButtonText
            firstTextWidth: 346
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: "Black"
            firstTextX: 38
            firstTextY: 680-638

            secondText:secondButtonText
            secondTextWidth: 346
            secondTextAlies: "Center"
            secondTextSize: 36
            secondTextColor: colorInfo.buttonGrey
            secondTextFocusPressColor: colorInfo.brightGrey
            secondTextX: 37
            secondTextY: 680-639

            KeyNavigation.left:cmdButton3
            KeyNavigation.right:cmdButton5

            onClickOrKeySelected: {cmdButtonClickEvent(1)}
        }

        MButton{
            id:cmdButton5
            x:427+427
            y:0
            width:427
            height:81
            dimmed: button2dimmed //jyjoen_20120227

            bgImage:threeBtnthirdButtonImg
            bgImagePress: threeBtnthirdButtonImgPress
            bgImageFocusPress: threeBtnthirdButtonImgFocusPress
            bgImageFocus: threeBtnthirdButtonImgFocus

            firstText:thirdButtonText
            firstTextWidth: 350
            firstTextAlies: "Center"
            firstTextSize: 36
            firstTextColor: colorInfo.brightGrey
            firstTextFocusPressColor: "Black"
            firstTextX: 38
            firstTextY: 680-638

            secondText:thirdButtonText
            secondTextWidth: 350
            secondTextAlies: "Center"
            secondTextSize: 36
            secondTextColor: colorInfo.buttonGrey
            secondTextFocusPressColor: colorInfo.brightGrey
            secondTextX: 37
            secondTextY: 680-639

            KeyNavigation.left:cmdButton4

            onClickOrKeySelected: {cmdButtonClickEvent(2)}
        }
    }



} // End MComponent
