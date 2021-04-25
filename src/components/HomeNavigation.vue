<template>
  <div id="navigation">
    <v-app-bar app flat color="rgba(0,0,0,0)">
      <v-img src="../assets/logo.png" alt="Logo" max-width="250px" class="d-none d-inline-flex"></v-img>

      <v-spacer></v-spacer>

      <v-btn text>
        <v-icon>mdi-home-outline</v-icon>
        <div class="d-none d-md-flex">主页</div>
      </v-btn>
      <v-btn text @click="changeTheme">
        <v-icon>mdi-image-multiple</v-icon>
        <div class="d-none d-md-flex">{{ app.isDark ? '亮色' : '暗色' }}</div>
      </v-btn>
      <v-btn text @click="toLogin">
        <v-icon>mdi-login</v-icon>
        <div class="d-none d-md-flex">登录</div>
      </v-btn>
      <v-btn text @click="toRegister">
        <v-icon>mdi-account-plus</v-icon>
        <div class="d-none d-md-flex">注册</div>
      </v-btn>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  name: "HomeNavigation",
  data() {
    return {
      app: this.$root.$children[0],
    }
  },
  methods: {
    toHome: function () {
      if (this.$route.path !== '/'){
        this.$router.push({
          path: '/',
        })
      }
    },
    toLogin: function () {
      if(this.$route.path!=='login'){
        this.$router.push({
          path: '/login'
        })
      }

    },
    toRegister: function () {
      if(this.$route.path!=='/register'){
        this.$router.push({
          path: '/register'
        })
      }
    },
    changeTheme: function () {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
      this.$store.commit('changeTheme', this.$vuetify.theme.dark);
    },
    goTo(src) {
      this.$router.replace(src)
    }
  }
}
</script>

<style scoped>

</style>
