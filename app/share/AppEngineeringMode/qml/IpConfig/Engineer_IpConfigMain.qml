import Qt 4.7

import com.engineer.data 1.0


import "../Component" as MComp
import "../System" as MSystem

MComp.MComponent
{
    id: root

    width: 1280
    height: 720
    clip:true
    focus: true
    y:0
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MComp.MBand{
        y:parent.y
        titleText: qsTr("Engineering Mode > IP Config")
        onBackKeyClicked: {
            mainViewState="Main"
            setMainAppScreen("", true)
            mainViewState = "AutoTest"
            setMainAppScreen("AutoTest", false)
        }
    }
    onBackKeyPressed: {
        mainViewState="Main"
        setMainAppScreen("", true)
        mainViewState = "AutoTest"
        setMainAppScreen("AutoTest", false)
    }
    Connections{
        target:UIListener
        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {

                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                  //  idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }


        }
    }
    property string newIP: ""
    property string netmask: ""
    property string gateway: ""

    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderBt_phone : imageInfo.imgFolderBt_phone

    signal click(variant num)

    function trim(value) {
        return value.replace(/\s/g,'');
    }

    onClick: {
        if( ipitem.button1.activeFocus || ipitem.button2.activeFocus || ipitem.button3.activeFocus || ipitem.button4.activeFocus )
            ipitem.buttonClick(num)
        else if( netmaskitem.button1.activeFocus || netmaskitem.button2.activeFocus || netmaskitem.button3.activeFocus || netmaskitem.button4.activeFocus )
            netmaskitem.buttonClick(num)
        else if( gatewayitem.button1.activeFocus || gatewayitem.button2.activeFocus || gatewayitem.button3.activeFocus || gatewayitem.button4.activeFocus )
            gatewayitem.buttonClick(num)
    }

    Row {
        x: 30
        spacing : 80
        FocusScope {
            width: 550
            height: columnItem.height

            focus: true

            Component.onCompleted: {
                ipitem.focus1 = true

                    UIListener.autoTest_athenaSendObject();

            }

            Column {
                id: columnItem
                y: 187-90
                spacing : 2

                Text {
                    text: "IP address"
                    font.pixelSize: 36;
                    font.family:UIListener.getFont(false)//"HDR"
                    color:  "#FAFAFA"
                    height: 36
                }

                Engineer_IpConfig_Item
                {
                    id: ipitem

                    Connections {
                        target: ipitem.button4
                        onTextItemChanged: {
                            if( ipitem.button4.textItem.length == 3 )
                            {
                                netmaskitem.focus1 = true
                            }
                        }
                    }

                    onButtonClick: {
                        button1.focus = true
                        if( num != "bt" )
                        {
                            if( button1.activeFocus == true ) {
                                if( button1.textItem.length != 3 )
                                    button1.textItem += num }
                            else if( button2.activeFocus == true ) {
                                if( button2.textItem.length != 3 )
                                    button2.textItem += num }
                            else if( button3.activeFocus == true ) {
                                if( button3.textItem.length != 3 )
                                    button3.textItem += num }
                            else if( button4.activeFocus == true ) {
                                if( button4.textItem.length != 3 )
                                    button4.textItem += num }
                        }
                        else
                        {
                            if( button1.activeFocus == true )
                            {
                                if( button1.textItem.length == 0 );
                                else
                                    button1.textItem = button1.textItem.substring(0, button1.textItem.length-1)
                            }
                            else if( button2.activeFocus == true )
                            {
                                if( button2.textItem.length == 0 )
                                {
                                    button1.textItem = button1.textItem.substring(0, button1.textItem.length-1)
                                    focus1 = true
                                }
                                else
                                    button2.textItem = button2.textItem.substring(0, button2.textItem.length-1)
                            }
                            else if( button3.activeFocus == true )
                            {
                                if( button3.textItem.length == 0 )
                                {
                                    button2.textItem = button2.textItem.substring(0, button2.textItem.length-1)
                                    focus2 = true
                                }
                                else
                                    button3.textItem = button3.textItem.substring(0, button3.textItem.length-1)
                            }
                            else if( button4.activeFocus == true )
                            {
                                if( button4.textItem.length == 0 )
                                {
                                    button3.textItem = button3.textItem.substring(0, button3.textItem.length-1)
                                    focus3 = true
                                }
                                else
                                    button4.textItem = button4.textItem.substring(0, button4.textItem.length-1)
                            }
                        }
                    }
                }

                Text {
                    text: "Net Mask"
                    font.pixelSize: 36;
                    font.family: UIListener.getFont(false)//"HDR"
                    color:  "#FAFAFA"
                }

                Engineer_IpConfig_Item
                {
                    id: netmaskitem

                    Connections {
                        target: netmaskitem.button4
                        onTextItemChanged: {
                            if( netmaskitem.button4.textItem.length == 3 )
                            {
                                gatewayitem.focus1 = true
                            }
                        }
                    }

                    onButtonClick: {
                        if( num != "bt" )
                        {
                            if( button1.activeFocus == true ) {
                                if( button1.textItem.length != 3 )
                                    button1.textItem += num }
                            else if( button2.activeFocus == true ) {
                                if( button2.textItem.length != 3 )
                                    button2.textItem += num }
                            else if( button3.activeFocus == true ) {
                                if( button3.textItem.length != 3 )
                                    button3.textItem += num }
                            else if( button4.activeFocus == true ) {
                                if( button4.textItem.length != 3 )
                                    button4.textItem += num }
                        }
                        else
                        {
                            if( button1.activeFocus == true )
                            {
                                if( button1.textItem.length == 0 )
                                {
                                    console.log("clicked!!!!!!!!!!!!!!!!!!!!!!")
                                    ipitem.button4.textItem = ipitem.button4.textItem.substring(0, ipitem.button4.textItem.length-1)
                                    ipitem.focus4 = true
                                }
                                else
                                    button1.textItem = button1.textItem.substring(0, button1.textItem.length-1)
                            }
                            else if( button2.activeFocus == true )
                            {
                                if( button2.textItem.length == 0 )
                                {
                                    button1.textItem = button1.textItem.substring(0, button1.textItem.length-1)
                                    focus1 = true
                                }
                                else
                                    button2.textItem = button2.textItem.substring(0, button2.textItem.length-1)
                            }
                            else if( button3.activeFocus == true )
                            {
                                if( button3.textItem.length == 0 )
                                {
                                    button2.textItem = button2.textItem.substring(0, button2.textItem.length-1)
                                    focus2 = true
                                }
                                else
                                    button3.textItem = button3.textItem.substring(0, button3.textItem.length-1)
                            }
                            else if( button4.activeFocus == true )
                            {
                                if( button4.textItem.length == 0 )
                                {
                                    button3.textItem = button3.textItem.substring(0, button3.textItem.length-1)
                                    focus3 = true
                                }
                                else
                                    button4.textItem = button4.textItem.substring(0, button4.textItem.length-1)
                            }
                        }
                    }
                }

                Text {
                    text: "Gateway"
                    font.pixelSize: 36;
                    font.family: UIListener.getFont(false) //"HDR"
                    color:  "#FAFAFA"
                }

                Engineer_IpConfig_Item
                {
                    id: gatewayitem

                    Connections {
                        target: gatewayitem.button4
                        onTextItemChanged: {
                            if( gatewayitem.button4.textItem.length == 3 )
                            {
                                gatewayitem.button4.state = "cursor3"
                            }
                        }
                    }

                    onButtonClick: {
                        if( num != "bt" )
                        {
                            if( button1.activeFocus == true ) {
                                if( button1.textItem.length != 3 )
                                    button1.textItem += num }
                            else if( button2.activeFocus == true ) {
                                if( button2.textItem.length != 3 )
                                    button2.textItem += num }
                            else if( button3.activeFocus == true ) {
                                if( button3.textItem.length != 3 )
                                    button3.textItem += num }
                            else if( button4.activeFocus == true ) {
                                if( button4.textItem.length != 3 )
                                    button4.textItem += num }
                        }
                        else
                        {
                            if( button1.activeFocus == true )
                            {
                                if( button1.textItem.length == 0 )
                                {
                                    //root.current--;
                                    netmaskitem.button4.textItem = netmaskitem.button4.textItem.substring(0, netmaskitem.button4.textItem.length-1)
                                    //                                    netmaskitem.focus = true
                                    netmaskitem.focus4 = true
                                }
                                else
                                    button1.textItem = button1.textItem.substring(0, button1.textItem.length-1)
                            }
                            else if( button2.activeFocus == true )
                            {
                                if( button2.textItem.length == 0 )
                                {
                                    button1.textItem = button1.textItem.substring(0, button1.textItem.length-1)
                                    focus1 = true
                                }
                                else
                                    button2.textItem = button2.textItem.substring(0, button2.textItem.length-1)
                            }
                            else if( button3.activeFocus == true )
                            {
                                if( button3.textItem.length == 0 )
                                {
                                    button2.textItem = button2.textItem.substring(0, button2.textItem.length-1)
                                    focus2 = true
                                }
                                else
                                    button3.textItem = button3.textItem.substring(0, button3.textItem.length-1)
                            }
                            else if( button4.activeFocus == true )
                            {
                                if( button4.textItem.length == 0 )
                                {
                                    button3.textItem = button3.textItem.substring(0, button3.textItem.length-1)
                                    focus3 = true
                                }
                                else
                                    button4.textItem = button4.textItem.substring(0, button4.textItem.length-1)
                            }
                        }
                    }
                }
            }
        }

        Column {
            y: 187-90
            spacing: 10

            Text {
                width: 640
                height: 36
                text: "Enter the new IP address."
                font.pixelSize: 36;
                font.family: UIListener.getFont(false)//"HDR"
                color:  "#FAFAFA"
            }

            MComp.KeyPad {
                id: system_change_password
                width: 640
                height: 335 //lcd height - statusbar height
                color:"transparent"
            }

            Row {
                width: 640
                spacing: 4
                MComp.PINKeyPadButton {
                    width:189; height:80
                    bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                    MComp.Label{
                        text: "Set IP."
                        fontName: "HDR"
                        fontSize: 36
                        txtAlign: "Center"
                        fontColor: colorInfo.brightGrey
                    }

                    onClicked: {
                        newIP = trim(ipitem.button1.textItem) + "." + trim(ipitem.button2.textItem) + "." + trim(ipitem.button3.textItem) + "." + trim(ipitem.button4.textItem)
                        netmask = trim(netmaskitem.button1.textItem) + "." + trim(netmaskitem.button2.textItem) + "." + trim(netmaskitem.button3.textItem) + "." + trim(netmaskitem.button4.textItem)
                        gateway = trim(gatewayitem.button1.textItem) + "." + trim(gatewayitem.button2.textItem) + "." + trim(gatewayitem.button3.textItem) + "." + trim(gatewayitem.button4.textItem)
                        console.log(newIP+"\n"+netmask+"\n"+gateway)

                        IPInfo.handleSetIP(newIP, netmask, gateway);

                    } // End if
                } // End PINKeyPadButton
                MComp.PINKeyPadButton {
                    width:189; height:80
                    bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                    MComp.Label{
                        text: "Get IP."
                        fontName: "HDR"
                        fontSize: 36
                        txtAlign: "Center"
                        fontColor: colorInfo.brightGrey
                    }

                    onClicked: {
                        IPInfo.getIP()
                    }

                    Connections {
                        target: IPInfo

                        onSignalGetIP : {
                            ipitem.button1.textItem = ip1; ipitem.button2.textItem = ip2; ipitem.button3.textItem = ip3; ipitem.button4.textItem = ip4;
                        }

                        onSignalGetMask : {
                            netmaskitem.button1.textItem = mask1; netmaskitem.button2.textItem = mask2; netmaskitem.button3.textItem = mask3; netmaskitem.button4.textItem = mask4;
                        }

                        onSignalGetRoute : {
                            gatewayitem.button1.textItem = route1; gatewayitem.button2.textItem = route2; gatewayitem.button3.textItem = route3; gatewayitem.button4.textItem = route4;
                        }
                    }

                } // End PINKeyPadButtonIPInfo

                MComp.PINKeyPadButton {
                    width:189; height:80
                    bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                    MComp.Label{
                        text: "ConsoleOff"
                        fontName: "HDR"
                        fontSize: 36
                        txtAlign: "Center"
                        fontColor: colorInfo.brightGrey
                    }

                    onClicked: {
                        IPInfo.handleExecuteScriptOff();
                    }

                } // End PINKeyPadButtonIPInfo


            }
        }
    }
}


