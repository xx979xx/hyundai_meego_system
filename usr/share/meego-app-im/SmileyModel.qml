/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7

ListModel {
     id: smileyModel

     ListElement {
         name: "angry"
         source: "icons/emotes/emote-angry.png"
         ascii: ":-&"
     }
     ListElement {
         name: "confused"
         source: "icons/emotes/emote-confused.png"
         ascii: ":-S"
     }
     ListElement {
         name: "embarassed"
         source: "icons/emotes/emote-embarressed.png"
         ascii: ":-["
     }
     ListElement {
         name: "happy"
         source: "icons/emotes/emote-happy.png"
         ascii: ":-)"
     }
     ListElement {
         name: "heart"
         source: "icons/emotes/emote-love.png"
         ascii: "<3"
     }
     ListElement {
         name: "sad"
         source: "icons/emotes/emote-sad.png"
         ascii: ":'("
     }
     ListElement {
         name: "star"
         source: "icons/emotes/emote-star.png"
         ascii: "(*)"
     }
     ListElement {
         name: "tired"
         source: "icons/emotes/emote-tired.png"
         ascii: "|-("
     }
     ListElement {
         name: "wink"
         source: "icons/emotes/emote-wink.png"
         ascii: ";-)"
     }
 }
