import QtQuick 1.0

import "../DH" as MComp
import "../../system/DH" as MSystem

Rectangle {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    id:stepArrowBg
    color: colorInfo.transparent
    width: parent.width; height: parent.height

    property int stepLevel: 0
    property string imgFolderSettings : imageInfo.imgFolderSettings
    signal slideReleased(int level)

    Rectangle{
        Image {
            y:0
            id: stepArrowBgImage
            source: imgFolderSettings+"step_arrow_01_n.png"
        }
        Image {
            x:27
            id: stepArrowBgImage2
            source: imgFolderSettings+"step_arrow_02_n.png"
        }
        Image {
            x:27+27
            id: stepArrowBgImage3
            source: imgFolderSettings+"step_arrow_02_n.png"
        }
        Image {
            x:27+27+27
            id: stepArrowBgImage4
            source: imgFolderSettings+"step_arrow_02_n.png"
        }
        Image {
            x:27+27+27+27
            id: stepArrowBgImage5
            source: imgFolderSettings+"step_arrow_02_n.png"
        }
        Image {
            x:27+27+27+27+27
            id: stepArrowBgImage6
            source: imgFolderSettings+"step_arrow_02_n.png"
        }
        Image {
            x:27+27+27+27+27+27
            id: stepArrowBgImage7
            source: imgFolderSettings+"step_arrow_02_n.png"
        }
    }
    Rectangle{
        id:selectArrow
        Image {
            y:0
            id: stepArrowArrowImage
            source: imgFolderSettings+"step_arrow_01_f.png"
            visible: false
        }
        Image {
            x:27
            id: stepArrowArrowImage1
            source: imgFolderSettings+"step_arrow_02_f.png"
            visible: false
        }
        Image {
            x:27+27
            id: stepArrowArrowImage2
            source: imgFolderSettings+"step_arrow_02_f.png"
            visible: false
        }
        Image {
            x:27+27+27
            id: stepArrowArrowImage3
            source: imgFolderSettings+"step_arrow_02_f.png"
            visible: false
        }
        Image {
            x:27+27+27+27
            id: stepArrowArrowImage4
            source: imgFolderSettings+"step_arrow_02_f.png"
            visible: false
        }
        Image {
            x:27+27+27+27+27
            id: stepArrowArrowImage5
            source: imgFolderSettings+"step_arrow_02_f.png"
            visible: false
        }
        Image {
            x:27+27+27+27+27+27
            id: stepArrowArrowImage6
            source: imgFolderSettings+"step_arrow_02_f.png"
            visible: false
        }
    }

    MouseArea {
        anchors.fill: parent
        //drag.target: selectArrow ;
        drag.axis: Drag.XAxis
        drag.minimumX: -24; drag.maximumX: container.width-50
        onClicked: {
            stepLevel = mouse.x
        }

        onPositionChanged: {
            stepLevel = mouse.x/27
            console.log(stepLevel)
            if(stepLevel<="1"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=false
                stepArrowArrowImage2.visible=false
                stepArrowArrowImage3.visible=false
                stepArrowArrowImage4.visible=false
                stepArrowArrowImage5.visible=false
                stepArrowArrowImage6.visible=false
            }
            else if(stepLevel<="2"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=true
                stepArrowArrowImage2.visible=false
                stepArrowArrowImage3.visible=false
                stepArrowArrowImage4.visible=false
                stepArrowArrowImage5.visible=false
                stepArrowArrowImage6.visible=false
            }
            else if(stepLevel<="3"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=true
                stepArrowArrowImage2.visible=true
                stepArrowArrowImage3.visible=false
                stepArrowArrowImage4.visible=false
                stepArrowArrowImage5.visible=false
                stepArrowArrowImage6.visible=false
            }
            else if(stepLevel<="4"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=true
                stepArrowArrowImage2.visible=true
                stepArrowArrowImage3.visible=true
                stepArrowArrowImage4.visible=false
                stepArrowArrowImage5.visible=false
                stepArrowArrowImage6.visible=false
            }
            else if(stepLevel<="5"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=true
                stepArrowArrowImage2.visible=true
                stepArrowArrowImage3.visible=true
                stepArrowArrowImage4.visible=true
                stepArrowArrowImage5.visible=false
                stepArrowArrowImage6.visible=false
            }
            else if(stepLevel<="6"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=true
                stepArrowArrowImage2.visible=true
                stepArrowArrowImage3.visible=true
                stepArrowArrowImage4.visible=true
                stepArrowArrowImage5.visible=true
                stepArrowArrowImage6.visible=false
            }
            else if(stepLevel<="7"){
                stepArrowArrowImage.visible=true
                stepArrowArrowImage1.visible=true
                stepArrowArrowImage2.visible=true
                stepArrowArrowImage3.visible=true
                stepArrowArrowImage4.visible=true
                stepArrowArrowImage5.visible=true
                stepArrowArrowImage6.visible=true
            }
        }
    }
}
