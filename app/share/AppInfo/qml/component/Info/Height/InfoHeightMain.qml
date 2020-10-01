import Qt 4.7
import "../../Info" as MInfo
import "../../../component/system/DH" as MSystem
import "../../../component/QML/DH" as MComp

MComp.MComponent {
    id: idInfoHeightMain
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    y : -systemInfo.statusBarHeight
    focus: true

    Connections{
        target: uiListener
        onRetranslateUi:{
            LocTrigger.retrigger();
            console.log("InfoStringInfo: onRetranslateUid");
            setText();
//            onAnimation();

        }
    }
    state:idAppMain.lastHeightState

    onStateChanged: {
        console.log("################ onStateChanged ##############");
        setText();
        onAnimation();
    }
    //--------------- Height Info #
    property int lineTextY : stateY+23+43
    property int stateLeftMargin : 316
    property int stateRightMargin : 302
    property int stateTextSize : 55

    property int stateX : 0
    property int stateY : 243-systemInfo.statusBarHeight
    property int stateWidth : 0
    property int stateHeight : 52
    property int imgSmallCarWidth : 131
    property int imgSmallCarHeight : stateHeight
    property int imgSmallArrowWidth : 75
    property int imgSmallArrowHeight : stateHeight
    property int txtStateWidth : 125 //txtHeightState.paintedWidth
    property int txtStateHeight : stateHeight
    property string txtLastStateHeight : ""

    function setText(){
        switch(idInfoHeightMain.state)
        {
        case "NormalStop" :
        case "NormalLowering" :
        case "NormalLifting" :
            txtHeightState.text = stringInfo.strAutoCareHeightNormal
            break;
        case "HighStop" :
        case "HighLifting" :
            txtHeightState.text = stringInfo.strAutoCareHeightHigh
            break;
        case "LowStop" :
        case "LowLowering" :
            txtHeightState.text = stringInfo.strAutoCareHeightLow
            break;
        case "@Error" :
            txtHeightState.text = "Error"
            break;
        default :
            txtHeightState.text = stringInfo.strAutoCareHeightNormal
            break;
        }
        setTextStateWidth()
    }

    function setTextStateWidth(){
        txtStateWidth = txtHeightState.paintedWidth
        //console.debug(" # [InfoHeightMain] txtStateWidth :", txtStateWidth)
        stateWidth = imgSmallCarWidth+imgSmallArrowWidth+txtStateWidth
        //console.debug(" # [InfoHeightMain] stateWidth :", stateWidth)
        setStateX()
    }

    function setStateX(){
        stateX = (systemInfo.lcdWidth-stateWidth)/2
        //console.debug(" # [InfoHeightMain] stateX :", stateX)
    }

    function onAnimation(){
        txtHeightState.visible=true;
        aniHeight.running=true;
    }



    Component.onCompleted: {
        console.debug(" # [InfoHeightMain][onCompleted] lastHeightState : " + idAppMain.lastHeightState )
        console.debug(" # [InfoHeightMain][onCompleted] InfoHeightMain.state : " + idInfoHeightMain.state)
        uiListener.autoTest_athenaSendObject();
        setText()
        aniHeight.running=false
    }

    onActiveFocusChanged:{ console.debug(" # [InfoHeightMain][onActiveFocusChanged] activeFocus :" + idInfoHeightMain.activeFocus) }

//    //--------------- Timer #
//    Timer {
//        id: idHeightMainTimer
//        interval: 5000
//        onTriggered: { uiListener.HandleBackPreviousState() }
//        onRunningChanged: { console.log(" # [InfoDrivingMain][HeightMainTimer] Start # ") }
//    }

    //--------------- Background Image #
    Image {
        y: -systemInfo.statusBarHeight
        source: imgFolderGeneral+"bg_5.png"
    } // End Image

    Image {
        y:464 // 557- systemInfo.titleAreaHeight//+systemInfo.statusBarHeight)
        height:  systemInfo.lcdHeight - 557
        source: imgFolderInfo+"info_bg.png"
    } // End Image
    //--------------- Small Car Image #
    Image {
        id: imgSmallCar
        x: stateX; y: stateY
        width: imgSmallCarWidth; height: imgSmallCarHeight
        source: imgFolderInfo + "car_height.png"
    } // End Image

    //--------------- Small Arrow Image(Low) #
    Image {
        id: imgSmallArrowLow
        x: stateX+imgSmallCarWidth; y: stateY
        width: imgSmallArrowWidth; height: imgSmallArrowHeight
        source: imgFolderInfo + "info_arrow_d.png"
        opacity: 1
        SequentialAnimation{
            id: aniSmallArrowLow
            running: false
            loops: Animation.Infinite
            NumberAnimation { target: imgSmallArrowLow; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgSmallArrowLow; property: "opacity"; to: 1.0; duration: 500 }
        }
    } // End Image

    //--------------- Small Arrow Image(Normal) #
    Image {
        id: imgSmallArrowNormal
        x: stateX+imgSmallCarWidth; y: stateY
        width: imgSmallArrowWidth; height: imgSmallArrowHeight
        source: imgFolderInfo + "info_arrow_n.png"
        opacity: 1
        SequentialAnimation{
            id: aniSmallArrowNormal
            running: true
            loops: Animation.Infinite
            NumberAnimation { target: imgSmallArrowNormal; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgSmallArrowNormal; property: "opacity"; to: 1.0; duration: 500 }
        }
    } // End Image

    //--------------- Small Arrow Image(High) #
    Image {
        id: imgSmallArrowHigh
        x: stateX+imgSmallCarWidth; y: stateY
        width: imgSmallArrowWidth; height: imgSmallArrowHeight
        source: imgFolderInfo + "info_arrow_u.png"
        opacity: 1
        SequentialAnimation{
            id: aniSmallArrowHigh
            running: false
            loops: Animation.Infinite
            NumberAnimation { target: imgSmallArrowHigh; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgSmallArrowHigh; property: "opacity"; to: 1.0; duration: 500 }
        }
    } // End Image

    //--------------- State Text #
    Text{
        id: txtHeightState
        x: stateX+imgSmallCarWidth + imgSmallArrowWidth; y: stateY
        width: txtStateWidth; height: txtStateHeight
        text: "Normal"
        font.pixelSize: stateTextSize
        font.family: "HDB"
        color: colorInfo.brightGrey

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        opacity: 1
        SequentialAnimation{
            id: aniHeight
            running: false
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: txtHeightState; property: "opacity"; to: 1.0; duration: 500 }
        }
    } // End Text


/*
    //--------------- Line Image #
    Image{
        id: imgHeight
        source: imgFolderInfo + "line.png"
        //x: stateLeftMargin
        y: lineTextY
        height: 2
        width: 662
        anchors.horizontalCenter: parent.horizontalCenter
    } // End Image
*/
    //--------------- Big Car Image #
    Image {
        id : imgBigCar
        x: imgBigCarX; y: imgBigCarY
        height: 348
        width: 876
        source: imgBigCarSource
    } // End Image

    //--------------- InfoHeight Band #
    InfoHeightBand{ id: idInfoHeightBand }

    onBackKeyPressed: {
        console.log(" # [InfoHeightMain] Back")
        gotoBackScreen()
    }



    states: [
        State {
            name: 'NormalStop';
            PropertyChanges { target: imgSmallArrowLow; visible: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: true; opacity: 1.0 }
            PropertyChanges { target: aniSmallArrowNormal; running: false }
            PropertyChanges { target: imgSmallArrowHigh; visible: false }
            PropertyChanges { target: aniHeight; running: true }
        },
        State {
            name: 'HighStop';
            PropertyChanges { target: imgSmallArrowLow; visible: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: false }
            PropertyChanges { target: imgSmallArrowHigh;  visible: true; opacity: 1.0  }
            PropertyChanges { target: aniSmallArrowHigh; running: false }
            PropertyChanges { target: aniHeight; running: true }
        },
        State {
            name: 'LowStop';
            PropertyChanges { target: imgSmallArrowLow;  visible: true; opacity: 1.0  }
            PropertyChanges { target: aniSmallArrowLow; running: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: false }
            PropertyChanges { target: imgSmallArrowHigh; visible: false }
            PropertyChanges { target: aniHeight; running: true }
        },

        State {
            name: 'NormalLowering'; // Hight -> Normal
            PropertyChanges { target: imgSmallArrowLow; visible: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: true }
            PropertyChanges { target: aniSmallArrowNormal; running: true }
            PropertyChanges { target: imgSmallArrowHigh; visible: false }
            PropertyChanges { target: aniHeight; running: true }
        },
        State {
            name: 'NormalLifting'; // Low -> Normal
            PropertyChanges { target: imgSmallArrowLow; visible: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: true }
            PropertyChanges { target: aniSmallArrowNormal; running: true }
            PropertyChanges { target: imgSmallArrowHigh; visible: false }
            PropertyChanges { target: aniHeight; running: true }
        },

        State {
            name: 'HighLifting'; // To High
            PropertyChanges { target: imgSmallArrowLow; visible: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: false}
            PropertyChanges { target: imgSmallArrowHigh; visible: true }
            PropertyChanges { target: aniSmallArrowHigh; running: true }
            PropertyChanges { target: aniHeight; running: true }
        },
        State {
            name: 'LowLowering'; // To Low
            PropertyChanges { target: imgSmallArrowLow; visible: true }
            PropertyChanges { target: aniSmallArrowLow; running: true }
            PropertyChanges { target: imgSmallArrowNormal; visible: false }
            PropertyChanges { target: imgSmallArrowHigh; visible: false }
            PropertyChanges { target: aniHeight; running: true }
        },

        State {
            name: 'init';
            PropertyChanges { target: imgSmallArrowLow; visible: false }
            PropertyChanges { target: imgSmallArrowNormal; visible: false }
            PropertyChanges { target: imgSmallArrowHigh; visible: false }
            PropertyChanges { target: aniHeight; running: true }
        }
    ] // End states
} // End FocusScope

