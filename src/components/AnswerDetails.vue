<template>
  <v-container>
    <v-banner :sticky="true" elevation="10" style="background-color: white">
      <v-list>
        <v-list-item><h2>{{question.title}}</h2></v-list-item>
        <v-list-item><p>{{question.content}}</p></v-list-item>
        <v-list-item>提问者： <b>   {{questioner.username }}   </b><div style="color: gray; font-size: small; margin-left: 20px">{{ questioner.nickname }}</div></v-list-item>
      </v-list>
    </v-banner>
    <v-container>
      <v-data-iterator      :items="answers"
                            hide-default-footer>
        <v-row>
          <v-col v-for="(item,index) in answers"
                 :key="index"
                 cols="12"
                 sm="12"
                 md="12"
                 lg="12">
            <v-card outlined>
              <v-card-title>
                <v-list>
                  <v-list-item>
                    <v-avatar left>
                      <v-img src="https://cdn.vuetifyjs.com/images/john.png"></v-img>
                    </v-avatar>
                    <div style="margin-left: 20px"><b>   {{answerers[index].username}}</b></div>
                    <div style="color: gray; font-size: small; margin-left: 20px">{{ answerers[index].nickname }}</div>
                  </v-list-item>
                </v-list>
              </v-card-title>
              <v-card-text style="color: black">
                <p>{{answers[index].content}}</p>
                <div style="text-align: right;">创建于：{{answers[index].createdTime}} 更新于：{{answers[index].updatedTime}}</div>

                <v-btn tile color="primary">
                  <v-icon left>mdi-thumb-up</v-icon>
                  赞同 {{answers[index].likes}}
                </v-btn>
                <v-btn icon class="ma-2" text>
                  <v-icon>mdi-thumb-down</v-icon>
                </v-btn>
                <v-btn class="ma-2" text>
                  <v-icon left>mdi-comment-multiple-outline</v-icon>
                  查看评论
                </v-btn>
                <comments :q-id="answers[index].aId"></comments>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-data-iterator>
    </v-container>
  </v-container>
</template>

<script>
import Comments from "@/components/Comments";
export default {
  name: "AnswerDetails",
  components: {Comments},
  data(){
    return{
      question:{
        title:"为什么二刺螈如此美好？",
        content:"二刺螈真的太美好了，我做梦都想去二刺螈！😭😭😭，二刺螈，我的二刺螈！",
      },
      questioner: {
        id:123,
        username: "glc123",
        nickname: "不是二刺螈"
      },
      answers:[{
        answererId:123,
        content:"傻狗二刺螈，怎么还没死透啊😅？",
        createdTime:"2021-04-13 7:50:54",
        updatedTime:"2021-04-13 7:50:54",
        aId:123,
        likes: 67997
      },{
        answererId:124,
        content:"傻狗3刺螈，怎么还没死透啊😅？",
        createdTime:"2021-03-30 15:20:54",
        updatedTime:"2021-04-18 15:20:54",
        aId:124,
        likes: 3
      }],
      answerers: [{
        id:124,
        username: "ylhssb",
        nickname: "不是3刺螈"
      },{
        id:125,
        username: "fjy",
        nickname: "88刺螈"
      }],
      index:0
    }
  }
}
</script>

<style scoped>

</style>
