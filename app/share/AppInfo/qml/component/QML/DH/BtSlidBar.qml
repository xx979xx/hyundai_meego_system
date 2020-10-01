import QtQuick 1.0

FocusScope {
    id: idSlideBar

    width: 87+132+139+145+77; height: 63

    property int mousePo:(slidWidth/levelDivide)*levelValue
    property int slidWidth: 390
    property int maxLevel : 5
    property int minLevel : 0
    property int levelDivide : 5
    property int levelValue : (maxLevel-minLevel) / 2
    property int levelGap : (maxLevel-minLevel)/levelDivide

    signal slideReleased(int levelValue)

    //**************************************** [-] Button
    Button{
        id:btnVolLeft
        x:0; y:0
        width:75; height:63
        focus: true
        bgImage: imgFolderBt_phone+"btn_calling_-_n.png"
        bgImagePressed: imgFolderBt_phone+"btn_calling_-_p.png"
        bgImageFocused: imgFolderBt_phone+"bg_calling_vol_f.png"
        onClickOrKeySelected: {
            if(levelValue>minLevel){
                levelValue=levelValue-1
                mousePo=(slidWidth/levelDivide)*levelValue
                micvolumelevel.text=levelValue
            }
        }
        KeyNavigation.right: btnVolRight
    }
    //**************************************** Bar Image
    Image{
        id:imgsliderCursor
        x:85; y:24
        width:407; height:16
        source: imgFolderBt_phone+"slider_n.png"
        Image{
            x:0; y:0
            width:mousePo+7; height:16
            source: imgFolderBt_phone+"slider_s.png"
        }
        Image{
            id:imgsliderCursorlevelGap
            x:mousePo-7; y:-8
            width: 34; height: 34
            source: imgFolderBt_phone+"slider_cursor.png"
        }

        MouseArea{
            clip: true
            drag.target: imgsliderCursorlevelGap; drag.axis: Drag.XAxis
            drag.minimumX: 0; drag.maximumX: 390
            anchors.fill: parent

            onReleased: {
                if(mouseX<=400&&mouseX>=0){
                    mousePo=mouse.x
                    levelValue=mousePo/(slidWidth/levelDivide)
                    console.log("levelValue : " + levelValue)
                    console.log(mouse.x)
                    mousePo=(slidWidth/levelDivide)*levelValue
                    micvolumelevel.text=levelValue
                }
                else if(mouseX>400){
//                    mousePo=(slidWidth/levelDivide)*maxLevel
//                    levelValue=maxLevel
                    //levelValue=mousePo/(slidWidth/levelDivide)
                }
                else if(mouseX<0){
//                    mousePo=(slidWidth/levelDivide)*minLevel
//                    levelValue=minLevel
                    //levelValue=mousePo/(slidWidth/levelDivide)
                }
            }
//            onMousePositionChanged: {
//                if(mouseX<=395&&mouseX>=0){
//                    mousePo=mouse.x
//                    levelValue=mousePo/(slidWidth/levelDivide)
//                    mousePo=(slidWidth/levelDivide)*levelValue
//                    micvolumelevel.text=levelValue
//                    console.log("mousePo : "+mousePo)
//                    console.log("mouse.x : "+mouse.x)
//                }
//                else if(mouseX>395){
//                    mousePo=(slidWidth/levelDivide)*maxLevel
//                    levelValue=maxLevel
//                }
//                else if(mouseX<0){
//                    mousePo=(slidWidth/levelDivide)*minLevel
//                    levelValue=minLevel
//                }
//            }
        }
    }
    //**************************************** [+] Button
    Button{
        id:btnVolRight
        x:87+132+139+145; y:0
        width:75; height:63
        bgImage: imgFolderBt_phone+"btn_calling_+_n.png"
        bgImagePressed: imgFolderBt_phone+"btn_calling_+_p.png"
        bgImageFocused: imgFolderBt_phone+"bg_calling_vol_f.png"
        onClickOrKeySelected: {
            if(levelValue<maxLevel){
                levelValue=levelValue+1
                mousePo=(slidWidth/levelDivide)*levelValue
                micvolumelevel.text=levelValue
            }
        }
        KeyNavigation.left: btnVolLeft
    }

    onLevelValueChanged: {
        BtCoreCtrl.setMicVolume(levelValue)
    }
}
