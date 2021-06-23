<template>
  <v-app :class="app.backgroundStyle" id="UserHome">
    <UserHomeNavigation></UserHomeNavigation>
    <v-main class="temp">
      <router-view/>
    </v-main>
  </v-app>
</template>

<script>
import UserHomeNavigation from "@/components/UserHomeNavigation";

export default {
  name: "UserHome",
  data() {
    return {
      app: this.$root.$children[0],
    }
  },

  components: {
    UserHomeNavigation,
  },
  methods: {},

}
</script>

<style scoped>
.temp {
  margin-top: 10px;
}
</style>
