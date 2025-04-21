import { HomeView } from './HomeView';
import { MineView } from './MineView';
import { AppStorageV2, mediaquery } from '@kit.ArkUI';
import { AppBreakPoint } from './models';

@Entry
@ComponentV2
struct Index {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!

  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!

  listenerScreen = mediaquery.matchMediaSync('(orientation: landscape) and (device-type: tablet)')

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
      .vertical(this.appBreakPoint.breakPoint === 'lg')
      .barPosition(this.appBreakPoint.breakPoint === 'lg' ? BarPosition.Start : BarPosition.End)
      .layoutWeight(1)
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .mode(NavigationMode.Auto)
    .navBarWidth('50%')
  }
}
