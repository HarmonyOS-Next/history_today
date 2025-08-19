import { AppStorageV2, promptAction } from '@kit.ArkUI'
import { MyListItem } from '../components/MyListItem'
import { AppBreakPoint, EventPageParams, HistoryEvent } from '../models'
import { SearchUtil } from '../utils/SearchUtil'


@ComponentV2
export struct HomeView {
  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!
  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!
  @Local selectedDate: Date = new Date()
  @Local keyword: string = ''
  @Local dayEventList: HistoryEvent[] = []
  customDialogId = 0

  async aboutToAppear(): Promise<void> {
    await this.getData()
    if (this.appBreakPoint.breakPoint === 'lg' && this.dayEventList[0]) {
      this.pathStack?.pushPathByName('EventPage', this.dayEventList[0])
    }
  }

  async getData() {
    try {
      // const month = this.selectedDate.getMonth() + 1
      // const date = this.selectedDate.getDate()
      // const url = `events?month=${month}&date=${date}&title=${encodeURIComponent(this.keyword)}`
      // const data = await httpClient.request<DayEvent[]>({ url })
      const ctx = this.getUIContext().getHostContext()!
      const result = await SearchUtil.getInstance(ctx).getData({
        month: `${this.selectedDate.getMonth() + 1}`,
        date: `${this.selectedDate.getDate()}`,
        keyword: this.keyword
      })
      if (result) {
        this.dayEventList = result.events
      }
    } catch (e) {
      promptAction.showDialog({ message: e.message || '获取数据失败' })
    }
  }

  async showDatePicker() {
    this.customDialogId = await promptAction.openCustomDialog({
      builder: () => {
        this.DatePickerBuilder()
      }
    })
  }

  @Builder
  DatePickerBuilder() {
    Column() {
      Text('选择日期')
        .height(64)
        .fontSize(20)
        .fontWeight(500)
      DatePicker({
        selected: $$this.selectedDate
      })
      Row({ space: 80 }) {
        Text('取消')
          .fontColor('#999999')
          .fontSize(20)
          .onClick(() => promptAction.closeCustomDialog(this.customDialogId))
        Text('确认')
          .fontColor($r('app.color.main_color'))
          .fontSize(20)
          .onClick(() => {
            promptAction.closeCustomDialog(this.customDialogId)
            this.keyword = ''
            this.getData()
          })
      }
      .height(64)
    }
  }

  build() {
    Column() {
      Row({ space: 15 }) {
        Image($r('app.media.icon'))
          .width(36)
          .borderRadius(18)
        Search({ placeholder: '请输入关键字~', value: this.keyword })
          .placeholderFont({ size: 14 })
          .searchButton('查找', {
            fontColor: $r('app.color.main_color')
          })
          .height(36)
          .layoutWeight(1)
          .onSubmit((value) => {
            this.keyword = value
            this.getData()
          })
        Image($r('sys.media.calendar_badge_play'))
          .width(24)
          .onClick(() => {
            this.showDatePicker()
          })
      }
      .height(56)
      .margin({ bottom: 4 })

      List() {
        Repeat<HistoryEvent>(this.dayEventList)
          .each((item) => {
            ListItem(){
              MyListItem({ title: item.item.title, content: item.item.content })
                .onClick(() => {
                  this.pathStack?.pushPathByName('EventPage', { item: item.item, list: this.dayEventList, isCollectPage: false } as EventPageParams)
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
    .padding({ left: 15, right: 15 })
    .width('100%')
    .height('100%')
  }
}
