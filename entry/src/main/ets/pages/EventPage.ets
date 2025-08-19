import { DayEvent, EventPageParams, HistoryEvent } from "../models"
import { curves, promptAction } from "@kit.ArkUI"
import { collectUtil } from "../utils/CollectUtil"
import { ReadStateCode, TextReaderIcon } from "@hms.ai.textReader"
import { EventTextReader } from "../components/EventTextReader"

@Builder
export function EventPageBuilder() {
  EventPage()
}

@ComponentV2
struct EventPage {
  pathStack: NavPathStack = new NavPathStack()

  @Local dateEvent: HistoryEvent = {} as HistoryEvent
  @Local dateEventList: HistoryEvent[] = []

  @Local angle: number = 22.5

  @Local isCollected: boolean = false

  @Local readState: ReadStateCode = ReadStateCode.WAITING

  @Local isCollectPage: boolean = false



  build() {
    NavDestination() {
      Column(){
        List({ space: 15 }){
          ListItem(){
            Row({ space: 15 }){
              Column({ space: 15 }){
                Text(this.dateEvent.title)
                  .width('100%')
                  .fontWeight(500)
                  .fontSize(20)
                Row({ space: 15 }){
                  Text(this.dateEvent.year + '-' + this.dateEvent.month + '-' +this.dateEvent.date)
                    .textAlign(TextAlign.Center)
                    .fontColor('#999999')
                  if (!this.isCollected) {
                    Text('收藏')
                      .fontColor($r('app.color.main_color'))
                      .onClick(() => {
                        collectUtil.add(this.dateEvent)
                        this.isCollected = true
                        promptAction.showToast({ message: '收藏成功' })
                      })
                  }
                  if (this.isCollectPage && this.isCollected) {
                    Text('取消收藏')
                      .fontColor($r('app.color.main_color'))
                      .onClick(() => {
                        collectUtil.del(this.dateEvent)
                        this.isCollected = false
                        promptAction.showToast({ message: '取消收藏成功' })
                      })
                  }
                }
                .width('100%')
              }
              .layoutWeight(1)
              EventTextReader({ eventId: this.dateEvent.id?.toString(), list: this.dateEventList })
            }
          }
          ListItem(){
            Text(this.dateEvent.content)
              .fontColor('#333333')
              .lineHeight(24)
          }
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
      }
      .padding(15)
      .width('100%')
      .height('100%')
      .rotate({
        angle: this.angle,
      })
      .transform({
        origin: 'left bottom'
      })
      .animation({
        duration: 500,
        curve: curves.springMotion()
      })
      .onAppear(() => {
        this.angle = 0
      })
    }
    .title('')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      const param = context.pathInfo.param as EventPageParams
      this.dateEvent = param.item
      this.dateEventList = param.list
      this.isCollectPage = param.isCollectPage
      const collectedList = collectUtil.all()
      this.isCollected = collectedList.findIndex(item => item.id === this.dateEvent.id) > -1
    })
  }
}
