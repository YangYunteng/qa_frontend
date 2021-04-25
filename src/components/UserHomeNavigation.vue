<template>
  <v-app-bar app fixed flat color="rgba(0,0,0,0)" height="90">
    <v-row>
      <v-col cols="3">
        <v-img max-width="250px" alt="Logo" src="../assets/logo.png" class="d-none d-inline-flex"></v-img>
      </v-col>
      <v-spacer></v-spacer>
      <v-col cols="4">
        <v-row>
          <v-col cols="11">
            <v-text-field label="搜索" class="ml-3" dense outlined v-model="search"
                          :append-outer-icon="'mdi-send'" @click:append-outer="searchQuestion"
            ></v-text-field>
          </v-col>
        </v-row>
      </v-col>
      <v-col cols="4">
        <v-btn text v-for="(item,index) in menu" v-bind:key="index" @click="item.func">
          <v-icon>{{ item.icon }}</v-icon>
          <div class="d-none d-md-flex">{{ item.title }}</div>
        </v-btn>
      </v-col>
    </v-row>
  </v-app-bar>
</template>

<script>
export default {
  name: "UserHomeNavigation",
  data() {
    return {
      search: "",
      menu: [
        {title: "去提问", icon: 'mdi-frequently-asked-questions', func: this.searchQuestion},
        {title: "首页", icon: 'mdi-home-outline', func: this.toUserHome},
        {title: "关注", icon: 'mdi-cube-scan', func: this.getFollowingQuestions},
        {title: "热榜", icon: 'mdi-trophy', func: this.getHotQuestions},
        {title: '用户', icon: 'mdi-account', func: this.toUserInfo},
        {title: '登出', icon: 'mdi-logout', func: this.logout}
        // {
        //   index: "3",
        //   title: "热榜",
        // },
      ],

    }
  },
  methods: {
    searchQuestion: function () {
      console.log("question")
    },
    toUserHome: function () {
      if (this.$route.path !== '/userHome') {
        this.$router.push({
          path: '/userHome'
        })
      }
    },
    getFollowingQuestions: function () {
      console.log("followingQuestions")
    },
    getHotQuestions: function () {
      console.log("hotQuestions")
    },
    toUserInfo: function () {
      if (this.$route.path !== 'toUserInfo') {
        console.log("toUserInfo")
      }
    },
    logout: function () {
      if (this.$store.state.token) {
        this.$store.commit('logout');
      }
      this.$router.push('/');
    }
  }
}
</script>

<style scoped>

</style>
