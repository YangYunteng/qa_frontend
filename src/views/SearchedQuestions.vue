<template>
  <div>
    <Questions ref="questions"></Questions>
    <v-pagination v-if="questionTotal!=0"
                  v-model="questionPage"
                  :length="questionPaginationLen"
                  :total-visible="6"
                  @input="searchQuestion"
    ></v-pagination>
  </div>
</template>

<script>
import Questions from "@/components/Questions";

export default {
  name: "SearchedQuestions",
  components: {Questions},
  props: ["search"],
  data() {
    return {
      app: this.$root.$children[0],
      questions: [],
      questionTotal: 0,
      questionPage: 1,
      questionPaginationLen: 1,
      questionPageSize: 5
    }
  },
  methods: {
    searchQuestion: function () {
      if (this.app.overlay === true)
        return;
      if (this.search === '')
        return;
      // console.log(this.search);
      this.app.overlay = true;
      this.questions = [];
      this.axios.get('/userServer/questions', {
          params: {
            search: this.search,
            pageNum: this.questionPage,
            pageSize: this.questionPageSize,
            orderBy: 'score desc',
          }
        }
      )
        .then(resp => {
          this.questionTotal = resp.headers.totalcount;
          this.questionPaginationLen = Math.ceil(this.questionTotal / this.questionPageSize);
          if (resp.status === 200 && resp.data.code === 200 && resp.data.data != null) {
            this.questions = resp.data.data;
            for (let i = 0; i < this.questions.length; i++) {
              let questionID = this.questions[i].ID;
              let questionerID = this.questions[i].questionerID;
              this.isQuestionFollowed(questionID, i);
              this.queryQuestionerNickname(questionerID, i);
            }
            this.$refs.questions.transferData(this.questions);
          } else {
            this.app.message("无相关问题，快去提问吧", "success");
          }
        })
        .catch(error => {
          console.log(error);
        })
      this.app.overlay = false;
    },

    isQuestionFollowed: function (questionID, index) {
      this.$axios.get('/userServer/questions/' + questionID + '/follows', {
        params: {
          "question-id": questionID
        }
      }).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.questions[index], 'isFollowed', resp.data.data);
        } else {
          this.$set(this.questions[index], 'isFollowed', resp.data.data);
        }
      }).catch(err => {
        console.log(err)
      })
    },
    queryQuestionerNickname(questionerID, index) {
      this.$axios.get('/userServer/users/' + questionerID, {
        params: {
          "user-id": questionerID
        }
      }).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.questions[index], 'questionerNickname', resp.data.data.nickname);
        } else {
          this.$set(this.questions[index], 'questionerNickname', '未知');
        }
      }).catch(err => {
        console.log(err);
      })
    }
  },
  mounted() {
    this.searchQuestion();
  }
}
</script>

<style scoped>

</style>
