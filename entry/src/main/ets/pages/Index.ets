import { SelectTopic } from '../components/SelectTopic';
import { QuizPage } from '../components/QuizPage';
import { QuizResultPage } from '../components/QuizResultPage';

@Entry
@Component
struct Index {
  @State currentPage: string = 'splash';
  @State selectedTopic: string = '';
  @State selectedDifficulty: string = 'Easy';
  @State resultScore: number = 0;

  aboutToAppear() {
    setTimeout(() => {
      this.currentPage = 'topics';
    }, 2000);
  }

  private startQuiz = (topic: string, difficulty: string) => {
    this.selectedTopic = topic;
    this.selectedDifficulty = difficulty;
    this.currentPage = 'quiz';
    console.info('Starting quiz for topic:', topic, 'difficulty:', difficulty);
  }

  private backToTopics = () => {
    this.currentPage = 'topics';
    this.selectedTopic = '';
    console.info('Returning to topics selection');
  }

  @State totalQuestions: number = 0;

  private showResult = (score: number, total: number) => {
    this.resultScore = score;
    this.totalQuestions = total;
    this.currentPage = 'result';
  }

  build() {
    Stack() {
      if (this.currentPage === 'splash') {
        Column() {
          Image($r('app.media.startIcon'))
            .width(100)
            .height(100)
            .margin({ bottom: 20 })
          Text('QUIX')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#0B0F14')
        .justifyContent(FlexAlign.Center)
        .transition({ type: TransitionType.Insert, opacity: 1 })
        .transition({ type: TransitionType.Delete, opacity: 0 })

      } else if (this.currentPage === 'topics') {
        SelectTopic({
          onStartQuiz: this.startQuiz
        })
      } else if (this.currentPage === 'quiz') {
        QuizPage({
          topic: this.selectedTopic,
          difficulty: this.selectedDifficulty,
          onBackToTopics: this.backToTopics,
          onShowResult: this.showResult
        })
      } else if (this.currentPage === 'result') {
        QuizResultPage({
          quizScore: this.resultScore,
          totalQuestions: this.totalQuestions,
          onQuizFinish: this.backToTopics
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}