import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
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
