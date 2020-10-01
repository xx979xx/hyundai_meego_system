import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    XMDataAddDeleteCheckBoxListDelegate{
        id: idListItem
        x:0; y:0
        z: index
        width:ListView.view.width;
        height:92

        //signal checkOn(int index);
        //signal checkOff(int index);

        onCheckBoxOn:{
            ListView.view.currentIndex = index;
            stockDataManager.appendDeleteFavorites(Symbol);
            onChangeCount();
        }
        onCheckBoxOff:{
            ListView.view.currentIndex = index;
            stockDataManager.removeDeleteFavorites(Symbol);
            onChangeCount();
        }
        onClickOrKeySelected: {
            if(playBeepOn)
                UIListener.playAudioBeep();
            idListItem.ListView.view.currentIndex = index;
            toggleCheckBox();
            itemClicked(idText.text);
            forceActiveFocus();
        }

        Text {
            id: idText
            x: 49 + 35
            y: 0
            width: 294
            height: parent.height
            text: Symbol
            font.family: systemInfo.font_NewHDB
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Component.onCompleted: {
            if(stockDataManager.searchDeleteFavorites(Symbol))
            {
                setCheckBoxOn();
            }
        }

        Connections {
            target: stockDataManager
            onSelectAllOccured: {
                setCheckBoxOn();
            }
            onDeselectAllOccured: {
                setCheckBoxOff();
            }
            onRollbackAllOccured: {
                if(stockDataManager.favoriteListForRollBack.indexOf(Symbol) < 0)
                    setCheckBoxOff();
                else
                    setCheckBoxOn();
            }
        }

        onHomeKeyPressed: {
            gotoFirstScreen();
        }
        onBackKeyPressed: {
            gotoBackScreen(false);//CCP
        }
    }
}
