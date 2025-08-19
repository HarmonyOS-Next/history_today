import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { AppBreakPoint } from '../models';
import { WindowManager } from '@kit.SpeechKit';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  // 根据当前窗口尺寸更新断点
  updateBreakpoint(windowWidth: number) :void{
    // 将长度的单位由px换算为vp
    const windowWidthVp = px2vp(windowWidth)
    let breakPoint: string = 'sm'
    if (windowWidthVp < 320) {
      breakPoint = 'xs'
    } else if (windowWidthVp < 600) {
      breakPoint = 'sm'
    } else if (windowWidthVp < 840) {
      breakPoint = 'md'
    } else {
      breakPoint = 'lg'
    }
    const app = AppStorageV2.connect(AppBreakPoint, () => new AppBreakPoint())!
    app.breakPoint = breakPoint // 将断点值存入到全局状态
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 计算断点
    windowStage.getMainWindow().then((win) => {
      // 获取应用启动时的窗口尺寸
      this.updateBreakpoint(win.getWindowProperties().windowRect.width)
      // 注册回调函数，监听窗口尺寸变化
      win.on('windowSizeChange', (windowSize)=>{
        this.updateBreakpoint(windowSize.width)
      })
    });

    // 朗读控件
    WindowManager.setWindowStage(windowStage)

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
