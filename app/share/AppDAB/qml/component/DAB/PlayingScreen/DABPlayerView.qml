/**
 * FileName: DABPlayerView.qml
 * Author: DaeHyungE
 * Time: 2013-01-17
 *
 * - 2013-01-17 Initial Crated by HyungE
 */

import Qt 4.7

FocusScope {
    id : idDABPlayerView

    DABPlayerInfoIcon {
        id : idDABPlayerInfoIcon
        x : 0
        y : 0
        width : idDabPlayerMain.width
        height : 64     //243 - 166
    }

    DABPlayerLogo {
        id : idDABPlayerLogo
        x : 146
        y : 326 - 179
        width : 262
        height : 262
        focus: true
    }

    DABPlayerFreqInfo {
        id : idDABPlayerFreqInfo
        x : 463
        y : 156
        width : 776
        height : 394
        visible: !m_bEnsembleSeek
    }

    DABPlayerSeekInfo {
        id : idDABPlayerSeekInfo
        x : 463
        y : 156
        width : 776
        height : 394
        visible: m_bEnsembleSeek
    }
}
