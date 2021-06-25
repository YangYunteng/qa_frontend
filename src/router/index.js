import Vue from 'vue'
import store from '../store/index'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import Login from "@/views/Login";
import Register from "@/views/Register";
import UserHome from "@/views/UserHome";
import Error from "@/views/Error";
import UserHomeWelcome from "@/views/UserHomeWelcome";
import UserInfo from "@/views/UserInfo";


import FollowingQuestions from "@/views/FollowingQuestions";
import HotQuestions from "@/views/HotQuestions";
import SearchedQuestions from "@/views/SearchedQuestions";
import QuestionDetails from "@/components/QuestionDetails";
import SuggestionsView from "@/views/SuggestionsView";
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/error/:id', name: 'Error',
    component: Error
  },
  {
    path: '*', name: 'NotFound',
    component: Error
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/userHome',
    name: 'UserHome',
    component: UserHome,
    meta:
      {
        requireAuth: true
      },
    children: [
      {
        path: '',
        name: 'UserHomeWelcome',
        component: UserHomeWelcome
      },
      {
        path: 'hotQuestions',
        name: 'HotQuestions',
        component: HotQuestions
      },
      {
        path: 'followingQuestions',
        name: 'FollowingQuestions',
        component: FollowingQuestions
      },
      {
        path: 'searchedQuestions/:search',
        name: 'SearchedQuestions',
        component: SearchedQuestions,
        props: true
      }, {
        path: 'questionDetails/:questionID',
        name: 'QuestionDetails',
        component: QuestionDetails,
        props: true
      },
      {
        path: 'suggestionsView',
        name: 'SuggestionsView',
        component: SuggestionsView,
      },
      {
        path: 'userInfo',
        name: 'userInfo',
        component: UserInfo,
      }
    ]
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

// 前端登录拦截
router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requireAuth)) {
    if (store.state.token) {
      next();
    } else {
      next({
        path: '/login',
        query: {redirect: to.fullPath} // 登录成功之后重新跳转到该路由
      });
    }
  } else {
    next();
  }
});

export default router
