@ObservedV2
export class AppBreakPoint {
  @Trace
  breakPoint: string = 'sm'
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