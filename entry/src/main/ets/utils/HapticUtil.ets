import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class HapticUtil {
  static playSuccess() {
    try {
      vibrator.startVibration({
        type: 'preset',
        effectId: 'haptic.effect.soft',
        count: 1
      }, {
        usage: 'alarm'
      }, (error: BusinessError) => {
        if (error) {
          console.error('vibrate failed, code: ' + error.code + ' ,message: ' + error.message);
        }
      });
    } catch (err) {
      console.error('Haptic failed', err);
    }
  }

  static playFailure() {
    try {
      vibrator.startVibration({
        type: 'preset',
        effectId: 'haptic.effect.hard',
        count: 2
      }, {
        usage: 'alarm'
      }, (error: BusinessError) => {
        if (error) {
          console.error('vibrate failed, code: ' + error.code + ' ,message: ' + error.message);
        }
      });
    } catch (err) {
      console.error('Haptic failed', err);
    }
  }
}
