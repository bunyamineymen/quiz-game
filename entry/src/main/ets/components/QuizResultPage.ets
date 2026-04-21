import { PreferencesUtil } from '../utils/PreferencesUtil';
import { ThemeUtil } from '../utils/ThemeUtil';

@Component
export struct QuizResultPage {
  @Prop quizScore: number;
  @Prop totalQuestions: number;
  private preferencesUtil: PreferencesUtil = PreferencesUtil.getInstance();
  @State isDarkMode: boolean = false;
  private onQuizFinish?: (score: number) => void;

  aboutToAppear() {
    this.isDarkMode = this.preferencesUtil.getDarkModePreference(this.getUIContext().getHostContext() as Context);
  }

  private getPerformanceMessage(): string {
    if (this.totalQuestions === 0) return "Done!";
    const percentage = (this.quizScore / this.totalQuestions) * 100;
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
    Scroll() {
      Column({ space: 16 }) {
        Text('Quiz Result')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isDarkMode ? '#ffffff' : '#000000')
          .alignSelf(ItemAlign.Center)
          .margin({ top: 24, bottom: 8 })

        Text(`Success Rate: %${this.totalQuestions > 0 ? Math.round((this.quizScore / this.totalQuestions) * 100) : 0}`)
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
          .fontSize(14)
          .backgroundColor(ThemeUtil.getButtonStyle(this.isDarkMode).backgroundColor)
          .fontColor(ThemeUtil.getButtonStyle(this.isDarkMode).fontColor)
          .borderRadius(25)
          .padding({ left: 20, right: 20, top: 10, bottom: 10 })
          .margin({ top: 20, bottom: 24 })
          .onClick(() => {
            if (this.onQuizFinish) {
              this.onQuizFinish(this.quizScore);
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
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
  }
}
