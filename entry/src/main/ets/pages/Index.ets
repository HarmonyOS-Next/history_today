import { HomeView } from './HomeView';
import { MineView } from './MineView';
import { AppStorageV2, mediaquery } from '@kit.ArkUI';
import { GlobalData } from './models';

@Entry
@ComponentV2
struct Index {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!

  @Local globalData: GlobalData = AppStorageV2.connect(GlobalData, () => new GlobalData())!

  listenerScreen = mediaquery.matchMediaSync('(orientation: landscape) and (device-type: tablet)')

  aboutToAppear() {
    this.listenerScreen.on('change', (mediaQueryResult) => {
      this.globalData.isLandscape = mediaQueryResult.matches
    })
  }


  build() {
    Navigation(this.pathStack){
      Tabs(){
        TabContent(){
          HomeView()
        }
        .tabBar({
          text: '首页',
          icon: $r('sys.media.AI_phone_doc'),
        })
        TabContent(){
          MineView()
        }
        .tabBar({
          text: '我的',
          icon: $r('sys.media.AI_panels'),
        })
      }
      .vertical(this.globalData.isLandscape)
      .barPosition(this.globalData.isLandscape ? BarPosition.Start : BarPosition.End)
      .layoutWeight(1)
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .navBarWidth('50%')
  }
}
