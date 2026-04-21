export interface ClickableSlice {
  topic: string;
  startAngle: number;
  endAngle: number;
  centerX: number;
  centerY: number;
  radius: number;
}

export class CanvasUtil {
  private constructor() {}

  static drawPieChart(
    context: CanvasRenderingContext2D,
    topics: string[],
    isDarkMode: boolean,
    darkColors: string[],
    lightColors: string[]
  ): ClickableSlice[] {
    const ctx = context;
    const w = ctx.width;
    const h = ctx.height;
    ctx.clearRect(0, 0, w, h);

    const cx = w / 2;
    const cy = h / 2;
    const radius = Math.min(w, h) * 0.44;

    const slice = (2 * Math.PI) / topics.length;
    let start = -Math.PI / 2;
    const clickableSlices: ClickableSlice[] = [];

    topics.forEach((topic, i) => {
      const end = start + slice;

      clickableSlices.push({
        topic: topic,
        startAngle: start,
        endAngle: end,
        centerX: cx,
        centerY: cy,
        radius: radius
      });

      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.arc(cx, cy, radius, start, end, false);
      ctx.closePath();
      ctx.fillStyle = isDarkMode ?
      darkColors[i % darkColors.length] :
      lightColors[i % lightColors.length];
      ctx.fill();

      ctx.strokeStyle = isDarkMode ? '#ffffff' : '#000000';
      ctx.lineWidth = 2;
      ctx.stroke();

      const mid = (start + end) / 2;
      const rx = cx + Math.cos(mid) * radius * 0.65;
      const ry = cy + Math.sin(mid) * radius * 0.65;
      ctx.fillStyle = isDarkMode ? '#ffffff' : '#000000';
      ctx.font = `${Math.round(radius * 0.20)}px sans-serif`;
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(topic, rx, ry);

      start = end;
    });

    return clickableSlices;
  }

  static getClickedSlice(
    clickX: number,
    clickY: number,
    slices: ClickableSlice[]
  ): string | null {
    for (const slice of slices) {
      const dx = clickX - slice.centerX;
      const dy = clickY - slice.centerY;
      const distance = Math.sqrt(dx * dx + dy * dy);

      if (distance <= slice.radius) {
        let angle = Math.atan2(dy, dx);
        if (angle < 0) {
          angle += 2 * Math.PI;
          angle = (angle + Math.PI / 2) % (2 * Math.PI);
        }

        let startAngle = (slice.startAngle + Math.PI / 2) % (2 * Math.PI);
        let endAngle = (slice.endAngle + Math.PI / 2) % (2 * Math.PI);

        if (startAngle < 0) {
          startAngle += 2 * Math.PI;
        }
        if (endAngle < 0) {
          endAngle += 2 * Math.PI;
        }

        if (startAngle <= endAngle) {
          if (angle >= startAngle && angle <= endAngle) {
            return slice.topic;
          }
        } else {
          if (angle >= startAngle || angle <= endAngle) {
            return slice.topic;
          }
        }
      }
    }
    return null;
  }
}