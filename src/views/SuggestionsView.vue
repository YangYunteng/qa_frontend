<template>
  <div>
    <Suggestions ref="Suggestions"></Suggestions>
  </div>
</template>

<script>
import Suggestions from "@/components/Suggestions";

export default {
  name: "SuggestionsView",
  components: {Suggestions},
  data() {
    return {
      app: this.$root.$children[0],
    }
  },
  methods: {
  },
  mounted() {
    this.$refs.Suggestions.querySuggestions();
  }
}


</script>

<style scoped>

</style>
