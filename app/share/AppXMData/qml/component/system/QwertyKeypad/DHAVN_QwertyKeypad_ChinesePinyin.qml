import Qt 4.7
import ChinesePinyin 1.0

Item
{
    signal keySelect( string text )

    x: 7
    width: 1263

    ChinesePinyin  {
        id: pinyinModel
    }

    Image{
        source : translate.getResourcePath() + "keypad/bg_chn_key.png"
        Text{
            id: inputText
            x:5
            color: "gray"
            text: ""
            font.pixelSize: 50
            anchors.horizontalCenter: parent.horizontalCenter
        }
        width: (inputText.width)? inputText.width+20 : 0
    //    width: inputText.text.length * 84
    }

    Image{
        y: 79
        source : translate.getResourcePath() + "keypad/bg_spin_ctrl.png"
        ListView {
            id: selectionList
            anchors.fill: parent
            anchors.leftMargin: 92
            anchors.rightMargin: 92
            currentIndex : -1
            highlightMoveDuration : 1

            model: pinyinModel

            delegate: Item{
                height:  81
                width: (size <= 1) ? 98 : candiateText.width+10
                Text {
                    anchors.centerIn: parent
                    id: candiateText
                    text: name
                    font.pixelSize: 50
                    color: "gray"
                }
                Image {
                    visible: index ? 1: 0
                    anchors.left: parent.left
                    source: translate.getResourcePath() + "keypad/bg_spin_ctrl_divider.png"
                }
                MouseArea
                {
                    anchors.fill: parent
                    onPressed:{
                        if(size){
                            selectionList.currentIndex = index
                        }
                    }
                    onReleased: {
                        if(size){
                            selectionList.currentIndex = -1
                            keySelect(name)
                            inputText.text = ""
                            pinyinModel.setKeyWord(inputText.text)
                        }
                    }
                }
            }
            highlight:Item{
                Image{
                    x:4
                    width:  parent.width -4
                    visible : true
                    source: translate.getResourcePath() + "keypad/bg_spin_ctrl_s.png"
                }
            }

            clip: true
            orientation:"Horizontal"
        }
        Image {
            source: translate.getResourcePath() + "keypad/btn_arrow_l_n.png"
            Image{
                id: pressImageL
                visible:  false
                source: translate.getResourcePath() + "keypad/btn_arrow_l_p.png"
            }
            MouseArea
            {
                anchors.fill: parent
                onPressed: pressImageL.visible = true
                onCanceled: pressImageL.visible = false
                onReleased: {
                    pressImageL.visible = false
                    selectionList.decrementCurrentIndex()
                }
            }
        }

        Image {
           anchors.right: parent.right
           source: translate.getResourcePath() + "keypad/btn_arrow_r_n.png"
           Image{
               id: pressImageR
               visible:  false
               source: translate.getResourcePath() + "keypad/btn_arrow_r_p.png"
           }
           MouseArea
           {
               anchors.fill: parent
               onPressed: pressImageR.visible = true
               onCanceled: pressImageR.visible = false
               onReleased: {
                   pressImageR.visible = false
                   if(selectionList.currentIndex+1 <  pinyinModel.getCount())
                       selectionList.incrementCurrentIndex()
               }
           }
        }
    }

    function handleKey(keyCode, keyText)
    {
        if( keyCode == Qt.Key_Space )
            return false

        if ( keyCode < 0x01000000 ){
            inputText.text += keyText[0]
            pinyinModel.setKeyWord(inputText.text)
            selectionList.currentIndex = (pinyinModel.getCount()) ? 0 : -1
            return true
        }

        if(keyCode == Qt.Key_Back){
            var nPos = inputText.text.length;

            if(nPos <= 0)
                return false
            nPos--

            inputText.text = inputText.text.substring( 0,nPos )
            pinyinModel.setKeyWord(inputText.text)
            selectionList.currentIndex = (pinyinModel.getCount()) ? 0 : -1
            return true
        }
        return false
    }

    function update(keyType)
    {
        selectionList.currentIndex = -1
        inputText.text = ""
        pinyinModel.setKeyWord("")
        pinyinModel.setKeypadType(keyType)
    }
}
