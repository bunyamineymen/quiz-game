import { Question, QuizResult } from '../models/Question';

export class QuizViewModel {
  private static instance: QuizViewModel | null = null;
  private questionsDatabase: Map<string, Question[]> = new Map();

  private constructor() {
    this.initializeQuestions();
  }

  static getInstance(): QuizViewModel {
    if (QuizViewModel.instance === null) {
      QuizViewModel.instance = new QuizViewModel();
    }
    return QuizViewModel.instance;
  }

  private initializeQuestions(): void {
    const historyQuestions: Question[] = [
      { id: 1, question: 'When did World War II end?', options: ['1944', '1945', '1946', '1947'], correctAnswer: 1, topic: 'History' },
      { id: 2, question: 'Who was the first President of the United States?', options: ['John Adams', 'Thomas Jefferson', 'George Washington', 'Benjamin Franklin'], correctAnswer: 2, topic: 'History' },
      { id: 3, question: 'In which year did the Berlin Wall fall?', options: ['1987', '1988', '1989', '1990'], correctAnswer: 2, topic: 'History' },
      { id: 4, question: 'Which empire was ruled by Julius Caesar?', options: ['Greek Empire', 'Roman Empire', 'Ottoman Empire', 'Persian Empire'], correctAnswer: 1, topic: 'History' },
      { id: 5, question: 'When did the American Civil War begin?', options: ['1859', '1860', '1861', '1862'], correctAnswer: 2, topic: 'History' },
      { id: 6, question: 'Who discovered America?', options: ['Vasco da Gama', 'Christopher Columbus', 'Ferdinand Magellan', 'Marco Polo'], correctAnswer: 1, topic: 'History' },
      { id: 7, question: 'In which year was the Declaration of Independence signed?', options: ['1774', '1775', '1776', '1777'], correctAnswer: 2, topic: 'History' },
      { id: 8, question: 'Which ancient wonder was located in Alexandria?', options: ['Colossus of Rhodes', 'Lighthouse of Alexandria', 'Hanging Gardens', 'Statue of Zeus'], correctAnswer: 1, topic: 'History' },
      { id: 9, question: 'Who was the last Pharaoh of Egypt?', options: ['Nefertiti', 'Hatshepsut', 'Cleopatra VII', 'Ankhesenamun'], correctAnswer: 2, topic: 'History' },
      { id: 10, question: 'When did the French Revolution begin?', options: ['1789', '1790', '1791', '1792'], correctAnswer: 0, topic: 'History' }
    ];

    const scienceQuestions: Question[] = [
      { id: 1, question: 'What is the chemical symbol for gold?', options: ['Go', 'Gd', 'Au', 'Ag'], correctAnswer: 2, topic: 'Science' },
      { id: 2, question: 'How many bones are in the adult human body?', options: ['204', '206', '208', '210'], correctAnswer: 1, topic: 'Science' },
      { id: 3, question: 'What is the speed of light?', options: ['300,000 km/s', '299,792,458 m/s', '186,000 mph', 'All of the above'], correctAnswer: 3, topic: 'Science' },
      { id: 4, question: 'Which planet is known as the Red Planet?', options: ['Venus', 'Mars', 'Jupiter', 'Saturn'], correctAnswer: 1, topic: 'Science' },
      { id: 5, question: 'What is the most abundant gas in Earth\'s atmosphere?', options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'], correctAnswer: 2, topic: 'Science' },
      { id: 6, question: 'Who proposed the theory of evolution?', options: ['Isaac Newton', 'Albert Einstein', 'Charles Darwin', 'Gregor Mendel'], correctAnswer: 2, topic: 'Science' },
      { id: 7, question: 'What is the smallest unit of matter?', options: ['Molecule', 'Atom', 'Proton', 'Electron'], correctAnswer: 1, topic: 'Science' },
      { id: 8, question: 'How many chambers does a human heart have?', options: ['2', '3', '4', '5'], correctAnswer: 2, topic: 'Science' },
      { id: 9, question: 'What is the hardest natural substance?', options: ['Gold', 'Iron', 'Diamond', 'Platinum'], correctAnswer: 2, topic: 'Science' },
        { id: 10, question: 'Which blood type is known as the universal donor?', options: [`A+`, `B+`, `AB+`, `O-`], correctAnswer: 3, topic: 'Science' }
    ];

    const geographyQuestions: Question[] = [
      { id: 1, question: 'What is the capital of Australia?', options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'], correctAnswer: 2, topic: 'Geography' },
      { id: 2, question: 'Which river is the longest in the world?', options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'], correctAnswer: 1, topic: 'Geography' },
      { id: 3, question: 'How many continents are there?', options: ['5', '6', '7', '8'], correctAnswer: 2, topic: 'Geography' },
      { id: 4, question: 'Which country has the most natural lakes?', options: ['Russia', 'Canada', 'Finland', 'Norway'], correctAnswer: 1, topic: 'Geography' },
      { id: 5, question: 'What is the smallest country in the world?', options: ['Monaco', 'Vatican City', 'Nauru', 'San Marino'], correctAnswer: 1, topic: 'Geography' },
      { id: 6, question: 'Which mountain range contains Mount Everest?', options: ['Alps', 'Andes', 'Himalayas', 'Rocky Mountains'], correctAnswer: 2, topic: 'Geography' },
      { id: 7, question: 'What is the deepest ocean trench?', options: ['Puerto Rico Trench', 'Java Trench', 'Mariana Trench', 'Peru-Chile Trench'], correctAnswer: 2, topic: 'Geography' },
      { id: 8, question: 'Which desert is the largest in the world?', options: ['Sahara', 'Gobi', 'Antarctic', 'Arabian'], correctAnswer: 2, topic: 'Geography' },
      { id: 9, question: 'What is the most spoken language in the world?', options: ['English', 'Mandarin Chinese', 'Spanish', 'Hindi'], correctAnswer: 1, topic: 'Geography' },
      { id: 10, question: 'Which country is both in Europe and Asia?', options: ['Russia', 'Turkey', 'Kazakhstan', 'All of the above'], correctAnswer: 3, topic: 'Geography' }
    ];

    const sportsQuestions: Question[] = [
      { id: 1, question: 'How many players are on a basketball team on court?', options: ['4', '5', '6', '7'], correctAnswer: 1, topic: 'Sports' },
      { id: 2, question: 'In which sport would you perform a slam dunk?', options: ['Volleyball', 'Tennis', 'Basketball', 'Baseball'], correctAnswer: 2, topic: 'Sports' },
      { id: 3, question: 'How often are the Summer Olympics held?', options: ['Every 2 years', 'Every 3 years', 'Every 4 years', 'Every 5 years'], correctAnswer: 2, topic: 'Sports' },
      { id: 4, question: 'Which country won the 2018 FIFA World Cup?', options: ['Germany', 'Brazil', 'France', 'Argentina'], correctAnswer: 2, topic: 'Sports' },
      { id: 5, question: 'In golf, what is one stroke under par called?', options: ['Eagle', 'Birdie', 'Bogey', 'Ace'], correctAnswer: 1, topic: 'Sports' },
      { id: 6, question: 'How many Grand Slam tournaments are there in tennis?', options: ['3', '4', '5', '6'], correctAnswer: 1, topic: 'Sports' },
      { id: 7, question: 'Which sport is known as \'The Beautiful Game\'?', options: ['Basketball', 'Soccer/Football', 'Tennis', 'Cricket'], correctAnswer: 1, topic: 'Sports' },
      { id: 8, question: 'In which sport do you use a shuttlecock?', options: ['Tennis', 'Squash', 'Badminton', 'Table Tennis'], correctAnswer: 2, topic: 'Sports' },
      { id: 9, question: 'How many holes are there in a standard golf course?', options: ['16', '17', '18', '19'], correctAnswer: 2, topic: 'Sports' },
      { id: 10, question: 'Which country invented baseball?', options: ['Canada', 'United States', 'United Kingdom', 'Japan'], correctAnswer: 1, topic: 'Sports' }
    ];

    const artQuestions: Question[] = [
      { id: 1, question: 'Who painted the Mona Lisa?', options: ['Michelangelo', 'Leonardo da Vinci', 'Picasso', 'Van Gogh'], correctAnswer: 1, topic: 'Art' },
      { id: 2, question: 'In which museum is the Mona Lisa displayed?', options: ['British Museum', 'Metropolitan Museum', 'Louvre Museum', 'Uffizi Gallery'], correctAnswer: 2, topic: 'Art' },
      { id: 3, question: 'Who painted \'Starry Night\'?', options: ['Claude Monet', 'Vincent van Gogh', 'Pablo Picasso', 'Salvador Dalí'], correctAnswer: 1, topic: 'Art' },
      { id: 4, question: 'Which art movement was Pablo Picasso associated with?', options: ['Impressionism', 'Cubism', 'Surrealism', 'Renaissance'], correctAnswer: 1, topic: 'Art' },
      { id: 5, question: 'Who sculpted \'David\'?', options: ['Donatello', 'Rodin', 'Michelangelo', 'Bernini'], correctAnswer: 2, topic: 'Art' },
      { id: 6, question: 'What type of art is Auguste Rodin famous for?', options: ['Painting', 'Sculpture', 'Photography', 'Architecture'], correctAnswer: 1, topic: 'Art' },
      { id: 7, question: 'Which artist cut off his own ear?', options: ['Pablo Picasso', 'Vincent van Gogh', 'Claude Monet', 'Edgar Degas'], correctAnswer: 1, topic: 'Art' },
      { id: 8, question: 'In which period did Leonardo da Vinci live?', options: ['Baroque', 'Renaissance', 'Romantic', 'Modern'], correctAnswer: 1, topic: 'Art' },
      { id: 9, question: 'What is the art technique of painting on wet plaster called?', options: ['Tempera', 'Oil painting', 'Fresco', 'Watercolor'], correctAnswer: 2, topic: 'Art' },
      { id: 10, question: 'Who painted \'The Persistence of Memory\'?', options: ['René Magritte', 'Salvador Dalí', 'Joan Miró', 'Max Ernst'], correctAnswer: 1, topic: 'Art' }
    ];

    const musicQuestions: Question[] = [
      { id: 1, question: 'How many strings does a standard guitar have?', options: ['4', '5', '6', '7'], correctAnswer: 2, topic: 'Music' },
      { id: 2, question: 'Which composer wrote \'The Four Seasons\'?', options: ['Bach', 'Mozart', 'Vivaldi', 'Beethoven'], correctAnswer: 2, topic: 'Music' },
      { id: 3, question: 'What does \'piano\' mean in musical terms?', options: ['Fast', 'Slow', 'Loud', 'Soft'], correctAnswer: 3, topic: 'Music' },
      { id: 4, question: 'Which instrument did Miles Davis famously play?', options: ['Saxophone', 'Trumpet', 'Piano', 'Guitar'], correctAnswer: 1, topic: 'Music' },
      { id: 5, question: 'How many keys does a standard piano have?', options: ['76', '84', '88', '92'], correctAnswer: 2, topic: 'Music' },
      { id: 6, question: 'Which band released the album \'Abbey Road\'?', options: ['The Rolling Stones', 'Led Zeppelin', 'The Beatles', 'Queen'], correctAnswer: 2, topic: 'Music' },
      { id: 7, question: 'What is the highest female singing voice?', options: ['Alto', 'Mezzo-soprano', 'Soprano', 'Contralto'], correctAnswer: 2, topic: 'Music' },
      { id: 8, question: 'Which composer became deaf later in life?', options: ['Mozart', 'Bach', 'Beethoven', 'Chopin'], correctAnswer: 2, topic: 'Music' },
      { id: 9, question: 'How many movements does a typical symphony have?', options: ['2', '3', '4', '5'], correctAnswer: 2, topic: 'Music' },
      { id: 10, question: 'Which country is the birthplace of reggae music?', options: ['Cuba', 'Brazil', 'Jamaica', 'Trinidad'], correctAnswer: 2, topic: 'Music' }
    ];

    this.questionsDatabase.set('History', historyQuestions);
    this.questionsDatabase.set('Science', scienceQuestions);
    this.questionsDatabase.set('Geography', geographyQuestions);
    this.questionsDatabase.set('Sports', sportsQuestions);
    this.questionsDatabase.set('Art', artQuestions);
    this.questionsDatabase.set('Music', musicQuestions);
  }

  getQuestionsForTopic(topic: string): Question[] {
    return this.questionsDatabase.get(topic) || [];
  }

  calculateResult(topic: string, userAnswers: number[]): QuizResult {
    const questions = this.getQuestionsForTopic(topic);
    let correctAnswers = 0;

    questions.forEach((question, index) => {
      if (userAnswers[index] === question.correctAnswer) {
        correctAnswers++;
      }
    });

    const percentage = Math.round((correctAnswers / questions.length) * 100);

    return {
      topic: topic,
      score: correctAnswers,
      totalQuestions: questions.length,
      percentage: percentage
    };
  }

  getAvailableTopics(): string[] {
    return Array.from(this.questionsDatabase.keys());
  }
}
