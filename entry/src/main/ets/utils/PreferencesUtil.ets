import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

export class PreferencesUtil {
  private constructor() {
  }

  private static instance: PreferencesUtil | null = null;
  private dataPreferences: preferences.Preferences | null = null;
  private readonly PREFERENCES_NAME = 'userSettings';
  private readonly DARK_MODE_KEY = $r('app.string.IsDarkMode');

  private constructor() {
  }

  static getInstance(): PreferencesUtil {
    if (PreferencesUtil.instance === null) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }

  async initPreferences(context: common.UIAbilityContext): Promise<boolean> {
    try {
      const options: preferences.Options = { name: this.PREFERENCES_NAME };
      this.dataPreferences = preferences.getPreferencesSync(context, options);
      console.info('Preferences initialized successfully');
      return true;
    } catch (err) {
      console.error('Failed to initialize preferences:', err);
      return false;
    }
  }

  getDarkModePreference(context: Context): boolean {
    if (!this.dataPreferences) {
      console.warn('Preferences not initialized');
      return false;
    }

    try {
      const isDarkMode = this.dataPreferences.getSync(
           context
          .resourceManager
          .getStringSync(this.DARK_MODE_KEY.id)

        , false) as boolean;
      console.info('Loaded theme preference:', isDarkMode ? 'Dark' : 'Light');
      return isDarkMode;
    } catch (err) {
      console.error('Failed to load theme preference:', err);
      return false;
    }
  }

  saveDarkModePreference(isDarkMode: boolean, context: Context, callback?: () => void): void {
    if (!this.dataPreferences) {
      console.warn('Preferences not initialized');
      return;
    }

    try {
      this.dataPreferences.putSync(

        context
          .resourceManager
          .getStringSync(this.DARK_MODE_KEY.id)
        , isDarkMode);

      this.dataPreferences.flush((err: BusinessError) => {
        if (err) {
          console.error(`Failed to flush preferences. Code: ${err.code}, message: ${err.message}`);
        } else {
          console.info('Theme preference saved successfully:', isDarkMode ? 'Dark' : 'Light');
          if (callback) {
            callback();
          }
        }
      });
    } catch (err) {
      console.error('Failed to save theme preference:', err);
    }
  }

  toggleDarkMode(context: Context, callback?: (newState: boolean) => void): void {
    const currentState = this.getDarkModePreference(context);
    const newState = !currentState;

    this.saveDarkModePreference(newState,context, () => {
      if (callback) {
        callback(newState);
      }
    });
  }
}