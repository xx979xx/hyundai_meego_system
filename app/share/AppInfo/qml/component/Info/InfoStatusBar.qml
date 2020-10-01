import Qt 4.7
import "../../component/system/DH" as MSystem
import "../../component/QML/DH" as MComp
import "../Info" as MInfo

MComp.MComponent {
    id: idInfoStatusBar
    width:systemInfo.lcdWidth
    height:systemInfo.statusBarHeight

    property string selectHeight : "" //stringInfo.strAutoCareHeightNormal
    property string selectDriving : "" // stringInfo.strAutoCareDrivingNormal

    state: {
        if(idAppMain.state=="InfoHeightMain")
        {
            if(selectHeight=="High"){ "Height_High" }
            else if(selectHeight=="Low"){ "Height_Low" }
            else if(selectHeight=="Normal"){ "Height_Normal" }
        }
        else if(idAppMain.state=="InfoDrivingMain")
        {
            if(selectDriving=="Normal"){ "Driving_Normal" }
            else if(selectDriving=="Sports"){ "Driving_Sports" }
            else if(selectDriving=="ECO"){ "Driving_ECO" }
            else if(selectDriving=="Snow"){ "Driving_Snow" }
        } // End if
    }

    //--------------- Background Image #
    Image{
        source:imgFolderAutocare+"bg_anymode.png"
    }

    //--------------- Height/Driving Image of Type #
    Image{
        id: imgType
        x:46
        width:88; height:systemInfo.statusBarHeight	
        source: ""
    } // End Image

    //--------------- Height/Driving Title #
    Item{
        id: txtTitleItem
        x:46+88
        width:400; height:40
	anchors.verticalCenter: parent.verticalCenter

        Text {
            id: txtTitle
            text: ""
            color:colorInfo.brightGrey
            font.family: "HDBa1"
            font.pixelSize: 36
            anchors.verticalCenter: parent.verticalCenter
        } // End Text
    } // End Item

    //--------------- Height/Driving Image of State #
    Image{
        id:imgState
        x:46+88+424
        width:164; height:systemInfo.statusBarHeight
        source:imgFolderAutocare+"icon_anymode_car.png"

        //------ Height Image
        Image{
            id:imageArrow
            x:73; y:20
            width:32; height:35
            visible: idAppMain.state=="InfoHeightMain"
            source: ""
//            {
//                if(selectHeight=="High"){
//                    imgFolderAutocare+"arrow_anymode_high.png"
//                }
//                else if(selectHeight=="Low"){
//                    imgFolderAutocare+"arrow_anymode_low.png"
//                }
//                else{
//		    ""
//		} // End if
//            } // End source

            ///Image visible on change by source start
            Behavior on source {
                SequentialAnimation {
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageArrow; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                }
            } ///Image visible change end
        } // End Image

        //------ Driving Mode Image
        Image{
            id:imageDriving1
            x:18; y:32
            width:23; height:26
            visible: idAppMain.state=="InfoDrivingMain"
            source: ""
//            {
//                if(selectDriving=="Normal"){
//                    imgFolderAutocare+"spring_anymode_auto.png"
//                }
//                else if(selectDriving=="Sports"){
//                    imgFolderAutocare+"spring_anymode_sports.png"
//                } // End if
//            } // End source

            ///Image visible on change by source start
            Behavior on source {
                SequentialAnimation {
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving1; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                }
            }///Image visible change end
        } // End Image

        Image{
            id:imageDriving2
            x:18+96; y:32
            width:23; height:26
            visible: idAppMain.state=="InfoDrivingMain"
            source: ""
//            {
//                if(selectDriving=="Normal"){
//                    imgFolderAutocare+"spring_anymode_auto.png"
//                }
//                else if(selectDriving=="Sports"){
//                    imgFolderAutocare+"spring_anymode_sports.png"
//                } // End if
//            } // End source

            ///Image visible on change by source start
            Behavior on source {
                SequentialAnimation {
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: false; duration:500 }
                    PropertyAnimation{ target: imageDriving2; easing.type:Easing.Linear;property: "visible"; to: true; duration:500 }
                }
            }///Image visible change end
        }// End Image
    } // End mage

    //--------------- Height/Driving Mode #
    Item{
        id: txtModeItem
        x:46+88+424+187
        width:200; height:32
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: txtMode
            text: ""
            color:colorInfo.brightGrey
            font.family: "HDBa1"
            font.pixelSize: 32
            anchors.verticalCenter: parent.verticalCenter
        } // End Text
    } // End Item

    //--------------- Change State #
    states: [
        State {
            name: 'Height_High'; when: idAppMain.state=="InfoHeightMain" && selectHeight=="High"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareHeightInfo }
            PropertyChanges { target: imgType; source: imgFolderAutocare+"icon_anymode_height.png" }
            //PropertyChanges { target: imageArrow; visible: true }
            PropertyChanges { target: imageArrow; source: imgFolderAutocare+"arrow_anymode_high.png" }
            //PropertyChanges { target: imageDriving1; visible: false }
            //PropertyChanges { target: imageDriving2;visible: false }
            PropertyChanges { target: txtMode; text : selectHeight }
        },
        State {
            name: 'Height_Low'; when: idAppMain.state=="InfoHeightMain" && selectHeight=="Low"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareHeightInfo }
            PropertyChanges { target: imgType; source: imgFolderAutocare+"arrow_anymode_low.png" }
            //PropertyChanges { target: imageArrow; visible: true }
            PropertyChanges { target: imageArrow; source: imgFolderAutocare+"arrow_anymode_low.png" }
            //PropertyChanges { target: imageDriving1; visible: false }
            //PropertyChanges { target: imageDriving2;visible: false }
            PropertyChanges { target: txtMode; text : selectHeight }
        },
        /*
        State {
            name: 'Height_Normal'; when: idAppMain.state=="InfoHeightMain" && selectHeight=="Normal"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareHeightInfo }
            //PropertyChanges { target: imgType; source: imgFolderAutocare+"arrow_anymode_low.png" }
            //PropertyChanges { target: imageArrow; visible: true }
            PropertyChanges { target: imageArrow; source: imgFolderAutocare+"arrow_anymode_low.png" }
            //PropertyChanges { target: imageDriving1; visible: false }
            //PropertyChanges { target: imageDriving2;visible: false }
            //PropertyChanges { target: txtMode; text : selectHeight }
        }, */
        State {
            name: 'Driving_Normal'; when: idAppMain.state=="InfoDrivingMain" && selectDriving=="Normal"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareDrivingMode }
            PropertyChanges { target: imgType; source: imgFolderAutocare+"icon_anymode_damping.png" }
            //PropertyChanges { target: imageArrow; visible: false }
            //PropertyChanges { target: imageDriving1; visible: true }
            PropertyChanges { target: imageDriving1; source: imgFolderAutocare+"spring_anymode_auto.png" }
            //PropertyChanges { target: imageDriving2; visible: true }
            PropertyChanges { target: imageDriving2; source: imgFolderAutocare+"spring_anymode_auto.png" }
            PropertyChanges { target: txtMode; text : selectDriving }
        },
        State {
            name: 'Driving_Sports'; when: idAppMain.state=="InfoDrivingMain" && selectDriving=="Sports"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareDrivingMode }
            PropertyChanges { target: imgType; source: imgFolderAutocare+"icon_anymode_damping.png" }
            //PropertyChanges { target: imageArrow; visible: false }
            //PropertyChanges { target: imageDriving1; visible: true }
            PropertyChanges { target: imageDriving1; source: imgFolderAutocare+"spring_anymode_sports.png" }
            //PropertyChanges { target: imageDriving2; visible: true }
            PropertyChanges { target: imageDriving2; source: imgFolderAutocare+"spring_anymode_sports.png" }
            PropertyChanges { target: txtMode; text : selectDriving }
        },
        State {
            name: 'Driving_ECO'; when: idAppMain.state=="InfoDrivingMain" && selectDriving=="ECO"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareDrivingMode }
            PropertyChanges { target: imgType; source: imgFolderAutocare+"icon_anymode_damping.png" }
            //PropertyChanges { target: imageArrow; visible: false }
            //PropertyChanges { target: imageDriving1; visible: true }
            PropertyChanges { target: imageDriving1; source: imgFolderAutocare+"spring_anymode_auto.png" }
            //PropertyChanges { target: imageDriving2; visible: true }
            PropertyChanges { target: imageDriving2; source: imgFolderAutocare+"spring_anymode_auto.png" }
            PropertyChanges { target: txtMode; text : selectDriving }
        },
        State {
            name: 'Driving_Snow'; when: idAppMain.state=="InfoDrivingMain" && selectDriving=="Snow"
            PropertyChanges { target: txtTitle; text: stringInfo.strAutoCareDrivingMode }
            PropertyChanges { target: imgType; source: imgFolderAutocare+"icon_anymode_damping.png" }
            //PropertyChanges { target: imageArrow; visible: false }
            //PropertyChanges { target: imageDriving1; visible: true }
            PropertyChanges { target: imageDriving1; source: imgFolderAutocare+"spring_anymode_sports.png" }
            //PropertyChanges { target: imageDriving2; visible: true }
            PropertyChanges { target: imageDriving2; source: imgFolderAutocare+"spring_anymode_sports.png" }
            PropertyChanges { target: txtMode; text : selectDriving }
        }
    ] // End states
} // MComp.MComponent

