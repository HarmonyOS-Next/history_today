import { MyListItem } from '../components/MyListItem'
import { AppStorageV2, promptAction } from '@kit.ArkUI'
import { AppBreakPoint } from '../models'
import { CollectComp } from '../components/CollectComp'

@ComponentV2
export struct MineView {

  pathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!

  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!


  build() {
    Column(){
      Row({ space: 10 }){
        Image($r('app.media.icon'))
          .width(60)
          .aspectRatio(1)
          .borderRadius(30)

        Column({ space: 10 }){
          Text('版本号：1.0.0')
            .fontColor('#999999')
          Text('联系我：zhousg1007@qq.com')
            .fontColor('#999999')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .padding({ left: 15, right: 15 })
      .height(100)
      .width('100%')
      .border({
        width: { bottom: 0.5 },
        color: '#E4E4E4'
      })

      if (this.appBreakPoint.breakPoint !== 'lg') {
        CollectComp()
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