<template>
  <div>
    <v-app :class="app.backgroundStyle">
      <HomeNavigation></HomeNavigation>
      <v-main>
        <v-app style="background-color: rgba(0,0,0,0);">
          <v-navigation-drawer style="background-color: rgba(0,0,0,0); position: absolute; height: 90%; z-index: 2"><q-a-robot></q-a-robot></v-navigation-drawer>
          <v-container>
            <v-main class="mt-8">
              <MindMap style="width: 600px;
                    height: 400px;
                    margin: 0 auto;
                    position: relative;" question="" :query-state="1" :middle-button="true">
              </MindMap>
            </v-main>
          </v-container>
        </v-app>
        <HomeFooter></HomeFooter>
      </v-main>

    </v-app>
  </div>
</template>

<script>
// @ is an alias to /src
import HomeNavigation from "@/components/HomeNavigation";
import HomeFooter from "@/components/HomeFooter";
import MindMap from "@/components/MindMap";
import QARobot from "@/components/QARobot/QARobot";

export default {
  name: 'Home',
  components: {
    QARobot,
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
