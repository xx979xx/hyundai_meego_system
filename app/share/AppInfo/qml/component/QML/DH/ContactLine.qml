import Qt 4.7

import "../../system/DH" as MSystem
//import "../../../component/BT" as MBt

MComponent{
    id : container
    width: systemInfo.lcdWidth
    height: 82

    //---------------# Label
    property string text : "NOT SET"
    property string fontName : "HDR"
    property int fontSize : 40
    property int fontX : 39
    property int fontY : 40
    //---------------# Input Box
    property string inputText : ""
    property string bgImageFocused: imgFolderBt_phone+"inputbox_new_f.png"

    //--------------- Label
    Text{
        id:bgTxt
        x:fontX; y:fontY-(fontSize/2)-11
        width: 172; height: inputBox.height

        text: container.text
        color: colorInfo.brightGrey
        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        //anchors.horizontalCenter: bgTxt.horizontalCenter
        anchors.verticalCenter: Text.verticalCenter
    } // End Text

    //--------------- Input Box
    Button{
        id: inputBox
        x:39*2+bgTxt.width; y:0
        width:642; height:82
        focus: true
        bgImage:imgFolderBt_phone+"bg_edit_inputbox.png"
        bgImagePressed: imgFolderBt_phone+"bg_edit_inputbox.png"
        text: inputText
        txtAlign:"Left"
        fontName: "HDR"
        fontSize: 54
        fontColor: "Black"
        fontColorPressed: "Black"
        fontX:0
        fontColorShadow: colorInfo.brightGrey
        Button{
            id: btnX
            x: 577; y:13
            width: 53; height: 54
            bgImage: imgFolderBt_phone+"btn_x_n.png"
            bgImagePressed: imgFolderBt_phone+"btn_x_n.png"
            onClickOrKeySelected:{
                if(inputText!=""){
                    inputText=""
                } // End if
                console.log("# ContactLine X#")
            }
        }
        onClickOrKeySelected:{
            setMainAppScreen("BtContactADMain",false)
//            selectInfo=container.text
//            idQwertyKeypad.showQwertyKeypad();
        }
        KeyNavigation.right:btnShortCut.visible=="false"?inputBox:btnShortCut
    }

    //--------------- ShortCut Button
    Button{ // ButtonFont(L) HDB, 40
        id: btnShortCut
        x: bgTxt.width+93+inputBox.width
        y:0
        width:172; height:inputBox.height
        text:stringInfo.strQmlContactLine
        fontSize: 37
        visible: if(container.inputText!=""&&container.text!=stringInfo.strQmlContactName){true}
                 else{false}
        bgImage:imgFolderBt_phone+"btn_edit_n.png"
        bgImagePressed:imgFolderBt_phone+"btn_edit_p.png"

        onClickOrKeySelected: {
            setMainAppScreen("BtShortCutMain",true)
        } // End onClicked
        KeyNavigation.right:btnDelegate
        KeyNavigation.left:inputBox
    } // End Button

    //--------------- Delegate Button
    Button{
        id: btnDelegate
        width:172; height:inputBox.height
        x: bgTxt.width+93+inputBox.width+btnShortCut.width+4
        text:stringInfo.strQmlContactDelegte
        fontSize: 37//40
        //fontName: "HDBa1"
        visible: {
            if(container.inputText!=""&&container.text!=stringInfo.strQmlContactName){true}
            else{false}
        }
        bgImage:imgFolderBt_phone+"btn_edit_n.png"
        bgImagePressed:imgFolderBt_phone+"btn_edit_p.png"

        onClickOrKeySelected: {
            console.log("# ContactLine Delegate #")
        } // End onClicked
        KeyNavigation.left: btnShortCut
    } // End Button
} // End FocusScope
