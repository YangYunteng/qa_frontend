<template>
  <v-container>
    <v-data-iterator :items="problems"      hide-default-footer>
      <v-row>
        <v-col v-for="item in problems"
               :key="item.qId"
               cols="12"
               sm="12"
               md="12"
               lg="12">
          <h2>{{item.qTitle}}</h2>
          <p style="text-overflow: ellipsis; overflow: hidden; display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 2;">
            <b>{{item.answererId}}: </b>{{item.aContent}}
          </p>
          <v-btn tile color="primary">
            <v-icon left>mdi-thumb-up</v-icon>
            赞同
          </v-btn>
          <v-btn icon class="ma-2" text>
            <v-icon>mdi-thumb-down</v-icon>
          </v-btn>
          <v-btn class="ma-2" text>
            <v-icon left>mdi-comment-multiple-outline</v-icon>
            查看评论
          </v-btn>
          <comments :q-id="item.aId"></comments>
          <v-divider></v-divider>
        </v-col>
      </v-row>
    </v-data-iterator>
  </v-container>
</template>

<script>
import Comments from "@/components/Comments";
export default {
  name: "problems",
  components: {Comments},
  data(){
    return {
      problems: [{
        qId: 123,
        questionerId: 123,
        qTitle: "为什么二刺螈如此美好？",
        qContent: "二刺螈真的太美好了，我做梦都想去二刺螈！😭😭😭，二刺螈，我的二刺螈！",
        answererId: 123,
        aId:123,
        //aPicture: null,
        aContent: "傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？傻狗二刺螈，怎么还没死透啊😅？",
        likes: 59889,
        comments: 23333
      }, {
        qId: 124,
        questionerId: 124,
        qTitle: "为什么三刺螈如此美好？",
        qContent: "三刺螈真的太美好了，我做梦都想去3刺螈！😭😭😭，3刺螈，我的3刺螈！",
        answererId: 124,
        aId:124,
        //aPicture: null,
        aContent: "傻狗3刺螈，怎么还没死透啊😅？",
        likes: 0,
        comments: 0
      }]
    }
  }
}
</script>

<style scoped>

</style>
