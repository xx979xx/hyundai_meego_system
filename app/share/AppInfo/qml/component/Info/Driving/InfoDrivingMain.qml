import Qt 4.7
import "../../Info" as MInfo
import "../../../component/system/DH" as MSystem
import "../../../component/QML/DH" as MComp
import "InfoDrivingMain_constant.js" as CONST

MComp.MComponent {
    id: idInfoDrivingMain
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
        y : -systemInfo.statusBarHeight
    focus: true

    Keys.onPressed:{
        switch( event.key )
        {
            case Qt.Key_Left :
            case Qt.Key_Right :
            case Qt.Key_Up :
            case Qt.Key_Down :
            case Qt.Key_Minus:
            case Qt.Key_Equal:
            {
//                focusVisible=true;
//                 console.log("Keys.onPressed in DrivingMode");
//                id_topButton_f.visible=true;
                id_topButton_rect.forceActiveFocus()
                event.accepted=true;
            }break;
            case Qt.Key_Enter :
            case Qt.Key_Return:
            {
                focusVisible=true;
                 console.log("Key_Return : focusVisible=true");
                id_topButton_f.visible=true
                id_topButton_fp.visible=true
                event.accepted=true;
            }break;
        }
    }//onPressed
    Keys.onReleased:{
        switch( event.key )
        {
            case Qt.Key_Enter :
            case Qt.Key_Return:
            {
                if(focusVisible==true){
                    id_topButton_fp.visible=false
                }
                event.accepted=true;
                uiListener.handleBackKey()
//                gotoBackScreen()
            }break;
            case Qt.Key_Left :
            case Qt.Key_Right :
            case Qt.Key_Up :
            case Qt.Key_Down :
            case Qt.Key_Minus:
            case Qt.Key_Equal:
            {
                console.log("Keys.onReleased in DrivingMode");
                focusVisible=true;
                 console.log("Keys.onPressed in DrivingMode");
                id_topButton_f.visible=true;
                id_topButton_rect.forceActiveFocus()
                event.accepted=true;
            }break;

        }
    }//onReleased
    Connections{
        target: uiListener
        onRetranslateUi:{
            LocTrigger.retrigger();
            console.log("InfoStringInfo: onRetranslateUid");
            setText();
        }
        onRequestFG:{
            if(uiListener.getTopApp()!=1)
                return;
            console.log("DrivingInfo FG");
            focusVisible=false
            id_topButton_f.visible=false
            //                ENTRY_BLACK_SCREEN =0,
            //                ENTRY_DRIVING_MODE =1,
            //                ENTRY_CLIMATE_MODE =2
            if( uiListener.getTopApp() != 0)
                uiListener.clearOSD();
        }
//        onDisplayBlack:{
//            console.log("onDisplayBlack")
//            stateBlackScreen = true;
//            uiListener.setBlackScreenMode(true)
//            if( id_osd_timer.running == true){
//                console.log("OSD Timer restart!!!!")
//                id_osd_timer.restart()
//            }
//            else{
//                console.log("OSD Timer start!!!!")
//                id_osd_timer.start()
//            }
//        }
//        onHideBlack:{
//            console.log("onHideBlack")
//            stateBlackScreen = false;
//            uiListener.setBlackScreenMode(false)
//        }

    } // End Connections
    onStateChanged: {
        console.debug(" # [InfoDrivingMain][onStateChanged] canDB.C_DrivingModeState : " + canDB.C_DrivingModeState )
        console.debug(" # [InfoDrivingMain][onStateChanged] InfoDrivingMain.state : " + idInfoDrivingMain.state)
        setText();
    }
//    Timer {
//        id: id_osd_timer
//        interval: 5000
//        repeat: false
//        onTriggered:
//        {
//            console.log(" # OSD 5 sec Timer expired  # ");
//            uiListener.requestDrivingModeBG();
//            uiListener.setBlackScreenMode(false)
//            stateBlackScreen = false;
//        }
//    }
    //--------------- Driving Info #
    property int lineTextY : stateY+23+43
    property int stateLeftMargin : 316
    property int stateTextSize : 38

    property int stateX : 0
    property int stateY : 243-systemInfo.statusBarHeight
    property int stateWidth : txtStateWidth
    property int stateHeight : stateTextSize-3
    property int txtStateWidth : 876 //txtDrivingState.paintedWidth
    property int txtStateHeight : stateHeight
    property string initialState: ""
    property string drivingStateStore: ""
    property bool focusVisible:false
    property bool stateBlackScreen:false
    property int countryVariant: -1


    function setText(){
        switch(idInfoDrivingMain.state)
        {
        case "Normal" :
            txtDrivingState.text = stringInfo.strAutoCareDrivingNormal+" : "+stringInfo.strAutoCareDrivingNormalMsg
            break;
        case "Sports" :
            txtDrivingState.text = stringInfo.strAutoCareDrivingSports+" : "+stringInfo.strAutoCareDrivingSportsMsg
            break;
        case "ECO" :
            txtDrivingState.text = stringInfo.strAutoCareDrivingECO+" : "+stringInfo.strAutoCareDrivingECOMsg
            break;
        case "Snow" :
            txtDrivingState.text = stringInfo.strAutoCareDrivingSnow+" : "+stringInfo.strAutoCareDrivingSnowMsg
            break;
        default :
            txtDrivingState.text = stringInfo.strAutoCareDrivingNormal+" : "+stringInfo.strAutoCareDrivingNormalMsg
            break;
        }
        setTextStateWidth()
    }

    function setTextStateWidth(){
        txtStateWidth = txtDrivingState.paintedWidth
        //console.debug(" # [InfoDrivingMain] txtStateWidth : ", txtStateWidth)
        setStateX()
    }

    function setStateX(){
        stateX = (systemInfo.lcdWidth-stateWidth)/2
        //console.debug(" # [InfoDrivingMain] stateX : ", stateX)
    }



//    state: lastDrivingState
    state: drivingMode
  //    {
//        if(canDB.C_DrivingModeState=="1"){ "Normal" }
//        else if(canDB.C_DrivingModeState=="2"){ "Sports" }
//        else if(canDB.C_DrivingModeState=="3"){ "ECO" }
//        else if(canDB.C_DrivingModeState=="4"){ "Snow" }
//    }

    Component.onCompleted: {
        console.debug(" # [InfoDrivingMain][onCompleted] lastDrivingState : " + drivingMode )
        console.debug(" # [InfoDrivingMain][onCompleted] InfoDrivingMain.state : " + idInfoDrivingMain.state)
//        drivingStateStore = drivingMode
//        drivingMode = initialState;
//        drivingMode = drivingStateStore;
        setText();
        uiListener.autoTest_athenaSendObject();
        countryVariant = uiListener.getVariant();
    }


    onActiveFocusChanged:{
        console.debug(" # [InfoDrivingMain][onActiveFocusChanged] activeFocus :" + idInfoDrivingMain.activeFocus)
        if(idInfoDrivingMain.activeFocus == true)
        {
            drivingStateStore = drivingMode;
            drivingMode = initialState;
            drivingMode = drivingStateStore;
//            id_topButton_rect.forceActiveFocus()
            setText()

        }
    }
//    //--------------- Timer #
//    Timer {
//        id: idDrivingMainTimer
//        interval: 7000
//        onTriggered: { uiListener.HandleBackPreviousState() }
//        onRunningChanged: { console.log(" # [InfoDrivingMain][DrivingMainTimer] Start # ") }
//    }

    //--------------- Background Image #
    Image {
        y: -83//systemInfo.statusBarHeight
        source: imgFolderGeneral+"bg_5.png"
        MouseArea{
            anchors.fill: parent
            onPressed: {
                focusVisible=false
                id_topButton_f.visible=false
            }
        }//MouseArea
    } // End Image

    Image {
        y:464 // 557- systemInfo.titleAreaHeight//+systemInfo.statusBarHeight)
        height:  systemInfo.lcdHeight - 557
        source: imgFolderInfo+"info_bg.png"
    } // End Image

    FocusScope{
        x:0;y:0
        width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
        Image{
            x: 0; y: 0

            source: imgFolderGeneral+"bg_title.png"
        }
        Text{
            id: txtTitle
            text: stringInfo.strAutoCareDrivingMode
            x: countryVariant != 4 ? CONST.title_Area_X : CONST.title_Area_reverse_X
            y: countryVariant != 4 ? CONST.title_Area_Y : CONST.title_Area_reverse_Y
            width: 830; height: 26
            font.pointSize: 40
            font.family: "HDB"
            horizontalAlignment: countryVariant != 4 ? Text.AlignLeft : Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            visible: true
        }
        Rectangle{
        id:id_topButton_rect
        x: countryVariant != 4 ? CONST.topButton_rect_X : CONST.topButton_rect_reverse_X
        y: countryVariant != 4 ? CONST.topButton_rect_Y : CONST.topButton_rect_reverse_Y
        width: 121
        height: 73
        color: "transparent"
        focus: true
            Image {
                id: id_topButton_n
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: id_topButton_rect.width
                height: id_topButton_rect.height
                source: countryVariant != 4 ?  imgFolderGeneral+"btn_title_back_n.png" : imgFolderGeneral+"arab/btn_title_back_n.png"
                visible:true

            }//id_topButton_n
            Image {
                id: id_topButton_p
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: id_topButton_n.width
                height: id_topButton_n.height
                source: countryVariant != 4 ? imgFolderGeneral+"btn_title_back_p.png" : imgFolderGeneral+"arab/btn_title_back_p.png"
                visible: false
            }//id_topButton_p
            Image {
                id: id_topButton_fp
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: id_topButton_n.width
                height: id_topButton_n.height
                source: countryVariant != 4 ? imgFolderGeneral+"btn_title_back_fp.png" : imgFolderGeneral+"arab/btn_title_back_fp.png"
                visible: false
            }//id_topButton_fp
            Image {
                id: id_topButton_f
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: id_topButton_n.width
                height: id_topButton_n.height
                source: countryVariant != 4 ? imgFolderGeneral+"btn_title_back_f.png" :imgFolderGeneral+"arab/btn_title_back_f.png"
                visible: false
            }//id_topButton_f

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onPressed: {

                    focusVisible=false
                    id_topButton_f.visible=false
                    id_topButton_p.visible=true
                }
                onReleased: {
                    if((mouse.x>=0&&mouse.x<121)&&(mouse.y>=0&&mouse.y<73)){ //121*74
                        console.log("valid release")
                        id_topButton_p.visible=false
                        //gotoBackScreen()
                        uiListener.HandleBackKey()
                    }
                    else{
                        console.log("invalid release X : "+mouse.x + " Y: "+mouse.y);
                        id_topButton_p.visible=false
                    }
                }


            }
        onActiveFocusChanged: {
            console.log("###################### id_topButton_rect get activeFocus!!!!!!");

        }



        }//id_topButton_rect

    } // id:bkFocusScope
    //--------------- State Text #
    Text{
        id:txtDrivingState
        x: stateX; y: stateY+23-6
        width: txtStateWidth; height: txtStateHeight
        text: "Normal"
        font.pointSize: stateTextSize
        font.family: "HDB"
        color: colorInfo.brightGrey
        anchors.horizontalCenter: parent.horizontalCenter

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    } // End Text

    //--------------- Line Image #
    Image{
        id: imgHeight
        source: imgFolderInfo + "line.png"
        //x: stateLeftMargin
        y: lineTextY
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
    } // End Image

    //--------------- Big Car Image #
    Image {
        id : imgBigCar
        x: imgBigCarX; y: imgBigCarY
        source: imgBigCarSource
    } // End Image

    //--------------- ColorBar Image #
    Image {
        id: imgColorBar
        x: stateLeftMargin+94 ; y: lineTextY+259
        //width: imgSmallArrowWidth; height: imgSmallArrowHeight
        source: ""
        opacity: 1
        visible: false
        SequentialAnimation{
            id: aniColorBar
            running: false
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 0.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 1.0; duration: 500 }
            NumberAnimation { target: imgColorBar; property: "opacity"; to: 0.0; duration: 500 }
        }
    } // End Image

    //--------------- InfoDriving Band #
//    InfoDrivingBand{
//        id: idInfoDrivingBand
//        focus : true

//    }

    onBackKeyPressed: {
        console.log(" # [InfoDrivingMain] Back")
        //gotoBackScreen()
    }
    
    Rectangle{
        id:id_black_screen
        height: 720
        width: 1280
        y:0
        x:0
        color:Qt.rgba(0,0,0,1)
        visible:false

    }
    //--------------- Change State #
    states: [
        State {
            name: 'OSD'; when:  (stateBlackScreen == true)
            PropertyChanges { target: id_black_screen;  visible: true }
        },
        State {
            name: 'Normal'; when:  (stateBlackScreen != true && drivingMode == "Normal" )
            PropertyChanges { target: imgColorBar; source: imgFolderInfo+"info_bar_normal.png" }
            PropertyChanges { target: imgColorBar;  visible: true }
            PropertyChanges { target: aniColorBar;  running: true }
            PropertyChanges { target: id_black_screen;  visible: false }
            //PropertyChanges { target: idDrivingMainTimer; running: true }
        },
        State {
            name: 'Sports'; when:  (stateBlackScreen != true && drivingMode == "Sports" )
            PropertyChanges { target: imgColorBar; source: imgFolderInfo+"info_bar_sports.png" }
            PropertyChanges { target: imgColorBar;  visible: true }
            PropertyChanges { target: aniColorBar;  running: true }
            PropertyChanges { target: id_black_screen;  visible: false }
            //PropertyChanges { target: idDrivingMainTimer; running: true }
        },
        State {
            name: 'ECO';
            PropertyChanges { target: imgColorBar; source: imgFolderInfo+"info_bar_eco.png" }
            PropertyChanges { target: imgColorBar;  visible: true }
            PropertyChanges { target: aniColorBar;  running: true }
            PropertyChanges { target: id_black_screen;  visible: false }
            //PropertyChanges { target: idDrivingMainTimer; running: true }
        },
        State {
            name: 'Snow';when:  (stateBlackScreen != true && drivingMode == "Snow" )
            PropertyChanges { target: imgColorBar; source: imgFolderInfo+"info_bar_snow.png" }
            PropertyChanges { target: imgColorBar;  visible: true }
            PropertyChanges { target: aniColorBar;  running: true }
            PropertyChanges { target: id_black_screen;  visible: false }
            //PropertyChanges { target: idDrivingMainTimer; running: true }
        },
        State {
            name: 'init';when:  (stateBlackScreen != true && drivingMode == "init" )
            PropertyChanges { target: imgColorBar;  visible: false }
            PropertyChanges { target: id_black_screen;  visible: false }
        }
    ] // End states

} // End FocusScope
