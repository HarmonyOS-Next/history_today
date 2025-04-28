import { MyListItem } from '../components/MyListItem'
import { AppStorageV2, promptAction } from '@kit.ArkUI'
import { AppBreakPoint } from '../models'
import { CollectView } from '../views/CollectView'

@ComponentV2
export struct MineView {

  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!

  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!


  build() {
    Column(){
      Column(){
        Text($r('app.string.app_name'))
          .fontSize(18)
          .height(60)
          .width('100%')
          .fontWeight(500)

        Image($r('app.media.icon'))
          .width(100)
          .aspectRatio(1)
        Text('版本号：1.0.0')
          .height(36)
          .fontColor('#999999')

        MyListItem({ title: '反馈建议' })
          .border({ width: { bottom: 0.5 }, color: '#E4E4E4' })
          .onClick(() => {
            promptAction.showDialog({
              title: '建议反馈',
              message: '如您对本元服务有任何意见，您可以通过发送邮件的方式与我们联系、咨询、投诉或举报，邮箱地址【zhousg1007@qq.com】'
            })
          })
      }
      .padding({ left: 15, right: 15 })

      if (this.appBreakPoint.breakPoint !== 'lg') {
        CollectView()
          .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .onVisibleAreaChange([0, 1], (isVisible) => {
      if (isVisible) {
        if (this.appBreakPoint.breakPoint === 'lg') {
          this.pathStack?.pushPathByName('CollectPage', null)
        }
      }
    })
  }
}