export interface ButtonStyle {
  backgroundColor: string;
  fontColor: string;
  shadowColor: string;
}
export class ThemeUtil {
  private constructor() {}

  static readonly DARK_COLORS = [
    '#8B0000',
    '#00008B',
    '#006400',
    '#4B0082',
    '#8B4513',
    '#2F4F4F'
  ];

  static readonly LIGHT_COLORS = [
    '#FFC0CB',
    '#ADD8E6',
    '#90EE90',
    '#DDA0DD',
    '#F5DEB3',
    '#D3D3D3'
  ];

  static getBackgroundColor(isDarkMode: boolean): string {
    return isDarkMode ? '#0B0F14' : '#FFFFFF';
  }

  static getButtonStyle(isDarkMode: boolean): ButtonStyle {
    return {
      backgroundColor: isDarkMode ? '#333333' : '#f0f0f0',
      fontColor: isDarkMode ? '#ffffff' : '#000000',
      shadowColor: isDarkMode ? '#000000' : '#cccccc'
    };
  }

  static getButtonText(isDarkMode: boolean): string {
    return isDarkMode ? '🌙' : '☀️';
  }
}