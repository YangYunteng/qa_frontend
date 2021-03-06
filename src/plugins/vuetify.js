import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';
import store from '../store'

Vue.use(Vuetify);

export default new Vuetify({
  theme: {
    // dark 主题配合深色背景图片使用
    //true or false
    dark: store.state.themeIsDark,
  }
});
