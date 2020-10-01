import QtQuick 1.0

Item {
	id: europeStatusArea

	Image { }
	Image { }
	Image { }

	function positioningIcon() {
		for ( var i = 0; i < 3; ++i){
			europeStatusArea.children[i].x = (57 * i);
			europeStatusArea.children[i].y = 18;
			europeStatusArea.children[i].width = 44;
			europeStatusArea.children[i].height = 45;
		}
	}

	Component.onCompleted: {
		positioningIcon();
	}

	Connections {
		target: model
		onEuropeIconFileChanged: europeStatusArea.children[index].source = model.europeIcons[index].iconFile
	}
}
