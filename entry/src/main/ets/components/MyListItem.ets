@ComponentV2
export struct MyListItem {
  @Param title: string = ''

  build() {
    Row() {
      Text(this.title)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(24)
        .aspectRatio(1)
        .fillColor('#999999')
    }
    .width('100%')
    .height(60)
  }
}
