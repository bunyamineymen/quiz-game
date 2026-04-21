import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { Question, Difficulty } from '../models/Question';

export class RdbUtil {
  private static instance: RdbUtil | null = null;
  private store: relationalStore.RdbStore | null = null;
  private readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'Quiz.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };

  private constructor() {}

  static getInstance(): RdbUtil {
    if (!RdbUtil.instance) {
      RdbUtil.instance = new RdbUtil();
    }
    return RdbUtil.instance;
  }

  async init(context: common.UIAbilityContext) {
    if (this.store) return;
    this.store = await relationalStore.getRdbStore(context, this.STORE_CONFIG);
    await this.store.executeSql(
      'CREATE TABLE IF NOT EXISTS questions (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'question TEXT, ' +
      'options TEXT, ' +
      'correctAnswer INTEGER, ' +
      'topic TEXT, ' +
      'difficulty TEXT)'
    );
  }

  async insertQuestions(questions: Question[]) {
    if (!this.store) return;
    for (const q of questions) {
      const valueBucket: relationalStore.ValuesBucket = {
        question: q.question,
        options: JSON.stringify(q.options),
        correctAnswer: q.correctAnswer,
        topic: q.topic,
        difficulty: q.difficulty
      };
      await this.store.insert('questions', valueBucket);
    }
  }

  async getQuestions(topic: string, difficulty: string): Promise<Question[]> {
    if (!this.store) return [];
    let predicates = new relationalStore.RdbPredicates('questions');
    predicates.equalTo('topic', topic).and().equalTo('difficulty', difficulty);

    const resultSet = await this.store.query(predicates);
    const questions: Question[] = [];
    while (resultSet.goToNextRow()) {
      questions.push({
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        question: resultSet.getString(resultSet.getColumnIndex('question')),
        options: JSON.parse(resultSet.getString(resultSet.getColumnIndex('options'))),
        correctAnswer: resultSet.getLong(resultSet.getColumnIndex('correctAnswer')),
        topic: resultSet.getString(resultSet.getColumnIndex('topic')),
        difficulty: resultSet.getString(resultSet.getColumnIndex('difficulty')) as Difficulty
      });
    }
    resultSet.close();
    return questions;
  }

  async isEmpty(): Promise<boolean> {
    if (!this.store) return true;
    let predicates = new relationalStore.RdbPredicates('questions');
    const resultSet = await this.store.query(predicates);
    const count = resultSet.rowCount;
    resultSet.close();
    return count === 0;
  }
}
