import QtQuick 2.2
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
import io.thp.pyotherside 1.5

SilicaFlickable {

    property int detail_list_length: item_array[8].length
    property int check_list_length: item_array[9].length
    contentHeight: contentColumn.height
    function fill_models() {
        for (var i = 0; i < item_array[2].length; ++i) {
            picture_urls.append({
                                    "image_url": item_array[2][i]
                                })
        }

        for (var i = 0; i < item_array[8].length; ++i) {
            detail_item_list.append({
                                        "detail_description": item_array[8][i][1],
                                        "detail_content": item_array[8][i][0]
                                    })
        }

        for (var i = 0; i < item_array[9].length; ++i) {
            check_grid_model.append({
                                        "check_grid_item": item_array[9][i]
                                    })
        }
    }
    //for loader qml -> requires following array with name "item_array"
    //[[username, userinfo], [big_pics, .. , big_pics], [small_pics, .., small_pics], heading, price, zip, date, views, [[detaillistright, detaillistleft], .., [detaillistright, detaillistleft]], [checktags, .. , checktags], text, link]
    //          0                       1                               2                3      4       5   6       7                                       8                                                           9         10    11

    //TODO datei umbenennen ist keine Silivaview sondern flickable
    //anchors.fill: parent

    //TODO schauen ob nicht verfügbar mehr
Column {
    id: contentColumn
    x: Theme.horizontalPageMargin
    width: parent.width - 2*Theme.horizontalPageMargin
    spacing: Theme.paddingMedium

    Label {
      id: marginTop
      width: parent.width
      height: Theme.paddingLarge * 1.5
    }

    SlideshowView {
        id: pic_carussel
        height: pic_carussel.width
        width: parent.width
        clip: true

        model: ListModel {
            id: picture_urls
        }

        delegate: Image {
            id: image_item
            source: image_url

            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("PictureCarussel.qml"), {
                                       "big_pic_urls": item_array[1],
                                       "current_index": pic_carussel.currentIndex
                                   })
                }
            }
        }

        visible: item_array[2].length > 0 ? true : false
    }


    /*Icon {
            source: "image://theme/icon-m-arrow-left-green"

        anchors {
            //verticalCenter: pic_carussel.verticalCenter
            left: parent.left + Theme.paddingLarge


        }

color: "black"

        }*/
    Item {
        id: item_details
        height: heading.height + price.height + zip.height
        width: parent.width

        Label {
            id: heading
            width: parent.width
            text: item_array[3]
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.highlightColor
            wrapMode: Text.WordWrap
        }

        Label {
            id: price
            text: item_array[4]
            anchors.top: heading.bottom
            anchors.right: parent.right
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
        }

        /* // views are empty in python script
        Label {
            id: views
            text: item_array[7] + " " + qsTr("Views")
            anchors.bottom: price.bottom
            anchors.left: parent.left
            anchors.topMargin: Theme.paddingSmall
            font.pixelSize: Theme.fontSizeSmall
        }*/

        Label {
            id: date
            text: item_array[6]
            anchors.bottom: price.bottom
            font.pixelSize: Theme.fontSizeSmall
        }

        Label {
            id: zip
            text: item_array[5]
            anchors.top: price.bottom
            font.pixelSize: Theme.fontSizeSmall
            width: parent.width
            truncationMode: TruncationMode.Fade

        }
    }

    SectionHeader {
        id: section_header_details
        text: qsTr("Details")
        visible: detail_list_length > 0 ? true : false
    }

    SilicaListView {
        id: detail_list
        width: parent.width

        height: Theme.itemSizeSmall / 1.15 * detail_list_length
        interactive: false

        model: ListModel {
            id: detail_item_list
        }

        delegate: DetailItem {
            id: detail_item
            height: Theme.itemSizeSmall / 1.15
            label: detail_description
            value: detail_content
        }

    }

    SectionHeader {
        id: section_header_checklist
        text: qsTr("Features")
        visible: check_list_length > 0 ? true : false
    }

    SilicaListView {
        id: check_grid
        width: parent.width
        height: check_list_length * Theme.itemSizeExtraSmall / 1.5
        spacing: Theme.paddingSmall
        interactive: false

        model: ListModel {
            id: check_grid_model
        }

        delegate: Label {
                id: gridLabel
                text: check_grid_item
                width: parent.width
                height: Theme.itemSizeExtraSmall / 1.5
                wrapMode: Text.WordWrap
        }
    }

    SectionHeader {
        id: section_header_description
        text: qsTr("Description")
    }


    Label {
        id: text
        width: parent.width
        text: item_array[10]
        wrapMode: Text.Wrap
    }


    SectionHeader {
        id: section_header_footer
        text: qsTr("Info")
    }

    Label {
        id: userinfo
        width: parent.width
        text: {
            if(item_array[0][0] == "")
                item_array[0][1]
            else
                item_array[0][0] + ": " + item_array[0][1]
        }
        wrapMode: Text.WordWrap
    }

    Label {
      id: marginBottom
      width: parent.width
      height: Theme.paddingLarge
    }
}

    PullDownMenu {

        MenuItem {
            text: qsTr("Open item in Browser")
            onClicked: {
                //pageStack.push(Qt.resolvedUrl("WebView.qml"), {itemUrl: item_array[11]})
                Qt.openUrlExternally(item_array[11])
            }
        }
    }

    VerticalScrollDecorator {}

    Component.onCompleted: {
        fill_models()
        pageStack.pushAttached(Qt.resolvedUrl("WebView.qml"), {
                                   "itemUrl": item_array[11]
                               })

    }
}