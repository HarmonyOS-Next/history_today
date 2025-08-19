import { preferences } from '@kit.ArkData';
import { HistoryEvent } from '../models';

class CollectUtil {

  private store?: preferences.Preferences

  getStore() {
    if (!this.store) {
      const ctx = getContext()
      this.store = preferences.getPreferencesSync(ctx, { name: 'collect-store' })
    }
    return this.store
  }

  add (item: HistoryEvent) {
    this.getStore().putSync(item.id.toString(), item)
    this.getStore().flushSync()
  }

  del (item: HistoryEvent) {
    this.getStore().deleteSync(item.id.toString())
    this.getStore().flushSync()
  }

  all () {
    const data = this.getStore().getAllSync()
    const values = Object.values(data) as HistoryEvent[]
    return values
  }


}

export const collectUtil = new CollectUtil()