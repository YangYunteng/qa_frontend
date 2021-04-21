<template>
  <v-container>
    {{comments.length}}条评论：
    <v-data-iterator :items="comments"      hide-default-footer>
      <v-row>
        <v-col v-for="(item,o) in comments"
               :key="o"
               cols="12"
               sm="12"
               md="12"
               lg="12">
          <b>{{item.commenter}}: </b>{{item.cContent}}
          <br>
          <v-divider v-if="o+1!==comments.length"></v-divider>
        </v-col>
      </v-row>
    </v-data-iterator>
  </v-container>
</template>

<script>
export default {
  name: "Comments",
  props:{qId:Number},
  data(){
    return {
      comments: [{
        commenter: "glc123",
        cid:123,
        cContent: "说得好，二刺螈该死！",
        likes: 1
      }, {
        cid:345,
        commenter: "ylhssb",
        cContent: "说得坏，3刺螈该死！",
        likes: 2
      }]
    }
  }
}
</script>

<style scoped>

</style>
