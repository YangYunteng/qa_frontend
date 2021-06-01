<template>
  <v-container>
    <b class="text-h7 ml-2">{{ total }} 条回答：</b>
    <v-card v-for="(item,index) in answers" :key="index" color="rgb(255,255,255,0.6)" class="mt-2" outlined
            min-height="50px">
      <v-row>
        <v-col cols="5">
          <b>{{ item.answererNickname }}: </b>
        </v-col>
        <v-spacer></v-spacer>
        <v-col cols="2">
          {{ item.likesCount }}
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="black" dark v-bind="attrs" v-on="on"
                      v-if="!item.isLiked" @click="likeAnswer(item.ID)" style="cursor: pointer">
                mdi-heart-outline
              </v-icon>
            </template>
            <span>点赞</span>
          </v-tooltip>
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="red" v-bind="attrs" v-on="on"
                      v-if="!item.isLiked" @click="cancelLikeAnswer(item.ID)" style="cursor: pointer">
                mdi-cards-heart
              </v-icon>
            </template>
            <span>取消点赞</span>
          </v-tooltip>
          <v-tooltip bottom v-if="canDelete(item.answererID)">
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                      @click="deleteAnswer(item.ID)" style="cursor: pointer">
                mdi-delete
              </v-icon>
            </template>
            <span>删除</span>
          </v-tooltip>
          <v-tooltip bottom v-if="canDelete(item.answererID)">
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                      @click="openModifyAnswerDialog(item,index)"
                      style="cursor: pointer">
                mdi-pencil
              </v-icon>
            </template>
            <span>修改</span>
          </v-tooltip>
        </v-col>
      </v-row>
      <v-row style="margin-top: -20px" class="justify-center">
        <v-col cols="11">
          <p v-html="item.content"></p>
        </v-col>
      </v-row>
      <v-row style="margin-top: -20px">
        <v-col cols="3">{{ getTime(item.UpdatedAt) }}</v-col>
        <v-col>
          <v-chip @click="openCommentDialog(item)">
            33 评论
          </v-chip>
        </v-col>
      </v-row>
    </v-card>
    <div class="text-center">
      <v-pagination
        v-model="answerPage"
        :length="answerPaginationLen"
        :total-visible="6"
        @input="queryAnswers"
      ></v-pagination>
    </div>

    <!--  修改回答的Dialog  -->
    <v-dialog transition="dialog-bottom-transition" v-model="isModifyAnswerDialogOn" width="600px" persistent>
      <v-card>
        <v-toolbar
          color="primary"
          dark
        >修改答案
        </v-toolbar>
        <v-card-text class="mt-5">
          <MarkdownInput @transformHtml="receiveModifyAnswerHtml" ref="modifyAnswerMarkdownInput"
                         placeholder="你的答案..."></MarkdownInput>
        </v-card-text>
        <v-card-actions class="justify-end">
          <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="submitModifyAnswer">提交</v-btn>
          <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="closeModifyAnswerDialog">取消
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 评论Dialog, 显示该问题的所有评论-->
    <v-dialog width="800px" v-model="isCommentDialogOn">
      <template>
        <v-card min-height="600px" width="800px">
          <v-toolbar
            color="primary"
            dark
          >回答详情
          </v-toolbar>
          <v-card-text>
            <v-row>
              <v-col cols="5">
                <b style="color: black">{{ answer.answererNickname }}: </b>
              </v-col>
              <v-spacer></v-spacer>
              <v-col cols="2">
                {{ answer.likesCount }}
                <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-icon color="black" v-bind="attrs" v-on="on"
                            v-if="!answer.isLiked" @click="likeAnswer(answer.ID)"
                            style="cursor: pointer">
                      mdi-heart-outline
                    </v-icon>
                  </template>
                  <span>点赞</span>
                </v-tooltip>
                <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-icon color="red" v-bind="attrs" v-on="on"
                            v-if="!answer.isLiked" @click="cancelLikeAnswer(answer.ID)"
                            style="cursor: pointer">
                      mdi-cards-heart
                    </v-icon>
                  </template>
                  <span>取消点赞</span>
                </v-tooltip>
                <v-btn text @click="openCommentToDialog(answer.answererID)">回复</v-btn>
              </v-col>
            </v-row>
            <v-row class="justify-center" style="margin-top: -30px">
              <v-col cols="11">
                <p v-html="answer.content" style="color: black"></p>
              </v-col>
            </v-row>
            <v-divider></v-divider>
            <div v-if="commentTotal!==0" style="margin-top: 30px">
              <v-card style="color: black" v-for="(item,index) in this.comments" :key="index">
                <v-row>
                  <v-col cols="4">
                    {{ item.fromNickname }} to {{ item.toNickName }}
                  </v-col>
                  <v-spacer></v-spacer>
                  <v-col cols="4">
                    {{ item.likesCount }}
                    <v-tooltip bottom>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="black" v-bind="attrs" v-on="on"
                                v-if="!item.isLiked" @click="likeComment(item.ID)"
                                style="cursor: pointer">
                          mdi-heart-outline
                        </v-icon>
                      </template>
                      <span>点赞</span>
                    </v-tooltip>
                    <v-tooltip bottom>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="red" v-bind="attrs" v-on="on"
                                v-if="!item.isLiked" @click="cancelLikeComment(item.ID)"
                                style="cursor: pointer">
                          mdi-cards-heart
                        </v-icon>
                      </template>
                      <span>取消点赞</span>
                    </v-tooltip>
                    <v-tooltip bottom v-if="canDelete(item.fromID)">
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon color="primary" v-bind="attrs" v-on="on"
                                @click="deleteComment(item.ID,index)"
                                style="cursor: pointer">
                          mdi-delete
                        </v-icon>
                      </template>
                      <span>删除</span>
                    </v-tooltip>
                  </v-col>
                </v-row>
                <v-row style="margin-top: -15px">
                  <v-col cols="11" class="ml-4" v-if="item.content!==undefined">{{ item.content }}</v-col>
                  <v-col cols="11" class="ml-4" v-if="item.content===undefined">该评论已被删除</v-col>
                </v-row>
              </v-card>
              <v-pagination
                v-model="commentPage"
                :length=commentPaginationLen
                :total-visible="6"
                @input="queryComments"
                style="margin-top: 20px"
              ></v-pagination>
            </div>
            <div v-if="commentTotal===0">
              <v-row class="justify-center">
                <v-col cols="4">
                  <v-img src="../assets/writeComment.png" alt="Logo" width="250px" height="189px"></v-img>
                </v-col>
              </v-row>
              <v-row class="justify-center text-center">
                <p>暂无评论</p>
              </v-row>
            </div>
          </v-card-text>
        </v-card>
      </template>
    </v-dialog>

    <!-- 对回答和评论进行评论的Dialog -->
    <v-dialog transition="dialog-bottom-transition" v-model="isCommentToDialogOn" width="600px" persistent>
      <v-card>
        <v-toolbar
          color="primary"
          dark
        >评论
        </v-toolbar>
        <v-card-text class="mt-5">
          <v-textarea color="black" label="评论" v-model="commentContent"></v-textarea>
        </v-card-text>
        <v-card-actions class="justify-end">
          <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="submitComment">提交</v-btn>
          <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="closeCommentToDialog">取消
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import MarkdownInput from "@/components/MarkdownInput";

export default {
  name: "Comments",
  props: ['questionID'],
  components: {MarkdownInput},
  data() {
    return {
      app: this.$root.$children[0],
      total: 7,
      isCommentDialogOn: false,
      answerPage: 1,
      answerPageSize: 5,
      answerPaginationLen: 2,
      answer: {},
      answers: [],

      isCommentToDialogOn: false,
      commentTo: '',
      commentContent: '',
      comments: [],
      commentTotal: 0,
      commentPage: 1,
      commentPageSize: 5,
      commentPaginationLen: 1,

      isModifyAnswerDialogOn: false,
      modifyAnswer: {},
      modifyAnswerIndex: 0,
      modifyAnswerContent: '',
    }
  },
  methods: {

    canDelete(id) {
      return id === this.$store.state.userDetails.ID;
    },

    //修改回答
    receiveModifyAnswerHtml: function (msg) {
      this.modifyAnswerContent = msg;
    },

    submitModifyAnswer: function () {
      let path = '/answers/' + this.modifyAnswer.ID;
      this.app.overlay = true;
      this.$axios.put(path, {
        content: this.modifyAnswerContent,
      }).then(resp => {
        if (resp.data.code === 200) {
          this.closeModifyAnswerDialog();
          this.$set(this.answers[this.modifyAnswerIndex], 'content', this.modifyAnswerContent);
          this.modifyAnswerContent = '';
          this.$refs.modifyAnswerMarkdownInput.content = '';
          this.app.message('评论修改成功', 'success');
        } else {
          this.app.message('修改失败', 'warning');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
      this.app.overlay = false;
    },
    openModifyAnswerDialog: function (item, index) {
      this.isModifyAnswerDialogOn = true;
      this.modifyAnswer = item;
      this.modifyAnswerIndex = index;
    },
    closeModifyAnswerDialog: function () {
      this.isModifyAnswerDialogOn = false;
    },


    getTime: function (date) {
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

    openCommentDialog(item) {
      this.answer = item;
      this.isCommentDialogOn = true;
      this.queryComments();
      console.log(this.comments);
      console.log(this.commentTotal !== 0)
    },

    deleteAnswer(id) {
      let path = '/answers/' + id;
      this.app.overlay = true;
      this.$axios.delete(path, {}).then(resp => {
        console.log(resp);
        if (resp.data.code === 200) {
          this.queryAnswers()
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
      this.app.overlay = false;
    },

    queryAnswers: function () {
      let path = '/questions/' + this.questionID + '/answers';
      this.$axios.get(path, {
        params: {
          pageNum: this.answerPage,
          pageSize: this.answerPageSize,
          orderBy: 'created_at asc'
        }
      }).then(resp => {
        if (resp.data.code === 200) {
          let answers = resp.data.data;
          let answersIDs = [];
          let temp = '';
          for (let i = 0; i < answers.length; i++) {
            answersIDs.push(answers[i].ID);
            answers[i].content = '   ' + answers[i].content;
            answers[i].answererNickname = answers[i].answerer.nickname;
            let path = '/answers/' + answers[i].ID + '/likes';
            this.$axios.get(path, {}).then(resp => {
              if (resp.data.code === 200) {
                answers[i].isLiked = resp.data.data;
              } else {
                answers[i].isLiked = false;
              }
            }).catch(() => {
              this.app.message('服务器在忙', 'red')
            })
            delete answers[i].answerer;
          }
          console.log(answers)
          this.answers = answers;
          temp = answersIDs.join(',')
          this.$axios.get('/answers/likes/counts', {
            params: {
              "answer-ids": temp
            }
          }).then(resp => {
            if (resp.data.code === 200) {
              let answerLikesCounts = resp.data.data;
              for (let i = 0; i < answers.length; i++) {
                //answers[i].likesCount = answerLikesCounts[i];
                this.$set(this.answers[i], 'likesCount', answerLikesCounts[i]);
              }
            }
          }).catch(() => {
            console.log("服务器在忙", 'red');
          })
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },

    likeAnswer: function (answerID) {
      let path = '/answers/' + answerID + '/likes';
      this.$axios.post(path, {}).then(resp => {
        console.log(resp);
        if (resp.data.code === 200) {
          this.$set(this.answers, 'isLiked', true);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    cancelLikeAnswer: function (answerID) {
      let path = '/answers/' + answerID + '/likes';
      this.$axios.delete(path, {}).then(resp => {
        console.log(resp);
        if (resp.data.code === 200) {
          this.$set(this.answers, 'isLiked', false);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    openCommentToDialog: function (to_id) {
      this.commentTo = to_id;
      this.isCommentToDialogOn = true;
    },
    closeCommentToDialog: function () {
      this.isCommentToDialogOn = false;
    },

    submitComment: function () {
      if (this.commentContent === '') {
        this.app.message('评论内容不能为空', 'warning');
        return;
      }
      let path = '/answers/' + this.answer.ID + '/comments';
      this.$axios.post(path, {
        content: this.commentContent,
        to_id: this.commentTo
      }).then(resp => {
        //console.log(resp);
        if (resp.data.code === 200) {
          this.commentContent = '';
          this.queryComments();
          this.closeCommentToDialog();
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })

    },

    queryComments: function () {
      let path = '/answers/' + this.answer.ID + '/comments';
      this.$axios.get(path, {
        params: {
          pageNum: this.commentPage,
          pageSize: this.commentPageSize,
        }
      }).then(resp => {
        if (resp.data.code === 200) {
          this.commentTotal = resp.headers.totalcount;
          this.commentPaginationLen = Math.ceil(this.commentTotal / this.commentPageSize);
          console.log(this.commentPaginationLen);
          let comments = resp.data.data;
          let commentIDs = [];
          for (let i = 0; i < comments.length; i++) {
            commentIDs.push(comments[i].ID);
            comments[i].fromNickname = comments[i].from.nickname;
            comments[i].toNickName = comments[i].to.nickname;
            path = '/comments/' + comments[i].ID + '/likes';
            this.$axios.get(path, {}).then(resp => {
              //console.log(resp);
              if (resp.data.code === 200) {
                comments[i].isLiked = resp.data.data;
              } else {
                comments[i].isLiked = false;
              }
            }).catch(() => {
              this.app.message('服务器在忙', 'red');
            })
            delete comments[i].from;
            delete comments[i].to;
          }
          this.comments = comments;
          // console.log(this.comments);
          this.commentTotal = comments.length
          let temp = commentIDs.join(',');
          path = '/comments/likes/counts';
          this.$axios.get(path, {
            params: {
              "comment-ids": temp
            }
          }).then(resp => {
            // console.log(resp);
            if (resp.data.code === 200) {
              let commentLikesCount = resp.data.data;
              for (let i = 0; i < this.comments.length; i++) {
                this.$set(this.comments[i], 'likesCount', commentLikesCount[i]);
              }
            }
          }).catch(() => {
            this.app.message('服务器在忙', 'red');
          })
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    likeComment: function (id, index) {
      let path = '/comments/' + id + '/likes';
      this.$axios.post(path, {}).then(resp => {
        // console.log(resp);
        if (resp.data.code === 200) {
          this.$set(this.comments[index], 'likesCount', this.comments[index] + 1);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    cancelLikeComment: function (id, index) {
      let path = '/comments/' + id + '/likes';
      this.$axios.post(path, {}).then(resp => {
        console.log(resp);
        if (resp.data.code === 200) {
          this.$set(this.comments[index], 'likesCount', this.comments[index] - 1);
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },

    deleteComment: function (id, index) {
      let path = '/comments/' + id;
      this.app.overlay = true;
      this.$axios.delete(path, {}).then(resp => {
        console.log(resp);
        if (resp.data.code === 200) {
          this.app.message('评论删除成功', 'success');
          this.$set(this.comments[index], 'content', undefined);
          //this.queryComments();
        } else {
          this.app.message('评论删除失败', 'warning');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
      this.app.overlay = false;
    },
  }
}
</script>

<style scoped>

</style>
