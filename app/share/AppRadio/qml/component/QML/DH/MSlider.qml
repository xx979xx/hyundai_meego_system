import Qt 4.7

import "../../system/DH" as MSystem


FocusScope {
    id: idMSlider

    //Button Info
    property int btnWidth: 69
    property int btnHeight: 58
    property int rightButtonX: 4+76+225

    //Left Image
    property string imgLeftButton:imgFolderSettings+"btn_-_n.png"
    property string imgLeftButtonPress:imgFolderSettings+"btn_-_p.png"
    property string imgLeftButtonFocus:imgFolderSettings+"btn_-_f.png"
    property string imgLeftButtonFocusPress:imgFolderSettings+"btn_-_fp.png"

    //Right Image
    property string imgRightButton:imgFolderSettings+"btn_+_n.png"
    property string imgRightButtonPress:imgFolderSettings+"btn_+_p.png"
    property string imgRightButtonFocus:imgFolderSettings+"btn_+_f.png"
    property string imgRightButtonFocusPress:imgFolderSettings+"btn_+_fp.png"

    //Slider Image
    property int sliderX:4+76
    property int sliderY:9+18
    property string imgSliderBG:imgFolderSettings+"slider_n.png"
    property string imgSliderFG:imgFolderSettings+"slider_s.png"

    //Point Image
    property string imgPointer:imgFolderSettings+"slider_pointer_s.png"
    property int pointHeight: 42
    property int pointWidth: 41

    //Point position
    property int pointValue: 0
    property int sliderWidth: 217
    property int sliderHeight: 58

    property int sliderDivision: 10

    property int pointGap: (sliderWidth-41)/sliderDivision

    signal leftButtonClick()
    signal rightButtonClick()

    MButton{
        x:0
        y:0
        id:btnSliderLeft
        focus:true
        width:btnWidth
        height:btnHeight
        bgImage: imgLeftButton
        bgImagePress: imgLeftButtonPress
        bgImageFocus: imgLeftButtonFocus
        bgImageFocusPress: imgLeftButtonFocusPress
        onClickOrKeySelected: {
            if(pointValue<=0){}
            else{leftButtonClick();pointValue=pointValue-1;}
        }
        KeyNavigation.right:btnSliderRight
    }

    Image{
        id:sliderBG
        x:sliderX
        y:sliderY
        source: imgSliderBG

        MouseArea{
            height: sliderHeight
            width: sliderWidth
            x:0
            y:-(sliderBG.y)
            onClicked:{
                if(mouseX<(pointValue-2)*pointGap){pointValue=0}
                else if(mouseX>pointGap*sliderDivision){pointValue=sliderDivision}
                else{pointValue=(mouseX-(pointGap/2))/pointGap}
            }
            onPositionChanged: {
                if(mouseX<0){pointValue=0}
                else if(mouseX>pointGap*sliderDivision){}
                else{pointValue=(mouseX-(pointGap/2))/pointGap}
            }
        }
        BorderImage {
            source: imgSliderFG
            anchors.left: sliderBG.left
            anchors.right:pointer.horizontalCenter
        }
        Image {
            id:pointer
            y:-(pointHeight/2)+3
            x:pointGap*pointValue
            source: imgPointer
        }
    }

    MButton{
        id:btnSliderRight
        width:btnWidth
        height:btnHeight
        x:rightButtonX
        bgImage: imgRightButton
        bgImagePress: imgRightButtonPress
        bgImageFocus: imgRightButtonFocus
        bgImageFocusPress: imgRightButtonFocusPress
        onClickOrKeySelected: {
            if(pointValue>=sliderDivision){}
            else{pointValue=pointValue+1;rightButtonClick()}
        }
        KeyNavigation.left:btnSliderLeft
    }
}
