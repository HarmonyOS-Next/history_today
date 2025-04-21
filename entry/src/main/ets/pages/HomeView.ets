import { AppStorageV2, promptAction } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios'
import { AppBreakPoint, DayEvent, DayRes } from './models'


@ComponentV2
export struct HomeView {
  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!
  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!
  @Local selectedDate: Date = new Date()
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
      const url = `https://api-tanhua-harmony.itheima.net/api/events?month=${month}&date=${date}`
      const res = await axios.get<null, AxiosResponse<DayRes, null>>(url)
      this.dayEventList = res.data.data
    } catch (e) {
      promptAction.showDialog({ message: e.message })
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
          .fontColor('#0000FF')
          .fontSize(20)
          .onClick(() => {
            promptAction.closeCustomDialog(this.customDialogId)
            this.getData()
          })
      }
      .height(64)
    }
  }

  build() {
    Column() {
      Text('Days Matter')
        .height(60)
        .width('100%')
      Row({ space: 15 }) {
        Button('日期')
          .type(ButtonType.Normal)
          .borderRadius(8)
          .onClick(() => {
            this.showDatePicker()
          })
        Search({ placeholder: '搜索 Days Matter 的文章' })
          .searchButton('查找')
          .layoutWeight(1)
      }
      .height(56)
      .margin({ bottom: 4 })

      List() {
        Repeat<DayEvent>(this.dayEventList)
          .each((item) => {
            MyListItem({ title: item.item.title })
              .onClick(() => {
                this.pathStack?.pushPathByName('EventPage', item.item)
              })
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


@ComponentV2
struct MyListItem {
  @Param title: string = ''

  build() {
    ListItem() {
      Row() {
        Text(this.title)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .width(24)
          .aspectRatio(1)
          .fillColor('#999999')
      }
      .width('100%')
      .height(60)
    }
  }
}
