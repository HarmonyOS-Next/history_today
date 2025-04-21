@ObservedV2
export class GlobalData {
  @Trace
  isLandscape: boolean = false
}

export class DayEvent {
  time: string = ''
  content: string = ''
  title: string = ''
  id: string = ''
}

export class DayRes {
  data: DayEvent[] = []
}