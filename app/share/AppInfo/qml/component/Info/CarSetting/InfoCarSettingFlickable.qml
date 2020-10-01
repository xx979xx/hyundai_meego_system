import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp
import "../../Info" as MInfo
import "../../Info/CarSetting" as MCarSetting

FocusScope {
    id: idInfoCarSettingFlickable
    x: 0; y: 0
    width:systemInfo.lcdWidth; height:systemInfo.lcdHeight
    focus: true
    //width: 500; height: systemInfo.lcdHeight-110

    property int aqsLevel : idSliderBar.levelValue
    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string imgFolderAutocare : imageInfo.imgFolderAutocare

    MCarSetting.InfoCarSettingModel{id:idCarSettingModel}
    MCarSetting.InfoCarSettingDoorUnlock{id:idDoorUnlockModel}

    Item {
        x:0; y:5
        width:systemInfo.lcdWidth; height:66

        Flickable {
            id:flickTop
            y:80
            width: systemInfo.lcdWidth; height: systemInfo.lcdHeight-170
            contentHeight: systemInfo.lcdHeight+systemInfo.lcdHeight/2
            clip: true

            //--------------- Lock Door Auto #
            Item{
                x:0
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:8
                    text: stringInfo.strSettingAutoLock
                    color: colorInfo.brightGrey
                    font { family: "HDR"; pixelSize: 40}
                } // End Text
                Text {
                    x:41; y:38-20+38
                    text: "Door information"
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                } // End Text
                InfoSpinControl{
                    x:653; y:30-12
                    spinnerModel: idCarSettingModel

                    onSelectedItemNameChanged: {
                        console.log("Lock Door Auto : ", selectedItemName)
                        if(selectedItemName==0){ // Off
                            //canMethod.lockDoorAuto(1)
			    lockDoorAuto(1)
                        }else if(selectedItemName==1){ // On
                            //canMethod.lockDoorAuto(2)
			    lockDoorAuto(2)
                        }else if(selectedItemName==2){ // Mission Level Connect
                            //canMethod.lockDoorAuto(3)
			    lockDoorAuto(3)
                        } //End if
                    } // End onSelectedItemNameChanged
                } // End Spinner
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item
            //--------------- UnLock Door Auto #
            Item{
                x:0; y:107+3
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:38-20
                    text: stringInfo.strSettingUnLock
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 40}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                InfoSpinControl{
                    x:653; y:30-12
                    spinnerModel: idCarSettingModel

                    onSelectedItemNameChanged: {
                        console.log("UnLock Door Auto : ", selectedItemName)
                        if(selectedItemName==0){
                            //canMethod.unlockDoorAuto(1)
			    unlockDoorAuto(1)
                        }else if(selectedItemName==1){
                            //canMethod.unlockDoorAuto(2)
			    unlockDoorAuto(2)
                        }else if(selectedItemName==2){
                            //canMethod.unlockDoorAuto(3)
			    unlockDoorAuto(3)
                        } //End if
                    } // End onSelectedItemNameChanged
                } // End Spinner
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item
            //--------------- Door lock sound #
            Item{
                x:0; y:(107+3)*2                
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:38-20
                    text: stringInfo.strSettingAutoSound
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 40}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                InfoSwitchButton{
                    id: btnswitch2
                    x:995; y:18
                    width: 262
                    focusImg:imgFolderAutocare + "bg_info_spin_ctrl_f.png"
                    bgImage:imgFolderAutocare + "bg_info_switch.png"
                    bgImageToggle:imgFolderAutocare + "info_switch.png"

                    onStateChanged: {
                        console.log("btnswitch2_state : ",btnswitch2.state)
                        if(btnswitch2.state=="Off"){
                            canMethod.doorLockSound(1)
                        }else if(btnswitch2.state=="On"){
                            canMethod.doorLockSound(2)
                        } // End if
                    } // End onStateChanged
                }
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item
            //--------------- Riding seat interlock #
            Item{
                x:0; y:(107+3)*3
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:18
                    text: stringInfo.strSettingSeatConnect
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 40}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                InfoSwitchButton{
                    id: btnswitch3
                    x:995; y:18
                    width: 262
                    focusImg:imgFolderAutocare + "bg_info_spin_ctrl_f.png"
                    bgImage:imgFolderAutocare + "bg_info_switch.png"
                    bgImageToggle:imgFolderAutocare + "info_switch.png"

                    onStateChanged: {
                        console.log("btnswitch3_state : ",btnswitch3.state)
                        if(btnswitch3.state=="Off"){
                            canMethod.ridingSeatInterlock(1)
                        }else if(btnswitch3.state=="On"){
                            canMethod.ridingSeatInterlock(2)
                        } // End if
                    } // End onStateChanged
                }
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item
            //--------------- Riding handle interlock #
            Item{
                x:0; y:(107+3)*4
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:18
                    text: stringInfo.strSettingHandleConnect
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 40}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                InfoSwitchButton{
                    id: btnswitch4
                    x:995; y:18
                    width: 262
                    focusImg:imgFolderAutocare + "bg_info_spin_ctrl_f.png"
                    bgImage:imgFolderAutocare + "bg_info_switch.png"
                    bgImageToggle:imgFolderAutocare + "info_switch.png"

                    onStateChanged: {
                        console.log("btnswitch4_state : ",btnswitch4.state)
                        if(btnswitch4.state=="Off"){
                            canMethod.ridingHandleInterlock(1)
                        }else if(btnswitch4.state=="On"){
                            canMethod.ridingHandleInterlock(2)
                        } // End if
                    } // End onStateChanged
                }
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item
            //--------------- Turn lamp auto 3 times #
            Item{
                x:0; y:(107+3)*5
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:18
                    text: stringInfo.strSettingLampAuto
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 40}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                InfoSwitchButton{
                    id: btnswitch5
                    x:995; y:18
                    width: 262
                    focusImg:imgFolderAutocare + "bg_info_spin_ctrl_f.png"
                    bgImage:imgFolderAutocare + "bg_info_switch.png"
                    bgImageToggle:imgFolderAutocare + "info_switch.png"

                    onStateChanged: {
                        console.log("btnswitch5_state : ",btnswitch5.state)
                        if(btnswitch5.state=="Off"){
                            canMethod.turnLampAuto3Times(1)
                        }else if(btnswitch5.state=="On"){
                            canMethod.turnLampAuto3Times(2)
                        } // End if
                    } // End onStateChanged
                }
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item
            //--------------- Smart night view warning #
            Item{
                x:0; y:(107+3)*6
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:18
                    text: stringInfo.strSettingView
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 40}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                InfoSwitchButton{
                    id: btnswitch6
                    x:995; y:18
                    width: 262
                    focusImg:imgFolderAutocare + "bg_info_spin_ctrl_f.png"
                    bgImage:imgFolderAutocare + "bg_info_switch.png"
                    bgImageToggle:imgFolderAutocare + "info_switch.png"

                    onStateChanged: {
                        console.log("btnswitch6_state : ",btnswitch6.state)
                        if(btnswitch6.state=="Off"){
                            canMethod.smartNightViewWarning(1)
                        }else if(btnswitch6.state=="On"){
                            canMethod.smartNightViewWarning(2)
                        } // End if
                    }
                }
                //--------------- Line Image #
                Image {
                    y:107
                    height: 3
                    source: imgFolderAutocare + "line_info.png"
                } // End Image
            } // End Item

            //////////////////////////////////////// Need to Set function
            //--------------- AQS level setting #
            Item{
                x:0; y:(107+3)*7
                width: systemInfo.lcdWidth; height: 107
                Text {
                    x:41; y:18
                    text: stringInfo.strSettingAQS
                    opacity : 1
                    color: colorInfo.white
                    font { family: "HDR"; pixelSize: 38}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Text {
                    x:41; y:38+18+8
                    text: "Door information"
                    opacity : 1
                    color: colorInfo.dimmedGrey
                    font { family: "HDR"; pixelSize: 24}
                    anchors {
                        //left: preset_mode_list_icon2.right;
                        leftMargin: 15
                    }
                } // End Text
                Item{
                    x:39+700; y:18
                    width: 53+11+85+107+188+75; height:63
                    Item{
                        width: 53; height:63
                        Text{
                            text:aqsLevel
                            font.family: "HDR"
                            font.pixelSize: 40
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: colorInfo.brightGrey
                        } // End Text
                    } // End Item

                    //--------------------- Slide Bar #
                    InfoSlideBar{
                        id: idSliderBar
                        x:64; y:0
                        slideWidth:85+284
                        //focus: true
                        maxLevel: 5
                        minLevel: 0
                        levelDivide: 5
                        levelGap: 1
                        levelValue : 3

                        onClickOrKeySelected:{
                            console.log("SlideBar_mousePo", mousePo)
                            aqsLevel = levelValue
                        }

                        onSlideReleased: {
                            aqsLevel = levelValue
                        }
                    } // End InfoSlideBar
                } // End Item
                Text {
                    x:41; y:25+38+29+8
                    text: stringInfo.strSettingMsg1
                    font.pixelSize: 22
                    color:colorInfo.dimmedGrey
                    font.bold: true
                } // End Text
                Text {
                    x:41; y:25+38+29+29+8
                    text: stringInfo.strSettingMsg2
                    font.pixelSize: 22
                    color:colorInfo.dimmedGrey
                    font.bold: true
                } // End Text
            } // End Item
        } // End Flickable
    } // End Item
} // MComp.MComponent
