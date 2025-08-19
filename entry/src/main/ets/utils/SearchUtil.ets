import { HistoryEventJson, SearchParams } from "../models";
import util from '@ohos.util';

export class SearchUtil {

  private static instance?: SearchUtil

  private context: Context

  static getInstance (context: Context) {
    if (!SearchUtil.instance) {
      SearchUtil.instance = new SearchUtil(context)
    }
    return SearchUtil.instance
  }

  constructor(context: Context) {
    this.context = context
  }

  async getData (params: SearchParams): Promise<HistoryEventJson | null> {
    try {
      // 格式化月份和日期为两位数，例如 1 -> 01
      const formattedMonth = params.month.padStart(2, '0');
      const formattedDate = params.date.padStart(2, '0');
      
      // 构建文件名，例如 0101.json
      const fileName = `${formattedMonth}${formattedDate}.json`;
      
      // 获取资源管理器
      const resourceManager = this.context.resourceManager;
      
      // 从 rawfile 中读取文件内容
      const fileData = await resourceManager.getRawFileContent(fileName);
      
      // 将 Uint8Array 转换为字符串
      const textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
      const jsonString = textDecoder.decode(fileData);
      
      // 解析 JSON 数据
      const jsonData: HistoryEventJson = JSON.parse(jsonString);

      if (params.keyword) {
        const events = jsonData.events.filter(item => item.title.includes(params.keyword))
        jsonData.events = events
      }

      return jsonData;
    } catch (error) {
      console.error('读取历史事件数据失败:', error);
      return null;
    }
  }
}
