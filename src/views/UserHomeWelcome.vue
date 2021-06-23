<template>
  <v-container>
    <mind-map style="width: 700px;
            height: 400px;
            margin:50px auto;
            position: relative;"></mind-map>
    <v-row justify="center">
      <h3 style="letter-spacing: 1px">您好, 亲爱的 {{ username }}<br class="d-md-none"></h3>
    </v-row>
    <v-row justify="center" class="mt-12">
      <v-img src="../assets/logo.png" max-width="50%"></v-img>
    </v-row>
  </v-container>
</template>

<script>
import MindMap from "@/components/MindMap";
export default {
  name: "UserHomeWelcome",
  components: {MindMap},
  data() {
    return {
      app: this.$root.$children[0],
    }
  },
  computed: {
    username: function () {
      return this.$store.state.userDetails ? this.$store.state.userDetails.nickname : 'xxx';
    }
  }
}
</script>

<style scoped>

</style>
