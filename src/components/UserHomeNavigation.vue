<template>
  <v-app-bar absolute app flat prominent color="rgb(255,255,255,0.2)" height="60" class="justify-center pt-2"
             style="z-index: 200">
    <v-row>
      <v-col cols="2">
        <v-img max-width="250px" alt="Logo" src="../assets/logo.png" class="d-none d-inline-flex mt-1"></v-img>
      </v-col>
      <v-col cols="4" v-if="!isAdmin">
        <v-row>
          <v-spacer></v-spacer>
          <v-col cols="11">
            <v-text-field label="搜索" dense outlined v-model="search"
                          :append-outer-icon="'mdi-send'" @click:append-outer="toSearchedQuestions"
            ></v-text-field>
          </v-col>
        </v-row>
      </v-col>
      <v-col cols="6" v-if="!isAdmin">
        <v-row>
          <v-spacer></v-spacer>
          <v-col cols="12" sm="12" md="12" lg="10" xl="9" class="d-sm-flex d-md-flex d-lg-flex d-xl-flex">
            <v-btn text v-for="(item,index) in menu" v-bind:key="index" @click="item.func">
              <v-icon>{{ item.icon }}</v-icon>
              <div class="d-none d-md-flex">{{ item.title }}</div>
            </v-btn>
          </v-col>
        </v-row>
      </v-col>
      <v-spacer></v-spacer>
      <v-col cols="4" v-if="isAdmin">
        <v-row>
          <v-spacer></v-spacer>
          <v-col cols="12" sm="12" md="12" lg="10" xl="9" class="d-sm-flex d-md-flex d-lg-flex d-xl-flex">
            <v-btn text v-for="(item,index) in adminMenu" v-bind:key="index" @click="item.func">
              <v-icon>{{ item.icon }}</v-icon>
              <div class="d-none d-md-flex">{{ item.title }}</div>
            </v-btn>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
    <v-dialog
      persistent
      max-width="800px"
      v-model="isQuestionDialogOn"
    >
      <template>
        <v-card>
          <v-toolbar
            color="primary"
            dark
          >提问
          </v-toolbar>
          <v-card-text class="mt-5">
            <v-text-field placeholder="" v-model="questionTitle" label="问题标题" outlined dense></v-text-field>
            <MarkdownInput style="margin-top: -30px" @transformHtml="receiveHtml" ref="markdownInput"
                           placeholder="问题描述...."></MarkdownInput>
          </v-card-text>
          <v-card-actions class="justify-end">
            <v-btn @click="submitQuestion" class="mb-4 mr-4" elevation="2" color="primary" depressed>提交</v-btn>
            <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed
                   @click="closeQuestionDialog">取消
            </v-btn>
          </v-card-actions>
        </v-card>
      </template>
    </v-dialog>
  </v-app-bar>
</template>

<script>
import MarkdownInput from "@/components/MarkdownInput";

export default {
  name: "UserHomeNavigation",
  components: {
    MarkdownInput,
  },
  data() {
    return {
      app: this.$root.$children[0],
      questionTitle: '',
      questionDescription: '',
      isQuestionDialogOn: false,
      search: "",
      menu: [
        {title: "首页", icon: 'mdi-home-outline', func: this.toUserHome},
        {title: "去提问", icon: 'mdi-frequently-asked-questions', func: this.openQuestionDialog},
        {title: "热榜", icon: 'mdi-trophy', func: this.toHotQuestions},
        {title: "换肤", icon: 'mdi-image-multiple', func: this.changeTheme},
        {title: '用户', icon: 'mdi-account', func: this.toUserInfo},
        {title: '登出', icon: 'mdi-logout', func: this.logout}
      ],
      adminMenu: [
        {title: "首页", icon: 'mdi-home-outline', func: this.toUserHome},
        {title: "换肤", icon: 'mdi-image-multiple', func: this.changeTheme},
        {title: '建议', icon: 'mdi-comment-plus', func: this.toSuggestionsView},
        {title: '登出', icon: 'mdi-logout', func: this.logout}
      ]
    }
  },
  computed: {
    isAdmin: function () {
      return this.$store.state.userDetails.ID===6;
    },
  },
  methods: {
    changeTheme: function () {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
      this.$store.commit('changeTheme', this.$vuetify.theme.dark);
    },
    //前往搜索问题界面
    toSearchedQuestions: function () {
      // let lastKey
      if (this.search !== '') {
        this.$router.push({
          path: '/userHome/searchedQuestions/' + this.search,
        }).catch(err => err)
      }
    },

    //首页
    toUserHome: function () {
      if (this.$route.path !== '/userHome/') {
        this.$router.push({
          path: '/userHome'
        }).catch(err => err)
      }
    },

    toUserInfo: function () {
      if (this.$route.path !== '/userInfo/') {
        this.$router.push({
          path: '/userHome/userInfo'
        }).catch(err => err)
      }
    },

    //提问问题相关函数
    openQuestionDialog: function () {
      this.isQuestionDialogOn = true;
    },

    closeQuestionDialog: function () {
      this.isQuestionDialogOn = false;
    },

    receiveHtml: function (msg) {
      this.questionDescription = msg;
    },

    judgeQuestionCanPost: function () {
      if (this.questionTitle === '') {
        this.app.message("问题标题不能为空", 'warning');
        return false;
      }
      if (this.questionDescription === '') {
        this.app.message("问题描述不能为空", 'warning');
        return false;
      }
      return true;
    },

    submitQuestion: function () {
      if (this.app.overlay === true)
        return;
      //console.log(this.judgeQuestionCanPost());
      let canPost = this.judgeQuestionCanPost();
      if (canPost) {
        //console.log("run")
        this.app.overlay = true;
        this.$axios.post('/userServer/questions', {
          content: this.questionDescription,
          title: this.questionTitle
        }).then(resp => {
          if (resp.status === 200) {
            let code = resp.data.code;
            if (code === 200) {
              this.app.message("问题提交成功", 'success');
              this.questionTitle = '';
              this.questionDescription = '';
              this.$refs.markdownInput.content = '';
              this.closeQuestionDialog();
            } else {
              this.app.message("问题上传失败", "warning");
            }
          }
        }).catch(() => {
          this.app.message("服务器正忙", 'red');
        })
        this.app.overlay = false;
      }
    },
    toSuggestionsView: function () {
      if (this.$route.path !== '/userHome/suggestionsView') {
        this.$router.push({
          path: '/userHome/suggestionsView'
        }).catch(err => err)
      }
    },
    //切换到关注的问题界面
    toFollowingQuestions: function () {
      if (this.$route.path !== '/userHome/followingQuestions') {
        this.$router.push({
          path: '/userHome/followingQuestions'
        }).catch(err => err)
      }
    },
    //切换到热门问题界面
    toHotQuestions: function () {
      if (this.$route.path !== '/userHome/hotQuestions') {
        this.$router.push({
          path: '/userHome/hotQuestions'
        }).catch(err => err)
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
