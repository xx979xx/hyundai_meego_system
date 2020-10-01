/**
 * BtContactListDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MContactsDelegate
{
    id: idDelegate
    width: 547
    height: 83
    x: 9
    active: (index == idContactLeftList.currentIndex)
    focus: (index == idContactLeftList.currentIndex)

    bgImage: ""
    bgImagePress: ImagePath.imgFolderBt_phone + "contacts_menu_p.png"
    bgImageFocus: ImagePath.imgFolderBt_phone + "contacts_menu_f.png"

    firstText: {
        if(true == replacedName) {
            /* 전화번호가 이름으로 대체된 경우라면 - 삽입 */
            MOp.checkPhoneNumber(contactName);
        } else {
            contactName
        }
    }

    firstTextColor: colorInfo.brightGrey
    firstTextFocusColor: colorInfo.brightGrey
    firstTextSelectedColor:colorInfo.bandBlue

    /* INTERNAL functions */
    function setContactInfo() {
        // 언어 변경 시 하기 팝업에서 입력 값이 초기화 되어 팝업 내부 값들이 표시 안되는 문제
        if(popupState == "popup_phonebook_search_add"
            || popupState == "popup_phonebook_search"
            || popupState == "popup_favorite_add_contacts_add"
            || popupState == "popup_favorite_add_contacts") {
            return;
        }

        /* 오른쪽 정보를 표시하기 위해 값을 저장함
         */
        position = index;

        delegate_count = count;

        contact_type_1 = type1;
        contact_type_2 = type2;
        contact_type_3 = type3;
        contact_type_4 = type4;
        contact_type_5 = type5;

        add_favorite_index = index;

        phoneNum    = number1;
        homeNum     = number2;
        officeNum   = number3;
        otherNum    = number4;
        other2Num   = number5;

        phoneName = idDelegate.firstText;

        /* 폰북이름을 화면에 보여지는 길이(paintedWidth) 기준 1줄 또는 2줄로 구성함
         */
        idHideClippingText.text = idDelegate.firstText;

        if(idHideClippingText.paintedWidth < 541) {
            headName = phoneName;
            tailName = "";
        } else {
            // 스페이스를 포함하고 있다면 스페이스를 기준으로 앞뒤로 나눔
            var splitted_names = phoneName.split(" ");
            var head_name = "";
            var tail_name = "";

            if(0 < splitted_names.length) {
                // 1개 이상의 스페이스를 포함
                var i = 0;
                for(/*var i = 0*/; i < splitted_names.length; i++) {
                    var temp = ("" == head_name) ? splitted_names[i] : (head_name + " " + splitted_names[i]);
                    idHideClippingText.text = temp;
                    if(idHideClippingText.paintedWidth > 541) {
                        break;
                    } else {
                        head_name = temp;
                    }
                }

                if("" == head_name) {
                    // 스페이스 앞이 너무 길어서 541을 넘어간 경우, 붙인 이름에서 그냥 자름
                    var i = 0;
                    for(/*var i = 0*/; i < phoneName.length; i++) {
                        var temp = phoneName.substr(0, i + 1);
                        idHideClippingText.text = temp;

                        if(537 < idHideClippingText.paintedWidth) {
                            break;
                        }
                    }

                    headName = phoneName.substr(0, i);
                    tailName = phoneName.substr(i);
                } else {
                    headName = head_name;

                    for(; i < splitted_names.length; i++) {
                        tail_name = ("" == tail_name) ? splitted_names[i] : (tail_name + " " + splitted_names[i]);
                    }

                    tailName = tail_name;
                }
            } else {
                // 스페이스가 없을 경우 임의로 자름
                var i = 0;
                for(/*var i = 0*/; i < phoneName.length; i++) {
                    var temp = phoneName.substr(0, i + 1);
                    idHideClippingText.text = temp;

                    if(537 < idHideClippingText.paintedWidth) {
                        break;
                    }
                }

                headName = phoneName.substr(0, i);
                tailName = phoneName.substr(i);
            }
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idDelegate.active) {
            // 오른쪽 정보를 표시하기 위해 값을 저장함
            idDelegate.setContactInfo();
        }
    }

    onActiveFocusChanged: {
        //DEPRECATED qml_debug("idDelegate.currentIndex : " + idDelegate.currentIndex)
        if(true == idDelegate.activeFocus) {
            // focus -> in the listview

            // 오른쪽 정보를 표시하기 위해 값을 저장함
            idDelegate.setContactInfo();

            // Set visual-cue
            idVisualCue.setVisualCue(true, false, false, true);
        }
    }

    onClickOrKeySelected: {
        // 오른쪽 정보를 표시하기 위해 값을 저장함
        idDelegate.setContactInfo();
        idBtContactRightView.forceActiveFocus();
    }

    /* WIDGETS */
    Text {
        /* 전화번호부 화면 오른쪽 이름 출력부분의 1줄, 2줄 표시 결정을 위해
         * idHideClippingText에 이름을 저장하여 paintedWidth를 계산함
         * (화면에 보이지 않고 width 계산을 위해 사용되는 Temporary Text)
         */
        id: idHideClippingText
        text: headName
        height: 60
        width: 537

        font {
            family: stringInfo.fontFamilyBold    //"HDB"
            pointSize: 60
        }

        visible:false
    }

    Image {
        x: 15
        y: 20
        width: 39
        height: 49
        visible: 1 == storageType ? true : false
        source: true == idDelegate.activeFocus ? ImagePath.imgFolderBt_phone + "ico_sim_f.png" : ImagePath.imgFolderBt_phone + "ico_sim_n.png"
    }
}
/* EOF */
