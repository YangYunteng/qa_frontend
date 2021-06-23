<template>
  <div>
    <p>Hello Suggestions!</p>
  </div>
</template>

<script>
export default {
  name: "SuggestionsView",
  data() {
    return {
      app: this.$root.$children[0],
    }
  },
  mounted() {
    let path = '/adminServer/admin/suggestions';
    this.$axios.get(path, {
      pageNum: 1,
      pageSize: 5,
      orderBy: 'updated_at asc',
      locked: false
    }).then(resp => {
      console.log(resp);
    }).catch(() => {
      this.app.message("服务器在忙", 'red');
    })
  }
}


</script>

<style scoped>

</style>
