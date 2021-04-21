<template>
  <v-app>
    <!--  全局overlay 以及snackbar, 用于处理延迟并未用户提示消息  -->
    <v-overlay :value="overlay" z-index="500">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>
    <v-snackbar v-model="showSnackbar" :timeout="2000" :color="snackbarType" top>
      {{ snackbarMessage }}
    </v-snackbar>
    <router-view/>
  </v-app>
</template>

<script>
export default {
  name: 'App',

  data: () => ({
    overlay: false,
    showSnackbar: false,
    snackbarMessage: '',
    snackbarType: '',
  }),
  computed: {
    //判断背景色的状态，此处我们只设置了两种类型
    isDark: function () {
      return this.$vuetify.theme.dark;
    },
    //调整组件在不同背景色下的透明度
    whiteOpacity: function () {
      return this.isDark ? 'rgba(255,255,255,0.1)' : 'rgba(255,255,255,0.3)';
    },
    backgroundStyle: function () {
      return this.isDark ? 'darkBg' : 'lightBg';
    }
  },
  methods: {
    //将其与ElementUI进行一个简单的统一，在之后页面如果需要进行提示
    //可以通过app=this.$root.children[0]锁定到App.vue
    //使用this.app.message("message",type)进行调用
    message(message, type) {
      this.showSnackbar = true;
      this.snackbarMessage = message;
      this.snackbarType = type;
    },
    //检查token过期
    updateToken() {
      // 如果当前时间大于 expires 中保存的过期时间，
      // 则直接退出登录
      if (this.$store.state.token && this.$store.state.expiredAt) {
        let expiredAt = new Date(this.$store.state.expiredAt);
        let now = new Date();
        if (now >= expiredAt) {
          this.$store.commit("logout");
        }
      }
      setTimeout(() => {
        this.updateToken();
      }, 60000)
    }
  },
  mounted() {
    this.updateToken();
  }
};
</script>

