<template>
  <v-app id="login" :class="app.backgroundStyle">
    <v-main>
      <v-container fluid>
        <v-row align="center" justify="center">
          <v-col cols="12" sm="8" md="5">
            <v-card shaped :color="app.whiteOpacity" id="loginBase">
              <v-card-text>
                <v-toolbar flat color="rgba(255,255,255,0)">
                  <v-toolbar-title class="display-1">登录</v-toolbar-title>
                  <v-spacer/>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                      <v-btn icon large v-on="on" @click="toHome">
                        <v-icon>mdi-home-outline</v-icon>
                      </v-btn>
                    </template>
                    <span>主页</span>
                  </v-tooltip>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                      <v-btn icon large v-on="on" @click="changeTheme">
                        <v-icon>mdi-image-multiple</v-icon>
                      </v-btn>
                    </template>
                    <span>换肤</span>
                  </v-tooltip>
                </v-toolbar>
                <v-form ref="form" class="ma-7 mb-n5">
                  <v-text-field v-model="username" label="username" append-icon="mdi-account"
                                ref="username" outlined
                                :rules="usernameRules"></v-text-field>
                  <v-text-field v-model="password" label="password" append-icon="mdi-fingerprint"
                                ref="password" outlined type="password" @keyup.enter="login"
                                :rules="passwordRules"></v-text-field>
                </v-form>
              </v-card-text>
              <v-card-actions class="mr-7">
                <v-spacer></v-spacer>
                <v-btn color="primary" text @click="resetForm" class="title">重置</v-btn>
                <v-btn color="primary" text @click="login" class="title">确认</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      username: '',
      usernameRules: [v => !!v || '用户名不为空'],
      password: '',
      passwordRules: [v => !!v || "密码不为空"],
      formHasErrors: false,
      app: this.$root.$children[0],
    }
  },
  components: {},
  computed: {
    form: function () {
      return {
        username: this.username,
        password: this.password
      }
    }
  },
  methods: {
    toHome: function () {
      this.$router.push({
        path: '/'
      })
    },
    changeTheme: function () {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
      this.$store.commit('changeTheme', this.$vuetify.theme.dark);
    },

    resetForm: function () {
      this.formHasErrors = false;

      Object.keys(this.form).forEach(f => {
        this.$refs[f].reset();
      });
    },
    checkForm: function () {
      this.formHasErrors = false;
      Object.keys(this.form).forEach(f => {
        this.$refs[f].validate(true);
        if (!this.$refs[f].valid) {
          this.formHasErrors = true;
        }
      })
    },
    login: function () {
      if (this.app.overlay === true) {
        return;
      }
      this.checkForm();
      if (!this.formHasErrors) {
        this.app.overlay = true;
        this.$axios.post('/userServer/users/login', {
          password: this.password,
          username: this.username
        })
          .then(resp => {
            if (resp.status === 200) {
              let code = resp.data.code;
              if (code === 200) {
                this.$store.commit('login', resp.data.data);
                //this.app.message("登录成功",'success')
                this.$axios.get('/userServer/users/curr', {
                  params: {}
                })
                  .then(resp => {
                    if (resp.status === 200) {
                      let code = resp.data.code;
                      if (code === 200) {
                        this.$store.commit('updateUserDetails', resp.data.data);
                        if (!this.$route.query.redirect) {
                          //如果输入相关跳转路径
                          this.$router.replace({
                            path: '/userHome'
                          })
                        } else {
                          this.$router.replace({path: this.$route.query.redirect}).catch(() => {
                            this.app.message("跳转失败", 'warning');
                          })
                        }
                        this.app.message("登录成功", 'success');
                      }
                    }
                  })
                  .catch(() => {
                    this.app.message('获取用户信息失败', 'red');
                  })
              } else if (code === 204 || code === 404) {
                this.app.message('用户名或密码错误', 'warning');
              } else {
                this.app.message('服务器错误', 'red');
              }
            }
          })
          .catch(() => {
            this.app.message('登录失败', 'red');
          })
        this.app.overlay = false;
      }
    }
  },
  beforeRouteEnter: (to, from, next) => {
    next(vm => {
      if (vm.$store.state.token) {
        vm.$router.push('/userHome');
      }
    })
  }
}
</script>

<style scoped>
#loginBase {
  margin-top: 100px;
}
</style>
