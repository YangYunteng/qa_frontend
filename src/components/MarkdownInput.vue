<template>
  <div>
    <mavon-editor
      v-model="content"
      ref="md"
      @change="change"
      :placeholder="placeholder"
      style="min-height: 300px; margin: 50px;max-height: 300px"
    />
  </div>
</template>

<script>
import {mavonEditor} from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'

export default {
  name: "MarkdownInput",
  components: {mavonEditor},
  data() {
    return {
      app: this.$root.$children[0],
      content: '', // 输入的markdown
      html: '',    // 及时转的html
    }
  },
  methods: {
    // 所有操作都会被解析重新渲染
    change(value, render) {
      // render 为 markdown 解析后的结果[html]
      this.html = render;
      this.$emit('transformHtml', this.html);
    },
    initHtml() {
      console.log(123);
    }

  },
  props: ['placeholder']
}
</script>

<style scoped>

</style>
