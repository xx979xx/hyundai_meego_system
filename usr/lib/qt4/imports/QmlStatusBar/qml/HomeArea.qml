import QtQuick 1.0
import QmlStatusBar 1.0

Item {
	id: homeArea
	property bool isMiddleEast: false
	signal goHome()

	function showHomeButton(showHome) {
		if ( showHome == 0){
			homeButton.visible = false;
			homeText.visible = false;
			bgImage.source = "qrc:/images/bg_indi.png";
			homeButton.source = "qrc:/images/btn_indi_home_n.png"
			statusBar.color = "#000000FF";
		}
		else if ( showHome == 1){
			homeText.visible = false;
			homeButton.visible = true;
			bgImage.source = "qrc:/images/bg_indi.png";
			statusBar.color = "#000000FF";
		}
		else if ( showHome == 2){
			homeText.visible = true;
			homeButton.visible = false;
			homeButton.source = "qrc:/images/btn_indi_home_n.png"
			bgImage.source = "";
			statusBar.color = "#00000000";
		}
		else if ( showHome == 3){
			homeText.visible = false;
			homeButton.visible = true;
			homeButton.source = "qrc:/images/btn_indi_home_n.png"
			bgImage.source = "";
			statusBar.color = "#00000000";
		}
	}

	function hideHomeButton() {
		homeButton.visible = false;
		homeText.visible = false;
	}

	Image {
		id: homeButton
		x: 0; y: 0; width: 149; height: 93
		source: "qrc:/images/btn_indi_home_n.png"
		property bool isPressed: false
		visible: true

		MouseArea {
			id: buttonMouseArea
                        beepEnabled: false
			anchors.fill: parent
			onPressed: {
				console.log("StatusBar Home Pressed");
				homeButton.source =  "qrc:/images/btn_indi_home_p.png"
				homeButton.isPressed = true 
			}
			onReleased: {
				console.log("StatusBar Home Released");
				homeButton.source =  "qrc:/images/btn_indi_home_n.png"

				if ( buttonMouseArea.mouseX > 0 && homeButton.isPressed){
					homeArea.goHome()
				}
				homeButton.isPressed = false
			}
			onExited: {
				console.log("StatusBar Home Exited");
				homeButton.source =  "qrc:/images/btn_indi_home_n.png"
				homeButton.isPressed = false
			}
		}

		onVisibleChanged: {
			if ( visible == false) {
				homeButton.source = "qrc:/images/btn_indi_home_n.png"
			}
		}
	}

	Text {
		id: homeText
		x: 10; y: 0; width: 160; height: 94
		font.family: "HDB"
		font.pointSize: 35
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		color: "#9E9E9E"
		text: "HOME"
		visible: false
	}
}

