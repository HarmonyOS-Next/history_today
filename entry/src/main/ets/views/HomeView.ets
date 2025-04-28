import { AppStorageV2, promptAction } from '@kit.ArkUI'
import { MyListItem } from '../components/MyListItem'
import { AppBreakPoint, DayEvent } from '../models'
import { httpClient } from '../utils/HttpClient'


@ComponentV2
export struct HomeView {
  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!
  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!
  @Local selectedDate: Date = new Date()
  @Local keyword: string = ''
  @Local dayEventList: DayEvent[] = []
  customDialogId = 0

  async aboutToAppear(): Promise<void> {
    await this.getData()
    if (this.appBreakPoint.breakPoint === 'lg' && this.dayEventList[0]) {
      this.pathStack?.pushPathByName('EventPage', this.dayEventList[0])
    }
  }

  async getData() {
    try {
      const month = this.selectedDate.getMonth() + 1
      const date = this.selectedDate.getDate()
      const url = `events?month=${month}&date=${date}&title=${encodeURIComponent(this.keyword)}`
      const data = await httpClient.request<DayEvent[]>({ url })
      this.dayEventList = data
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
      Text($r('app.string.app_name'))
        .fontSize(18)
        .height(60)
        .width('100%')
        .fontWeight(500)
      Row({ space: 15 }) {
        Button('日期')
          .backgroundColor($r('app.color.main_color'))
          .type(ButtonType.Normal)
          .borderRadius(8)
          .onClick(() => {
            this.showDatePicker()
          })
        Search({ placeholder: '搜索 Today In History 的文章', value: this.keyword })
          .searchButton('查找', {
            fontColor: $r('app.color.main_color')
          })
          .layoutWeight(1)
          .onSubmit((value) => {
            this.keyword = value
            this.getData()
          })
      }
      .height(56)
      .margin({ bottom: 4 })

      List() {
        Repeat<DayEvent>(this.dayEventList)
          .each((item) => {
            ListItem(){
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
    .padding({ left: 15, right: 15 })
    .width('100%')
    .height('100%')
  }
}
