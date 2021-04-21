<template>
  <v-app>
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
  components:{
    UserHomeNavigation,
    // MarkdownInput,
    Problems
  }
}
</script>

<style scoped>
.temp{
  margin-top: 100px;
}
</style>
