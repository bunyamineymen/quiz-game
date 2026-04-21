import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CanvasUtil, ClickableSlice } from '../utils/CanvasUtil';
import { ThemeUtil } from '../utils/ThemeUtil';
import { HistoryUtil, QuizHistoryItem } from '../utils/HistoryUtil';
import { common } from '@kit.AbilityKit';

@Component
export struct SelectTopic {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private preferencesUtil: PreferencesUtil = PreferencesUtil.getInstance();
  private clickableSlices: ClickableSlice[] = [];
  private onStartQuiz?: (topic: string, difficulty: string) => void;
  private topics: string[] = [
    'History', 'Science', 'Geography', 'Sports', 'Art', 'Music'
  ];

  @State isDarkMode: boolean = false;
  @State selectedDifficulty: string = 'Easy';
  @State history: QuizHistoryItem[] = [];
  @State showHistory: boolean = false;
  @State activeMode: boolean = false;
  private difficulties: string[] = ['Easy', 'Medium', 'Hard'];

  aboutToAppear() {
    this.initComponent();
  }

  private async initComponent() {
    try {
      await this.preferencesUtil.initPreferences(this.getUIContext().getHostContext() as common.UIAbilityContext);
      this.isDarkMode = this.preferencesUtil.getDarkModePreference
      (this.getUIContext().getHostContext() as common.UIAbilityContext);

      const historyUtil = HistoryUtil.getInstance();
      await historyUtil.init(this.getUIContext().getHostContext() as common.UIAbilityContext);
      this.history = historyUtil.getHistory();
    } catch (err) {
      console.error('Failed to initialize component:', err);
    }
  }

  private toggleTheme() {
    this.preferencesUtil.toggleDarkMode(this.getUIContext().getHostContext() as Context,
      (newState: boolean) => {
      this.isDarkMode = newState;
      this.redrawCanvas();
    });
  }

  private redrawCanvas() {
    setTimeout(() => {
      this.clickableSlices = CanvasUtil.drawPieChart(
        this.context,
        this.topics,
        this.isDarkMode,
        ThemeUtil.DARK_COLORS,
        ThemeUtil.LIGHT_COLORS
      );
    }, 50);
  }

  private onCanvasClick(event: ClickEvent) {
    const clickedTopic = CanvasUtil.getClickedSlice(
      event.x,
      event.y,
      this.clickableSlices
    );

    if (clickedTopic) {
      console.info('Selected topic:', clickedTopic);
      if (this.onStartQuiz) {
        this.onStartQuiz(clickedTopic, this.selectedDifficulty);
      }
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.showHistory) {
        Column() {
          Text('Recent History')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDarkMode ? '#ffffff' : '#000000')
            .margin({ top: 40, bottom: 10 })

          List({ space: 5 }) {
            ForEach(this.history, (item: QuizHistoryItem) => {
              ListItem() {
                Row() {
                  Text(item.topic)
                    .fontSize(12)
                    .fontColor(this.isDarkMode ? '#ffffff' : '#000000')
                  Blank()
                  Text(`${item.score}/${item.total}`)
                    .fontSize(12)
                    .fontColor(this.isDarkMode ? '#cccccc' : '#666666')
                }
                .width('100%')
                .padding({ left: 15, right: 15, top: 10, bottom: 10 })
              }
            }, (item: QuizHistoryItem) => item.date + item.topic)
          }
          .width('100%')
          .height('60%')

          Button('Back')
            .fontSize(10)
            .margin({ top: 10 })
            .onClick(() => this.showHistory = false)
        }
        .width('100%')
        .height('100%')
        .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
        .zIndex(10)
      }

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Canvas(this.context)
          .width('90%')
          .height('90%')
          .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
          .onReady(() => {
            this.redrawCanvas();
          })
          .onClick((event: ClickEvent) => {
            this.onCanvasClick(event);
          })
      }
      .width('100%')
      .height('100%')

      Column() {
        Row({ space: 10 }) {
          ForEach(this.difficulties, (diff: string) => {
            Text(diff[0])
              .fontSize(14)
              .width(28)
              .height(28)
              .textAlign(TextAlign.Center)
              .borderRadius(14)
              .backgroundColor(this.selectedDifficulty === diff ? '#4caf50' : (this.isDarkMode ? '#333333' : '#eeeeee'))
              .fontColor(this.selectedDifficulty === diff ? '#ffffff' : (this.isDarkMode ? '#ffffff' : '#000000'))
              .onClick(() => {
                this.selectedDifficulty = diff;
              })
          }, (diff: string) => diff)
        }
        .margin({ top: 10 })

        Button('📊')
          .fontSize(16)
          .backgroundColor(ThemeUtil.getButtonStyle(this.isDarkMode).backgroundColor)
          .borderRadius(25)
          .padding(8)
          .onClick(() => this.showHistory = true)

        Button(this.activeMode ? '🏃' : '🧘')
          .fontSize(16)
          .backgroundColor(this.activeMode ? '#ff9800' : ThemeUtil.getButtonStyle(this.isDarkMode).backgroundColor)
          .borderRadius(25)
          .padding(8)
          .margin({ top: 5 })
          .onClick(() => this.activeMode = !this.activeMode)

        Button(ThemeUtil.getButtonText(this.isDarkMode))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(ThemeUtil.getButtonStyle(this.isDarkMode).backgroundColor)
          .fontColor(ThemeUtil.getButtonStyle(this.isDarkMode).fontColor)
          .borderRadius(25)
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .margin({ top: 5 })
          .onClick(() => {
            this.toggleTheme();
          })
          .shadow({
            radius: 8,
            color: ThemeUtil.getButtonStyle(this.isDarkMode).shadowColor,
            offsetX: 0,
            offsetY: 2
          })
      }
      .width('100%')
      .padding({ top: 40, bottom: 40 })
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
  }
}