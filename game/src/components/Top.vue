<template>
  <div>
    <div class="row justify-content-center">
      <div class="col-auto">
        <h2>なんもんせいかいできるかな？</h2>
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-auto text-center">
        <img
          src="@/assets/kanji.png"
          class="img-fluid w-75 center-block"
          alt=""
        />
      </div>
    </div>

    <div class="row">
      <label
        class="col-6 col-form-label col-form-label-lg"
        style="text-align: right"
        >もんだいのかず</label
      >
      <div class="col-6" style="display: flex">
        <input
          type="number"
          min="1"
          name="countOfQuestions"
          v-model="countOfQuestions"
          max="100"
          class="form-control form-control-lg"
          v-validate="'required|numeric|min:1|max:100'"
          data-vv-as="もんだいのかず"
          style="width: 5em"
        />
        <label class="col-form-label col-form-label-lg">もん</label>
      </div>
    </div>

    <div class="row mt-1">
      <label
        class="col-6 col-form-label col-form-label-lg"
        style="text-align: right"
        >よみあげ</label
      >
      <div class="col-6">
        <toggle-switch :options="myOption" v-model="selectedMapOption" />
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-auto">
        <p>
          <strong style="color: #b00" v-if="selectedMapOption === 'あり'"
            >おとがなるので、びっくりしないでね！</strong
          >
        </p>
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-auto">
        <button @click="startGame" class="btn btn-lg btn-primary pl-5 pr-5">
          はじめる
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      selectedMapOption: 'あり',
      myOption: {
        size: { height: 2.5 },
        items: {
          labels: [
            { name: 'なし', backgroundColor: 'gray' },
            { name: 'あり', backgroundColor: 'green' }
          ]
        }
      }
    }
  },
  computed: {
    countOfQuestions: {
      get () {
        return this.$store.state.countOfQuestions
      },
      set (value) {
        this.$store.commit('updateCountOfQuestions', value)
      }
    }
  },
  methods: {
    startGame () {
      this.$validator.validate().then(result => {
        if (!result) {
          return false
        }

        this.$router.push({
          name: `Playing`,
          params: {
            countOfQuestions: this.countOfQuestions,
            enableSpeak: this.selectedMapOption === 'あり'
          }
        })
      })
    }
  }
}
</script>

<style scoped>
.intro {
  font-size: 160%;
}
</style>
