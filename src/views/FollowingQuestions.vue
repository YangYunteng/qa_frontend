<template>
  <Questions ref="questions"></Questions>
</template>

<script>
import Questions from "@/components/Questions";
export default {
  name: "FollowingQuestions",
  components: {Questions},
  data(){
    return{
      questions: [{
        ID: 11,
        questionerID: 4,
        questionerNickName: "yyt",
        title: 'Test2 Following',
        content: "<p><strong>Test2问题描述:</strong>yyt不会</p>",
        likes: 1,
        CreatedAt: "0001-01-01T00:00:00Z",
        DeletedAt: null,
        UpdatedAt: "0001-01-01T00:00:00Z",
      }
      ],
    }
  }
}
</script>

<style scoped>

</style>
