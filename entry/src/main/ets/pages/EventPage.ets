import { DayEvent } from "../models"
import { curves, promptAction } from "@kit.ArkUI"
import { collectUtil } from "../utils/CollectUtil"

@Builder
export function EventPageBuilder() {
  EventPage()
}

@ComponentV2
struct EventPage {
  pathStack: NavPathStack = new NavPathStack()

  @Local dayEvent: DayEvent = new DayEvent()

  @Local angle: number = 22.5

  @Local isCollected: boolean = false

  build() {
    NavDestination() {
      Column(){
        List({ space: 15 }){
          ListItem(){
            Text(this.dayEvent.title)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontWeight(500)
              .fontSize(20)
          }
          ListItem(){
            Row({ space: 15 }){
              Text(this.dayEvent.time)
                .textAlign(TextAlign.Center)
                .fontColor('#999999')
              if (!this.isCollected) {
                Text('收藏')
                  .fontColor($r('app.color.main_color'))
                  .onClick(() => {
                    collectUtil.add(this.dayEvent)
                    this.isCollected = true
                    promptAction.showToast({ message: '收藏成功' })
                  })
              }
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
          }
          ListItem(){
            Text(this.dayEvent.content)
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
      const param = context.pathInfo.param as DayEvent
      this.dayEvent = param
      const collectedList = collectUtil.all()
      this.isCollected = collectedList.findIndex(item => item.id === this.dayEvent.id) > -1
    })
  }
}