<template>
  <v-app :class="app.backgroundStyle" id="home">
    <HomeNavigation></HomeNavigation>
    <v-main class="mt-8">
      <MindMap style="width: 700px;
            height: 500px;
            margin:50px auto;
            position: relative;">
      </MindMap>
    </v-main>
    <HomeFooter></HomeFooter>
  </v-app>
</template>

<script>
// @ is an alias to /src
import HomeNavigation from "@/components/HomeNavigation";
import HomeFooter from "@/components/HomeFooter";
import MindMap from "@/components/MindMap";

export default {
  name: 'Home',
  components: {
    HomeNavigation,
    HomeFooter,
    MindMap
  },
  data() {
    return {
      app: this.$root.$children[0],
      counter:0
    }
  },
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
