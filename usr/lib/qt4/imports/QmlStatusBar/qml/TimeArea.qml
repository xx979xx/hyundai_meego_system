import QtQuick 1.0

Item {
	id: timeArea
        signal goTimeClick()
        property bool isPressed: false
        property string timeButtonSource:"";

        Image {
            id:timeButton
            x:0-42
            y:0-22
            width:288
            height:93
            source: timeButtonSource
        }

        Image {
            id:hour1
            x:0
            y:0
            width:34
            height:43
            source: hour1Source
        }

        Image {
            id:hour2
            x:36
            y:0
            width:34
            height:43
            source: hour2Source
        }

        Image {
            id:colon
            x:36 + 38
            y:6
            width:11
            height:30
            source: "qrc:/images/time/colon.png"
        }

        Image {
            id:min1
            x:36 + 38 + 13
            y:0
            width:34
            height:43
            source: min1Source
        }

        Image {
            id:min2
            x:36 + 38 + 13 + 36
            y:0
            width:34
            height:43
            source: min2Source
        }

        Image {
            id:am
            x:36 + 38 + 13 + 36 + 38
            y:16
            width:52
            height:27
            source: "qrc:/images/time/am.png";
            visible: false
        }

        Image {
            id:pm
            x:36 + 38 + 13 + 36 + 38
            y:16
            width:52
            height:27
            source: "qrc:/images/time/pm.png";
            visible: false
        }

        property string hour1Source:"";
        property string hour2Source:"";
        property string min1Source:"";
        property string min2Source:"";

        property string imagePrefix:"qrc:/images/time/num/num_0";
        property string imageSuffix:".png";

        function setTime(_hour, _minute, _ampm){
            if (_hour == -1) {

                am.visible = false;
                pm.visible = false;

                hour1.visible = true;

                hour1.x = 26;
                hour2.x = 26 + 36;
                colon.x = 26 + 36+ 38;
                min1.x = 26 + 36 + 38 + 13;
                min2.x = 26 + 36 + 38 + 13 + 36;

                hour1Source = "qrc:/images/time/num_hyphen.png";
                hour2Source = hour1Source;
                min1Source = hour1Source;
                min2Source = hour1Source;
            }
            else {
                if (_ampm) {

                    hour1.x = 0;
                    hour2.x = 36;
                    colon.x = 36 + 38;
                    min1.x = 36 + 38 + 13;
                    min2.x = 36 + 38 + 13 + 36;
                    am.x = 36 + 38 + 13 + 36 + 38;
                    pm.x = 36 + 38 + 13 + 36 + 38;

                    if (_hour < 10) {
                        hour1.visible = false;
                    }
                    else {
                        hour1.visible = true;
                        hour1Source = imagePrefix.concat(parseInt((_hour / 10)).toString(), imageSuffix);
                    }

                    hour2Source = imagePrefix.concat( parseInt((_hour % 10)).toString(), imageSuffix);

                    min1Source = imagePrefix.concat( parseInt((_minute / 10)).toString(), imageSuffix);
                    min2Source = imagePrefix.concat( parseInt((_minute % 10)).toString(), imageSuffix);

                    if (_ampm.toUpperCase() == "AM"){
                        am.visible = true;
                        pm.visible = false;
                    }
                    else if (_ampm.toUpperCase() == "PM"){
                        am.visible = false;
                        pm.visible = true;
                    }
                    else{
                        am.visible = false;
                        pm.visible = false;
                    }
                }
                else {
                    am.visible = false;
                    pm.visible = false;

                    hour1.visible = true;

                    hour1.x = 26;
                    hour2.x = 26 + 36;
                    colon.x = 26 + 36+ 38;
                    min1.x = 26 + 36 + 38 + 13;
                    min2.x = 26 + 36 + 38 + 13 + 36;

                    hour1Source = imagePrefix.concat( parseInt((_hour / 10)).toString(), imageSuffix);
                    hour2Source = imagePrefix.concat( parseInt((_hour % 10)).toString(), imageSuffix);

                    min1Source = imagePrefix.concat( parseInt((_minute / 10)).toString(), imageSuffix);
                    min2Source = imagePrefix.concat( parseInt((_minute % 10)).toString(), imageSuffix);
                }   // ampm
            }

        }

        /*
        function setTime(hour, minute, ampm){

		var imagePrefix = "qrc:/images/time/num/num_0";
		var imageSuffix = ".png";

                if (hour == -1) {
                    timeArea.children[5].visible = false;
                    timeArea.children[0].visible = true;

                    for ( var i = 0; i < 5; ++i){
                            if ( i == 2){
                                    timeArea.children[i].y = 6;
                                    timeArea.children[i].width = 11;
                                    timeArea.children[i].height = 30;
                            }
                            else{
                                    timeArea.children[i].y = 0;
                                    timeArea.children[i].width = 34;
                                    timeArea.children[i].height = 43;
                            }
                    }

                    timeArea.children[0].x = 26;
                    timeArea.children[1].x = 26 + 36;
                    timeArea.children[2].x = 26 + 36+ 38;
                    timeArea.children[3].x = 26 + 36 + 38 + 13;
                    timeArea.children[4].x = 26 + 36 + 38 + 13 + 36;

                    timeArea.children[0].source = "qrc:/images/time/num_hyphen.png";
                    timeArea.children[1].source = "qrc:/images/time/num_hyphen.png";
                    timeArea.children[2].source = "qrc:/images/time/colon.png";
                    timeArea.children[3].source = "qrc:/images/time/num_hyphen.png";
                    timeArea.children[4].source = "qrc:/images/time/num_hyphen.png";
                }
                else {
                    if ( ampm ){
                            for ( var i = 0; i < 6; ++i){
                                    if ( i == 2){
                                            timeArea.children[i].y = 6;
                                            timeArea.children[i].width = 11;
                                            timeArea.children[i].height = 30;
                                    }
                                    else if ( i == 5){
                                            timeArea.children[i].y = 16;
                                            timeArea.children[i].width = 52;
                                            timeArea.children[i].height = 27;
                                    }
                                    else{
                                            timeArea.children[i].y = 0;
                                            timeArea.children[i].width = 34;
                                            timeArea.children[i].height = 43;
                                    }
                            }

                            timeArea.children[0].x = 0;
                            timeArea.children[1].x = 36;
                            timeArea.children[2].x = 36 + 38;
                            timeArea.children[3].x = 36 + 38 + 13;
                            timeArea.children[4].x = 36 + 38 + 13 + 36;
                            timeArea.children[5].x = 36 + 38 + 13 + 36 + 38;

                            if (hour < 10) {
                                timeArea.children[0].visible = false;
                            }
                            else {
                                timeArea.children[0].visible = true;
                                timeArea.children[0].source = imagePrefix.concat(parseInt((hour / 10)).toString(), imageSuffix);
                            }

                            timeArea.children[1].source = imagePrefix.concat( parseInt((hour % 10)).toString(), imageSuffix);
                            timeArea.children[2].source = "qrc:/images/time/colon.png";
                            timeArea.children[3].source = imagePrefix.concat( parseInt((minute / 10)).toString(), imageSuffix);
                            timeArea.children[4].source = imagePrefix.concat( parseInt((minute % 10)).toString(), imageSuffix);

                            if ( ampm.toUpperCase() == "AM"){
                                    timeArea.children[5].source = "qrc:/images/time/am.png";
                                    timeArea.children[5].visible = true;
                            }
                            else if ( ampm.toUpperCase() == "PM"){
                                    timeArea.children[5].source = "qrc:/images/time/pm.png";
                                    timeArea.children[5].visible = true;
                            }
                            else{
                                    timeArea.children[5].visible = false;
                            }
                    }
                    else{
                            timeArea.children[0].visible = true;
                            timeArea.children[5].visible = false;

                            for ( var i = 0; i < 5; ++i){
                                    if ( i == 2){
                                            timeArea.children[i].y = 6;
                                            timeArea.children[i].width = 11;
                                            timeArea.children[i].height = 30;
                                    }
                                    else{
                                            timeArea.children[i].y = 0;
                                            timeArea.children[i].width = 34;
                                            timeArea.children[i].height = 43;
                                    }
                            }

                            timeArea.children[0].x = 26;
                            timeArea.children[1].x = 26 + 36;
                            timeArea.children[2].x = 26 + 36+ 38;
                            timeArea.children[3].x = 26 + 36 + 38 + 13;
                            timeArea.children[4].x = 26 + 36 + 38 + 13 + 36;

                            timeArea.children[0].source = imagePrefix.concat( parseInt((hour / 10)).toString(), imageSuffix);
                            timeArea.children[1].source = imagePrefix.concat( parseInt((hour % 10)).toString(), imageSuffix);
                            timeArea.children[2].source = "qrc:/images/time/colon.png";
                            timeArea.children[3].source = imagePrefix.concat( parseInt((minute / 10)).toString(), imageSuffix);
                            timeArea.children[4].source = imagePrefix.concat( parseInt((minute % 10)).toString(), imageSuffix);
                    }
                }
	}
        */

        Connections {
                target: model
                onTimeChanged: setTime(chour, cminute, cAMPM);
        }

        MouseArea {
                id: timeMouseArea
                anchors.fill: parent
                beepEnabled: false
                onPressed: {

//                    if (statusBar.isAgreed == true) {
//                        timeButton.source = "qrc:/images/num_press.png"
//                        isPressed = true
//                    }
//                    if ((statusBar.isAgreed == true) && (statusBar.isSoslock == false)) {
//                        timeButton.source = "qrc:/images/num_press.png"
//                        isPressed = true
//                        statusBarModel.qmlprint();
//                    }
                    if (statusBarModel.getApplicationName() != "AppStandBy") {
                        timeButton.source = "qrc:/images/num_press.png"
                        isPressed = true
                    }
//                    if (isPressed) {
//                        timeArea.goTimeClick()
//                    }
//                        }
//                        isPressed = false
                }
                onReleased: {
                        timeButton.source = ""
//                        if ( buttonMouseArea.mouseX > 0 && homeButton.isPressed){
//                                homeArea.goHome()
                    if (isPressed) {
                        timeArea.goTimeClick()
                    }
////                        }
                        isPressed = false

                }
                onExited: {
                        timeButton.source = ""
                        isPressed = false
                }

//                Rectangle {
//                        anchors.fill: parent
//                        height: 72
//                        color:  "transparent"
//                        border.width: 2
//                        border.color: "red"
//                        visible: isPressed
//                }

        }
}
