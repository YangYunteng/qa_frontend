<template>
  <v-app :class="app.backgroundStyle" id="home">
    <HomeNavigation></HomeNavigation>
    <v-main class="mt-8">
      <v-container class="mb-12 pb-12">
        <v-row class="mt-16 mb-16" justify="center">
          <v-img src="../assets/logo.png"
                 max-width="80%" data-test="logo"></v-img>
        </v-row>
        <v-row align="center" justify="center">
          <v-col cols="12" md="9">
            <v-card :color="app.whiteOpacity" class="mt-3" data-test="card">
              <v-card-title class="display-1 font-weight-light" data-test="title">
                欢迎来到 Q&A
              </v-card-title>
              <v-card-subtitle class="title font-weight-thin" data-test="subtitle">
                一个强大的论坛
              </v-card-subtitle>
              <v-card-text class="headline font-weight-light mt-5">
                Q&A 是一个神奇的网站。
                你所感兴趣的，不知道的在这里都可以找到答案
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
    <HomeFooter></HomeFooter>
  </v-app>
</template>

<script>
// @ is an alias to /src
import HomeNavigation from "@/components/HomeNavigation";
import HomeFooter from "@/components/HomeFooter";

export default {
  name: 'Home',
  components: {
    HomeNavigation,
    HomeFooter
  },
  data() {
    return {
      app: this.$root.$children[0],
    }
  }

}
</script>

<style>
.darkBg {
  background: url("../assets/dark_bg.jpg") center fixed !important;
}

.lightBg {
  background: url("../assets/light_bg.jpg") center fixed !important;
}
</style>
