<template>
  <v-container>
    <v-card color="rgb(255,255,255,0.5)" class="mt-7" v-for="(item,index) in questions"
            :key="index">
      <v-card-title
        class="text-h4" @click="toAnswerDetails(item.ID)"
        v-text="item.title"
      ></v-card-title>
      <v-card-subtitle>
        发起人:{{ item.questionerNickname }}
      </v-card-subtitle>
      <v-row class="justify-center">
        <v-col cols="11">
          <v-expansion-panels popout>
            <v-expansion-panel>
              <v-expansion-panel-header><strong>问题描述</strong></v-expansion-panel-header>
              <v-expansion-panel-content><p v-html="item.content"></p></v-expansion-panel-content>
            </v-expansion-panel>
          </v-expansion-panels>
        </v-col>
      </v-row>
      <v-row class="d-flex">
        <v-spacer></v-spacer>
        <v-col cols="5">
          <v-btn color="primary" dark class="ml-3" @click="toAnswerDetails(item.ID)">
            <v-icon left>mdi-pencil</v-icon>
            写回答
          </v-btn>
          <v-btn color="primary" dark v-if="!item.isFollowed" class="ml-3"
                 @click="followQuestion(item.ID,index)">
            <v-icon left>mdi-star</v-icon>
            关注
          </v-btn>
          <v-btn color="error" dark v-if="item.isFollowed" class="ml-3"
                 @click="cancelFollowQuestion(item.ID,index)">
            <v-icon left>mdi-bell-cancel</v-icon>
            取消关注
          </v-btn>
          <v-btn class="ml-3" color="success" @click="toAnswerDetails(item.ID)">
            <v-icon left>mdi-comment-multiple-outline</v-icon>
            查看详情
          </v-btn>
          <v-btn class="ml-3" color="error" v-if="canDelete(item.questionerID)" @click="deleteQuestion(item.ID,index)">
            <v-icon left>mdi-delete</v-icon>
            删除
          </v-btn>
        </v-col>
      </v-row>
    </v-card>
  </v-container>
</template>

<script>
import Comments from "@/components/Answers";

export default {
  name: "Questions",
  // components: {Comments},
  data() {
    return {
      app: this.$root.$children[0],
      questions: [],
    }
  },
  methods: {
    goTo: function (src) {
      this.$router.replace(src)
    },
    transferData: function (questions) {
      this.questions = questions;
    },
    canDelete(id) {
      return id === this.$store.state.userDetails.ID;
    },
    toAnswerDetails: function (questionID) {
      this.$router.push({
        name: 'QuestionDetails',
        params: {
          questionID: questionID
        }
      })
    },

    followQuestion(questionID, index) {
      let path = '/userServer/questions/' + questionID + '/follows';
      this.$axios.post(path, {}).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.questions[index], 'isFollowed', true);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    deleteQuestion(questionID, index) {
      let path = '/userServer/questions/' + questionID;
      this.$axios.delete(path, {}).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("问题删除成功", 'success');
          this.questions.splice(index, 1);
        }
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    },
    cancelFollowQuestion(questionID, index) {
      let path = '/userServer/questions/' + questionID + '/follows';
      this.$axios.delete(path, {}).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.questions[index], 'isFollowed', false);
        }
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    }
  },

}
</script>

<style scoped>
.text-h4:hover {
  cursor: pointer;
}
</style>
