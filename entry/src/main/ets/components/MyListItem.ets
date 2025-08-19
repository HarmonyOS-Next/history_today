@ComponentV2
export struct MyListItem {
  @Param title: string = ''
  @Param content: string = ''

  build() {
    Row() {
      Column({ space: 10 }){
        Text(this.title)
          .fontWeight(500)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.content)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(14)
          .fontColor('#999')
          .lineHeight(20)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(24)
        .aspectRatio(1)
        .fillColor('#999999')
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
  }
}
