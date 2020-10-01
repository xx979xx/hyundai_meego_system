/**
 * BtContactScroll.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath


FocusScope
{
    id: idContactQuickScrollContainer
    width: 100
    height: 432

    /* INTERNAL functions */
    function getMiniPopupLetter(posY) {
        // Mini-popup에 보여줄 문자를 반환
        var index = idListViewQuickScroll.indexAt(0, posY);
        if(0 > index) {
            if(posY > 432) {
                index = idListViewQuickScroll.count - 1
                console.log("!!! > " + posY)
            } else if (posY < 62) {
                index = 0
            }
        }

        return idListViewQuickScroll.model.get(index).letter;
    }

    function getScrollLetter(posY) {
        // 실제 스크롤할 문자를 반환
        var index = idListViewHidden.indexAt(0, posY);
        if(0 > index) {
            // INVALID index, do nothing
            if(posY > 432) {
                index = idListViewQuickScroll.count - 1
                console.log("!!! > " + posY)
            } else if (posY < 10) {
                index = 0
            }
        }

        return idListViewHidden.model.get(index).letter;
    }


    /* WIDGETS */
    Image {
        id: idImageBackground
        source: ImagePath.imgFolderBt_phone + "contacts_quickscroll.png"
        width: 40
        height: 432

/*DEBUG
        Rectangle {
            color: "yellow"
            opacity: 0.2
            anchors.fill: parent
        }
DEBUG*/
    }

    // 화면에 보여지는 fast-scroll
    ListView {
        id: idListViewQuickScroll
        x: -20
        y: 32
        width: 80
        height: 400
        boundsBehavior: Flickable.StopAtBounds
        highlightMoveSpeed: 9999999

        visible: true

        model: {
            if(2 == gLanguage) {
                // LANGUAGE_KO
                listModelKor
            } else if(20 == gLanguage) {
                // LANGUAGE_AR
                listModelMed
            } else {
                listModelEng
            }
        }

        delegate: Item {
            width: 100//parent.width
            height: {
                if(2 == gLanguage) {
                    41
                } else if(20 == gLanguage) {
                    37
                } else {
                    46
                }
            }

            Text {
                text: letter
                x: 25
                y: -11
                width: 30
                height: 22
                font.pointSize : 22
                font.family: stringInfo.fontFamilyBold    //"HDB"
                color: colorInfo.brightGrey
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                //anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: iconIndex
                x: 39
                y: {
                    if(2 == gLanguage) {
                        19
                    } else if(20 == gLanguage) {
                        18
                    } else {
                        21
                    }
                }

                visible: (letter == 'V' || letter == 'U') ? false: true
                source: ImagePath.imgFolderBt_phone + "contacts_quickscroll_dot.png"
            }
        }
    }

    // Hidden quick-scroll
    ListView {
        id: idListViewHidden
        x: -20
        y: -10
        width: 50//parent.width
        height: 480
        boundsBehavior: Flickable.StopAtBounds
        highlightMoveSpeed: 9999999
        visible: true

        model: {
            if(2 == gLanguage) {
                // LANGUAGE_KO
                hiddenModelKorean
            } else if(20 == gLanguage) {
                // LANGUAGE_AR
                hiddenModelMidEast
            } else {
                hiddenModelGeneral
            }
        }

        delegate: Item {
            width: 100
            height: {
                if(2 == gLanguage) {
                    if(0 > gap) {
                        if("#" == letter) { 41 + 21 + 11 }
                        else if("Z" == letter) { 32 + 11 + 10 }
                        else { 22 }
                    } else {
                        19 / gap
                    }

                    //(0 > gap) ? (("#" == letter || "U" == letter) ? 41 + 21 + 11 : 22) : 19 / gap
                } else if(20 == gLanguage) {
                    if(0 > gap) {
                        if("#" == letter) { 37 + 21 + 11 }
                        else if("Z" == letter) { 32 + 11 + 10 }
                        else { 22 }
                    } else {
                        15 / gap
                    }

                    //(0 > gap) ? (("#" == letter || "U" == letter) ? 37 + 21 + 11 : 22) : 15 / gap
                } else {
                    if(0 > gap) {
                        if("#" == letter) { 46 + 21 + 11 }
                        else if("Z" == letter) { 32 + 11 + 10 }
                        else { 22 }
                    } else {
                        24 / gap
                    }

                    //(0 > gap) ? (("#" == letter || "V" == letter) ? 46 + 21 + 11 : 22) : 24 / gap
                }
            }

            Text {
                text: letter
                x: 12
                y: 0
                anchors.fill: parent
                font.pointSize : 22
                font.family: stringInfo.fontFamilyBold    //"HDB"
                color: colorInfo.brightGrey
                verticalAlignment: Text.AlignVCenter
                visible: false
            }
/*DEBUG
            Rectangle {
                border.color: "Red"
                border.width: 1
                color: "transparent"
                anchors.fill: parent
            }
DEBUG*/
        } // end of delegate
    }


    /* LISTMODEL */
    // 화면에 보여지지 않는 Quick-scroll을 위한 ListModel
    ListModel {
        id: hiddenModelKorean

        ListElement { letter: "#";  gap: -1 } //
        ListElement { letter: "ㄱ";  gap: -1 } //
        ListElement { letter: "ㄴ";  gap: 3 }
        ListElement { letter: "ㄷ";  gap: 3 }
        ListElement { letter: "ㄹ";  gap: 3 }
        ListElement { letter: "ㅁ";  gap: -1 } //
        ListElement { letter: "ㅂ";  gap: 3 }
        ListElement { letter: "ㅅ";  gap: 3 }
        ListElement { letter: "ㅇ";  gap: 3 }
        ListElement { letter: "ㅈ";  gap: -1 } //
        ListElement { letter: "ㅊ";  gap: 3 }
        ListElement { letter: "ㅋ";  gap: 3 }
        ListElement { letter: "ㅌ";  gap: 3 }
        ListElement { letter: "ㅍ";  gap: -1 } //
        ListElement { letter: "ㅎ";  gap: 1 }
        ListElement { letter: "A";  gap: -1 } //
        ListElement { letter: "B";  gap: 4 }
        ListElement { letter: "C";  gap: 4 }
        ListElement { letter: "D";  gap: 4 }
        ListElement { letter: "E";  gap: 4 }
        ListElement { letter: "F";  gap: -1 } //
        ListElement { letter: "G";  gap: 4 }
        ListElement { letter: "H";  gap: 4 }
        ListElement { letter: "I";  gap: 4 }
        ListElement { letter: "J";  gap: 4 }
        ListElement { letter: "K";  gap: -1 } //
        ListElement { letter: "L";  gap: 4 }
        ListElement { letter: "M";  gap: 4 }
        ListElement { letter: "N";  gap: 4 }
        ListElement { letter: "O";  gap: 4 }
        ListElement { letter: "P";  gap: -1 } //
        ListElement { letter: "Q";  gap: 4 }
        ListElement { letter: "R";  gap: 4 }
        ListElement { letter: "S";  gap: 4 }
        ListElement { letter: "T";  gap: 4 }
        ListElement { letter: "U";  gap: -1 } //
        ListElement { letter: "V";  gap: 6 }
        ListElement { letter: "W";  gap: 6 }
        ListElement { letter: "X";  gap: 6 }
        ListElement { letter: "Y";  gap: 6 }
        ListElement { letter: "Z";  gap: -1 }
    }

    ListModel {
        id: hiddenModelGeneral

        ListElement { letter: "#";  gap: -1}     //
        ListElement { letter: "A";  gap: -1 }    //
        ListElement { letter: "B";  gap: 2 }
        ListElement { letter: "C";  gap: 2 }
        ListElement { letter: "D";  gap: -1 }    //
        ListElement { letter: "E";  gap: 2 }
        ListElement { letter: "F";  gap: 2 }
        ListElement { letter: "G";  gap: -1 }    //
        ListElement { letter: "H";  gap: 2 }
        ListElement { letter: "I";  gap: 2 }
        ListElement { letter: "J";  gap: -1 }    //
        ListElement { letter: "K";  gap: 2 }
        ListElement { letter: "L";  gap: 2 }
        ListElement { letter: "M";  gap: -1 }    //
        ListElement { letter: "N";  gap: 2 }
        ListElement { letter: "O";  gap: 2 }
        ListElement { letter: "P";  gap: -1 }    //
        ListElement { letter: "Q";  gap: 2 }
        ListElement { letter: "R";  gap: 2 }
        ListElement { letter: "S";  gap: -1 }    //
        ListElement { letter: "T";  gap: 2 }
        ListElement { letter: "U";  gap: 2 } //
        ListElement { letter: "V";  gap: -1 }
        ListElement { letter: "W";  gap: 6 }
        ListElement { letter: "X";  gap: 6 }
        ListElement { letter: "Y";  gap: 6 }
        ListElement { letter: "Z";  gap: -1 }
    }

    // http://en.wikipedia.org/wiki/Arabic_alphabet
    ListModel {
        id: hiddenModelMidEast

        ListElement { letter: "#";  gap: -1 }   //
        ListElement { letter: "ا";  gap: -1 }   // 'alif
        ListElement { letter: "ب";  gap: 5 }    // ba'
        ListElement { letter: "ت";  gap: 5 }    // ta'
        ListElement { letter: "ث";  gap: 5 }    // tha'
        ListElement { letter: "ج";  gap: 5 }    // jim
        ListElement { letter: "ح";  gap: 5 }    // Ha'
        ListElement { letter: "خ";  gap: -1 }   // kha'
        ListElement { letter: "د";  gap: 5 }    // dal
        ListElement { letter: "ذ";  gap: 5 }    // dhal
        ListElement { letter: "ر";  gap: 5 }    // ra'
        ListElement { letter: "ز";  gap: 5 }    // zay
        ListElement { letter: "س";  gap: 5 }    // sin
        ListElement { letter: "ش";  gap: -1 }   // shin
        ListElement { letter: "ص";  gap: 5 }    // Sad
        ListElement { letter: "ض";  gap: 5 }    // Dad
        ListElement { letter: "ط";  gap: 5 }    // Ta'
        ListElement { letter: "ظ";  gap: 5 }    // Za'
        ListElement { letter: "ع";  gap: 5 }    // 'ayn
        ListElement { letter: "غ";  gap: -1 }   // Ghayn
        ListElement { letter: "ف";  gap: 5 }    // fa'
        ListElement { letter: "ق";  gap: 5 }    // qaf
        ListElement { letter: "ك";  gap: 5 }    // kaf
        ListElement { letter: "ل";  gap: 5 }    // lam
        ListElement { letter: "م";  gap: 5 }    // mim
        ListElement { letter: "ن";  gap: -1 }   // nun

        ListElement { letter: "A";  gap: -1 } //
        ListElement { letter: "B";  gap: 4 }
        ListElement { letter: "C";  gap: 4 }
        ListElement { letter: "D";  gap: 4 }
        ListElement { letter: "E";  gap: 4 }
        ListElement { letter: "F";  gap: -1 } //
        ListElement { letter: "G";  gap: 4 }
        ListElement { letter: "H";  gap: 4 }
        ListElement { letter: "I";  gap: 4 }
        ListElement { letter: "J";  gap: 4 }
        ListElement { letter: "K";  gap: -1 } //
        ListElement { letter: "L";  gap: 4 }
        ListElement { letter: "M";  gap: 4 }
        ListElement { letter: "N";  gap: 4 }
        ListElement { letter: "O";  gap: 4 }
        ListElement { letter: "P";  gap: -1 } //
        ListElement { letter: "Q";  gap: 4 }
        ListElement { letter: "R";  gap: 4 }
        ListElement { letter: "S";  gap: 4 }
        ListElement { letter: "T";  gap: 4 }
        ListElement { letter: "U";  gap: -1 } //
        ListElement { letter: "V";  gap: 6 }
        ListElement { letter: "W";  gap: 6 }
        ListElement { letter: "X";  gap: 6 }
        ListElement { letter: "Y";  gap: 6 }
        ListElement { letter: "Z";  gap: -1 }
    }


    /* 화면에 보여지는 Quick Scroll 문자를 위한 Model */
    // 한글
    ListModel {
        id: listModelKor

        ListElement { letter: "#" }
        ListElement { letter: "ㄱ" }
        ListElement { letter: "ㅁ" }
        ListElement { letter: "ㅈ" }
        ListElement { letter: "ㅍ" }
        ListElement { letter: "A" }
        ListElement { letter: "F" }
        ListElement { letter: "K" }
        ListElement { letter: "P" }
        ListElement { letter: "U" }
    }

    // 중동
    ListModel {
        id: listModelMed

        ListElement { letter: "#"  }
        ListElement { letter: "ا"  }    // 'alif
        ListElement { letter: "خ"  }    // kha'
        ListElement { letter: "ش"  }    // shin
        ListElement { letter: "غ"  }    // Ghayn
        ListElement { letter: "ن"  }    // nun
        ListElement { letter: "A"  }
        ListElement { letter: "F"  }
        ListElement { letter: "K"  }
        ListElement { letter: "P"  }
        ListElement { letter: "U"  }
    }

    // 영어
    ListModel {
        id: listModelEng

        ListElement { letter: "#" }
        ListElement { letter: "A" }
        ListElement { letter: "D" }
        ListElement { letter: "G" }
        ListElement { letter: "J" }
        ListElement { letter: "M" }
        ListElement { letter: "P" }
        ListElement { letter: "S" }
        ListElement { letter: "V" }
    }
}
/* EOF */
