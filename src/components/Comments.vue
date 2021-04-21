<template>
  <v-container>
    {{comments.length}}条评论：
    <v-card outlined style="padding: 20px">
      <v-data-iterator :items="comments"      hide-default-footer>
        <v-row v-for="(item,o) in comments"
               :key="o"
               cols="12"
        >
          <v-col>
            <b>{{item.commenter}}: </b>{{item.cContent}}
          </v-col>
          <v-divider v-if="o+1!==comments.length"></v-divider>
        </v-row>

      </v-data-iterator>
    </v-card>
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
