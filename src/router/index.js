import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import MarkdownInput from "@/components/MarkdownInput";
import Problems from "@/components/Problems";

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/markdownInput',
    name: 'MarkdownInput',
    component: MarkdownInput
  },
  {
    path: '/problems',
    name: 'Problems',
    component: Problems
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
