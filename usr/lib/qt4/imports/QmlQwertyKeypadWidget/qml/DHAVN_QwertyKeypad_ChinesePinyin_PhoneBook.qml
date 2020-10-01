import QtQuick 1.1
import ChinesePinyin 1.0
import AppEngineQMLConstants 1.0

Item{
    id: pinyinMain
    signal phoneBookDBReadFailed()

    ChinesePinyin  {
        id: pinyinModel

        onPhoneBookDBOpenFailed:
        {
            pinyinMain.phoneBookDBReadFailed()
        }
    }

    signal clearBufferData()

    property string pinyinSpell

    function handleKey(keyCode, keyText)
    {
        if ( keyCode < 0x01000000 )
        {
            pinyinSpell  += keyText[0]
            pinyinModel.setKeyWord(pinyinSpell)
            return true
        }

        if(keyCode == Qt.Key_Back)
        {
            var nPos = pinyinSpell.length;

            if(nPos <= 0)
                return false

            nPos--

            pinyinSpell = pinyinSpell.substring( 0, nPos )
            pinyinModel.setKeyWord(pinyinSpell)

            // 데이터베이스를 검색하기 위해 버퍼에 저장해둔 문자열의 길이가 0 이하가 되면 버퍼를 초기화하고 버튼을 모두 활성화시킨다.
            if(nPos <= 0)   clearBufferData()

            return true
        }
        return false
    }

    //성음 퀵스펠러 (다음 입력될 수 있는 문자)
    function getConsontChars()
    {
        var nextChars = new Array()
        var btnIDs = new Array()
        var consonantCharLength

        nextChars = pinyinModel.getConsonantsNextCharList();
        consonantCharLength = nextChars.length

        for (var i=0; i < consonantCharLength; i++)
        {
            btnIDs[i] = fromStringToID(nextChars[i])
        }

        return btnIDs
    }


    function fromStringToID(btnText)
    {
        if (btnText ==" ")
            return 100

        var charToAsciiVal = btnText.charCodeAt(0)
        // btnIDList : btn_id list of sequential btn_text {'a', 'b', 'c', ..., 'z'}
        var btnIDList = new Array(10, 24, 22, 12, 2, 13, 14, 15, 7, 16, 17, 18, 26, 25, 8, 9, 0, 3, 11, 4, 6, 23, 1, 21, 5, 20 )
        var btnID = btnIDList[charToAsciiVal - 65]

        return btnID
    }

    function update(keyType)
    {
        pinyinModel.setKeypadType(keyType, isReceivedUsePhoneBookDB, phoneBookDBPath)
        pinyinSpell = ""
        pinyinModel.setKeyWord(pinyinSpell)
    }

    function clearBuffer()
    {
        pinyinSpell = ""
        pinyinModel.clearBuffer()
    }
}
