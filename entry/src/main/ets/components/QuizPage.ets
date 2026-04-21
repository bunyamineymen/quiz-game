import { Question, QuizResult } from '../models/Question';
import { QuizViewModel } from '../viewmodels/QuizViewModel';
import { ThemeUtil } from '../utils/ThemeUtil';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { HapticUtil } from '../utils/HapticUtil';
import { HistoryUtil } from '../utils/HistoryUtil';
import { AudioUtil } from '../utils/AudioUtil';
import { HealthUtil } from '../utils/HealthUtil';
import { common } from '@kit.AbilityKit';

@Component
export struct QuizPage {
  private quizViewModel: QuizViewModel = QuizViewModel.getInstance();
  private preferencesUtil: PreferencesUtil = PreferencesUtil.getInstance();
  private onBackToTopics?: () => void;
  private onShowResult?: (score: number) => void;

  @Prop topic: string = '';
  @Prop difficulty: string = 'Easy';
  @State questions: Question[] = [];
  @State userAnswers: number[] = [];
  @State currentQuestionIndex: number = 0;
  private isQuizCompleted: boolean = false;
  private quizResult: QuizResult | null = null;
  @State isDarkMode: boolean = false;

  @State timeLeft: number = 15;
  private timerId: number = -1;
  @State selectedOptionIndex: number = -1;
  @State showFeedback: boolean = false;
  @State heartRate: number = 0;

  aboutToAppear() {
    this.initQuiz();
  }

  private async initQuiz() {
    if (this.topic) {
      await this.quizViewModel.initRdb(this.getUIContext().getHostContext() as common.UIAbilityContext);
      this.questions = await this.quizViewModel.getQuestionsForTopic(this.topic, this.difficulty);
      this.userAnswers = new Array(this.questions.length).fill(-1);
      this.isDarkMode = this.preferencesUtil.getDarkModePreference(this.getUIContext().getHostContext() as Context);
      this.currentQuestionIndex = 0;
      this.isQuizCompleted = false;
      this.quizResult = null;
      this.startTimer();
    }
  }

  private async startTimer() {
    this.timeLeft = 15;
    this.heartRate = await HealthUtil.getMockHeartRate();
    this.timerId = setInterval(() => {
      if (this.timeLeft > 0) {
        this.timeLeft--;
      } else {
        this.handleTimeout();
      }
    }, 1000);
  }

  private stopTimer() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  private handleTimeout() {
    this.selectAnswer(-1);
  }

  private selectAnswer(answerIndex: number) {
    this.stopTimer();
    this.userAnswers[this.currentQuestionIndex] = answerIndex;
    this.selectedOptionIndex = answerIndex;
    this.showFeedback = true;

    if (answerIndex !== -1) {
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      if (answerIndex === this.getCurrentQuestion()?.correctAnswer) {
        HapticUtil.playSuccess();
        AudioUtil.playSound('success', context);
      } else {
        HapticUtil.playFailure();
        AudioUtil.playSound('failure', context);
      }
    }

    setTimeout(() => {
      this.showFeedback = false;
      this.selectedOptionIndex = -1;
      if (this.currentQuestionIndex < this.questions.length - 1) {
        this.currentQuestionIndex++;
        this.startTimer();
      } else {
        this.finishQuiz();
      }
    }, 1500);
  }

  private async finishQuiz() {
    this.quizResult = await this.quizViewModel.calculateResult(this.topic, this.userAnswers, this.difficulty);
    console.info(this.quizResult.score.toString())

    const historyUtil = HistoryUtil.getInstance();
    await historyUtil.init(this.getUIContext().getHostContext() as common.UIAbilityContext);
    historyUtil.saveHistory({
      topic: this.topic,
      score: this.quizResult.score,
      total: this.quizResult.totalQuestions,
      date: new Date().toLocaleDateString()
    });

    this.isQuizCompleted = true;
    if (this.onShowResult) {
      this.onShowResult(this.quizResult.score);
    }
  }


  private getCurrentQuestion(): Question | null {
    return this.currentQuestionIndex < this.questions.length ?
    this.questions[this.currentQuestionIndex] : null;
  }

  private getOptionBackgroundColor(index: number): string {
    if (this.showFeedback) {
      const correctIndex = this.getCurrentQuestion()?.correctAnswer;
      if (index === correctIndex) return '#4caf50';
      if (index === this.selectedOptionIndex) return '#f44336';
    }
    return this.isDarkMode ? '#333333' : '#f8f9fa';
  }

  private getOptionBorderColor(index: number): string {
    if (this.showFeedback) {
      const correctIndex = this.getCurrentQuestion()?.correctAnswer;
      if (index === correctIndex) return '#4caf50';
      if (index === this.selectedOptionIndex) return '#f44336';
    }
    return this.isDarkMode ? '#555555' : '#e9ecef';
  }

  aboutToDisappear() {
    this.stopTimer();
  }

  build() {
    Column() {
        Stack({ alignContent: Alignment.Center }) {
          Progress({ value: this.timeLeft, total: 15, type: ProgressType.Ring })
            .width(40)
            .height(40)
            .color('#4caf50')
            .backgroundColor(this.isDarkMode ? '#333333' : '#eeeeee')

          Text(`${this.timeLeft}`)
            .fontSize(10)
            .fontColor(this.isDarkMode ? '#ffffff' : '#000000')

          if (this.heartRate > 0) {
            Text(`❤️${this.heartRate}`)
              .fontSize(6)
              .fontColor('#f44336')
              .offset({ y: 15 })
          }
        }
        .margin({ top: 15, bottom: 5 })

        Text(`${this.currentQuestionIndex + 1}/${this.questions.length}`)
          .fontSize(8)
          .fontColor(this.isDarkMode ? '#cccccc' : '#666666')
          .margin({ bottom: 10 })
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
              ForEach(this.getCurrentQuestion()!.options, (option: string, index: number) => {
                Button(option)
                  .width('90%')
                  .height(30)
                  .fontSize(8)
                  .fontColor(this.isDarkMode ? '#ffffff' : '#000000')
                  .backgroundColor(this.getOptionBackgroundColor(index))
                  .borderRadius(16)
                  .border({
                    width: 2,
                    color: this.getOptionBorderColor(index)
                  })
                  .enabled(!this.showFeedback)
                  .onClick(() => {
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