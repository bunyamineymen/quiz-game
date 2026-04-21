export type Difficulty = 'Easy' | 'Medium' | 'Hard';

export interface Question {
  id: number;
  question: string;
  options: string[];
  correctAnswer: number;
  topic: string;
  difficulty: Difficulty;
}

export interface QuizResult {
  topic: string;
  score: number;
  totalQuestions: number;
  percentage: number;
}