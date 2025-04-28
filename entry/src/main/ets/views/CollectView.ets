import { MyListItem } from "../components/MyListItem"
import { DayEvent } from "../models"
import { collectUtil } from "../utils/CollectUtil"
import { AppStorageV2 } from "@kit.ArkUI"

@ComponentV2
export struct CollectView {
  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!

  @Local list: DayEvent[] = []

  aboutToAppear(): void {
    this.list = collectUtil.all()
    collectUtil.getStore().on('change', () => {
      this.list = collectUtil.all()
    })
  }

  aboutToDisappear(): void {
    collectUtil.getStore().off('change')
  }

  build() {
    Column() {
      Text('已收藏文章')
        .fontWeight(500)
        .fontSize(18)
        .fontColor('#533F2E')
        .height(60)
        .width('100%')
        .textAlign(TextAlign.Center)


      List() {
        Repeat<DayEvent>(this.list)
          .each((item) => {
            ListItem() {
              MyListItem({ title: item.item.title })
                .onClick(() => {
                  this.pathStack?.pushPathByName('EventPage', item.item)
                })
            }
          })
      }
      .scrollBar(BarState.Off)
      .divider({
        strokeWidth: 0.5,
        color: '#E4E4E4'
      })
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .padding(15)
    .width('100%')
    .height('100%')
  }
}