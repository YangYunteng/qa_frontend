<template>
  <v-container>
    <v-row justify="center" class="mt-12">
      <v-img src="../assets/logo.png" max-width="80%"></v-img>
    </v-row>
    <v-row justify="center" class="mt-12">
      <v-col cols="9">
        <v-card :color="app.whiteOpacity">
          <v-card-title class="display-1 font-weight-light">
            您好, 亲爱的 {{ username }}<br class="d-md-none">
          </v-card-title>
          <v-card-subtitle class="title font-weight-thin"></v-card-subtitle>
          <v-card-text class="headline font-weight-light">QA 是一个强大的论坛。
            你所感兴趣的，不知道的在这里都可以找寻答案和有缘人的回答
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "UserHomeWelcome",
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
