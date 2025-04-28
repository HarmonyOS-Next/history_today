import { AppBreakPoint } from '../models'
import { CollectView } from '../views/CollectView'
import { AppStorageV2 } from '@kit.ArkUI'

@Builder
export function CollectPageBuilder() {
  CollectPage()
}

@ComponentV2
struct CollectPage {
  pathStack: NavPathStack = new NavPathStack()

  appBreakPoint: AppBreakPoint = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!

  build() {
    NavDestination() {
      CollectView()
    }
    .title('')
    .hideBackButton(this.appBreakPoint.breakPoint === 'lg' ? true : false)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}