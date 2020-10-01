import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idSXMRadioEngListGPS
    x: 0; y:0
    width: systemInfo.lcdWidth; height: 550

    property real fLatitude
    property real fLongitude
    property string m_sSettingEmulatorOnOff : (UIListener.HandleGetEmulatorFileExist() == true) ? "on" : "off"

    // Device Location Text
    Text {
        id: idSXMRadioEngTitle
        x:50; y:5+18-(font.pixelSize/2)
        width:systemInfo.lcdWidth/2; height: 50
        text: "[  Device Location  ]"
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    // Latitude Text
    Text {
        id: idSXMRadioEngLatitude
        x:50; y:5+idSXMRadioEngTitle.height+10+18-(font.pixelSize/2)
        width:(systemInfo.lcdWidth/2)/3; height: 50
        text: "Latitude"
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    TextEdit {
        id: idSXMRadioEngLatitudeEdit
        x:idSXMRadioEngLatitude.x+idSXMRadioEngLatitude.width; y:5+idSXMRadioEngTitle.height+10
        width:(systemInfo.lcdWidth/2)*2/3; height: 50
        text: selectNumLat
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        cursorVisible: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selectEdit = "Latitude"
                if (idSXMRadioEngLatitudeEdit.cursorVisible == false && selectEdit == "Latitude") {
                    idSXMRadioEngLatitudeEdit.cursorVisible = true
                    idSXMRadioEngLongitudeEdit.cursorVisible = false
                    xm_engineeringlist_keypad.resetValue()
                    selectNumLat = ""
                }
            }
        }
        Image {
            x:-15; y:-2
            width:(systemInfo.lcdWidth/2)*2/3 + 15; height: 50
            source: imageInfo.imgFolderRadio_SXM + "focus_649_r.png"
        }
    }

    // Longitude Text
    Text {
        id: idSXMRadioEngLongitude
        x:50; y:5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10+18-(font.pixelSize/2)
        width:(systemInfo.lcdWidth/2)/3; height: 50
        text: "Longitude"
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    TextEdit {
        id: idSXMRadioEngLongitudeEdit
        x:idSXMRadioEngLongitude.x+idSXMRadioEngLongitude.width; y:5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10
        width:(systemInfo.lcdWidth/2)*2/3; height: 50
        text: selectNumLon
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        cursorVisible: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selectEdit = "Longitude"
                if (idSXMRadioEngLongitudeEdit.cursorVisible == false && selectEdit == "Longitude") {
                    idSXMRadioEngLatitudeEdit.cursorVisible = false
                    idSXMRadioEngLongitudeEdit.cursorVisible = true
                    xm_engineeringlist_keypad.resetValue()
                    selectNumLon = ""
                }
            }
        }
        Image {
            x:-15; y:-2
            width:(systemInfo.lcdWidth/2)*2/3 + 15; height: 50
            source: imageInfo.imgFolderRadio_SXM + "focus_649_r.png"
        }
    }

    // Adjust Location Button
    MComp.MButton{
        id: idSXMRadioEngAdjust
        x: 50; y: 5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10+idSXMRadioEngLongitude.height+30
        width: systemInfo.lcdWidth/2; height: 50
        focus: true
        visible: true
        buttonWidth: systemInfo.lcdWidth/2
        buttonHeight: 50
        bgImage: imageInfo.imgFolderSettings+"btn_screen_off_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_screen_off_p.png"
        bgImageFocusPress: imageInfo.imgFolderSettings+"btn_screen_off_fp.png"
        bgImageFocus: imageInfo.imgFolderSettings+"btn_screen_off_f.png"
        onClickOrKeySelected: {
            console.log("Adjust Location Button Clicked Latitude:"+idSXMRadioEngLatitudeEdit.text+" Longitude:"+idSXMRadioEngLongitudeEdit.text)
            fLatitude = idSXMRadioEngLatitudeEdit.text
            fLongitude = idSXMRadioEngLongitudeEdit.text

            UIListener.HandleEngSetDevLocation(fLatitude.toFixed(6), fLongitude.toFixed(6))
        }

        firstText: "Adjust Engineer Location"
        firstTextX: 5; firstTextY: 35
        firstTextWidth: systemInfo.lcdWidth/2
        firstTextSize: 32
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.subTextGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.subTextGrey
    }

    // Automatic Button
    MComp.MButton{
        id: idSXMRadioEngContextBtn
        x: 50; y: 5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10+idSXMRadioEngLongitude.height+10+idSXMRadioEngAdjust.height+50
        width: systemInfo.lcdWidth/2; height: 50
        focus: true
        visible: true
        buttonWidth: systemInfo.lcdWidth/2
        buttonHeight: 50
        bgImage: imageInfo.imgFolderSettings+"btn_screen_off_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_screen_off_p.png"
        bgImageFocusPress: imageInfo.imgFolderSettings+"btn_screen_off_fp.png"
        bgImageFocus: imageInfo.imgFolderSettings+"btn_screen_off_f.png"
        onClickOrKeySelected: {
            console.log("Automatic Button Clicked")

            UIListener.HandleEngSetDevLocation(0, 0)
        }

        firstText: "Stop Engineer Location Mode"
        firstTextX: 5; firstTextY: 35
        firstTextWidth: systemInfo.lcdWidth/2
        firstTextSize: 32
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.subTextGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.subTextGrey
    }

    // Emulator Text
    Text {
        id: idSXMRadioEngEmulator
        x:50
        y:5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10+idSXMRadioEngLongitude.height+10+idSXMRadioEngAdjust.height+50+100+18-(font.pixelSize/2)
        width:systemInfo.lcdWidth/2; height: 50
        text: "[  Emulator  ]"
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    // Emulator On/Off Text
    Text {
        id: idSXMRadioEngEmulatorOnOff
        x:50
        y:5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10+idSXMRadioEngLongitude.height+10+idSXMRadioEngAdjust.height+50+100+60+18-(font.pixelSize/2)
        width:(systemInfo.lcdWidth/2)/3; height: 50
        text: "Emulator On/Off"
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        color: colorInfo.brightGrey
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    // Emulator Switch Button
    MComp.SettingsSwitchButton {
        id:idSXMRadioEngSwitchButton
        x: 50+400
        y: 5+idSXMRadioEngTitle.height+10+idSXMRadioEngLatitude.height+10+idSXMRadioEngLongitude.height+10+idSXMRadioEngAdjust.height+50+100+50
        focus:true
        fontSize : 36
        textfontHeight : 66
        imgWidthOffset : 0
        imgHeightOffset: 0
        textYPostion : 123
        state: m_sSettingEmulatorOnOff
        knobX:1 ; knobY: -1
        onStateChanged: {
            console.log("Emulator Switch Button State: "+state)
            if(state == "on")
                UIListener.HandleSetEmulatorFileExist(true)
            else
                UIListener.HandleSetEmulatorFileExist(false)
        }
    }
}
