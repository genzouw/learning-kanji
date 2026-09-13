<template>
  <div>
    <div class="row">
      <div class="col-auto">
        <h2>[だい{{ currentQuestionIndex + 1 }}もん]</h2>
      </div>
      <div class="col-auto">
        <button
          class="btn btn-sm btn-primary"
          v-bind:class="{
            'btn-primary': this.enableSpeak,
            'btn-secondary': !this.enableSpeak
          }"
          @click.prevent="clickSpeakToggle"
        >
          {{ this.enableSpeak ? '○' : '✕' }} よみあげ{{
            this.enableSpeak ? 'あり' : 'なし'
          }}
        </button>
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-sm-10 cont main-container bg-secondary text-dark">
        <div style="display: flex;">
          <span v-html="questionData.question" style="font-size: 200%;"></span>
          <a
            href="javascript:void(0)"
            style="font-size: 200%; "
            v-show="this.enableSpeak"
            @click="speakQuestionIfEnabled"
            title="もんだいを、もういちどきく"
          >
            👂
          </a>
        </div>
        <div class="row">
          <div
            class="col-sm-12"
            v-for="c in questionData.choices"
            v-bind:key="c"
          >
            <label
              class="option"
              v-bind:class="{
                correct: !thinking && c === questionData.answer,
                choiced: !thinking && c === choice
              }"
              @click="clickAnswer(c)"
            >
              <span>{{ c }}</span>
            </label>
          </div>
        </div>
        <div class="row justify-content-center">
          <div class="col-sm-12">
            <button
              class="btn btn-lg btn-primary btn-block"
              v-bind:disabled="thinking"
              @click.prevent="clickNext"
            >
              次へ
            </button>
          </div>
        </div>
      </div>
    </div>
    <audio id="right-sound" preload>
      <source src="@/assets/right.mp3" type="audio/mp3" />
    </audio>
    <audio id="wrong-sound" preload>
      <source src="@/assets/wrong.mp3" type="audio/mp3" />
    </audio>
  </div>
</template>

<script>
import _ from 'underscore'

export default {
  data () {
    return {
      currentQuestionIndex: 0,
      score: 0,
      countOfQuestions: 0,
      questionData: {
        question: '',
        choices: [],
        answer: ''
      },
      choice: null,
      thinking: false,
      questionList: [],
      speak: new SpeechSynthesisUtterance(),
      enableSpeak: true
    }
  },
  mounted () {
    this.speak.rate = 0.75
    this.speak.pitch = 1
    this.speak.lang = 'ja-JP'

    this.countOfQuestions = this.$route.params.countOfQuestions
    this.enableSpeak = this.$route.params.enableSpeak
    this.questionList = _.shuffle(questions)
    this.loadQuestion()
  },
  methods: {
    clickStart () {
      console.log(this.$route.params)
      this.clickNext()
    },
    clickAnswer (c) {
      // すでに合否が表示されたあとは、次の問題へ進む
      if (!this.thinking) {
        this.clickNext()
        return
      }

      this.choice = c

      this.thinking = false

      speechSynthesis.cancel(this.speak)

      // 正解したら
      if (this.questionData.answer === this.choice) {
        this.score++

        let rightSound = document.getElementById('right-sound')
        rightSound.play()
      } else {
        let wrongSound = document.getElementById('wrong-sound')
        wrongSound.play()
      }
    },
    clickNext () {
      this.currentQuestionIndex++

      if (this.currentQuestionIndex < this.countOfQuestions) {
        this.loadQuestion()
      } else {
        this.$router.push(`/gameSet/${this.countOfQuestions}/${this.score}`)
      }
    },
    loadQuestion () {
      this.questionData = this.questionList[this.currentQuestionIndex]
      let dummies = _.shuffle(
        _.filter(
          _.map(this.questionList, (v, k) => {
            return v.answer
          }),
          v => {
            return v !== this.questionData.answer
          }
        )
      )
      this.questionData.choices = [
        this.questionData.answer,
        dummies[0],
        dummies[1],
        dummies[2]
      ]
      this.questionData.choices = _.shuffle(this.questionData.choices)
      this.thinking = true
      this.choice = null

      this.speakQuestionIfEnabled()
    },
    clickSpeakToggle () {
      this.enableSpeak = !this.enableSpeak

      this.speakQuestionIfEnabled()
    },
    speakQuestionIfEnabled () {
      this.speak.text = this.questionData.question
      if (this.enableSpeak) {
        speechSynthesis.cancel(this.speak)
        speechSynthesis.speak(this.speak)
      }
    }
  }
}

const questions = [
  {
    question: 'いぬ',
    answer: '犬'
  },
  {
    question: 'いち',
    answer: '一'
  },
  {
    question: 'に',
    answer: '二'
  },
  {
    question: 'さん',
    answer: '三'
  },
  {
    question: 'よん',
    answer: '四'
  },
  {
    question: 'ご',
    answer: '五'
  },
  {
    question: 'きゅう',
    answer: '九'
  },
  {
    question: 'はち',
    answer: '八'
  },
  {
    question: 'なな',
    answer: '七'
  },
  {
    question: 'じゅう',
    answer: '十'
  },
  {
    question: 'ひと',
    answer: '人'
  },
  {
    question: 'はいる',
    answer: '入る'
  },
  {
    question: 'ちから',
    answer: '力'
  },
  {
    question: 'した',
    answer: '下'
  },
  {
    question: 'くち',
    answer: '口'
  },
  {
    question: 'やま',
    answer: '山'
  },
  {
    question: 'こ',
    answer: '子'
  },
  {
    question: 'おんな',
    answer: '女'
  },
  {
    question: 'ちいさい',
    answer: '小さい'
  },
  {
    question: 'うえ',
    answer: '上'
  },
  {
    question: 'ゆう',
    answer: '夕'
  },
  {
    question: 'せん',
    answer: '千'
  },
  {
    question: 'かわ',
    answer: '川'
  },
  {
    question: 'おおきい',
    answer: '大きい'
  },
  {
    question: 'つち',
    answer: '土'
  },
  {
    question: 'えん',
    answer: '円'
  },
  {
    question: 'おう',
    answer: '王'
  },
  {
    question: 'ひ',
    answer: '火'
  },
  {
    question: 'つき',
    answer: '月'
  },
  {
    question: 'て',
    answer: '手'
  },
  {
    question: 'みず',
    answer: '水'
  },
  {
    question: 'なか',
    answer: '中'
  },
  {
    question: 'てん',
    answer: '天'
  },
  {
    question: 'ひ',
    answer: '日'
  },
  {
    question: 'ぶん',
    answer: '文'
  },
  {
    question: 'き',
    answer: '木'
  },
  {
    question: 'ろく',
    answer: '六'
  },
  {
    question: 'みぎ',
    answer: '右'
  },
  {
    question: 'たま',
    answer: '玉'
  },
  {
    question: 'ひだり',
    answer: '左'
  },
  {
    question: 'でる',
    answer: '出る'
  },
  {
    question: 'ただしい',
    answer: '正しい'
  },
  {
    question: 'いきる',
    answer: '生きる'
  },
  {
    question: 'いし',
    answer: '石'
  },
  {
    question: 'た',
    answer: '田'
  },
  {
    question: 'しろ',
    answer: '白'
  },
  {
    question: 'ほん',
    answer: '本'
  },
  {
    question: 'め',
    answer: '目'
  },
  {
    question: 'たつ',
    answer: '立つ'
  },
  {
    question: 'きもち',
    answer: '気もち'
  },
  {
    question: 'やすみ',
    answer: '休み'
  },
  {
    question: 'いと',
    answer: '糸'
  },
  {
    question: 'じ',
    answer: '字'
  },
  {
    question: 'みみ',
    answer: '耳'
  },
  {
    question: 'さき',
    answer: '先'
  },
  {
    question: 'はやい',
    answer: '早い'
  },
  {
    question: 'たけ',
    answer: '竹'
  },
  {
    question: 'むし',
    answer: '虫'
  },
  {
    question: 'とし',
    answer: '年'
  },
  {
    question: 'ひゃく',
    answer: '百'
  },
  {
    question: 'な',
    answer: '名'
  },
  {
    question: 'はな',
    answer: '花'
  },
  {
    question: 'かい',
    answer: '貝'
  },
  {
    question: 'みる',
    answer: '見る'
  },
  {
    question: 'くるま',
    answer: '車'
  },
  {
    question: 'あか',
    answer: '赤'
  },
  {
    question: 'あし',
    answer: '足'
  },
  {
    question: 'むら',
    answer: '村'
  },
  {
    question: 'おとこ',
    answer: '男'
  },
  {
    question: 'まち',
    answer: '町'
  },
  {
    question: 'あめ',
    answer: '雨'
  },
  {
    question: 'がく',
    answer: '学'
  },
  {
    question: 'きん',
    answer: '金'
  },
  {
    question: 'そら',
    answer: '空'
  },
  {
    question: 'あお',
    answer: '青'
  },
  {
    question: 'はやし',
    answer: '林'
  },
  {
    question: 'おと',
    answer: '音'
  },
  {
    question: 'くさ',
    answer: '草'
  },
  {
    question: 'がっこう',
    answer: '学校'
  },
  {
    question: 'もり',
    answer: '森'
  }
]
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#navbarSupportedContent h1 {
  font-size: 100%;
}

.quiz-start-page {
  text-align: center;
  /* background: linear-gradient(to bottom right, #f7ff9194, #f7ff91b8); */
}

.option {
  width: 95%;
  padding: 10px 0 10px 40%;
  background: #e2e2e2;
  margin: 5px 0 5px 10px;
  color: #000000;
  border-radius: 20px;
  margin-bottom: 0.25em;
  vertical-align: middle;
  font-size: 150%;
}

.choiced {
  background-color: pink;
}

.choiced:after {
  content: ' ×';
  color: red;
  font-weight: bold;
}

.correct {
  background-color: lightblue;
  color: darkblue;
}

.correct.choiced {
  background-color: lightgreen;
}

.correct.choiced:after {
  content: ' ○';
  color: blue;
  font-weight: bold;
}
</style>
