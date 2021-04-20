import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: localStorage.getItem('token') || null,
    expires: localStorage.getItem('expires') || null,
    themeIsDark: localStorage.getItem('theme') === 'dark',
  },
  mutations: {
    changeTheme(state, isDark) {
      const theme = isDark ? 'dark' : 'light';
      localStorage.removeItem('theme');
      localStorage.setItem('theme', theme);
      state.themeIsDark = isDark;
    }
  },
  actions: {},
  modules: {}
})
