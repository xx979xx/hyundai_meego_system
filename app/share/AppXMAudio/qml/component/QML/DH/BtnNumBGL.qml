import Qt 4.7

FocusScope {
    width: 258
    height: 123
    property bool bFocused : false
    property bool keyPressed : false

    property string imgMouseN       : imageInfo.imgFolderRadio_SXM + "btn_num_l_n.png"
    property string imgMouseP       : imageInfo.imgFolderRadio_SXM + "btn_num_l_p.png"
    property string imgMouseF       : imageInfo.imgFolderRadio_SXM + "bg_num_l_f.png"

    Image {
        id: background
        source: imgMouseN
        anchors.fill: parent
        smooth: true
    }

    Image {
        x: -12; y: -12
        source: imgMouseF
        smooth: true
        visible: bFocused
    }

    onKeyPressedChanged:
    {
        if(keyPressed) background.source = imgMouseP;
        else background.source = imgMouseN;
    }

    Keys.onPressed:
    {
        if(event.key == Qt.Key_Return)
           keyPressed = true
    }

    Keys.onReleased:
    {
        if(event.key == Qt.Key_Return)
        {
            keyPressed = false
            onEnterKeyRelease()
        }
    }

    states: [
        State {
            name: 'pressed'; when: parent.pressed
            PropertyChanges {target: background; source: imgMouseP}
        }
    ]
}
