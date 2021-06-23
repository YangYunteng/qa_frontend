<template>
  <v-app :class="app.backgroundStyle" id="UserHome">
    <UserHomeNavigation :menu="menu"></UserHomeNavigation>
    <v-main class="temp">
      <router-view/>
    </v-main>
  </v-app>
</template>

<script>
import UserHomeNavigation from "@/components/UserHomeNavigation";

export default {
  name: "UserHome",
  data() {
    return {
      app: this.$root.$children[0],
      menu: [],
    }
  },

  components: {
    UserHomeNavigation,
  },
  methods: {},
  mounted() {
    let id = this.$store.state.userDetails.ID;
    let adminId = 11;
    if (id === adminId) {
      this.menu = [{title: '登出', icon: 'mdi-logout', func: this.logout}];
    } else {
      this.menu = [
        {title: "首页", icon: 'mdi-home-outline', func: this.toUserHome},
        {title: "去提问", icon: 'mdi-frequently-asked-questions', func: this.openQuestionDialog},
        {title: "热榜", icon: 'mdi-trophy', func: this.toHotQuestions},
        {title: "换肤", icon: 'mdi-image-multiple', func: this.changeTheme},
        {title: '用户', icon: 'mdi-account', func: this.toUserInfo},
        {title: '登出', icon: 'mdi-logout', func: this.logout}
      ]
    }

  }
}
</script>

<style scoped>
.temp {
  margin-top: 10px;
}
</style>
