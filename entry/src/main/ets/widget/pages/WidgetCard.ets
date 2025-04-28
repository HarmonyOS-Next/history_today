@Entry
@Component
struct WidgetCard {
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'EntryAbility';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';

  build() {
    FormLink({
      action: this.actionType,
      abilityName: this.abilityName
    }) {
      Row() {
        Column() {
          Image($r('app.media.icon'))
            .width('75%')
            .aspectRatio(1)
        }
        .justifyContent(FlexAlign.Center)
        .width(this.fullWidthPercent)
      }
      .height(this.fullHeightPercent)
    }
  }
}