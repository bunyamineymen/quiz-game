import { Question, QuizResult } from '../models/Question';
import { QuizViewModel } from '../viewmodels/QuizViewModel';
import { ThemeUtil } from '../utils/ThemeUtil';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Component
export struct QuizPage {
  private quizViewModel: QuizViewModel = QuizViewModel.getInstance();
  private preferencesUtil: PreferencesUtil = PreferencesUtil.getInstance();
  private onBackToTopics?: () => void;
  private onShowResult?: (score: number) => void;

  @Prop topic: string = '';
  @State questions: Question[] = [];
  @State userAnswers: number[] = [];
  @State currentQuestionIndex: number = 0;
  private isQuizCompleted: boolean = false;
  private quizResult: QuizResult | null = null;
  @State isDarkMode: boolean = false;

  aboutToAppear() {
    this.initQuiz();
  }

  private initQuiz() {
    if (this.topic) {
      this.questions = this.quizViewModel.getQuestionsForTopic(this.topic);
      this.userAnswers = new Array(this.questions.length).fill(-1);
      this.isDarkMode = this.preferencesUtil.getDarkModePreference(this.getUIContext().getHostContext() as Context);
      this.currentQuestionIndex = 0;
      this.isQuizCompleted = false;
      this.quizResult = null;
    }
  }

  private selectAnswer(answerIndex: number) {
    this.userAnswers[this.currentQuestionIndex] = answerIndex;

    setTimeout(() => {
      if (this.currentQuestionIndex < this.questions.length - 1) {
        this.currentQuestionIndex++;
      } else {
        this.finishQuiz();
      }
    }, 300);
  }

  private finishQuiz() {
    this.quizResult = this.quizViewModel.calculateResult(this.topic, this.userAnswers);
    console.info(this.quizResult.score.toString())
    this.isQuizCompleted = true;
    if (this.onShowResult) {
      this.onShowResult(this.quizResult.score);
    }
  }


  private getCurrentQuestion(): Question | null {
    return this.currentQuestionIndex < this.questions.length ?
    this.questions[this.currentQuestionIndex] : null;
  }


  build() {
    Column() {
        Text(`${this.currentQuestionIndex + 1}/${this.questions.length}`)
          .fontSize(8)
          .fontColor(this.isDarkMode ? '#cccccc' : '#666666')
          .margin({ top: 20, bottom: 20 })
          .alignSelf(ItemAlign.Center)

        if (this.getCurrentQuestion()) {
          Column() {
            Text(this.getCurrentQuestion()!.question)
              .fontSize(12)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isDarkMode ? '#ffffff' : '#000000')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 12 })
              .padding({ left: 20, right: 20 })

            Column({ space: 8 }) {
              ForEach(this.getCurrentQuestion()!.options, (option: string) => {
                Button(option)
                  .width('90%')
                  .height(30)
                  .fontSize(8)
                  .fontColor(this.isDarkMode ? '#ffffff' : '#000000')
                  .backgroundColor(this.isDarkMode ? '#333333' : '#f8f9fa')
                  .borderRadius(16)
                  .border({
                    width: 2,
                    color: this.isDarkMode ? '#555555' : '#e9ecef'
                  })
                  .onClick(() => {
                    const index = this.getCurrentQuestion()!.options.indexOf(option);
                    this.selectAnswer(index);
                  })
              },(option: string) => option)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
  }
}