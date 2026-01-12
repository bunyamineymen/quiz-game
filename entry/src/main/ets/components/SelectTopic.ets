import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CanvasUtil, ClickableSlice } from '../utils/CanvasUtil';
import { ThemeUtil } from '../utils/ThemeUtil';
import { common } from '@kit.AbilityKit';

@Component
export struct SelectTopic {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private preferencesUtil: PreferencesUtil = PreferencesUtil.getInstance();
  private clickableSlices: ClickableSlice[] = [];
  private onStartQuiz?: (topic: string) => void;
  private topics: string[] = [
    'History', 'Science', 'Geography', 'Sports', 'Art', 'Music'
  ];

  @State isDarkMode: boolean = false;

  aboutToAppear() {
    this.initComponent();
  }

  private async initComponent() {
    try {
      await this.preferencesUtil.initPreferences(this.getUIContext().getHostContext() as common.UIAbilityContext);
      this.isDarkMode = this.preferencesUtil.getDarkModePreference
      (this.getUIContext().getHostContext() as common.UIAbilityContext);
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
        this.onStartQuiz(clickedTopic);
      }
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
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

      Button(ThemeUtil.getButtonText(this.isDarkMode))
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .backgroundColor(ThemeUtil.getButtonStyle(this.isDarkMode).backgroundColor)
        .fontColor(ThemeUtil.getButtonStyle(this.isDarkMode).fontColor)
        .borderRadius(25)
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .margin({ top: 20, right: 20 })
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
    .height('100%')
    .backgroundColor(ThemeUtil.getBackgroundColor(this.isDarkMode))
  }
}