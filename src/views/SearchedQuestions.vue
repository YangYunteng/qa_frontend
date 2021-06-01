<template>
  <Questions ref="questions"></Questions>
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
      this.axios.get('/questions', {
          params: {
            search: this.search,
            pageNum: 1,
            pageSize: 5,
          }
        }
      )
        .then(resp => {
          if (resp.status === 200 && resp.data.code === 200) {
            this.questions = resp.data.data;
            for (let i = 0; i < this.questions.length; i++) {
              let questionID = this.questions[i].ID;
              let questionerID = this.questions[i].questionerID;
              this.isQuestionFollowed(questionID, i);
              this.queryQuestionerNickname(questionerID, i);
            }
            this.$refs.questions.transferData(this.questions);
          }
        })
        .catch(() => {
          this.app.message("服务器在忙", 'red');
        })
      this.app.overlay = false;
    },

    isQuestionFollowed: function (questionID, index) {
      this.$axios.get('/questions/' + questionID + '/follows', {
        params: {
          "question-id": questionID
        }
      }).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.questions[index], 'isFollowed', resp.data.data);
        } else {
          this.$set(this.questions[index], 'isFollowed', resp.data.data);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    queryQuestionerNickname(questionerID, index) {
      this.$axios.get('/users/' + questionerID, {
        params: {
          "user-id": questionerID
        }
      }).then(resp => {
        if (resp.data.code === 200) {
          this.$set(this.questions[index], 'questionerNickname', resp.data.data.nickname);
        } else {
          this.$set(this.questions[index], 'questionerNickname', '未知');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    }
  },
  mounted() {
    this.searchQuestion();
    //this.isQuestionFollowed(11)
  }
}
</script>

<style scoped>

</style>
