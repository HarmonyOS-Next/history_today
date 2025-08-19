import { HomeView } from '../views/HomeView';
import { MineView } from '../views/MineView';
import { AppStorageV2, mediaquery } from '@kit.ArkUI';
import { AppBreakPoint } from '../models';

@Entry
@ComponentV2
struct Index {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, () => new NavPathStack())!
  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!
  listenerScreen = mediaquery.matchMediaSync('(orientation: landscape) and (device-type: tablet)')
  @Local activeIndex: number = 0

  @Builder
  TabBarBuilder(text: string, icon: Resource, index: number) {
    Column({ space: 4 }) {
      Image(icon)
        .width(24)
        .aspectRatio(1)
        .fillColor(index === this.activeIndex ? $r('app.color.main_color') : '#CCCCCC')
      Text(text)
        .fontSize(12)
        .fontColor(index === this.activeIndex ? $r('app.color.main_color') : '#CCCCCC')
    }
  }

  build() {
    Navigation(this.pathStack) {
      Tabs({ index: this.activeIndex }) {
        TabContent() {
          HomeView()
        }
        .tabBar(this.TabBarBuilder('首页', $r('app.media.ic_public_home'), 0))

        TabContent() {
          MineView()
        }
        .tabBar(this.TabBarBuilder('我的', $r('app.media.ic_public_mine'), 1))
      }
      .vertical(this.appBreakPoint.breakPoint === 'lg')
      .barPosition(this.appBreakPoint.breakPoint === 'lg' ? BarPosition.Start : BarPosition.End)
      .layoutWeight(1)
      .onTabBarClick(i => {
        this.activeIndex = i
      })
      .onChange(() => {
        if (this.activeIndex === 0) {
          if (this.appBreakPoint.breakPoint === 'lg') {
            const collectIndex = this.pathStack.getIndexByName('CollectPage')
            this.pathStack.popToIndex(collectIndex[0] - 1)
          }
        }
      })
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .mode(NavigationMode.Auto)
    .navBarWidth('50%')
  }
}
