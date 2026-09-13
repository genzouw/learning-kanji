<template>
  <div id="wrap">
    <b-navbar
      toggleable="lg"
      class="navbar navbar-expand-lg navbar-dark bg-primary mb-3"
    >
      <a
        class="navbar-brand"
        href="https://kanji.genzouw.com"
        style="width: 100%; text-align: center; font-size: 200%;"
        >かんじをおぼえよう</a
      >

      <!--
      <template v-if="user">
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-dropdown-item @click="profile">{{ user.email }}</b-dropdown-item>
          <b-dropdown-item @click="signOut">ログアウトする</b-dropdown-item>
        </b-navbar-nav>
      </b-collapse>
      </template>
      <template v-else>
        <router-link to="/signIn" class="btn btn-md btn-secondary">ログイン</router-link>
      </template>
      -->
    </b-navbar>

    <div class="container">
      <router-view />
    </div>

    <footer
      class="page-footer font-small fixed-bottom bg-light text-dark justify-content-center"
    >
      <div class="footer-copyright text-center py-2">
        <a
          class="twitter-share-button"
          data-size="large"
          data-text="「かんじをおぼえよう」で漢字を楽しく学ぼう！
#かんじ #漢字 #日本語 #japanese #kanji

"
          data-url="https://kanji.genzouw.com"
          >シェア</a
        >
      </div>
    </footer>
  </div>
</template>

<script>
import firebase from 'firebase'

export default {
  name: 'App',
  metaInfo: {
    title: 'かんじをおぼえよう',
    meta: [
      {
        'http-equiv': 'Content-Type',
        content: 'text/html; charset=utf-8'
      },
      {
        name: 'viewport',
        content: 'width=device-width, initial-scale=1'
      },
      {
        name: 'description',
        content: 'みんなでたのしく「かんじをおぼえよう」！'
      },
      // OpenGraph data (Most widely used)
      {
        property: 'og:title',
        content: 'かんじをおぼえよう'
      },
      {
        property: 'og:site_name',
        content: 'かんじをおぼえよう'
      },
      // The list of types is available here: http://ogp.me/#types
      {
        property: 'og:type',
        content: 'website'
      },
      // Should the the same as your canonical link, see below.
      {
        property: 'og:url',
        content: 'https://kanji.genzouw.com'
      },
      {
        property: 'og:image',
        content: 'https://kanji.genzouw.com/kanji.png'
      },
      // Often the same as your meta description, but not always.
      {
        property: 'og:description',
        content: 'かんじをおぼえよう。なんもんせいかいできるかな？'
      },
      // Twitter card
      {
        name: 'twitter:card',
        content: 'summary'
      },
      {
        name: 'twitter:site',
        content: 'https://kanji.genzouw.com'
      },
      {
        name: 'twitter:title',
        content: 'かんじをおぼえよう'
      },
      {
        name: 'twitter:description',
        content: 'かんじをおぼえよう。なんもんせいかいできるかな？'
      },
      // Your twitter handle, if you have one.
      {
        name: 'twitter:creator',
        content: '@genzouw'
      },
      {
        name: 'twitter:image:src',
        content: 'https://kanji.genzouw.com/kanji.png'
      },

      // Google / Schema.org markup:
      {
        itemprop: 'name',
        content: 'かんじをおぼえよう'
      },
      {
        itemprop: 'description',
        content: 'かんじをおぼえよう。なんもんせいかいできるかな？'
      },
      {
        itemprop: 'image',
        content: 'https://kanji.genzouw.com/kanji.png'
      }
    ]
  },
  data () {
    return {}
  },
  created () {
    firebase.auth().onAuthStateChanged(user => {
      this.$store.commit('updateUser', user)
    })
  },
  computed: {
    user () {
      return this.$store.state.user
    }
  },
  methods: {
    signOut () {
      if (!window.confirm('ログアウトします。よろしいですか？')) return false
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.$router.push('/')
        })
    },
    profile () {
      this.$router.push('/profile')
    }
  }
}
</script>

<style>
body > #app {
  padding: 0;
}
.dropdown-item {
  color: white;
}
.dropdown-item:hover {
  color: black;
}
div.container-fluid {
  margin-bottom: 3em;
}
</style>
