<template>
  <v-app style="background-color: rgba(0,0,0,0)">
    <v-navigation-drawer style="background-color: rgba(0,0,0,0); position: absolute; height: 90%;"><q-a-robot></q-a-robot></v-navigation-drawer>
    <v-container>
        <mind-map style="width: 700px;
          height: 400px;
          margin:50px auto 50px;
          display: flex;"></mind-map>
        <v-row justify="center">
          <h3 style="letter-spacing: 1px">您好, 亲爱的 {{ username }}<br></h3>
        </v-row>
        <v-row justify="center" class="mt-12">
          <v-img src="../assets/logo.png" max-width="50%"></v-img>
        </v-row>
    </v-container>

  </v-app>
</template>

<script>
import MindMap from "@/components/MindMap";
import QARobot from "@/components/QARobot/QARobot";
export default {
  name: "UserHomeWelcome",
  //components: {QARobot},
  components: {QARobot, MindMap},
  data() {
    return {
      app: this.$root.$children[0],
    }
  },
  computed: {
    isAdmin: function () {
      return this.$store.state.userDetails.ID===1;
    },
    username: function () {
      return this.$store.state.userDetails ? this.$store.state.userDetails.nickname : 'xxx';
    }
  }

}
</script>

<style scoped>

</style>
