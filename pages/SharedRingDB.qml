// Copyright (c) 2018, The Liberty Project
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../components" as LibertyComponents
import libertyComponents.Clipboard 1.0

Rectangle {
    property alias panelHeight: mainLayout.height
    color: "transparent"

    Clipboard { id: clipboard }

    function validHex32(s) {
        if (s.length != 64)
            return false
        for (var i = 0; i < s.length; ++i)
            if ("0123456789abcdefABCDEF".indexOf(s[i]) == -1)
                return false
        return true
    }

    function validUnsigned(s) {
        if (s.length == 0)
            return false
        for (var i = 0; i < s.length; ++i)
            if ("0123456789".indexOf(s[i]) == -1)
                return false
        return true
    }

    function validRing(str, relative) {
        var outs = str.split(" ");
        if (outs.length == 0)
            return false
        for (var i = 1; i < outs.length; ++i) {
            if (relative) {
                if (outs[i] <= 0)
                    return false
            }
            else {
                if (outs[i] <= outs[i-1])
                    return false
            }
        }
        return true
    }

    /* main layout */
    ColumnLayout {
        id: mainLayout
        Layout.fillWidth: true
        anchors.margins: 20
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        spacing: 20

        MessageDialog {
            id: sharedRingDBDialog
            standardButtons: StandardButton.Ok
        }

        LibertyComponents.Label {
            id: signTitleLabel
            fontSize: 24
            text: qsTr("Shared RingDB") + translationManager.emptyString
        }

        LibertyComponents.TextPlain {
            text: qsTr("This page allows you to interact with the shared ring database. " +
                       "This database is meant for use by Liberty wallets as well as wallets from Liberty clones which reuse the Liberty keys.") + translationManager.emptyString
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            font.family: LibertyComponents.Style.fontRegular.name
            font.pixelSize: 14
            color: LibertyComponents.Style.defaultFontColor
        }

        LibertyComponents.LabelSubheader {
            Layout.fillWidth: true
            textFormat: Text.RichText
            text: "<style type='text/css'>a {text-decoration: none; color: #D9A83E; font-size: 14px;}</style>" +
                  qsTr("Outputs marked as spent") + " <a href='#'>" + qsTr("Help") + "</a>" + translationManager.emptyString
            onLinkActivated: {
                sharedRingDBDialog.title  = qsTr("Outputs marked as spent") + translationManager.emptyString;
                sharedRingDBDialog.text = qsTr(
                    "In order to obscure which inputs in a Liberty transaction are being spent, a third party should not be able " +
                    "to tell which inputs in a ring are already known to be spent. Being able to do so would weaken the protection " +
                    "afforded by ring signatures. If all but one of the inputs are known to be already spent, then the input being " +
                    "actually spent becomes apparent, thereby nullifying the effect of ring signatures, one of the three main layers " +
                    "of privacy protection Liberty uses.<br>" +
                    "To help transactions avoid those inputs, a list of known spent ones can be used to avoid using them in new " +
                    "transactions. Such a list is maintained by the Liberty project and is available on the getliberty.org website, " +
                    "and you can import this list here.<br>" +
                    "Alternatively, you can scan the blockchain (and the blockchain of key-reusing Liberty clones) yourself " +
                    "using the liberty-blockchain-mark-spent-outputs tool to create a list of known spent outputs.<br>"
                ) + translationManager.emptyString
                sharedRingDBDialog.icon = StandardIcon.Information
                sharedRingDBDialog.open()
            }
        }

        LibertyComponents.TextPlain {
            textFormat: Text.RichText
            font.family: LibertyComponents.Style.fontRegular.name
            font.pixelSize: 14
            text: qsTr("This sets which outputs are known to be spent, and thus not to be used as privacy placeholders in ring signatures. ") +
                  qsTr("You should only have to load a file when you want to refresh the list. Manual adding/removing is possible if needed.") + translationManager.emptyString
            wrapMode: Text.Wrap
            Layout.fillWidth: true;
            color: LibertyComponents.Style.defaultFontColor
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: 12

            FileDialog {
                id: loadBlackballFileDialog
                title: qsTr("Please choose a file from which to load outputs to mark as spent") + translationManager.emptyString;
                folder: "file://"
                nameFilters: ["*"]

                onAccepted: {
                    loadBlackballFileLine.text = walletManager.urlToLocalPath(loadBlackballFileDialog.fileUrl)
                }
            }

            LibertyComponents.LineEdit {
                id: loadBlackballFileLine
                Layout.fillWidth: true
                fontSize: 16
                placeholderFontSize: 16
                placeholderText: qsTr("Path to file") + "..." + translationManager.emptyString
                labelFontSize: 14
                labelText: qsTr("Filename with outputs to mark as spent") + ":" + translationManager.emptyString
                copyButton: true
                readOnly: false
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 18

                LibertyComponents.StandardButton {
                    id: selectBlackballFileButton
                    text: qsTr("Browse") + translationManager.emptyString
                    enabled: true
                    small: true
                    onClicked: {
                      loadBlackballFileDialog.open()
                    }
                }

                LibertyComponents.StandardButton {
                    id: loadBlackballFileButton
                    text: qsTr("Load") + translationManager.emptyString
                    small: true
                    enabled: !!appWindow.currentWallet && loadBlackballFileLine.text !== ""
                    onClicked: appWindow.currentWallet.blackballOutputs(walletManager.urlToLocalPath(loadBlackballFileDialog.fileUrl), true)
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columnSpacing: 20

            LibertyComponents.LineEdit {
                id: blackballOutputAmountLine
                Layout.fillWidth: true
                fontSize: 16
                labelFontSize: 14
                labelText: qsTr("Or manually mark a single output as spent/unspent:") + translationManager.emptyString
                placeholderFontSize: 16
                placeholderText: qsTr("Paste output amount") + "..." + translationManager.emptyString
                readOnly: false
                validator: IntValidator { bottom: 0 }
            }

            LibertyComponents.LineEdit {
                id: blackballOutputOffsetLine
                Layout.fillWidth: true
                fontSize: 16
                labelFontSize: 14
                labelText: " "
                placeholderFontSize: 16
                placeholderText: qsTr("Paste output offset") + "..." + translationManager.emptyString
                readOnly: false
                validator: IntValidator { bottom: 0 }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 18

            LibertyComponents.StandardButton {
                id: blackballButton
                text: qsTr("Mark as spent") + translationManager.emptyString
                small: true
                enabled: !!appWindow.currentWallet && validUnsigned(blackballOutputAmountLine.text) && validUnsigned(blackballOutputOffsetLine.text)
                onClicked: appWindow.currentWallet.blackballOutput(blackballOutputAmountLine.text, blackballOutputOffsetLine.text)
            }

            LibertyComponents.StandardButton {
                id: unblackballButton
                text: qsTr("Mark as unspent") + translationManager.emptyString
                small: true
                enabled: !!appWindow.currentWallet && validUnsigned(blackballOutputAmountLine.text) && validUnsigned(blackballOutputOffsetLine.text)
                onClicked: appWindow.currentWallet.unblackballOutput(blackballOutputAmountLine.text, blackballOutputOffsetLine.text)
            }
        }

        LibertyComponents.LabelSubheader {
            Layout.fillWidth: true
            Layout.topMargin: 24
            textFormat: Text.RichText
            text: "<style type='text/css'>a {text-decoration: none; color: #D9A83E; font-size: 14px;}</style>" +
                  qsTr("Rings") + " <a href='#'>" + qsTr("Help") + "</a>" + translationManager.emptyString
            onLinkActivated: {
                sharedRingDBDialog.title  = qsTr("Rings") + translationManager.emptyString;
                sharedRingDBDialog.text = qsTr(
                    "In order to avoid nullifying the protection afforded by Liberty's ring signatures, an output should not " +
                    "be spent with different rings on different blockchains. While this is normally not a concern, it can become one " +
                    "when a key-reusing Liberty clone allows you to spend existing outputs. In this case, you need to ensure this " +
                    "existing outputs uses the same ring on both chains.<br>" +
                    "This will be done automatically by Liberty and any key-reusing software which is not trying to actively strip " +
                    "you of your privacy.<br>" +
                    "If you are using a key-reusing Liberty clone too, and this clone does not include this protection, you can still " +
                    "ensure your transactions are protected by spending on the clone first, then manually adding the ring on this page, " +
                    "which allows you to then spend your Liberty safely.<br>" +
                    "If you do not use a key-reusing Liberty clone without these safety features, then you do not need to do anything " +
                    "as it is all automated.<br>"
                ) + translationManager.emptyString
                sharedRingDBDialog.icon = StandardIcon.Information
                sharedRingDBDialog.open()
            }
        }

        LibertyComponents.TextPlain {
            textFormat: Text.RichText
            font.family: LibertyComponents.Style.fontRegular.name
            font.pixelSize: 14
            text: qsTr("This records rings used by outputs spent on Liberty on a key reusing chain, so that the same ring may be reused to avoid privacy issues.") + translationManager.emptyString
            wrapMode: Text.Wrap
            Layout.fillWidth: true;
            color: LibertyComponents.Style.defaultFontColor
        }

        LibertyComponents.LineEdit {
            id: keyImageLine
            Layout.fillWidth: true
            fontSize: 16
            labelFontSize: 14
            labelText: qsTr("Key image") + ":" + translationManager.emptyString
            placeholderFontSize: 16
            placeholderText: qsTr("Paste key image") + "..." + translationManager.emptyString
            readOnly: false
            copyButton: true
        }

        GridLayout{
            Layout.topMargin: 12
            columns: 2
            columnSpacing: 32

            ColumnLayout {
                RowLayout {
                    LibertyComponents.LineEdit {
                        id: getRingLine
                        Layout.fillWidth: true
                        fontSize: 16
                        labelFontSize: 14
                        labelText: qsTr("Get ring") + ":" + translationManager.emptyString
                        readOnly: true
                        copyButton: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 18

                    LibertyComponents.StandardButton {
                        id: getRingButton
                        text: qsTr("Get Ring") + translationManager.emptyString
                        small: true
                        enabled: !!appWindow.currentWallet && validHex32(keyImageLine.text)
                        onClicked: {
                            var ring = appWindow.currentWallet.getRing(keyImageLine.text)
                            if (ring === "") {
                                getRingLine.text = qsTr("No ring found") + translationManager.emptyString;
                            }
                            else {
                                getRingLine.text = ring;
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                RowLayout {
                    LibertyComponents.LineEdit {
                        id: setRingLine
                        Layout.fillWidth: true
                        fontSize: 16
                        labelFontSize: 14
                        placeholderFontSize: 16
                        labelText: qsTr("Set ring") + ":" + translationManager.emptyString
                        readOnly: false
                        copyButton: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 18

                    LibertyComponents.StandardButton {
                        id: setRingButton
                        text: qsTr("Set Ring") + translationManager.emptyString
                        small: true
                        enabled: !!appWindow.currentWallet && validHex32(keyImageLine.text) && validRing(setRingLine.text.trim(), setRingRelative.checked)
                        onClicked: {
                            var outs = setRingLine.text.trim()
                            appWindow.currentWallet.setRing(keyImageLine.text, outs, setRingRelative.checked)
                        }
                    }
                }
            }
        }

        GridLayout {
            columnSpacing: 20
            columns: 2

            LibertyComponents.CheckBox {
                id: segregatePreForkOutputs
                checked: persistentSettings.segregatePreForkOutputs
                text: qsTr("I intend to spend on key-reusing fork(s)") + translationManager.emptyString
                onClicked: {
                    persistentSettings.segregatePreForkOutputs = segregatePreForkOutputs.checked
                    if (appWindow.currentWallet) {
                        appWindow.currentWallet.segregatePreForkOutputs(segregatePreForkOutputs.checked)
                    }
                }
            }

            LibertyComponents.CheckBox {
                id: keyReuseMitigation2
                checked: persistentSettings.keyReuseMitigation2
                text: qsTr("I might want to spend on key-reusing fork(s)") + translationManager.emptyString
                onClicked: {
                    persistentSettings.keyReuseMitigation2 = keyReuseMitigation2.checked
                    if (appWindow.currentWallet) {
                        appWindow.currentWallet.keyReuseMitigation2(keyReuseMitigation2.checked)
                    }
                }
            }

            LibertyComponents.CheckBox {
                id: setRingRelative
                checked: true
                text: qsTr("Relative") + translationManager.emptyString
            }
        }

        GridLayout {
            id: segregationHeightRow
            Layout.fillWidth: true
            Layout.topMargin: 17
            columns: 2
            columnSpacing: 32

            LibertyComponents.LineEdit {
                id: segregationHeightLine
                property bool edited: false
                Layout.fillWidth: true

                placeholderFontSize: 16
                labelFontSize: 14
                labelText: qsTr("Set segregation height:") + translationManager.emptyString
                validator: IntValidator { bottom: 0 }
                readOnly: false
                onEditingFinished: {
                    persistentSettings.segregationHeight = segregationHeightLine.text
                    if (appWindow.currentWallet) {
                        appWindow.currentWallet.segregationHeight(segregationHeightLine.text)
                    }

                    // @TODO: LineEdit should visually be able show that an action
                    // has been completed due to modification of the text
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }

    function onPageCompleted() {
        console.log("RingDB page loaded");
        appWindow.currentWallet.segregatePreForkOutputs(persistentSettings.segregatePreForkOutputs)
        appWindow.currentWallet.segregationHeight(persistentSettings.segregationHeight)
        segregationHeightLine.text = persistentSettings.segregationHeight
        appWindow.currentWallet.keyReuseMitigation2(persistentSettings.keyReuseMitigation2)
    }
}
