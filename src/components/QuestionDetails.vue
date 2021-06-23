<template>
  <v-container>
    <v-card color="rgb(255,255,255,0.5)">
      <v-row>
        <v-col cols="5" class="ml-4">
          <h2>{{ question.title }}</h2>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="5" class="ml-6"><strong>发起人: </strong>{{ questioner.nickname }}</v-col>
        <v-spacer></v-spacer>
        <v-col cols="3"><strong>创建时间: </strong>{{ getTime(question.CreatedAt) }}</v-col>
        <v-col cols="3"><strong>更新时间: </strong>{{ getTime(question.UpdatedAt) }}</v-col>
      </v-row>
      <v-row class="justify-center">
        <v-col cols="11">
          <v-expansion-panels popout>
            <v-expansion-panel>
              <v-expansion-panel-header><strong>问题描述</strong></v-expansion-panel-header>
              <v-expansion-panel-content><p v-html="question.content"></p></v-expansion-panel-content>
            </v-expansion-panel>
          </v-expansion-panels>
        </v-col>
      </v-row>
      <v-row>
        <v-spacer></v-spacer>
        <v-col cols="4">
          <v-btn tile color="primary" @click="openAnswerDialog">
            <v-icon left>mdi-pencil</v-icon>
            写回答
          </v-btn>
          <v-btn color="primary" dark v-if="!question.isFollowed" class="ml-3" @click="followQuestion(question.ID)">
            <v-icon left>mdi-star</v-icon>
            关注
          </v-btn>
          <v-btn color="error" dark v-if="question.isFollowed" class="ml-3"
                 @click="cancelFollowQuestion(questionID)">
            <v-icon left>mdi-bell-cancel</v-icon>
            取消关注
          </v-btn>
        </v-col>
      </v-row>
    </v-card>
    <v-card class="mt-8" color="rgb(255,255,255,0.5)">
      <Answers :questionID="questionID" ref="Answers"></Answers>
    </v-card>

    <v-dialog
      persistent
      max-width="800px"
      v-model="isAnswerDialogOn"
    >
      <template>
        <v-card>
          <v-toolbar
            color="primary"
            dark
          >写下你的答案
          </v-toolbar>
          <v-card-text class="mt-5">
            <MarkdownInput @transformHtml="receiveHtml" ref="markdownInput" placeholder="你的答案..."></MarkdownInput>
          </v-card-text>
          <v-card-actions class="justify-end">
            <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="submitAnswer">提交回答</v-btn>
            <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="cancelAnswerDialog">取消</v-btn>
          </v-card-actions>
        </v-card>
      </template>
    </v-dialog>
  </v-container>
</template>

<script>
import Answers from "@/components/Answers";
import MarkdownInput from "@/components/MarkdownInput";


export default {
  name: "QuestionDetails",
  components: {MarkdownInput, Answers},
  data() {
    return {
      app: this.$root.$children[0],
      answer: '',
      page: 1,
      isAnswerDialogOn: false,
      question: {},
      questioner: {},
      answers: {},
      pageSize: 5,
      paginationLen: 2,
    }
  },

  methods: {
    goTo(src) {
      this.$router.replace(src)
    },
    receiveHtml: function (msg) {
      this.answer = msg;
    },
    cancelAnswerDialog: function () {
      this.isAnswerDialogOn = false;
    },
    openAnswerDialog: function () {
      this.isAnswerDialogOn = true;
    },
    judgeAnswerCanPost: function () {
      if (this.answer === '') {
        this.app.message('答案不能为空');
        return false;
      }
      return true;
    },
    submitAnswer: function () {
      if (this.app.overlay)
        return;
      let canPost = this.judgeAnswerCanPost();
      if (canPost) {
        this.app.overlay = true;
        let path = '/questions/' + this.question.ID + '/answers';
        this.$axios.post(path,
          {
            "content": this.answer,
          },
        ).then(resp => {
          if (resp.data.code === 200) {
            this.answer = '';
            this.$refs.markdownInput.content = '';
            this.cancelAnswerDialog();
            this.app.message('回答提交成功,正在进行数据库写入,请稍后查询', 'success');
            this.$refs.Answers.queryAnswers();
          } else {
            this.app.message("回答提交失败", 'warning');
          }
          this.app.overlay = false;
        }).catch(err => {
          this.app.message('服务器在忙', 'red');
        })

      }
    },

    getTime(date) {
      date = new Date(date);
      let res = '';
      res += date.getFullYear() + '-';
      res += this.timeComplement(date.getMonth() + 1, 2) + '-';
      res += this.timeComplement(date.getDate(), 2) + ' ';
      res += this.timeComplement(date.getHours(), 2) + ':';
      res += this.timeComplement(date.getMinutes(), 2) + ':';
      res += this.timeComplement(date.getSeconds(), 2);
      return res;
    },
    timeComplement: function (timeElement, len) {
      timeElement = timeElement + '';
      if (timeElement.length < len) {
        for (let i = timeElement.length; i < len; i++) {
          timeElement = '0' + timeElement;
        }
      }
      return timeElement;
    },

    getQuestionDetails: function (questionID) {
      let path = '/questions/' + this.questionID;
      this.$axios.get(path, {}).then(resp => {
        if (resp.status === 200 && resp.data.code === 200) {
          this.question = resp.data.data;
          this.questioner = this.question.questioner;
          path = '/questions/' + this.questionID + '/follows';
          this.$axios.get(path, {
            params: {
              "question-id": questionID,
            }
          }).then(resp => {
            if (resp.data.code === 200) {
              this.$set(this.question, 'isFollowed', resp.data.data);
            } else {
              this.$set(this.question, 'isFollowed', false);
            }
          })
        } else {
          this.app.message("数据加载失败", 'warning');
        }
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    },

    followQuestion: function (questionID) {
      let path = '/questions/' + questionID + '/follows';
      this.$axios.post(path, {}).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.question, 'isFollowed', true);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })

    },

    cancelFollowQuestion: function (questionID) {
      let path = '/questions/' + questionID + '/follows';
      this.$axios.delete(path, {}).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.question, 'isFollowed', false);
        }
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    },
    sleep: function (NumMillis) {
      let nowTime = new Date();
      let exitTime = nowTime.getTime() + NumMillis;
      for (; ;) {
        let now = new Date();
        if (now.getTime() > exitTime)
          return;
      }
    }
  },

  props: ['questionID'],

  mounted() {
    this.getQuestionDetails(this.questionID);
    this.$refs.Answers.queryAnswers();
  },


}
</script>

<style scoped>

</style>
