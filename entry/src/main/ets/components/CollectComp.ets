import { MyListItem } from '../components/MyListItem'
import { EventPageParams, HistoryEvent } from '../models'
import { collectUtil } from '../utils/CollectUtil'
import { AppStorageV2 } from '@kit.ArkUI'

@ComponentV2
export struct CollectComp {
  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!

  @Local list: HistoryEvent[] = []

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
      Text('已收藏事件')
        .fontWeight(500)
        .fontSize(18)
        .fontColor('#533F2E')
        .height(45)
        .width('100%')
        .textAlign(TextAlign.Center)


      List() {
        if (this.list.length === 0)  {
          ListItem(){
            Text('暂无收藏~')
              .height(60)
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
        }
        Repeat<HistoryEvent>(this.list)
          .each((item) => {
            ListItem() {
              MyListItem({ title: item.item.title, content: item.item.content })
                .onClick(() => {
                  this.pathStack?.pushPathByName('EventPage', { item: item.item, list: this.list, isCollectPage: true } as EventPageParams)
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