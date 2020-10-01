import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:24; y:0
        width:ListView.view.width-35-x; height:92

        // Function for Change Text Color
        function changeTextColor(text) {
            if( text.charAt(0) == '+')
                return "#2F7DFF";
            else if( text.charAt(0) == '-')
                return "#EA3939";
            else
                return colorInfo.brightGrey;
        }

        Image {
            x: 0; y: parent.height //In GUI Guide this position is 88 (height-2)
            source: imageInfo.imgFolderGeneral + "list_line.png"
        }

        Text {
            id: idText
            x: 102-24; y: 0//46 - font.pixelSize/2;
            width: 465
            height: parent.height
            text: display
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        MComp.MButton {
            id: idAddFavoriteButton
            x: 928
            y: 46-38
            width: 274; height: 79
            bgImage: imageInfo.imgFolderXMData + "btn_fav_n.png"
            bgImagePress: imageInfo.imgFolderXMData + "btn_fav_p.png"
            bgImageFocus: imageInfo.imgFolderXMData + "btn_fav_f.png"
            firstTextX: 9
            focus: true

            firstText:
            {
                if(stockDataManager.searchMyFavorites(display))
                {
                    return stringInfo.sSTR_XMDATA_DELETEFAVORITE;
                }
                else
                {
                    return stringInfo.sSTR_XMDATA_ADDFAVORITE;
                }
            }
            firstTextSize: 26//32
            firstTextStyle: systemInfo.font_NewHDB
            firstTextColor: colorInfo.brightGrey

            onBackKeyPressed: {
                gotoBackScreen(false);//CCP
            }
            onHomeKeyPressed: {
                gotoFirstScreen();
            }

            onClickOrKeySelected: {
                idListItem.ListView.view.currentIndex = index;
                idCenterFocusScope.focus = true;
                if(stockDataManager.canIAddToFavorite())
                {
                    if(stockDataManager.searchMyFavorites(display))
                    {
                        stockDataManager.removeMyFavoritesForToggle(display);
//                        interfaceManager.executeStockFavorite();
                        idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_ADDFAVORITE
                        showDeletedSuccessfully();
                    }
                    else
                    {
                        stockDataManager.prependMyFavorites(display);
//                        interfaceManager.executeStockFavorite();
                        idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_DELETEFAVORITE
                        showAddedToFavorite(stockDataManager.getRegisterFavoriteCount());
                    }
                }
                else
                {
                    if(idAddFavoriteButton.firstText == stringInfo.sSTR_XMDATA_ADDFAVORITE)
                    {
                        showListIsFull();
                    }
                    else
                    {
                        if(stockDataManager.searchMyFavorites(display))
                        {
                            stockDataManager.removeMyFavoritesForToggle(display);
//                            interfaceManager.executeStockFavorite();
                            idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_ADDFAVORITE
                            showDeletedSuccessfully();
                        }
                    }
                }
            }
        }

        onClickOrKeySelected: {
            if(playBeepOn)
                UIListener.playAudioBeep();
            idListItem.ListView.view.currentIndex = index;
            idCenterFocusScope.focus = true;
            if(stockDataManager.canIAddToFavorite())
            {
                if(stockDataManager.searchMyFavorites(display))
                {
                    stockDataManager.removeMyFavoritesForToggle(display);
//                    interfaceManager.executeStockFavorite();
                    idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_ADDFAVORITE
                    showDeletedSuccessfully();
                }
                else
                {
                    stockDataManager.prependMyFavorites(display);
//                    interfaceManager.executeStockFavorite();
                    idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_DELETEFAVORITE
                    showAddedToFavorite(stockDataManager.getRegisterFavoriteCount());
                }
            }
            else
            {
                if(idAddFavoriteButton.firstText == stringInfo.sSTR_XMDATA_ADDFAVORITE)
                {
                    showListIsFull();
                }
                else
                {
                    if(stockDataManager.searchMyFavorites(display))
                    {
                        stockDataManager.removeMyFavoritesForToggle(display);
//                        interfaceManager.executeStockFavorite();
                        idAddFavoriteButton.firstText = stringInfo.sSTR_XMDATA_ADDFAVORITE
                        showDeletedSuccessfully();
                    }
                }
            }
        }
        onHomeKeyPressed: {
            gotoFirstScreen();
        }
        onBackKeyPressed: {
            gotoBackScreen(false);//CCP
        }
        onWheelRightKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;
            ListView.view.moveOnPageByPage(rowPerPage, true);

        }
        onWheelLeftKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;
            ListView.view.moveOnPageByPage(rowPerPage, false);

        }
    }
}
