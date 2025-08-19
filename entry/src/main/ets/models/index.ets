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

// 数据库模型
export interface HistoryEvent {
  id: number;
  title: string;
  year: string;
  month: string;
  date: string;
  content: string;
}

export interface HistoryEventJson {
  data: string
  events: HistoryEvent[]
  event_count: number
}

export interface SearchParams {
  month: string
  date: string,
  keyword: string
}

export interface EventPageParams {
  item: HistoryEvent,
  list: HistoryEvent[],
  isCollectPage: boolean
}