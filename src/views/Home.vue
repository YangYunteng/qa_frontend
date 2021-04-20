<template>
  <v-app :class="app.backgroundStyle">
    <HomeNavigation></HomeNavigation>
    <v-main>
      <router-view/>
    </v-main>
  </v-app>
</template>

<script>
// @ is an alias to /src
import HomeNavigation from "@/components/Home/HomeNavigation";

export default {
  name: 'Home',
  components: {
    HomeNavigation
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
