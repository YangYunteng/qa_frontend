<template>
  <v-container>
    <div class="list" id="list" ref="list">
      <ul>
        <li v-for="(item,index) in msglist" :key="index">
          <div v-if="item.me">
            <user :id="item.id" :type="item.type" :content="item.content"></user>
            <v-btn text color="blue" x-small @click="showMapDialogue(item.content)" style="margin-right: 60px; display: flex; flex-direction: row-reverse">
              可视化 &gt;
            </v-btn>
          </div>
          <div v-else>
            <robot :id="item.id" :type="item.type" :content="item.content"></robot>
            <v-btn text color="blue" x-small @click="showSuggestionDialog = true" v-if="$store.state.token!==null">
              提供改进建议 &gt;
            </v-btn>

            <v-btn text color="blue" x-small @click="showSuggestionDialog = true" v-else disabled>登录后可提出建议 &gt;</v-btn>

          </div>
        </li>
      </ul>
    </div>
    <div>
      <div class="line"></div>
      <div class="input-send">
        <v-text-field v-model="text" placeholder="请输入聊天内容..." class="input" @keyup.enter="send"/>
        <v-btn plain type="info" class="send" @click="send">发送</v-btn>
      </div>
    </div>
    <v-dialog
      persistent
      max-width="800px"
      v-model="showSuggestionDialog"
    >
      <template>
        <v-card>
          <v-toolbar
            color="primary"
            dark
          >留下您的建议
          </v-toolbar>
          <v-card-text class="mt-5">
            <v-textarea v-model="suggestion" ref="input" placeholder="你的建议..."></v-textarea>
          </v-card-text>
          <v-card-actions class="justify-end">
            <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="submitSuggestion">提交建议</v-btn>
            <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="cancelAnswerDialog">取消</v-btn>
          </v-card-actions>
        </v-card>
      </template>
    </v-dialog>

    <v-dialog
      persistent
      max-width="800px"
      min-width="600px"
      v-model="showMapDialog"
    >
      <template>
        <v-card>
          <v-toolbar
            color="primary"
            dark
          >可视化
          </v-toolbar>
          <div id="container" style="width:100%; height:100%; overflow:hidden;"></div>
          <relation-graph :question="question"></relation-graph>
        <v-card-actions class="justify-end">
        <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="showMapDialog = false">OK</v-btn>
        </v-card-actions>
        </v-card>
      </template>
    </v-dialog>
  </v-container>

</template>
<script>
import Vue from "vue";
import User from "@/components/QARobot/User";
import Robot from "@/components/QARobot/Robot";
import RelationGraph from "@/components/RelationGraph";

Vue.directive('scroll', {
  inserted(el) {
    el.scrollIntoView()
  }
})

export default {
  name: "QARobot",
  components: { Robot, User, RelationGraph},
  data() {
    return {
      app: this.$root.$children[0],
      text: '',
      msglist: [{
        id: 1,
        type: 1,
        content: '欢迎你！',
        me: false
      }],
      timer: 0,
      showSuggestionDialog: false,
      suggestion: '',
      showMapDialog : false,
      question:  ''
    }
  },
  methods: {
    showMapDialogue(question){
      this.showMapDialog = true;
      this.question = question;
    },

    scroll() {
      let elm = document.getElementById('container');
      elm.scrollTop = elm.scrollHeight;
      console.log(elm.scrollHeight, elm.scrollTop);
    },
    send() {
      if (this.text) {
        this.msglist.push({
          id: this.msglist[this.msglist.length - 1].id + 1,
          type: 1,
          content: this.text,
          me: true
        })

        this.getResponse(this.text)
        this.text = ''
      }
    },
    renderSuggestion() {
      console.log('render QAR')
    },
    submitSuggestion() {
      console.log(this.judgeAnswerCanPost())
      if (!this.judgeAnswerCanPost()) return;
      this.$axios.post('/userServer/suggestions', {
        'content': this.suggestion
      }).then((resp) => {
        console.log(resp);
        if (resp.status === 200) {
          if (resp.data.code === 200 && resp.data.data.object_id.length !== 0) {
            this.app.message('建议提交成功', 'green');
            this.showSuggestionDialog = false;
            this.suggestion = '';
          } else {
            this.app.message('服务器开小差了', 'red');
          }
        } else {
          this.app.message('服务器开小差了', 'red');
        }
      })
    },
    cancelAnswerDialog() {
      this.suggestion = '';
      this.showSuggestionDialog = false;
    },
    judgeAnswerCanPost() {
      console.log(this.suggestion);
      if (this.suggestion.length === 0) {
        this.app.message('建议不能为空', 'red');
        return false;
      }
      return true;
    },
    getResponse(text) {
      this.$axios.get('/userServer/question-answer/' + text, {params: {question: text, limit: 3}}).then((resp) => {
        console.log(resp);
        if (resp.data.code === 200) {
          if (resp.data.data === null) {
            this.msglist.push({
              id: this.msglist[this.msglist.length - 1].id + 1,
              type: 1,
              content: "对不起，我冯启航也无能为力……",
              me: false
            })
          } else {
            let temp = '';
            for (let res of resp.data.data) {
              temp += res.subject + " " + res.predicate + " " + res.objects[0] + ";";
            }
            this.msglist.push({
              id: this.msglist[this.msglist.length - 1].id + 1,
              type: 1,
              content: temp,
              me: false
            })
          }
        }

      })
    }
  }
}
</script>


<style scoped lang="scss">
ul {
  padding: 0;
  margin: 0;
  height: 80%;
}

li {
  list-style: none;

}

.list {
  width: 100%;
  height: 80%;
  margin-bottom: 45px;
}

.bottom {
  width: 100%;
  bottom: 0;
  position: fixed;
}

.line {
  width: 100%;
  height: 1px;
}

.input-send {
  //position: absolute;
  display: inline-flex;
}

.input {
  padding-right: 10px;
  flex: 1;
}

.send {
  //width: 50%;
  height: 30px;
  margin-top: 7px;
  margin-right: 10px;
}


</style>
