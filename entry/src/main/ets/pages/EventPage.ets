import { DayEvent } from "./models"
import { curves } from "@kit.ArkUI"

@Builder
export function EventPageBuilder() {
  EventPage()
}

@ComponentV2
struct EventPage {
  pathStack: NavPathStack = new NavPathStack()

  @Local dayEvent: DayEvent = new DayEvent()

  @Local angle: number = 22.5

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
            Text(this.dayEvent.time)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontColor('#999999')
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
    })
  }
}