<template>
  <div>
    <Questions ref="questions"></Questions>
    <!--    <v-pagination-->
    <!--      v-model="questionPage"-->
    <!--      :length="questionPaginationLen"-->
    <!--      :total-visible="6"-->
    <!--      @input="getHotQuestions"-->
    <!--    ></v-pagination>-->
  </div>
</template>

<script>
import Questions from "@/components/Questions";

export default {
  name: "HotQuestions",
  components: {Questions},
  data() {
    return {
      app: this.$root.$children[0],
    }
  },
  methods: {
    getHotQuestions: function () {
      if (this.app.overlay === true)
        return;
      this.app.overlay = true;
      this.questions = [];
      this.axios.get('/userServer/hot-list', {})
        .then(resp => {
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
            this.app.message('目前没有热点问题', "warning");
          }
          this.app.overlay = false;
        })
        .catch(() => {
          this.app.message("服务器在忙", 'red');
        })
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
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
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
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    }
  },
  mounted() {
    this.getHotQuestions();
  }
}
</script>

<style scoped>

</style>
