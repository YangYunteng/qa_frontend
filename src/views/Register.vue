<template>
  <v-app id="register" :class="app.backgroundStyle">
    <v-main>
      <v-container fluid>
        <v-row align="center" justify="center">
          <v-col cols="12" sm="8" md="5">
            <v-card shaped :color="app.whiteOpacity" id="registerBase">
              <v-card-text>
                <v-toolbar flat color="rgba(255,255,255,0)">
                  <v-toolbar-title class="display-1">注册</v-toolbar-title>
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
                  <v-text-field v-model="username" label="用户名" append-icon="mdi-account"
                                ref="username" outlined dense
                                :rules="usernameRules"></v-text-field>
                  <v-text-field v-model="nickname" label="昵称" append-icon="mdi-qqchat"
                                ref="nickname" outlined dense
                                :rules="nicknameRules"
                  ></v-text-field>
                  <v-text-field v-model="password" label="密码" append-icon="mdi-fingerprint"
                                ref="password" outlined dense type="password"
                                :rules="passwordRules"></v-text-field>
                  <v-text-field v-model="ensurePassword" label="确认密码" append-icon="mdi-fingerprint"
                                ref="ensurePassword" outlined dense type="password"
                                :rules="ensurePasswordRules"></v-text-field>
                  <v-radio-group v-model="gender" row mandatory>
                    <v-radio label="男" value='1'></v-radio>
                    <v-radio label="女" value='2'></v-radio>
                  </v-radio-group>

                  <v-text-field v-model="email" label="邮箱" append-icon="mdi-email"
                                ref="email" outlined dense
                                :rules="emailRules"></v-text-field>
                  <v-distpicker :province='province' :city='city' :area='area' @province="getProvince" @city="getCity"
                                @area="getArea" class="mb-4"></v-distpicker>

                  <v-text-field v-model="address" label="地址" append-icon="mdi-map-marker"
                                ref="address" outlined dense disabled
                                :rules="addressRules"></v-text-field>
                </v-form>
              </v-card-text>
              <v-card-actions class="mr-7">
                <v-spacer></v-spacer>
                <v-btn color="primary" text @click="resetForm" class="title">重置</v-btn>
                <v-btn color="primary" text @click="register" class="title">确认</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import VDistpicker from 'v-distpicker'

export default {
  name: "Register",
  data() {
    return {
      app: this.$root.$children[0],
      formHasErrors: false,
      username: '',
      usernameRules: [
        v => !!v || '用户名不能为空',
        v => (v.length >= 4 && v.length <= 8) || '用户长度需大于4，小于8',
        v => /^[A-Za-z0-9]{4,8}$/.test(v) || '用户名只能由数字和字母组成'
      ],
      nickname: '',
      nicknameRules: [v => !!v || '昵称不能为空'],
      password: '',
      passwordRules: [
        v => !!v || '密码不能为空',
        v => (v.length >= 6 && v.length <= 10) || '密码长度需大于6，小于10',
        v => /^[A-Za-z0-9]{6,10}$/.test(v) || '密码只能由数字和字母组成'
      ],
      ensurePassword: '',
      ensurePasswordRules: [this.checkEnsurePassword],
      gender: 1,
      email: '',
      emailRules: [
        v => !!v || '邮箱不能为空',
        v => /.+@.+\..+/.test(v) || '邮箱格式错误',],
      address: '',
      addressRules: [this.checkAddress],
      province: '',
      city: '',
      area: ''
    }
  },
  components: {
    VDistpicker
  },
  computed: {
    form: function () {
      return {
        username: this.username,
        nickname: this.nickname,
        password: this.password,
        ensurePassword: this.ensurePassword,
        email: this.email,
        address: this.address,
      }
    }
  },
  methods: {
    checkEnsurePassword: function () {
      if (this.ensurePassword === this.password) {
        return true;
      } else {
        return "密码确认错误";
      }
    },
    checkAddress: function () {
      if (this.province === '省' || this.province === '' || this.city === '市' || this.city === '' || this.area === '区' || this.area === '') {
        return "地址未选全"
      } else {
        return true;
      }
    },
    updateAddress: function () {
      if (this.province === '省' || this.province === '') {
        this.address = '';
      } else {
        if (this.city === '市' || this.city === '') {
          this.address = this.province + ' ';
        } else {
          if (this.area === '区' || this.area === '') {
            this.address = this.province + ' ' + this.city + ' ';
          } else {
            this.address = this.province + ' ' + this.city + ' ' + this.area;
          }
        }
      }

    },
    getProvince: function (data) {
      this.province = data.value;
      this.updateAddress();
    },
    getCity: function (data) {
      this.city = data.value;
      this.updateAddress();
    },

    getArea: function (data) {
      this.area = data.value;
      this.updateAddress();
    },
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
      this.gender = 1;
      this.province = '';
      this.city = '';
      this.area = '';
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
    register: function () {
      if (this.app.overlay === true) {
        return;
      }
      this.checkForm();

      if (!this.formHasErrors) {
        this.app.overlay = true;
        this.$axios.post('/users/register', {
          address: this.address,
          email: this.email,
          gender: parseInt(this.gender),
          nickname: this.nickname,
          password: this.password,
          username: this.username
        })
          .then(resp => {
            if (resp.status === 200) {
              let code = resp.data.code;
              if (code === 200) {
                this.app.message('注册成功', 'success');
                this.$router.push({
                  path: '/'
                })
              } else if (code === 409) {
                this.app.message('用户名已存在', 'warning')
              } else {
                this.app.message('服务器错误', 'warning')
              }
            }
          })
          .catch(() => {
            this.app.message('注册失败', 'red')
          });
        this.app.overlay = false;
      }

    }
  }
}
</script>

<style scoped>
#registerBase {
  margin-top: 20px;
}
</style>
