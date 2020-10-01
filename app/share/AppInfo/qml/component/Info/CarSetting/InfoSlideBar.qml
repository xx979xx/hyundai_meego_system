import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idSlideBar   
    width: slideWidth; height: 63

    property string imgFolderSettings : imageInfo.imgFolderSettings

    property int slideWidth: 85+284+11+75
    property int maxLevel : 45
    property int minLevel : 0
    property int maxMouseX : 270
    property int minMouseX : 0
    property int levelDivide : 45
    property int levelValue : 25 // defualt value //(maxLevel-minLevel) / 2
    property int levelGap : (maxLevel-minLevel)/levelDivide
    //property int mousePo: 10+(260/(maxLevel-minLevel))*levelValue
    property int mousePo: mousePoGap*levelValue
    property int mousePoGap: maxMouseX/(maxLevel+minLevel)

    signal slideReleased(int levelValue)

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    onVisibleChanged: { if(visible) idSlideBar.focus = true }

    //--------------------- [-] Button
    InfoButton{
        id: btnMinus
        x:0; y:0
        width:75; height:63
        focus: true
        bgImage: imgFolderSettings+"btn_-_n.png"
        bgImagePressed: imgFolderSettings+"btn_-_p.png"

        onClickOrKeySelected: {
            if(mousePo >= minMouseX+mousePoGap && mousePo <= maxMouseX) // 6 < mousePo < 270
            {
                console.log(">>>>>>>>>>>>>>>  btnMinus, 1 < mousePo < 270")
                mousePo = mousePo - mousePoGap
                levelValue = levelValue - levelGap
            }
            else
            {
                if(mousePo <= minMouseX+mousePoGap || levelValue < minLevel ) // mousePo <= 6
                {
                    console.log(">>>>>>>>>>>>>>>  btnMinus, mousePo < 6")
                    mousePo = minMouseX
                    levelValue = minLevel
                } // End if
            } // End if
            console.log("btnMinus_mousePo", mousePo)
            console.log("btnMinus_levelValue", levelValue)
        } // End onClickOrKeySelected
        KeyNavigation.right:btnPlus
    } // End Button

    //--------------------- Bar Image
    Image{
        id : idBarImg
        x:85; y:13
        width:284; height:36
        source: imgFolderSettings+"slider_s_n.png"
        Image{
            x:0; y:0
            //width:mousePo; height:36
            width:mousePo; height:36
            source: imgFolderSettings+"slider_s_s.png"
        } // End Image
        Image{
            id:imgsliderCursor
            x:mousePo; y:-5
            width: 23; height: 46
            source: imgFolderSettings+"slider_cursor.png"
        } // End Image

        MouseArea{
            clip: true
            drag.target: imgsliderCursor; drag.axis: Drag.XAxis
            drag.minimumX: minMouseX; drag.maximumX: maxMouseX
            anchors.fill: parent

            onMousePositionChanged: {
                if(mouseX >= minMouseX && mouseX < maxMouseX)
                {
                    levelValue=(mouseX/mousePoGap)%100
                    mousePo = mouseX
                }
                else
                {
                    if(mouseX < minMouseX || levelValue < minLevel )
                    {
                        mousePo = minMouseX
                        levelValue = minLevel
                    }
                    else if(mouseX > maxMouseX || levelValue < maxLevel )
                    {
                        mousePo = maxMouseX
                        levelValue = maxLevel
                    } // End if
                } // End if
                console.log("BarImg_mousePo", mousePo)
            }
        }
    } // End Image

    //--------------------- [+] Button
    InfoButton{
        id: btnPlus
        x:85+107+188; y:0
        width:75; height:63
        bgImage: imgFolderSettings+"btn_+_n.png"
        bgImagePressed: imgFolderSettings+"btn_+_p.png"

        onClickOrKeySelected: {
            mousePo = mousePo
            if(mousePo >= minMouseX && mousePo < maxMouseX) // 0 < mousePo < 269
            {
                console.log(">>>>>>>>>>>>>>>  btnPlus, 0 < mousePo < 269")
                levelValue = levelValue + levelGap
                mousePo = mousePo + mousePoGap
            }
            else
            {
                if(mousePo >= maxMouseX || levelValue < maxLevel ) // mousePo >= 270
                {
                    console.log(">>>>>>>>>>>>>>>  btnPlus, mousePo >= 270")
                    mousePo = maxMouseX
                    levelValue = maxLevel
                } // End if
            } // End if
            console.log("btnPlus_mousePo", mousePo)
            console.log("btnPlus_levelValue", levelValue)
        } // End onClickOrKeySelected
        KeyNavigation.left: btnMinus
    } // End Button
} // End MComponent

