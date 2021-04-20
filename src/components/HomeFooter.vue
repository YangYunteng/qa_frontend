<template>
  <div id="footer">
    <v-footer absolute padless color="rgba(255,255,255,0)">
      <v-card flat class="text-center" width="100%" :color="app.whiteOpacity">
        <v-card-text>
          Copyright&nbsp;&copy;&nbsp;2021&nbsp;Advanced Web&nbsp;Q&A.&nbsp;All&nbsp;rights&nbsp;reserved.
        </v-card-text>
      </v-card>
    </v-footer>
  </div>
</template>

<script>
export default {
  name: "HomeFooter",

  data() {
    return {
      app: this.$root.$children[0]
    }
  }
}
</script>

<style scoped>

</style>
