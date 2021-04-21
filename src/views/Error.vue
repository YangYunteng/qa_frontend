<template>
  <v-app id="error">
    <v-card width="100%" height="100%" color="black">
      <v-container>
        <v-row justify="center" class="mt-12">
          <v-card-title class="display-3 font-weight-bold white--text text-no-wrap">{{errorMessage}}</v-card-title>
        </v-row>
        <v-row justify="center">
          <v-card-subtitle class="title white--text">This page has jumped to another world line</v-card-subtitle>
        </v-row>
        <v-row justify="center">
          <v-img src="../assets/WorldLine.jpg"></v-img>
        </v-row>
      </v-container>
    </v-card>
  </v-app>
</template>

<script>
import StatusCodes from "../data/StatusCode";

export default {
  name: 'Error',
  data() {
    return {}
  },
  computed: {
    errorMessage: function () {
      if (/^\/error\/((40[0-9])|(41[0-7]))$/.test(this.$route.path)) {
        return StatusCodes[this.$route.params.id];
      } else {
        return StatusCodes[404];
      }
    }
  }
}
</script>
