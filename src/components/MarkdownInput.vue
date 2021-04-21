<template>
  <div>
    <mavon-editor
      v-model="content"
      ref="md"
      @change="change"
      style="min-height: 300px; margin: 50px;"
    />
    <div style="text-align: center">
      <v-btn @click="submit" style="margin: 20px auto;" elevation="2" color="primary" depressed>提交</v-btn>
    </div>

  </div>
</template>

<script>
import { mavonEditor } from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
export default {
  name: "MarkdownInput",
  components:{mavonEditor},
  data() {
    return {
      app: this.$root.$children[0],
      content:'', // 输入的markdown
      html:'',    // 及时转的html
    }
  },
  methods:{
    // 所有操作都会被解析重新渲染
    change(value, render){
      // render 为 markdown 解析后的结果[html]
      this.html = render;
    },
    // 提交
    submit(){
      console.log(this.content);
      console.log(this.html);
    }
  }
}
</script>

<style scoped>

</style>
