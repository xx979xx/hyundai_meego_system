/**
 * FileName: Case_D_DeleteAllQuestion.qml
 * Author: David.Bae
 * Time: 2012-05-11 18:07
 *
 * - 2012-05-11 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
// Local Import
import "../../../component/XMData" as XMData
//import AGWDataMapBackground 1.0

MComp.MComponent{
    id:container
    // Position/Size/focus Definition
    width:parent.width;height:parent.height+systemInfo.titleAreaHeight;
    //focus:true

    // Property Definition include alias
    property alias prioritizationLevels: idPriorityLevel.text;
    property alias alertType:idAlertType.text;
    property alias phrase:idPhrase.text;
    property alias startingTime:idSTime.text;
    property alias eTime:idETime.text;
//    property alias wsaLon: idAlertMapBG.saLon;
//    property alias wsaLat: idAlertMapBG.saLat;

    // Message Area Info
    property int msgAreaWidth: 987
    property int msgAreaHeight: 559

    // Scroll Info
    property int scrollWidth: 13
    property int scrollY: 14


    signal close();
    signal button1Clicked();

    // function Descirption

    // Event Definition
    MouseArea{ anchors.fill: parent
        onClicked:{
            console.log("[QML] Case_C_ChannelName Background Dimmed area.. clicked. Do not anyting")
        }
    }
    // Componet Layout
    //****************************** # Background mask #
    Rectangle{
        x:0; y:0;
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.6
    }
    //****************************** # Popup Background #
    Image{
        x: 110; y: 37
        source: imageInfo.imgFolderPopup +"popup_etc_05_bg.png"

        Item{
            id:idMsgPopup
            x:0; y:0
            width: msgAreaWidth-scrollWidth; height: msgAreaHeight
            clip: true

            Flickable{
                id:idMsgFlick
                contentX:0; contentY: 0
                contentWidth: msgAreaWidth-scrollWidth
                contentHeight: idPriorityLevel.height/*+idAlertMapBG.height*/+idPhrase.paintedHeight+idSTime.height
                flickableDirection: Flickable.VerticalFlick;
                boundsBehavior : Flickable.DragOverBounds//Flickable.StopAtBounds
                anchors.fill: parent;
                clip: true

                //******************************* # Title #
                Text{
                    id:idPriorityLevel;
                    x:45; y:/*55*/44-height/2
                    width:75;
                    height:44;
                    font.pixelSize:44;
                    font.family: systemInfo.font_NewHDB
                    horizontalAlignment: Text.AlignLeft
                    color: Qt.rgba( 182/255, 201/255, 255/255, 1)
                    elide: Text.ElideRight
                    text:"prioritizationLevels"
                    XMData.XMRectangleForDebug{}
                }
                //******************************** # select 1
                //
                Text{
                    id:idAlertType
                    x:idPriorityLevel.y+idPriorityLevel.width+10; y:44-height/2//55+80-height/2
                    width:450/*74+428+494*/;height:44
                    font.pixelSize:44;
                    font.family: systemInfo.font_NewHDB
                    horizontalAlignment: Text.AlignLeft
                    color: colorInfo.subTextGrey
                    elide: Text.ElideRight
                    text:"alertType";
                    XMData.XMRectangleForDebug{border.color:"red"}
                }
                //
                //
//                AGWDataMapBackground{
//                    id:idAlertMapBG
//                    x:45; y:103
//                    width:320; height:240
//                    securityAlert: true
//                    saLon: wsaLon/*-86.459209*/
//                    saLat: wsaLat/*37.7982*/
//                    source:"1x_1_1"
//                    Image{
//                        id:idCurrLoc
//                        x: idAlertMapBG.width/2 - (104/2)
//                        y: idAlertMapBG.height/2 - (106/2)
//                        source: imageInfo.imgFolderXMData + "ico_radar_location.png";
//                    }
//                }
                //
                //
                Text{
                    id:idPhrase
                    x:45; y:340
                    width:750/*74+428+494*/;height:idPhrase.paintedHeight
                    font.pixelSize:30
                    font.family: systemInfo.font_NewHDB
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                    color: colorInfo.subTextGrey
                    text:"phrase";
                    XMData.XMRectangleForDebug{border.color:"red"}
                }
                //
                //
                Text{
                    id:idSTime
                    x:45; y:idPhrase.y+idPhrase.height+10
                    width:270/*74+428+494*/;height:30
                    font.pixelSize:30;
                    font.family: systemInfo.font_NewHDB
                    horizontalAlignment: Text.AlignLeft
                    color: colorInfo.subTextGrey
                    elide: Text.ElideRight
                    text:"startingTime";
                    XMData.XMRectangleForDebug{border.color:"red"}
                }
                //
                //
                Text{
                    id:idETime
                    x:idSTime.x+idSTime.width; y:idPhrase.y+idPhrase.height+10
                    width:200/*74+428+494*/;height:30
                    font.pixelSize:30;
                    font.family: systemInfo.font_NewHDB
                    horizontalAlignment: Text.AlignLeft
                    color: colorInfo.subTextGrey
                    elide: Text.ElideRight
                    text:"eTime";
                    XMData.XMRectangleForDebug{border.color:"red"}
                }
            }
            //--------------------- ScrollBar #
            MComp.MScroll {
                id: idMsgPopupScroll
                x: 907; y: 14
                height: 509; width: scrollWidth
                scrollArea: idMsgFlick;
                visible: 539<idMsgFlick.height
                selectedScrollImage: imageInfo.imgFolderPopup+"scroll_bell_bg.png"
                anchors.verticalCenter: idMsgFlick.verticalCenter
            }
        }        

        //
        MComp.MButton{
            id:idButtonOK;
            x:927 ;y:14/*189+82*/
            width:140;height:260
            firstText: "List"/*stringInfo.sSTR_XMDATA_OK*/;
            firstTextX:14;
//            firstTextY:33
//            firstTextWidth:140-28
            firstTextSize:30
            firstTextColor: colorInfo.subTextGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextStyle: systemInfo.font_NewHDB
//            firstTextAlies: "Center"
            bgImage: imageInfo.imgFolderPopup + "btn_popup_l_n.png";
            bgImageFocus: imageInfo.imgFolderPopup + "btn_popup_l_f.png";
            bgImagePress: imageInfo.imgFolderPopup + "btn_popup_l_p.png";
            bgImageFocusPress: imageInfo.imgFolderPopup + "btn_popup_l_fp.png";
            onClickOrKeySelected: {
                button1Clicked();
            }
            focus : true
            KeyNavigation.down: null;
        }

        MComp.MButton{
            id:idButtonCancel;
            x:idButtonOK.x;y:idButtonOK.y+idButtonOK.height/*189+82*/
            width:140;height:260
            firstText: stringInfo.sSTR_XMDATA_CANCEL
            firstTextX:14;
//            firstTextY:33
//            firstTextWidth:140-28
            firstTextSize:30
            firstTextColor: colorInfo.subTextGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusPressColor: colorInfo.brightGrey
            firstTextStyle: systemInfo.font_NewHDB
//            firstTextAlies: "Center"
            bgImage: imageInfo.imgFolderPopup + "btn_popup_l_n.png";
            bgImageFocus: imageInfo.imgFolderPopup + "btn_popup_l_f.png";
            bgImagePress: imageInfo.imgFolderPopup + "btn_popup_l_p.png";
            bgImageFocusPress: imageInfo.imgFolderPopup + "btn_popup_l_fp.png";
            onClickOrKeySelected: {
                close();
            }
            KeyNavigation.up: null;
        }
    }
    //XMRectangleForDebug{ border.width:5; border.color:"blue"}
}
