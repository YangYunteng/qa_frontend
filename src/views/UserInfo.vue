<template>
  <div>
    <v-card
      elevation="2"
      style="margin: 5vh; padding: 5vh;"
    >
      <div style="text-align: center"><h3>用户 {{this.user.username}} 信息</h3></div><br>
      用户昵称 | {{this.user.nickname}}<br>
      用户地区 | {{this.user.address}}<br>
      用户ID&nbsp;| {{this.user.ID}}<br>
      性别&nbsp;&nbsp;| {{ (this.user.gender===1)?'男':'女'}}<br>
      邮箱&nbsp;&nbsp;| {{ this.user.email}}
    </v-card>
    <v-card style="margin: 5vh 5vh; padding: 1vh 2vh;  background-color: rgba(255,255,255,0.3)" outlined>
      <div style="text-align: center"><h3>最 近 活 动</h3></div><br>
      <div v-for="(o,index) in this.recentActivity" :key="index" style="margin: 1vh 2vh 3vh; padding: 1vh 5vh; text-align: center; background-color: white; border-radius: 5px">
<!--        <span :id="index"></span>-->
        <div>{{ (o.hasOwnProperty('text'))?o.text:setContent(o,index)}}</div>
<!--        <span v-else v-html="o.entity_id"></span>-->
      </div>
      <div class="text-center">
        <v-btn outlined style="margin: 5px"  @click="prevPage">&lt;</v-btn>
        <v-btn outlined style="margin: 5px"  @click="nextPage">&gt;</v-btn>
      </div>
    </v-card>
  </div>
</template>

<script>
export default {
  name: "UserInfo",
  data() {
    return {
      app: this.$root.$children[0],
      user:this.$store.state.userDetails,
      recentActivity:[],
      currPage: 1,
      paginationSize: 5,
    }
  },
  mounted() {
   this.queryRecentActivity();
  },
  methods:{
    nextPage(){
      this.currPage++;
      this.queryRecentActivity();
    },
    prevPage(){
      if (this.currPage===1) {
        this.app.message('已经到头了哦', 'blue');
        return ;
      }
      this.currPage--;
      this.queryRecentActivity();
    },
    setContent(o,index) {
      let s = '';
      switch (o.action) {
        case 'create':
          s = '创建了 '
          break;
        case 'delete':
          s = '删除了 '
          break;
        case 'update':
          s = '修改了 '
          break;
        default:
          s = o.action;
          break;
      }

      let t = '';
      let content = '';
      console.log(index);
      switch (o.entity) {
        case 'question':
          t = '问题 '
          content = (o.value) ? o.value+'...' : ""
          break;
        case 'answer':
          t = '回答 '
          content = (o.value) ? o.value+'...' : ""
          break;
        case 'suggestion':
          t = '建议 '
          break;
        case 'comment':
          t = '评论 ';
          content = (o.value.content) ? o.value.content+'...' : ""
          break;
        default:
          t = o.entity;
          break;
      }
      return '在 ' + this.getTime(o.recorded_at) + ' ' + s + t + content;
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

    async queryRecentActivity(){
      await this.$axios.get('/userServer/activity-records', {params:{
          pageNum: this.currPage,
          pageSize: this.paginationSize
      }}).then((resp)=>{
        this.$nextTick(()=> {
          if (resp.data.code === 200 && resp.data.data.length !== 0) {
            this.recentActivity = resp.data.data;
          } else if (resp.data.code === 200 && resp.data.data.length === 0) {
            if (this.currPage!==1) this.currPage--;
            if (this.recentActivity.length === 0)
              this.recentActivity = [{text: '已经到底了哦'}]
            else this.app.message('已经到底了哦', 'blue');
          }
        })
      })
    }
  }
}
</script>

<style scoped>

</style>
