import Vue from 'vue'
import Router from 'vue-router'
import Top from '@/components/Top'
import Playing from '@/components/Playing'
import GameSet from '@/components/GameSet'
import SignUp from '@/components/SignUp'
import SignIn from '@/components/SignIn'
import Profile from '@/components/Profile'

Vue.use(Router)

let router = new Router({
  mode: 'history',
  // kanji.genzouw.com/play/ 配下で配信するため base を合わせる
  base: '/play/',
  routes: [
    {
      path: '/',
      name: 'top',
      component: Top
    },
    {
      path: '/playing/:countOfQuestions/:enableSpeak',
      name: 'Playing',
      component: Playing
    },
    {
      path: '/gameSet/:countOfQuestions/:score',
      name: 'GameSet',
      component: GameSet
    },
    {
      path: '/signUp',
      name: 'SignUp',
      component: SignUp
    },
    {
      path: '/signIn',
      name: 'SignIn',
      component: SignIn
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile
    }
  ]
})

export default router
