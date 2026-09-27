// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vuex from 'vuex'
import App from './App'
import Meta from 'vue-meta'
import VueAnalytics from 'vue-analytics'
import VeeValidate, {Validator} from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja'
import router from './router'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import './assets/yeti/bootstrap.min.css'
import ToggleSwitch from 'vuejs-toggle-switch'
Vue.use(Vuex)
Vue.use(Meta)
Vue.use(BootstrapVue)
Vue.use(VueAnalytics, {
  id: 'UA-41583079-14',
  router
})
Vue.use(VeeValidate)
Vue.use(ToggleSwitch)

Validator.localize('ja', ja)

Vue.config.productionTip = false

const app = new Vue({
  store: new Vuex.Store({
    state: {
      countOfQuestions: 10,
      user: null
    },
    mutations: {
      updateCountOfQuestions (state, payload) {
        state.countOfQuestions = payload
      },
      updateUser (state, user) {
        state.user = user
      }
    }
  }),
  router,
  components: { App },
  template: '<App/>'
})
app.$mount('#app')
