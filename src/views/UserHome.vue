<template>
  <v-app :class="app.backgroundStyle">
    <UserHomeNavigation></UserHomeNavigation>
    <v-main class="temp">
      <Problems></Problems>
    </v-main>
  </v-app>
</template>

<script>
import UserHomeNavigation from "@/components/UserHomeNavigation";
import MarkdownInput from "@/components/MarkdownInput";
import Problems from "@/components/Problems";

export default {
  name: "UserHome",
  data() {
    return {
      app: this.$root.$children[0],
    }
  },

  components: {

    UserHomeNavigation,
    // MarkdownInput,
    Problems
  }
}
</script>

<style scoped>
.temp {
  margin-top: 10px;
}
</style>
