import QtQuick 1.0
import QmlStatusBar 1.0

Rectangle {
	id: statusBar
	x: 0; y: 0; width: 1280; height: 93
	property string homeType: "button"
	property bool middleEast: false

	property bool isAgreed: false

	property alias model: statusBarModel

	StatusIconModel {
		id: statusBarModel

		onAgreed: {
			statusBar.isAgreed = true
		}

		onBackToAgree: {
			statusBar.isAgreed = false
		}

//                onPowerStatusChanged : {
//                    checkPowerStatus();
//                }
	}

	onHomeTypeChanged: {
            changeHomeType();
            setTime();
	}

	function changeHomeType(){
		if ( homeType == "button"){
			homeArea.showHomeButton(1);
		}
		else if ( homeType == "home-button"){
			homeArea.showHomeButton(3);
		}
		else if ( homeType == "text"){
			homeArea.showHomeButton(2);
		}
		else {
			homeArea.showHomeButton(0);
		}	
	}

	Image {
		id: bgImage
		source: "qrc:/images/bg_indi.png"
		anchors.fill: parent
	}

	HomeArea {
		id: homeArea
		isMiddleEast: parent.middleEast
		
		x: 0; y: 0; width: 170; height: 94
	}

	StatusArea {
		id: iconArea
		isMiddleEast: parent.middleEast
		x: 1280 - (57 * 8 + 18); y: 0; width: 57 * 8; height: 94
	}

	EuropeStatusArea {
		id: europeIconArea
		x: 173; y: 0; width: 57 * 3; height: 94
	}

	TimeArea {
		id: timeArea
                x: 532; y: 22; width: 213; height: 94-22
	}

	function handleVariant() {
		if ( middleEast ){
			homeArea.x = 1280 - 167;
			iconArea.x = 31;
			europeIconArea.visible = false;
		}
		else{
			homeArea.x = 0;
			iconArea.x = 1280 - (57 * 8 + 18);
			europeIconArea.visible = true;
		}
	}

	Component.onCompleted: {
            handleVariant();
            setTime();

//            checkPowerStatus();
	}

	onMiddleEastChanged: {
            handleVariant();
            setTime();

//            checkPowerStatus();
	}

	Connections {
		target: homeArea
		onGoHome: {
			console.log("home clicked")
			statusBarModel.sendHome()
		}
	}
        Connections {
                target: timeArea
                onGoTimeClick: {
                    console.log("Time clicked")
                    statusBarModel.sendTimeClick()
                }
        }

        function setTime() {

            console.log("StatusBar setTime")
            timeArea.setTime(statusBarModel.getHour(), statusBarModel.getMin(), statusBarModel.getAMPM());

        }        

        /*
        function checkPowerStatus() {

            if (statusBarModel.isPowerOn() == true) {
                console.log("StatusBar checkPowerStatus Power ON")
                changeHomeType();
            }
            else {
                console.log("StatusBar checkPowerStatus Power OFF")
                homeArea.hideHomeButton();

             }
        }
        */
}
