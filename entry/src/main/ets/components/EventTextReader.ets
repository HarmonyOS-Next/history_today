import { ReadStateCode, TextReader, TextReaderIcon } from '@kit.SpeechKit';
import { HistoryEvent } from '../models';
import { image } from '@kit.ImageKit';


@ComponentV2
export struct EventTextReader {
  @Param @Require eventId: string
  @Param list: HistoryEvent[] = []
  @Local readState: ReadStateCode = ReadStateCode.WAITING

  readList: TextReader.ReadInfo[] = []

  async init() {
    const ctx = this.getUIContext().getHostContext()!
    const imgBuffer = await ctx.resourceManager.getMediaContent($r('app.media.icon'))
    const imageSource = image.createImageSource(imgBuffer.buffer);
    const imagePixelMap = await imageSource.createPixelMap()
    await imageSource.release()

    const initParam: TextReader.ReaderParam = {
      isVoiceBrandVisible: true,
      businessBrandInfo: {
        panelName: '历史上的今天',
        panelIcon: $r('app.media.icon')
      },
      keepBackgroundRunning: true
    }

    await TextReader.init(ctx, initParam)

    TextReader.on('stateChange', (state: TextReader.ReadState) => {
      if (this.eventId === state.id) {
        this.readState = state.state
      } else {
        this.readState = ReadStateCode.WAITING
      }
    })

    TextReader.on('requestMore', () => {
      TextReader.loadMore([], true)
    })

    this.readList = this.list.map(item => {
      return {
        id: item.id.toString(),
        title: { text: item.title, isClickable: false },
        author: { text: '', isClickable: false },
        date: { text: '', isClickable: false },
        image:  imagePixelMap,
        bodyInfo: item.content
      } as TextReader.ReadInfo
    })
  }

  aboutToAppear(): void {
    this.init()
  }

  aboutToDisappear(): void {
    TextReader.release()
  }

  build() {
    TextReaderIconV2({ readState: this.readState })
      .width(32)
      .aspectRatio(1)
      .onClick(async () => {
          await TextReader.start(this.readList, this.eventId)
      })
  }
}


@Component
struct TextReaderIconV2 {
  @Prop readState: ReadStateCode = ReadStateCode.WAITING

  build() {
    TextReaderIcon({ readState: this.readState })
  }
}