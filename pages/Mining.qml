// The Liberty Project
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../components" as LibertyComponents
import libertyComponents.Wallet 1.0

Rectangle {
    id: root
    color: "transparent"
    property alias miningHeight: mainLayout.height
    property double currentHashRate: 0

    ColumnLayout {
        id: mainLayout
        Layout.fillWidth: true
        anchors.margins: 20
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: 20

        LibertyComponents.Label {
            id: soloTitleLabel
            fontSize: 24
            text: qsTr("Solo mining") + translationManager.emptyString
        }

        LibertyComponents.WarningBox {
            Layout.bottomMargin: 8
            text: qsTr("Mining is only available on local daemons.") + translationManager.emptyString
            visible: persistentSettings.useRemoteNode
        }

        LibertyComponents.WarningBox {
            Layout.bottomMargin: 8
            text: qsTr("Your daemon must be synchronized before you can start mining") + translationManager.emptyString
            visible: !persistentSettings.useRemoteNode && !appWindow.daemonSynced
        }

        LibertyComponents.TextPlain {
            id: soloMainLabel
            text: qsTr("Mining with your computer helps strengthen the Liberty network. The more that people mine, the harder it is for the network to be attacked, and every little bit helps.\n\nMining also gives you a small chance to earn some Liberty. Your computer will create hashes looking for block solutions. If you find a block, you will get the associated reward. Good luck!") + translationManager.emptyString
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            font.family: LibertyComponents.Style.fontRegular.name
            font.pixelSize: 14
            color: LibertyComponents.Style.defaultFontColor
        }

        LibertyComponents.WarningBox {
            id: warningLabel
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            text: qsTr("Mining may reduce the performance of other running applications and processes.") + translationManager.emptyString
        }

        GridLayout {
            columns: 2
            Layout.fillWidth: true
            columnSpacing: 20
            rowSpacing: 16

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment : Qt.AlignTop | Qt.AlignLeft

                LibertyComponents.Label {
                    id: soloMinerThreadsLabel
                    color: LibertyComponents.Style.defaultFontColor
                    text: qsTr("CPU threads") + translationManager.emptyString
                    fontSize: 16
                    wrapMode: Text.WordWrap
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                LibertyComponents.LineEdit {
                    id: soloMinerThreadsLine
                    Layout.minimumWidth: 200
                    text: "1"
                    validator: IntValidator { bottom: 1; top: idealThreadCount }
                }

                LibertyComponents.TextPlain {
                    id: numAvailableThreadsText
                    text: qsTr("Max # of CPU threads available for mining: ") + idealThreadCount + translationManager.emptyString
                    wrapMode: Text.WordWrap
                    font.family: LibertyComponents.Style.fontRegular.name
                    font.pixelSize: 14
                    color: LibertyComponents.Style.defaultFontColor
                }

                RowLayout {
                    LibertyComponents.StandardButton {
                        id: autoRecommendedThreadsButton
                        small: true
                        text: qsTr("Use recommended # of threads") + translationManager.emptyString
                        enabled: startSoloMinerButton.enabled
                        onClicked: {
                                soloMinerThreadsLine.text = Math.floor(idealThreadCount / 2);
                                appWindow.showStatusMessage(qsTr("Set to use recommended # of threads"),3)
                        }
                    }

                    LibertyComponents.StandardButton {
                        id: autoSetMaxThreadsButton
                        small: true
                        text: qsTr("Use all threads") + translationManager.emptyString
                        enabled: startSoloMinerButton.enabled
                        onClicked: {
                            soloMinerThreadsLine.text = idealThreadCount
                            appWindow.showStatusMessage(qsTr("Set to use all threads") + translationManager.emptyString,3)
                        }
                    }
                }

                RowLayout {
                    LibertyComponents.CheckBox {
                        id: backgroundMining
                        enabled: startSoloMinerButton.enabled
                        checked: persistentSettings.allow_background_mining
                        onClicked: {persistentSettings.allow_background_mining = checked}
                        text: qsTr("Background mining (experimental)") + translationManager.emptyString
                    }
                }

                RowLayout {
                    // Disable this option until stable
                    visible: false
                    LibertyComponents.CheckBox {
                        id: ignoreBattery
                        enabled: startSoloMinerButton.enabled
                        checked: !persistentSettings.miningIgnoreBattery
                        onClicked: {persistentSettings.miningIgnoreBattery = !checked}
                        text: qsTr("Enable mining when running on battery") + translationManager.emptyString
                    }
                }
            }

            ColumnLayout {
                Layout.alignment : Qt.AlignTop | Qt.AlignLeft

                LibertyComponents.Label {
                    id: manageSoloMinerLabel
                    color: LibertyComponents.Style.defaultFontColor
                    text: qsTr("Manage miner") + translationManager.emptyString
                    fontSize: 16
                    wrapMode: Text.Wrap
                    Layout.preferredWidth: manageSoloMinerLabel.textWidth
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                RowLayout {
                    LibertyComponents.StandardButton {
                        visible: true
                        id: startSoloMinerButton
                        small: true
                        text: qsTr("Start mining") + translationManager.emptyString
                        onClicked: {
                            var success = walletManager.startMining(appWindow.currentWallet.address(0, 0), soloMinerThreadsLine.text, persistentSettings.allow_background_mining, persistentSettings.miningIgnoreBattery)
                            if (success) {
                                update()
                            } else {
                                errorPopup.title  = qsTr("Error starting mining") + translationManager.emptyString;
                                errorPopup.text = qsTr("Couldn't start mining.<br>") + translationManager.emptyString
                                if (persistentSettings.useRemoteNode)
                                    errorPopup.text += qsTr("Mining is only available on local daemons. Run a local daemon to be able to mine.<br>") + translationManager.emptyString
                                errorPopup.icon = StandardIcon.Critical
                                errorPopup.open()
                            }
                        }
                    }

                    LibertyComponents.StandardButton {
                        visible: true
                        id: stopSoloMinerButton
                        small: true
                        text: qsTr("Stop mining") + translationManager.emptyString
                        onClicked: {
                            walletManager.stopMining()
                            update()
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment : Qt.AlignTop | Qt.AlignLeft

                LibertyComponents.Label {
                    id: statusLabel
                    color: LibertyComponents.Style.defaultFontColor
                    text: qsTr("Status") + translationManager.emptyString
                    fontSize: 16
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                LibertyComponents.LineEditMulti {
                    id: statusText
                    Layout.minimumWidth: 300
                    text: qsTr("Not mining") + translationManager.emptyString
                    borderDisabled: true
                    readOnly: true
                    wrapMode: Text.Wrap
                    inputPaddingLeft: 0
                }
            }
        }
    }

    function updateStatusText() {
        if (appWindow.isMining) {
            var userHashRate = walletManager.miningHashRate();
            if (userHashRate === 0) {
                statusText.text = qsTr("Mining temporarily suspended.") + translationManager.emptyString;
            }
            else {
                var blockTime = 120;
                var blocksPerDay = 86400 / blockTime;
                var globalHashRate = walletManager.networkDifficulty() / blockTime;
                var probabilityFindNextBlock = userHashRate / globalHashRate;
                var probabilityFindBlockDay = 1 - Math.pow(1 - probabilityFindNextBlock, blocksPerDay);
                var chanceFindBlockDay = Math.round(1 / probabilityFindBlockDay);
                statusText.text = qsTr("Mining at %1 H/s. It gives you a 1 in %2 daily chance of finding a block.").arg(userHashRate).arg(chanceFindBlockDay) + translationManager.emptyString;
            }
        }
        else {
            statusText.text = qsTr("Not mining") + translationManager.emptyString;
        }
    }

    function onMiningStatus(isMining) {
        var daemonReady = !persistentSettings.useRemoteNode && appWindow.daemonSynced
        appWindow.isMining = isMining;
        updateStatusText()
        startSoloMinerButton.enabled = !appWindow.isMining && daemonReady
        stopSoloMinerButton.enabled = !startSoloMinerButton.enabled && daemonReady
    }

    function update() {
        walletManager.miningStatusAsync();
    }

    LibertyComponents.StandardDialog {
        id: errorPopup
        cancelVisible: false
    }

    Timer {
        id: timer
        interval: 2000; running: false; repeat: true
        onTriggered: update()
    }

    function onPageCompleted() {
        console.log("Mining page loaded");
        update()
        timer.running = !persistentSettings.useRemoteNode
    }

    function onPageClosed() {
        timer.running = false
    }

    Component.onCompleted: {
        walletManager.miningStatus.connect(onMiningStatus);
    }
}
