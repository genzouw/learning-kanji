<template>
  <div>
    <div class="row justify-content-center">
      <div class="col-sm-10">
        <div class="result bg-dark text-light">
          <p>{{ countOfQuestions }}もん のうち</p>
          <p class="score">{{ score }}もん せいかい</p>
          <p>でした。</p>
        </div>

        <div class="row justify-content-center">
          <div class="col-auto">
            <p>
              <strong>よろしければシェアをおねがいします！</strong>
            </p>
          </div>
        </div>

        <div class="row justify-content-center">
          <div class="col-auto">
            <p>
              <a
                class="twitter-share-button"
                href="https://twitter.com/intent/tweet?text=%E3%80%8C%E3%81%8B%E3%82%93%E3%81%98%E3%82%92%E3%81%8A%E3%81%BC%E3%81%88%E3%82%88%E3%81%86%E3%80%8D%E3%81%A7%E6%BC%A2%E5%AD%97%E3%82%92%E6%A5%BD%E3%81%97%E3%81%8F%E5%AD%A6%E3%81%BC%E3%81%86%EF%BC%81%0A%23%E3%81%8B%E3%82%93%E3%81%98+%23%E6%BC%A2%E5%AD%97+%23%E6%97%A5%E6%9C%AC%E8%AA%9E+%23japanese+%23kanji%0A%0Ahttps%3A%2F%2Fkanji.gnzouw.com"
                data-size="large"
                data-text="かんじをおぼえよう"
                data-url="https://kanji.genzouw.com"
              >シェア</a>
            </p>
          </div>
        </div>

        <div class="row justify-content-center">
          <div class="col-auto">
            <h3>
              <a href="https://kanji.genzouw.com" class="btn btn-primary btn-lg">もういっかいちゃれんじ！</a>
            </h3>
          </div>
        </div>

        <div class="row justify-content-center" v-if="reversedScores.length > 0">
          <div class="col-auto">
            <table class="table table-striped table-bordered table-condensed">
              <colgroup>
                <col>
                <col>
                <col>
              </colgroup>
              <thead>
                <tr>
                  <th>にちじ</th>
                  <th>もんだい</th>
                  <th>てんすう</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="s in reversedScores" :key="s.id">
                  <td>{{ s.createdAt }}</td>
                  <td>{{ s.countOfQuestions }}</td>
                  <td>{{ s.score }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'

export default {
  data () {
    return {
      countOfQuestions: 0,
      score: 0,
      scores: []
    }
  },
  created () {
    moment.locale('ja')
    this.fetchData()
  },
  watch: {
    $route: 'fetchData'
  },
  methods: {
    unixtimeToString (unixtime) {
      return moment.unix(Number(unixtime)).format('Mがつ Dにち (ddd) HH:mm')
    },
    fetchData () {
      this.countOfQuestions = Number(this.$route.params.countOfQuestions)
      this.score = Number(this.$route.params.score)
    }
  },
  computed: {
    result () {
      return ` ${this.score}もん せいかい ( ${
        this.countOfQuestions
      }もんちゅう )`
    },
    reversedScores () {
      let keys = Object.keys(this.scores).reverse()

      let scores = []

      let k
      for (k of keys) {
        scores.push({
          createdAt: this.unixtimeToString(k),
          countOfQuestions: this.scores[k].countOfQuestions,
          score: this.scores[k].score
        })
      }

      return scores
    }
  }
}
</script>

<style scoped>
.result {
  text-align: center;
  font-size: 150%;
}
.result .score {
  font-size: 200%;
}
thead {
  text-align: center;
}
tbody > tr > td:nth-child(1) {
  text-align: center;
}
tbody > tr > td:nth-child(2), tbody > tr > td:nth-child(3) {
  text-align: right;
}
</style>
