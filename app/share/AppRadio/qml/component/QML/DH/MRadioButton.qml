/**
 * FileName: MRadioButton.qml
 * Author: WSH
 * Time: 2012-03-09
 *
 * - 2012-03-13 Modified by WSH
 */
import QtQuick 1.0

MComponent {
    id: container
    x: iconX; y: iconY
    width: 45; height: 45

    //--------------------- SelectedIndex Info(Property) ##
    property int selectedIndex: 0

    //--------------------- Active Info(Property) ##
    property bool active: false

    //--------------------- Icon Info(Property) ##
    property int iconX: 0
    property int iconY: 0
    property string bgImage: imgFolderGeneral + "ico_radio_n.png"
    property string bgImageSelected: imgFolderGeneral + "ico_radio_s.png"
    property string imgFillMode: Image.TileHorizontally

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //-------------------- View the background
    Image {
        id: imgRadioBtn
        source: bgImage
        fillMode: imgFillMode
        anchors.fill: parent
        smooth: true
    } // End Image

    //KSW 140613 delete MouseArea
//    //KSW 131212 [211424][ITS]
//    MouseArea {
//        id:mouseArea
//        anchors.fill: parent
//        property bool isExited : false
//        onPressAndHold: {
//            //console.log("#### onPressAndHold mEnabled ="+mEnabled +"pressCancel = "+pressCancel);
//            pressAndHoldFlag = true
//            if(!mEnabled || pressCancel) return;
//            container.pressAndHold(container.target, container.buttonName);
//            idAppMain.returnToTouchMode();
//        }
//        onReleased: {
//            //console.log("#### mouseArea.containsMouse ="+mouseArea.containsMouse +" isExited = "+isExited);
//            if((mouseArea.containsMouse == true) && (!isExited)){
//                pressAndHoldFlag    = false;
//                if(!mEnabled || pressCancel) return;
//                container.clicked(container.target, container.buttonName);
//                playBeepOn = true;     // JSH 130404
//                //console.log("############################  touch - 1before signal");
//                idAppMain.enterType = 0;
//                clickOrKeySelected(0);
//                //console.log("############################  touch - 1after signal");
//            }
//            clickReleased();
//        }
//        onMousePositionChanged: {
//            //console.log("############################  touch - onMousePositionChanged????? mEnabled" + mEnabled);
//            if(!mEnabled || pressCancel){
//                //console.log("[CHECK_11_14_DRAG] : Mouse pressCanceled " + pressCancel );
//                return;
//            }
//            ////
//            mousePosChanged(mouseX,mouseY); // JSH 121121
//        }
//        onPressed: { //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
//            idAppMain.returnToTouchMode(); // JSH 130624
//            //console.log("############################  touch - 1onPressed????? ");
//            pressedForFlickable(mouseX,mouseY);
//            isExited            = false; // JSH 130717
//            pressAndHoldFlag    = false;
//            pressCancel         = false; // JSH 130906
//        }
//        onExited: {
//            //console.debug("############################  touch - 1onExited?????")
//            if(!mouseArea.pressed)
//                return;

//            isExited = true ;
//            cancel();
//        }
//        onCanceled :{
//            //console.debug("1onCanceled ???");
//            cancel();
//        }

//    }

    //-------------------- Click Event
    onClickOrKeySelected:{
        console.debug("------ [MRadioButton] [onClickOrKeySelected] ")
        selectedIndex = index;
        if(playBeepOn && container.state!="disabled")
        {
            idAppMain.playBeep(); //KSW 131227-1 add code
            //UIListener.writeToLogFile("playBeep MRadioButton1");
        }

    }

    states: [
        State {
            name: "on"; when: container.active
            PropertyChanges { target: imgRadioBtn; source: bgImageSelected }
        },
        State {
            name: "off"; when: !(idRadioButton.active)
            PropertyChanges { target: imgRadioBtn; source: bgImage }
        }
    ]
} // End MComponent
