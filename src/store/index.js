import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: localStorage.getItem('token') || null,
    expiredAt: localStorage.getItem('expiredAt') || null,
    userDetails: JSON.parse(localStorage.getItem('userDetails')) || null,
    themeIsDark: localStorage.getItem('theme') === 'dark',
    userdata: localStorage.getItem('userdata') ||null,
    userdata2: localStorage.getItem('userdata2') ||null
  },
  mutations: {
    login(state, data) {
      localStorage.setItem('token', data.Token);
      localStorage.setItem('expiredAt', data.ExpiredAt);
      state.token = data.Token;
      state.expiredAt = data.ExpiredAt;
    },
    logout(state) {
      //移除token信息
      localStorage.removeItem('token');
      localStorage.removeItem('expiredAt');
      localStorage.removeItem('userDetails');
      state.token = null;
      state.expiredAt = null;
      state.userDetails = null;
    },
    updateUserDetails(state, userDetails) {
      localStorage.setItem('userDetails', JSON.stringify(userDetails));
      state.userDetails = userDetails;
    },
    changeTheme(state, isDark) {
      const theme = isDark ? 'dark' : 'light';
      localStorage.removeItem('theme');
      localStorage.setItem('theme', theme);
      state.themeIsDark = isDark;
    },
    setUserData(state,data){
      localStorage.setItem('userdata',data);
      state.userdata = data;
    },
    setUserData2(state,data){
      localStorage.setItem('userdata2',data);
      state.userdata2 = data;
    }
  },
  actions: {},
  modules: {},
  getters: {
    getUserData: state => state.userdata,
    getUserData2: state => state.userdata2,
  }
})
