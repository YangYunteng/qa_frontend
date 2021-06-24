<template>
  <div>
    <Suggestions :suggestions="suggestions" ref="Suggestions"></Suggestions>
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
      suggestions: [
        {
          suggester_id: 10,
          suggester_name: "yyy1",
          content: "建议修改xxxxxxxx",
          updated_at:""
        },
        {
          suggester_id: 10,
          suggester_name: "yyy1",
          content: "建议修改xxxxxxxx"
        },
        {
          suggester_id: 10,
          suggester_name: "yyy1",
          content: "建议修改xxxxxxxx"
        },
      ]
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
