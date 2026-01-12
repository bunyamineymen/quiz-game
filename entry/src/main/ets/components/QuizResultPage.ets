import { PreferencesUtil } from '../utils/PreferencesUtil';
import { ThemeUtil } from '../utils/ThemeUtil';

@Component
export struct QuizResultPage {
  @Prop quizResult: number;
  private preferencesUtil: PreferencesUtil = PreferencesUtil.getInstance();
  @State isDarkMode: boolean = false;
  private onQuizFinish?: (quizResult: number) => void;

  aboutToAppear() {
    this.isDarkMode = this.preferencesUtil.getDarkModePreference(this.getUIContext().getHostContext() as Context);
  }

  private getPerformanceMessage(): string {
    const percentage = this.quizResult*10;
    if (percentage >= 90) {
      return 'Excellent! 🏆'
    };
    if (percentage >= 80) {
      return 'Very good! 🌟'
    };
    if (percentage >= 70) {
      return 'Good! 👍'
    };
    if (percentage >= 60) {
      return 'Not bad! 💪'
    };
    if (percentage >= 50) {
      return 'You can do better! 📚'
    };
    return "Don't give up! 🎯";
  }

  build() {
    Column({ space: 16 }) {
      Text('Quiz Result')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
        .alignSelf(ItemAlign.Center)
        .margin({ top: 24, bottom: 8 })

      Text(`Success Rate: %${this.quizResult*10}`)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.isDarkMode
          ? ThemeUtil.getButtonStyle(true).fontColor
          : ThemeUtil.getButtonStyle(false).fontColor
        )
        .alignSelf(ItemAlign.Center)

      Text(this.getPerformanceMessage())
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.isDarkMode ? '#4caf50' : '#007bff')
        .margin({ top: 12 })
        .alignSelf(ItemAlign.Center)

      Button('Back to Topics')
        .fontSize(12)
        .backgroundColor(ThemeUtil.getButtonStyle(this.isDarkMode).backgroundColor)
        .fontColor(ThemeUtil.getButtonStyle(this.isDarkMode).fontColor)
        .borderRadius(25)
        .padding({ left: 20, right: 20, top: 10, bottom: 10 })
        .margin({ top: 20 })
        .onClick(() => {
          if (this.onQuizFinish) {
            this.onQuizFinish(this.quizResult);
          }
        })
        .shadow({
          radius: 8,
          color: ThemeUtil.getButtonStyle(this.isDarkMode).shadowColor,
          offsetX: 0,
          offsetY: 2
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
