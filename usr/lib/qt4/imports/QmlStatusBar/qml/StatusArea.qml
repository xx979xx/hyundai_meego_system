import QtQuick 1.0

Item {
	id: statusArea
	property bool isMiddleEast: false
	Image { }
	Image { }
	Image { }
	Image { }
	Image { }
	Image { }
	Image { }
	Image { }

	function handleVariant() {
		for (var i = 0; i < 8; ++i){
			if ( isMiddleEast ){
				statusArea.children[i].x = (57 * i);
			}
			else{
				statusArea.children[i].x = (57 * 8) - (57 * (i + 1));
			}

			statusArea.children[i].y = 18;
			statusArea.children[i].width = 44;
			statusArea.children[i].height = 45;
		}
	}

	Component.onCompleted: {
		handleVariant();
	}

	onIsMiddleEastChanged: {
		handleVariant();
	}

	Connections {
		target: model
		onIconFileChanged: statusArea.children[index].source = model.statusIcons[index].iconFile
	}

}
