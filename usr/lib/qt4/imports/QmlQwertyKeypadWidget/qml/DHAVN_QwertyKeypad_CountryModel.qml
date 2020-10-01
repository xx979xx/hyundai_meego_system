import QtQuick 1.0
import "DHAVN_QwertyKeypad.js" as QKC

ListModel{
    ListElement{//Korean-0
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenKorean.qml"
                name: "STR_KEYPAD_TYPE_KOREAN"
                type: 1 // QKC.const_QWERTY_KEYPAD_TYPE_KOREAN
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            }
        ]
    }
    ListElement{//English-1
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH_A"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenLatinExtended.qml"
                name: "STR_KEYPAD_TYPE_LATINEXT"
                type: 7 // QKC.const_QWERTY_KEYPAD_TYPE_LATIN
            }
        ]
    }
    ListElement{//China-2
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenChinese_Pinyin.qml"
                name: "STR_KEYPAD_TYPE_CHINESE"
                type: 3 // QKC.const_QWERTY_KEYPAD_TYPE_CHINA
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            }
        ]
    }
    ListElement{//General-3
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenKorean.qml"
                name: "STR_KEYPAD_TYPE_KOREAN"
                type: 1 // QKC.const_QWERTY_KEYPAD_TYPE_KOREAN
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            }
        ]
    } 
    ListElement{//MiddleEast-4
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenArabic_Numbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenArabic.qml"
                name: "STR_KEYPAD_TYPE_ARABIC"
                type: 4 // QKC.const_QWERTY_KEYPAD_TYPE_MIDDLE_EAST
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenArabic_English.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenArabic_Latin.qml"
                name: "STR_KEYPAD_TYPE_EU_LATIN"
                type: 7 // QKC.const_QWERTY_KEYPAD_TYPE_LATIN
            },
            ListElement{ // Toggle Page (in screen of arabic keyboard)
                url: "DHAVN_QwertyKeypad_ScreenArabic_Type2_SpecialChar.qml"
                name: ""
                type: 4 // QKC.const_QWERTY_KEYPAD_TYPE_MIDDLE_EAST
            }

        ]
    }
    ListElement{//Europa-5
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean_Numbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean.qml"
                name: "STR_KEYPAD_TYPE_EUROPEAN"
                type: 6 // QKC.const_QWERTY_KEYPAD_TYPE_EU
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean_LatinExtended.qml"
                name: "STR_KEYPAD_TYPE_EU_LATINEXT"
                type: 7 // QKC.const_QWERTY_KEYPAD_TYPE_LATIN
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean_Cyrillic.qml"
                name: "STR_KEYPAD_TYPE_EU_CYRILIC"
                type: 5 // QKC.const_QWERTY_KEYPAD_TYPE_CYRILLIC
            }
        ]
    }
    ListElement{//Canada-6
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH_A"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenLatinExtended.qml"
                name: "STR_KEYPAD_TYPE_LATINEXT"
                type: 7 // QKC.const_QWERTY_KEYPAD_TYPE_LATIN
            }
        ]
    }
    ListElement{//RUSSIA-7
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean_Numbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean.qml"
                name: "STR_KEYPAD_TYPE_EUROPEAN"
                type: 6 // QKC.const_QWERTY_KEYPAD_TYPE_EU
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean_LatinExtended.qml"
                name: "STR_KEYPAD_TYPE_EU_LATINEXT"
                type: 7 // QKC.const_QWERTY_KEYPAD_TYPE_LATIN
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenEuropean_Cyrillic.qml"
                name: "STR_KEYPAD_TYPE_EU_CYRILIC"
                type: 5 // QKC.const_QWERTY_KEYPAD_TYPE_CYRILLIC
            }
        ]
    }
    ListElement{//China 2 : HWR 8
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenChinese_HWR.qml"
                name: "STR_KEYPAD_TYPE_CHINESE"
                type: 3 // QKC.const_QWERTY_KEYPAD_TYPE_CHINA
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            }
        ]
    }
    ListElement{//China 2 : Consonant 9
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenChinese_Consonant.qml"
                name: "STR_KEYPAD_TYPE_CHINESE"
                type: 3 // QKC.const_QWERTY_KEYPAD_TYPE_CHINA
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            }
        ]
    }
    ListElement{//China 2 : Consonant(PhoneBook) 10
        line:[
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenNumbers.qml"
                name: "STR_KEYPAD_TYPE_NUMBER"
                type: 0 // QKC.const_QWERTY_KEYPAD_TYPE_NUMBER
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenChinese_Consonant_PhoneBook.qml"
                name: "STR_KEYPAD_TYPE_CHINESE"
                type: 3 // QKC.const_QWERTY_KEYPAD_TYPE_CHINA
            },
            ListElement{
                url: "DHAVN_QwertyKeypad_ScreenSymbols.qml"
                name: "STR_KEYPAD_TYPE_ENGLISH"
                type: 2 // QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH
            }
        ]
    }
}

