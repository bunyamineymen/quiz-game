import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

export interface QuizHistoryItem {
  topic: string;
  score: number;
  total: number;
  date: string;
}

export class HistoryUtil {
  private static instance: HistoryUtil | null = null;
  private dataPreferences: preferences.Preferences | null = null;
  private readonly PREF_NAME = 'quizHistory';
  private readonly HISTORY_KEY = 'history_list';

  private constructor() {}

  static getInstance(): HistoryUtil {
    if (!HistoryUtil.instance) {
      HistoryUtil.instance = new HistoryUtil();
    }
    return HistoryUtil.instance;
  }

  async init(context: common.UIAbilityContext) {
    this.dataPreferences = preferences.getPreferencesSync(context, { name: this.PREF_NAME });
  }

  saveHistory(item: QuizHistoryItem) {
    if (!this.dataPreferences) return;
    const history = this.getHistory();
    history.unshift(item);
    // Limit to 10 items
    if (history.length > 10) history.pop();
    this.dataPreferences.putSync(this.HISTORY_KEY, JSON.stringify(history));
    this.dataPreferences.flush();
  }

  getHistory(): QuizHistoryItem[] {
    if (!this.dataPreferences) return [];
    const val = this.dataPreferences.getSync(this.HISTORY_KEY, '[]') as string;
    try {
      return JSON.parse(val) as QuizHistoryItem[];
    } catch (e) {
      console.error('HistoryUtil: Failed to parse history', e);
      return [];
    }
  }
}
